Return-Path: <kvm+bounces-317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 347137DE240
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 15:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8651B20D89
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 14:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D410713AD5;
	Wed,  1 Nov 2023 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MsSQD7DE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FA4101EC
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 14:16:08 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036183
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 07:16:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afacc566f3so65242927b3.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 07:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698848164; x=1699452964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V40p05CD6XkzApx4zccf3FWriwPpKLjFHTaz0izqv7Q=;
        b=MsSQD7DE7pplsc0b7BoeVtoc8ndYPkawb7gTlxyJyLi9O5YYPrNnkYh8IMbKS+VXDh
         mwL2cZTCbqoMUTPSx6FR56vwk3UgFcwWMnmp9/yG0TuojEXct6FXFeiuaAu9B0bu2Yyl
         KR4Dvc37xbIYikl8atSeY3Jmfdg7+uCUprtupEmJDtavoeQuZCMKXPTxPl8qto349e19
         edih/xa/6v7lBZcYIbeu5Q5n1J4bYoKYJGEv5OQz0oYDvtKBoZ+FBPYUg+vgtRw0n4oN
         xPxuLDw064f89DYj/rxHoG1oIY5mlFIC/VZvISXqrr5GijWrFn5n8JOB4eLoSrKs37it
         X9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698848164; x=1699452964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V40p05CD6XkzApx4zccf3FWriwPpKLjFHTaz0izqv7Q=;
        b=CcGQzKFdSGlLteIFMLKipWjd77HibENlOkSxzB8Z5giCiudz/2jkM54VGl+qHzQ52X
         ZujeTUYXZD1TSJ8zUjDnrztI1yuy045Cu+Mvhyq6gwrofPcjhw41tCehjVTfWe94nVdK
         Hl1eKAxEYptBSPQPcsbeVLYVLCb/UYhCVMXrI+VchnAxoZA74gV6YfYyB4nVjW3RyyEv
         wGIihMj5Lr3KK2DUmpsw4Fy1nJtlvVJ/xchp1n+eD4QHwSlp5wWws+m3e4n9BML5cVjb
         BY1DiE4x93hSaXB2Mzz5d5b2mH3l6d4R/WZhXJkZyl6UmMqRsfDQl2e6EYodFg53yUfX
         RWOA==
X-Gm-Message-State: AOJu0Yy+MtB+wAprxpeKdJsradG2ui6swKIP/aehFf6k40e9C1vNJfV8
	zv5XRzy3dEkdYMHGDsDR//MV+oksHEc=
X-Google-Smtp-Source: AGHT+IG5yfHp4gwZrrbycFMA7Q58mhz5LHvmZjSqQ9DnhKtq2igOtYOfuFP5mn6MtxsFZJtRj0EXAdx5t9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:848c:0:b0:d9a:5e10:c34d with SMTP id
 v12-20020a25848c000000b00d9a5e10c34dmr308204ybk.11.1698848163709; Wed, 01 Nov
 2023 07:16:03 -0700 (PDT)
Date: Wed, 1 Nov 2023 07:16:02 -0700
In-Reply-To: <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
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
Message-ID: <ZUJdohf6wLE5LrCN@google.com>
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>, Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
> > On Wed, Oct 25, 2023, Weijiang Yang wrote:
> On top of that I think that applying the same permission approach to guest's
> FPU state is not a good fit, because of two reasons:
> 
> 1. The guest FPU state will never be pushed on the signal stack - KVM swaps
>    back the host FPU state before it returns from the KVM_RUN ioctl.
> 
>    Also I think (not sure) that ptrace can only access (FPU) state of a
>    stopped process, and a stopped vCPU process will also first return to
>    userspace. Again I might be mistaken here, I never researched this in
>    depth.
> 
>    Assuming that I am correct on these assumptions, the guest FPU state can
>    only be accessed via KVM_GET_XSAVE/KVM_SET_XSAVE/KVM_GET_XSAVE2 ioctls,
>    which also returns the userspace portion of the state including optionally
>    the AMX state, but this ioctl doesn't really need FPU permission
>    framework, because it is a KVM ABI, and in fact KVM_GET_XSAVE2 was added
>    exactly because of that: to make sure that userspace is aware that larger
>    than 4K buffer can be returned.
> 
> 2. Guest FPU state is not even on demand resized (but I can imagine that in
>    the future we will do this).

Just because guest FPU state isn't resized doesn't mean there's no value in
requiring userspace to opt-in to allocating 8KiB of data per-vCPU.

> And of course, adding permissions for kernel features, that is even worse
> idea, which we really shouldn't do.
> 
> >  
> > If there are no objections, I'll test the below and write a proper changelog.
> >  
> > --
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Thu, 26 Oct 2023 10:17:33 -0700
> > Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
> >  __state_perm
> > 
> > Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index ef6906107c54..73f6bc00d178 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
> >  	if ((permitted & requested) == requested)
> >  		return 0;
> >  
> > -	/* Calculate the resulting kernel state size */
> > +	/*
> > +	 * Calculate the resulting kernel state size.  Note, @permitted also
> > +	 * contains supervisor xfeatures even though supervisor are always
> > +	 * permitted for kernel and guest FPUs, and never permitted for user
> > +	 * FPUs.
> > +	 */
> >  	mask = permitted | requested;
> > -	/* Take supervisor states into account on the host */
> > -	if (!guest)
> > -		mask |= xfeatures_mask_supervisor();
> >  	ksize = xstate_calculate_size(mask, compacted);
> 
> This might not work with kernel dynamic features, because
> xfeatures_mask_supervisor() will return all supported supervisor features.

I don't understand what you mean by "This".

Somewhat of a side topic, I feel very strongly that we should use "guest only"
terminology instead of "dynamic".  There is nothing dynamic about whether or not
XFEATURE_CET_KERNEL is allowed; there's not even a real "decision" beyond checking
wheter or not CET is supported.

> Therefore at least until we have an actual kernel dynamic feature (a feature
> used by the host kernel and not KVM, and which has to be dynamic like AMX),
> I suggest that KVM stops using the permission API completely for the guest
> FPU state, and just gives all the features it wants to enable right to

By "it", I assume you mean userspace?

> __fpu_alloc_init_guest_fpstate() (Guest FPU permission API IMHO should be
> deprecated and ignored)

KVM allocates guest FPU state during KVM_CREATE_VCPU, so not using prctl() would
either require KVM to defer allocating guest FPU state until KVM_SET_CPUID{,2},
or would require a VM-scoped KVM ioctl() to let userspace opt-in to

Allocating guest FPU state during KVM_SET_CPUID{,2} would get messy, as KVM allows
multiple calls to KVM_SET_CPUID{,2} so long as the vCPU hasn't done KVM_RUN.  E.g.
KVM would need to support actually resizing guest FPU state, which would be extra
complexity without any meaningful benefit.

The only benefit I can think of for a VM-scoped ioctl() is that it would allow a
single process to host multiple VMs with different dynamic xfeature requirements.
But such a setup is mostly theoretical.  Maybe it'll affect the SEV migration
helper at some point?  But even that isn't guaranteed.

So while I agree that ARCH_GET_XCOMP_GUEST_PERM isn't ideal, practically speaking
it's sufficient for all current use cases.  Unless a concrete use case comes along,
deprecating ARCH_GET_XCOMP_GUEST_PERM in favor of a KVM ioctl() would be churn for
both the kernel and userspace without any meaningful benefit, or really even any
true change in behavior.

