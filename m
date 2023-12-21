Return-Path: <kvm+bounces-5093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F9C81BC85
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EBD01F22535
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA2058231;
	Thu, 21 Dec 2023 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VigL3GYq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9E75822E
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703177989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ky8oNKjijOb1tIn4ayWtmUKjCWxopvvJegMZ8w2vi34=;
	b=VigL3GYqVD/EHFP9PD2XY0BKZTIcDu4m3RffBxHPYFmkh4OO7KM0RKDoHWt5g141gZReCD
	Ychg1gx+kQ3W6m6vr84I6XSQRwGT4lbSilavbvJNJvZZPNX/EUgHYUmwxbTR/qHNyzGtI5
	myh3tBvrSHigzTqfcUAlWx4P+DD15Bo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-Oz9vWOGdMGqe1camdG7uWw-1; Thu, 21 Dec 2023 11:59:47 -0500
X-MC-Unique: Oz9vWOGdMGqe1camdG7uWw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a26a096b87fso49724366b.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 08:59:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703177986; x=1703782786;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ky8oNKjijOb1tIn4ayWtmUKjCWxopvvJegMZ8w2vi34=;
        b=S4MGwk4HzlosY+K2e7fFguangt24hnnZnob4D93gw1oigQtKJF+/hmoJIqAsCVVrBF
         xGrccZ8umR3j+U9L3DC19S03SGx3v3FoDwouZ5s6LIDm+SUbMHIafqULM3J1CMrWIx4v
         Btd/fnXCnkTscuWCKVvYuaZlCbwBVf5N6tpUiSZ6niOJp7oTHIITpyvhHn8GERZgQjeO
         5URQEhV9NQOGe92CYXg9KAgTyrFyo0mKeb9SpQhZ4TgMeI7EIWDWDSUfy/O8NpOyQUGF
         zwiF0a/uSSfCdqqJImE63Ip8kyIFatVCAZQf0PLospCsK6EstfYiKNkHnQ2i4gHwLHVL
         BzPQ==
X-Gm-Message-State: AOJu0YwQdRcHI4tg89wuUcLoBQKqPr4AFqIH0ALG+9dWLPzugAOQjAFR
	ruTaYEmtQeiPNRgF7n3eoxIxXvlL482Y97AUbkeCQZBnExbU3DC4mH2ImSMdO590VB5H9Tg6ZKm
	TaFoZXyfgjY597iMZ//3P
X-Received: by 2002:a17:906:eb14:b0:a1e:6f75:d9f6 with SMTP id mb20-20020a170906eb1400b00a1e6f75d9f6mr53002ejb.74.1703177986111;
        Thu, 21 Dec 2023 08:59:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJww3NmjP4GfkogpnV//xBltozl1W6BKERNxb21AASQ3+QDCRv3QeGeoJNUYihJ1w99Z0N+A==
X-Received: by 2002:a17:906:eb14:b0:a1e:6f75:d9f6 with SMTP id mb20-20020a170906eb1400b00a1e6f75d9f6mr52996ejb.74.1703177985764;
        Thu, 21 Dec 2023 08:59:45 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id j13-20020a170906254d00b009fea232316bsm1141978ejb.193.2023.12.21.08.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 08:59:45 -0800 (PST)
Message-ID: <daaf098a6219310b6b1c1e3dc147fbb7e48b6f54.camel@redhat.com>
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest
 CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 21 Dec 2023 18:59:43 +0200
In-Reply-To: <ZWk8IMZamuemfwXG@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-4-seanjc@google.com>
	 <3ad69657ba8e1b19d150db574193619cf0cb34df.camel@redhat.com>
	 <ZWk8IMZamuemfwXG@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-11-30 at 17:51 -0800, Sean Christopherson wrote:
> On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> > On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > > +/*
> > > + * This isn't truly "unsafe", but all callers except kvm_cpu_after_set_cpuid()
> > > + * should use __cpuid_entry_get_reg(), which provides compile-time validation
> > > + * of the input.
> > > + */
> > > +static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
> > > +{
> > > +	switch (reg) {
> > > +	case CPUID_EAX:
> > > +		return entry->eax;
> > > +	case CPUID_EBX:
> > > +		return entry->ebx;
> > > +	case CPUID_ECX:
> > > +		return entry->ecx;
> > > +	case CPUID_EDX:
> > > +		return entry->edx;
> > > +	default:
> > > +		WARN_ON_ONCE(1);
> > > +		return 0;
> > > +	}
> > > +}
> 
> ...
> 
> > >  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  {
> > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > >  	struct kvm_cpuid_entry2 *best;
> > >  	bool allow_gbpages;
> > > +	int i;
> > >  
> > > -	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
> > > +	BUILD_BUG_ON(ARRAY_SIZE(reverse_cpuid) != NR_KVM_CPU_CAPS);
> > > +
> > > +	/*
> > > +	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
> > > +	 * honor userspace's definition for features that don't require KVM or
> > > +	 * hardware management/support (or that KVM simply doesn't care about).
> > > +	 */
> > > +	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> > > +		const struct cpuid_reg cpuid = reverse_cpuid[i];
> > > +
> > > +		best = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
> > > +		if (best)
> > > +			vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(best, cpuid.reg);
> > 
> > Why not just use __cpuid_entry_get_reg? 
> > 
> > cpuid.reg comes from read/only 'reverse_cpuid' anyway, and in fact
> > it seems that all callers of __cpuid_entry_get_reg, take the reg value from
> > x86_feature_cpuid() which also takes it from 'reverse_cpuid'.
> > 
> > So if the compiler is smart enough to not complain in these cases, I don't
> > see why this case is different.
> 
> It's because the input isn't a compile-time constant, and so the BUILD_BUG() in
> the default path will fire. 
>  All of the compile-time assertions in reverse_cpuid.h
> rely on the feature being a constant value, which allows the compiler to optimize
> away the dead paths, i.e. turn __cpuid_entry_get_reg()'s switch statement into
> simple pointer arithmetic and thus omit the BUILD_BUG() code.

In the above code, assuming that the compiler really treats the reverse_cpuid as const
(if that assumption is not true, then all uses of __cpuid_entry_get_reg are also not compile
time constant either),
then the 'reg' value depends only on 'i', and therefore for each iteration of the loop,
the compiler does know the compile time value of the 'reg',
and so it can easily prove that 'default' case in __cpuid_entry_get_reg can't be reached,
and thus eliminate that BUILD_BUG().


> 
> > Also why not to initialize guest_caps = host_caps & userspace_cpuid?
> > 
> > If this was the default we won't need any guest_cpu_cap_restrict and such,
> > instead it will just work.
> 
> Hrm, I definitely like the idea.  Unfortunately, unless we do an audit of all
> ~120 uses of guest_cpuid_has(), restricting those based on kvm_cpu_caps might
> break userspace.

120 uses is not that bad, IMHO it is worth it - we won't need to deal with that
in the future.

How about a compromise - you change the patches such as it will be possible to remove
these cases one by one, and also all new cases will be fully automatic?


> 
> Aside from purging the governed feature nomenclature, the main goal of this series
> provide a way to do fast lookups of all known guest CPUID bits without needing to
> opt-in on a feature-by-feature basis, including for features that are fully
> controlled by userspace.

I'll note that, this makes sense.
> 
> It's definitely doable, but I'm not all that confident that the end result would
> be a net positive, e.g. I believe we would need to special case things like the
> feature bits that gate MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.  MOVBE and RDPID
> are other features that come to mind, where KVM emulates the feature in software
> but it won't be set in kvm_cpu_caps.

> 
> Oof, and MONITOR and MWAIT too, as KVM deliberately doesn't advertise those to
> userspace.
> 
> So yeah, I'm not opposed to trying that route at some point, but I really don't
> want to do that in this series as the risk of subtly breaking something is super
> high.
> 
> > Special code will only be needed in few more complex cases, like forced exposed
> > of a feature to a guest due to a virtualization hole.
> > 
> > 
> > > +		else
> > > +			vcpu->arch.cpu_caps[i] = 0;
> > > +	}
> > >  
> > >  	/*
> > >  	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> > > @@ -342,8 +380,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  	 */
> > >  	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
> > >  				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
> > > -	if (allow_gbpages)
> > > -		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
> > > +	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
> > 
> > IMHO the original code was more readable, now I need to look up the
> > 'guest_cpu_cap_change()' to understand what is going on.
> 
> The change is "necessary".  The issue is that with the caps 0-initialied, the
> !allow_gbpages could simply do nothing.  Now, KVM needs to explicitly clear the
> flag, i.e. would need to do:
> 
> 	if (allow_gbpages)
> 		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
> 	else
> 		guest_cpu_cap_clear(vcpu, X86_FEATURE_GBPAGES);

I understand now but I am complaining more about the fact that I like the
explicit longer version better than calling guest_cpu_cap_change because it's not obvious
what guest_cpu_cap_change really does. I am not going to fight over this though,
just saying.

> 
> I don't much love the name either, but it pairs with cpuid_entry_change() and I
> want to keep the kvm_cpu_cap, cpuid_entry, and guest_cpu_cap APIs in sync as far
> as the APIs go.  The only reason kvm_cpu_cap_change() doesn't exist is because
> there aren't any flows that need to toggle a bit.
> 
> > >  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 8a99a73b6ee5..5827328e30f1 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -4315,14 +4315,14 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
> > >  	 * the guest read/write access to the host's XSS.
> > >  	 */
> > > -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> > > -	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> > > -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> > > -		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
> > > +	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> > > +			     boot_cpu_has(X86_FEATURE_XSAVE) &&
> > > +			     boot_cpu_has(X86_FEATURE_XSAVES) &&
> > > +			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
> > 
> > In theory this change does change behavior, now the X86_FEATURE_XSAVE will
> > be set iff the condition is true, but before it was set *if* the condition was true.
> 
> No, before it was set if and only if the condition was true, because in that case
> caps were 0-initialized, i.e. this was/is the only way for XSAVE to be set.
> 
> > > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
> > > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
> > > -	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
> > > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_NRIPS);
> > > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_TSCRATEMSR);
> > > +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_LBRV);
> > 
> > One of the main reasons I don't like governed features is this manual list.
> 
> To be fair, the manual lists predate the governed features.

100% agree, however the point of governed features was to simplify this list,
the point of this patch set is to simplify these lists and yet they still remain,
more or less untouched, and we will still need to maintain them.

Again I do think that governed features and/or this patchset are better than
the mess that was there before, but a part of me wants to fully get rid of this mess instead
of just making it a bit more beautiful. 

> 
> > I want to reach the point that one won't need to add anything manually,
> > unless there is a good reason to do so, and there are only a few exceptions
> > when the guest cap is set, while the host's isn't.
> 
> Yeah, agreed.

I am glad that we are on the same page here.

Best regards,
	Maxim Levitsky

> 



