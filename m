Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDCC73C4FD
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 02:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjFXADJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjFXADI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 20:03:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249D91715
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 17:03:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc68c4e046aso1500724276.0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 17:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687564986; x=1690156986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJRpHpBRxhEBpqUMpgxdt7ZEA9jhxO3EbeVO5RWIH/c=;
        b=wrPLcjdZEuLvKlQejy6mmm6vFqEuR71DdT1dtLc1jLOd96Bz4UEcdH15ET6SpelId9
         GQtAHju4xgNlTFW74th8oeE1bYUqywu0LwnQ1ptjE5jNzFmdE63NDA+LIqQVedxd0l3f
         FXr77QNIMStzKabpqQbRSq4Lxrq/uNAdixck+gQj+FGaz0wav0B4H1ZPMuCoV06B1wo+
         vUSVwUvDrpjlxN877vGOdS/X/YE4lBqiHFT/0BjLQju/CaTKarHx+aWL7W3dcYEUWID7
         S5iexCybml0UbrC5hXuRtmxOb9x31rELawxczMOz0iZkg4hFGXBq79unBJzlHFiJlOq7
         u3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687564986; x=1690156986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJRpHpBRxhEBpqUMpgxdt7ZEA9jhxO3EbeVO5RWIH/c=;
        b=hOg4H2qo1vTIUTwaW6ZsqPG6hHUFUcNRdAzKYwV5Tu/MzLsZdC2H0soQGVA3E4yvRq
         mSuiRZcVM1Q453SSXx/X6biWlKawhrh3INwqiyvKLqQDm2JHVkynRe8UHBccBEabNXir
         KAacvH2aA2jDssNRHOL43qPLUsq9nzOqsX76Aru7L2Uzl3XW+RaN+W4ldXgvn3q8Lm17
         GFWW8+FjP++ypfHIcqYcH/6+pq23ZDrlUC+/h3LTwrHlz0fkJWPQCShm7KDHLlaBa17c
         I3cikqVAndQC+9XIDQen/4VQsrRUW5CN0AS9d9ubgRojb7ZPfpt8xGn1/CFeq2mS1w1q
         t0pA==
X-Gm-Message-State: AC+VfDxR2wALAskQprpqhSm/YvXKPkOGUKXn9Of9ABYAlKsxsXw4dxGe
        gGpStCu33Wx/3ZOlFsn6nteNLZbcrxU=
X-Google-Smtp-Source: ACHHUZ4zNI64Z0H8UOQGjEcoKGXm99o1pbXCunalbcWnloXvRzMk3erOepCrX8q9Cv8erigb8TI4jydNpdI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce8e:0:b0:ba8:4ff5:4671 with SMTP id
 x136-20020a25ce8e000000b00ba84ff54671mr9864348ybe.9.1687564986407; Fri, 23
 Jun 2023 17:03:06 -0700 (PDT)
Date:   Fri, 23 Jun 2023 17:03:04 -0700
In-Reply-To: <20230511040857.6094-21-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com> <20230511040857.6094-21-weijiang.yang@intel.com>
Message-ID: <ZJYyuBdh8Ob+zzT2@google.com>
Subject: Re: [PATCH v3 20/21] KVM:x86: Enable kernel IBT support for guest
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a2494156902d..1d0151f9e575 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -711,6 +711,7 @@ static bool is_valid_passthrough_msr(u32 msr)
>  		return true;
>  	case MSR_IA32_U_CET:
>  	case MSR_IA32_PL3_SSP:
> +	case MSR_IA32_S_CET:
>  		return true;
>  	}
>  
> @@ -2097,14 +2098,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
>  	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
>  	case MSR_IA32_PL3_SSP:
>  	case MSR_KVM_GUEST_SSP:
>  		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>  			return 1;
> -		if (msr_info->index == MSR_KVM_GUEST_SSP)
> +		if (msr_info->index == MSR_KVM_GUEST_SSP) {

Unnecessary curly braces.

>  			msr_info->data = vmcs_readl(GUEST_SSP);
> -		else
> +		} else if (msr_info->index == MSR_IA32_S_CET) {
> +			msr_info->data = vmcs_readl(GUEST_S_CET);
> +		} else {
>  			kvm_get_xsave_msr(msr_info);
> +		}
>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> @@ -2419,6 +2424,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
>  	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
>  	case MSR_IA32_PL3_SSP:
>  	case MSR_KVM_GUEST_SSP:
>  		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> @@ -2430,10 +2436,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if ((msr_index == MSR_IA32_PL3_SSP ||
>  		     msr_index == MSR_KVM_GUEST_SSP) && (data & GENMASK(2, 0)))
>  			return 1;
> -		if (msr_index == MSR_KVM_GUEST_SSP)
> +		if (msr_index == MSR_KVM_GUEST_SSP) {
>  			vmcs_writel(GUEST_SSP, data);
> -		else
> +		} else if (msr_index == MSR_IA32_S_CET) {
> +			vmcs_writel(GUEST_S_CET, data);
> +		} else {

Same here.

>  			kvm_set_xsave_msr(msr_info);
> +		}
>  		break;
>  	case MSR_IA32_PERF_CAPABILITIES:
>  		if (data && !vcpu_to_pmu(vcpu)->version)
> @@ -7322,6 +7331,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	kvm_wait_lapic_expire(vcpu);
>  
> +	/*
> +	 * Save host MSR_IA32_S_CET so that it can be reloaded at vm_exit.
> +	 * No need to save the other two vmcs fields as supervisor SHSTK
> +	 * are not enabled on Intel platform now.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
> +	    (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_CET_STATE)) {
> +		u64 msr;
> +
> +		rdmsrl(MSR_IA32_S_CET, msr);

Reading the MSR on every VM-Enter can't possibly be necessary.  At the absolute
minimum, this could be moved outside of the fastpath; if the kernel modifies S_CET
from NMI context, KVM is hosed.  And *if* S_CET isn't static post-boot, this can
be done in .prepare_switch_to_guest() so long as S_CET isn't modified from IRQ
context.

But unless mine eyes deceive me, S_CET is only truly modified during setup_cet(),
i.e. is static post boot, which means it can be read once at KVM load time, e.g.
just like host_efer.

The kernel does save/restore IBT when making BIOS calls, but if KVM is running a
vCPU across a BIOS call then we've got bigger issues.

> +		vmcs_writel(HOST_S_CET, msr);
> +	}
> +
>  	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
>  	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
>  
> @@ -7735,6 +7757,13 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>  
>  	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>  	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
> +
> +	/*
> +	 * If IBT is available to guest, then passthrough S_CET MSR too since
> +	 * kernel IBT is already in mainline kernel tree.
> +	 */
> +	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
>  }
>  
>  static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> @@ -7805,7 +7834,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
>  
> -	if (kvm_cet_user_supported())
> +	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))

Yeah, kvm_cet_user_supported() simply looks wrong.
