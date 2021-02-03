Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03A30D683
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 10:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhBCJn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 04:43:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232815AbhBCJny (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 04:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612345347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=biSKBCz8mruHfx6T0zzWWZ0kE/fGP6S93LISl+LC4YQ=;
        b=Kssk/iqqmNTAiEJnnq6HqxF782h1ycL8tSWnOn8L1C4cM2XsSkQx3BysCwIPczlYg1eCbq
        Hs6tLvFgajUkL6Y9mWefR+1WTP0ssxtx0Pnth0stOsQlsGBR1Ac4bbhCUlYgl+1Z+S8uha
        zx4KpdSlE1+WBDNqymlP5mt9032UK2k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-p6L-95trNmiOTNy2enO91A-1; Wed, 03 Feb 2021 04:42:26 -0500
X-MC-Unique: p6L-95trNmiOTNy2enO91A-1
Received: by mail-ed1-f69.google.com with SMTP id u19so11106025edr.1
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 01:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=biSKBCz8mruHfx6T0zzWWZ0kE/fGP6S93LISl+LC4YQ=;
        b=U4NYSzivimpGrVVvD7deu4fjbGBvgqSsPP1EQYosiVTjwdvnGI0DMbOIOLmWO2d3ba
         kUiElMtSdz3qUHRiEwbCg8T+ExqbqMfKXLYJ1v2ermRyhBpP6+vDv2wgFfwtdpyzakBq
         H5Sr0pO3FnbY0jRAxFA7TAIUtPL62rV11SRgp1zd0aDNprCU11lVQVmk0hdow7WRVdSM
         2K3BVf1yn/Ei/Wvg8iEYP8YBAgduXqBrpoFwtENej9VYh6ssv3iCiTQ6KVGX6z6yj72+
         ck5U27HhoVk8+fETCcx1jEqY8OgsLcb5yS+EbnOtadzy2+BgH9siNUkwgSptmgsVbWaW
         hmgw==
X-Gm-Message-State: AOAM531Lk5XKmhjhMa++EndCDmBtpeLODFU0y2rBIdWMfcFnITDoYoR6
        anlb7nEWAFGrsYvLD04tuLDdANzt6uZEw3ErXEEF/rf//hUp9IfYcxX0zuHMr/eBY0K2jRwV51a
        KySIJxZRHGm3+
X-Received: by 2002:aa7:d352:: with SMTP id m18mr2081505edr.190.1612345344986;
        Wed, 03 Feb 2021 01:42:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyYJCOYFoTShDOJw71pEdhI7iII+5s/dIoyufsv9Eq0TviKQwk3YfrsDwAkPB8fUWslrNJGw==
X-Received: by 2002:aa7:d352:: with SMTP id m18mr2081484edr.190.1612345344780;
        Wed, 03 Feb 2021 01:42:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t3sm585734eds.89.2021.02.03.01.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 01:42:23 -0800 (PST)
Subject: Re: [PATCH] KVM: vmx/pmu: Add VMCS fields check before exposing
 LBR_FMT
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210203065027.314622-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1fa3086-b95b-58bc-3814-31fe08dc8be6@redhat.com>
Date:   Wed, 3 Feb 2021 10:42:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203065027.314622-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 07:50, Like Xu wrote:
> Before KVM exposes guest LBR_FMT perf capabilities, it needs to check
> whether VMCS has GUEST_IA32_DEBUGCTL guest status field and vmx switch
> support on IA32_DEBUGCTL MSR (including VM_EXIT_SAVE_DEBUG_CONTROLS
> and VM_ENTRY_LOAD_DEBUG_CONTROLS). It helps nested LBR enablement.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index d1d77985e889..ac3af06953a8 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -378,6 +378,12 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>   	return pt_mode == PT_MODE_HOST_GUEST;
>   }
>   
> +static inline bool cpu_has_vmx_lbr(void)
> +{
> +	return (vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_DEBUG_CONTROLS) &&
> +		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_DEBUG_CONTROLS);
> +}
> +
>   static inline u64 vmx_get_perf_capabilities(void)
>   {
>   	u64 perf_cap = 0;
> @@ -385,7 +391,8 @@ static inline u64 vmx_get_perf_capabilities(void)
>   	if (boot_cpu_has(X86_FEATURE_PDCM))
>   		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>   
> -	perf_cap &= PMU_CAP_LBR_FMT;
> +	if (cpu_has_vmx_lbr())
> +		perf_cap &= PMU_CAP_LBR_FMT;

This is incorrect in the case where cpu_has_vmx_lbr() is false.  You 
would need something like

  	u64 perf_cap = 0;
	u64 host_perf_cap = 0;

  	if (boot_cpu_has(X86_FEATURE_PDCM))
		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);

	if (cpu_has_vmx_lbr())
		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;

However, KVM won't run without VM_ENTRY_LOAD_DEBUG_CONTROLS and 
VM_EXIT_SAVE_DEBUG_CONTROLS (see setup_vmcs_config), so this change is 
not needed either.

Paolo

