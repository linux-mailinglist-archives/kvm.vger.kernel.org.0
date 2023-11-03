Return-Path: <kvm+bounces-504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 899197E04BD
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29E0BB21485
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128C81B278;
	Fri,  3 Nov 2023 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CeP2gnI/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235711A5A1
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:33:05 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECD8D50
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:33:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0631f977bso2515213276.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 07:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699021983; x=1699626783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpJSZ5mbXewL2nGOafYwkZFzofRxVugIM54vK7gCLUs=;
        b=CeP2gnI/hRgpGVxhF25z0WF/GM/jv+jBjYDx2ocN6KA0v5NFf3jN0YXWpauNY4pyBH
         +w7w6m5a+Ws9CGiM2gIaOWjsbq0NB4QZRXJySm3AibIonTGZb0NsKCaU7KYQAZZaMVoH
         /LtmJCsRrmg1cudxXkT7x2Qz7SkhiKNyPxpwphCsQxNs6szPhMYEvpQWbmz28zvFLPx3
         rzEqu2KokGt0C/g0C1Zf7hmZ16YgFtvGGmQQeawj4np00h2Zwa0zAE4zAJwfuRfwiXGY
         JQKsA4Hc4H/RLyB6c9WLE3QTxr2SCyBL/MWgTtIH4QQYX2lC0dg01KwrNVIL1XuJr8M+
         UYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699021983; x=1699626783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpJSZ5mbXewL2nGOafYwkZFzofRxVugIM54vK7gCLUs=;
        b=Rh56m9QOFvTbRuJzg0zk3mO7gvnxK3RmAWh0JdmOkqS5qv6XCyIX/tp+fpNYWXU1jN
         cz95mD7RiDY7LA7NPfzBDQk1Mf37dtlkk5OxIDDnu+WlaXfSghAbGSFddHXVN6lefN3n
         lby6j4eGELDEOD94ftINLnKqw+9z9m7rKN+irubeNmrMxx1VS5VLgBTSp4ZAEuzA+Sh8
         qT4LxE3EFEA+UkbhWdbVXIwfGCPItxqX/oXQ1QaCigHvwS6xFkfRKfYgFverH/ASOxZw
         azXkhfiC4IceNNZjUwuZ9u042SEowyR8TGo7QOAaRxY1XufIKgix0/8pkOK6cMecAzQM
         441w==
X-Gm-Message-State: AOJu0YwRpbyUpUEhon1BwRZfObV6DzUlEBfFIHLi8fdj4pGrphBW95cn
	4S9QQWnu9lm7v9TcAo//dODm76vXjPo=
X-Google-Smtp-Source: AGHT+IEZTmjXBmRW1uEZrAtI3/gkqMzQWqxt/qWCdH2d8f4UJ0Ia5LRCJdg8JZKIDOc/x8NM3c6iHqtNRaU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7653:0:b0:d9a:38e4:78b5 with SMTP id
 r80-20020a257653000000b00d9a38e478b5mr436112ybc.5.1699021983042; Fri, 03 Nov
 2023 07:33:03 -0700 (PDT)
Date: Fri, 3 Nov 2023 07:33:01 -0700
In-Reply-To: <f4e2d8c79ca3f238aafd61a82a3f5ad5c2d6bcab.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com> <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com> <ZTf5wPKXuHBQk0AN@google.com>
 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com> <ZTqgzZl-reO1m01I@google.com>
 <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
 <ZUJdohf6wLE5LrCN@google.com> <f4e2d8c79ca3f238aafd61a82a3f5ad5c2d6bcab.camel@redhat.com>
Message-ID: <ZUUEnXcqgY7O0jp7@google.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> On Wed, 2023-11-01 at 07:16 -0700, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
> > > > --
> > > > From: Sean Christopherson <seanjc@google.com>
> > > > Date: Thu, 26 Oct 2023 10:17:33 -0700
> > > > Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
> > > >  __state_perm
> > > > 
> > > > Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
> > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > > index ef6906107c54..73f6bc00d178 100644
> > > > --- a/arch/x86/kernel/fpu/xstate.c
> > > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > > @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
> > > >  	if ((permitted & requested) == requested)
> > > >  		return 0;
> > > >  
> > > > -	/* Calculate the resulting kernel state size */
> > > > +	/*
> > > > +	 * Calculate the resulting kernel state size.  Note, @permitted also
> > > > +	 * contains supervisor xfeatures even though supervisor are always
> > > > +	 * permitted for kernel and guest FPUs, and never permitted for user
> > > > +	 * FPUs.
> > > > +	 */
> > > >  	mask = permitted | requested;
> > > > -	/* Take supervisor states into account on the host */
> > > > -	if (!guest)
> > > > -		mask |= xfeatures_mask_supervisor();
> > > >  	ksize = xstate_calculate_size(mask, compacted);
> > > 
> > > This might not work with kernel dynamic features, because
> > > xfeatures_mask_supervisor() will return all supported supervisor features.
> > 
> > I don't understand what you mean by "This".
> 
> > 
> > Somewhat of a side topic, I feel very strongly that we should use "guest only"
> > terminology instead of "dynamic".  There is nothing dynamic about whether or not
> > XFEATURE_CET_KERNEL is allowed; there's not even a real "decision" beyond checking
> > wheter or not CET is supported.
> 
> > > Therefore at least until we have an actual kernel dynamic feature (a feature
> > > used by the host kernel and not KVM, and which has to be dynamic like AMX),
> > > I suggest that KVM stops using the permission API completely for the guest
> > > FPU state, and just gives all the features it wants to enable right to
> > 
> > By "it", I assume you mean userspace?
> > 
> > > __fpu_alloc_init_guest_fpstate() (Guest FPU permission API IMHO should be
> > > deprecated and ignored)
> > 
> > KVM allocates guest FPU state during KVM_CREATE_VCPU, so not using prctl() would
> > either require KVM to defer allocating guest FPU state until KVM_SET_CPUID{,2},
> > or would require a VM-scoped KVM ioctl() to let userspace opt-in to
> > 
> > Allocating guest FPU state during KVM_SET_CPUID{,2} would get messy, 
> 
> > as KVM allows
> > multiple calls to KVM_SET_CPUID{,2} so long as the vCPU hasn't done KVM_RUN.  E.g.
> > KVM would need to support actually resizing guest FPU state, which would be extra
> > complexity without any meaningful benefit.
> 
> 
> OK, I understand you now. What you claim is that it is legal to do this:
> 
> - KVM_SET_XSAVE
> - KVM_SET_CPUID (with AMX enabled)
> 
> KVM_SET_CPUID will have to resize the xstate which is already valid.

I was actually talking about

  KVM_SET_CPUID2 (with dynamic user feature #1)
  KVM_SET_CPUID2 (with dynamic user feature #2)

The second call through __xstate_request_perm() will be done with only user
xfeatures in @permitted and so the kernel will compute the wrong ksize.

> Your patch to fix the __xstate_request_perm() does seem to be correct in a
> sense that it will preserve the kernel fpu components in the fpu permissions.
> 
> However note that kernel fpu permissions come from
> 'fpu_kernel_cfg.default_features' which don't include the dynamic kernel
> xfeatures (added a few patches before this one).

CET_KERNEL isn't dynamic!  It's guest-only.  There are no runtime decisions as to
whether or not CET_KERNEL is allowed.  All guest FPU get CET_KERNEL, no kernel FPUs
get CET_KERNEL.

That matters because I am also proposing that we add a dedicated, defined-at-boot
fpu_guest_cfg instead of bolting on a "dynamic", which is what I meant by this:

 : Or even better if it doesn't cause weirdness elsewhere, a dedicated
 : fpu_guest_cfg.  For me at least, a fpu_guest_cfg would make it easier to
 : understand what all is going on.

That way, initialization of permissions is simply

	fpu->guest_perm = fpu_guest_cfg.default_features;

and there's no need to differentiate between guest and kernel FPUs when reallocating
for dynamic user xfeatures because guest_perm.__state_perm already holds the correct
data.

> Therefore an attempt to resize the xstate to include a kernel dynamic feature by
> __xfd_enable_feature will fail.
> 
> If kvm on the other hand includes all the kernel dynamic features in the
> initial allocation of FPU state (not optimal but possible),

This is what I am suggesting.

 : There are definitely scenarios where CET will not be exposed to KVM guests, but
 : I don't see any reason to make the guest FPU space dynamically sized for CET.
 : It's what, 40 bytes?

> then later call to __xstate_request_perm for a userspace dynamic feature
> (which can still happen) will mess the the xstate, because again the
> permission code assumes that only default kernel features were granted the
> permissions.
> 
> 
> This has to be solved this way or another.
> 
> > 
> > The only benefit I can think of for a VM-scoped ioctl() is that it would allow a
> > single process to host multiple VMs with different dynamic xfeature requirements.
> > But such a setup is mostly theoretical.  Maybe it'll affect the SEV migration
> > helper at some point?  But even that isn't guaranteed.
> > 
> > So while I agree that ARCH_GET_XCOMP_GUEST_PERM isn't ideal, practically speaking
> > it's sufficient for all current use cases.  Unless a concrete use case comes along,
> > deprecating ARCH_GET_XCOMP_GUEST_PERM in favor of a KVM ioctl() would be churn for
> > both the kernel and userspace without any meaningful benefit, or really even any
> > true change in behavior.
> 
> 
> ARCH_GET_XCOMP_GUEST_PERM/ARCH_SET_XCOMP_GUEST_PERM is not a good API from
> usability POV, because it is redundant.
> 
> KVM already has API called KVM_SET_CPUID2, by which the qemu/userspace
> instructs the KVM, how much space to allocate, to support a VM with *this*
> CPUID.
> 
> For example if qemu asks for nested SVM/VMX, then kvm will allocate on demand
> state for it (also at least 8K/vCPU btw).  The same should apply for AMX -
> Qemu sets AMX xsave bit in CPUID - that permits KVM to allocate the extra
> state when needed.
> 
> I don't see why we need an extra and non KVM API for that.

I don't necessarily disagree, but what's done is done.  We missed our chance to
propose a different mechanism, and at this point undoing all of that without good
cause is unlikely to benefit anyone.  If a use comes along that needs something
"better" than the prctl() API, then I agree it'd be worth revisiting.

