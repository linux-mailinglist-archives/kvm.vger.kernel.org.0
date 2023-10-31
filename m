Return-Path: <kvm+bounces-219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 692A97DD4E8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CECB1C20C89
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144462230D;
	Tue, 31 Oct 2023 17:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="arSB6IjB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4CA22301
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:45:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA22191
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rWf+4dRln/ZnS7DUNhqOn//sFXTpR/FU0p4fjjC28pk=;
	b=arSB6IjB2/KAwxn1nSRUkFyCOAmhuVJvoYL6lUC7e/3HNiD+x47JD5pmgeDGX3EjhNSD2p
	0UcQqfcdUBTgiKpTvJfbCSZTwMnt1cOUEX28c4OoYXqT5XuLPPFEPe0GoNoIq57OqS5fdh
	2NgKnWtwwVf6fLmZOMSZG1ljcZlUhds=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-0tSdPojVMG-6Pwee5W9rSA-1; Tue, 31 Oct 2023 13:45:15 -0400
X-MC-Unique: 0tSdPojVMG-6Pwee5W9rSA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40837aa4a58so522035e9.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774314; x=1699379114;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rWf+4dRln/ZnS7DUNhqOn//sFXTpR/FU0p4fjjC28pk=;
        b=Jg3eMkwGfKcNyg2z0x2NUofDnX0d20p37427Go5w6pS9faIG1J8I/RGLGjOpL4cywm
         4l2Q/W8QRbVrZSbDpW5avyK9BI1tuPEy/5MKUgHHBLvCMKPxtZELR6TzP6XIqNkEbB+y
         9JPYIEUe600FucPzbFn7sXcaC4xl5G/xo6AYC82mlRks3soIwBB6+xNJv/avCo0f9gr/
         5cZe9lUhLcFi4JozAuA+iw1Auc1IKyslukk6KGFnEeEpm6J/JOInynsBV+9p1ITxj4lf
         +yKcqI1WGN8lTLgC3CBEsdLwBU/MS7qcrDdM+8XlSr/Pnt+vxtHSjLNmD8Ig05YPVjNw
         dIcw==
X-Gm-Message-State: AOJu0YzmwEHEmo46LGSkvrX+lU2DTv9063DWJcecI9nhwsKoaDb5sOvw
	1G2hedxEt1hYc9XFt3JOKhLJzIoDagbD0b3L0YhbCEevSDJ+dkgiRJDvrzJn3D4Ka/ULFf/P1gs
	DVI+Bj1Pz02at
X-Received: by 2002:a05:600c:444d:b0:407:3e94:bcca with SMTP id v13-20020a05600c444d00b004073e94bccamr3745612wmn.1.1698774314260;
        Tue, 31 Oct 2023 10:45:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbZBYqKwT+ougX5g/TztWctujgcRUcbudRaLRTD/WxfIqJFPl/aXqTBrFrrEIyuIt7ZpPcWQ==
X-Received: by 2002:a05:600c:444d:b0:407:3e94:bcca with SMTP id v13-20020a05600c444d00b004073e94bccamr3745577wmn.1.1698774313833;
        Tue, 31 Oct 2023 10:45:13 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c468f00b003fe1c332810sm2362973wmo.33.2023.10.31.10.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:45:13 -0700 (PDT)
Message-ID: <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits
 when calculate guest xstate size
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Weijiang Yang
	 <weijiang.yang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:45:11 +0200
In-Reply-To: <ZTqgzZl-reO1m01I@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-7-weijiang.yang@intel.com>
	 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
	 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
	 <ZTf5wPKXuHBQk0AN@google.com>
	 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
	 <ZTqgzZl-reO1m01I@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
> On Wed, Oct 25, 2023, Weijiang Yang wrote:
> > On 10/25/2023 1:07 AM, Sean Christopherson wrote:
> > > On Fri, Sep 15, 2023, Weijiang Yang wrote:
> > > IIUC, the "dynamic" features contains CET_KERNEL, whereas xfeatures_mask_supervisor()
> > > conatins PASID, CET_USER, and CET_KERNEL.  PASID isn't virtualized by KVM, but
> > > doesn't that mean CET_USER will get dropped/lost if userspace requests AMX/XTILE
> > > enabling?
> > 
> > Yes, __state_size is correct for guest enabled xfeatures, including CET_USER,
> > and it gets removed from __state_perm.
> > 
> > IIUC, from current qemu/kernel interaction for guest permission settings,
> > __xstate_request_perm() is called only _ONCE_ to set AMX/XTILE for every vCPU
> > thread, so the removal of guest supervisor xfeatures won't hurt guest! ;-/
> 
> Huh?  I don't follow.  What does calling __xstate_request_perm() only once have
> to do with anything?
> 
> /me stares more
> 
> OMG, hell no.  First off, this code is a nightmare to follow.  The existing comment
> is useless.  No shit the code is adding in supervisor states for the host.  What's
> not AT ALL clear is *why*.
> 
> The commit says it's necessary because the "permission bitmap is only relevant
> for user states":
> 
>   commit 781c64bfcb735960717d1cb45428047ff6a5030c
>   Author: Thomas Gleixner <tglx@linutronix.de>
>   Date:   Thu Mar 24 14:47:14 2022 +0100
> 
>     x86/fpu/xstate: Handle supervisor states in XSTATE permissions
>     
>     The size calculation in __xstate_request_perm() fails to take supervisor
>     states into account because the permission bitmap is only relevant for user
>     states.
> 
> But @permitted comes from:
> 
>   permitted = xstate_get_group_perm(guest);
> 
> which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm.  And
> __state_perm is initialized to:
> 
> 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;

Not anymore after patch 5, and patch 5 does make sense in the regard to the fact
that we might not want to save/restore kernel CET state for nothing for regular kernel threads.

> 
> where fpu_kernel_cfg.default_features contains everything except the dynamic
> xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
> 
> 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
> 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> 
> So why on earth does this code to force back xfeatures_mask_supervisor()?  Because
> the code just below drops the supervisor bits to compute the user xstate size and
> then clobbers __state_perm.
> 
> 	/* Calculate the resulting user state size */
> 	mask &= XFEATURE_MASK_USER_SUPPORTED;
> 	usize = xstate_calculate_size(mask, false);
> 
> 	...
> 
> 	WRITE_ONCE(perm->__state_perm, mask);
> 
> That is beyond asinine.  IIUC, the intent is to apply the permission bitmap only
> for user states, because the only dynamic states are user states.  Bbut the above
> creates an inconsistent mess.  If userspace doesn't request XTILE_DATA,
> __state_perm will contain supervisor states, but once userspace does request
> XTILE_DATA, __state_perm will be lost.
> 
> And because that's not confusing enough, clobbering __state_perm would also drop
> FPU_GUEST_PERM_LOCKED, except that __xstate_request_perm() can' be reached with
> said LOCKED flag set.
> 
> fpu_xstate_prctl() already strips out supervisor features:
> 
> 	case ARCH_GET_XCOMP_PERM:
> 		/*
> 		 * Lockless snapshot as it can also change right after the
> 		 * dropping the lock.
> 		 */
> 		permitted = xstate_get_host_group_perm();
> 		permitted &= XFEATURE_MASK_USER_SUPPORTED;
> 		return put_user(permitted, uptr);
> 
> 	case ARCH_GET_XCOMP_GUEST_PERM:
> 		permitted = xstate_get_guest_group_perm();
> 		permitted &= XFEATURE_MASK_USER_SUPPORTED;
> 		return put_user(permitted, uptr);
> 
> and while KVM doesn't apply the __state_perm to supervisor states, if it did
> there would be zero harm in doing so.
> 
> 	case 0xd: {
> 		u64 permitted_xcr0 = kvm_get_filtered_xcr0();
> 		u64 permitted_xss = kvm_caps.supported_xss;
> 
> Second, the relying on QEMU to only trigger __xstate_request_perm() is not acceptable.
> It "works" for the current code, but only because there's only a single dynamic
> feature, i.e. this will short circuit and prevent computing a bad ksize.
> 
> 	/* Check whether fully enabled */
> 	if ((permitted & requested) == requested)
> 		return 0;
> 
> I don't know how I can possibly make it any clearer: KVM absolutely must not assume
> userspace behavior.
> 
> So rather than continue with the current madness, which will break if/when the
> next dynamic feature comes along, just preserve non-user xfeatures/flags in
> __guest_perm.

I more or less agree with you, however I would like to discuss the FPU permissions
in more depth:


First of all we have two things at play here:

1. On demand resize of the thread's FPU state buffer to avoid penalty of context switching the AMX state.

2. The fact that allowing this on demand resize of this state buffer breaks the x86_64 ABI,
   because FPU state has to be saved on the signal stack and ABI allows the stack size to be smaller than what is
   needed to save the FPU state with AMX features enabled.

Thus a two tiered approach was done: first application asks for a permission to use the dynamic features,
and then when it actually uses it, the FPU state buffer is resized.

Otherwise if an AMX instruction is used by the app but the permission was not asked by the app for its xstate component, 
the application is terminated.

(I might not 100% understand this correctly, please correct me if I am wrong).

However IMHO the 'fpu permission' name is a bit misleading,
This feature is not really about security/permissions but more like opt-in to use newer ABI,
for example KVM capabilities API, and the kernel will never refuse the permission request
(except if the
signal stack size is too small but the userspace can adjust it before asking for the permission)


On top of that I think that applying the same permission approach to guest's FPU state is not a good fit,
because of two reasons:

1. The guest FPU state will never be pushed on the signal stack - KVM swaps back the host FPU state
   before it returns from the KVM_RUN ioctl.

   Also I think (not sure) that ptrace can only access (FPU) state of a stopped process, and a stopped vCPU process
   will also first return to userspace. Again I might be mistaken here, I never researched this in depth.

   Assuming that I am correct on these assumptions, the guest FPU state can only be accessed via 
   KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2 ioctls,
   which also returns the userspace portion of the state including optionally the AMX state, 
   but this ioctl doesn't really need FPU permission framework, because it is a KVM ABI, and in 
   fact KVM_GET_XSAVE2 was added exactly because of that: to make sure that userspace
   is aware that larger than 4K buffer can be returned.

2. Guest FPU state is not even on demand resized (but I can imagine that in the future we will do this).


And of course, adding permissions for kernel features, that is even worse idea, which we really
shouldn't do.

>  
> If there are no objections, I'll test the below and write a proper changelog.
>  
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 26 Oct 2023 10:17:33 -0700
> Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>  __state_perm
> 
> Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index ef6906107c54..73f6bc00d178 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>  	if ((permitted & requested) == requested)
>  		return 0;
>  
> -	/* Calculate the resulting kernel state size */
> +	/*
> +	 * Calculate the resulting kernel state size.  Note, @permitted also
> +	 * contains supervisor xfeatures even though supervisor are always
> +	 * permitted for kernel and guest FPUs, and never permitted for user
> +	 * FPUs.
> +	 */
>  	mask = permitted | requested;
> -	/* Take supervisor states into account on the host */
> -	if (!guest)
> -		mask |= xfeatures_mask_supervisor();
>  	ksize = xstate_calculate_size(mask, compacted);

This might not work with kernel dynamic features, because xfeatures_mask_supervisor() will
return all supported supervisor features.


Therefore at least until we have an actual kernel dynamic feature 
(a feature used by the host kernel and not KVM, and which has to be dynamic like AMX),
I suggest that KVM stops using the permission
API completely for the guest FPU state, 
and just gives all the features it wants to enable right to __fpu_alloc_init_guest_fpstate()
(Guest FPU permission API IMHO should be deprecated and ignored)



>  
> -	/* Calculate the resulting user state size */
> -	mask &= XFEATURE_MASK_USER_SUPPORTED;
> -	usize = xstate_calculate_size(mask, false);
> +	/*
> +	 * Calculate the resulting user state size.  Take care not to clobber
> +	 * the supervisor xfeatures in the new mask!
> +	 */
> +	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
>  
>  	if (!guest) {
>  		ret = validate_sigaltstack(usize);




Best regards,
	Maxim Levitsky

> 
> base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4







