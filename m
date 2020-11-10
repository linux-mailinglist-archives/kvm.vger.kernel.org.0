Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510ED2ACA68
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 02:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgKJBZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 20:25:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKJBZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 20:25:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1JlM2134847;
        Tue, 10 Nov 2020 01:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RfTNumpSEEH4ytP1ibwXcPjCeqUMXJxiPwdNHiSal3U=;
 b=gZ5wLe5saf2k7EbE8uUEKhE06l46KygDUU9fXF9kssqyPCyDgASshoMmY+c0yR9mKZmV
 uzbMp8KbVJITe+yDTaTPDo4wHVQFRJ6s8aYnPwEAB9qBJJ0H7nyHfs3KgyVwU/OCbaSJ
 NS9aofs3oqhsah0GZZ6urhi0UCmwZRkr5/cs6k1QM48AEoX9Kmr/6QbzFlZ4rubkqYXP
 KDGMgT9Jjj3Cns3jcYUK0SowTiOQCfSqwYgaJ74mV0zkRlSfY62WdvqAT1u5s1RzJDWp
 IOj7mRMm2kTxDIvT6R8QMdJjFXyYPJdHEqCqjz5DwGWplf56NFxbaTFWEx/k4st0X8eU nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72ef9na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 01:25:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1K7V3024070;
        Tue, 10 Nov 2020 01:23:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gw4a0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 01:23:33 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AA1NWjf014143;
        Tue, 10 Nov 2020 01:23:32 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 17:23:31 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 1/5 v4] KVM: x86: Change names of some of the kvm_x86_ops functions to make them more semantical and readable
Date:   Tue, 10 Nov 2020 01:23:08 +0000
Message-Id: <20201110012312.20820-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
References: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=4
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=4 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/arm64/include/asm/kvm_host.h   |  2 +-
 arch/mips/include/asm/kvm_host.h    |  2 +-
 arch/powerpc/include/asm/kvm_host.h |  2 +-
 arch/s390/kvm/kvm-s390.c            |  2 +-
 arch/x86/include/asm/kvm_host.h     | 16 +++++++--------
 arch/x86/kvm/lapic.c                |  2 +-
 arch/x86/kvm/svm/nested.c           |  2 +-
 arch/x86/kvm/svm/svm.c              | 14 +++++++-------
 arch/x86/kvm/vmx/nested.c           |  2 +-
 arch/x86/kvm/vmx/vmx.c              | 10 +++++-----
 arch/x86/kvm/x86.c                  | 30 ++++++++++++++---------------
 include/linux/kvm_host.h            |  2 +-
 include/uapi/linux/kvm.h            |  6 +++---
 tools/include/uapi/linux/kvm.h      |  6 +++---
 virt/kvm/kvm_main.c                 |  4 ++--
 15 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 781d029b8aa8..50d0768f3aef 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -592,7 +592,7 @@ static inline bool kvm_arch_requires_vhe(void)
 
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
-static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_hardware_teardown(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 24f3d0f9996b..88ec47f7a56a 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -1145,7 +1145,7 @@ extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
 extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 			     struct kvm_mips_interrupt *irq);
 
-static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_hardware_teardown(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index d67a470e95a3..5a702ce6398a 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm_vcpu_arch {
 #define __KVM_HAVE_CREATE_DEVICE
 
 static inline void kvm_arch_hardware_disable(void) {}
-static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_hardware_teardown(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..e503263a0ef7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -312,7 +312,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
+void kvm_arch_hardware_teardown(void)
 {
 	gmap_unregister_pte_notifier(&gmap_notifier);
 	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..3f3948f08440 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1085,7 +1085,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
-	void (*hardware_unsetup)(void);
+	void (*hardware_teardown)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
@@ -1146,7 +1146,7 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
 
-	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1155,8 +1155,8 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	void (*set_irq)(struct kvm_vcpu *vcpu);
-	void (*set_nmi)(struct kvm_vcpu *vcpu);
+	void (*inject_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
@@ -1175,7 +1175,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
-	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	int (*deliver_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
@@ -1267,8 +1267,8 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
-	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
-	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
@@ -1290,7 +1290,7 @@ struct kvm_x86_nested_ops {
 	int (*set_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
 			 struct kvm_nested_state *kvm_state);
-	bool (*get_nested_state_pages)(struct kvm_vcpu *vcpu);
+	bool (*get_pages)(struct kvm_vcpu *vcpu);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 105e7859d1f2..aa839724fe94 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1090,7 +1090,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		if (kvm_x86_ops.deliver_posted_interrupt(vcpu, vector)) {
+		if (kvm_x86_ops.deliver_interrupt(vcpu, vector)) {
 			kvm_lapic_set_irr(vector, apic);
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9e4c226dbf7d..200674190449 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1211,7 +1211,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
-	.get_nested_state_pages = svm_get_nested_state_pages,
+	.get_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
 };
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..5ee8eef1905a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4177,7 +4177,7 @@ static int svm_vm_init(struct kvm *kvm)
 }
 
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.hardware_unsetup = svm_hardware_teardown,
+	.hardware_teardown = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
@@ -4224,15 +4224,15 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.tlb_flush_gva = svm_flush_tlb_gva,
 	.tlb_flush_guest = svm_flush_tlb,
 
-	.run = svm_vcpu_run,
+	.vcpu_run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
-	.set_irq = svm_set_irq,
-	.set_nmi = svm_inject_nmi,
+	.inject_irq = svm_set_irq,
+	.inject_nmi = svm_inject_nmi,
 	.queue_exception = svm_queue_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
@@ -4276,7 +4276,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
-	.deliver_posted_interrupt = svm_deliver_avic_intr,
+	.deliver_interrupt = svm_deliver_avic_intr,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
@@ -4287,8 +4287,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_smi_window = enable_smi_window,
 
 	.mem_enc_op = svm_mem_enc_op,
-	.mem_enc_reg_region = svm_register_enc_region,
-	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.mem_enc_register_region = svm_register_enc_region,
+	.mem_enc_unregister_region = svm_unregister_enc_region,
 
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 89af692deb7e..6c32f73cffd5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6573,7 +6573,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
-	.get_nested_state_pages = nested_get_vmcs12_pages,
+	.get_pages = nested_get_vmcs12_pages,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..ddfc127d5c4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7588,7 +7588,7 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.hardware_unsetup = hardware_unsetup,
+	.hardware_teardown = hardware_unsetup,
 
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
@@ -7633,15 +7633,15 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.tlb_flush_gva = vmx_flush_tlb_gva,
 	.tlb_flush_guest = vmx_flush_tlb_guest,
 
-	.run = vmx_vcpu_run,
+	.vcpu_run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
-	.set_irq = vmx_inject_irq,
-	.set_nmi = vmx_inject_nmi,
+	.inject_irq = vmx_inject_irq,
+	.inject_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
@@ -7661,7 +7661,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+	.deliver_interrupt = vmx_deliver_posted_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ede41bf9e6..b86e5b01cfcc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5607,13 +5607,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_MEMORY_ENCRYPT_OP: {
+	case KVM_MEM_ENC_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
 			r = kvm_x86_ops.mem_enc_op(kvm, argp);
 		break;
 	}
-	case KVM_MEMORY_ENCRYPT_REG_REGION: {
+	case KVM_MEM_ENC_REGISTER_REGION: {
 		struct kvm_enc_region region;
 
 		r = -EFAULT;
@@ -5621,11 +5621,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_reg_region)
-			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_register_region)
+			r = kvm_x86_ops.mem_enc_register_region(kvm, &region);
 		break;
 	}
-	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
+	case KVM_MEM_ENC_UNREGISTER_REGION: {
 		struct kvm_enc_region region;
 
 		r = -EFAULT;
@@ -5633,8 +5633,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_unreg_region)
-			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
+		if (kvm_x86_ops.mem_enc_unregister_region)
+			r = kvm_x86_ops.mem_enc_unregister_region(kvm, &region);
 		break;
 	}
 	case KVM_HYPERV_EVENTFD: {
@@ -8180,10 +8180,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 */
 	else if (!vcpu->arch.exception.pending) {
 		if (vcpu->arch.nmi_injected) {
-			kvm_x86_ops.set_nmi(vcpu);
+			kvm_x86_ops.inject_nmi(vcpu);
 			can_inject = false;
 		} else if (vcpu->arch.interrupt.injected) {
-			kvm_x86_ops.set_irq(vcpu);
+			kvm_x86_ops.inject_irq(vcpu);
 			can_inject = false;
 		}
 	}
@@ -8259,7 +8259,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
-			kvm_x86_ops.set_nmi(vcpu);
+			kvm_x86_ops.inject_nmi(vcpu);
 			can_inject = false;
 			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
 		}
@@ -8273,7 +8273,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			goto busy;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			kvm_x86_ops.set_irq(vcpu);
+			kvm_x86_ops.inject_irq(vcpu);
 			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
@@ -8710,7 +8710,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}
@@ -8910,7 +8910,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	exit_fastpath = kvm_x86_ops.run(vcpu);
+	exit_fastpath = kvm_x86_ops.vcpu_run(vcpu);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -10178,9 +10178,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
+void kvm_arch_hardware_teardown(void)
 {
-	kvm_x86_ops.hardware_unsetup();
+	kvm_x86_ops.hardware_teardown();
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f2e2a09ebbd..b087488cf5fc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -925,7 +925,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
-void kvm_arch_hardware_unsetup(void);
+void kvm_arch_hardware_teardown(void);
 int kvm_arch_check_processor_compat(void *opaque);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..91239a6c8818 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1491,15 +1491,15 @@ struct kvm_s390_ucas_mapping {
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
 /* Memory Encryption Commands */
-#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
+#define KVM_MEM_ENC_OP      _IOWR(KVMIO, 0xba, unsigned long)
 
 struct kvm_enc_region {
 	__u64 addr;
 	__u64 size;
 };
 
-#define KVM_MEMORY_ENCRYPT_REG_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
-#define KVM_MEMORY_ENCRYPT_UNREG_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
+#define KVM_MEM_ENC_REGISTER_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
+#define KVM_MEM_ENC_UNREGISTER_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
 
 /* Available with KVM_CAP_HYPERV_EVENTFD */
 #define KVM_HYPERV_EVENTFD        _IOW(KVMIO,  0xbd, struct kvm_hyperv_eventfd)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 7d8eced6f459..ab651099d0c4 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1475,15 +1475,15 @@ struct kvm_s390_ucas_mapping {
 #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
 /* Memory Encryption Commands */
-#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
+#define KVM_MEM_ENC_OP      _IOWR(KVMIO, 0xba, unsigned long)
 
 struct kvm_enc_region {
 	__u64 addr;
 	__u64 size;
 };
 
-#define KVM_MEMORY_ENCRYPT_REG_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
-#define KVM_MEMORY_ENCRYPT_UNREG_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
+#define KVM_MEM_ENC_REGISTER_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
+#define KVM_MEM_ENC_UNREGISTER_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
 
 /* Available with KVM_CAP_HYPERV_EVENTFD */
 #define KVM_HYPERV_EVENTFD        _IOW(KVMIO,  0xbd, struct kvm_hyperv_eventfd)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2541a17ff1c4..309f027b8b72 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4858,7 +4858,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
-	kvm_arch_hardware_unsetup();
+	kvm_arch_hardware_teardown();
 out_free_1:
 	free_cpumask_var(cpus_hardware_enabled);
 out_free_0:
@@ -4880,7 +4880,7 @@ void kvm_exit(void)
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	kvm_arch_hardware_unsetup();
+	kvm_arch_hardware_teardown();
 	kvm_arch_exit();
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
-- 
2.18.4

