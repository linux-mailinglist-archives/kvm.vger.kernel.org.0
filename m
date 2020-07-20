Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD552227285
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 00:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgGTWzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 18:55:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGTWzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 18:55:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KMkU3Y183178;
        Mon, 20 Jul 2020 22:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=lAMDmMSPe03TMVD16HrjbUC1k3xBR2s09sagwjo/1zo=;
 b=KspMPLYcXm9yrjGUvFLOwk1kRULFpfsXjHgfiY1TVgQ5vDCiSKAwCUukWW1KWGnL9+xh
 GLaX1tGLgTThDQmYRV6hgCk/sktMkbY+6lic8sV11sPiTNlC2lKd9abAlJLaotjc6TA6
 l/vLYwYvb5RYdwH0hObpJJBGcfUYpCcnWWyhRlukhtw2pWA6WW3b2DOUR/W9yiZ/VYlJ
 JgrimEmxZRUT/6iMCKriKjE0zgpXfdT2j8fhFmtWyH+mqmftzLxNoHIoEnqse38pjT8X
 8TuH/s9tt71F1jOJfNCPBgOheT2b/1/PwyTTZp95OtEc9u48N81AY7n6XF3YTw8un6A4 LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgr9rxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 22:55:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KMmxid120275;
        Mon, 20 Jul 2020 22:53:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32djyx4vt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 22:53:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06KMmoP3007303;
        Mon, 20 Jul 2020 22:48:50 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 15:48:49 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: [PATCH] KVM: x86: Fix names of implemented kvm_x86_ops in VMX and SVM modules
Date:   Mon, 20 Jul 2020 18:07:28 -0400
Message-Id: <20200720220728.11140-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200720220728.11140-1-krish.sadhukhan@oracle.com>
References: <20200720220728.11140-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=3 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=3 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the names do not have a corresponding 'vmx_' or 'svm_' prefix. Also,
the order of the words in some of the names is not the same as that in the
kvm_x86_ops structure. Fixing the naming will help in better readability of
the code and maintenance.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/avic.c   |  4 +--
 arch/x86/kvm/svm/svm.c    | 46 ++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h    |  2 +-
 arch/x86/kvm/vmx/nested.c |  4 +--
 arch/x86/kvm/vmx/vmx.c    | 56 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h    |  4 +--
 6 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa98682f..619391edced5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -579,7 +579,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-void avic_post_state_restore(struct kvm_vcpu *vcpu)
+void svm_avic_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (avic_handle_apic_id_update(vcpu) != 0)
 		return;
@@ -660,7 +660,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * we need to check and update the AVIC logical APIC ID table
 		 * accordingly before re-activating.
 		 */
-		avic_post_state_restore(vcpu);
+		svm_avic_post_state_restore(vcpu);
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..471c648151bc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -254,7 +254,7 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex("invlpga %1, %0") : : "c"(asid), "a"(addr));
 }
 
-static int get_npt_level(struct kvm_vcpu *vcpu)
+static int svm_get_npt_level(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	return PT64_ROOT_4LEVEL;
@@ -312,7 +312,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -351,7 +351,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		(void)skip_emulated_instruction(&svm->vcpu);
+		(void)svm_skip_emulated_instruction(&svm->vcpu);
 		rip = kvm_rip_read(&svm->vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
@@ -1153,7 +1153,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
-static int svm_create_vcpu(struct kvm_vcpu *vcpu)
+static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *page;
@@ -1232,7 +1232,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
 }
 
-static void svm_free_vcpu(struct kvm_vcpu *vcpu)
+static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1627,7 +1627,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
-static void update_bp_intercept(struct kvm_vcpu *vcpu)
+static void svm_update_bp_intercept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -2143,7 +2143,7 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (!skip_emulated_instruction(&svm->vcpu))
+		if (!svm_skip_emulated_instruction(&svm->vcpu))
 			return 0;
 	}
 
@@ -2909,7 +2909,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 	*info2 = control->exit_info_2;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -3036,7 +3036,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3145,7 +3145,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !svm_interrupt_blocked(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3169,7 +3169,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3857,7 +3857,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3975,8 +3975,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
-	.vcpu_create = svm_create_vcpu,
-	.vcpu_free = svm_free_vcpu,
+	.vcpu_create = svm_vcpu_create,
+	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
 	.vm_size = sizeof(struct kvm_svm),
@@ -3989,7 +3989,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
 
-	.update_bp_intercept = update_bp_intercept,
+	.update_bp_intercept = svm_update_bp_intercept,
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
@@ -4017,8 +4017,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.tlb_flush_guest = svm_flush_tlb,
 
 	.run = svm_vcpu_run,
-	.handle_exit = handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.handle_exit = svm_handle_exit,
+	.skip_emulated_instruction = svm_skip_emulated_instruction,
 	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
@@ -4031,9 +4031,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nmi_allowed = svm_nmi_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
 	.set_nmi_mask = svm_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
+	.enable_nmi_window = svm_enable_nmi_window,
+	.enable_irq_window = svm_enable_irq_window,
+	.update_cr8_intercept = svm_update_cr8_intercept,
 	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
@@ -4042,11 +4042,11 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
 	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
-	.apicv_post_state_restore = avic_post_state_restore,
+	.apicv_post_state_restore = svm_avic_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_tdp_level = get_npt_level,
+	.get_tdp_level = svm_get_npt_level,
 	.get_mt_mask = svm_get_mt_mask,
 
 	.get_exit_info = svm_get_exit_info,
@@ -4077,7 +4077,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.smi_allowed = svm_smi_allowed,
 	.pre_enter_smm = svm_pre_enter_smm,
 	.pre_leave_smm = svm_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	.enable_smi_window = svm_enable_smi_window,
 
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..ef12288ccc88 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -444,7 +444,7 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm);
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
-void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void svm_avic_post_state_restore(struct kvm_vcpu *vcpu);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d4a4cec034d0..46838c4ba09b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2514,7 +2514,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bitwise-or of what L1 wants to trap for L2, and what we want to
 	 * trap. Note that CR0.TS also needs updating - we do this later.
 	 */
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 	vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 
@@ -3016,7 +3016,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
-	vmx_prepare_switch_to_guest(vcpu);
+	vmx_prepare_guest_switch(vcpu);
 
 	/*
 	 * Induce a consistency check VMExit by clearing bit 1 in GUEST_RFLAGS,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13745f2a5ecd..bad91bef041c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -617,7 +617,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool report_flexpriority(void)
+static inline bool vmx_report_flexpriority(void)
 {
 	return flexpriority_enabled;
 }
@@ -760,7 +760,7 @@ static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 	return *p;
 }
 
-void update_exception_bitmap(struct kvm_vcpu *vcpu)
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
 
@@ -1122,7 +1122,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
-void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs_host_state *host_state;
@@ -2314,7 +2314,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int hardware_enable(void)
+static int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2363,7 +2363,7 @@ static void kvm_cpu_vmxoff(void)
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 
-static void hardware_disable(void)
+static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 	kvm_cpu_vmxoff();
@@ -2769,7 +2769,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
 			(vmcs_readl(CR4_READ_SHADOW) & X86_CR4_VME));
 
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_pmode_seg(vcpu, VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
 	fix_pmode_seg(vcpu, VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
@@ -2849,7 +2849,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmcs_writel(GUEST_RFLAGS, flags);
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_rmode_seg(VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
 	fix_rmode_seg(VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
@@ -4445,23 +4445,23 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_set_cr4(vcpu, 0);
 	vmx_set_efer(vcpu, 0);
 
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	vpid_sync_context(vmx->vpid);
 	if (init_event)
 		vmx_clear_hlt(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_INTR_WINDOW_EXITING);
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	if (!enable_vnmi ||
 	    vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & GUEST_INTR_STATE_STI) {
-		enable_irq_window(vcpu);
+		vmx_enable_irq_window(vcpu);
 		return;
 	}
 
@@ -6170,7 +6170,7 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6834,7 +6834,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_fastpath;
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6845,7 +6845,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
@@ -7799,7 +7799,7 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
@@ -7824,7 +7824,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+static void vmx_hardware_teardown(void)
 {
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -7841,25 +7841,25 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.hardware_unsetup = hardware_unsetup,
+	.hardware_unsetup = vmx_hardware_teardown,
 
-	.hardware_enable = hardware_enable,
-	.hardware_disable = hardware_disable,
-	.cpu_has_accelerated_tpr = report_flexpriority,
+	.hardware_enable = vmx_hardware_enable,
+	.hardware_disable = vmx_hardware_disable,
+	.cpu_has_accelerated_tpr = vmx_report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
-	.vcpu_create = vmx_create_vcpu,
-	.vcpu_free = vmx_free_vcpu,
+	.vcpu_create = vmx_vcpu_create,
+	.vcpu_free = vmx_vcpu_free,
 	.vcpu_reset = vmx_vcpu_reset,
 
-	.prepare_guest_switch = vmx_prepare_switch_to_guest,
+	.prepare_guest_switch = vmx_prepare_guest_switch,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
-	.update_bp_intercept = update_exception_bitmap,
+	.update_bp_intercept = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
@@ -7901,9 +7901,9 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
+	.enable_nmi_window = vmx_enable_nmi_window,
+	.enable_irq_window = vmx_enable_irq_window,
+	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
@@ -7963,7 +7963,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.smi_allowed = vmx_smi_allowed,
 	.pre_enter_smm = vmx_pre_enter_smm,
 	.pre_leave_smm = vmx_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	.enable_smi_window = vmx_enable_smi_window,
 
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 639798e4a6ca..3dcc80ad827e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,7 +325,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
-void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
@@ -342,7 +342,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
-void update_exception_bitmap(struct kvm_vcpu *vcpu);
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
-- 
2.20.1

