Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FA543197C
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhJRMn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhJRMnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634560874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5qFf3VI73kFQn2LyVeKguZB9EmFNL0jwRXY2EkA/dfI=;
        b=ZAJTeI9qLUl4jiGo2UbJOu0mqbJpkwSKGvrsifINCDQwG2eNHXLAvhFdAWpx6V97Hde+Hm
        tPmLJbE7AYAfLxJrII6I+10w8/LjjUv1BTqr8O5PBLsx8kRWJUiEZbZWHy5G7OLd13+Ogq
        upUWG4zRh/b9krSGDsOlX/17zWTC2Os=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-lsV-GSIuPneZIR5QnD-T2w-1; Mon, 18 Oct 2021 08:41:13 -0400
X-MC-Unique: lsV-GSIuPneZIR5QnD-T2w-1
Received: by mail-wr1-f71.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so8812436wrc.9
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 05:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5qFf3VI73kFQn2LyVeKguZB9EmFNL0jwRXY2EkA/dfI=;
        b=qJjaxLWZu4XjhCjk5Vh/t7DGI57qpeEDRBoFMQ6zpqmlogSESrTDD69ZyTENBGNoPI
         lpafrsnvKBGAfhw9dixRnGS69htePDA5P9Ngnw1aOVxVjQHDi54kDVqwynOvMi3GhSVW
         jW/LSqkM/1/bm31TAz/24mjcg1fviBmQ2f3iys0urb/n1aZgO+XupG6OyP+k/kviHVDp
         1hktGMCTbuuyVH8K2T2L2i8pZd7QoOI5vioXWN2pu3ebR0BYJOeSaCW5FhyEZDAY20aG
         P8GKaL9EnTwWaLbvBD5NZdt/V7CNE1lV3LkfCDlYpO+7NUcv6UOmxSh8HRAfTn9rycbD
         ipbw==
X-Gm-Message-State: AOAM532ETzImzog2lwInNtbIYsqoZ3rEtJeSKhn0SGCUUqHN15C/oiLo
        UgskrL+7Zp3PtP8tlTnwc5p9CW1wmyztpCyfBL9WAJBNLPeHxNm9K3jWHBy5y7jWu5/9NnCKntF
        YVFYmMUVL0hEl
X-Received: by 2002:a05:600c:a43:: with SMTP id c3mr42805782wmq.193.1634560872116;
        Mon, 18 Oct 2021 05:41:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFLqBqHNsYgatjWEsa5xVYt5GS/KiY7e5BxQadmhOhAsag56flHd3brWoTaEUsc1nq4hHk5Q==
X-Received: by 2002:a05:600c:a43:: with SMTP id c3mr42805742wmq.193.1634560871742;
        Mon, 18 Oct 2021 05:41:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k10sm12346384wrh.64.2021.10.18.05.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:41:10 -0700 (PDT)
Message-ID: <fb05e1cf-e847-11cf-c01e-fc07202229ad@redhat.com>
Date:   Mon, 18 Oct 2021 14:41:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 3/7] KVM: VMX: Rename pt_desc.addr_range to
 pt_desc.nr_addr_range
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-4-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210827070249.924633-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 09:02, Xiaoyao Li wrote:
> To better self explain the meaning of this field.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Let's use num_addr_ranges to map the PT_CAP constant.

Paolo

>   arch/x86/kvm/vmx/vmx.c | 26 +++++++++++++-------------
>   arch/x86/kvm/vmx/vmx.h |  2 +-
>   2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 96a2df65678f..c54b99cec0e6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1059,8 +1059,8 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
>   	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
>   	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
>   		wrmsrl(MSR_IA32_RTIT_CTL, 0);
> -		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
> -		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
> +		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.nr_addr_ranges);
> +		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.nr_addr_ranges);
>   	}
>   }
>   
> @@ -1070,8 +1070,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
>   		return;
>   
>   	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> -		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
> -		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
> +		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.nr_addr_ranges);
> +		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.nr_addr_ranges);
>   	}
>   
>   	/*
> @@ -1460,16 +1460,16 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>   	 * cause a #GP fault.
>   	 */
>   	value = (data & RTIT_CTL_ADDR0) >> RTIT_CTL_ADDR0_OFFSET;
> -	if ((value && (vmx->pt_desc.addr_range < 1)) || (value > 2))
> +	if ((value && (vmx->pt_desc.nr_addr_ranges < 1)) || (value > 2))
>   		return 1;
>   	value = (data & RTIT_CTL_ADDR1) >> RTIT_CTL_ADDR1_OFFSET;
> -	if ((value && (vmx->pt_desc.addr_range < 2)) || (value > 2))
> +	if ((value && (vmx->pt_desc.nr_addr_ranges < 2)) || (value > 2))
>   		return 1;
>   	value = (data & RTIT_CTL_ADDR2) >> RTIT_CTL_ADDR2_OFFSET;
> -	if ((value && (vmx->pt_desc.addr_range < 3)) || (value > 2))
> +	if ((value && (vmx->pt_desc.nr_addr_ranges < 3)) || (value > 2))
>   		return 1;
>   	value = (data & RTIT_CTL_ADDR3) >> RTIT_CTL_ADDR3_OFFSET;
> -	if ((value && (vmx->pt_desc.addr_range < 4)) || (value > 2))
> +	if ((value && (vmx->pt_desc.nr_addr_ranges < 4)) || (value > 2))
>   		return 1;
>   
>   	return 0;
> @@ -1889,7 +1889,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>   		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
>   		if (!vmx_pt_mode_is_host_guest() ||
> -		    (index >= 2 * vmx->pt_desc.addr_range))
> +		    (index >= 2 * vmx->pt_desc.nr_addr_ranges))
>   			return 1;
>   		if (index % 2)
>   			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
> @@ -2204,7 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (!pt_can_write_msr(vmx))
>   			return 1;
>   		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
> -		if (index >= 2 * vmx->pt_desc.addr_range)
> +		if (index >= 2 * vmx->pt_desc.nr_addr_ranges)
>   			return 1;
>   		if (is_noncanonical_address(data, vcpu))
>   			return 1;
> @@ -3880,7 +3880,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>   	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_BASE, MSR_TYPE_RW, flag);
>   	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_MASK, MSR_TYPE_RW, flag);
>   	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_CR3_MATCH, MSR_TYPE_RW, flag);
> -	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
> +	for (i = 0; i < vmx->pt_desc.nr_addr_ranges; i++) {
>   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
>   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
>   	}
> @@ -7113,7 +7113,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   	}
>   
>   	/* Get the number of configurable Address Ranges for filtering */
> -	vmx->pt_desc.addr_range = intel_pt_validate_cap(vmx->pt_desc.caps,
> +	vmx->pt_desc.nr_addr_ranges = intel_pt_validate_cap(vmx->pt_desc.caps,
>   						PT_CAP_num_address_ranges);
>   
>   	/* Initialize and clear the no dependency bits */
> @@ -7161,7 +7161,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_FABRIC_EN;
>   
>   	/* unmask address range configure area */
> -	for (i = 0; i < vmx->pt_desc.addr_range; i++)
> +	for (i = 0; i < vmx->pt_desc.nr_addr_ranges; i++)
>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4858c5fd95f2..f48eafbbed0e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -62,7 +62,7 @@ struct pt_ctx {
>   
>   struct pt_desc {
>   	u64 ctl_bitmask;
> -	u32 addr_range;
> +	u32 nr_addr_ranges;
>   	u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
>   	struct pt_ctx host;
>   	struct pt_ctx guest;
> 


