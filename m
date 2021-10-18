Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB504319BC
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhJRMsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229843AbhJRMsX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634561171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H6ER0yaSWMpzMbiBOBsThEGJi6+tWVkiEl6DXpHEDYM=;
        b=EIUR71WsxQJWHinxdXkRYe4cYhvLaisUzN8zqJGYL+q8GGpR1jLd5bopBvVbYnDcflyCVk
        Gw0zi4gh/ODBnjv3HOLZfPgcPHLcegmyFNEUxSAuE/ol3GP4vfCHy2hYXrmkFSR4N0VkuI
        QxCl+Xds23Y92oodsyDQFJEIgqV/05o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-NqLs6SEzPdSi2sv7mVN6Bw-1; Mon, 18 Oct 2021 08:46:09 -0400
X-MC-Unique: NqLs6SEzPdSi2sv7mVN6Bw-1
Received: by mail-wm1-f70.google.com with SMTP id 128-20020a1c0486000000b0030dcd45476aso2037815wme.0
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 05:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H6ER0yaSWMpzMbiBOBsThEGJi6+tWVkiEl6DXpHEDYM=;
        b=mcxQ41oWxkigI+NNXHgPBXtSVo7NPFRIHe+Kz2nf3qa3EYxdqca1cHwyi/0ieswmbR
         xtIieY2SzlVtk2cq7p7CvdOcb424m5a/WeRGlTnUuLg/3H4SARO4WfDpRPw2EAEGZsED
         WAhNvYBjILXCXqBvi35NqSQNEFuwO0BJ0amFCda77LXJaoUsvUMeWoJY5oDMoXZy0Ih2
         SH+LD9uMn4fkubZslD+zfvK5rBubYyuPIPGgHmlU6c2numbYUgDQkK3Dmt8ZxP9EHXKS
         BEiXz/I6B8xwMr6N+fp0v9iVhRYfrQoFKX+6vcbWJsGNiQEn52ThCCTAnYMW9hm/dskQ
         5/4A==
X-Gm-Message-State: AOAM533tfegnjQ73RtIP62aaUne/Tfm3xHQLXGQlZuFrAQzs+C1B1Uro
        wtI7EeDBfOTC3OfYsn3+rr+dyB+sGHt6Akt2qMLEK3e0wW5DJ8Q4BJv9ibZ7w4H4al2ssuYOFQb
        4eMoFegUv/Yxm
X-Received: by 2002:a05:6000:1683:: with SMTP id y3mr21250715wrd.314.1634561168354;
        Mon, 18 Oct 2021 05:46:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfM09qTKJcvWscLRFWVnoHx5yzSko0ksxB0vJB6nCSF1nMb6pvJCfIrfAEooR/QXcANewGJQ==
X-Received: by 2002:a05:6000:1683:: with SMTP id y3mr21250688wrd.314.1634561168125;
        Mon, 18 Oct 2021 05:46:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a2sm14358433wrq.9.2021.10.18.05.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:46:07 -0700 (PDT)
Message-ID: <265883f8-83a4-6386-fa56-b53b4897f5e1@redhat.com>
Date:   Mon, 18 Oct 2021 14:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 5/7] KVM: VMX: Disallow PT MSRs accessing if PT is not
 exposed to guest
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-6-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210827070249.924633-6-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 09:02, Xiaoyao Li wrote:
> Per SDM, it triggers #GP for all the accessing of PT MSRs, if
> X86_FEATURE_INTEL_PT is not available.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v2:
>   - allow userspace/host access regradless of PT bit, (Sean)
> ---
>   arch/x86/kvm/vmx/vmx.c | 38 +++++++++++++++++++++++++-------------
>   1 file changed, 25 insertions(+), 13 deletions(-)

Let's cache this in vmx->pt_desc.  More precisely:

- always call update_intel_pt_cfg from vmx_vcpu_after_set_cpuid

- add a field vmx->pt_desc.available matching guest_cpuid_has(vcpu, 
X86_FEATURE_INTEL_PT)

- if it is false, clear _all_ of vmx->pt_desc (with memcpy) and return 
early from update_intel_pt_cfg

Thanks,

Paolo

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b9d640029c40..394ef4732838 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1007,10 +1007,21 @@ static unsigned long segment_base(u16 selector)
>   }
>   #endif
>   
> -static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
> +static inline bool pt_can_write_msr(struct vcpu_vmx *vmx,
> +				    struct msr_data *msr_info)
>   {
>   	return vmx_pt_mode_is_host_guest() &&
> -	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
> +	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) &&
> +	       (msr_info->host_initiated ||
> +		guest_cpuid_has(&vmx->vcpu, X86_FEATURE_INTEL_PT));
> +}
> +
> +static inline bool pt_can_read_msr(struct kvm_vcpu *vcpu,
> +				   struct msr_data *msr_info)
> +{
> +	return vmx_pt_mode_is_host_guest() &&
> +	       (msr_info->host_initiated ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT));
>   }
>   
>   static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
> @@ -1852,24 +1863,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   							&msr_info->data);
>   		break;
>   	case MSR_IA32_RTIT_CTL:
> -		if (!vmx_pt_mode_is_host_guest())
> +		if (!pt_can_read_msr(vcpu, msr_info))
>   			return 1;
>   		msr_info->data = vmx->pt_desc.guest.ctl;
>   		break;
>   	case MSR_IA32_RTIT_STATUS:
> -		if (!vmx_pt_mode_is_host_guest())
> +		if (!pt_can_read_msr(vcpu, msr_info))
>   			return 1;
>   		msr_info->data = vmx->pt_desc.guest.status;
>   		break;
>   	case MSR_IA32_RTIT_CR3_MATCH:
> -		if (!vmx_pt_mode_is_host_guest() ||
> +		if (!pt_can_read_msr(vcpu, msr_info) ||
>   			!intel_pt_validate_cap(vmx->pt_desc.caps,
>   						PT_CAP_cr3_filtering))
>   			return 1;
>   		msr_info->data = vmx->pt_desc.guest.cr3_match;
>   		break;
>   	case MSR_IA32_RTIT_OUTPUT_BASE:
> -		if (!vmx_pt_mode_is_host_guest() ||
> +		if (!pt_can_read_msr(vcpu, msr_info) ||
>   			(!intel_pt_validate_cap(vmx->pt_desc.caps,
>   					PT_CAP_topa_output) &&
>   			 !intel_pt_validate_cap(vmx->pt_desc.caps,
> @@ -1878,7 +1889,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = vmx->pt_desc.guest.output_base;
>   		break;
>   	case MSR_IA32_RTIT_OUTPUT_MASK:
> -		if (!vmx_pt_mode_is_host_guest() ||
> +		if (!pt_can_read_msr(vcpu, msr_info) ||
>   			(!intel_pt_validate_cap(vmx->pt_desc.caps,
>   					PT_CAP_topa_output) &&
>   			 !intel_pt_validate_cap(vmx->pt_desc.caps,
> @@ -1888,7 +1899,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>   		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
> -		if (!vmx_pt_mode_is_host_guest() ||
> +		if (!pt_can_read_msr(vcpu, msr_info) ||
>   		    (index >= 2 * vmx->pt_desc.nr_addr_ranges))
>   			return 1;
>   		if (index % 2)
> @@ -2156,6 +2167,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		return vmx_set_vmx_msr(vcpu, msr_index, data);
>   	case MSR_IA32_RTIT_CTL:
>   		if (!vmx_pt_mode_is_host_guest() ||
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT) ||
>   			vmx_rtit_ctl_check(vcpu, data) ||
>   			vmx->nested.vmxon)
>   			return 1;
> @@ -2164,14 +2176,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		pt_update_intercept_for_msr(vcpu);
>   		break;
>   	case MSR_IA32_RTIT_STATUS:
> -		if (!pt_can_write_msr(vmx))
> +		if (!pt_can_write_msr(vmx, msr_info))
>   			return 1;
>   		if (data & MSR_IA32_RTIT_STATUS_MASK)
>   			return 1;
>   		vmx->pt_desc.guest.status = data;
>   		break;
>   	case MSR_IA32_RTIT_CR3_MATCH:
> -		if (!pt_can_write_msr(vmx))
> +		if (!pt_can_write_msr(vmx, msr_info))
>   			return 1;
>   		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
>   					   PT_CAP_cr3_filtering))
> @@ -2179,7 +2191,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vmx->pt_desc.guest.cr3_match = data;
>   		break;
>   	case MSR_IA32_RTIT_OUTPUT_BASE:
> -		if (!pt_can_write_msr(vmx))
> +		if (!pt_can_write_msr(vmx, msr_info))
>   			return 1;
>   		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
>   					   PT_CAP_topa_output) &&
> @@ -2191,7 +2203,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vmx->pt_desc.guest.output_base = data;
>   		break;
>   	case MSR_IA32_RTIT_OUTPUT_MASK:
> -		if (!pt_can_write_msr(vmx))
> +		if (!pt_can_write_msr(vmx, msr_info))
>   			return 1;
>   		if (!intel_pt_validate_cap(vmx->pt_desc.caps,
>   					   PT_CAP_topa_output) &&
> @@ -2201,7 +2213,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		vmx->pt_desc.guest.output_mask = data;
>   		break;
>   	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
> -		if (!pt_can_write_msr(vmx))
> +		if (!pt_can_write_msr(vmx, msr_info))
>   			return 1;
>   		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
>   		if (index >= 2 * vmx->pt_desc.nr_addr_ranges)
> 

