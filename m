Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942F519AD51
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 16:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732901AbgDAODQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 10:03:16 -0400
Received: from mail-wr1-f74.google.com ([209.85.221.74]:56589 "EHLO
        mail-wr1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732843AbgDAODQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 10:03:16 -0400
Received: by mail-wr1-f74.google.com with SMTP id w12so14581080wrl.23
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RNlyOyyI+iDwlolb7pJpaxUUdy3zyUpQyBfu38tGvPM=;
        b=vZtoXntumcdQh2rFxP4pdzt/3hOC88omg5zB+2DbEAjSZ3pVshACbEjhd6ZlRBnOQG
         KyCS/19w+XwA6o3rL+zd1ZVtQJp7lBwT2xLbG6Md96O9UU5fS7SuA7ki463KdLj5tTj5
         rqWfEWEXW+uf42ffGEKQ3Yto+VkIgAlfzWCOkTddQ9Gqv0KCyM/0r8VBRxS0UaEXbF3E
         U0oCCfWLQGdh2BoiM5F73MQ/iduE8dF9Cr2D5BsUUlcej2D35B08pTYAhu1Ct1ga4tSI
         t1F0pHsbRXwcmcyzukSnEZGrtSY+/HXa0Clrvdpoy+MUMOeNqHPHrzATOWvkcC188Lcw
         /O6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RNlyOyyI+iDwlolb7pJpaxUUdy3zyUpQyBfu38tGvPM=;
        b=khe4LfRmz48+GOUkJQ/2X7x70exiPdP2umdstk+thEdgmZXUE0oXEpVySObhoKfk7y
         mzv8N8VIXd1rBFg6ljqPZgdoqhUg338AdjvYFBKDbjl0uOf0Ad32x7kbbEo2O2Sx1a+I
         gF/qFUVSA37JuwI2sJy/K6rjVGXu3v4/AQDoRmArp6QATJ4aPIYRkJNCuiofh0dr4Y46
         UG9943aZ00yaGENg47yXIbM8m/Wa45eQTZFfAdssp+pCMi+1mOW2J/q0LU9/1JNPs6s2
         YXXGRMgKPwk08e0fAdmbH7B4L14oB55bedQtJD01NFrJen3gH4NK5VyHWPE0nnNGGPL7
         18aA==
X-Gm-Message-State: ANhLgQ0Z5w8DmJ4FE4zqt9FJyJYGlGRWY4ZX3yiXfQ1ZetSxtqp6RGmO
        PZQVptGhQjz27YD4OOSEvA2PbGLpIg==
X-Google-Smtp-Source: ADFU+vutiq7Y+aqFIGo4/ZvNBTjU0X6gU1aG6CNXLmHGSj0SkssqD/jojO8Ka3Q/mjh+BeUzhZ8yJCa4iw==
X-Received: by 2002:a5d:6742:: with SMTP id l2mr27528686wrw.124.1585749793647;
 Wed, 01 Apr 2020 07:03:13 -0700 (PDT)
Date:   Wed,  1 Apr 2020 15:03:10 +0100
Message-Id: <20200401140310.29701-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: [PATCH] KVM: Fix spelling in code comments
From:   Fuad Tabba <tabba@google.com>
To:     maz@kernel.org
Cc:     catalin.marinas@arm.com, will@kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, trivial@kernel.org, jeffv@google.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix spelling and typos (e.g., repeated words) in comments.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/guest.c        | 4 ++--
 arch/arm64/kvm/reset.c        | 6 +++---
 arch/arm64/kvm/sys_regs.c     | 6 +++---
 virt/kvm/arm/arm.c            | 6 +++---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
 virt/kvm/arm/mmio.c           | 2 +-
 virt/kvm/arm/mmu.c            | 6 +++---
 virt/kvm/arm/psci.c           | 6 +++---
 virt/kvm/arm/vgic/vgic-v3.c   | 2 +-
 virt/kvm/coalesced_mmio.c     | 2 +-
 virt/kvm/eventfd.c            | 2 +-
 virt/kvm/kvm_main.c           | 2 +-
 12 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2bd92301d32f..0eb9ec63dc88 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -261,7 +261,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	/*
 	 * Vector lengths supported by the host can't currently be
 	 * hidden from the guest individually: instead we can only set a
-	 * maxmium via ZCR_EL2.LEN.  So, make sure the available vector
+	 * maximum via ZCR_EL2.LEN.  So, make sure the available vector
 	 * lengths match the set requested exactly up to the requested
 	 * maximum:
 	 */
@@ -331,7 +331,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	unsigned int reg_num;
 
 	unsigned int reqoffset, reqlen; /* User-requested offset and length */
-	unsigned int maxlen; /* Maxmimum permitted length */
+	unsigned int maxlen; /* Maximum permitted length */
 
 	size_t sve_state_size;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 30b7ea680f66..658f3a79617b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -163,7 +163,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	vl = vcpu->arch.sve_max_vl;
 
 	/*
-	 * Resposibility for these properties is shared between
+	 * Responsibility for these properties is shared between
 	 * kvm_arm_init_arch_resources(), kvm_vcpu_enable_sve() and
 	 * set_sve_vls().  Double-check here just to be sure:
 	 */
@@ -249,7 +249,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  * ioctl or as part of handling a request issued by another VCPU in the PSCI
  * handling code.  In the first case, the VCPU will not be loaded, and in the
  * second case the VCPU will be loaded.  Because this function operates purely
- * on the memory-backed valus of system registers, we want to do a full put if
+ * on the memory-backed values of system registers, we want to do a full put if
  * we were loaded (handling a request) and load the values back at the end of
  * the function.  Otherwise we leave the state alone.  In both cases, we
  * disable preemption around the vcpu reset as we would otherwise race with
@@ -357,7 +357,7 @@ void kvm_set_ipa_limit(void)
 	 *
 	 * So clamp the ipa limit further down to limit the number of levels.
 	 * Since we can concatenate upto 16 tables at entry level, we could
-	 * go upto 4bits above the maximum VA addressible with the current
+	 * go upto 4bits above the maximum VA addressable with the current
 	 * number of levels.
 	 */
 	va_max = PGDIR_SHIFT + PAGE_SHIFT - 3;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 090f46d3add1..ad908793e814 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -35,7 +35,7 @@
 #include "trace.h"
 
 /*
- * All of this file is extremly similar to the ARM coproc.c, but the
+ * All of this file is extremely similar to the ARM coproc.c, but the
  * types are different. My gut feeling is that it should be pretty
  * easy to merge, but that would be an ABI breakage -- again. VFP
  * would also need to be abstracted.
@@ -119,8 +119,8 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	 * entry to the guest but are only restored on vcpu_load.
 	 *
 	 * Note that MPIDR_EL1 for the guest is set by KVM via VMPIDR_EL2 but
-	 * should never be listed below, because the the MPIDR should only be
-	 * set once, before running the VCPU, and never changed later.
+	 * should never be listed below, because the MPIDR should only be set
+	 * once, before running the VCPU, and never changed later.
 	 */
 	switch (reg) {
 	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index eda7b624eab8..1a2ba13aaf52 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -455,9 +455,9 @@ void force_vm_exit(const cpumask_t *mask)
  *
  * The hardware supports a limited set of values with the value zero reserved
  * for the host, so we check if an assigned value belongs to a previous
- * generation, which which requires us to assign a new value. If we're the
- * first to use a VMID for the new generation, we must flush necessary caches
- * and TLBs on all CPUs.
+ * generation, which requires us to assign a new value. If we're the first to
+ * use a VMID for the new generation, we must flush necessary caches and TLBs
+ * on all CPUs.
  */
 static bool need_new_vmid_gen(struct kvm_vmid *vmid)
 {
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index ccf1fde9836c..1b0084e3d0c4 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -579,7 +579,7 @@ static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
 
 /*
  * The priority value is independent of any of the BPR values, so we
- * normalize it using the minumal BPR value. This guarantees that no
+ * normalize it using the minimal BPR value. This guarantees that no
  * matter what the guest does with its BPR, we can always set/get the
  * same value of a priority.
  */
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index aedfcff99ac5..4e0366759726 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -131,7 +131,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
-	 * voluntered to do so, and bail out otherwise.
+	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 19c961ac4e3c..b9940523e767 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -784,7 +784,7 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	/*
-	 * This assumes that we we have enough space below the idmap
+	 * This assumes that we have enough space below the idmap
 	 * page to allocate our VAs. If not, the check below will
 	 * kick. A potential alternative would be to detect that
 	 * overflow and switch to an allocation above the idmap.
@@ -964,7 +964,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
  * stage2_unmap_vm - Unmap Stage-2 RAM mappings
  * @kvm: The struct kvm pointer
  *
- * Go through the memregions and unmap any reguler RAM
+ * Go through the memregions and unmap any regular RAM
  * backing memory already mapped to the VM.
  */
 void stage2_unmap_vm(struct kvm *kvm)
@@ -2257,7 +2257,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	/*
 	 * At this point memslot has been committed and there is an
-	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
+	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
 	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 17e2bdd4b76f..0cd5feebe86d 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -95,7 +95,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	/*
 	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
-	 * the general puspose registers are undefined upon CPU_ON.
+	 * the general purpose registers are undefined upon CPU_ON.
 	 */
 	reset_state->r0 = smccc_get_arg3(source_vcpu);
 
@@ -231,10 +231,10 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	case PSCI_0_2_FN_SYSTEM_OFF:
 		kvm_psci_system_off(vcpu);
 		/*
-		 * We should'nt be going back to guest VCPU after
+		 * We shouldn't be going back to guest VCPU after
 		 * receiving SYSTEM_OFF request.
 		 *
-		 * If user space accidently/deliberately resumes
+		 * If user space accidentally/deliberately resumes
 		 * guest VCPU after SYSTEM_OFF request then guest
 		 * VCPU should see internal failure from PSCI return
 		 * value. To achieve this, we preload r0 (or x0) with
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 1bc09b523486..7dc948bc1c71 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -585,7 +585,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	int ret;
 
 	/*
-	 * The ListRegs field is 5 bits, but there is a architectural
+	 * The ListRegs field is 5 bits, but there is an architectural
 	 * maximum of 16 list registers. Just ignore bit 4...
 	 */
 	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 00c747dbc82e..e2c197fd4f9d 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -119,7 +119,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 
 	/*
 	 * We're using this spinlock to sync access to the coalesced ring.
-	 * The list doesn't need it's own lock since device registration and
+	 * The list doesn't need its own lock since device registration and
 	 * unregistration should only happen when kvm->slots_lock is held.
 	 */
 	spin_lock_init(&kvm->ring_lock);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 67b6fc153e9c..e586d1395c28 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -116,7 +116,7 @@ irqfd_shutdown(struct work_struct *work)
 	struct kvm *kvm = irqfd->kvm;
 	u64 cnt;
 
-	/* Make sure irqfd has been initalized in assign path. */
+	/* Make sure irqfd has been initialized in assign path. */
 	synchronize_srcu(&kvm->irq_srcu);
 
 	/*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..c9dce733851d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2593,7 +2593,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
  *
  *  (a) VCPU which has not done pl-exit or cpu relax intercepted recently
  *  (preempted lock holder), indicated by @in_spin_loop.
- *  Set at the beiginning and cleared at the end of interception/PLE handler.
+ *  Set at the beginning and cleared at the end of interception/PLE handler.
  *
  *  (b) VCPU which has done pl-exit/ cpu relax intercepted but did not get
  *  chance last time (mostly it has become eligible now since we have probably
-- 
2.26.0.rc2.310.g2932bb562d-goog

