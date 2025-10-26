Return-Path: <kvm+bounces-61106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1853C0B242
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D8383A3040
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039193002CF;
	Sun, 26 Oct 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bUxfpBZx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A32240604;
	Sun, 26 Oct 2025 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510030; cv=none; b=cmTa9NJYVZx0A0+eie4vmkGwZkSYSlVou+Uac3MyLKaFrw+CoQkKcpoA6VFTjbCrDf9rfTOvp/BhiO5lSKmL6r9TL1D/UUtmcWuUDRZ7350pcoP5rfvpNLk8uoy/VLR0WyMtQAlvbF4ICI50JdjhnaZlmh9J3kbbR6JY5KDwzxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510030; c=relaxed/simple;
	bh=SmIoEMovSI6hEy8xuUeQhToxJCrX95ZdpOAbfe7w+Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT4x9hpTMblxT/k1Y8brekO1qcr65+GW8P3cfml+29zEt3htvL4eZDhE8mJ3WndQ1oBTaYq/GzvG+Eb13L8ZEA1sNNBmccCcL+foz6eDJ1snXtCKq8uV41BjqwYdhifBqfYncHyR0HbksauaDA7no36pEeo2ZLYW4vnXbkdJbjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bUxfpBZx; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBka505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBka505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509978;
	bh=hPQWIGTOjYHFSGXKdSj1tGlVXwtPGyUuIEWRIU4ksPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUxfpBZxadxDmMuTpqGq8fEpfLdhLtrbR0Z9H6yPsjT3rFzlB1ZfhOxNImtmtN8/7
	 Zn313ln+47j+5/tBwmJd5G1OIcEESTdxRj6r6b7CyrhBbGKwke41lZ9tWYmlGiK4Sh
	 li4eoYKuLcJh0clUTeUAm3O84ZYau/vD0ogBPXZEkZ+mOqPKNhU5PcbCA2TPWtpncY
	 k7IMkS1jSkjfxFhfbZBCTJ6am1zJ4NQCaqwFf9Yt1OkCxM0hy113n4i41JGW17Uc8P
	 CLSpUccowlDX3EJQdUQV0XF5tzB5w4OhQTazGJbJNilyjZCyx1OwPEEQB9AdeY4ucy
	 rRNUADU5juvLQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested VMX context
Date: Sun, 26 Oct 2025 13:19:07 -0700
Message-ID: <20251026201911.505204-20-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Extend nested VMX context management to include FRED-related VMCS fields,
enabling proper handling of FRED state during nested virtualization.

Because KVM always sets SECONDARY_VM_EXIT_SAVE_IA32_FRED, FRED MSRs are
always saved to vmcs02.  However an L1 VMM may choose to clear this bit,
i.e., not to save FRED MSRs to vmcs12.  This is not a problem when the L1
VMM sets SECONDARY_VM_EXIT_LOAD_IA32_FRED, as KVM then immediately loads
host FRED MSRs of vmcs12 to guest FRED MSRs of vmcs01.  However if the L1
VMM clears SECONDARY_VM_EXIT_LOAD_IA32_FRED, KVM should retain FRED MSRs
to run the L1 VMM.

To propagate guest FRED MSRs from vmcs02 to vmcs01, save them in
sync_vmcs02_to_vmcs12() regardless of whether
SECONDARY_VM_EXIT_SAVE_IA32_FRED is set in vmcs12.  Then, use the saved
values to set guest FRED MSRs in vmcs01 within load_vmcs12_host_state()
when !nested_cpu_load_host_fred_state().

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v9:
* Rebase to kvm-x86/next.
* Guard FRED state save/restore with guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)
  (syzbot & Chao).

Changes in v8:
* Make the newly added FRED fields 64-bit aligned in vmcs12 (Isaku).
* Remove the change to Documentation/virt/kvm/x86/nested-vmx.rst.

Change in v6:
* Handle FRED MSR pre-vmenter save/restore (Chao Gao).
* Save FRED MSRs of vmcs02 at VM-Exit even an L1 VMM clears
  SECONDARY_VM_EXIT_SAVE_IA32_FRED.
* Save FRED MSRs in sync_vmcs02_to_vmcs12() instead of its rare version.

Change in v5:
* Add TB from Xuelian Guo.

Changes in v4:
* Advertise VMX nested exception as if the CPU supports it (Chao Gao).
* Split FRED state management controls (Chao Gao).

Changes in v3:
* Add and use nested_cpu_has_fred(vmcs12) because vmcs02 should be set
  from vmcs12 if and only if the field is enabled in L1's VMX config
  (Sean Christopherson).
* Fix coding style issues (Sean Christopherson).

Changes in v2:
* Remove hyperv TLFS related changes (Jeremi Piotrowski).
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
---
 arch/x86/kvm/vmx/capabilities.h       |   5 ++
 arch/x86/kvm/vmx/nested.c             | 118 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h             |  22 +++++
 arch/x86/kvm/vmx/vmcs12.c             |  18 ++++
 arch/x86/kvm/vmx/vmcs12.h             |  37 ++++++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |   4 +
 arch/x86/kvm/vmx/vmx.h                |  41 +++++++++
 7 files changed, 243 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f390f9f883c3..5eba2530ffb4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -80,6 +80,11 @@ static inline bool cpu_has_vmx_basic_no_hw_errcode_cc(void)
 	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
 }
 
+static inline bool cpu_has_vmx_nested_exception(void)
+{
+	return vmcs_config.basic & VMX_BASIC_NESTED_EXCEPTION;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbb682424a5b..63cdfffba58b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -708,6 +708,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
 #endif
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
@@ -1294,9 +1297,11 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
 				 VMX_BASIC_INOUT |
 				 VMX_BASIC_TRUE_CTLS |
-				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
+				 VMX_BASIC_NO_HW_ERROR_CODE_CC |
+				 VMX_BASIC_NESTED_EXCEPTION;
 
-	const u64 reserved_bits = GENMASK_ULL(63, 57) |
+	const u64 reserved_bits = GENMASK_ULL(63, 59) |
+				  BIT_ULL(57) |
 				  GENMASK_ULL(47, 45) |
 				  BIT_ULL(31);
 
@@ -2539,6 +2544,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 			     vmcs12->vm_entry_instruction_len);
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 			     vmcs12->guest_interruptibility_info);
+		if (cpu_has_vmx_fred())
+			vmcs_write64(INJECTED_EVENT_DATA, vmcs12->injected_event_data);
 		vmx->loaded_vmcs->nmi_known_unmasked =
 			!(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_NMI);
 	} else {
@@ -2693,6 +2700,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				     vmcs12->guest_ssp, vmcs12->guest_ssp_tbl);
 
 	set_cr4_guest_host_mask(vmx);
+
+	if (guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED) &&
+	    nested_cpu_load_guest_fred_state(vmcs12)) {
+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->guest_ia32_fred_config);
+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->guest_ia32_fred_rsp1);
+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->guest_ia32_fred_rsp2);
+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->guest_ia32_fred_rsp3);
+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->guest_ia32_fred_stklvls);
+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->guest_ia32_fred_ssp1);
+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->guest_ia32_fred_ssp2);
+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->guest_ia32_fred_ssp3);
+	}
 }
 
 /*
@@ -2759,6 +2778,18 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_IA32_PAT, vcpu->arch.pat);
 	}
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED) &&
+	    (!vmx->nested.nested_run_pending || !nested_cpu_load_guest_fred_state(vmcs12))) {
+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.pre_vmenter_fred_config);
+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.pre_vmenter_fred_rsp1);
+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.pre_vmenter_fred_rsp2);
+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.pre_vmenter_fred_rsp3);
+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.pre_vmenter_fred_stklvls);
+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.pre_vmenter_fred_ssp1);
+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.pre_vmenter_fred_ssp2);
+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.pre_vmenter_fred_ssp3);
+	}
+
 	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
 			vcpu->arch.l1_tsc_offset,
 			vmx_get_l2_tsc_offset(vcpu),
@@ -3631,6 +3662,18 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 				    &vmx->nested.pre_vmenter_ssp,
 				    &vmx->nested.pre_vmenter_ssp_tbl);
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED) &&
+	    (!vmx->nested.nested_run_pending || !nested_cpu_load_guest_fred_state(vmcs12))) {
+		vmx->nested.pre_vmenter_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
+		vmx->nested.pre_vmenter_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
+		vmx->nested.pre_vmenter_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
+		vmx->nested.pre_vmenter_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
+		vmx->nested.pre_vmenter_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
+		vmx->nested.pre_vmenter_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
+		vmx->nested.pre_vmenter_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
+		vmx->nested.pre_vmenter_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
+	}
+
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled.  In the
 	 * event of a "late" VM-Fail, i.e. a VM-Fail detected by hardware but
@@ -3934,6 +3977,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	u32 idt_vectoring;
 	unsigned int nr;
 
+	vmcs12->original_event_data = 0;
+
 	/*
 	 * Per the SDM, VM-Exits due to double and triple faults are never
 	 * considered to occur during event delivery, even if the double/triple
@@ -3972,6 +4017,13 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 				vcpu->arch.exception.error_code;
 		}
 
+		if ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
+		    (vmcs12->guest_cr4 & X86_CR4_FRED) &&
+		    (vcpu->arch.exception.nested))
+			idt_vectoring |= VECTORING_INFO_NESTED_EXCEPTION_MASK;
+
+		vmcs12->original_event_data = vcpu->arch.exception.event_data;
+
 		vmcs12->idt_vectoring_info_field = idt_vectoring;
 	} else if (vcpu->arch.nmi_injected) {
 		vmcs12->idt_vectoring_info_field =
@@ -4714,6 +4766,28 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs_read_cet_state(&vmx->vcpu, &vmcs12->guest_s_cet,
 			    &vmcs12->guest_ssp,
 			    &vmcs12->guest_ssp_tbl);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
+		vmx->nested.fred_msr_at_vmexit.fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
+		vmx->nested.fred_msr_at_vmexit.fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
+		vmx->nested.fred_msr_at_vmexit.fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
+		vmx->nested.fred_msr_at_vmexit.fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
+		vmx->nested.fred_msr_at_vmexit.fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
+		vmx->nested.fred_msr_at_vmexit.fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
+		vmx->nested.fred_msr_at_vmexit.fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
+		vmx->nested.fred_msr_at_vmexit.fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
+
+		if (nested_cpu_save_guest_fred_state(vmcs12)) {
+			vmcs12->guest_ia32_fred_config = vmx->nested.fred_msr_at_vmexit.fred_config;
+			vmcs12->guest_ia32_fred_rsp1 = vmx->nested.fred_msr_at_vmexit.fred_rsp1;
+			vmcs12->guest_ia32_fred_rsp2 = vmx->nested.fred_msr_at_vmexit.fred_rsp2;
+			vmcs12->guest_ia32_fred_rsp3 = vmx->nested.fred_msr_at_vmexit.fred_rsp3;
+			vmcs12->guest_ia32_fred_stklvls = vmx->nested.fred_msr_at_vmexit.fred_stklvls;
+			vmcs12->guest_ia32_fred_ssp1 = vmx->nested.fred_msr_at_vmexit.fred_ssp1;
+			vmcs12->guest_ia32_fred_ssp2 = vmx->nested.fred_msr_at_vmexit.fred_ssp2;
+			vmcs12->guest_ia32_fred_ssp3 = vmx->nested.fred_msr_at_vmexit.fred_ssp3;
+		}
+	}
 }
 
 /*
@@ -4758,6 +4832,21 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 		vmcs12->vm_exit_intr_info = exit_intr_info;
 		vmcs12->vm_exit_instruction_len = exit_insn_len;
+
+		/*
+		 * When there is a valid original event, the exiting event is a nested
+		 * event during delivery of the earlier original event.
+		 *
+		 * FRED event delivery reflects this relationship by setting the value
+		 * of the nested exception bit of VM-exit interruption information
+		 * (aka exiting-event identification) to that of the valid bit of the
+		 * IDT-vectoring information (aka original-event identification).
+		 */
+		if ((vmcs12->idt_vectoring_info_field & VECTORING_INFO_VALID_MASK) &&
+		    (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
+		    (vmcs12->guest_cr4 & X86_CR4_FRED))
+			vmcs12->vm_exit_intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
+
 		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 
 		/*
@@ -4786,6 +4875,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	enum vm_entry_failure_code ignored;
 	struct kvm_segment seg;
 
@@ -4860,6 +4950,28 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(__kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 						     vmcs12->host_ia32_perf_global_ctrl));
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
+		if (nested_cpu_load_host_fred_state(vmcs12)) {
+			vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->host_ia32_fred_config);
+			vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->host_ia32_fred_rsp1);
+			vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->host_ia32_fred_rsp2);
+			vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->host_ia32_fred_rsp3);
+			vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->host_ia32_fred_stklvls);
+			vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->host_ia32_fred_ssp1);
+			vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->host_ia32_fred_ssp2);
+			vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->host_ia32_fred_ssp3);
+		} else {
+			vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.fred_msr_at_vmexit.fred_config);
+			vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.fred_msr_at_vmexit.fred_rsp1);
+			vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.fred_msr_at_vmexit.fred_rsp2);
+			vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.fred_msr_at_vmexit.fred_rsp3);
+			vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.fred_msr_at_vmexit.fred_stklvls);
+			vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.fred_msr_at_vmexit.fred_ssp1);
+			vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.fred_msr_at_vmexit.fred_ssp2);
+			vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.fred_msr_at_vmexit.fred_ssp3);
+		}
+	}
+
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
 	seg = (struct kvm_segment) {
@@ -7339,6 +7451,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 		msrs->basic |= VMX_BASIC_INOUT;
 	if (cpu_has_vmx_basic_no_hw_errcode_cc())
 		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
+	if (cpu_has_vmx_nested_exception())
+		msrs->basic |= VMX_BASIC_NESTED_EXCEPTION;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 983484d42ebf..a99d3d83d58e 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -249,6 +249,11 @@ static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
 	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 }
 
+static inline bool nested_cpu_has_secondary_vm_exit_controls(struct vmcs12 *vmcs12)
+{
+	return vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
+}
+
 static inline bool nested_exit_on_nmi(struct kvm_vcpu *vcpu)
 {
 	return nested_cpu_has_nmi_exiting(get_vmcs12(vcpu));
@@ -269,6 +274,23 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
 }
 
+static inline bool nested_cpu_load_guest_fred_state(struct vmcs12 *vmcs12)
+{
+	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED;
+}
+
+static inline bool nested_cpu_save_guest_fred_state(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has_secondary_vm_exit_controls(vmcs12) &&
+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED;
+}
+
+static inline bool nested_cpu_load_host_fred_state(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has_secondary_vm_exit_controls(vmcs12) &&
+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
+}
+
 /*
  * if fixed0[i] == 1: val[i] must be 1
  * if fixed1[i] == 0: val[i] must be 0
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 3b01175f392a..9691e709061f 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -67,6 +67,24 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
 	FIELD64(SECONDARY_VM_EXIT_CONTROLS, secondary_vm_exit_controls),
+	FIELD64(INJECTED_EVENT_DATA, injected_event_data),
+	FIELD64(ORIGINAL_EVENT_DATA, original_event_data),
+	FIELD64(GUEST_IA32_FRED_CONFIG, guest_ia32_fred_config),
+	FIELD64(GUEST_IA32_FRED_RSP1, guest_ia32_fred_rsp1),
+	FIELD64(GUEST_IA32_FRED_RSP2, guest_ia32_fred_rsp2),
+	FIELD64(GUEST_IA32_FRED_RSP3, guest_ia32_fred_rsp3),
+	FIELD64(GUEST_IA32_FRED_STKLVLS, guest_ia32_fred_stklvls),
+	FIELD64(GUEST_IA32_FRED_SSP1, guest_ia32_fred_ssp1),
+	FIELD64(GUEST_IA32_FRED_SSP2, guest_ia32_fred_ssp2),
+	FIELD64(GUEST_IA32_FRED_SSP3, guest_ia32_fred_ssp3),
+	FIELD64(HOST_IA32_FRED_CONFIG, host_ia32_fred_config),
+	FIELD64(HOST_IA32_FRED_RSP1, host_ia32_fred_rsp1),
+	FIELD64(HOST_IA32_FRED_RSP2, host_ia32_fred_rsp2),
+	FIELD64(HOST_IA32_FRED_RSP3, host_ia32_fred_rsp3),
+	FIELD64(HOST_IA32_FRED_STKLVLS, host_ia32_fred_stklvls),
+	FIELD64(HOST_IA32_FRED_SSP1, host_ia32_fred_ssp1),
+	FIELD64(HOST_IA32_FRED_SSP2, host_ia32_fred_ssp2),
+	FIELD64(HOST_IA32_FRED_SSP3, host_ia32_fred_ssp3),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index fa5306dc0311..051016a3afba 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -191,6 +191,25 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u16 padding16[1]; /* align to 64-bit boundary */
+	u64 guest_ia32_fred_config;
+	u64 guest_ia32_fred_rsp1;
+	u64 guest_ia32_fred_rsp2;
+	u64 guest_ia32_fred_rsp3;
+	u64 guest_ia32_fred_stklvls;
+	u64 guest_ia32_fred_ssp1;
+	u64 guest_ia32_fred_ssp2;
+	u64 guest_ia32_fred_ssp3;
+	u64 host_ia32_fred_config;
+	u64 host_ia32_fred_rsp1;
+	u64 host_ia32_fred_rsp2;
+	u64 host_ia32_fred_rsp3;
+	u64 host_ia32_fred_stklvls;
+	u64 host_ia32_fred_ssp1;
+	u64 host_ia32_fred_ssp2;
+	u64 host_ia32_fred_ssp3;
+	u64 injected_event_data;
+	u64 original_event_data;
 };
 
 /*
@@ -373,6 +392,24 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(guest_ia32_fred_config, 1000);
+	CHECK_OFFSET(guest_ia32_fred_rsp1, 1008);
+	CHECK_OFFSET(guest_ia32_fred_rsp2, 1016);
+	CHECK_OFFSET(guest_ia32_fred_rsp3, 1024);
+	CHECK_OFFSET(guest_ia32_fred_stklvls, 1032);
+	CHECK_OFFSET(guest_ia32_fred_ssp1, 1040);
+	CHECK_OFFSET(guest_ia32_fred_ssp2, 1048);
+	CHECK_OFFSET(guest_ia32_fred_ssp3, 1056);
+	CHECK_OFFSET(host_ia32_fred_config, 1064);
+	CHECK_OFFSET(host_ia32_fred_rsp1, 1072);
+	CHECK_OFFSET(host_ia32_fred_rsp2, 1080);
+	CHECK_OFFSET(host_ia32_fred_rsp3, 1088);
+	CHECK_OFFSET(host_ia32_fred_stklvls, 1096);
+	CHECK_OFFSET(host_ia32_fred_ssp1, 1104);
+	CHECK_OFFSET(host_ia32_fred_ssp2, 1112);
+	CHECK_OFFSET(host_ia32_fred_ssp3, 1120);
+	CHECK_OFFSET(injected_event_data, 1128);
+	CHECK_OFFSET(original_event_data, 1136);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index cad128d1657b..da338327c2b3 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -74,6 +74,10 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 /* 64-bit */
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
+SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data)
+SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data)
+SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data)
+SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data)
 
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 48a5ab12cccf..cedb714bc082 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -67,6 +67,37 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+/*
+ * Used to snapshot FRED MSRs that may NOT be saved to vmcs12 as specified
+ * in the VM-Exit controls of vmcs12 configured by L1 VMM.
+ *
+ * FRED MSRs are *always* saved into vmcs02 because KVM always sets
+ * SECONDARY_VM_EXIT_SAVE_IA32_FRED.  However an L1 VMM may choose to clear
+ * this bit, resulting in FRED MSRs not being propagated to vmcs12 from
+ * vmcs02.  When the L1 VMM sets SECONDARY_VM_EXIT_LOAD_IA32_FRED, this is
+ * not a problem, since KVM then immediately loads the host FRED MSRs of
+ * vmcs12 to the guest FRED MSRs of vmcs01.
+ *
+ * But if the L1 VMM clears SECONDARY_VM_EXIT_LOAD_IA32_FRED, KVM should
+ * retain the FRED MSRs, i.e., propagate the guest FRED MSRs of vmcs02 to
+ * the guest FRED MSRs of vmcs01.
+ *
+ * This structure stores guest FRED MSRs that an L1 VMM opts not to save
+ * during VM-Exits from L2 to L1.  These MSRs may still be retained for
+ * running the L1 VMM if SECONDARY_VM_EXIT_LOAD_IA32_FRED is cleared in
+ * vmcs12.
+ */
+struct fred_msr_at_vmexit {
+	u64 fred_config;
+	u64 fred_rsp1;
+	u64 fred_rsp2;
+	u64 fred_rsp3;
+	u64 fred_stklvls;
+	u64 fred_ssp1;
+	u64 fred_ssp2;
+	u64 fred_ssp3;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -184,6 +215,16 @@ struct nested_vmx {
 	u64 pre_vmenter_s_cet;
 	u64 pre_vmenter_ssp;
 	u64 pre_vmenter_ssp_tbl;
+	u64 pre_vmenter_fred_config;
+	u64 pre_vmenter_fred_rsp1;
+	u64 pre_vmenter_fred_rsp2;
+	u64 pre_vmenter_fred_rsp3;
+	u64 pre_vmenter_fred_stklvls;
+	u64 pre_vmenter_fred_ssp1;
+	u64 pre_vmenter_fred_ssp2;
+	u64 pre_vmenter_fred_ssp3;
+
+	struct fred_msr_at_vmexit fred_msr_at_vmexit;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.51.0


