Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1A433CE0
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhJSRCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234319AbhJSRCJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634662796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=auOaRSgFVQD2w+eLTQPC0fEgzDhm9Ph3YAcBEKwAoHw=;
        b=YjS4qXkOn1qNIWte7Owt8mGSSLhV6z8wDPAV2h/kWMrqyxh0chz1o4gA534fSFNIMIwr+l
        q4WIWLAQYVor2pnYVnnZYV4DzLkSkfhkDDM7SvHYTBW9cm6guEG/funVrWJlAzOjnqke+2
        x/WW3aCwGXpAA6wwcpu1Q51w2YY6+04=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-hnD_HekXO22eavCkL_ZIbQ-1; Tue, 19 Oct 2021 12:59:55 -0400
X-MC-Unique: hnD_HekXO22eavCkL_ZIbQ-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so18174573edl.17
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:59:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=auOaRSgFVQD2w+eLTQPC0fEgzDhm9Ph3YAcBEKwAoHw=;
        b=SeUKYYXb2ZiWFWk894f9au4f+ESiaWon28RSDoExWoSbgLOZgsTMm7RMvjwlti2XYp
         5tkWlBe0bVOwlnmNSVabf4ZsrsJKHoVrGWxQ2DLz1mB2CGH9Wji0qz9QURJ4m2b9wmHQ
         ZZNLfS0hIaJsDBvUDH8EtWZEasRgQZs6OG3ByfsAyxe9D9JEctEpYuxRJ6nV9kjrb72X
         IZdOSMGbDxo5O6viUn/O8nND1Sv+HE0fKxlAWTfmkTwk6Zcwec7s/yaoUwCfWVogK/m9
         i+tdl+w/YV3j5Uk17uMuv3qzrU83A63Uamd8YJ05u06AnSlObLoxTTsOIWt2eKTEI0Z+
         +MkA==
X-Gm-Message-State: AOAM531ad9Si226XyS8+sZpAwDh/R1i0Fb8434FNqhgIyguNhJumbks7
        LGjkLlVmI/eh3Ej0N8ke7Guz5RNdg2nKSTi70+mCJ9Tjn//75tiZuUVQxszNq8MEStNgDjDMorV
        1a5EF1YrKtfOX
X-Received: by 2002:a17:906:b803:: with SMTP id dv3mr38709843ejb.289.1634662793961;
        Tue, 19 Oct 2021 09:59:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGIdkunPz/iPJZgp31Ko6ZczYRZfWldr+tHzPxDEq9P9+ndL7w1lwWPoyu7xW2GOSIiPrsOg==
X-Received: by 2002:a17:906:b803:: with SMTP id dv3mr38709815ejb.289.1634662793711;
        Tue, 19 Oct 2021 09:59:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id z13sm7987068ejl.106.2021.10.19.09.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:59:52 -0700 (PDT)
Message-ID: <64702a4e-6759-e0f9-e116-7f874852e9d0@redhat.com>
Date:   Tue, 19 Oct 2021 18:59:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 2/3] KVM: vPMU: Fill get_msr
 MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1634631160-67276-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 10:12, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> SDM section 18.2.3 mentioned that:
> 
>    "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of
>     any general-purpose or fixed-function counters via a single WRMSR."
> 
> It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing,
> the value is always 0 for ICX/SKX boxes on hands. Let's fill get_msr
> MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior and drop
> global_ovf_ctrl variable.
> 
> Tested-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Btw, xen also fills get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0.
> v1 -> v2:
>   * drop 'u64 global_ovf_ctrl' directly
> 
>   arch/x86/include/asm/kvm_host.h | 1 -
>   arch/x86/kvm/vmx/pmu_intel.c    | 6 ++----
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f8f48a7ec577..7aaac918e992 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -499,7 +499,6 @@ struct kvm_pmu {
>   	u64 fixed_ctr_ctrl;
>   	u64 global_ctrl;
>   	u64 global_status;
> -	u64 global_ovf_ctrl;
>   	u64 counter_bitmask[2];
>   	u64 global_ctrl_mask;
>   	u64 global_ovf_ctrl_mask;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 10cc4f65c4ef..b8e0d21b7c8a 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = pmu->global_ctrl;
>   		return 0;
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -		msr_info->data = pmu->global_ovf_ctrl;
> +		msr_info->data = 0;
>   		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> @@ -423,7 +423,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (!(data & pmu->global_ovf_ctrl_mask)) {
>   			if (!msr_info->host_initiated)
>   				pmu->global_status &= ~data;
> -			pmu->global_ovf_ctrl = data;
>   			return 0;
>   		}
>   		break;
> @@ -588,8 +587,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>   		pmc->counter = 0;
>   	}
>   
> -	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
> -		pmu->global_ovf_ctrl = 0;
> +	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
>   
>   	intel_pmu_release_guest_lbr_event(vcpu);
>   }
> 

Queued, thanks.

Paolo

