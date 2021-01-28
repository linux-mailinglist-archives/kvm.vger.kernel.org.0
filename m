Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D424E307CE4
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhA1Roe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233074AbhA1RoF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611855757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJS+3GFCtCfmN69c0BzqEjKIwA/fcAY9rImqkPB5gBQ=;
        b=BpQRu5l4ien9mf33VYQvh4SF0DWRUq5r+AqRmOQ2z/9Vdln7AsK+A/QfUBmYi8G7tWyhlf
        MjkvX/9HtJ44i2KMSpKQ8NtyMo+QbClEm6coOEBJyrK+Jy+4xQFhwEr+wJykFPrwSY5QPK
        QQRlgM0XWV81RLO2QhoCJ5zCZ0bEu80=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-TEoXBi5FNFaAnl7VBfZszw-1; Thu, 28 Jan 2021 12:42:36 -0500
X-MC-Unique: TEoXBi5FNFaAnl7VBfZszw-1
Received: by mail-ej1-f72.google.com with SMTP id le12so2526100ejb.13
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJS+3GFCtCfmN69c0BzqEjKIwA/fcAY9rImqkPB5gBQ=;
        b=GaIGhOQ7dJs0AnY2uAN8CQhZKG3/Qdo6oI53DSFVUeURvdmc+sUj0QWy8gWfp5poWn
         0uY6vg8yUszfjCePRCPIEvk5s1biBs2nkfTU9u0KiFXySSCpQsh+s8KhoRwAJsV5rjxV
         O94X4AEZZcuv9rXMyl7wqoE33B/RMdlBRMF1638refZsH+lTLmDqfTOeZUiOKPZDvRio
         S+HZMcYSrbU2RRNbndSuxYpoD4r/06jyK6FMleGC9eyt/vzaOAa328nIndQ1IhrCeo0u
         ArGJ88OXpQkRn/2Nn5UrwPg0nKA8SvE5Nb/x2a8IRi7OkihzEkrZx5FEH1gzK9AKZV+J
         71Pg==
X-Gm-Message-State: AOAM530x0DAMzVK1iIVe8obxYyTH92fr4TM5FEN2KYYM3eWYbdDQxYso
        AbgZiM0iJZvE9L8so4yFUNFv98v6BjpFcgSljoTT3gj2AyiIVLsean8bdwCsPEa8q7OScClOE2x
        UTDpx5GagO0TL
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr814648edc.68.1611855754985;
        Thu, 28 Jan 2021 09:42:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrN8Ed0JfsjIGJTjYBE38cLR12dA3PUS54cDu+Mv1wdeKrexLUMtwsnv/jahIBOMJlz8hpYw==
X-Received: by 2002:a05:6402:3487:: with SMTP id v7mr814625edc.68.1611855754788;
        Thu, 28 Jan 2021 09:42:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p12sm3437911edr.82.2021.01.28.09.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:42:33 -0800 (PST)
Subject: Re: [PATCH v14 08/13] KVM: VMX: Add a synthetic MSR to allow
 userspace VMM to access GUEST_SSP
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-9-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f94b472f-086e-ea0c-5ff0-848d5a9689dc@redhat.com>
Date:   Thu, 28 Jan 2021 18:42:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106011637.14289-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 02:16, Yang Weijiang wrote:
> Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP so that the VMM
> can read/write the guest's SSP, e.g. to migrate CET state.  Use a
> synthetic MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject
> to the same consistency checks as the PL*_SSP MSRs, i.e. can share code.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>   arch/x86/kvm/vmx/vmx.c               | 14 ++++++++++++--
>   2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 812e9b4c1114..5203dc084125 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -53,6 +53,7 @@
>   #define MSR_KVM_POLL_CONTROL	0x4b564d05
>   #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>   #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_GUEST_SSP	0x4b564d08
>   
>   struct kvm_steal_time {
>   	__u64 steal;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dd78d3a79e79..28ba8414a7a3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1817,7 +1817,8 @@ static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
>   	if (msr->host_initiated)
>   		return true;
>   
> -	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    msr->index == MSR_KVM_GUEST_SSP)
>   		return false;
>   
>   	if (msr->index == MSR_IA32_INT_SSP_TAB)
> @@ -1995,6 +1996,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>   		break;
> +	case MSR_KVM_GUEST_SSP:
> +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_SSP);
> +		break;
>   	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>   		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
>   			return 1;
> @@ -2287,12 +2293,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
>   		break;
> +	case MSR_KVM_GUEST_SSP:
>   	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>   		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
>   			return 1;
>   		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
>   			return 1;
> -		vmx_set_xsave_msr(msr_info);
> +		if (msr_index == MSR_KVM_GUEST_SSP)
> +			vmcs_writel(GUEST_SSP, data);
> +		else
> +			vmx_set_xsave_msr(msr_info);
>   		break;
>   	case MSR_TSC_AUX:
>   		if (!msr_info->host_initiated &&
> 

Doh, I misread the change in cet_is_ssp_msr_accessible, sorry.  */

