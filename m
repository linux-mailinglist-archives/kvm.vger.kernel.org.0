Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDD32B5C0
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449321AbhCCHTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44688 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1444039AbhCBUtT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 15:49:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122KhLOJ124963;
        Tue, 2 Mar 2021 15:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GgtUo7M6IAF8gKRdGxj4ROOGvmT7f45ORgvxTxyoVdg=;
 b=NvgFfs1SU0GWqsjSeKWooTviuvYZ5ddp0hWxiH87J9j5m7pXj+vsqr++9rJiALrFYsqo
 9YONk1RJJrjLsUE1Zza/NOukAcTkgkWOPQyZagzjAaA7MVlGJPlM1aXFs+4qLuI6taav
 qXxGSU0kM4GG1Cim4Hx8EnQAF3hfYw+ZyhU0pwIKyImPqd7CK17GKVQP9LyzdTf7XUUb
 ZCIU4KHm49aG0u5YxlbDgqbEhQ5cCd/0HSyPvD4KfnbXCc7GdmeDxQskpbxVqVNhtc4B
 V6yjRGq2vFtX5i3N35uOLjGrOArIX/q/SchcRMvHXlgGbck/64L3ksS3tG2gfhxvX4sm og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371vn7r7bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:48:31 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122KlbGf162811;
        Tue, 2 Mar 2021 15:48:30 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371vn7r7bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:48:30 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122KgZad019202;
        Tue, 2 Mar 2021 20:48:29 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3710sqnccy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 20:48:29 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122KmSZD15860192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 20:48:28 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B51528059;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D1428067;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
Received: from amdrome1.watson.ibm.com (unknown [9.2.130.16])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 20:48:28 +0000 (GMT)
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
To:     qemu-devel@nongnu.org
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Jon Grimm <jon.grimm@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [RFC PATCH 02/26] kvm: add support to sync the page encryption state bitmap
Date:   Tue,  2 Mar 2021 15:47:58 -0500
Message-Id: <20210302204822.81901-3-dovmurik@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210302204822.81901-1-dovmurik@linux.vnet.ibm.com>
References: <20210302204822.81901-1-dovmurik@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The SEV VMs have concept of private and shared memory. The private memory
is encrypted with guest-specific key, while shared memory may be encrypted
with hyperivosr key. The KVM_GET_PAGE_ENC_BITMAP can be used to get a
bitmap indicating whether the guest page is private or shared. A private
page must be transmitted using the SEV migration commands.

Add a cpu_physical_memory_sync_encrypted_bitmap() which can be used to get
the page encryption bitmap for a given memory region.

The page encryption bitmap is not exactly same as dirty bitmap. The page
encryption bitmap is a purely a matter of state about the page is encrypted
or not. To avoid some confusion we clone few functions for clarity.

[Dov changes: replace memcrypt-related checkers with confidential guest
support in migration/ram.c and accel/kvm; rename atomic_* to qatomic_*
in include/exec/ram_addr.h]

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
---
 include/exec/ram_addr.h | 197 ++++++++++++++++++++++++++++++++++++++++
 include/exec/ramblock.h |   3 +
 include/exec/ramlist.h  |   3 +-
 accel/kvm/kvm-all.c     |  43 +++++++++
 migration/ram.c         |  17 ++++
 5 files changed, 262 insertions(+), 1 deletion(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 3cb9791df3..aac5b5e393 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -284,6 +284,60 @@ static inline void cpu_physical_memory_set_dirty_flag(ram_addr_t addr,
     set_bit_atomic(offset, blocks->blocks[idx]);
 }
 
+static inline void cpu_physical_memory_set_encrypted_range(ram_addr_t start,
+                                                           ram_addr_t length,
+                                                           unsigned long val)
+{
+    unsigned long page;
+    unsigned long * const *src;
+
+    page = start >> TARGET_PAGE_BITS;
+
+    rcu_read_lock();
+
+    src = qatomic_rcu_read(
+            &ram_list.dirty_memory[DIRTY_MEMORY_ENCRYPTED])->blocks;
+
+    if (length) {
+        unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+        int m = (start) & (BITS_PER_LONG - 1);
+        int n = MIN(length, BITS_PER_LONG - m);
+        unsigned long old_val = qatomic_read(&src[idx][BIT_WORD(offset)]);
+        unsigned long mask;
+
+        mask = (~0UL >> n);
+        mask = mask << m;
+
+        old_val &= ~mask;
+        val &= mask;
+
+        qatomic_xchg(&src[idx][BIT_WORD(offset)], old_val | val);
+        page += n;
+        length -= n;
+    }
+
+    /* remaining bits */
+    if (length) {
+        unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+        int m = (start) & (BITS_PER_LONG - 1);
+        int n = MIN(length, BITS_PER_LONG - m);
+        unsigned long old_val = qatomic_read(&src[idx][BIT_WORD(offset)]);
+        unsigned long mask;
+
+        mask = (~0UL >> n);
+        mask = mask << m;
+
+        old_val &= ~mask;
+        val &= mask;
+
+        qatomic_xchg(&src[idx][BIT_WORD(offset)], old_val | val);
+    }
+
+    rcu_read_unlock();
+}
+
 static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
                                                        ram_addr_t length,
                                                        uint8_t mask)
@@ -335,6 +389,62 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
 }
 
 #if !defined(_WIN32)
+static inline void cpu_physical_memory_set_encrypted_lebitmap(
+                                                        unsigned long *bitmap,
+                                                        ram_addr_t start,
+                                                        ram_addr_t pages)
+{
+    unsigned long i;
+    unsigned long hpratio = getpagesize() / TARGET_PAGE_SIZE;
+    unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
+
+    /* start address is aligned at the start of a word? */
+    if ((((page * BITS_PER_LONG) << TARGET_PAGE_BITS) == start) &&
+        (hpratio == 1)) {
+        unsigned long **blocks[DIRTY_MEMORY_NUM];
+        unsigned long idx;
+        unsigned long offset;
+        long k;
+        long nr = BITS_TO_LONGS(pages);
+
+        idx = (start >> TARGET_PAGE_BITS) / DIRTY_MEMORY_BLOCK_SIZE;
+        offset = BIT_WORD((start >> TARGET_PAGE_BITS) %
+                          DIRTY_MEMORY_BLOCK_SIZE);
+
+        rcu_read_lock();
+
+        for (i = 0; i < DIRTY_MEMORY_NUM; i++) {
+            blocks[i] = qatomic_rcu_read(&ram_list.dirty_memory[i])->blocks;
+        }
+
+        for (k = 0; k < nr; k++) {
+            if (bitmap[k]) {
+                unsigned long temp = leul_to_cpu(bitmap[k]);
+
+                qatomic_xchg(&blocks[DIRTY_MEMORY_ENCRYPTED][idx][offset], temp);
+            }
+
+            if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
+                offset = 0;
+                idx++;
+            }
+        }
+
+        rcu_read_unlock();
+    } else {
+        i = 0;
+        while (pages > 0) {
+            unsigned long len = MIN(pages, BITS_PER_LONG);
+
+            cpu_physical_memory_set_encrypted_range(start, len,
+                            leul_to_cpu(bitmap[i]));
+            start += len;
+            i++;
+            pages -= len;
+        }
+    }
+}
+
 static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                                                           ram_addr_t start,
                                                           ram_addr_t pages)
@@ -438,6 +548,8 @@ static inline void cpu_physical_memory_clear_dirty_range(ram_addr_t start,
     cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_MIGRATION);
     cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_VGA);
     cpu_physical_memory_test_and_clear_dirty(start, length, DIRTY_MEMORY_CODE);
+    cpu_physical_memory_test_and_clear_dirty(start, length,
+                                             DIRTY_MEMORY_ENCRYPTED);
 }
 
 
@@ -513,5 +625,90 @@ uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
 
     return num_dirty;
 }
+
+static inline bool cpu_physical_memory_test_encrypted(ram_addr_t start,
+                                                      ram_addr_t length)
+{
+    unsigned long end, page;
+    bool enc = false;
+    unsigned long * const *src;
+
+    if (length == 0) {
+        return enc;
+    }
+
+    end = TARGET_PAGE_ALIGN(start + length) >> TARGET_PAGE_BITS;
+    page = start >> TARGET_PAGE_BITS;
+
+    rcu_read_lock();
+
+    src = qatomic_rcu_read(
+            &ram_list.dirty_memory[DIRTY_MEMORY_ENCRYPTED])->blocks;
+
+    while (page < end) {
+        unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long offset = page % DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long num = MIN(end - page, DIRTY_MEMORY_BLOCK_SIZE - offset);
+
+        enc |= qatomic_read(&src[idx][BIT_WORD(offset)]);
+        page += num;
+    }
+
+    rcu_read_unlock();
+
+    return enc;
+}
+
+static inline
+void cpu_physical_memory_sync_encrypted_bitmap(RAMBlock *rb,
+                                               ram_addr_t start,
+                                               ram_addr_t length)
+{
+    ram_addr_t addr;
+    unsigned long word = BIT_WORD((start + rb->offset) >> TARGET_PAGE_BITS);
+    unsigned long *dest = rb->encbmap;
+
+    /* start address and length is aligned at the start of a word? */
+    if (((word * BITS_PER_LONG) << TARGET_PAGE_BITS) ==
+         (start + rb->offset) &&
+        !(length & ((BITS_PER_LONG << TARGET_PAGE_BITS) - 1))) {
+        int k;
+        int nr = BITS_TO_LONGS(length >> TARGET_PAGE_BITS);
+        unsigned long * const *src;
+        unsigned long idx = (word * BITS_PER_LONG) / DIRTY_MEMORY_BLOCK_SIZE;
+        unsigned long offset = BIT_WORD((word * BITS_PER_LONG) %
+                                        DIRTY_MEMORY_BLOCK_SIZE);
+        unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
+
+        rcu_read_lock();
+
+        src = qatomic_rcu_read(
+                &ram_list.dirty_memory[DIRTY_MEMORY_ENCRYPTED])->blocks;
+
+        for (k = page; k < page + nr; k++) {
+            unsigned long bits = qatomic_read(&src[idx][offset]);
+            dest[k] = bits;
+
+            if (++offset >= BITS_TO_LONGS(DIRTY_MEMORY_BLOCK_SIZE)) {
+                offset = 0;
+                idx++;
+            }
+        }
+
+        rcu_read_unlock();
+    } else {
+        ram_addr_t offset = rb->offset;
+
+        for (addr = 0; addr < length; addr += TARGET_PAGE_SIZE) {
+            long k = (start + addr) >> TARGET_PAGE_BITS;
+            if (cpu_physical_memory_test_encrypted(start + addr + offset,
+                                                   TARGET_PAGE_SIZE)) {
+                set_bit(k, dest);
+            } else {
+                clear_bit(k, dest);
+            }
+        }
+    }
+}
 #endif
 #endif
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 07d50864d8..bcd7720826 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -59,6 +59,9 @@ struct RAMBlock {
      */
     unsigned long *clear_bmap;
     uint8_t clear_bmap_shift;
+
+    /* bitmap of page encryption state for an encrypted guest */
+    unsigned long *encbmap;
 };
 #endif
 #endif
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index 26704aa3b0..2422e5ce86 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -11,7 +11,8 @@ typedef struct RAMBlockNotifier RAMBlockNotifier;
 #define DIRTY_MEMORY_VGA       0
 #define DIRTY_MEMORY_CODE      1
 #define DIRTY_MEMORY_MIGRATION 2
-#define DIRTY_MEMORY_NUM       3        /* num of dirty bits */
+#define DIRTY_MEMORY_ENCRYPTED 3
+#define DIRTY_MEMORY_NUM       4        /* num of dirty bits */
 
 /* The dirty memory bitmap is split into fixed-size blocks to allow growth
  * under RCU.  The bitmap for a block can be accessed as follows:
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 84c943fcdb..13350c1b9b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -604,6 +604,43 @@ static void kvm_memslot_init_dirty_bitmap(KVMSlot *mem)
     mem->dirty_bmap = g_malloc0(bitmap_size);
 }
 
+/* sync page_enc bitmap */
+static int kvm_sync_page_enc_bitmap(KVMMemoryListener *kml,
+                                    MemoryRegionSection *section,
+                                    KVMSlot *mem)
+{
+    unsigned long size;
+    KVMState *s = kvm_state;
+    struct kvm_page_enc_bitmap e = {};
+    ram_addr_t pages = int128_get64(section->size) / getpagesize();
+    ram_addr_t start = section->offset_within_region +
+                       memory_region_get_ram_addr(section->mr);
+
+    size = ALIGN(((mem->memory_size) >> TARGET_PAGE_BITS), 64) / 8;
+    e.enc_bitmap = g_malloc0(size);
+    e.start_gfn = mem->start_addr >> TARGET_PAGE_BITS;
+    e.num_pages = pages;
+    if (kvm_vm_ioctl(s, KVM_GET_PAGE_ENC_BITMAP, &e) == -1) {
+        DPRINTF("KVM_GET_PAGE_ENC_BITMAP ioctl failed %d\n", errno);
+        g_free(e.enc_bitmap);
+        return 1;
+    }
+
+    cpu_physical_memory_set_encrypted_lebitmap(e.enc_bitmap,
+                                               start, pages);
+
+    g_free(e.enc_bitmap);
+
+    return 0;
+}
+
+static inline bool confidential_guest(void)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+
+    return ms->cgs;
+}
+
 /**
  * kvm_physical_sync_dirty_bitmap - Sync dirty bitmap from kernel space
  *
@@ -659,6 +696,12 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
         slot_offset += slot_size;
         start_addr += slot_size;
         size -= slot_size;
+
+        if (confidential_guest() &&
+            kvm_sync_page_enc_bitmap(kml, section, mem)) {
+            g_free(d.dirty_bitmap);
+            return -1;
+        }
     }
 out:
     return ret;
diff --git a/migration/ram.c b/migration/ram.c
index 72143da0ac..997f90cc5b 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -61,6 +61,7 @@
 #if defined(__linux__)
 #include "qemu/userfaultfd.h"
 #endif /* defined(__linux__) */
+#include "hw/boards.h"
 
 /***********************************************************/
 /* ram save/restore */
@@ -81,6 +82,13 @@
 /* 0x80 is reserved in migration.h start with 0x100 next */
 #define RAM_SAVE_FLAG_COMPRESS_PAGE    0x100
 
+static inline bool memcrypt_enabled(void)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+
+    return ms->cgs;
+}
+
 static inline bool is_zero_range(uint8_t *p, uint64_t size)
 {
     return buffer_is_zero(p, size);
@@ -865,6 +873,9 @@ static void ramblock_sync_dirty_bitmap(RAMState *rs, RAMBlock *rb)
 
     rs->migration_dirty_pages += new_dirty_pages;
     rs->num_dirty_pages_period += new_dirty_pages;
+    if (memcrypt_enabled()) {
+        cpu_physical_memory_sync_encrypted_bitmap(rb, 0, rb->used_length);
+    }
 }
 
 /**
@@ -2174,6 +2185,8 @@ static void ram_save_cleanup(void *opaque)
         block->clear_bmap = NULL;
         g_free(block->bmap);
         block->bmap = NULL;
+        g_free(block->encbmap);
+        block->encbmap = NULL;
     }
 
     xbzrle_cleanup();
@@ -2615,6 +2628,10 @@ static void ram_list_init_bitmaps(void)
             bitmap_set(block->bmap, 0, pages);
             block->clear_bmap_shift = shift;
             block->clear_bmap = bitmap_new(clear_bmap_size(pages, shift));
+            if (memcrypt_enabled()) {
+                block->encbmap = bitmap_new(pages);
+                bitmap_set(block->encbmap, 0, pages);
+            }
         }
     }
 }
-- 
2.20.1

