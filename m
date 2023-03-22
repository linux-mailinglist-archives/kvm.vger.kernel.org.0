Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBDC6C44AD
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 09:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCVIPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 04:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCVIPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 04:15:33 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5555457D08
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 01:15:31 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id o12so69370217edb.9
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 01:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679472930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yX1PylJsbOJ+Mtm+afJQlEAtJMN9YyqyzP0lJvmSfe4=;
        b=H0DwALhNDlE/J8V0xykIX5ECvWWI3DSHDWw+50X4tY24ZMkyEimoUuHVxhbRdkTXjA
         7/dAvvsIlM0e2pKgffcwBegoinBohHhmcWjohgdzm2xyyObozpzQ/1ZAUIZ9whpMzs2R
         j9/0g6s0vtRI+JTRMKwEYOMefRXXDVWxAuvlLpD6GkNqXY58I24a4verkBpGOyYQFCzW
         FB66iWQUok8lxZSfD4yVNsfJ3sBLIvOmeoMx5ij++JnSR+xQUgikfrQ9BNWrQ0QlOGdV
         JxOUEH7hmKPBFD5uLL5V+ATqVM2iAEgBqlcTkj4/M7TQOCfES2vRq+B1Q/lbUa0Q+sT0
         Nu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679472930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yX1PylJsbOJ+Mtm+afJQlEAtJMN9YyqyzP0lJvmSfe4=;
        b=n2ladRNzvjx+aBsV+h6mrzvuBDt9yqv1MQfEUGDtP/NNH9yxxlikuTNkkNG6hr3PuK
         8o3xYXg7MceJOtfAylbYExipsgVWVv4EUHiytpQgZbGoixyOo1JTqTF0pb9zRmT03ir8
         0SWKL5hGjkG7JUs42TClmWsrj5zm3OSkhvY7nkudgzt72tz5ldDRGuhd2K2IFB35JySN
         h2AuDIcZ9VIvklwO0LIBimTBB77cm1vmd/6FxQRp+m0BgLW2DGkQ8w6swcDkEN2kZNCO
         e+H1AwmufWd+3i9XmRre4k4uiK7YEKqnN++jB32PLoILaVrZ083SWRO7TDKYsw9VHCSA
         B3tw==
X-Gm-Message-State: AO0yUKU7eZSfbxnuTI6VxmvMn2d+amRHFEDaWIEotLDKB9a8JcSaS4rd
        KBAXahRA6oSdHfttoVDqqolvQw==
X-Google-Smtp-Source: AK7set/EaLANEGLX2Ch/dcG5mmfP8oVSyWtGJBvtDS60cnw2xvm1moXQgOY193jq2AapsyHx8UYEqA==
X-Received: by 2002:a17:906:5a5c:b0:8f3:8bfd:a8e with SMTP id my28-20020a1709065a5c00b008f38bfd0a8emr1429648ejc.26.1679472929834;
        Wed, 22 Mar 2023 01:15:29 -0700 (PDT)
Received: from ?IPV6:2003:f6:af46:bf00:c0c2:695b:730f:946e? (p200300f6af46bf00c0c2695b730f946e.dip0.t-ipconnect.de. [2003:f6:af46:bf00:c0c2:695b:730f:946e])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090630c400b0092b5384d6desm6808314ejb.153.2023.03.22.01.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 01:15:29 -0700 (PDT)
Message-ID: <3b3f2e12-4812-af5f-6525-2c29fe035e9e@grsecurity.net>
Date:   Wed, 22 Mar 2023 09:15:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/6] KVM: x86: Revert MSR_IA32_FLUSH_CMD.FLUSH_L1D
 enabling
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
 <20230322011440.2195485-2-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230322011440.2195485-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.03.23 02:14, Sean Christopherson wrote:
> Revert the recently added virtualizing of MSR_IA32_FLUSH_CMD, as both
> the VMX and SVM are fatally buggy to guests that use MSR_IA32_FLUSH_CMD or
> MSR_IA32_PRED_CMD, and because the entire foundation of the logic is
> flawed.
> 
> The most immediate problem is an inverted check on @cmd that results in
> rejecting legal values.  SVM doubles down on bugs and drops the error,
> i.e. silently breaks all guest mitigations based on the command MSRs.
> 
> The next issue is that neither VMX nor SVM was updated to mark
> MSR_IA32_FLUSH_CMD as being a possible passthrough MSR,
> which isn't hugely problematic, but does break MSR filtering and triggers
> a WARN on VMX designed to catch this exact bug.
> 
> The foundational issues stem from the MSR_IA32_FLUSH_CMD code reusing
> logic from MSR_IA32_PRED_CMD, which in turn was likely copied from KVM's
> support for MSR_IA32_SPEC_CTRL.  The copy+paste from MSR_IA32_SPEC_CTRL
> was misguided as MSR_IA32_PRED_CMD (and MSR_IA32_FLUSH_CMD) is a
> write-only MSR, i.e. doesn't need the same "deferred passthrough"
> shenanigans as MSR_IA32_SPEC_CTRL.
> 
> Revert all MSR_IA32_FLUSH_CMD enabling in one fell swoop so that there is
> no point where KVM advertises, but does not support, L1D_FLUSH.
> 
> This reverts commits 45cf86f26148e549c5ba4a8ab32a390e4bde216e,
> 723d5fb0ffe4c02bd4edf47ea02c02e454719f28, and
> a807b78ad04b2eaa348f52f5cc7702385b6de1ee.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lkml.kernel.org/r/20230317190432.GA863767%40dev-arch.thelio-3990X
> Cc: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c      |  2 +-
>  arch/x86/kvm/svm/svm.c    | 43 ++++++++-----------------
>  arch/x86/kvm/vmx/nested.c |  3 --
>  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++-------------------------
>  4 files changed, 39 insertions(+), 77 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9583a110cf5f..599aebec2d52 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -653,7 +653,7 @@ void kvm_set_cpu_caps(void)
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 70183d2271b5..252e7f37e4e2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2869,28 +2869,6 @@ static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
>  	return 0;
>  }
>  
> -static int svm_set_msr_ia32_cmd(struct kvm_vcpu *vcpu, struct msr_data *msr,
> -				bool guest_has_feat, u64 cmd,
> -				int x86_feature_bit)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	if (!msr->host_initiated && !guest_has_feat)
> -		return 1;
> -
> -	if (!(msr->data & ~cmd))
> -		return 1;
> -	if (!boot_cpu_has(x86_feature_bit))
> -		return 1;
> -	if (!msr->data)
> -		return 0;
> -
> -	wrmsrl(msr->index, cmd);
> -	set_msr_interception(vcpu, svm->msrpm, msr->index, 0, 1);
> -
> -	return 0;
> -}
> -
>  static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -2965,14 +2943,19 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>  		break;
>  	case MSR_IA32_PRED_CMD:
> -		r = svm_set_msr_ia32_cmd(vcpu, msr,
> -					 guest_has_pred_cmd_msr(vcpu),
> -					 PRED_CMD_IBPB, X86_FEATURE_IBPB);
> -		break;
> -	case MSR_IA32_FLUSH_CMD:
> -		r = svm_set_msr_ia32_cmd(vcpu, msr,
> -					 guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D),
> -					 L1D_FLUSH, X86_FEATURE_FLUSH_L1D);
> +		if (!msr->host_initiated &&
> +		    !guest_has_pred_cmd_msr(vcpu))
> +			return 1;
> +
> +		if (data & ~PRED_CMD_IBPB)
> +			return 1;
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
> +			return 1;
> +		if (!data)
> +			break;
> +
> +		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
>  		break;
>  	case MSR_AMD64_VIRT_SPEC_CTRL:
>  		if (!msr->host_initiated &&
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f63b28f46a71..1bc2b80273c9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -654,9 +654,6 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
>  
> -	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> -					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> -
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>  
>  	vmx->nested.force_msr_bitmap_recalc = false;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7bf14abdba1..f777509ecf17 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2133,39 +2133,6 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>  	return debugctl;
>  }
>  
> -static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
> -				struct msr_data *msr_info,
> -				bool guest_has_feat, u64 cmd,
> -				int x86_feature_bit)
> -{
> -	if (!msr_info->host_initiated && !guest_has_feat)
> -		return 1;
> -
> -	if (!(msr_info->data & ~cmd))
> -		return 1;
> -	if (!boot_cpu_has(x86_feature_bit))
> -		return 1;
> -	if (!msr_info->data)
> -		return 0;
> -
> -	wrmsrl(msr_info->index, cmd);
> -
> -	/*
> -	 * For non-nested:
> -	 * When it's written (to non-zero) for the first time, pass
> -	 * it through.
> -	 *
> -	 * For nested:
> -	 * The handling of the MSR bitmap for L2 guests is done in
> -	 * nested_vmx_prepare_msr_bitmap. We should not touch the
> -	 * vmcs02.msr_bitmap here since it gets completely overwritten
> -	 * in the merging.
> -	 */
> -	vmx_disable_intercept_for_msr(vcpu, msr_info->index, MSR_TYPE_W);
> -
> -	return 0;
> -}
> -
>  /*
>   * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
> @@ -2319,16 +2286,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		goto find_uret_msr;
>  	case MSR_IA32_PRED_CMD:
> -		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
> -					   guest_has_pred_cmd_msr(vcpu),
> -					   PRED_CMD_IBPB,
> -					   X86_FEATURE_IBPB);
> -		break;
> -	case MSR_IA32_FLUSH_CMD:
> -		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
> -					   guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D),
> -					   L1D_FLUSH,
> -					   X86_FEATURE_FLUSH_L1D);
> +		if (!msr_info->host_initiated &&
> +		    !guest_has_pred_cmd_msr(vcpu))
> +			return 1;
> +
> +		if (data & ~PRED_CMD_IBPB)
> +			return 1;
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
> +			return 1;
> +		if (!data)
> +			break;
> +
> +		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> +
> +		/*
> +		 * For non-nested:
> +		 * When it's written (to non-zero) for the first time, pass
> +		 * it through.
> +		 *
> +		 * For nested:
> +		 * The handling of the MSR bitmap for L2 guests is done in
> +		 * nested_vmx_prepare_msr_bitmap. We should not touch the
> +		 * vmcs02.msr_bitmap here since it gets completely overwritten
> +		 * in the merging.
> +		 */
> +		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
>  		break;
>  	case MSR_IA32_CR_PAT:
>  		if (!kvm_pat_valid(data))

This fixes the boot crash others an me ran into. Thanks a lot, Sean!

Tested-by: Mathias Krause <minipli@grsecurity.net>
