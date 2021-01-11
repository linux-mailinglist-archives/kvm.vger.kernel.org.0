Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1D2F1C11
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbhAKRRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:17:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbhAKRRO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 12:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610385348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XG4nE77l9V+rRZuoWuOzDt9ZOhzNiCqRWdt18ZZfUjs=;
        b=UCINYGTvcxJXkN+Ktr0d6Oe6/i5FX6vwwxbBLqC2UkciHHezuFGmbPPuJmBPuLph/WY1HU
        Gt2fu8dRKgZZivqA44K2JwelMkgmSc1e+iwAV4jw8DmLLNNBnTTM5WPArNRPwmH7BJ3Deh
        kFEcGNG4I2smuOAFasNwqaYEAS8Ii1w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-F_UaqxqbPNiNNISNqg80Zg-1; Mon, 11 Jan 2021 12:15:46 -0500
X-MC-Unique: F_UaqxqbPNiNNISNqg80Zg-1
Received: by mail-ed1-f71.google.com with SMTP id d12so8536766edx.23
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XG4nE77l9V+rRZuoWuOzDt9ZOhzNiCqRWdt18ZZfUjs=;
        b=jP4RNzR/FvnLxlqNfXB7jzZgWlFc8d6dhS2QRMYwvlwWd1TyYXsv9zVKIdwbM6kcg7
         lrVK4zqxKC6tVMCvxDXbAYJ69KiQiTv6Y1VlvPR1FNg/dz8kYd/apRc/3/UuqIJBqMgA
         +rO2WEpZEoJ+2AjPk4iQILSA4893fjjkGRXrRTbCO+eUmwFfyNgA4Y0U8szcVI3JYK8u
         mZJxr2eLmOAnWaiFRq0DKccmI/MZEkAzuFrk2b6GDAhlZ8XvIPKa0k8IPA/gt2+w1bEC
         XBPZnZzciMANnbtsYLGBZNM9tjC/CUs815OXK/RcVSXjIRyflepiezKoPhJMQBz/Y7w/
         YI6g==
X-Gm-Message-State: AOAM532pyocaoXgA9goGI1aSt06uLc4dY33EssR2k6vwposn/Kq31W3u
        Ihgz0gHO4BGW++CeQMOkkc7EXVpeREKS6fCmm2JfMVDO6ELgT1ea0If9dzE4qw+M0Ax7YRo/4jx
        vveeh5oFLZSJQ
X-Received: by 2002:a05:6402:318f:: with SMTP id di15mr275587edb.237.1610385345332;
        Mon, 11 Jan 2021 09:15:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwtU8IgVCF7zsM451sQJKQOHdiAFlqQKj7bLZn7B0U5ai/6SyhYTAzdtk72H5Nhzn+BgqLiKQ==
X-Received: by 2002:a05:6402:318f:: with SMTP id di15mr275559edb.237.1610385345089;
        Mon, 11 Jan 2021 09:15:45 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a13sm211657edb.76.2021.01.11.09.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:15:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Cun Li <cun.jia.li@gmail.com>
Cc:     seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cun Li <cun.jia.li@gmail.com>,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: update depracated jump label API
In-Reply-To: <20210111152435.50275-1-cun.jia.li@gmail.com>
References: <20210111152435.50275-1-cun.jia.li@gmail.com>
Date:   Mon, 11 Jan 2021 18:15:43 +0100
Message-ID: <87h7nn8ke8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cun Li <cun.jia.li@gmail.com> writes:

> The use of 'struct static_key' and 'static_key_false' is
> deprecated. Use the new API.
>
> Signed-off-by: Cun Li <cun.jia.li@gmail.com>
> ---
>  arch/x86/kvm/lapic.h         | 6 +++---
>  arch/x86/kvm/mmu/mmu_audit.c | 4 ++--
>  arch/x86/kvm/x86.c           | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 4fb86e3a9dd3..b7aa76e2678e 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -176,7 +176,7 @@ extern struct static_key kvm_no_apic_vcpu;
>  
>  static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
>  {
> -	if (static_key_false(&kvm_no_apic_vcpu))
> +	if (static_branch_unlikely(&kvm_no_apic_vcpu))
>  		return vcpu->arch.apic;
>  	return true;
>  }
> @@ -185,7 +185,7 @@ extern struct static_key_deferred apic_hw_disabled;
>  
>  static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
>  {
> -	if (static_key_false(&apic_hw_disabled.key))
> +	if (static_branch_unlikely(&apic_hw_disabled.key))
>  		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
>  	return MSR_IA32_APICBASE_ENABLE;
>  }
> @@ -194,7 +194,7 @@ extern struct static_key_deferred apic_sw_disabled;
>  
>  static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
>  {
> -	if (static_key_false(&apic_sw_disabled.key))
> +	if (static_branch_unlikely(&apic_sw_disabled.key))
>  		return apic->sw_enabled;
>  	return true;
>  }
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index c8d51a37e2ce..8a4b3510151a 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -234,7 +234,7 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>  }
>  
>  static bool mmu_audit;
> -static struct static_key mmu_audit_key;
> +static DEFINE_STATIC_KEY_FALSE(mmu_audit_key);
>  
>  static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
>  {
> @@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
>  
>  static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
>  {
> -	if (static_key_false((&mmu_audit_key)))
> +	if (static_branch_unlikely((&mmu_audit_key)))
>  		__kvm_mmu_audit(vcpu, point);
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a8969a6dd06..b8c05ef26942 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10339,7 +10339,7 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>  	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
>  }
>  
> -struct static_key kvm_no_apic_vcpu __read_mostly;
> +__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_no_apic_vcpu);
>  EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
>  
>  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)

mmu_audit_key can only be true or false so it would also be nice to use 
static_branch_enable()/static_branch_disable() for it and not
static_key_slow_inc()/static_key_slow_dec() we currently use (as it
sounds weird to increment 'false').

kvm_no_apic_vcpu is different, we actually need to increase it with
every vCPU which doesn't have LAPIC but maybe we can at least switch to
static_branch_inc()/static_branch_dec(). It is still weird we initialize
it to 'false' but it seems to be a documented behavior. From
include/linux/jump_label.h:

"... Thus, static_branch_inc() can be thought of as a 'make more true'
 and static_branch_dec() as a 'make more false'"

so .. oh well.

-- 
Vitaly

