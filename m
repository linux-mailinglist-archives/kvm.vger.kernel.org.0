Return-Path: <kvm+bounces-5701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1BB824CC7
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 03:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09C93B22B94
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 02:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C5820DD3;
	Fri,  5 Jan 2024 02:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2qqYxwRL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3B20B1B
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 02:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d4ce9f52a0so6054225ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 18:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704420793; x=1705025593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+grBcrGVuvV4liSJu69kJ2ylLSuHocR0OaEGbLjwBA=;
        b=2qqYxwRLJoVj3b/23IxQUOz6jMEsi3FaLUvszZHbXbbiFXYMHtrHIdLZcWsMM9FybU
         BnZlbjfQ+Kj9vxOrrPZLYEXeULDS6Cs6eL4t5laXg284xQL0GEF4uveYT/oFuLizLkE/
         5h9JxyuPeZ3qriAxmiYpD/AL7Y9zBvgAvMaBklS2qlEo6FQuIbQRK4wCnUtgqla30gFk
         81z8tyD+tltdZ5guZWhLx3hsFcb/zqJK/MhE2YlD+sHkcgKbNLsyykBX6thW+SFWeFJH
         d+z5O3Qu5wB09fwzFjwdWm38PcAUs1/yTkIYM+7v66aZyM5eCZswEdYNCJOnHIJE+deP
         ubCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704420793; x=1705025593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+grBcrGVuvV4liSJu69kJ2ylLSuHocR0OaEGbLjwBA=;
        b=shLAM7mTytfvIVx+owuBoavH8OWnFsLPya87IHAnuTHNb/xT/S+yW4r2j25yUMFqbU
         P1KStTXlgWq5r2398M1veiyfZwJQJzj+y9I7wgDHUmvry5E+qm2UaA5DEqm+s/noe0UZ
         XuAa8xr+4YY/48EKCZy0PsWh7s4b+8WryfBoDwnb1HzkmNYju9oLAddxGAcEXVTWfpRW
         BNGQ8Bn7YPEhOh9ijb2bymlFKmLj3pAAQ5u0lgMcYfC7GArUq4AeAfzNLNXtJ2SKxryM
         u1IHjm6X0IUD26CRRuYIykc7/klKcOW0+bdQQHkaWLGzr78LC6IAtH1ivMJoeL7LTJPz
         7C6g==
X-Gm-Message-State: AOJu0YxivQkSIO7EbJeLmYfIoLCq6C06YaOunkqgG5deQ1ezs6tCOk75
	bl0nQs73TvR0cm9QYruQD5uBl6fcKvcDFyQpHQ==
X-Google-Smtp-Source: AGHT+IG/U2QC5Y+0MYUnbGp2rZg3hY/EEchDQ6omkGn7csCqtl3k7PDPSzo6S/WwQ+npbS3ZQhZGaKLX/CY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2352:b0:1d4:1370:ebca with SMTP id
 c18-20020a170903235200b001d41370ebcamr8366plh.6.1704420793102; Thu, 04 Jan
 2024 18:13:13 -0800 (PST)
Date: Thu, 4 Jan 2024 18:13:11 -0800
In-Reply-To: <daaf098a6219310b6b1c1e3dc147fbb7e48b6f54.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-4-seanjc@google.com>
 <3ad69657ba8e1b19d150db574193619cf0cb34df.camel@redhat.com>
 <ZWk8IMZamuemfwXG@google.com> <daaf098a6219310b6b1c1e3dc147fbb7e48b6f54.camel@redhat.com>
Message-ID: <ZZdlt2Dm36VF4WL6@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest CPUID
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 21, 2023, Maxim Levitsky wrote:
> On Thu, 2023-11-30 at 17:51 -0800, Sean Christopherson wrote:
> > On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> > > On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> > > > +/*
> > > > + * This isn't truly "unsafe", but all callers except kvm_cpu_after_set_cpuid()
> > > > + * should use __cpuid_entry_get_reg(), which provides compile-time validation
> > > > + * of the input.
> > > > + */
> > > > +static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
> > > > +{
> > > > +	switch (reg) {
> > > > +	case CPUID_EAX:
> > > > +		return entry->eax;
> > > > +	case CPUID_EBX:
> > > > +		return entry->ebx;
> > > > +	case CPUID_ECX:
> > > > +		return entry->ecx;
> > > > +	case CPUID_EDX:
> > > > +		return entry->edx;
> > > > +	default:
> > > > +		WARN_ON_ONCE(1);
> > > > +		return 0;
> > > > +	}
> > > > +}
> > 
> > ...
> > 
> > > >  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > > >  	struct kvm_cpuid_entry2 *best;
> > > >  	bool allow_gbpages;
> > > > +	int i;
> > > >  
> > > > -	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
> > > > +	BUILD_BUG_ON(ARRAY_SIZE(reverse_cpuid) != NR_KVM_CPU_CAPS);
> > > > +
> > > > +	/*
> > > > +	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
> > > > +	 * honor userspace's definition for features that don't require KVM or
> > > > +	 * hardware management/support (or that KVM simply doesn't care about).
> > > > +	 */
> > > > +	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
> > > > +		const struct cpuid_reg cpuid = reverse_cpuid[i];
> > > > +
> > > > +		best = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
> > > > +		if (best)
> > > > +			vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(best, cpuid.reg);
> > > 
> > > Why not just use __cpuid_entry_get_reg? 
> > > 
> > > cpuid.reg comes from read/only 'reverse_cpuid' anyway, and in fact
> > > it seems that all callers of __cpuid_entry_get_reg, take the reg value from
> > > x86_feature_cpuid() which also takes it from 'reverse_cpuid'.
> > > 
> > > So if the compiler is smart enough to not complain in these cases, I don't
> > > see why this case is different.
> > 
> > It's because the input isn't a compile-time constant, and so the BUILD_BUG() in
> > the default path will fire. 
> >  All of the compile-time assertions in reverse_cpuid.h
> > rely on the feature being a constant value, which allows the compiler to optimize
> > away the dead paths, i.e. turn __cpuid_entry_get_reg()'s switch statement into
> > simple pointer arithmetic and thus omit the BUILD_BUG() code.
> 
> In the above code, assuming that the compiler really treats the reverse_cpuid
> as const (if that assumption is not true, then all uses of __cpuid_entry_get_reg
> are also not compile time constant either),

It's not so much the compiler treating something as const as it is the compiler
generating code that resolves the relevant inputs to compile-time constants.

> then the 'reg' value depends only on 'i', and therefore for each iteration of
> the loop, the compiler does know the compile time value of the 'reg', and so
> it can easily prove that 'default' case in __cpuid_entry_get_reg can't be
> reached, and thus eliminate that BUILD_BUG().

A compiler _could_ know, but as above what truly matters is what code the compiler
actually generates.  E.g. all helpers are tagged __always_inline to prevent the
compiler from uninlining the functions (thanks, KASAN), at which point the code
of the non-inline function is no longer dealing with compile-time constants and
so the BUILD_BUG_ON() doesn't get eliminated.

For the loop, while all values are indeed constant, the compiler may choose to
generate a loop instead of unrolling everything.  A sufficiently clever compiler
could still detect that nothing in the loop can hit the "default" case, but in
practice neither clang nor gcc does that level of optimization, at least not yet.

> > > Also why not to initialize guest_caps = host_caps & userspace_cpuid?
> > > 
> > > If this was the default we won't need any guest_cpu_cap_restrict and such,
> > > instead it will just work.
> > 
> > Hrm, I definitely like the idea.  Unfortunately, unless we do an audit of all
> > ~120 uses of guest_cpuid_has(), restricting those based on kvm_cpu_caps might
> > break userspace.
> 
> 120 uses is not that bad, IMHO it is worth it - we won't need to deal with that
> in the future.
> 
> How about a compromise - you change the patches such as it will be possible
> to remove these cases one by one, and also all new cases will be fully
> automatic?

Hrm, I'm not necessarily opposed to that, but I don't think we should go partway
unless we are 100% confident that changing the default to "use guest CPUID ANDed
with KVM capabilities" is the best end state, *and* that someone will actually
have the bandwidth to do the work soon-ish so that KVM isn't in a half-baked
state for months on end.  Even then, my preference would definitely be to switch
everything in one go.

And automatically handling new features would only be feasible for entirely new
leafs.  E.g. X86_FEATURE_RDPID is buried in CPUID.0x7.0x0.ECX, so to automatically
handle new features KVM would need to set the default guest_caps for all bits
*except* RDPID, at which point we're again building a set of features that need
to opt-out.

> > To be fair, the manual lists predate the governed features.
> 
> 100% agree, however the point of governed features was to simplify this list,
> the point of this patch set is to simplify these lists and yet they still remain,
> more or less untouched, and we will still need to maintain them.
> 
> Again I do think that governed features and/or this patchset are better than
> the mess that was there before, but a part of me wants to fully get rid of
> this mess instead of just making it a bit more beautiful. 

Oh, I would love to get rid of the mess too, I _completely_ getting rid of the
mess isn't realistic.  There are guaranteed to be exceptions to the rule, whether
the rule is "use guest CPUID by default" or "use guest CPUID constrained by KVM
capabilities by default".

I.e. there will always be some amount of manual messiness, the question is which
default behavior would yield the smallest mess.  My gut agrees with you, that
defaulting to "guest & KVM" would yield the fewest exceptions.  But as above,
I think we're better off doing the switch as an all-or-nothing things (where "all"
means within a single series, not within a single patch).

