Return-Path: <kvm+bounces-6117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2DB82B8BA
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 01:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 709E11F24F88
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 00:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62EEED7;
	Fri, 12 Jan 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITV8y+JE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9683812
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 00:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28c391d255dso4091229a91.2
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 16:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705020285; x=1705625085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sN2es8KlQfgJlHIGj5HF3V4E8vkTP0blruT0KN91HgE=;
        b=ITV8y+JEIUqkHd2L5nkGpuraOPsGYiKofNUDKqTrVUKpCJWdD6+yepTBNKJ8EwDa7I
         w32qqS8VeB0X1CMgNY2GOnkEygG4c9qiv56cFdBldoJLUg66WMHO76/qlyCkF1H9u6Kf
         pKO3uuhGz/lgGouJ4OTwwJSbRUcPZMzwv6uiQOguBy++g+40Ww0jAWN+a32ocB3V6Ikf
         6Y1rUo9Lw1sUc8gadVB/Ua1Z+6FjerNRdAanFhqnCI3nyXV7WiD9AaZ2EYM/2+KMm8Xn
         bQFteOE+kRvMWY+0gvIs6qOCn0nZWHQYpFSddMY6egO2aHhoB9IyZuDGK2+rICcIcuB1
         s3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705020285; x=1705625085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sN2es8KlQfgJlHIGj5HF3V4E8vkTP0blruT0KN91HgE=;
        b=SuQvLTsoauuGl2jdrEAIhCpgnNIg17r0pgJ2pDLusFUMLbJZ27I6yVVjpnPTrrE4pX
         5cjnyacH6GjpFhGpRjmSTfurW+lP+18Scnwfj7ERERvqPM4rFX8SFP3GEZ2c9vsZ5px2
         xHLuleXJG/kbxmfnaL0Ny1+hoTEKsV6BpPdyQs2W9aM11kQ6JTsSkCxmf5qtkcTh8p8i
         ijGDQQqP+YbWhpqs9NhjsyaCM4yyNQ3zHt2YLVv3R7mhXT5kxpCYlNg/k6TRo5GaxyKK
         YsVqelaDsadllQeQxEfirFeqREuurqFW2kqhSALsIhCx86yEPBDmClfKJ+uinxIRE+gy
         cTsQ==
X-Gm-Message-State: AOJu0YwKVh7BdT6mfr8hG/8KgxdSUDLaL8cncpB4ikb0LR2lFWVp//dD
	LK9IUPLAt2Fp90VORpGiFTZeNeD3kDrsqOQ9SA==
X-Google-Smtp-Source: AGHT+IG5ommWT719Fl7J9iZ+Wiaz9wxUw0BgdIsI4EBsqWk43AnLBHzc1JTU7N4YI/8UprhBryXp0Cn89eA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5209:b0:28e:272:4e18 with SMTP id
 sg9-20020a17090b520900b0028e02724e18mr2054pjb.2.1705020284924; Thu, 11 Jan
 2024 16:44:44 -0800 (PST)
Date: Thu, 11 Jan 2024 16:44:43 -0800
In-Reply-To: <ZZdlt2Dm36VF4WL6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-4-seanjc@google.com>
 <3ad69657ba8e1b19d150db574193619cf0cb34df.camel@redhat.com>
 <ZWk8IMZamuemfwXG@google.com> <daaf098a6219310b6b1c1e3dc147fbb7e48b6f54.camel@redhat.com>
 <ZZdlt2Dm36VF4WL6@google.com>
Message-ID: <ZaCLe4UdDgLuT21S@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest CPUID
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, Sean Christopherson wrote:
> On Thu, Dec 21, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-11-30 at 17:51 -0800, Sean Christopherson wrote:
> > > On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> > > > On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
 
> > > > Also why not to initialize guest_caps = host_caps & userspace_cpuid?
> > > > 
> > > > If this was the default we won't need any guest_cpu_cap_restrict and such,
> > > > instead it will just work.
> > > 
> > > Hrm, I definitely like the idea.  Unfortunately, unless we do an audit of all
> > > ~120 uses of guest_cpuid_has(), restricting those based on kvm_cpu_caps might
> > > break userspace.
> > 
> > 120 uses is not that bad, IMHO it is worth it - we won't need to deal with that
> > in the future.
> > 
> > How about a compromise - you change the patches such as it will be possible
> > to remove these cases one by one, and also all new cases will be fully
> > automatic?
> 
> Hrm, I'm not necessarily opposed to that, but I don't think we should go partway
> unless we are 100% confident that changing the default to "use guest CPUID ANDed
> with KVM capabilities" is the best end state, *and* that someone will actually
> have the bandwidth to do the work soon-ish so that KVM isn't in a half-baked
> state for months on end.  Even then, my preference would definitely be to switch
> everything in one go.
> 
> And automatically handling new features would only be feasible for entirely new
> leafs.  E.g. X86_FEATURE_RDPID is buried in CPUID.0x7.0x0.ECX, so to automatically
> handle new features KVM would need to set the default guest_caps for all bits
> *except* RDPID, at which point we're again building a set of features that need
> to opt-out.
> 
> > > To be fair, the manual lists predate the governed features.
> > 
> > 100% agree, however the point of governed features was to simplify this list,
> > the point of this patch set is to simplify these lists and yet they still remain,
> > more or less untouched, and we will still need to maintain them.
> > 
> > Again I do think that governed features and/or this patchset are better than
> > the mess that was there before, but a part of me wants to fully get rid of
> > this mess instead of just making it a bit more beautiful. 
> 
> Oh, I would love to get rid of the mess too, I _completely_ getting rid of the
> mess isn't realistic.  There are guaranteed to be exceptions to the rule, whether
> the rule is "use guest CPUID by default" or "use guest CPUID constrained by KVM
> capabilities by default".
> 
> I.e. there will always be some amount of manual messiness, the question is which
> default behavior would yield the smallest mess.  My gut agrees with you, that
> defaulting to "guest & KVM" would yield the fewest exceptions.  But as above,
> I think we're better off doing the switch as an all-or-nothing things (where "all"
> means within a single series, not within a single patch).

Ok, the idea of having vcpu->arch.cpu_caps default to a KVM & GUEST is growing
on me.  There's a lurking bug in KVM that in some ways is due to lack of a per-vCPU,
KVM-enforced set of a features.  The bug is relatively benign (VMX passes through
CR4.FSGSBASE when it's not supported in the host), and easy to fix (incorporate
KVM-reserved CR4 bits into vcpu->arch.cr4_guest_rsvd_bits), but it really is
something that just shouldn't happen.  E.g. KVM's handling of EFER has a similar
lurking problem where __kvm_valid_efer() is unsafe to use without also consulting
efer_reserved_bits.

And after digging a bit more, I think I'm just being overly paranoid.  I'm fairly
certain the only exceptions are literally the few that I've called out (RDPID,
MOVBE, and MWAIT (which is only a problem because of a stupid quirk)).  I don't
yet have a firm plan on how to deal with the exceptions in a clean way, e.g. I'd
like to somehow have the "opt-out" code share the set of emulated features with
__do_cpuid_func_emulated().  One thought would be to add kvm_emulated_cpu_caps,
which would be *comically* wasteful, but might be worth the 90 bytes.

For v2, what if I post this more or less as-is, with a "convert to KVM & GUEST"
patch thrown in at the end as an RFC?  I want to do a lot more testing (and staring)
before committing to the conversion, and sadly I don't have anywhere near enough
cycles to do that right now.

