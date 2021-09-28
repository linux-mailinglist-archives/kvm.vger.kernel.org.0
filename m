Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC841B47E
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbhI1Q5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:57:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhI1Q5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632848127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uud3srIrk5LfnP+oOg8qPl4zOzoxLHNL93JwPYw5eAU=;
        b=asN0FPqXXpkBpxMEGOQ6pD3zoJzRm4nXH+7UumltI0I+uKP36rc3u/NG/gAUB75soAWmw+
        foxgMLybt2DQAi8Xyx0mE+WKfYEryDcE8mDWPC8jvgFfqvmfq4AgFau5M1bMxvQMsDUbT9
        nMN3MAOIhkYws/o/pDh0tnhBb5GnD/Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-qte1gzrbN1ux_BBCXQXIUg-1; Tue, 28 Sep 2021 12:55:26 -0400
X-MC-Unique: qte1gzrbN1ux_BBCXQXIUg-1
Received: by mail-ed1-f72.google.com with SMTP id h6-20020a50c386000000b003da01adc065so22495890edf.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uud3srIrk5LfnP+oOg8qPl4zOzoxLHNL93JwPYw5eAU=;
        b=T+xSKu+/O9sae+N4/TCD0uLWSxlvm+1bKVUP7qNXSsXoCZHCHe09BF8U6wnman2acj
         WCG2EeLxfprdNgnDczTizH4sQKl3z2xhEpdqvw5ksJEoIOgsY5spU8uj0H+8L81N6E1K
         4Vio1/CBg5zSBwxWYMNtoCgCgxBZDSN4pQw4AjDYm48kkWsyON0sn2cfHtdcmpckKVMD
         tN4lFjkokdofNlw6HLPJwAyAtxnMHQVXhN1UnFuX8D6Lgttp/5A9ierPKFZTdJNA9vAl
         0Id+b3ZGJ3wEnmW4NU0u8o8BIeSxeN9LlwtecGYO+LVp+5w+HvGQLqR2yrsHQDjbgrbU
         Gaig==
X-Gm-Message-State: AOAM5321hMPq1DNfvQi2h8Ap9IT3W9lD68EmXgdJJ08UcvrO/J4ErsPk
        EM/4cKuUyBzVHCEdKTiUN1KLgtGwIjUkA2rmavkyfiLMBX0sw48W78Ie2BT2nf0JCrbsxUdYNAG
        FPgHQgvU07H3m
X-Received: by 2002:a50:9d02:: with SMTP id v2mr8699642ede.105.1632848125134;
        Tue, 28 Sep 2021 09:55:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUA31gkCDuEDDhxw+ZgG5BaT1/c/9pvhQxrlyQp/LzldVOGXUQaidw+sxotP0p8aexjvZXjg==
X-Received: by 2002:a50:9d02:: with SMTP id v2mr8699623ede.105.1632848124937;
        Tue, 28 Sep 2021 09:55:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d22sm11289571ejj.47.2021.09.28.09.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:55:24 -0700 (PDT)
Message-ID: <f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com>
Date:   Tue, 28 Sep 2021 18:55:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 2/5] nSVM: Check for optional commands and reserved
 encodings of TLB_CONTROL in nested VMCB
Content-Language: en-US
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
 <20210920235134.101970-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210920235134.101970-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 01:51, Krish Sadhukhan wrote:
> According to section "TLB Flush" in APM vol 2,
> 
>      "Support for TLB_CONTROL commands other than the first two, is
>       optional and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].
> 
>       All encodings of TLB_CONTROL not defined in the APM are reserved."
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5e13357da21e..028cc2a1f028 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -235,6 +235,22 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
>   	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>   }
>   
> +static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
> +{
> +	switch(tlb_ctl) {
> +		case TLB_CONTROL_DO_NOTHING:
> +		case TLB_CONTROL_FLUSH_ALL_ASID:
> +			return true;
> +		case TLB_CONTROL_FLUSH_ASID:
> +		case TLB_CONTROL_FLUSH_ASID_LOCAL:
> +			if (guest_cpuid_has(vcpu, X86_FEATURE_FLUSHBYASID))
> +				return true;
> +			fallthrough;

Since nested FLUSHBYASID is not supported yet, this second set of case 
labels can go away.

Queued with that change, thanks.

Paolo

> +		default:
> +			return false;
> +	}
> +}
> +
>   static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>   				       struct vmcb_control_area *control)
>   {
> @@ -254,6 +270,9 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>   					   IOPM_SIZE)))
>   		return false;
>   
> +	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
> +		return false;
> +
>   	return true;
>   }
>   
> 

