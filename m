Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD72F2ED0
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 13:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbhALMQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 07:16:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732873AbhALMQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 07:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610453717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ovKUsdhx+K2sEOzDkyXjp+F1QS460AJdQNlzt4NEb2Y=;
        b=BJm+IQgfsqjTtjR9KaaoLB0LrAPIGdSq0kLQiPdSBxWUuOoP32nX1t8JdSQB6BfITaK8zL
        VEdplWbVLEu7IBCwmEasmRTMP8jjCPxpIfw0wj51hbRact0BoXZ2MkYlHYUoYr2fLeVCtD
        q5E30KPxL+BU/OthNCsbeNqlX6MyPpI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-eNcEWiEQP1aGWEbUAr0YMg-1; Tue, 12 Jan 2021 07:15:15 -0500
X-MC-Unique: eNcEWiEQP1aGWEbUAr0YMg-1
Received: by mail-ej1-f69.google.com with SMTP id r26so923709ejx.6
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 04:15:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ovKUsdhx+K2sEOzDkyXjp+F1QS460AJdQNlzt4NEb2Y=;
        b=oNpIe8MlFRsWu6obbR9a3iZv2qTKXLnnGItz8FbjScI8qy/LwViWnzKaRgDzA0Sob2
         5r9zQbh0Wq/Od1718aSs/qea/eqNZ4kJWSD3QP6m9UXYQooo+XUf6ZyEDGIUKDWgwPEV
         wxk4ebkgUo56RRM++jCVNaAyskwUMX5bIkY3b8UhK2e5xOfIGSXT4VIi5Hkrp91JTOfK
         Y5mSLHf5RpDCgaq9kfeLn1QVsepYOliiSq9yPiJk4JDnPqjX2MaYCEHCW+OJjhucoieS
         Ek9weVaq+mxyNHhGFbgXg7P4mlYrMJzmBzKNn+qaimIQbNtVdRzVRMf9No3/9+qOyhE2
         7ssQ==
X-Gm-Message-State: AOAM533/eEalx6RVIuFiojsgDX9nr5JvO5Ro5w7N6wU56/BYoFa7ZA5l
        a2VtvWW+ohzIceU8r7+68kQdEadg4wne8nqoqDDUUIbPgepPjG9PSs2yrwQCPO15Ml7PpXBn16T
        Culk+g6ALaklF
X-Received: by 2002:a17:906:cd06:: with SMTP id oz6mr3043340ejb.25.1610453714083;
        Tue, 12 Jan 2021 04:15:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBNUL7RYrMmiooKbGdjnheXY+j3zeD8b5AvGhUZPjMtfE1dOCBahdI/DQptE6L0UxeNYDUrg==
X-Received: by 2002:a17:906:cd06:: with SMTP id oz6mr3043316ejb.25.1610453713691;
        Tue, 12 Jan 2021 04:15:13 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16sm1361105eds.10.2021.01.12.04.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 04:15:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered
 by VM instructions
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
Date:   Tue, 12 Jan 2021 13:15:11 +0100
Message-ID: <87eeiq8i7k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei Huang <wei.huang2@amd.com> writes:

> From: Bandan Das <bsd@redhat.com>
>
> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
> before checking VMCB's instruction intercept. If EAX falls into such
> memory areas, #GP is triggered before VMEXIT. This causes problem under
> nested virtualization. To solve this problem, KVM needs to trap #GP and
> check the instructions triggering #GP. For VM execution instructions,
> KVM emulates these instructions; otherwise it re-injects #GP back to
> guest VMs.
>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> Co-developed-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   8 +-
>  arch/x86/kvm/mmu.h              |   1 +
>  arch/x86/kvm/mmu/mmu.c          |   7 ++
>  arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h          |   8 ++
>  arch/x86/kvm/vmx/vmx.c          |   2 +-
>  arch/x86/kvm/x86.c              |  37 +++++++-
>  7 files changed, 146 insertions(+), 74 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3d6616f6f6ef..0ddc309f5a14 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
>   *			     due to an intercepted #UD (see EMULTYPE_TRAP_UD).
>   *			     Used to test the full emulator from userspace.
>   *
> - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
> + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMware
>   *			backdoor emulation, which is opt in via module param.
>   *			VMware backoor emulation handles select instructions
> - *			and reinjects the #GP for all other cases.
> + *			and reinjects #GP for all other cases. This also
> + *			handles other cases where #GP condition needs to be
> + *			handled and emulated appropriately
>   *
>   * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
>   *		 case the CR2/GPA value pass on the stack is valid.
> @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
>  #define EMULTYPE_SKIP		    (1 << 2)
>  #define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
>  #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
> -#define EMULTYPE_VMWARE_GP	    (1 << 5)
> +#define EMULTYPE_PARAVIRT_GP	    (1 << 5)
>  #define EMULTYPE_PF		    (1 << 6)
>  
>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 581925e476d6..1a2fff4e7140 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>  
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> +bool kvm_is_host_reserved_region(u64 gpa);

Just a suggestion: "kvm_gpa_in_host_reserved()" maybe? 

>  
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481aa29d..c5c4aaf01a1a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -50,6 +50,7 @@
>  #include <asm/io.h>
>  #include <asm/vmx.h>
>  #include <asm/kvm_page_track.h>
> +#include <asm/e820/api.h>
>  #include "trace.h"
>  
>  extern bool itlb_multihit_kvm_mitigation;
> @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>  
> +bool kvm_is_host_reserved_region(u64 gpa)
> +{
> +	return e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
> +}

While _e820__mapped_any()'s doc says '..  checks if any part of the
range <start,end> is mapped ..' it seems to me that the real check is
[start, end) so we should use 'gpa' instead of 'gpa-1', no?

> +EXPORT_SYMBOL_GPL(kvm_is_host_reserved_region);
> +
>  void kvm_mmu_zap_all(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..74620d32aa82 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -288,6 +288,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(svm);
>  			svm_set_gif(svm, true);
> +			clr_exception_intercept(svm, GP_VECTOR);
>  
>  			/*
>  			 * Free the nested guest state, unless we are in SMM.
> @@ -309,6 +310,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> +	/* Enable GP interception for SVM instructions if needed */
> +	if (efer & EFER_SVME)
> +		set_exception_intercept(svm, GP_VECTOR);
> +
>  	return 0;
>  }
>  
> @@ -1957,22 +1962,104 @@ static int ac_interception(struct vcpu_svm *svm)
>  	return 1;
>  }
>  
> +static int vmload_interception(struct vcpu_svm *svm)
> +{
> +	struct vmcb *nested_vmcb;
> +	struct kvm_host_map map;
> +	int ret;
> +
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> +	if (ret) {
> +		if (ret == -EINVAL)
> +			kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	nested_vmcb = map.hva;
> +
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +
> +	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +	return ret;
> +}
> +
> +static int vmsave_interception(struct vcpu_svm *svm)
> +{
> +	struct vmcb *nested_vmcb;
> +	struct kvm_host_map map;
> +	int ret;
> +
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> +	if (ret) {
> +		if (ret == -EINVAL)
> +			kvm_inject_gp(&svm->vcpu, 0);
> +		return 1;
> +	}
> +
> +	nested_vmcb = map.hva;
> +
> +	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> +
> +	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
> +	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> +
> +	return ret;
> +}
> +
> +static int vmrun_interception(struct vcpu_svm *svm)
> +{
> +	if (nested_svm_check_permissions(svm))
> +		return 1;
> +
> +	return nested_svm_vmrun(svm);
> +}
> +
> +/* Emulate SVM VM execution instructions */
> +static int svm_emulate_vm_instr(struct kvm_vcpu *vcpu, u8 modrm)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	switch (modrm) {
> +	case 0xd8: /* VMRUN */
> +		return vmrun_interception(svm);
> +	case 0xda: /* VMLOAD */
> +		return vmload_interception(svm);
> +	case 0xdb: /* VMSAVE */
> +		return vmsave_interception(svm);
> +	default:
> +		/* inject a #GP for all other cases */
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return 1;
> +	}
> +}
> +
>  static int gp_interception(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	u32 error_code = svm->vmcb->control.exit_info_1;
> -
> -	WARN_ON_ONCE(!enable_vmware_backdoor);
> +	int rc;
>  
>  	/*
> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
> +	 * them has non-zero error codes.
>  	 */
>  	if (error_code) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  		return 1;
>  	}
> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +
> +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
> +	if (rc > 1)
> +		rc = svm_emulate_vm_instr(vcpu, rc);
> +	return rc;
>  }
>  
>  static bool is_erratum_383(void)
> @@ -2113,66 +2200,6 @@ static int vmmcall_interception(struct vcpu_svm *svm)
>  	return kvm_emulate_hypercall(&svm->vcpu);
>  }
>  
> -static int vmload_interception(struct vcpu_svm *svm)
> -{
> -	struct vmcb *nested_vmcb;
> -	struct kvm_host_map map;
> -	int ret;
> -
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> -	if (ret) {
> -		if (ret == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	nested_vmcb = map.hva;
> -
> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> -
> -	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -	return ret;
> -}
> -
> -static int vmsave_interception(struct vcpu_svm *svm)
> -{
> -	struct vmcb *nested_vmcb;
> -	struct kvm_host_map map;
> -	int ret;
> -
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
> -	if (ret) {
> -		if (ret == -EINVAL)
> -			kvm_inject_gp(&svm->vcpu, 0);
> -		return 1;
> -	}
> -
> -	nested_vmcb = map.hva;
> -
> -	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> -
> -	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
> -	kvm_vcpu_unmap(&svm->vcpu, &map, true);
> -
> -	return ret;
> -}
> -
> -static int vmrun_interception(struct vcpu_svm *svm)
> -{
> -	if (nested_svm_check_permissions(svm))
> -		return 1;
> -
> -	return nested_svm_vmrun(svm);
> -}
> -

Maybe if you'd do it the other way around and put gp_interception()
after vm{load,save,run}_interception(), the diff (and code churn)
would've been smaller? 

>  void svm_set_gif(struct vcpu_svm *svm, bool value)
>  {
>  	if (value) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..d5dffcf59afa 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -350,6 +350,14 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
>  	recalc_intercepts(svm);
>  }
>  
> +static inline bool is_exception_intercept(struct vcpu_svm *svm, u32 bit)
> +{
> +	struct vmcb *vmcb = get_host_vmcb(svm);
> +
> +	WARN_ON_ONCE(bit >= 32);
> +	return vmcb_is_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
> +}
> +
>  static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
>  {
>  	struct vmcb *vmcb = get_host_vmcb(svm);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2af05d3b0590..5fac2f7cba24 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4774,7 +4774,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  			return 1;
>  		}
> -		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +		return kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
>  	}
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..c3662fc3b1bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7014,7 +7014,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> -	if (emulation_type & EMULTYPE_VMWARE_GP) {
> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>  		return 1;
>  	}
> @@ -7267,6 +7267,28 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  	return false;
>  }
>  
> +static int is_vm_instr_opcode(struct x86_emulate_ctxt *ctxt)

Nit: it seems we either return '0' or 'ctxt->modrm' which is 'u8', so
'u8' instead of 'int' maybe?

> +{
> +	unsigned long rax;
> +
> +	if (ctxt->b != 0x1)
> +		return 0;
> +
> +	switch (ctxt->modrm) {
> +	case 0xd8: /* VMRUN */
> +	case 0xda: /* VMLOAD */
> +	case 0xdb: /* VMSAVE */
> +		rax = kvm_register_read(emul_to_vcpu(ctxt), VCPU_REGS_RAX);
> +		if (!kvm_is_host_reserved_region(rax))
> +			return 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return ctxt->modrm;
> +}
> +
>  static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
>  {
>  	switch (ctxt->opcode_len) {
> @@ -7305,6 +7327,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	bool writeback = true;
>  	bool write_fault_to_spt;
> +	int vminstr;
>  
>  	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
>  		return 1;
> @@ -7367,10 +7390,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		}
>  	}
>  
> -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> -	    !is_vmware_backdoor_opcode(ctxt)) {
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -		return 1;
> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
> +		vminstr = is_vm_instr_opcode(ctxt);
> +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +			return 1;
> +		}
> +		if (vminstr)
> +			return vminstr;
>  	}
>  
>  	/*

-- 
Vitaly

