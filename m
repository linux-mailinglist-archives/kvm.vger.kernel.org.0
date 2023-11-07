Return-Path: <kvm+bounces-1050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B7E7E4841
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2CCA1C20C84
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF8736AEE;
	Tue,  7 Nov 2023 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BEORjZDB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06374358B5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:31:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C982125
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5T916OhqBqbSvF+bfK753LwTEnPyTXxluNJryek0/Bg=;
	b=BEORjZDBysahne2WhvFgkHAQPyaX+klno3bwEbnC0UYE+2HdFGcYxeRG40jXpHh1Jn/RYb
	CxQEg21zcMr1JgmhISdYyVbU/Cz1nm8vjZ/eUBh+Zt4p3wGgQqr79m9t5+UO/6QZ/v9seu
	y6j1y23YAtR8GhzRrIfvETsRhkhJgag=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-KCeLLp_TNoK1oIQhgj-Fqg-1; Tue, 07 Nov 2023 13:31:21 -0500
X-MC-Unique: KCeLLp_TNoK1oIQhgj-Fqg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5079c865541so1509336e87.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:31:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381568; x=1699986368;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5T916OhqBqbSvF+bfK753LwTEnPyTXxluNJryek0/Bg=;
        b=dB51GN9kOzDMvxi51GpJfbu4SjZP11fTWMRr3W8n0Jt0noQpCq6bmZMJgjdruez0Ri
         zklWaEjKUmKfYyQ6EfMmuMqiuYftkhSK3udywT2YVwZwVL36ZHdddVPkha1BvjCkmQW3
         Fc6DxC33yaZv6LkkCegTvOlIpjyfLFU5LS+AevlQh3OZlHcORnXm4brlYLNAyVlbeDaw
         a/HY3oOD30os87+vuDn2N5PzLnnDC+5+xkT3c8FRePfIetYce7Q8WGnROOXb4QRyddrH
         dKsTwFJXGVwz+RBKpurUuY6WHO5wYEIoUqD4WTfh+oRQQdMAjvm48jeafOGDy4baz1Ld
         wF2w==
X-Gm-Message-State: AOJu0YxANubV1EAUw5CoilmlsSmGj4gKHGePRcIeYSubTNDYyyAxVcPA
	AxKByFegGzmqRONN7HFN/+4vEn+T38dn713/97Ac4A3LfzPAp69WOXb8GkHErTbwSRsXmQBZKZ1
	vI+utdtu6EVZX
X-Received: by 2002:a05:6512:138a:b0:509:4767:57f9 with SMTP id fc10-20020a056512138a00b00509476757f9mr14592369lfb.55.1699381568555;
        Tue, 07 Nov 2023 10:26:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY5U6ZHCbnB22Laaorp8UUPfX4fVga+9jP7ekGNOGpsJcbnII5g2ApSfDHdjEjIugevNu1qA==
X-Received: by 2002:a05:6512:138a:b0:509:4767:57f9 with SMTP id fc10-20020a056512138a00b00509476757f9mr14592351lfb.55.1699381568183;
        Tue, 07 Nov 2023 10:26:08 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id n11-20020a5d400b000000b0032179c4a46dsm2992138wrp.100.2023.11.07.10.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:26:07 -0800 (PST)
Message-ID: <56ea03e7db1d2b53f54d6779e76c7e9a99e19356.camel@redhat.com>
Subject: Re: [PATCH 11/14] KVM: nVMX: hyper-v: Introduce
 nested_vmx_evmptr12() and nested_vmx_is_evmptr12_valid() helpers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Nov 2023 20:26:06 +0200
In-Reply-To: <20231025152406.1879274-12-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
	 <20231025152406.1879274-12-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-25 at 17:24 +0200, Vitaly Kuznetsov wrote:
> 'vmx->nested.hv_evmcs_vmptr' accesses are all over the place so hiding
> 'hv_evmcs_vmptr' under 'ifdef CONFIG_KVM_HYPERV' would take a lot of
> ifdefs. Introduce 'nested_vmx_evmptr12()' accessor and
> 'nested_vmx_is_evmptr12_valid()' checker instead. Note, several explicit
> 
>   nested_vmx_evmptr12(vmx) != EVMPTR_INVALID
> 
> comparisons exist for a reson: 'nested_vmx_is_evmptr12_valid()' also checks
> against 'EVMPTR_MAP_PENDING' and in these places this is undesireable. It
> is possible to e.g. introduce 'nested_vmx_is_evmptr12_invalid()' and turn
> these sites into
> 
>   !nested_vmx_is_evmptr12_invalid(vmx)
> 
> eliminating the need for 'nested_vmx_evmptr12()' but this seems to create
> even more confusion.
Makes sense.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/hyperv.h | 10 +++++++++
>  arch/x86/kvm/vmx/nested.c | 44 +++++++++++++++++++--------------------
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  3 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 933ef6cad5e6..ba1a95ea72b7 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "vmcs12.h"
> +#include "vmx.h"
>  
>  #define EVMPTR_INVALID (-1ULL)
>  #define EVMPTR_MAP_PENDING (-2ULL)
> @@ -20,7 +21,14 @@ enum nested_evmptrld_status {
>  	EVMPTRLD_ERROR,
>  };
>  
> +struct vcpu_vmx;
> +
>  #ifdef CONFIG_KVM_HYPERV
> +static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
> +static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
> +{
> +	return evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
> +}
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> @@ -30,6 +38,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else
> +static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; }
> +static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx) { return false; }
>  static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
>  static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
>  static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d0d735974b2c..b45586588bae 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
>  	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
>  	 * fields and thus must be synced.
>  	 */
> -	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
> +	if (nested_vmx_evmptr12(to_vmx(vcpu)) != EVMPTR_INVALID)
>  		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	return kvm_skip_emulated_instruction(vcpu);
> @@ -194,7 +194,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
>  	 * can't be done if there isn't a current VMCS.
>  	 */
>  	if (vmx->nested.current_vmptr == INVALID_GPA &&
> -	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	    !nested_vmx_is_evmptr12_valid(vmx))
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	return nested_vmx_failValid(vcpu, vm_instruction_error);
> @@ -230,7 +230,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (nested_vmx_is_evmptr12_valid(vmx)) {
>  		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
>  		vmx->nested.hv_evmcs = NULL;
>  	}
> @@ -2011,7 +2011,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  		return EVMPTRLD_DISABLED;
>  	}
>  
> -	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
> +	if (unlikely(evmcs_gpa != nested_vmx_evmptr12(vmx))) {
>  		vmx->nested.current_vmptr = INVALID_GPA;
>  
>  		nested_release_evmcs(vcpu);
> @@ -2089,7 +2089,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (nested_vmx_is_evmptr12_valid(vmx))
>  		copy_vmcs12_to_enlightened(vmx);
>  	else
>  		copy_vmcs12_to_shadow(vmx);
> @@ -2243,7 +2243,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  	u32 exec_control;
>  	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
>  
> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx))
>  		prepare_vmcs02_early_rare(vmx, vmcs12);
>  
>  	/*
> @@ -2538,11 +2538,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	bool load_guest_pdptrs_vmcs12 = false;
>  
> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
>  		prepare_vmcs02_rare(vmx, vmcs12);
>  		vmx->nested.dirty_vmcs12 = false;
>  
> -		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) ||
> +		load_guest_pdptrs_vmcs12 = !nested_vmx_is_evmptr12_valid(vmx) ||
>  			!(vmx->nested.hv_evmcs->hv_clean_fields &
>  			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>  	}
> @@ -2665,7 +2665,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	 * bits when it changes a field in eVMCS. Mark all fields as clean
>  	 * here.
>  	 */
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (nested_vmx_is_evmptr12_valid(vmx))
>  		vmx->nested.hv_evmcs->hv_clean_fields |=
>  			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
> @@ -3173,7 +3173,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  	 * properly reflected.
>  	 */
>  	if (guest_cpuid_has_evmcs(vcpu) &&
> -	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
> +	    nested_vmx_evmptr12(vmx) == EVMPTR_MAP_PENDING) {
>  		enum nested_evmptrld_status evmptrld_status =
>  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
>  
> @@ -3543,7 +3543,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  
>  	load_vmcs12_host_state(vcpu, vmcs12);
>  	vmcs12->vm_exit_reason = exit_reason.full;
> -	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  	return NVMX_VMENTRY_VMEXIT;
>  }
> @@ -3576,7 +3576,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
> +	if (CC(!nested_vmx_is_evmptr12_valid(vmx) &&
>  	       vmx->nested.current_vmptr == INVALID_GPA))
>  		return nested_vmx_failInvalid(vcpu);
>  
> @@ -3591,7 +3591,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(vmcs12->hdr.shadow_vmcs))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (nested_vmx_is_evmptr12_valid(vmx)) {
>  		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
>  		/* Enlightened VMCS doesn't have launch state */
>  		vmcs12->launch_state = !launch;
> @@ -4336,11 +4336,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (nested_vmx_is_evmptr12_valid(vmx))
>  		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>  
>  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare =
> -		!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
> +		!nested_vmx_is_evmptr12_valid(vmx);
>  
>  	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
>  	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
> @@ -4861,7 +4861,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	}
>  
>  	if ((vm_exit_reason != -1) &&
> -	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
> +	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	/* in case we halted in L2 */
> @@ -5327,7 +5327,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  					   vmptr + offsetof(struct vmcs12,
>  							    launch_state),
>  					   &zero, sizeof(zero));
> -	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
> +	} else if (vmx->nested.hv_evmcs && vmptr == nested_vmx_evmptr12(vmx)) {
>  		nested_release_evmcs(vcpu);
>  	}
>  
> @@ -5367,7 +5367,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  	/* Decode instruction info and find the field to read */
>  	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
>  
> -	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (!nested_vmx_is_evmptr12_valid(vmx)) {
>  		/*
>  		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
>  		 * any VMREAD sets the ALU flags for VMfailInvalid.
> @@ -5593,7 +5593,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
>  		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
>  
>  	/* Forbid normal VMPTRLD if Enlightened version was used */
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (nested_vmx_is_evmptr12_valid(vmx))
>  		return 1;
>  
>  	if (vmx->nested.current_vmptr != vmptr) {
> @@ -5656,7 +5656,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> -	if (unlikely(evmptr_is_valid(to_vmx(vcpu)->nested.hv_evmcs_vmptr)))
> +	if (unlikely(nested_vmx_is_evmptr12_valid(to_vmx(vcpu))))
>  		return 1;
>  
>  	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
> @@ -6442,7 +6442,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
>  
>  			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
> -			if (vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
> +			if (nested_vmx_evmptr12(vmx) != EVMPTR_INVALID)
>  				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
>  
>  			if (is_guest_mode(vcpu) &&
> @@ -6498,7 +6498,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	} else  {
>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
> -			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +			if (nested_vmx_is_evmptr12_valid(vmx))
>  				/*
>  				 * L1 hypervisor is not obliged to keep eVMCS
>  				 * clean fields data always up-to-date while
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index b0f2e26c1aea..0cedb80c5c94 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -58,7 +58,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
>  
>  	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
>  	return vmx->nested.current_vmptr != -1ull ||
> -		vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID;
> +		nested_vmx_evmptr12(vmx) != EVMPTR_INVALID;
>  }
>  
>  static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


