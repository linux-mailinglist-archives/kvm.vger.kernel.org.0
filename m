Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE622FE5F
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 02:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgG1ANM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 20:13:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgG1ANL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 20:13:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S07iSV098922;
        Tue, 28 Jul 2020 00:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=EHwJgLiBWUs4j5AUKMLo7Lu4A4ReSKShHV6stWxyZDc=;
 b=lbUV1pptvqNzXXXICx1+fXVOW5nXMIg9IVC1o7XX/Wq5+NvWbe8KWeOJd546PNVR/mGn
 eiBzhBssoQXR1UROlX6SJTZaziDtLK8H3komTtDGLQ3h9XZQYM8rpGMdz9DuSlJVvtCW
 oiTKq7Z9U58fvGNkXcpfKimuLBO7L67GHgwHXYzjKA28Qe4hjw5fyf/WDwT5LC50BHE3
 cWh2Z3yZlcc7uP3M7OUbA+M927tj1Bmbvn/6HktGGQ2HjCJp3ttg/XDd/lAFnToTE6yM
 kXVM6PdEuwysNyVnfeqQHoqf5g0XB44lXEag/ZuJmMIJ70pR6sxPUp8wlxcumA39O40Q BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jcgs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 00:13:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S09KJv113691;
        Tue, 28 Jul 2020 00:11:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5rp0y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 00:11:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06S0B0kp020209;
        Tue, 28 Jul 2020 00:11:00 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 17:11:00 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 2/6 v3] KVM: SVM: Fill in conforming svm_x86_ops via macro
Date:   Tue, 28 Jul 2020 00:10:46 +0000
Message-Id: <1595895050-105504-3-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595895050-105504-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=3 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=3 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of some of the svm_x86_ops functions do not have a corresponding
'svm_' prefix. Generate the names using a macro so that the names are
conformant. Fixing the naming will help in better readability and
maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/avic.c   |   4 +-
 arch/x86/kvm/svm/nested.c |   2 +-
 arch/x86/kvm/svm/sev.c    |   6 +-
 arch/x86/kvm/svm/svm.c    | 218 +++++++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.h    |   8 +-
 5 files changed, 120 insertions(+), 118 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa9..619391e 100644
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
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6bceafb..3be6256 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -348,7 +348,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
 
-	svm_flush_tlb(&svm->vcpu);
+	svm_tlb_flush(&svm->vcpu);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5573a97..1ca9f60 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -969,7 +969,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
-int svm_register_enc_region(struct kvm *kvm,
+int svm_mem_enc_register_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1038,8 +1038,8 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-int svm_unregister_enc_region(struct kvm *kvm,
-			      struct kvm_enc_region *range)
+int svm_mem_enc_unregister_region(struct kvm *kvm,
+				  struct kvm_enc_region *range)
 {
 	struct enc_region *region;
 	int ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24755eb..d63181e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -254,7 +254,7 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex("invlpga %1, %0") : : "c"(asid), "a"(addr));
 }
 
-static int get_npt_level(struct kvm_vcpu *vcpu)
+static int svm_get_tdp_level(struct kvm_vcpu *vcpu)
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
 
@@ -1585,7 +1585,7 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu);
+		svm_tlb_flush(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
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
@@ -3023,7 +3023,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static void svm_set_irq(struct kvm_vcpu *vcpu)
+static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
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
 
@@ -3202,7 +3202,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return 0;
 }
 
-void svm_flush_tlb(struct kvm_vcpu *vcpu)
+void svm_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3219,7 +3219,7 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 		svm->asid_generation--;
 }
 
-static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
+static void svm_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3857,7 +3857,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3968,124 +3968,126 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+#define KVM_X86_OP(name) .name = svm_##name
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.hardware_teardown = svm_hardware_teardown,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
-	.has_emulated_msr = svm_has_emulated_msr,
+	KVM_X86_OP(hardware_teardown),
+	KVM_X86_OP(hardware_enable),
+	KVM_X86_OP(hardware_disable),
+	KVM_X86_OP(cpu_has_accelerated_tpr),
+	KVM_X86_OP(has_emulated_msr),
 
-	.vcpu_create = svm_create_vcpu,
-	.vcpu_free = svm_free_vcpu,
-	.vcpu_reset = svm_vcpu_reset,
+	KVM_X86_OP(vcpu_create),
+	KVM_X86_OP(vcpu_free),
+	KVM_X86_OP(vcpu_reset),
 
 	.vm_size = sizeof(struct kvm_svm),
-	.vm_init = svm_vm_init,
-	.vm_destroy = svm_vm_destroy,
-
-	.prepare_guest_switch = svm_prepare_guest_switch,
-	.vcpu_load = svm_vcpu_load,
-	.vcpu_put = svm_vcpu_put,
-	.vcpu_blocking = svm_vcpu_blocking,
-	.vcpu_unblocking = svm_vcpu_unblocking,
-
-	.update_bp_intercept = update_bp_intercept,
-	.get_msr_feature = svm_get_msr_feature,
-	.get_msr = svm_get_msr,
-	.set_msr = svm_set_msr,
-	.get_segment_base = svm_get_segment_base,
-	.get_segment = svm_get_segment,
-	.set_segment = svm_set_segment,
-	.get_cpl = svm_get_cpl,
+	KVM_X86_OP(vm_init),
+	KVM_X86_OP(vm_destroy),
+
+	KVM_X86_OP(prepare_guest_switch),
+	KVM_X86_OP(vcpu_load),
+	KVM_X86_OP(vcpu_put),
+	KVM_X86_OP(vcpu_blocking),
+	KVM_X86_OP(vcpu_unblocking),
+
+	KVM_X86_OP(update_bp_intercept),
+	KVM_X86_OP(get_msr_feature),
+	KVM_X86_OP(get_msr),
+	KVM_X86_OP(set_msr),
+	KVM_X86_OP(get_segment_base),
+	KVM_X86_OP(get_segment),
+	KVM_X86_OP(set_segment),
+	KVM_X86_OP(get_cpl),
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
-	.set_cr0 = svm_set_cr0,
-	.set_cr4 = svm_set_cr4,
-	.set_efer = svm_set_efer,
-	.get_idt = svm_get_idt,
-	.set_idt = svm_set_idt,
-	.get_gdt = svm_get_gdt,
-	.set_gdt = svm_set_gdt,
-	.set_dr7 = svm_set_dr7,
-	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
-	.cache_reg = svm_cache_reg,
-	.get_rflags = svm_get_rflags,
-	.set_rflags = svm_set_rflags,
-
-	.tlb_flush_all = svm_flush_tlb,
-	.tlb_flush_current = svm_flush_tlb,
-	.tlb_flush_gva = svm_flush_tlb_gva,
-	.tlb_flush_guest = svm_flush_tlb,
-
-	.vcpu_run = svm_vcpu_run,
-	.handle_exit = handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	KVM_X86_OP(set_cr0),
+	KVM_X86_OP(set_cr4),
+	KVM_X86_OP(set_efer),
+	KVM_X86_OP(get_idt),
+	KVM_X86_OP(set_idt),
+	KVM_X86_OP(get_gdt),
+	KVM_X86_OP(set_gdt),
+	KVM_X86_OP(set_dr7),
+	KVM_X86_OP(sync_dirty_debug_regs),
+	KVM_X86_OP(cache_reg),
+	KVM_X86_OP(get_rflags),
+	KVM_X86_OP(set_rflags),
+
+	.tlb_flush_all = svm_tlb_flush,
+	.tlb_flush_current = svm_tlb_flush,
+	KVM_X86_OP(tlb_flush_gva),
+	.tlb_flush_guest = svm_tlb_flush,
+
+	KVM_X86_OP(vcpu_run),
+	KVM_X86_OP(handle_exit),
+	KVM_X86_OP(skip_emulated_instruction),
 	.update_emulated_instruction = NULL,
-	.set_interrupt_shadow = svm_set_interrupt_shadow,
-	.get_interrupt_shadow = svm_get_interrupt_shadow,
-	.patch_hypercall = svm_patch_hypercall,
-	.inject_irq = svm_set_irq,
-	.inject_nmi = svm_inject_nmi,
-	.queue_exception = svm_queue_exception,
-	.cancel_injection = svm_cancel_injection,
-	.interrupt_allowed = svm_interrupt_allowed,
-	.nmi_allowed = svm_nmi_allowed,
-	.get_nmi_mask = svm_get_nmi_mask,
-	.set_nmi_mask = svm_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
-	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
-	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
-	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
-	.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
-	.load_eoi_exitmap = svm_load_eoi_exitmap,
-	.hwapic_irr_update = svm_hwapic_irr_update,
-	.hwapic_isr_update = svm_hwapic_isr_update,
+	KVM_X86_OP(set_interrupt_shadow),
+	KVM_X86_OP(get_interrupt_shadow),
+	KVM_X86_OP(patch_hypercall),
+	KVM_X86_OP(inject_irq),
+	KVM_X86_OP(inject_nmi),
+	KVM_X86_OP(queue_exception),
+	KVM_X86_OP(cancel_injection),
+	KVM_X86_OP(interrupt_allowed),
+	KVM_X86_OP(nmi_allowed),
+	KVM_X86_OP(get_nmi_mask),
+	KVM_X86_OP(set_nmi_mask),
+	KVM_X86_OP(enable_nmi_window),
+	KVM_X86_OP(enable_irq_window),
+	KVM_X86_OP(update_cr8_intercept),
+	KVM_X86_OP(set_virtual_apic_mode),
+	KVM_X86_OP(refresh_apicv_exec_ctrl),
+	KVM_X86_OP(check_apicv_inhibit_reasons),
+	KVM_X86_OP(pre_update_apicv_exec_ctrl),
+	KVM_X86_OP(load_eoi_exitmap),
+	KVM_X86_OP(hwapic_irr_update),
+	KVM_X86_OP(hwapic_isr_update),
 	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
-	.apicv_post_state_restore = avic_post_state_restore,
+	.apicv_post_state_restore = svm_avic_post_state_restore,
 
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_tdp_level = get_npt_level,
-	.get_mt_mask = svm_get_mt_mask,
+	KVM_X86_OP(set_tss_addr),
+	KVM_X86_OP(set_identity_map_addr),
+	KVM_X86_OP(get_tdp_level),
+	KVM_X86_OP(get_mt_mask),
 
-	.get_exit_info = svm_get_exit_info,
+	KVM_X86_OP(get_exit_info),
 
-	.cpuid_update = svm_cpuid_update,
+	KVM_X86_OP(cpuid_update),
 
-	.has_wbinvd_exit = svm_has_wbinvd_exit,
+	KVM_X86_OP(has_wbinvd_exit),
 
-	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
+	KVM_X86_OP(write_l1_tsc_offset),
 
-	.load_mmu_pgd = svm_load_mmu_pgd,
+	KVM_X86_OP(load_mmu_pgd),
 
-	.check_intercept = svm_check_intercept,
-	.handle_exit_irqoff = svm_handle_exit_irqoff,
+	KVM_X86_OP(check_intercept),
+	KVM_X86_OP(handle_exit_irqoff),
 
 	.request_immediate_exit = __kvm_request_immediate_exit,
 
-	.sched_in = svm_sched_in,
+	KVM_X86_OP(sched_in),
 
 	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
-	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
-	.update_pi_irte = svm_update_pi_irte,
-	.setup_mce = svm_setup_mce,
+	KVM_X86_OP(dy_apicv_has_pending_interrupt),
+	KVM_X86_OP(update_pi_irte),
+	KVM_X86_OP(setup_mce),
 
-	.smi_allowed = svm_smi_allowed,
-	.pre_enter_smm = svm_pre_enter_smm,
-	.pre_leave_smm = svm_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	KVM_X86_OP(smi_allowed),
+	KVM_X86_OP(pre_enter_smm),
+	KVM_X86_OP(pre_leave_smm),
+	KVM_X86_OP(enable_smi_window),
 
-	.mem_enc_op = svm_mem_enc_op,
-	.mem_enc_register_region = svm_register_enc_region,
-	.mem_enc_unregister_region = svm_unregister_enc_region,
+	KVM_X86_OP(mem_enc_op),
+	KVM_X86_OP(mem_enc_register_region),
+	KVM_X86_OP(mem_enc_unregister_region),
 
-	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+	KVM_X86_OP(need_emulation_on_page_fault),
 
-	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+	KVM_X86_OP(apic_init_signal_blocked),
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00..e2d5029 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -352,7 +352,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-void svm_flush_tlb(struct kvm_vcpu *vcpu);
+void svm_tlb_flush(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
@@ -444,7 +444,7 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
-void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void svm_avic_post_state_restore(struct kvm_vcpu *vcpu);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
@@ -481,9 +481,9 @@ static inline bool svm_sev_enabled(void)
 
 void sev_vm_destroy(struct kvm *kvm);
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
-int svm_register_enc_region(struct kvm *kvm,
+int svm_mem_enc_register_region(struct kvm *kvm,
 			    struct kvm_enc_region *range);
-int svm_unregister_enc_region(struct kvm *kvm,
+int svm_mem_enc_unregister_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
-- 
1.8.3.1

