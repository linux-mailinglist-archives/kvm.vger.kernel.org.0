Return-Path: <kvm+bounces-36010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C6AA16D64
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 979B83A108F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9628D1E102E;
	Mon, 20 Jan 2025 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="PQegUL0p"
X-Original-To: kvm@vger.kernel.org
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69A41B5EBC;
	Mon, 20 Jan 2025 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737379638; cv=none; b=TMHoSQnHeHy27OI0ZQzqhesKcY3imwCESFDCWp+uKRYmoQ1tm0t78z9czeDCKu+t6fcxmCthqZcrLc5OcUuRE+7stAZKDQDpmF+7Sxek8cHAc6gejD8Az7IqXXf/0xWQBGVl5ZxGuJRIvvzo7IBXroELZyCdl6xnN12WNjNvefQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737379638; c=relaxed/simple;
	bh=LlGFl9fLta6DqNgFQzfJrVo/GiZenAF7eZ3EYYcJMTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HAGgheMncTFLPLw7UmqqZjSpIr4huWsbuIpo6IcWr3wR5y0WDSdT8Y+MF7q6CqM+S3oA/0bm3GdBJ6hxrwbAG23AV4olHGMsFIoGgV2XQJK7r/IV6c6W4j6/WuuXWWWGUI4t7Xs2JjIsz1DKEQTcuMBZFFjIL1RoIi/xORNoM+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=PQegUL0p; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Received: from mail01.disroot.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 6B00925BEE;
	Mon, 20 Jan 2025 14:27:12 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id nuqrjkukl3L0; Mon, 20 Jan 2025 14:27:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1737379628; bh=LlGFl9fLta6DqNgFQzfJrVo/GiZenAF7eZ3EYYcJMTY=;
	h=From:To:Cc:Subject:Date;
	b=PQegUL0pfzak20jk6tGMM5cplFbWbK0W4toCb7b80FlHO+tRvnj6z9vCRN7o9AM8c
	 YPvX5QIn9bNRDiW0pcAbALJLXovKyiZd3xTM85EmA/XIfddThOx51tQ2H3D2NNbeNk
	 yzKJ9ErPhoGNPetrKSf0DO+2P7ND7Ex5BUblKHR2TOh95TnCfXXk7D4e5CFAa5r69O
	 KbXiqQzIuUJvNrEq06vvpFMCBILHnPq5q0TH7sg4D1pRORuYbD1VqBhsLVwK+Mi61R
	 H0oHNrV/EFOStG1Sn0iBDihrIE/wdpaA7omHlPCanXFEksmTnHWHWf9iAhhqpIkGHE
	 cMzeA25IMyDsw==
From: Daniel Hejduk <danielhejduk@disroot.org>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Hejduk <danielhejduk@disroot.org>
Subject: [PATCH] KVM: Fixing coding style warnings and errors
Date: Mon, 20 Jan 2025 14:26:37 +0100
Message-ID: <20250120132637.12484-1-danielhejduk@disroot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixing checkpatch warnings and errors in KVM.

Signed-off-by: Daniel Hejduk <danielhejduk@disroot.org>
---
 virt/kvm/eventfd.c     | 21 +++++++++++----------
 virt/kvm/guest_memfd.c |  1 +
 virt/kvm/irqchip.c     | 10 ++++++----
 virt/kvm/kvm_main.c    | 41 +++++++++++++++++++++++------------------
 virt/kvm/vfio.c        |  1 +
 5 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 249ba5b72e9b..34dcef246b2a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -32,7 +32,7 @@
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
-bool __attribute__((weak))
+bool __weak
 kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	return true;
@@ -179,7 +179,7 @@ irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
 	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
 }
 
-int __attribute__((weak)) kvm_arch_set_irq_inatomic(
+int __weak kvm_arch_set_irq_inatomic(
 				struct kvm_kernel_irq_routing_entry *irq,
 				struct kvm *kvm, int irq_source_id,
 				int level,
@@ -192,19 +192,20 @@ int __attribute__((weak)) kvm_arch_set_irq_inatomic(
  * Called with wqh->lock held and interrupts disabled
  */
 static int
-irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
+irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(wait, struct kvm_kernel_irqfd, wait);
 	__poll_t flags = key_to_poll(key);
 	struct kvm_kernel_irq_routing_entry irq;
 	struct kvm *kvm = irqfd->kvm;
-	unsigned seq;
+	unsigned int seq;
 	int idx;
 	int ret = 0;
 
 	if (flags & EPOLLIN) {
 		u64 cnt;
+
 		eventfd_ctx_do_read(irqfd->eventfd, &cnt);
 
 		idx = srcu_read_lock(&kvm->irq_srcu);
@@ -275,24 +276,24 @@ static void irqfd_update(struct kvm *kvm, struct kvm_kernel_irqfd *irqfd)
 }
 
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
-void __attribute__((weak)) kvm_arch_irq_bypass_stop(
+void __weak kvm_arch_irq_bypass_stop(
 				struct irq_bypass_consumer *cons)
 {
 }
 
-void __attribute__((weak)) kvm_arch_irq_bypass_start(
+void __weak kvm_arch_irq_bypass_start(
 				struct irq_bypass_consumer *cons)
 {
 }
 
-int  __attribute__((weak)) kvm_arch_update_irqfd_routing(
+int  __weak kvm_arch_update_irqfd_routing(
 				struct kvm *kvm, unsigned int host_irq,
 				uint32_t guest_irq, bool set)
 {
 	return 0;
 }
 
-bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
+bool __weak kvm_arch_irqfd_route_changed(
 				struct kvm_kernel_irq_routing_entry *old,
 				struct kvm_kernel_irq_routing_entry *new)
 {
@@ -456,7 +457,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return ret;
 }
 
-bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
+bool kvm_irq_has_notifier(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	int gsi, idx;
@@ -487,7 +488,7 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 			kian->irq_acked(kian);
 }
 
-void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	int gsi, idx;
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 47a9f68f7b24..28722b9511fb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -32,6 +32,7 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	kvm_pfn_t pfn = folio_file_pfn(folio, index);
 	gfn_t gfn = slot->base_gfn + index - slot->gmem.pgoff;
 	int rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+
 	if (rc) {
 		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
 				    index, gfn, pfn, rc);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 162d8ed889f2..70feb4113fc6 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -37,7 +37,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
 	return n;
 }
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	struct kvm_irq_routing_table *irq_rt;
 
@@ -85,6 +85,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 
 	while (i--) {
 		int r;
+
 		r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level,
 				   line_status);
 		if (r < 0)
@@ -121,6 +122,7 @@ void kvm_free_irq_routing(struct kvm *kvm)
 	/* Called only during vm destruction. Nobody can use the pointer
 	   at this stage */
 	struct kvm_irq_routing_table *rt = rcu_access_pointer(kvm->irq_routing);
+
 	free_irq_routing_table(rt);
 }
 
@@ -156,7 +158,7 @@ static int setup_routing_entry(struct kvm *kvm,
 	return 0;
 }
 
-void __attribute__((weak)) kvm_arch_irq_routing_update(struct kvm *kvm)
+void __weak kvm_arch_irq_routing_update(struct kvm *kvm)
 {
 }
 
@@ -167,8 +169,8 @@ bool __weak kvm_arch_can_set_irq_routing(struct kvm *kvm)
 
 int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *ue,
-			unsigned nr,
-			unsigned flags)
+			unsigned int nr,
+			unsigned int flags)
 {
 	struct kvm_irq_routing_table *new, *old;
 	struct kvm_kernel_irq_routing_entry *e;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..8841c808a836 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -50,7 +50,7 @@
 #include <linux/kthread.h>
 #include <linux/suspend.h>
 
-#include <asm/processor.h>
+#include <linux/processor.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
 
@@ -185,7 +185,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(vcpu_put);
 
 /* TODO: merge with kvm_arch_vcpu_should_kick */
-static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
+static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned int req)
 {
 	int mode = kvm_vcpu_exiting_guest_mode(vcpu);
 
@@ -440,7 +440,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 }
 #endif
 
-static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned int id)
 {
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
@@ -1661,6 +1661,7 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 
 	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
 		int change = (new_flags & KVM_MEM_LOG_DIRTY_PAGES) ? 1 : -1;
+
 		atomic_set(&kvm->nr_memslots_dirty_logging,
 			   atomic_read(&kvm->nr_memslots_dirty_logging) + change);
 	}
@@ -2296,7 +2297,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
    if (log->first_page > memslot->npages ||
 	    log->num_pages > memslot->npages - log->first_page ||
 	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
-	    return -EINVAL;
+	return -EINVAL;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
@@ -2311,6 +2312,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	     i++, offset += BITS_PER_LONG) {
 		unsigned long mask = *dirty_bitmap_buffer++;
 		atomic_long_t *p = (atomic_long_t *) &dirty_bitmap[i];
+
 		if (!mask)
 			continue;
 
@@ -2875,6 +2877,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
+
 		r = fixup_user_fault(current->mm, kfp->hva,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
@@ -3172,7 +3175,7 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
 
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+				   void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -3205,7 +3208,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -3263,7 +3266,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
 int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
-		         unsigned long len)
+			 unsigned long len)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int seg;
@@ -3328,6 +3331,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
+
 	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
@@ -3429,7 +3433,7 @@ EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
-		 	     gfn_t gfn)
+			     gfn_t gfn)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -3752,7 +3756,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
-		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
 out:
@@ -4310,6 +4314,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_RUN: {
 		struct pid *oldpid;
+
 		r = -EINVAL;
 		if (arg)
 			goto out;
@@ -4859,7 +4864,7 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
-int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+int __weak kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
 	return -EINVAL;
@@ -5941,8 +5946,8 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
-        * is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
-        * avoids the race between open and the removal of the debugfs directory.
+	* is still valid when kvm_destroy_vm is called.  kvm_get_kvm_safe
+	* avoids the race between open and the removal of the debugfs directory.
 	 */
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
@@ -6062,7 +6067,7 @@ static const struct file_operations stat_fops_per_vm = {
 
 static int vm_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -6078,7 +6083,7 @@ static int vm_stat_get(void *_offset, u64 *val)
 
 static int vm_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -6098,7 +6103,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vm_stat_readonly_fops, vm_stat_get, NULL, "%llu\n");
 
 static int vcpu_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
 
@@ -6114,7 +6119,7 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 
 static int vcpu_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 
 	if (val)
@@ -6274,7 +6279,7 @@ EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
  */
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 {
-        return &kvm_running_vcpu;
+	return &kvm_running_vcpu;
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -6321,7 +6326,7 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
+int kvm_init(unsigned int vcpu_size, unsigned int vcpu_align, struct module *module)
 {
 	int r;
 	int cpu;
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 196a102e34fb..b36e203ef78b 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -190,6 +190,7 @@ static int kvm_vfio_file_del(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_file *kvf;
+
 	CLASS(fd, f)(fd);
 	int ret;
 
-- 
2.43.0


