Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF92B2AA5
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgKNBu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 20:50:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44678 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNBu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 20:50:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1oAVx171662;
        Sat, 14 Nov 2020 01:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=3PkGVVQL+HZ37SRMzxKwwnild564X8Vhiu55NW/g/Kc=;
 b=COBehHLkGPbydwrLgOp+ewn47haDtBpTp+wJzXZt/4WIlwziI0GZtxE9iunpPGIoyRlw
 Ks8yvhXIDwiVE0Pp8bmZlecntAsZASd3t6yLKhl7rYofHpVN4iBlfprkejq/qyY572MI
 8JRwrgxqYFJSNRaQXokmQkNZszifq4VbYxMPBqvNAfBAlnUiDRNQsoGjFWVnRSue5Gpw
 OoJluyvLm4nWiFyUySN/iySQ9e0sO8HqgznQZRnm1pwT2VtGNBx3JFqrLrFW1p1WOQY6
 P3WGHCArZu+smIm3zoO535k5iwDJ/oA+7u2Gg4KfOYcQe5Mh/kLCIcJK+vF8hLOpzpuf YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rag2m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 01:50:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1kNA5143021;
        Sat, 14 Nov 2020 01:50:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34t4bsbp94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 01:50:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE1o7c6007049;
        Sat, 14 Nov 2020 01:50:07 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 17:50:07 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 4/5 v5] KVM: VMX: Fill in conforming vmx_x86_ops via macro
Date:   Sat, 14 Nov 2020 01:49:54 +0000
Message-Id: <20201114014955.19749-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
References: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 mlxlogscore=938 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=951 adultscore=0 phishscore=0 suspectscore=3 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140009
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of some of the vmx_x86_ops functions do not have a corresponding
'vmx_' prefix. Generate the names using a macro so that the names are
conformant. Fixing the naming will help in better readability and
maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/pmu.h             |   2 +-
 arch/x86/kvm/vmx/nested.c      |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c   |   2 +-
 arch/x86/kvm/vmx/posted_intr.c |   6 +-
 arch/x86/kvm/vmx/posted_intr.h |   4 +-
 arch/x86/kvm/vmx/vmx.c         | 260 +++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h         |   2 +-
 7 files changed, 141 insertions(+), 137 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a7f1f048c6a8..b8049ee4d1ab 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -160,6 +160,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-extern struct kvm_pmu_ops intel_pmu_ops;
+extern struct kvm_pmu_ops vmx_pmu_ops;
 extern struct kvm_pmu_ops svm_pmu_ops;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6c32f73cffd5..104d6782ddc3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2532,7 +2532,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bitwise-or of what L1 wants to trap for L2, and what we want to
 	 * trap. Note that CR0.TS also needs updating - we do this later.
 	 */
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 	vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a886a47daebd..c39f1dbcd436 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -427,7 +427,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
-struct kvm_pmu_ops intel_pmu_ops = {
+struct kvm_pmu_ops vmx_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f02962dcc72c..39c7ccabfd82 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -228,7 +228,7 @@ void __init pi_init_cpu(int cpu)
 	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 }
 
-bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
+bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
@@ -238,7 +238,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
 
 
 /*
- * pi_update_irte - set IRTE for Posted-Interrupts
+ * vmx_pi_update_irte - set IRTE for Posted-Interrupts
  *
  * @kvm: kvm
  * @host_irq: host irq of the interrupt
@@ -246,7 +246,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  * @set: set or unset PI
  * returns 0 on success, < 0 on failure
  */
-int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
+int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set)
 {
 	struct kvm_kernel_irq_routing_entry *e;
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 0bdc41391c5b..76ab06faec26 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -92,8 +92,8 @@ int pi_pre_block(struct kvm_vcpu *vcpu);
 void pi_post_block(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
-bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
+bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
+int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ddfc127d5c4f..0b8539759ad9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -629,7 +629,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool report_flexpriority(void)
+static inline bool vmx_cpu_has_accelerated_tpr(void)
 {
 	return flexpriority_enabled;
 }
@@ -807,7 +807,7 @@ static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 	return *p;
 }
 
-void update_exception_bitmap(struct kvm_vcpu *vcpu)
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
 
@@ -2283,7 +2283,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int hardware_enable(void)
+static int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2332,7 +2332,7 @@ static void kvm_cpu_vmxoff(void)
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 
-static void hardware_disable(void)
+static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 	kvm_cpu_vmxoff();
@@ -2740,7 +2740,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
 			(vmcs_readl(CR4_READ_SHADOW) & X86_CR4_VME));
 
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_pmode_seg(vcpu, VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
 	fix_pmode_seg(vcpu, VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
@@ -2820,7 +2820,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 
 	vmcs_writel(GUEST_RFLAGS, flags);
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | X86_CR4_VME);
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 
 	fix_rmode_seg(VCPU_SREG_SS, &vmx->rmode.segs[VCPU_SREG_SS]);
 	fix_rmode_seg(VCPU_SREG_CS, &vmx->rmode.segs[VCPU_SREG_CS]);
@@ -2881,7 +2881,7 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -2904,7 +2904,7 @@ static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 root_hpa = mmu->root_hpa;
@@ -2922,7 +2922,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 		vpid_sync_context(nested_get_vpid02(vcpu));
 }
 
-static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+static void vmx_tlb_flush_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
 	 * vpid_sync_vcpu_addr() is a nop if vmx->vpid==0, see the comment in
@@ -2931,7 +2931,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	vpid_sync_vcpu_addr(to_vmx(vcpu)->vpid, addr);
 }
 
-static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+static void vmx_tlb_flush_guest(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
@@ -3979,7 +3979,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  * 2. If target vcpu isn't running(root mode), kick it to pick up the
  * interrupt from PIR in next vmentry.
  */
-static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+static int vmx_deliver_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
@@ -4470,23 +4470,23 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
 
@@ -6149,7 +6149,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
-static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+static void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	int tpr_threshold;
@@ -6237,7 +6237,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		return;
 
 	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
-	vmx_flush_tlb_current(vcpu);
+	vmx_tlb_flush_current(vcpu);
 
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
@@ -6822,7 +6822,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_fastpath;
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6833,7 +6833,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx;
 	int i, cpu, err;
@@ -7261,7 +7261,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	set_cr4_guest_host_mask(vmx);
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
-	update_exception_bitmap(vcpu);
+	vmx_update_exception_bitmap(vcpu);
 }
 
 static __init void vmx_set_cpu_caps(void)
@@ -7551,7 +7551,7 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static void enable_smi_window(struct kvm_vcpu *vcpu)
+static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
@@ -7571,7 +7571,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+static void vmx_hardware_teardown(void)
 {
 	if (nested)
 		nested_vmx_hardware_unsetup();
@@ -7587,134 +7587,138 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+#define KVM_X86_OP_NAME(name) .name = vmx_##name
+#define KVM_X86_OP_PTR(ptr) .ptr = &vmx_##ptr
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.hardware_teardown = hardware_unsetup,
+	KVM_X86_OP_NAME(hardware_teardown),
 
-	.hardware_enable = hardware_enable,
-	.hardware_disable = hardware_disable,
-	.cpu_has_accelerated_tpr = report_flexpriority,
-	.has_emulated_msr = vmx_has_emulated_msr,
+	KVM_X86_OP_NAME(hardware_enable),
+	KVM_X86_OP_NAME(hardware_disable),
+	KVM_X86_OP_NAME(cpu_has_accelerated_tpr),
+	KVM_X86_OP_NAME(has_emulated_msr),
 
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
-
-	.vcpu_create = vmx_create_vcpu,
-	.vcpu_free = vmx_free_vcpu,
-	.vcpu_reset = vmx_vcpu_reset,
-
-	.prepare_guest_switch = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
-
-	.update_exception_bitmap = update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
-	.get_segment_base = vmx_get_segment_base,
-	.get_segment = vmx_get_segment,
-	.set_segment = vmx_set_segment,
-	.get_cpl = vmx_get_cpl,
-	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.set_cr0 = vmx_set_cr0,
-	.set_cr4 = vmx_set_cr4,
-	.set_efer = vmx_set_efer,
-	.get_idt = vmx_get_idt,
-	.set_idt = vmx_set_idt,
-	.get_gdt = vmx_get_gdt,
-	.set_gdt = vmx_set_gdt,
-	.set_dr7 = vmx_set_dr7,
-	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
-	.cache_reg = vmx_cache_reg,
-	.get_rflags = vmx_get_rflags,
-	.set_rflags = vmx_set_rflags,
-
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
-
-	.vcpu_run = vmx_vcpu_run,
-	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = vmx_skip_emulated_instruction,
-	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vmx_set_interrupt_shadow,
-	.get_interrupt_shadow = vmx_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
-	.inject_irq = vmx_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
-	.queue_exception = vmx_queue_exception,
-	.cancel_injection = vmx_cancel_injection,
-	.interrupt_allowed = vmx_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = enable_nmi_window,
-	.enable_irq_window = enable_irq_window,
-	.update_cr8_intercept = update_cr8_intercept,
-	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vmx_load_eoi_exitmap,
-	.apicv_post_state_restore = vmx_apicv_post_state_restore,
-	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
-	.hwapic_irr_update = vmx_hwapic_irr_update,
-	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
-	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_interrupt = vmx_deliver_posted_interrupt,
-	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
-
-	.set_tss_addr = vmx_set_tss_addr,
-	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
-
-	.get_exit_info = vmx_get_exit_info,
-
-	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
+	KVM_X86_OP_NAME(vm_init),
+
+	KVM_X86_OP_NAME(vcpu_create),
+	KVM_X86_OP_NAME(vcpu_free),
+	KVM_X86_OP_NAME(vcpu_reset),
+
+	KVM_X86_OP_NAME(prepare_switch_to_guest),
+	KVM_X86_OP_NAME(vcpu_load),
+	KVM_X86_OP_NAME(vcpu_put),
+
+	KVM_X86_OP_NAME(update_exception_bitmap),
+
+	KVM_X86_OP_NAME(get_msr_feature),
+	KVM_X86_OP_NAME(get_msr),
+	KVM_X86_OP_NAME(set_msr),
+	KVM_X86_OP_NAME(get_segment_base),
+	KVM_X86_OP_NAME(get_segment),
+	KVM_X86_OP_NAME(set_segment),
+	KVM_X86_OP_NAME(get_cpl),
+	KVM_X86_OP_NAME(get_cs_db_l_bits),
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
+	KVM_X86_OP_NAME(update_emulated_instruction),
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
+	KVM_X86_OP_NAME(set_apic_access_page_addr),
+	KVM_X86_OP_NAME(refresh_apicv_exec_ctrl),
+	KVM_X86_OP_NAME(load_eoi_exitmap),
+	KVM_X86_OP_NAME(apicv_post_state_restore),
+	KVM_X86_OP_NAME(check_apicv_inhibit_reasons),
+	KVM_X86_OP_NAME(hwapic_irr_update),
+	KVM_X86_OP_NAME(hwapic_isr_update),
+	KVM_X86_OP_NAME(guest_apic_has_interrupt),
+	KVM_X86_OP_NAME(sync_pir_to_irr),
+	KVM_X86_OP_NAME(deliver_interrupt),
+	KVM_X86_OP_NAME(dy_apicv_has_pending_interrupt),
+
+	KVM_X86_OP_NAME(set_tss_addr),
+	KVM_X86_OP_NAME(set_identity_map_addr),
+	KVM_X86_OP_NAME(get_mt_mask),
+
+	KVM_X86_OP_NAME(get_exit_info),
+
+	KVM_X86_OP_NAME(vcpu_after_set_cpuid),
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
+	KVM_X86_OP_NAME(write_l1_tsc_offset),
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	KVM_X86_OP_NAME(load_mmu_pgd),
 
-	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	KVM_X86_OP_NAME(check_intercept),
+	KVM_X86_OP_NAME(handle_exit_irqoff),
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	KVM_X86_OP_NAME(request_immediate_exit),
 
-	.sched_in = vmx_sched_in,
+	KVM_X86_OP_NAME(sched_in),
 
-	.slot_enable_log_dirty = vmx_slot_enable_log_dirty,
-	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
-	.flush_log_dirty = vmx_flush_log_dirty,
-	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
+	KVM_X86_OP_NAME(slot_enable_log_dirty),
+	KVM_X86_OP_NAME(slot_disable_log_dirty),
+	KVM_X86_OP_NAME(flush_log_dirty),
+	KVM_X86_OP_NAME(enable_log_dirty_pt_masked),
 
-	.pre_block = vmx_pre_block,
-	.post_block = vmx_post_block,
+	KVM_X86_OP_NAME(pre_block),
+	KVM_X86_OP_NAME(post_block),
 
-	.pmu_ops = &intel_pmu_ops,
-	.nested_ops = &vmx_nested_ops,
+	KVM_X86_OP_PTR(pmu_ops),
+	KVM_X86_OP_PTR(nested_ops),
 
-	.update_pi_irte = pi_update_irte,
+	KVM_X86_OP_NAME(update_pi_irte),
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	KVM_X86_OP_NAME(set_hv_timer),
+	KVM_X86_OP_NAME(cancel_hv_timer),
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	KVM_X86_OP_NAME(setup_mce),
 
-	.smi_allowed = vmx_smi_allowed,
-	.pre_enter_smm = vmx_pre_enter_smm,
-	.pre_leave_smm = vmx_pre_leave_smm,
-	.enable_smi_window = enable_smi_window,
+	KVM_X86_OP_NAME(smi_allowed),
+	KVM_X86_OP_NAME(pre_enter_smm),
+	KVM_X86_OP_NAME(pre_leave_smm),
+	KVM_X86_OP_NAME(enable_smi_window),
 
-	.can_emulate_instruction = vmx_can_emulate_instruction,
-	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
-	.migrate_timers = vmx_migrate_timers,
+	KVM_X86_OP_NAME(can_emulate_instruction),
+	KVM_X86_OP_NAME(apic_init_signal_blocked),
+	KVM_X86_OP_NAME(migrate_timers),
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	KVM_X86_OP_NAME(msr_filter_changed),
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..42c90c1a6ea9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -329,7 +329,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
 		   int root_level);
 
-void update_exception_bitmap(struct kvm_vcpu *vcpu);
+void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
-- 
2.27.0

