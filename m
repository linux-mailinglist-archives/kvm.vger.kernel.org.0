Return-Path: <kvm+bounces-1038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3BD7E47C9
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70EEDB20CCB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5623589C;
	Tue,  7 Nov 2023 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idiss7u7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422F32E401
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:04:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B6DB0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699380298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SnfWst7YWy/G8qn8/lbczAXS0PlzIdVfaEM1EG2S9A=;
	b=idiss7u7OBlUMrlxnu8OGF1llsrzcZCvdUxVJYWAqual2huAcpwDwc0jqiqYLWkRTYBITm
	HEW+1Z4VsN0jz9slH9zccmQymKYthZ7SDjpY/zEwBavghlHpPdXtgrwT+D21cExh7UoS1N
	Z1jJaUv3eUGHGcvUPoZwO0Z5d/fE3pU=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-xDuiBWr1OQ-dFfAaQuNIKQ-1; Tue, 07 Nov 2023 13:04:57 -0500
X-MC-Unique: xDuiBWr1OQ-dFfAaQuNIKQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-507d4583c4cso6508354e87.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699380295; x=1699985095;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5SnfWst7YWy/G8qn8/lbczAXS0PlzIdVfaEM1EG2S9A=;
        b=XP5ff+xH/2AHkmGCDK7Tj6/ajXi5FPrYDQHK/fXiOZVR5CsWnRR3fTJwWOJyLzB9Fm
         vyvTDyoEQ25BvRm9RHVOBQKc+xs98lz+/XNYh9qMTv58FUxaF0pzGtp4Yj56lvUHsZEE
         s9kwmBUEgEtkBB255XLWmqtipuW6bDyXRlIe661tuvXbAANUJ0g6yyaeuq59PgsyR5p+
         f0rU8kjDgxoBJS5ip1fPNESEKwaVZAk//pqH0NIhBNmFAZqRpCMtSuFwCZhAxdVXYkfn
         MHWR5x9u8ATjvz4Z2iZFIVXUDOxZUUZkctMmzWGeA1Z1nk4NiHLE2pTZatKExfTCmX2p
         A91g==
X-Gm-Message-State: AOJu0YzMw6jMG9G6c/mKJWV7ZM0F2mmaYk+op/xoUzm86TfndG1go3eb
	qlACOswO8vzcjjGgqg+LrBuURz9JFpnKKoekissyULcCbqlimL46THj1ozLXp4US6cwNUR44OMD
	QxJfG5Ra74M30
X-Received: by 2002:ac2:4c94:0:b0:507:96cd:e641 with SMTP id d20-20020ac24c94000000b0050796cde641mr21537268lfl.51.1699380295582;
        Tue, 07 Nov 2023 10:04:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEP/jjMpM0e94iMbsSJJ3TYIhtbA/6z1Q2YJPC6dgbMVm/NhXwMv1W9zc9A8qb9G1+rsqzP+w==
X-Received: by 2002:ac2:4c94:0:b0:507:96cd:e641 with SMTP id d20-20020ac24c94000000b0050796cde641mr21537245lfl.51.1699380295203;
        Tue, 07 Nov 2023 10:04:55 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c1d2900b004083a105f27sm16726022wms.26.2023.11.07.10.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:04:54 -0800 (PST)
Message-ID: <a7c23f74187b5042814341ce5d2e749408d24650.camel@redhat.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits
 when calculate guest xstate size
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Dave Hansen
 <dave.hansen@intel.com>,  pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  peterz@infradead.org, chao.gao@intel.com,
 rick.p.edgecombe@intel.com,  john.allen@amd.com
Date: Tue, 07 Nov 2023 20:04:52 +0200
In-Reply-To: <ZUUEnXcqgY7O0jp7@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-7-weijiang.yang@intel.com>
	 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
	 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
	 <ZTf5wPKXuHBQk0AN@google.com>
	 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
	 <ZTqgzZl-reO1m01I@google.com>
	 <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
	 <ZUJdohf6wLE5LrCN@google.com>
	 <f4e2d8c79ca3f238aafd61a82a3f5ad5c2d6bcab.camel@redhat.com>
	 <ZUUEnXcqgY7O0jp7@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-03 at 07:33 -0700, Sean Christopherson wrote:
> On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > On Wed, 2023-11-01 at 07:16 -0700, Sean Christopherson wrote:
> > > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > > On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
> > > > > --
> > > > > From: Sean Christopherson <seanjc@google.com>
> > > > > Date: Thu, 26 Oct 2023 10:17:33 -0700
> > > > > Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
> > > > >  __state_perm
> > > > > 
> > > > > Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> > > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > > ---
> > > > >  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
> > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > > > index ef6906107c54..73f6bc00d178 100644
> > > > > --- a/arch/x86/kernel/fpu/xstate.c
> > > > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > > > @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
> > > > >  	if ((permitted & requested) == requested)
> > > > >  		return 0;
> > > > >  
> > > > > -	/* Calculate the resulting kernel state size */
> > > > > +	/*
> > > > > +	 * Calculate the resulting kernel state size.  Note, @permitted also
> > > > > +	 * contains supervisor xfeatures even though supervisor are always
> > > > > +	 * permitted for kernel and guest FPUs, and never permitted for user
> > > > > +	 * FPUs.
> > > > > +	 */
> > > > >  	mask = permitted | requested;
> > > > > -	/* Take supervisor states into account on the host */
> > > > > -	if (!guest)
> > > > > -		mask |= xfeatures_mask_supervisor();
> > > > >  	ksize = xstate_calculate_size(mask, compacted);
> > > > 
> > > > This might not work with kernel dynamic features, because
> > > > xfeatures_mask_supervisor() will return all supported supervisor features.
> > > 
> > > I don't understand what you mean by "This".
> > > Somewhat of a side topic, I feel very strongly that we should use "guest only"
> > > terminology instead of "dynamic".  There is nothing dynamic about whether or not
> > > XFEATURE_CET_KERNEL is allowed; there's not even a real "decision" beyond checking
> > > wheter or not CET is supported.
> > > > Therefore at least until we have an actual kernel dynamic feature (a feature
> > > > used by the host kernel and not KVM, and which has to be dynamic like AMX),
> > > > I suggest that KVM stops using the permission API completely for the guest
> > > > FPU state, and just gives all the features it wants to enable right to
> > > 
> > > By "it", I assume you mean userspace?
> > > 
> > > > __fpu_alloc_init_guest_fpstate() (Guest FPU permission API IMHO should be
> > > > deprecated and ignored)
> > > 
> > > KVM allocates guest FPU state during KVM_CREATE_VCPU, so not using prctl() would
> > > either require KVM to defer allocating guest FPU state until KVM_SET_CPUID{,2},
> > > or would require a VM-scoped KVM ioctl() to let userspace opt-in to
> > > 
> > > Allocating guest FPU state during KVM_SET_CPUID{,2} would get messy, 
> > > as KVM allows
> > > multiple calls to KVM_SET_CPUID{,2} so long as the vCPU hasn't done KVM_RUN.  E.g.
> > > KVM would need to support actually resizing guest FPU state, which would be extra
> > > complexity without any meaningful benefit.
> > 
> > OK, I understand you now. What you claim is that it is legal to do this:
> > 
> > - KVM_SET_XSAVE
> > - KVM_SET_CPUID (with AMX enabled)
> > 
> > KVM_SET_CPUID will have to resize the xstate which is already valid.
> 
> I was actually talking about
> 
>   KVM_SET_CPUID2 (with dynamic user feature #1)
>   KVM_SET_CPUID2 (with dynamic user feature #2)
> 
> The second call through __xstate_request_perm() will be done with only user
> xfeatures in @permitted and so the kernel will compute the wrong ksize.
> 
> > Your patch to fix the __xstate_request_perm() does seem to be correct in a
> > sense that it will preserve the kernel fpu components in the fpu permissions.
> > 
> > However note that kernel fpu permissions come from
> > 'fpu_kernel_cfg.default_features' which don't include the dynamic kernel
> > xfeatures (added a few patches before this one).
> 
> CET_KERNEL isn't dynamic!  It's guest-only.  There are no runtime decisions as to
> whether or not CET_KERNEL is allowed.  All guest FPU get CET_KERNEL, no kernel FPUs
> get CET_KERNEL.
> 
> That matters because I am also proposing that we add a dedicated, defined-at-boot
> fpu_guest_cfg instead of bolting on a "dynamic", which is what I meant by this:

Seems fair.

> 
>  : Or even better if it doesn't cause weirdness elsewhere, a dedicated
>  : fpu_guest_cfg.  For me at least, a fpu_guest_cfg would make it easier to
>  : understand what all is going on.
This is a very good idea.

> 
> That way, initialization of permissions is simply
> 
> 	fpu->guest_perm = fpu_guest_cfg.default_features;
> 
> and there's no need to differentiate between guest and kernel FPUs when reallocating
> for dynamic user xfeatures because guest_perm.__state_perm already holds the correct
> data.
> 
> > Therefore an attempt to resize the xstate to include a kernel dynamic feature by
> > __xfd_enable_feature will fail.
> > 
> > If kvm on the other hand includes all the kernel dynamic features in the
> > initial allocation of FPU state (not optimal but possible),
> 
> This is what I am suggesting.

This is a valid solution.

> 
>  : There are definitely scenarios where CET will not be exposed to KVM guests, but
>  : I don't see any reason to make the guest FPU space dynamically sized for CET.
>  : It's what, 40 bytes?

I don't disagree with this. Allocating all guest kernel features is a valid solution
for now although this can change in the future if a 'heavy' kernel feature comes.

Also IMHO its not a question of space but more question of run-time overhead.
I don't know how well the INIT/MODIFIED ucode state tracking works (on Intel and AMD)
and what are the costs of saving/restoring an unused feature.

But again this is a valid solution and as long as the code works, I don't have
anything against it.

> 
> > then later call to __xstate_request_perm for a userspace dynamic feature
> > (which can still happen) will mess the the xstate, because again the
> > permission code assumes that only default kernel features were granted the
> > permissions.
> > 
> > 
> > This has to be solved this way or another.
> > 
> > > The only benefit I can think of for a VM-scoped ioctl() is that it would allow a
> > > single process to host multiple VMs with different dynamic xfeature requirements.
> > > But such a setup is mostly theoretical.  Maybe it'll affect the SEV migration
> > > helper at some point?  But even that isn't guaranteed.
> > > 
> > > So while I agree that ARCH_GET_XCOMP_GUEST_PERM isn't ideal, practically speaking
> > > it's sufficient for all current use cases.  Unless a concrete use case comes along,
> > > deprecating ARCH_GET_XCOMP_GUEST_PERM in favor of a KVM ioctl() would be churn for
> > > both the kernel and userspace without any meaningful benefit, or really even any
> > > true change in behavior.
> > 
> > ARCH_GET_XCOMP_GUEST_PERM/ARCH_SET_XCOMP_GUEST_PERM is not a good API from
> > usability POV, because it is redundant.
> > 
> > KVM already has API called KVM_SET_CPUID2, by which the qemu/userspace
> > instructs the KVM, how much space to allocate, to support a VM with *this*
> > CPUID.
> > 
> > For example if qemu asks for nested SVM/VMX, then kvm will allocate on demand
> > state for it (also at least 8K/vCPU btw).  The same should apply for AMX -
> > Qemu sets AMX xsave bit in CPUID - that permits KVM to allocate the extra
> > state when needed.
> > 
> > I don't see why we need an extra and non KVM API for that.
> 
> I don't necessarily disagree, but what's done is done.  We missed our chance to
> propose a different mechanism, and at this point undoing all of that without good
> cause is unlikely to benefit anyone.  If a use comes along that needs something
> "better" than the prctl() API, then I agree it'd be worth revisiting.

I do think that it is not too late to deprecate the ARCH_GET_XCOMP_GUEST_PERM/ARCH_SET_XCOMP_GUEST_PERM,
and just ignore it, instead taking the guest CPUID as the source of truth.

That API was out only for a few releases and only has to be used for AMX which is a very new feature.

Also if we let the guest call the deprecated API but ignore it (allow everything regardless if the userspace
called the permission API) that will not break the existing code IMHO.

Best regards,
	Maxim Levitsky


> 



