# **Troubleshooting Disk Space Issues in Linux**

## **Common Storage Issues**

### **1. Disk Space Full**

#### **Symptoms:**

- Error messages indicating that the disk is full.
- Inability to write files or install software.

#### **Troubleshooting Steps:**

**Step 1: Identify Directories or Files Consuming Excessive Disk Space**

- **Check Disk Usage:** Display available disk space:

  ```bash
  df -h
  ```
- **Find Large Files:** Identify large files consuming space:

  ```bash
  sudo du -ah / | sort -rh | head -n 20
  ```
- **Check File Sizes in Root Directory:**

  ```bash
  du -sch /*
  ```
- **Find the Largest Files/Directories:**

  ```bash
  du -Sh | sort -rh | head -5
  ```

  ```bash
  du -a /dir/ | sort -n -r | head -n 20
  ```

  ```bash
  du -sh /home/* | sort -rh | head -n 10
  ```

  ```bash
  du -cks * | sort -rn | head
  ```

  ```bash
  du -cks / | sort -rn | head
  ```
- **Find the Largest File Using `find`**

  ```bash
  find /path/dir/ -type f -printf '%s %p\n' | sort -nr | head -20
  ```
- **Check File Sizes in a Known Directory:**

  ```bash
  ls -lh
  ```

### **2. Disk Read/Write Errors**

#### **Symptoms:**

- Input/output errors when accessing files.
- Slow performance or system hangs during disk operations.

#### **Troubleshooting Steps:**

- **Check Disk Health:**
  ```bash
  sudo smartctl -a /dev/sda
  ```
- **Run Filesystem Check (`fsck`)**
  ```bash
  sudo fsck /dev/sda1
  ```
- **Monitor Disk Activity:**
  ```bash
  iostat
  iotop
  ```

### **3. LVM Issues**

#### **Symptoms:**

- Logical volumes not available or showing incorrect sizes.
- Problems resizing volumes or extending volume groups.

#### **Troubleshooting Steps:**

- **Check LVM Status:**
  ```bash
  lvdisplay
  vgdisplay
  pvdisplay
  ```
- **Resize Volumes:**
  ```bash
  sudo lvextend -L +5G /dev/vgname/lvname
  sudo resize2fs /dev/vgname/lvname
  ```

## **Fixing a Full Disk**

### **Step 2: Delete Unnecessary Files**

- **Delete a Specific File:**
  ```bash
  rm -rf filename.txt
  ```
- **Delete Multiple Files:**
  ```bash
  rm -rf file2.txt work.txt code.txt
  ```
- **Delete All `.txt` Files in a Directory:**
  ```bash
  rm -rf *.txt
  ```
- **Delete Files Older Than 7 Days:**
  ```bash
  find /path/to/search -type f -mtime +7 -exec rm {} \;
  ```

## **Troubleshooting Inodes in Linux**

Inodes store metadata about files, and running out of inodes can prevent new file creation even if disk space is available.

### **1. Check Inode Usage**

```bash
df -i
```

🔹 If `IUse%` is **100%**, your system has run out of inodes.

### **2. Identify Directories with High Inode Usage**

```bash
for i in /*; do echo "$i: $(find "$i" -xdev -type f | wc -l)"; done | sort -nr -k2 | head -10
```

### **3. Count Files in a Directory**

```bash
ls -U | wc -l
```

### **4. Find and Remove Small, Unnecessary Files**

- **Find Files Under 1KB:**

  ```bash
  find /path/to/directory -type f -size -1k
  ```
- **Delete Specific File Types:**

  ```bash
  find /path/to/directory -type f -name "*.log" -delete
  ```

  ```bash
  find /path/to/directory -type f -name "*.tmp" -exec rm -f {} \;
  ```

### **5. Check Filesystem Type and Disk Space**

```bash
df -Th
```

### **6. Remove Empty Directories**

```bash
find /path/to/directory -type d -empty -delete
```

### **7. Check and Repair the Filesystem**

- **Identify the Affected Partition:**
  ```bash
  df -hT
  ```
- **Run `fsck` on an Unmounted Partition:**
  ```bash
  umount /dev/sdX
  fsck -fy /dev/sdX
  ```

  *(Replace `/dev/sdX` with the actual partition.)*

### **8. Prevent Future Inode Exhaustion**

✅ Use filesystems supporting **dynamic inode allocation** (like XFS).
✅ Store small files in **compressed archives**.
✅ Configure **log rotation**.
✅ Regularly monitor inode usage:

```bash
df -i
```

## **Preventive Measures**

1. **Regularly Monitor Disk Space**
   - Use disk monitoring tools and alerts to avoid unexpected full disks.
2. **Implement Log Rotation**
   - Configure log rotation to limit excessive log growth.
3. **Consider Disk Expansion**
   - If disk space frequently runs low, expand storage capacity or resize partitions.

## **Advanced Disk Diagnostics**

- **Top 5 Disk Consumers:**
  ```bash
  topdiskconsumer --limit 5 --path /
  ```
- **Filesystem & Disk Usage Overview:**
  ```bash
  df -hTP /
  ```

Following these best practices ensures smooth operation and prevents critical disk space issues. 🚀
