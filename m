Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3429C57191C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiGLLyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiGLLya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:54:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E29024B0E9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657626843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXVihHkqE7HqNYcD5UDFlY8SMlA1TWGMKcVtlGwdJ3Y=;
        b=L6QB3ccPTCKth4sW1FmD+wdGBSlD72hZpgRodRJQRqLi65NrLFq9zj7RCJmDgQQ9yo+pp9
        BavFTx2vdzd01/MAqGl7k3AEeXySAO+0CV+uDIq5AEwbuDu1Gn0BSj1upmeH/SwnsZGz0b
        5E5dQ5e0rHBMVx6MV/fZlGog5tItgXA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-j9KGePvIMweuNyOpk407iw-1; Tue, 12 Jul 2022 07:54:02 -0400
X-MC-Unique: j9KGePvIMweuNyOpk407iw-1
Received: by mail-qt1-f198.google.com with SMTP id z14-20020ac8454e000000b0031ead2bfe77so6569145qtn.2
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MXVihHkqE7HqNYcD5UDFlY8SMlA1TWGMKcVtlGwdJ3Y=;
        b=XtGjAy8WmVvPwl0Z3RMpyPXdcq1EqaiJ5ef5vLhCGq7b+Epjb+2g344UjVa7bSdmU8
         a83HYpQGnFYp44vumLp9M+p9/FMu1fcHE78j50ErmQfcIgNImDQ6qD5ddg8fB2oppwlh
         HcD+XBwwM86qdPeqhbn5tA1yqghJZlV4YitmUVXBZxiJE0iAyy/QTLHZ1q1HitPDZ5sr
         V69+67fMndXi5lN/zefI2XwK3qKOg0lN+WkIg8z+Ye+CD0RbBM2PZCui7oRuZSgpqq6J
         HMIKwYGy/yBOheySxuPVqTqtM8V4NHgqr1sx32qwTKSQai5FpbxsipqnVB7dPZCwqR3W
         YqyQ==
X-Gm-Message-State: AJIora9MFTtwJ1fSTnDl+/Z4AtBLb8CzF27mHRoidLy6JL+ZxZFGPiKZ
        vIbUlxFcl5zPf+I2IPQLEfGM5lfNBd1EGUr5LlpeHQ4dCvrf+/r72fPt8WYUpBPGbRzeUMI4IaT
        b2XsrsnZ2Du2f
X-Received: by 2002:ac8:5714:0:b0:31b:940a:fafa with SMTP id 20-20020ac85714000000b0031b940afafamr17809921qtw.599.1657626841474;
        Tue, 12 Jul 2022 04:54:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uUWqywJxNVVGmzGsA8HJhUrPDaHrj+/VepaC0lqpjY0BEEAqHUxBL5RsVu7mtuvakOVn1yJw==
X-Received: by 2002:ac8:5714:0:b0:31b:940a:fafa with SMTP id 20-20020ac85714000000b0031b940afafamr17809905qtw.599.1657626841213;
        Tue, 12 Jul 2022 04:54:01 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bi23-20020a05620a319700b006a6c552736asm8577657qkb.119.2022.07.12.04.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:54:00 -0700 (PDT)
Message-ID: <9d5579f4667944d3186e5c1597c88126ef8d52a6.camel@redhat.com>
Subject: Re: [PATCH v3 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:53:57 +0300
In-Reply-To: <20220708144223.610080-10-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-10-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> Enlightened VMCS v1 got updated and now includes the required fields
> for TSC scaling and loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT
> features. For Hyper-V on KVM enablement, KVM can just observe VMX control
> MSRs and use the features (with or without eVMCS) when
> possible. Hyper-V on KVM case is trickier because of live migration:
> the new features require explicit enablement from VMM to not break
> it. Luckily, the updated eVMCS revision comes with a feature bit in
> CPUID.0x4000000A.EBX.

Very tiny nitpick about the commit summary. It might make sense instead
of specifying which new fields added, just say that this patch
updates the EVMCS to 2022 revision, or something, because the patch
series as a whole addes some other fields (even if as commented out),
and a new cpuid bit to detect the new eVMCS revision.

Again, this is a very tiny nitpick, feel free to ignore.

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c     |  2 +-
>  arch/x86/kvm/vmx/evmcs.c  | 88 +++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/vmx/evmcs.h  | 17 ++------
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  5 files changed, 78 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index b666902da4d9..406c5e273983 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2562,7 +2562,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		case HYPERV_CPUID_NESTED_FEATURES:
>  			ent->eax = evmcs_ver;
>  			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
> -
> +			ent->ebx |= HV_X64_NESTED_EVMCS1_2022_UPDATE;
>  			break;
>  
>  		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 8bea5dea0341..52a53debd806 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -368,7 +368,60 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> +enum evmcs_v1_revision {
> +	EVMCSv1_2016,
> +	EVMCSv1_2022,
> +};
> +
> +enum evmcs_unsupported_ctrl_type {
> +	EVMCS_EXIT_CTLS,
> +	EVMCS_ENTRY_CTLS,
> +	EVMCS_2NDEXEC,
> +	EVMCS_PINCTRL,
> +	EVMCS_VMFUNC,
> +};
> +
> +static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
> +				      enum evmcs_unsupported_ctrl_type ctrl_type)
Tiny nitpick: line break not aligned in the above.

> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	enum evmcs_v1_revision evmcs_rev = EVMCSv1_2016;
> +
> +	if (!hv_vcpu)
> +		return 0;
> +
> +	if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
> +		evmcs_rev = EVMCSv1_2022;
> +
> +	switch (ctrl_type) {
> +	case EVMCS_EXIT_CTLS:
> +		if (evmcs_rev == EVMCSv1_2016)
> +			return EVMCS1_UNSUPPORTED_VMEXIT_CTRL |
> +				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		else
> +			return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +	case EVMCS_ENTRY_CTLS:
> +		if (evmcs_rev == EVMCSv1_2016)
> +			return EVMCS1_UNSUPPORTED_VMENTRY_CTRL |
> +				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		else
> +			return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +	case EVMCS_2NDEXEC:
> +		if (evmcs_rev == EVMCSv1_2016)
> +			return EVMCS1_UNSUPPORTED_2NDEXEC |
> +				SECONDARY_EXEC_TSC_SCALING;
> +		else
> +			return EVMCS1_UNSUPPORTED_2NDEXEC;
> +	case EVMCS_PINCTRL:
> +		return EVMCS1_UNSUPPORTED_PINCTRL;
> +	case EVMCS_VMFUNC:
> +		return EVMCS1_UNSUPPORTED_VMFUNC;
> +	}
> +
> +	return 0;
> +}
> +
> +void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
>  {
>  	u32 ctl_low = (u32)*pdata;
>  	u32 ctl_high = (u32)(*pdata >> 32);
> @@ -380,72 +433,73 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>  	switch (msr_index) {
>  	case MSR_IA32_VMX_EXIT_CTLS:
>  	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_EXIT_CTLS);
>  		break;
>  	case MSR_IA32_VMX_ENTRY_CTLS:
>  	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_ENTRY_CTLS);
>  		break;
>  	case MSR_IA32_VMX_PROCBASED_CTLS2:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_2NDEXEC);
>  		break;
>  	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>  	case MSR_IA32_VMX_PINBASED_CTLS:
> -		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> +		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
>  		break;
>  	case MSR_IA32_VMX_VMFUNC:
> -		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
> +		ctl_low &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_VMFUNC);
>  		break;
>  	}
>  
>  	*pdata = ctl_low | ((u64)ctl_high << 32);
>  }
>  
> -int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
> +int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  {
>  	int ret = 0;
>  	u32 unsupp_ctl;
>  
>  	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
> -		EVMCS1_UNSUPPORTED_PINCTRL;
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported pin-based VM-execution controls",
> +			"eVMCS: unsupported pin-based VM-execution controls: ",
>  			unsupp_ctl);
>  		ret = -EINVAL;
>  	}
>  
>  	unsupp_ctl = vmcs12->secondary_vm_exec_control &
> -		EVMCS1_UNSUPPORTED_2NDEXEC;
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_2NDEXEC);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported secondary VM-execution controls",
> +			"eVMCS: unsupported secondary VM-execution controls: ",
>  			unsupp_ctl);
>  		ret = -EINVAL;
>  	}
>  
>  	unsupp_ctl = vmcs12->vm_exit_controls &
> -		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_EXIT_CTLS);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported VM-exit controls",
> +			"eVMCS: unsupported VM-exit controls: ",
>  			unsupp_ctl);
>  		ret = -EINVAL;
>  	}
>  
>  	unsupp_ctl = vmcs12->vm_entry_controls &
> -		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_ENTRY_CTLS);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported VM-entry controls",
> +			"eVMCS: unsupported VM-entry controls: ",
>  			unsupp_ctl);
>  		ret = -EINVAL;
>  	}
>  
> -	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
> +	unsupp_ctl = vmcs12->vm_function_control &
> +		evmcs_get_unsupported_ctls(vcpu, EVMCS_VMFUNC);
>  	if (unsupp_ctl) {
>  		trace_kvm_nested_vmenter_failed(
> -			"eVMCS: unsupported VM-function controls",
> +			"eVMCS: unsupported VM-function controls: ",
>  			unsupp_ctl);
>  		ret = -EINVAL;
>  	}
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index f886a8ff0342..4b809c79ae63 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -37,16 +37,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   *	EPTP_LIST_ADDRESS               = 0x00002024,
>   *	VMREAD_BITMAP                   = 0x00002026,
>   *	VMWRITE_BITMAP                  = 0x00002028,
> - *
> - *	TSC_MULTIPLIER                  = 0x00002032,
>   *	PLE_GAP                         = 0x00004020,
>   *	PLE_WINDOW                      = 0x00004022,
>   *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
> - *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
> - *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
> - *
> - * Currently unsupported in KVM:
> - *	GUEST_IA32_RTIT_CTL		= 0x00002814,
>   */
>  #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
>  				    PIN_BASED_VMX_PREEMPTION_TIMER)
> @@ -58,12 +51,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  	 SECONDARY_EXEC_ENABLE_PML |					\
>  	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
>  	 SECONDARY_EXEC_SHADOW_VMCS |					\
> -	 SECONDARY_EXEC_TSC_SCALING |					\
>  	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
>  #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
> -	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
> -	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> -#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> +	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
>  struct evmcs_field {
> @@ -243,7 +234,7 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version);
> -void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
> -int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
> +void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
> +int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
>  
>  #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4fc84f0f5875..dcf3ee645212 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2891,7 +2891,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
> -		return nested_evmcs_check_controls(vmcs12);
> +		return nested_evmcs_check_controls(vcpu, vmcs12);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c30115b9cb33..b4915d841357 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1858,7 +1858,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 */
>  		if (!msr_info->host_initiated &&
>  		    vmx->nested.enlightened_vmcs_enabled)
> -			nested_evmcs_filter_control_msr(msr_info->index,
> +			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
>  							&msr_info->data);
>  		break;
>  	case MSR_IA32_RTIT_CTL:


Looks all good.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




