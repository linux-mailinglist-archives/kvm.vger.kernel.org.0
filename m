Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98866974C9
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 04:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjBODUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 22:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBODUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 22:20:44 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B563A2B288;
        Tue, 14 Feb 2023 19:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676431243; x=1707967243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4q6PHgjH7OmcRy57Dx4NMVy5X/QMiZB4rvFsDHTRkW4=;
  b=eLjFKzs7vdupXU1sTipUmvgG0ZgIwT7RiOeIXvB3a5UgsHtyY0QAKbqr
   8ZdH5zCjC4zoIoBK4hOFSngcPr2nRLfBrG1ElczK2lg+3B6QWlpMoGwJP
   I87nx47etSXE6GUAOLXRW0YkRuI37yuUVzoMWoJC+ri5oSnAFM7yKpXyU
   zm3RXSSFDvZl3GywstoXxWeWzebV8wMq33gNj8Py8ieNY2VdAytKmAR+E
   FwHpB97UeMt0ElwDCf/k9ANAckFyNyeuiFA1kPMs8sq0GBLs0FT5nFQrs
   Jgxnami4yBiHR4x1Moe8WexhXA1621evxamUGml5fUo+On0lKoc/uPEHu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="310965402"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="310965402"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 19:20:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699793667"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="699793667"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.117]) ([10.249.171.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 19:20:41 -0800
Message-ID: <953949b9-02fc-af3f-d7fe-6c15635a2ee8@intel.com>
Date:   Wed, 15 Feb 2023 11:20:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 03/21] KVM: x86: Add macros to track first...last VMX
 feature MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-4-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230210003148.2646712-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/2023 8:31 AM, Sean Christopherson wrote:
> Add macros to track the range of VMX feature MSRs that are emulated by
> KVM to reduce the maintenance cost of extending the set of emulated MSRs.
> 
> Note, KVM doesn't necessarily emulate all known/consumed VMX MSRs, e.g.
> PROCBASED_CTLS3 is consumed by KVM to enable IPI virtualization, but is
> not emulated as KVM doesn't emulate/virtualize IPI virtualization for
> nested guests.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/svm/svm.c | 2 +-
>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>   arch/x86/kvm/x86.h     | 8 ++++++++
>   3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b43775490074..a5b9ebd6f2c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4107,7 +4107,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>   {
>   	switch (index) {
>   	case MSR_IA32_MCG_EXT_CTL:
> -	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> +	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		return false;
>   	case MSR_IA32_SMBASE:
>   		if (!IS_ENABLED(CONFIG_KVM_SMM))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 47abd9101e68..ee86db130519 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1945,7 +1945,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
>   static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
> -	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> +	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		if (!nested)
>   			return 1;
>   		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
> @@ -2030,7 +2030,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
>   			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
>   		break;
> -	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> +	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		if (!nested_vmx_allowed(vcpu))
>   			return 1;
>   		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
> @@ -2366,7 +2366,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vmx->msr_ia32_sgxlepubkeyhash
>   			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
>   		break;
> -	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> +	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		if (!msr_info->host_initiated)
>   			return 1; /* they are read-only */
>   		if (!nested_vmx_allowed(vcpu))
> @@ -6960,7 +6960,7 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
>   		 * real mode.
>   		 */
>   		return enable_unrestricted_guest || emulate_invalid_guest_state;
> -	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
> +	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>   		return nested;
>   	case MSR_AMD64_VIRT_SPEC_CTRL:
>   	case MSR_AMD64_TSC_RATIO:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 754190af1791..4bc483d082ee 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -40,6 +40,14 @@ void kvm_spurious_fault(void);
>   	failed;								\
>   })
>   
> +/*
> + * The first...last VMX feature MSRs that are emulated by KVM.  This may or may
> + * not cover all known VMX MSRs, as KVM doesn't emulate an MSR until there's an
> + * associated feature that KVM supports for nested virtualization.
> + */
> +#define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
> +#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
> +
>   #define KVM_DEFAULT_PLE_GAP		128
>   #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
>   #define KVM_DEFAULT_PLE_WINDOW_GROW	2

