Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E7168276
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgBUP6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:58:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgBUP57 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 10:57:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582300677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=df9ScOEFwTTls6r9Zf0yGfvIdb7PXr3kzlNYfvbsYsg=;
        b=hUthrwSCxBvQHcbh+UCII9HIaYQiMwAQmyCfIbUR1O8Tm4/v9Q3b+R9Ypa2Z4apQp8N1O+
        JZzmpJj8Ad1fFgudMG4CbMNTqQlfrkf7s98aNbXQG+TY5qCxNq24OpKwDEEBhIYEzySYle
        PyIduGPf+QD9qpDqBnmRwLD6SVT2wGk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-iW9KUCn2OUy1w2o764jtOA-1; Fri, 21 Feb 2020 10:57:55 -0500
X-MC-Unique: iW9KUCn2OUy1w2o764jtOA-1
Received: by mail-wr1-f69.google.com with SMTP id c6so1189331wrm.18
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:57:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=df9ScOEFwTTls6r9Zf0yGfvIdb7PXr3kzlNYfvbsYsg=;
        b=OS08r8Zx60M9h1DTLTtlo5eHQX3uzsMFvOhDEajIUUq5hmnqWsZgA43jEuzSldg4i2
         G9Iik2GiAowFt9JjTWQuuOxI+yP80QN5qDzeiK5O1cwiG0zLzwc18Bf4TH7Xcg1RN/H6
         NK2Y+Enr5VwWPxV5QSmaFEvn2LHYPAjcNQY9yHlHZaAmhwPfcl6DAnA/t//2wPubfYrC
         Mb94cKMUWXZblggJ1qlxyt3OZBpsGbt7JijfgfqIyLD1RiMuC5HQ8Jv9BYNc+nQAGrsB
         QrWgwaxgJQj1HGF27n8/HBC5Aouyicpu1OEo3+Y1aMkrO06LwCIfI1IQnXz1A9CFwfQV
         QKXQ==
X-Gm-Message-State: APjAAAXhinCB7E+ZYFSGWYdSAuLO8F6annLg3EStuV4D0JfErnFdhl5v
        reACzH53/knvY/dRVNoasRhHV1CDafofZQriQrMeLtMaEZ+9WuYwPjesX4AtNW6zXr4rHhU9GoV
        dNt4VhzEYp5gK
X-Received: by 2002:adf:fa50:: with SMTP id y16mr47217036wrr.183.1582300674040;
        Fri, 21 Feb 2020 07:57:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDlkP5kKiX/apK/fdyvg4Z7dElRY33EXdeQ2VUj7qgatSBg7QtIiXPLhmh5NVFfYIkSZTSbQ==
X-Received: by 2002:adf:fa50:: with SMTP id y16mr47217010wrr.183.1582300673719;
        Fri, 21 Feb 2020 07:57:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f8sm4240284wru.12.2020.02.21.07.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:57:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/61] KVM: x86: Introduce cpuid_entry_{get,has}() accessors
In-Reply-To: <20200201185218.24473-27-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-27-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:57:52 +0100
Message-ID: <875zg0q6f3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Introduce accessors to retrieve feature bits from CPUID entries and use
> the new accessors where applicable.  Using the accessors eliminates the
> need to manually specify the register to be queried at no extra cost
> (binary output is identical) and will allow adding runtime consistency
> checks on the function and index in a future patch.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c |  9 +++++----
>  arch/x86/kvm/cpuid.h | 46 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 42 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e3026fe638aa..3316963dad3d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -68,7 +68,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  		best->edx |= F(APIC);
>  
>  	if (apic) {
> -		if (best->ecx & F(TSC_DEADLINE_TIMER))
> +		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
>  			apic->lapic_timer.timer_mode_mask = 3 << 17;
>  		else
>  			apic->lapic_timer.timer_mode_mask = 1 << 17;
> @@ -96,7 +96,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
> +	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> +		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	/*
> @@ -155,7 +156,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
>  			break;
>  		}
>  	}
> -	if (entry && (entry->edx & F(NX)) && !is_efer_nx()) {
> +	if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
>  		entry->edx &= ~F(NX);
>  		printk(KERN_INFO "kvm: guest NX capability removed\n");
>  	}
> @@ -387,7 +388,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  		entry->ebx |= F(TSC_ADJUST);
>  
>  		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> -		f_la57 = entry->ecx & F(LA57);
> +		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
>  		cpuid_mask(&entry->ecx, CPUID_7_ECX);
>  		/* Set LA57 based on hardware capability. */
>  		entry->ecx |= f_la57;
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 72a79bdfed6b..64e96e4086e2 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -95,16 +95,10 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
>  	return reverse_cpuid[x86_leaf];
>  }
>  
> -static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> +						  const struct cpuid_reg *cpuid)
>  {
> -	struct kvm_cpuid_entry2 *entry;
> -	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> -
> -	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> -	if (!entry)
> -		return NULL;
> -
> -	switch (cpuid.reg) {
> +	switch (cpuid->reg) {
>  	case CPUID_EAX:
>  		return &entry->eax;
>  	case CPUID_EBX:
> @@ -119,6 +113,40 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
>  	}
>  }
>  
> +static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> +						unsigned x86_feature)

It is just me who dislikes bare 'unsigned'?

> +{
> +	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> +
> +	return __cpuid_entry_get_reg(entry, &cpuid);
> +}
> +
> +static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
> +					   unsigned x86_feature)
> +{
> +	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
> +
> +	return *reg & __feature_bit(x86_feature);
> +}
> +
> +static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
> +					    unsigned x86_feature)
> +{
> +	return cpuid_entry_get(entry, x86_feature);
> +}
> +
> +static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> +
> +	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> +	if (!entry)
> +		return NULL;
> +
> +	return __cpuid_entry_get_reg(entry, &cpuid);
> +}
> +
>  static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
>  {
>  	u32 *reg;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

