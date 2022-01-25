Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C21F49B6CD
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358240AbiAYOra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1579397AbiAYOoN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 09:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643121845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rENnptulbHCfDS4+95Um4dqwijjfumjVEPP1UeTIm6E=;
        b=ZQdc3zUB2sCjeZhOUm1rvstaqT+sD6hvO1ANDEXk8sVs1fxYpFZKTMS4DcNjvxwyZYWTyz
        HpisUEmNZTy5Q4pXU8IK0WZUW/Zu84VFv7uNP6GY5WMG2YGWn4KNDpIn9F0AKsYXNpX3lq
        wkSZ8v6njXAUWt1j53Pakw+Le9WFyJQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-KcH9qLaANzKCu4dZ9SyEjg-1; Tue, 25 Jan 2022 09:44:03 -0500
X-MC-Unique: KcH9qLaANzKCu4dZ9SyEjg-1
Received: by mail-ed1-f70.google.com with SMTP id a18-20020aa7d752000000b00403d18712beso15106472eds.17
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 06:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rENnptulbHCfDS4+95Um4dqwijjfumjVEPP1UeTIm6E=;
        b=pSTZLE+LcqYXLMW3kFQxnsHFKD2m6nuR/sRHpflLfqFKutOZkhlPTHJ/CU2iF3S2hj
         Q86LTqhZIkcWyWXnO1EaTv4OwXen0TluMGGKNzYNVaUCbvW0WHlYy6MEdhS42DmnlZLA
         bHIewhamXyIZeomCK/WhQZlHIwxMrAd5WjwxvUHPd2K/HeBI77BRlbIEk/GppS/s/7XL
         3eTFuz3Dy1dTQn5oB4rznKu38Yye/JStgMLYbQNjePcrl/uTrmflC0HBuTt4NLeFVQKJ
         fGi5Bnwiw3A6ZMoRQ9GbUXwNpMinecI2YXoz4R6fAMipk0/k07nVhgYyDh6mwy47SZS+
         X5uQ==
X-Gm-Message-State: AOAM532sHfYxTOrexY9g02o03Va8VvEtoxTnIKbShygoWZc3PYDARUje
        dMi2F9uoK5BOwc77n0le7txTouquknDOGGrE9CyoFJp00m2AZxjkRmz8fgFpV5GPYksgZRmq0uu
        xgSt6Ik1rd/wC
X-Received: by 2002:a17:907:3f20:: with SMTP id hq32mr7856855ejc.613.1643121842558;
        Tue, 25 Jan 2022 06:44:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEJL6wCGgsczKUNeWJNSRDK85H0EGdelC3UINNqMmijJmdpawYhtQs9uaKEzdWA7vIIicoCQ==
X-Received: by 2002:a17:907:3f20:: with SMTP id hq32mr7856840ejc.613.1643121842297;
        Tue, 25 Jan 2022 06:44:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j20sm6211747eje.81.2022.01.25.06.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 06:44:01 -0800 (PST)
Message-ID: <89857bde-f9c8-4d5f-0e3f-a53829520284@redhat.com>
Date:   Tue, 25 Jan 2022 15:44:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Tian Kevin <kevin.tian@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125115223.33707-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125115223.33707-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 12:52, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> With the help of xstate_get_guest_group_perm(), KVM can exclude unpermitted
> xfeatures in cpuid.0xd.0.eax, in which case the corresponding xfeatures
> sizes should also be matched to the permitted xfeatures.
> 
> To fix this inconsistency, the permitted_xcr0 and permitted_xss are defined
> consistently, which implies 'supported' plus certain permissions for this
> task, and it also fixes cpuid.0xd.1.ebx and later leaf-by-leaf queries.
> 
> Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1 -> v2 Changelog:
> - Drop the use of shadow variable; (Paolo)
> - Define permitted_xss consistently; (Kevin)
> 
> Previous:
> https://lore.kernel.org/kvm/20220124080251.60558-1-likexu@tencent.com/
> 
>   arch/x86/kvm/cpuid.c | 25 +++++++++++++------------
>   1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3902c28fb6cb..07844d15dfdf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -887,13 +887,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		}
>   		break;
>   	case 0xd: {
> -		u64 guest_perm = xstate_get_guest_group_perm();
> +		u64 permitted_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
> +		u64 permitted_xss = supported_xss;
>   
> -		entry->eax &= supported_xcr0 & guest_perm;
> -		entry->ebx = xstate_required_size(supported_xcr0, false);
> +		entry->eax &= permitted_xcr0;
> +		entry->ebx = xstate_required_size(permitted_xcr0, false);
>   		entry->ecx = entry->ebx;
> -		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
> -		if (!supported_xcr0)
> +		entry->edx &= permitted_xcr0 >> 32;
> +		if (!permitted_xcr0)
>   			break;
>   
>   		entry = do_host_cpuid(array, function, 1);
> @@ -902,20 +903,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   
>   		cpuid_entry_override(entry, CPUID_D_1_EAX);
>   		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
> -			entry->ebx = xstate_required_size(supported_xcr0 | supported_xss,
> +			entry->ebx = xstate_required_size(permitted_xcr0 | permitted_xss,
>   							  true);
>   		else {
> -			WARN_ON_ONCE(supported_xss != 0);
> +			WARN_ON_ONCE(permitted_xss != 0);
>   			entry->ebx = 0;
>   		}
> -		entry->ecx &= supported_xss;
> -		entry->edx &= supported_xss >> 32;
> +		entry->ecx &= permitted_xss;
> +		entry->edx &= permitted_xss >> 32;
>   
>   		for (i = 2; i < 64; ++i) {
>   			bool s_state;
> -			if (supported_xcr0 & BIT_ULL(i))
> +			if (permitted_xcr0 & BIT_ULL(i))
>   				s_state = false;
> -			else if (supported_xss & BIT_ULL(i))
> +			else if (permitted_xss & BIT_ULL(i))
>   				s_state = true;
>   			else
>   				continue;
> @@ -929,7 +930,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			 * invalid sub-leafs.  Only valid sub-leafs should
>   			 * reach this point, and they should have a non-zero
>   			 * save state size.  Furthermore, check whether the
> -			 * processor agrees with supported_xcr0/supported_xss
> +			 * processor agrees with permitted_xcr0/permitted_xss
>   			 * on whether this is an XCR0- or IA32_XSS-managed area.
>   			 */
>   			if (WARN_ON_ONCE(!entry->eax || (entry->ecx & 0x1) != s_state)) {

Queued, thanks.

Paolo

