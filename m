Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D630DD04
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhBCOjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:39:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232566AbhBCOjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 09:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612363053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nxzodRnj6L8Hu+71XkSCF4ak/XSfmAmRxeG/xBj6v0=;
        b=XCO3QtvrTA797KDmLdItOywv5NXWuHQXBbuOM6DyKKTvfgCLls5EUGlO1b74xJqeACm18U
        Q0y52YyCNZOhNYXDja6r/XLXvCCLNvSFdmaiNiijZnBKI8anA4aMbuzQbQ5C188uXd6Fng
        WoC4XxNya3/qQurzTh7Sgj//Wbiyuxs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-6-RWavMXNIir3jWle5FbfA-1; Wed, 03 Feb 2021 09:37:31 -0500
X-MC-Unique: 6-RWavMXNIir3jWle5FbfA-1
Received: by mail-ed1-f70.google.com with SMTP id m16so11604142edd.21
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 06:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5nxzodRnj6L8Hu+71XkSCF4ak/XSfmAmRxeG/xBj6v0=;
        b=Om3BrIVtVt0jYEQoGhteo6qZ/faQH3Iw5Aj1gCjkwXK2vqFjo9W09tkgJv263odtox
         rkydEplLiuiY68f3Mz2Mpr78cCUrljn3UxHWZ4VSRW7BaJyac7DpI7+R3fu32sh2nPYe
         UItPvOixYzE6kozJIWMjTwzplmDTJpguB2CYUOj/Ax06j2anEdbUNYhPINJSsJgGhcAF
         AZ+uQtI6gbkkT+V6iT6IPr8pE/07fbVnPWoTrwCDphSEb6U+9r6qVoKesbihNc54lQLD
         A+Kduh4HplW/rTB6bqs0cbMIgcehHdfmRFLalrI4hVwYdaJ3eMKBj3Dv4yTXceoocOgg
         +KaA==
X-Gm-Message-State: AOAM5325zzuB/ULBzeKasCgof/PeyK2064Ewxgs1n76B4nuTo1JFtldm
        cuwK9WaNrCOtp/tQYF3ETNnGpmfrUr5hRmdakeZZUg5DtZpP3eLRa0lF6OxBgMET7GGnAI/ZX8y
        1R90TdFFUyDZn
X-Received: by 2002:a17:906:1d51:: with SMTP id o17mr3488076ejh.85.1612363050463;
        Wed, 03 Feb 2021 06:37:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCUEoejE6/XR79OpqkNimd8dpO6DsZwT7D/TO7tfyOnfj06V+4BOc/FAnLxQb2UkPp5hXWzA==
X-Received: by 2002:a17:906:1d51:: with SMTP id o17mr3488061ejh.85.1612363050297;
        Wed, 03 Feb 2021 06:37:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r1sm958046eds.70.2021.02.03.06.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 06:37:29 -0800 (PST)
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
Date:   Wed, 3 Feb 2021 15:37:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203135714.318356-5-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 14:57, Like Xu wrote:
> If CPUID.(EAX=07H, ECX=0):EDX[19] is exposed to 1, the KVM supports Arch
> LBRs and CPUID leaf 01CH indicates details of the Arch LBRs capabilities.
> As the first step, KVM only exposes the current LBR depth on the host for
> guest, which is likely to be the maximum supported value on the host.
> 
> If KVM supports XSAVES, the CPUID.(EAX=0DH, ECX=1):EDX:ECX[bit 15]
> is also exposed to 1, which means the availability of support for Arch
> LBR configuration state save and restore. When available, guest software
> operating at CPL=0 can use XSAVES/XRSTORS manage supervisor state
> component Arch LBR for own purposes once IA32_XSS [bit 15] is set.
> XSAVE support for Arch LBRs is enumerated in CPUID.(EAX=0DH, ECX=0FH).
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/cpuid.c   | 23 +++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c |  2 ++
>   arch/x86/kvm/x86.c     | 10 +++++++++-
>   3 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 944f518ca91b..900149eec42d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -778,6 +778,29 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->edx = 0;
>   		}
>   		break;
> +	/* Architectural LBR */
> +	case 0x1c:
> +	{
> +		u64 lbr_depth_mask = 0;
> +
> +		if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +
> +		/*
> +		 * KVM only exposes the maximum supported depth,
> +		 * which is also the fixed value used on the host.
> +		 *
> +		 * KVM doesn't allow VMM user sapce to adjust depth
> +		 * per guest, because the guest LBR emulation depends
> +		 * on the implementation of the host LBR driver.
> +		 */
> +		lbr_depth_mask = 1UL << fls(entry->eax & 0xff);
> +		entry->eax &= ~0xff;
> +		entry->eax |= lbr_depth_mask;
> +		break;
> +	}
>   	/* Intel PT */
>   	case 0x14:
>   		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ddf0a14d75c..c22175d9564e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7498,6 +7498,8 @@ static __init void vmx_set_cpu_caps(void)
>   		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
>   	if (vmx_pt_mode_is_host_guest())
>   		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
> +	if (cpu_has_vmx_arch_lbr())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
>   
>   	if (vmx_umip_emulated())
>   		kvm_cpu_cap_set(X86_FEATURE_UMIP);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 667d0042d0b7..107f2e72f526 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10385,8 +10385,16 @@ int kvm_arch_hardware_setup(void *opaque)
>   
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>   		supported_xss = 0;
> -	else
> +	else {
>   		supported_xss &= host_xss;
> +		/*
> +		 * The host doesn't always set ARCH_LBR bit to hoss_xss since this
> +		 * Arch_LBR component is used on demand in the Arch LBR driver.
> +		 * Check e649b3f0188f "Support dynamic supervisor feature for LBR".
> +		 */
> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +			supported_xss |= XFEATURE_MASK_LBR;
> +	}
>   
>   	/* Update CET features now that supported_xss is finalized. */
>   	if (!kvm_cet_supported()) {
> 

This requires some of the XSS patches that Weijang posted for CET, right?

Also, who takes care of saving/restoring the MSRs, if the host has not 
added XFEATURE_MASK_LBR to MSR_IA32_XSS?

Thanks,

Paolo

