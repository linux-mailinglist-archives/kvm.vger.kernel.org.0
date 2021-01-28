Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E30E307D2B
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhA1R4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:56:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231237AbhA1R4H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611856480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xfK15ZVkyxyM5VreEOv6Qia9+yGZ56hrT5mStJUdrc=;
        b=evxld10vJuUiv1LErOWPy7WU1/2clOoy9pK0Dla3cMPIMe2MJCA1ROcRGvsipoeNWbytKf
        Qe3hKi3YNs1Caew6vdRHRikFc4NXplQ1lt9vUgJ7S5f514YOSH6AGKhS2hnPjlK7qnturo
        +cJtAeEwYFWzDWTvzzDZlyVQnuZcb6g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-dOVNdJL2Psm-vl2BFopoiw-1; Thu, 28 Jan 2021 12:54:39 -0500
X-MC-Unique: dOVNdJL2Psm-vl2BFopoiw-1
Received: by mail-ed1-f70.google.com with SMTP id a26so3586602edx.8
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xfK15ZVkyxyM5VreEOv6Qia9+yGZ56hrT5mStJUdrc=;
        b=DD3IR/PIjoTevmoyC6izGR9DOJhjMcOK6LTkz3AMsrBEOeYOpLF4zRcggiKaautiit
         YbP5yvIe+StX+TLz/v8+yUFMZ/GLArMu11SQhw7i+NvQtHLvmS8sLxSq1cxu5tkdsjpu
         QIjR6KiHgE4zYpn4ewQNUJpEo6fd3CWV0JjtORmG/hjTKGUmHLVNlhlbLXdY3KWprtei
         gdVMjZwr2YqOKxxkRehyPveLg24S6DVQknOtleuvUKfAJ/3zG52ZtrnVfYz0f3hwP+Vr
         tR85nBd+KcicIKzrGtdjg+AqvgyjbP/+O3ebhqu/qGnilseaItdYrJ2ogknBTaaCtRFB
         /IFQ==
X-Gm-Message-State: AOAM531enGtTu08Ol62HpBo86wf1KJ1dfbojSUv2GZYtNmZVngTZxfX8
        6uwwUk/gtztsosuivVpdgzTzqOyoIoAffHHbcTPcgscrpmMVW5ye/+XQC5MRnnwzKD/dnKplDbn
        Vaf7E8UEbg8o+
X-Received: by 2002:aa7:c583:: with SMTP id g3mr786635edq.357.1611856477809;
        Thu, 28 Jan 2021 09:54:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjxJPGNAjWizazk2EDwntbEd3PVPEgWK2AW9vbs1xp4DNhKliyzq31O8TRsXWlQfIE+0hSWw==
X-Received: by 2002:aa7:c583:: with SMTP id g3mr786621edq.357.1611856477666;
        Thu, 28 Jan 2021 09:54:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p16sm2602219ejz.103.2021.01.28.09.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:54:36 -0800 (PST)
Subject: Re: [PATCH v14 11/13] KVM: VMX: Pass through CET MSRs to the guest
 when supported
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-12-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <78948a28-2b6c-fccb-971a-550ea7e4da2c@redhat.com>
Date:   Thu, 28 Jan 2021 18:54:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106011637.14289-12-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 02:16, Yang Weijiang wrote:
> Pass through all CET MSRs when the associated CET component (kernel vs.
> user) is enabled to improve guest performance.  All CET MSRs are context
> switched, either via dedicated VMCS fields or XSAVES.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c88a6e1721b1..6ba2027a3d44 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7366,6 +7366,32 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>   }
>   
> +static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_state)
> +{
> +	return (vcpu->arch.guest_supported_xss & xss_state) &&
> +	       (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT));
> +}
> +
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	bool incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER);
> +
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, incpt);
> +
> +	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
> +
> +	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_KERNEL);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
> +
> +	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, incpt);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, incpt);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, incpt);
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, incpt);
> +}
> +
>   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7409,6 +7435,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   
>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>   	update_exception_bitmap(vcpu);
> +
> +	if (kvm_cet_supported())
> +		vmx_update_intercept_for_cet_msr(vcpu);
>   }
>   
>   static __init void vmx_set_cpu_caps(void)
> 

Can you do this only if CR4.CET=1?

Paolo

