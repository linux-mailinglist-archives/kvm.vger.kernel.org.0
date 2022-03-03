Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1833F4CC65A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiCCTnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiCCTnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:43:22 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA2E18CC48;
        Thu,  3 Mar 2022 11:42:04 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o18-20020a05600c4fd200b003826701f847so5361168wmq.4;
        Thu, 03 Mar 2022 11:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u8ACULY4MSILv9Tvcfp9NW6hg6GcIEOYCM26Nr6tK1I=;
        b=e4gNjKJBJ8kN4dgRLDhWfLZ0YdD0l4c+nT4+5XTNuNr7Wy8Cj8P3VGph58odKgQETs
         t9EoghVpVo0/5JHa+kQXg0XSz5EkCbeMrZ1S5fUMBp1BYYqLbFzZCWB/Xrhmm2+nbzGE
         1hhzgnCi/IOHIOfLTkanoI8qGitz+WW9L1J6S8R+kHpfqL+z3bp2Hns+DBD8dts8PuNk
         +7ofzTWzjGeeWXgg7UCa13+uExiwqRDjv0cIC5ch8w/JqakeVVupaS8zO82n8tQc4jaO
         PeZSNSMj3GYngFVnTxVKrxv+ZdtmDtMC8fmGe3EnVaVINFulXfGaXQBF4jx6jxeeANMW
         QLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u8ACULY4MSILv9Tvcfp9NW6hg6GcIEOYCM26Nr6tK1I=;
        b=tNfntjuKDsvRuhfr/QlreDotBySKt3hLf/p37RD2uF4IGy/dTqjmGalmPows3vuEWz
         BnHDWIQ6gxxdIIDDhBmXR5jMdWGf9fTcLumck2cxQsOt7ZRwS/9VD7Hskw021LuKNwIk
         icqcgFuiL2TeTRH/9BG7V4npiW2yIjdkhIUGN/kErJ7WsX1gb8oaS3o+tqQW1Icr3cO2
         6vqr3pEBPCbclXbP23flN1DGmzRaXoAuBXb2IDeN3IzB/QIyRRK6CyZXIeOuCFcMW9tW
         Yif1EOVWlCFqXPBVaYFVT8U+sJVSajSMzHFFyVpSoLnqzrmkWp+xxvkn4EfIk9l1MVY4
         5V2g==
X-Gm-Message-State: AOAM5325mLdPTnhbiz6nRCtsVqrnuTXeJ1IAYmNhFsVBUj1lyZuuE33e
        Jk3YfybtXE1nlSsLv3aoVFw=
X-Google-Smtp-Source: ABdhPJzWjQFoi36vB83HIKYkESY047cVY9Jv8+zvejERlyg4Hc3dG2EMGbm2ONME4dQsu/VC86dnBA==
X-Received: by 2002:a7b:ce84:0:b0:37c:52fe:a3ff with SMTP id q4-20020a7bce84000000b0037c52fea3ffmr4971601wmj.48.1646336499989;
        Thu, 03 Mar 2022 11:41:39 -0800 (PST)
Received: from localhost.localdomain ([102.122.167.77])
        by smtp.gmail.com with ESMTPSA id i15-20020a05600c354f00b00381753c67a8sm2926485wmq.26.2022.03.03.11.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:41:39 -0800 (PST)
From:   hatimmohammed369@gmail.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hatim Muhammed <hatimmohammed369@gmail.com>
Subject: [PATCH 2/2] Fixed (unsigned) uses, instead use (unsigned int)
Date:   Thu,  3 Mar 2022 21:41:32 +0200
Message-Id: <20220303194132.10078-1-hatimmohammed369@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hatim Muhammed <hatimmohammed369@gmail.com>

Signed-off-by: Hatim Muhammed <hatimmohammed369@gmail.com>
---
 virt/kvm/kvm_main.c | 66 ++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58d31da8a2f7..2f155614efbe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -53,7 +53,7 @@
 #include <linux/kthread.h>
 #include <linux/suspend.h>
 
-#include <asm/processor.h>
+#include <linux/processor.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
 
@@ -75,23 +75,23 @@ MODULE_LICENSE("GPL");
 
 /* Architectures should define their poll value according to the halt latency */
 unsigned int halt_poll_ns = KVM_HALT_POLL_NS_DEFAULT;
-module_param(halt_poll_ns, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns);
+module_param(halt_poll_ns, uint, 0644);
 
 /* Default doubles per-vcpu halt_poll_ns. */
 unsigned int halt_poll_ns_grow = 2;
-module_param(halt_poll_ns_grow, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_grow);
+module_param(halt_poll_ns_grow, uint, 0644);
 
 /* The start value to grow halt_poll_ns from */
 unsigned int halt_poll_ns_grow_start = 10000; /* 10us */
-module_param(halt_poll_ns_grow_start, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
+module_param(halt_poll_ns_grow_start, uint, 0644);
 
 /* Default resets per-vcpu halt_poll_ns . */
 unsigned int halt_poll_ns_shrink;
-module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
+module_param(halt_poll_ns_shrink, uint, 0644);
 
 /*
  * Ordering of locks:
@@ -132,7 +132,10 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
  *   passed to a compat task, let the ioctls fail.
  */
 static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
-				unsigned long arg) { return -EINVAL; }
+				unsigned long arg)
+{
+	return -EINVAL;
+}
 
 static int kvm_no_compat_open(struct inode *inode, struct file *file)
 {
@@ -216,7 +219,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(vcpu_put);
 
 /* TODO: merge with kvm_arch_vcpu_should_kick */
-static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
+static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned int req)
 {
 	int mode = kvm_vcpu_exiting_guest_mode(vcpu);
 
@@ -415,7 +418,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 }
 #endif
 
-static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned int id)
 {
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
@@ -2156,7 +2159,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (log->first_page > memslot->npages ||
 	    log->num_pages > memslot->npages - log->first_page ||
 	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
-	    return -EINVAL;
+		return -EINVAL;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
@@ -2171,6 +2174,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	     i++, offset += BITS_PER_LONG) {
 		unsigned long mask = *dirty_bitmap_buffer++;
 		atomic_long_t *p = (atomic_long_t *) &dirty_bitmap[i];
+
 		if (!mask)
 			continue;
 
@@ -2181,7 +2185,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		 * never includes any bits beyond the length of the memslot (if
 		 * the length is not aligned to 64 pages), therefore it is not
 		 * a problem if userspace sets them in log->dirty_bitmap.
-		*/
+		 */
 		if (mask) {
 			flush = true;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
@@ -2477,6 +2481,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
+
 		r = fixup_user_fault(current->mm, addr,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
@@ -2515,7 +2520,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * tail pages of non-compound higher order allocations, which
 	 * would then underflow the refcount when the caller does the
 	 * required put_page. Don't allow those pages here.
-	 */ 
+	 */
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
 
@@ -2904,7 +2909,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+		void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -2933,7 +2938,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -2988,7 +2993,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+		unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3053,6 +3058,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
+
 	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
@@ -3153,8 +3159,8 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
-			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+		const struct kvm_memory_slot *memslot,
+			gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -3454,7 +3460,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
-		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
 out:
@@ -3669,7 +3675,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct file_operations kvm_vcpu_fops = {
+static const struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
@@ -3887,6 +3893,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_RUN: {
 		struct pid *oldpid;
+
 		r = -EINVAL;
 		if (arg)
 			goto out;
@@ -4720,7 +4727,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 }
 #endif
 
-static struct file_operations kvm_vm_fops = {
+static const struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.llseek		= noop_llseek,
@@ -4822,7 +4829,7 @@ static long kvm_dev_ioctl(struct file *filp,
 	return r;
 }
 
-static struct file_operations kvm_chardev_ops = {
+static const struct file_operations kvm_chardev_ops = {
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.llseek		= noop_llseek,
 	KVM_COMPAT(kvm_dev_ioctl),
@@ -5172,9 +5179,8 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		return 0;
 
 	for (i = 0; i < bus->dev_count; i++) {
-		if (bus->range[i].dev == dev) {
+		if (bus->range[i].dev == dev)
 			break;
-		}
 	}
 
 	if (i == bus->dev_count)
@@ -5241,8 +5247,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	 * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	 * avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
@@ -5366,7 +5372,7 @@ static const struct file_operations stat_fops_per_vm = {
 
 static int vm_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -5382,7 +5388,7 @@ static int vm_stat_get(void *_offset, u64 *val)
 
 static int vm_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -5402,7 +5408,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vm_stat_readonly_fops, vm_stat_get, NULL, "%llu\n");
 
 static int vcpu_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -5418,7 +5424,7 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 
 static int vcpu_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -5597,7 +5603,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
  */
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 {
-        return &kvm_running_vcpu;
+	return &kvm_running_vcpu;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -5656,7 +5662,7 @@ static void check_processor_compat(void *data)
 	*c->ret = kvm_arch_check_processor_compat(c->opaque);
 }
 
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+int kvm_init(void *opaque, unsigned int vcpu_size, unsigned int vcpu_align,
 		  struct module *module)
 {
 	struct kvm_cpu_compat_check c;
-- 
2.35.1

