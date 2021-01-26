Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88375305C82
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313777AbhAZWpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:45:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387900AbhAZSST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 13:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611685010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tmAwlqcFRm5dq0TJYgLmlazW5uNrUdUC5Uj9cYPhSCQ=;
        b=QngOMueFpmXC5muMciEQR+Ie4vKCvpehaF8JOnNXwRmBK4HAv76VahEo5tVRRz0YAGmX+n
        /b0Hwb8iPp7yJBnQCffkDrUcAKMNKT0HAanKBiVBjJAGhWF4+k63a88vy9b5PQJPGH7hh+
        xAp3ysISlHXLz3cit68uB+FswndtBro=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-fxzXv8a3OmqR6r69CQ6JnQ-1; Tue, 26 Jan 2021 13:16:49 -0500
X-MC-Unique: fxzXv8a3OmqR6r69CQ6JnQ-1
Received: by mail-ed1-f70.google.com with SMTP id k5so9777074edk.15
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tmAwlqcFRm5dq0TJYgLmlazW5uNrUdUC5Uj9cYPhSCQ=;
        b=P7Ou7dA7V8s4dtzWDOm1mMhMqWk3aLI7e3oXzd7CD+tkeo1rTcLbgwfAUlB0XPZsVZ
         SBjJKWJuSEkI99+0T7Jc3SbMyAWIwb7yd7HmhWS0jd80EwaVbLuC22UT2gkBYPXr238T
         mUWn27TThZCJVNTPsyINqBup2cxFa58gQu7uBq6yrPWq25ykCdGgFf0IjqYCAk9Gv7Og
         vtDu+TMivX1gF+F0tsj2d9WEggk1Qvub29gLr47izX1wzM1VwVe1XeI6Zt0hJN9wrsA5
         rJmtfjaYrQ7cBDHQ9lS0HRgGAzfwYJcHyEP24iI4yKSiuFc7zZyICEDDL7k482Z0ZeTy
         3L1Q==
X-Gm-Message-State: AOAM533F7/Qo/QX9ex2MRf7AlaCfi8LQKhytFapFgNKb4q2N9pqnkNGk
        HyJx4ziE12Jl9R1gjhqtHEkitNBbibn/uXA+Qjhwjs5q5mjZqkx6uDTJ7LA1UW7zORXypHm7H2a
        67Ws9FyyoMkht
X-Received: by 2002:a17:906:705:: with SMTP id y5mr4274366ejb.83.1611685008078;
        Tue, 26 Jan 2021 10:16:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsSJBnwQfhxbfgn+ahh/+fnRtzUKGdLjXMNEwDv1vHszj2URdSImu5elTuKBMInycbKAzeFg==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr4274344ejb.83.1611685007865;
        Tue, 26 Jan 2021 10:16:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o4sm6591828edw.78.2021.01.26.10.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:16:47 -0800 (PST)
Subject: Re: [RFC 3/7] KVM: MMU: Rename the pkru to pkr
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-4-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0116e8c6-2e2a-173a-a903-e3d3e9f05a2c@redhat.com>
Date:   Tue, 26 Jan 2021 19:16:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200807084841.7112-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/20 10:48, Chenyi Qiang wrote:
> PKRU represents the PKU register utilized in the protection key rights
> check for user pages. Protection Keys for Superviosr Pages (PKS) extends
> the protection key architecture to cover supervisor pages.
> 
> Rename the *pkru* related variables and functions to *pkr* which stands
> for both of the PKRU and PKRS. It makes sense because both registers
> have the same format. PKS and PKU can also share the same bitmap to
> cache the conditions where protection key checks are needed.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/mmu.h              | 12 ++++++------
>   arch/x86/kvm/mmu/mmu.c          | 18 +++++++++---------
>   3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..6b739d0d1c97 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -427,7 +427,7 @@ struct kvm_mmu {
>   	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
>   	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
>   	*/
> -	u32 pkru_mask;
> +	u32 pkr_mask;
>   
>   	u64 *pae_root;
>   	u64 *lm_root;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 444bb9c54548..0c2fdf0abf22 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -193,8 +193,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   	u32 errcode = PFERR_PRESENT_MASK;
>   
>   	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
> -	if (unlikely(mmu->pkru_mask)) {
> -		u32 pkru_bits, offset;
> +	if (unlikely(mmu->pkr_mask)) {
> +		u32 pkr_bits, offset;
>   
>   		/*
>   		* PKRU defines 32 bits, there are 16 domains and 2
> @@ -202,15 +202,15 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   		* index of the protection domain, so pte_pkey * 2 is
>   		* is the index of the first bit for the domain.
>   		*/
> -		pkru_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
> +		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>   
>   		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
>   		offset = (pfec & ~1) +
>   			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
>   
> -		pkru_bits &= mmu->pkru_mask >> offset;
> -		errcode |= -pkru_bits & PFERR_PK_MASK;
> -		fault |= (pkru_bits != 0);
> +		pkr_bits &= mmu->pkr_mask >> offset;
> +		errcode |= -pkr_bits & PFERR_PK_MASK;
> +		fault |= (pkr_bits != 0);
>   	}
>   
>   	return -(u32)fault & errcode;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d6a0ae7800c..481442f5e27a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4716,20 +4716,20 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
>   * away both AD and WD.  For all reads or if the last condition holds, WD
>   * only will be masked away.
>   */
> -static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   				bool ept)
>   {
>   	unsigned bit;
>   	bool wp;
>   
>   	if (ept) {
> -		mmu->pkru_mask = 0;
> +		mmu->pkr_mask = 0;
>   		return;
>   	}
>   
>   	/* PKEY is enabled only if CR4.PKE and EFER.LMA are both set. */
>   	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) || !is_long_mode(vcpu)) {
> -		mmu->pkru_mask = 0;
> +		mmu->pkr_mask = 0;
>   		return;
>   	}
>   
> @@ -4763,7 +4763,7 @@ static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   		/* PKRU.WD stops write access. */
>   		pkey_bits |= (!!check_write) << 1;
>   
> -		mmu->pkru_mask |= (pkey_bits & 3) << pfec;
> +		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
>   	}
>   }
>   
> @@ -4785,7 +4785,7 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
>   
>   	reset_rsvds_bits_mask(vcpu, context);
>   	update_permission_bitmask(vcpu, context, false);
> -	update_pkru_bitmask(vcpu, context, false);
> +	update_pkr_bitmask(vcpu, context, false);
>   	update_last_nonleaf_level(vcpu, context);
>   
>   	MMU_WARN_ON(!is_pae(vcpu));
> @@ -4815,7 +4815,7 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
>   
>   	reset_rsvds_bits_mask(vcpu, context);
>   	update_permission_bitmask(vcpu, context, false);
> -	update_pkru_bitmask(vcpu, context, false);
> +	update_pkr_bitmask(vcpu, context, false);
>   	update_last_nonleaf_level(vcpu, context);
>   
>   	context->page_fault = paging32_page_fault;
> @@ -4925,7 +4925,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>   	}
>   
>   	update_permission_bitmask(vcpu, context, false);
> -	update_pkru_bitmask(vcpu, context, false);
> +	update_pkr_bitmask(vcpu, context, false);
>   	update_last_nonleaf_level(vcpu, context);
>   	reset_tdp_shadow_zero_bits_mask(vcpu, context);
>   }
> @@ -5032,7 +5032,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>   	context->mmu_role.as_u64 = new_role.as_u64;
>   
>   	update_permission_bitmask(vcpu, context, true);
> -	update_pkru_bitmask(vcpu, context, true);
> +	update_pkr_bitmask(vcpu, context, true);
>   	update_last_nonleaf_level(vcpu, context);
>   	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
>   	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
> @@ -5103,7 +5103,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>   	}
>   
>   	update_permission_bitmask(vcpu, g_context, false);
> -	update_pkru_bitmask(vcpu, g_context, false);
> +	update_pkr_bitmask(vcpu, g_context, false);
>   	update_last_nonleaf_level(vcpu, g_context);
>   }
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

