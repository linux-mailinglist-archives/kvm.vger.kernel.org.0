Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D67368D9D
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhDWHGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:06:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241031AbhDWHGy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 03:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0Cl5FS9BM4Q35WpIm6J5r8zv2qpk0iAb6szpk8n7ZM=;
        b=biGX/NGO0qrC2w7BLajIz4frbV7lOHEKSbvtFeaRXIV1/oIH5JtgxLhOEd5eiZvMQaiZjX
        6S5NQI1hL6vHvgUyMJo5vj4oMK/7kvVK95XDqfWJVAgPgoR5dWOc7Zp1+CzLu6maE71lAB
        d6jYZKdEUo6xnnU8twyR8Tdc1PcRVE8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-_Lihg7JcMASn9_kgQGlwag-1; Fri, 23 Apr 2021 03:06:07 -0400
X-MC-Unique: _Lihg7JcMASn9_kgQGlwag-1
Received: by mail-ej1-f71.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso8029747ejv.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 00:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0Cl5FS9BM4Q35WpIm6J5r8zv2qpk0iAb6szpk8n7ZM=;
        b=kkhYEcCmSKrTmf6oDzPiCd31dvUr99narT1/ccCn0WxvHloW5hZ21eduJw4q5ID457
         9yN9SWl1q2z6Eqr7NPJLANui30P4+8gorlwW/G8hB8xOsyJpRtIM1isEus8+SZ425yMw
         aXNRgBO/6ol303OEaAzd2yT2PoyxyUNP44Y7cDx8UE/Co8nfFrCJKkKLbwMmGKmcQImF
         XQ86sTNiB5Tm9buUzNIwoDQ3LZC+/pRjJeflQeAO2/wQOlmo3mZDYsiD32xfHnFAjLe7
         Lcr9+9uICJEzEzfcYAi52X1VdAQXnIJv1tKzc7vqdYfxpqdU9zMqc/CMUbocbaqrM7qB
         Sumg==
X-Gm-Message-State: AOAM530YjqceEkDUT7O0Dx5HPIjw12sNAoJOgGZLTv6xsjevXYWMR3nj
        XTVq+sSOClz9fOPb3cxolR4esFU8QT8ZBvAVDlr9Ddu2g42UR98xWi0mrm5pZJbzmqddTZ1Hfsz
        Ebl/6OB3v9O4c
X-Received: by 2002:a50:cc4b:: with SMTP id n11mr2774598edi.186.1619161566790;
        Fri, 23 Apr 2021 00:06:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBaNe9SswxfFTcNaWeJfRB2NuJ7rXn8/9taV7As0j13rnKsmU38i2cf1iTBfRl6CSz7Kerww==
X-Received: by 2002:a50:cc4b:: with SMTP id n11mr2774568edi.186.1619161566637;
        Fri, 23 Apr 2021 00:06:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e16sm3918899edu.94.2021.04.23.00.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:06:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fix implicit enum conversion goof in scattered
 reverse CPUID code
To:     Sean Christopherson <seanjc@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
References: <20210421010850.3009718-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b1f385c-3a97-efe0-bb8d-53cdb9c19dbf@redhat.com>
Date:   Fri, 23 Apr 2021 09:06:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210421010850.3009718-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/21 03:08, Sean Christopherson wrote:
> Take "enum kvm_only_cpuid_leafs" in scattered specific CPUID helpers
> (which is obvious in hindsight), and use "unsigned int" for leafs that
> can be the kernel's standard "enum cpuid_leaf" or the aforementioned
> KVM-only variant.  Loss of the enum params is a bit disapponting, but
> gcc obviously isn't providing any extra sanity checks, and the various
> BUILD_BUG_ON() assertions ensure the input is in range.
> 
> This fixes implicit enum conversions that are detected by clang-11.
> 
> Fixes: 4e66c0cb79b7 ("KVM: x86: Add support for reverse CPUID lookup of scattered features")
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Hopefully it's not too late to squash this...

Too late, but I queued this anyway.

Paolo

> 
>   arch/x86/kvm/cpuid.c | 5 +++--
>   arch/x86/kvm/cpuid.h | 2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 96e41e1a1bde..e9d644147bf5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -365,7 +365,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>   }
>   
>   /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
> -static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
> +static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>   {
>   	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>   	struct kvm_cpuid_entry2 entry;
> @@ -378,7 +378,8 @@ static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
>   	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
>   }
>   
> -static __always_inline void kvm_cpu_cap_init_scattered(enum cpuid_leafs leaf, u32 mask)
> +static __always_inline
> +void kvm_cpu_cap_init_scattered(enum kvm_only_cpuid_leafs leaf, u32 mask)
>   {
>   	/* Use kvm_cpu_cap_mask for non-scattered leafs. */
>   	BUILD_BUG_ON(leaf < NCAPINTS);
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index eeb4a3020e1b..7bb4504a2944 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -236,7 +236,7 @@ static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
>   }
>   
>   static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
> -						 enum cpuid_leafs leaf)
> +						 unsigned int leaf)
>   {
>   	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
>   
> 

