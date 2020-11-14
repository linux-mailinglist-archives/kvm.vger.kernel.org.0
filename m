Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78D32B2AA6
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgKNBu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 20:50:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44708 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKNBu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 20:50:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1o7O8171657;
        Sat, 14 Nov 2020 01:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Je/fMNKSXxa8BJPNC8SEGTwmup/U77b+DQauDhsM0As=;
 b=rZlQdD4a40ntVLKDZtQeUeBJasIgct83CTYOL7hB1Yy5CpDHhn1nR148vyZSrudOtvGR
 wIKn0X/QP7e3gcIYquq6L95eeI18WHaQ5/6d0jy5+J3MyKHdm0SzjMPCPJGGptkOckLl
 UfGCFc7Aq7TdP2LE7AU/ukRagtw4KEjsNaqkLe9We9n4h0IkqE6xAJJcSvcmr5f5/nDv
 Cv1NDTlCEEwkw5Gg5Tp0ReXmKRrEZJj6kDUgUPJeAR5eMZn7SKfuu70u4xM0U1ETlJ4Q
 SnfyyMyBkL4Twvg7vALgt4+3aQhI6WJBtgw2Tm1FXQEVPyenLE4943mdHGx2CZqWbMmj Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34t4rag2m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 01:50:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1j5oW088977;
        Sat, 14 Nov 2020 01:50:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g5th7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 01:50:07 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE1o6XG022742;
        Sat, 14 Nov 2020 01:50:06 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 17:50:06 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 2/5 v5] KVM: SVM: Fill in conforming svm_x86_ops via macro
Date:   Sat, 14 Nov 2020 01:49:52 +0000
Message-Id: <20201114014955.19749-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
References: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=3 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140009
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
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/pmu.h      |   2 +-
 arch/x86/kvm/svm/avic.c |  11 +-
 arch/x86/kvm/svm/pmu.c  |   2 +-
 arch/x86/kvm/svm/sev.c  |   4 +-
 arch/x86/kvm/svm/svm.c  | 298 ++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.h  |  15 +-
 arch/x86/kvm/x86.c      |  11 +-
 7 files changed, 188 insertions(+), 155 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 067fef51760c..a7f1f048c6a8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -161,5 +161,5 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
-extern struct kvm_pmu_ops amd_pmu_ops;
+extern struct kvm_pmu_ops svm_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8c550999ace0..1e709237a77f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -577,7 +577,12 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-void avic_post_state_restore(struct kvm_vcpu *vcpu)
+int svm_sync_pir_to_irr(struct kvm_vcpu *vcpu)
+{
+	return kvm_lapic_find_highest_irr(vcpu);
+}
+
+void svm_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (avic_handle_apic_id_update(vcpu) != 0)
 		return;
@@ -658,7 +663,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * we need to check and update the AVIC logical APIC ID table
 		 * accordingly before re-activating.
 		 */
-		avic_post_state_restore(vcpu);
+		svm_apicv_post_state_restore(vcpu);
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
@@ -673,7 +678,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	return;
 }
 
-int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
+int svm_deliver_interrupt(struct kvm_vcpu *vcpu, int vec)
 {
 	if (!vcpu->arch.apicv_active)
 		return -1;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 035da07500e8..e518372ab292 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -311,7 +311,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_pmu_ops amd_pmu_ops = {
+struct kvm_pmu_ops svm_pmu_ops = {
 	.find_arch_event = amd_find_arch_event,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..53d8a6fbaf8e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -984,7 +984,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
-int svm_register_enc_region(struct kvm *kvm,
+int svm_mem_enc_register_region(struct kvm *kvm,
 			    struct kvm_enc_region *range)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1053,7 +1053,7 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-int svm_unregister_enc_region(struct kvm *kvm,
+int svm_mem_enc_unregister_region(struct kvm *kvm,
 			      struct kvm_enc_region *range)
 {
 	struct enc_region *region;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5ee8eef1905a..2c96a0e88b1e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -332,7 +332,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -371,7 +371,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		(void)skip_emulated_instruction(&svm->vcpu);
+		(void)svm_skip_emulated_instruction(&svm->vcpu);
 		rip = kvm_rip_read(&svm->vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
@@ -1284,7 +1284,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
-static int svm_create_vcpu(struct kvm_vcpu *vcpu)
+static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
@@ -1338,7 +1338,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
 }
 
-static void svm_free_vcpu(struct kvm_vcpu *vcpu)
+static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1648,6 +1648,15 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	}
 }
 
+static void svm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+        struct kvm_segment cs;
+
+	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
+        *db = cs.db;
+        *l = cs.l;
+}
+
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1691,7 +1700,7 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
-		svm_flush_tlb(vcpu);
+		svm_tlb_flush(vcpu);
 
 	vcpu->arch.cr4 = cr4;
 	if (!npt_enabled)
@@ -1733,7 +1742,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
-static void update_exception_bitmap(struct kvm_vcpu *vcpu)
+static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -2248,7 +2257,7 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (!skip_emulated_instruction(&svm->vcpu))
+		if (!svm_skip_emulated_instruction(&svm->vcpu))
 			return 0;
 	}
 
@@ -3058,7 +3067,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
 		*error_code = 0;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -3164,7 +3173,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static void svm_set_irq(struct kvm_vcpu *vcpu)
+static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3177,7 +3186,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3286,7 +3295,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !svm_interrupt_blocked(vcpu);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
+static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3310,7 +3319,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3343,7 +3352,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return 0;
 }
 
-void svm_flush_tlb(struct kvm_vcpu *vcpu)
+void svm_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3360,14 +3369,29 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 		svm->asid_generation--;
 }
 
-static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
+static void svm_tlb_flush_all(struct kvm_vcpu *vcpu)
+{
+	svm_tlb_flush(vcpu);
+}
+
+static void svm_tlb_flush_current(struct kvm_vcpu *vcpu)
+{
+	svm_tlb_flush(vcpu);
+}
+
+static void svm_tlb_flush_guest(struct kvm_vcpu *vcpu)
+{
+	svm_tlb_flush(vcpu);
+}
+
+static void svm_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	invlpga(gva, svm->vmcb->control.asid);
 }
 
-static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
+static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 }
 
@@ -3962,6 +3986,11 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void svm_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	__kvm_request_immediate_exit(vcpu);
+}
+
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 }
@@ -4057,7 +4086,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return ret;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4176,125 +4205,132 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+#define KVM_X86_OP_NAME(name) .name = svm_##name
+#define KVM_X86_OP_PTR(ptr) .ptr = &svm_##ptr
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.hardware_teardown = svm_hardware_teardown,
-	.hardware_enable = svm_hardware_enable,
-	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
-	.has_emulated_msr = svm_has_emulated_msr,
+	KVM_X86_OP_NAME(hardware_teardown),
+	KVM_X86_OP_NAME(hardware_enable),
+	KVM_X86_OP_NAME(hardware_disable),
+	KVM_X86_OP_NAME(cpu_has_accelerated_tpr),
+	KVM_X86_OP_NAME(has_emulated_msr),
 
-	.vcpu_create = svm_create_vcpu,
-	.vcpu_free = svm_free_vcpu,
-	.vcpu_reset = svm_vcpu_reset,
+	KVM_X86_OP_NAME(vcpu_create),
+	KVM_X86_OP_NAME(vcpu_free),
+	KVM_X86_OP_NAME(vcpu_reset),
 
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
-	.update_exception_bitmap = update_exception_bitmap,
-	.get_msr_feature = svm_get_msr_feature,
-	.get_msr = svm_get_msr,
-	.set_msr = svm_set_msr,
-	.get_segment_base = svm_get_segment_base,
-	.get_segment = svm_get_segment,
-	.set_segment = svm_set_segment,
-	.get_cpl = svm_get_cpl,
-	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
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
-	.update_emulated_instruction = NULL,
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
-	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
-	.apicv_post_state_restore = avic_post_state_restore,
-
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_mt_mask = svm_get_mt_mask,
-
-	.get_exit_info = svm_get_exit_info,
-
-	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
-
-	.has_wbinvd_exit = svm_has_wbinvd_exit,
-
-	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
-
-	.load_mmu_pgd = svm_load_mmu_pgd,
-
-	.check_intercept = svm_check_intercept,
-	.handle_exit_irqoff = svm_handle_exit_irqoff,
-
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
-	.sched_in = svm_sched_in,
-
-	.pmu_ops = &amd_pmu_ops,
-	.nested_ops = &svm_nested_ops,
-
-	.deliver_interrupt = svm_deliver_avic_intr,
-	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
-	.update_pi_irte = svm_update_pi_irte,
-	.setup_mce = svm_setup_mce,
-
-	.smi_allowed = svm_smi_allowed,
-	.pre_enter_smm = svm_pre_enter_smm,
-	.pre_leave_smm = svm_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
-
-	.mem_enc_op = svm_mem_enc_op,
-	.mem_enc_register_region = svm_register_enc_region,
-	.mem_enc_unregister_region = svm_unregister_enc_region,
-
-	.can_emulate_instruction = svm_can_emulate_instruction,
-
-	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
-
-	.msr_filter_changed = svm_msr_filter_changed,
+
+	KVM_X86_OP_NAME(vm_init),
+	KVM_X86_OP_NAME(vm_destroy),
+
+	KVM_X86_OP_NAME(prepare_switch_to_guest),
+	KVM_X86_OP_NAME(vcpu_load),
+	KVM_X86_OP_NAME(vcpu_put),
+	KVM_X86_OP_NAME(vcpu_blocking),
+	KVM_X86_OP_NAME(vcpu_unblocking),
+
+	KVM_X86_OP_NAME(update_exception_bitmap),
+	KVM_X86_OP_NAME(get_msr_feature),
+	KVM_X86_OP_NAME(get_msr),
+	KVM_X86_OP_NAME(set_msr),
+	KVM_X86_OP_NAME(get_segment_base),
+	KVM_X86_OP_NAME(get_segment),
+	KVM_X86_OP_NAME(set_segment),
+	KVM_X86_OP_NAME(get_cpl),
+
+	KVM_X86_OP_NAME(get_cs_db_l_bits),
+
+	KVM_X86_OP_NAME(set_cr0),
+	KVM_X86_OP_NAME(set_cr4),
+	KVM_X86_OP_NAME(set_efer),
+	KVM_X86_OP_NAME(get_idt),
+	KVM_X86_OP_NAME(set_idt),
+	KVM_X86_OP_NAME(get_gdt),
+	KVM_X86_OP_NAME(set_gdt),
+	KVM_X86_OP_NAME(set_dr7),
+	KVM_X86_OP_NAME(sync_dirty_debug_regs),
+	KVM_X86_OP_NAME(cache_reg),
+	KVM_X86_OP_NAME(get_rflags),
+	KVM_X86_OP_NAME(set_rflags),
+
+	KVM_X86_OP_NAME(tlb_flush_all),
+	KVM_X86_OP_NAME(tlb_flush_current),
+	KVM_X86_OP_NAME(tlb_flush_gva),
+	KVM_X86_OP_NAME(tlb_flush_guest),
+
+	KVM_X86_OP_NAME(vcpu_run),
+	KVM_X86_OP_NAME(handle_exit),
+	KVM_X86_OP_NAME(skip_emulated_instruction),
+
+	KVM_X86_OP_NAME(set_interrupt_shadow),
+	KVM_X86_OP_NAME(get_interrupt_shadow),
+	KVM_X86_OP_NAME(patch_hypercall),
+	KVM_X86_OP_NAME(inject_irq),
+	KVM_X86_OP_NAME(inject_nmi),
+	KVM_X86_OP_NAME(queue_exception),
+	KVM_X86_OP_NAME(cancel_injection),
+	KVM_X86_OP_NAME(interrupt_allowed),
+	KVM_X86_OP_NAME(nmi_allowed),
+	KVM_X86_OP_NAME(get_nmi_mask),
+	KVM_X86_OP_NAME(set_nmi_mask),
+	KVM_X86_OP_NAME(enable_nmi_window),
+	KVM_X86_OP_NAME(enable_irq_window),
+	KVM_X86_OP_NAME(update_cr8_intercept),
+	KVM_X86_OP_NAME(set_virtual_apic_mode),
+	KVM_X86_OP_NAME(refresh_apicv_exec_ctrl),
+	KVM_X86_OP_NAME(check_apicv_inhibit_reasons),
+	KVM_X86_OP_NAME(pre_update_apicv_exec_ctrl),
+	KVM_X86_OP_NAME(load_eoi_exitmap),
+	KVM_X86_OP_NAME(hwapic_irr_update),
+	KVM_X86_OP_NAME(hwapic_isr_update),
+
+	KVM_X86_OP_NAME(sync_pir_to_irr),
+	KVM_X86_OP_NAME(apicv_post_state_restore),
+
+	KVM_X86_OP_NAME(set_tss_addr),
+	KVM_X86_OP_NAME(set_identity_map_addr),
+	KVM_X86_OP_NAME(get_mt_mask),
+
+	KVM_X86_OP_NAME(get_exit_info),
+
+	KVM_X86_OP_NAME(vcpu_after_set_cpuid),
+
+	KVM_X86_OP_NAME(has_wbinvd_exit),
+
+	KVM_X86_OP_NAME(write_l1_tsc_offset),
+
+	KVM_X86_OP_NAME(load_mmu_pgd),
+
+	KVM_X86_OP_NAME(check_intercept),
+	KVM_X86_OP_NAME(handle_exit_irqoff),
+
+	KVM_X86_OP_NAME(request_immediate_exit),
+
+	KVM_X86_OP_NAME(sched_in),
+
+	KVM_X86_OP_PTR(pmu_ops),
+	KVM_X86_OP_PTR(nested_ops),
+
+	KVM_X86_OP_NAME(deliver_interrupt),
+	KVM_X86_OP_NAME(dy_apicv_has_pending_interrupt),
+	KVM_X86_OP_NAME(update_pi_irte),
+	KVM_X86_OP_NAME(setup_mce),
+
+	KVM_X86_OP_NAME(smi_allowed),
+	KVM_X86_OP_NAME(pre_enter_smm),
+	KVM_X86_OP_NAME(pre_leave_smm),
+	KVM_X86_OP_NAME(enable_smi_window),
+
+	KVM_X86_OP_NAME(mem_enc_op),
+	KVM_X86_OP_NAME(mem_enc_register_region),
+	KVM_X86_OP_NAME(mem_enc_unregister_region),
+
+	KVM_X86_OP_NAME(can_emulate_instruction),
+
+	KVM_X86_OP_NAME(apic_init_signal_blocked),
+
+	KVM_X86_OP_NAME(msr_filter_changed),
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1d853fe4c778..de535a2d59a3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -359,7 +359,7 @@ void svm_vcpu_free_msrpm(u32 *msrpm);
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-void svm_flush_tlb(struct kvm_vcpu *vcpu);
+void svm_tlb_flush(struct kvm_vcpu *vcpu);
 void disable_nmi_singlestep(struct vcpu_svm *svm);
 bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
@@ -453,7 +453,8 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm);
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
-void avic_post_state_restore(struct kvm_vcpu *vcpu);
+int svm_sync_pir_to_irr(struct kvm_vcpu *vcpu);
+void svm_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
@@ -461,7 +462,7 @@ void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate);
 void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
-int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
+int svm_deliver_interrupt(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
@@ -490,10 +491,10 @@ static inline bool svm_sev_enabled(void)
 
 void sev_vm_destroy(struct kvm *kvm);
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
-int svm_register_enc_region(struct kvm *kvm,
-			    struct kvm_enc_region *range);
-int svm_unregister_enc_region(struct kvm *kvm,
-			      struct kvm_enc_region *range);
+int svm_mem_enc_register_region(struct kvm *kvm,
+                            struct kvm_enc_region *range);
+int svm_mem_enc_unregister_region(struct kvm *kvm,
+                            struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a982a971db7c..1517575dca61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5807,6 +5807,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 {
 	kvm_x86_ops.get_segment(vcpu, var, seg);
 }
+EXPORT_SYMBOL_GPL(kvm_get_segment);
 
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 			   struct x86_exception *exception)
@@ -9363,16 +9364,6 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
-void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-{
-	struct kvm_segment cs;
-
-	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
-	*db = cs.db;
-	*l = cs.l;
-}
-EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
-
 static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
-- 
2.27.0

