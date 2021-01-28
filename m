Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0844F307CDA
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhA1RnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233256AbhA1Rm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611855690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjUgxjPulNgQYWnm8Kd2VJVF8wf5pzL5OzfyCR+KDYs=;
        b=L39LPPUYUpGw8Wc3ggaEYwJ9uDiJBiyV+YEywbK3ZfmPInInw8Sc1QbLXYQtN3Ga/NIYQm
        pfat3XVX/fjr126fMeqaKAk9PkZWUoVDzuxV7OGvIrct/lRomdSRAAaNO8xC0X3LKJdAjB
        GRtSa6kGsN0rNEktOY5oxZnExkapXXg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-oQsKlofdOV6YIUTJGr9-fQ-1; Thu, 28 Jan 2021 12:41:28 -0500
X-MC-Unique: oQsKlofdOV6YIUTJGr9-fQ-1
Received: by mail-ej1-f71.google.com with SMTP id m4so2520652ejc.14
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xjUgxjPulNgQYWnm8Kd2VJVF8wf5pzL5OzfyCR+KDYs=;
        b=MiF34+0tiqtGDnNtB2b6JtgGpfgJRDPpTMjb+xvS3M3qDgx3kzyMwKD3qaxcpJ0z6B
         pIk92mDsXBY8mMbzQPyWJ9cKU3+jSXye8L8TcPBLyGRSeKQXLRCWJ7pHZ85qc2p+ADeK
         /vIBklnjIk7W5NTQsi6XQJx6bdgoo5OLOjT1wd5R088EzsvS5ViLK2CJSpkhovvEpeK5
         AoiwygwGt4doOOIPbmc+R/CdkYO2diirmniuh4GBunbYX/HU0KY+XQ39h1QKsAcgA+dh
         Tv8u9dMN5iQ7LrQbiQPjuZPIq+pl8l3cMsXtYHhVw4CxOpkR6PyI0/BckyodXZkmpHLQ
         iDBA==
X-Gm-Message-State: AOAM533MrTQoHymZm70u+D5pKasTz4AJl4tVRIjUPJYEiAXe04uZJ0A3
        ftmHr0WdnSQQY47jli0EEsij20nabuIRgGUNctPL9f4LVYQ2XcUhQroqXSLDVewDLd9lr7RoEBA
        7EBZniBpAtlzz
X-Received: by 2002:a17:906:4690:: with SMTP id a16mr528056ejr.442.1611855687005;
        Thu, 28 Jan 2021 09:41:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgL/sFywB9SFyFAqg9RSwGvzKcsCZ6aX8kEdnmo6YUPW7pkL+l1WsZTDbxCC3/nt4XeKSFbA==
X-Received: by 2002:a17:906:4690:: with SMTP id a16mr528040ejr.442.1611855686843;
        Thu, 28 Jan 2021 09:41:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r11sm3308283edt.58.2021.01.28.09.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:41:25 -0800 (PST)
Subject: Re: [PATCH v14 08/13] KVM: VMX: Add a synthetic MSR to allow
 userspace VMM to access GUEST_SSP
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-9-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2929c5a-856f-d4f2-4999-1ae6a72288a0@redhat.com>
Date:   Thu, 28 Jan 2021 18:41:24 +0100
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

Better make this fail if !msr_info->host_initiated.

Paolo

