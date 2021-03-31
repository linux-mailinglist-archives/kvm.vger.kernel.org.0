Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395DC34FD1C
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 11:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhCaJju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234661AbhCaJjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617183581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Niw9RVMLpiWwvbFfmgVz3YlFQAINUbSdJj3GEMuzArs=;
        b=jWIfOTXRr0vzZErasyR0FIqRtOqFER8tNTZFnjcCogj6C+tNYXqfnj0msmKSf8mTpSc8aL
        ghgnXMrDznRd57mZIX5sqKdPhYn/GOOSEWZ04enCHvyevxiYNkUjYJDX2qK8T27gaDTUpM
        FPNNXt8qhDcT2JqIal/VoOK+InxUL+c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Km6fFxCePDiKFiCzJwyKIQ-1; Wed, 31 Mar 2021 05:39:39 -0400
X-MC-Unique: Km6fFxCePDiKFiCzJwyKIQ-1
Received: by mail-ed1-f71.google.com with SMTP id h5so797618edf.17
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Niw9RVMLpiWwvbFfmgVz3YlFQAINUbSdJj3GEMuzArs=;
        b=Y835wXEp+vURYzzEIrJybbHqjWU9Sgsj7X6gnUF4m1R1lEQyJLxz2mWZ7rCEk7jD7B
         fh5Bcxl2+DxXwMblIlwtIFqqJtbcl+aHCZg1LmYz/gheUIxLPXvUdFDGbLSMeU8ZvykG
         HhsXKMTXdkgpV1Wn94+K0PYiH1gIIlo3PdVsA24jkXYoTSQaNMV+UxwzYIDGTbHk5tRX
         MtvOL0/Sr/NaORRL7M0u8w2LGvKiRoiwf4GMVulQeI/fRGAuOJma87ggbUA9hxNiGDE5
         KZWiAkeGGbLkYAWxvt9wQGm4Dc0KxJ1Z7WxBRBHYU+QBpj2AhHsboILH594ihYV0sZP2
         pfGA==
X-Gm-Message-State: AOAM531XxJuegwZAswnBYR2OHMm1O+XLC7bA3tEU8nzmB6ItyXuaXtYp
        vwQzCJ+7mqUzQ/frIc/1hxMwWr42Xb8VnhbTCUi4gGol3xKukj+t5AgattTkh0H1Sw1SYfYAx5T
        0cy+HeqTitIJK
X-Received: by 2002:a05:6402:8c2:: with SMTP id d2mr2700406edz.4.1617183578685;
        Wed, 31 Mar 2021 02:39:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwigp8aVvoBrByB5xOnevDXQaOw19bQPrXQjYQ+/e58IovzP5/gdWEQOM50p8Thdldh/QYdbQ==
X-Received: by 2002:a05:6402:8c2:: with SMTP id d2mr2700390edz.4.1617183578544;
        Wed, 31 Mar 2021 02:39:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s13sm1151308edr.86.2021.03.31.02.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:39:36 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Account a variety of miscellaneous
 allocations
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210331023025.2485960-1-seanjc@google.com>
 <20210331023025.2485960-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18fa8484-c16b-f5af-09ab-d897eaaf45f4@redhat.com>
Date:   Wed, 31 Mar 2021 11:39:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331023025.2485960-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 04:30, Sean Christopherson wrote:
> Switch to GFP_KERNEL_ACCOUNT for a handful of allocations that are
> clearly associated with a single task/VM.
> 
> Note, there are a several SEV allocations that aren't accounted, but
> those can (hopefully) be fixed by using the local stack for memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/nested.c | 4 ++--
>   arch/x86/kvm/svm/sev.c    | 6 +++---
>   arch/x86/kvm/vmx/vmx.c    | 2 +-
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8523f60adb92..4f9e8b80ef99 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1234,8 +1234,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   
>   	ret  = -ENOMEM;
> -	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
> -	save = kzalloc(sizeof(*save), GFP_KERNEL);
> +	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
> +	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
>   	if (!ctl || !save)
>   		goto out_free;
>   
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 83e00e524513..883ce6bf23b9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -637,7 +637,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		}
>   
>   		ret = -ENOMEM;
> -		blob = kmalloc(params.len, GFP_KERNEL);
> +		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
>   		if (!blob)
>   			goto e_free;
>   
> @@ -1074,7 +1074,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		}
>   
>   		ret = -ENOMEM;
> -		blob = kmalloc(params.len, GFP_KERNEL);
> +		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
>   		if (!blob)
>   			goto e_free;
>   
> @@ -1775,7 +1775,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   			       len, GHCB_SCRATCH_AREA_LIMIT);
>   			return false;
>   		}
> -		scratch_va = kzalloc(len, GFP_KERNEL);
> +		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
>   		if (!scratch_va)
>   			return false;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c8a4a548e96b..5ab25376d718 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -562,7 +562,7 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>   	 * evmcs in singe VM shares same assist page.
>   	 */
>   	if (!*p_hv_pa_pg)
> -		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
>   
>   	if (!*p_hv_pa_pg)
>   		return -ENOMEM;
> 

Queued, thanks.

Paolo

