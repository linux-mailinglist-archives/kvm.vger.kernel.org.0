Return-Path: <kvm+bounces-443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDB87DF9D2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CB821C20E83
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7377521347;
	Thu,  2 Nov 2023 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6lCRTaq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55D51DFF5
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:20:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A5BDB
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698949227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vCkPgDNAcAuyFQJmJ3sGnTa/9jSqm1Vt4Hh4Jnv10kQ=;
	b=K6lCRTaqhgl23yovvtub0j9rSddV3elcl7Cz8SoEks2Lcvwe8/dBMdRZpdY/iJDumXABnR
	D8XD8WdHJh9SvVPzpw0acUEzYheOZ9Dq5JWpo/vmaEnnCh9GKW8TywucCEhAItmTvvBDgm
	xEVkVTe9q9P6LXxBFZgEnqWwdexKTRY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-yXFFVeLzOX2zFK-UNOS2YQ-1; Thu, 02 Nov 2023 14:20:26 -0400
X-MC-Unique: yXFFVeLzOX2zFK-UNOS2YQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40853e14f16so7870105e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698949225; x=1699554025;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vCkPgDNAcAuyFQJmJ3sGnTa/9jSqm1Vt4Hh4Jnv10kQ=;
        b=Wa1HaXa7vugJpt4VFyBzutgPkXdy5zr0/J4yVK3IRlhImK+bKldaa9tAsJHUNUrFLd
         IiYGMET1vLQmO2RDJ+JCPnTb/VRFuTLLLUPnz6JrTh+IgM5nqMDhuM52pgoNC954dj+O
         KMqk1GWgTPK0ml2yumrpRUnVphU4eyyzip2HHPQvLrrljQc/n7x3DE59KSpFAZdQ2ul9
         s/hyAoBh1/OO9kIL5HMMMoLrWjWVbJgq1oMP7CHpfgS0gEsGJam/3yuI/4u7pffAYuam
         P8XEiVfu7tIsc3wZCWhX/5JtFkeZ6/yMkejOwTFiAOTPlVLLI1ieM+1HuDY8fq+bK3Ou
         ahzQ==
X-Gm-Message-State: AOJu0YwA3dj+x9tGIMH3tFZghlPYNZw3Qm+kBw6VgQdPBItX/jO7r/fJ
	IEr8wXHG9kHZAuczawMqkoU3ob4VSc/800OEBkviCA/irSXeda/RLjL9x3DmktuiDUJdPt+qGsF
	KxJb8MGk8aMeA
X-Received: by 2002:a05:6000:186c:b0:32f:7a65:da64 with SMTP id d12-20020a056000186c00b0032f7a65da64mr15466711wri.65.1698949225186;
        Thu, 02 Nov 2023 11:20:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGafUiev8YWXZ4EBUnlmWxuao5K8uPhqfCwENZFJcn2nZb8vNibvin3jbofi3dWYt1Xb5hk8g==
X-Received: by 2002:a05:6000:186c:b0:32f:7a65:da64 with SMTP id d12-20020a056000186c00b0032f7a65da64mr15466688wri.65.1698949224859;
        Thu, 02 Nov 2023 11:20:24 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id z2-20020adff742000000b00326dd5486dcsm3081566wrp.107.2023.11.02.11.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:20:07 -0700 (PDT)
Message-ID: <f4e2d8c79ca3f238aafd61a82a3f5ad5c2d6bcab.camel@redhat.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits
 when calculate guest xstate size
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Dave Hansen
 <dave.hansen@intel.com>,  pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,  peterz@infradead.org, chao.gao@intel.com,
 rick.p.edgecombe@intel.com,  john.allen@amd.com
Date: Thu, 02 Nov 2023 20:20:05 +0200
In-Reply-To: <ZUJdohf6wLE5LrCN@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-7-weijiang.yang@intel.com>
	 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
	 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
	 <ZTf5wPKXuHBQk0AN@google.com>
	 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
	 <ZTqgzZl-reO1m01I@google.com>
	 <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
	 <ZUJdohf6wLE5LrCN@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 07:16 -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
> > > On Wed, Oct 25, 2023, Weijiang Yang wrote:
> > On top of that I think that applying the same permission approach to guest's
> > FPU state is not a good fit, because of two reasons:
> > 
> > 1. The guest FPU state will never be pushed on the signal stack - KVM swaps
> >    back the host FPU state before it returns from the KVM_RUN ioctl.
> > 
> >    Also I think (not sure) that ptrace can only access (FPU) state of a
> >    stopped process, and a stopped vCPU process will also first return to
> >    userspace. Again I might be mistaken here, I never researched this in
> >    depth.
> > 
> >    Assuming that I am correct on these assumptions, the guest FPU state can
> >    only be accessed via KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2 ioctls,
> >    which also returns the userspace portion of the state including optionally
> >    the AMX state, but this ioctl doesn't really need FPU permission
> >    framework, because it is a KVM ABI, and in fact KVM_GET_XSAVE2 was added
> >    exactly because of that: to make sure that userspace is aware that larger
> >    than 4K buffer can be returned.
> > 
> > 2. Guest FPU state is not even on demand resized (but I can imagine that in
> >    the future we will do this).
> 
> Just because guest FPU state isn't resized doesn't mean there's no value in
> requiring userspace to opt-in to allocating 8KiB of data per-vCPU.
See my response below:
> 
> > And of course, adding permissions for kernel features, that is even worse
> > idea, which we really shouldn't do.
> > 
> > >  
> > > If there are no objections, I'll test the below and write a proper changelog.
> > >  
> > > --
> > > From: Sean Christopherson <seanjc@google.com>
> > > Date: Thu, 26 Oct 2023 10:17:33 -0700
> > > Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
> > >  __state_perm
> > > 
> > > Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
> > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > index ef6906107c54..73f6bc00d178 100644
> > > --- a/arch/x86/kernel/fpu/xstate.c
> > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
> > >  	if ((permitted & requested) == requested)
> > >  		return 0;
> > >  
> > > -	/* Calculate the resulting kernel state size */
> > > +	/*
> > > +	 * Calculate the resulting kernel state size.  Note, @permitted also
> > > +	 * contains supervisor xfeatures even though supervisor are always
> > > +	 * permitted for kernel and guest FPUs, and never permitted for user
> > > +	 * FPUs.
> > > +	 */
> > >  	mask = permitted | requested;
> > > -	/* Take supervisor states into account on the host */
> > > -	if (!guest)
> > > -		mask |= xfeatures_mask_supervisor();
> > >  	ksize = xstate_calculate_size(mask, compacted);
> > 
> > This might not work with kernel dynamic features, because
> > xfeatures_mask_supervisor() will return all supported supervisor features.
> 
> I don't understand what you mean by "This".

> 
> Somewhat of a side topic, I feel very strongly that we should use "guest only"
> terminology instead of "dynamic".  There is nothing dynamic about whether or not
> XFEATURE_CET_KERNEL is allowed; there's not even a real "decision" beyond checking
> wheter or not CET is supported.

> > Therefore at least until we have an actual kernel dynamic feature (a feature
> > used by the host kernel and not KVM, and which has to be dynamic like AMX),
> > I suggest that KVM stops using the permission API completely for the guest
> > FPU state, and just gives all the features it wants to enable right to
> 
> By "it", I assume you mean userspace?
> 
> > __fpu_alloc_init_guest_fpstate() (Guest FPU permission API IMHO should be
> > deprecated and ignored)
> 
> KVM allocates guest FPU state during KVM_CREATE_VCPU, so not using prctl() would
> either require KVM to defer allocating guest FPU state until KVM_SET_CPUID{,2},
> or would require a VM-scoped KVM ioctl() to let userspace opt-in to
> 
> Allocating guest FPU state during KVM_SET_CPUID{,2} would get messy, 

> as KVM allows
> multiple calls to KVM_SET_CPUID{,2} so long as the vCPU hasn't done KVM_RUN.  E.g.
> KVM would need to support actually resizing guest FPU state, which would be extra
> complexity without any meaningful benefit.


OK, I understand you now. What you claim is that it is legal to do this:

- KVM_SET_XSAVE
- KVM_SET_CPUID (with AMX enabled)

KVM_SET_CPUID will have to resize the xstate which is already valid.

Your patch to fix the __xstate_request_perm() does seem to be correct in a sense that it will
preserve the kernel fpu components in the fpu permissions.

However note that kernel fpu permissions come from 'fpu_kernel_cfg.default_features' 
which don't include the dynamic kernel xfeatures (added a few patches before this one).

Therefore an attempt to resize the xstate to include a kernel dynamic feature by
__xfd_enable_feature will fail.

If kvm on the other hand includes all the kernel dynamic features in the initial
allocation of FPU state (not optimal but possible), then later call to __xstate_request_perm
for a userspace dynamic feature (which can still happen) will mess the the xstate,
because again the permission code assumes that only default kernel features were granted the permissions.


This has to be solved this way or another.

> 
> The only benefit I can think of for a VM-scoped ioctl() is that it would allow a
> single process to host multiple VMs with different dynamic xfeature requirements.
> But such a setup is mostly theoretical.  Maybe it'll affect the SEV migration
> helper at some point?  But even that isn't guaranteed.
> 
> So while I agree that ARCH_GET_XCOMP_GUEST_PERM isn't ideal, practically speaking
> it's sufficient for all current use cases.  Unless a concrete use case comes along,
> deprecating ARCH_GET_XCOMP_GUEST_PERM in favor of a KVM ioctl() would be churn for
> both the kernel and userspace without any meaningful benefit, or really even any
> true change in behavior.


ARCH_GET_XCOMP_GUEST_PERM/ARCH_SET_XCOMP_GUEST_PERM is not a good API from usability POV, because it is redundant.

KVM already has API called KVM_SET_CPUID2, by which the qemu/userspace instructs the KVM, how much space to allocate,
to support a VM with *this* CPUID.


For example if qemu asks for nested SVM/VMX, then kvm will allocate on demand state for it (also at least 8K/vCPU btw).
The same should apply for AMX - Qemu sets AMX xsave bit in CPUID - that permits KVM to allocate the extra state when needed.

I don't see why we need an extra and non KVM API for that.


Best regards,
	Maxim Levitsky



> 



