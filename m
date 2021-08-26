Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BCE3F83F7
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 10:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhHZIzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 04:55:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229785AbhHZIzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 04:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629968074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ng/LaKFuKOW+sfVAxKkipbH//fTtw7cNxs/+VHrslis=;
        b=MHKhU3XtKXgqMF4PSrfn9H/Tnqb1+Zg9dyn2icEz6orgsHgingewdeiRTJBE1VDPcv2/oY
        W+R4b9B7YCjkBcT83Au116LCXWTg9H0YJXGodNap9EjyrU2DLQ79k252qI4uss7wrZW09p
        8jTjDInNg3et++b/bfUpTqDbzb46RFM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551--udoGi4JORSevBr8FwGywQ-1; Thu, 26 Aug 2021 04:54:33 -0400
X-MC-Unique: -udoGi4JORSevBr8FwGywQ-1
Received: by mail-ed1-f69.google.com with SMTP id x4-20020a50d9c4000000b003bed5199871so1160182edj.14
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 01:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ng/LaKFuKOW+sfVAxKkipbH//fTtw7cNxs/+VHrslis=;
        b=es8wE1i2o6+7Uld7x/oTazP5YPNa2tioQpRPezvFH8FWoXc9Jk4neVFXCmE915nMRN
         dqyD1PEcr1bWvl5Sfs9uYx7r+LVbgzNYZHrFaLv8YUoBDhXwTAVvcIQ4TKq3qjjyg/Yi
         0+0RAH1uBGcTrmUcCm5L+CcOv7OcdtZ12TJDLUbGQQH1CRH7mKw5VgEgD6kEspuo5aLR
         YbUmxe5sVk0e0bp1VQwg8kz/IPwDr6B2rPjS5yrVECsR1SyeNhvVYizfjc9r5iV8u65q
         WBJMIYrkptHbiAPPN5FU4e5ikLXo0s9eCIj0HhC/S2sR657rp2kizkEVU8YFWqYTMrkA
         U51A==
X-Gm-Message-State: AOAM5319hoWmPge+Qb0+GogQV1DsvlJ4oIdOPun8fucyERq+9bmgrFES
        7fSxTgvoNdweraOkgdgLPTEkb9VuCDmvayDDgpynTZnvNVMOFem370BnEn0b/JrIImsv2DBz+YV
        ERHrxs9miyLXZ
X-Received: by 2002:a05:6402:1385:: with SMTP id b5mr3096129edv.276.1629968072191;
        Thu, 26 Aug 2021 01:54:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfJNLWKIzVaG6/BqSmTU8tzUq9KZs+QyMNnXfOwFl2X4buoGVJxlpp7+StsYUgidoQKDEANA==
X-Received: by 2002:a05:6402:1385:: with SMTP id b5mr3096108edv.276.1629968071945;
        Thu, 26 Aug 2021 01:54:31 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id sa21sm985202ejb.108.2021.08.26.01.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 01:54:31 -0700 (PDT)
Date:   Thu, 26 Aug 2021 10:54:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        pshier@google.com, ricarkol@google.com, rananta@google.com,
        reijiw@google.com, jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <20210826085429.b67fzkshhl3s2vfr@gator.home>
References: <YSVhV+UIMY12u2PW@google.com>
 <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
 <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <20210826084945.yknl64gklxtygwal@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826084945.yknl64gklxtygwal@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 10:49:45AM +0200, Andrew Jones wrote:
> On Wed, Aug 25, 2021 at 11:14:59AM -0700, Oliver Upton wrote:
> > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Wed, Aug 25, 2021 at 11:39:34AM +0100, Marc Zyngier wrote:
> > > > On Wed, 25 Aug 2021 11:02:28 +0100,
> > > > Oliver Upton <oupton@google.com> wrote:
> > > > >
> > > > > On Wed, Aug 25, 2021 at 2:27 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > > > Exposing new hypercalls to guests in this manner seems very unsafe to
> > > > > > > me. Suppose an operator is trying to upgrade from kernel N to kernel
> > > > > > > N+1, which brings in the new 'widget' hypercall. Guests are live
> > > > > > > migrated onto the N+1 kernel, but the operator finds a defect that
> > > > > > > warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
> > > > > > > Any guests that discovered the 'widget' hypercall are likely going to
> > > > > > > get fussy _very_ quickly on the old kernel.
> > > > > >
> > > > > > This goes against what we decided to support for the *only* publicly
> > > > > > available VMM that cares about save/restore, which is that we only
> > > > > > move forward and don't rollback.
> > > > >
> > > > > Ah, I was definitely missing this context. Current behavior makes much
> > > > > more sense then.
> > > > >
> > > > > > Hypercalls are the least of your
> > > > > > worries, and there is a whole range of other architectural features
> > > > > > that will have also appeared/disappeared (your own CNTPOFF series is a
> > > > > > glaring example of this).
> > > > >
> > > > > Isn't that a tad bit different though? I'll admit, I'm just as guilty
> > > > > with my own series forgetting to add a KVM_CAP (oops), but it is in my
> > > > > queue to kick out with the fix for nVHE/ptimer. Nonetheless, if a user
> > > > > takes up a new KVM UAPI, it is up to the user to run on a new kernel.
> > > >
> > > > The two are linked. Exposing a new register to userspace and/or guest
> > > > result in the same thing: you can't rollback. That's specially true in
> > > > the QEMU case, which *learns* from the kernel what registers are
> > > > available, and doesn't maintain a fixed list.
> > > >
> > > > > My concerns are explicitly with the 'under the nose' changes, where
> > > > > KVM modifies the guest feature set without userspace opting in. Based
> > > > > on your comment, though, it would appear that other parts of KVM are
> > > > > affected too.
> > > >
> > > > Any new system register that is exposed by a new kernel feature breaks
> > > > rollback. And so far, we only consider it a bug if the set of exposed
> > > > registers reduces. Anything can be added safely (as checked by one of
> > > > the selftests added by Drew).
> > > >
> > > > < It doesn't have to be rollback safety, either. There may
> > > > > simply be a hypercall which an operator doesn't want to give its
> > > > > guests, and it needs a way to tell KVM to hide it.
> > > >
> > > > Fair enough. But this has to be done in a scalable way, which
> > > > individual capability cannot provide.
> > > >
> > > > > > > Have I missed something blatantly obvious, or do others see this as an
> > > > > > > issue as well? I'll reply with an example of adding opt-out for PTP.
> > > > > > > I'm sure other hypercalls could be handled similarly.
> > > > > >
> > > > > > Why do we need this? For future hypercalls, we could have some buy-in
> > > > > > capabilities. For existing ones, it is too late, and negative features
> > > > > > are just too horrible.
> > > > >
> > > > > Oh, agreed on the nastiness. Lazy hack to realize the intended
> > > > > functional change..
> > > >
> > > > Well, you definitely achieved your goal of attracting my attention :).
> > > >
> > > > > > For KVM-specific hypercalls, we could get the VMM to save/restore the
> > > > > > bitmap of supported functions. That would be "less horrible". This
> > > > > > could be implemented using extra "firmware pseudo-registers" such as
> > > > > > the ones described in Documentation/virt/kvm/arm/psci.rst.
> > > > >
> > > > > This seems more reasonable, especially since we do this for migrating
> > > > > the guest's PSCI version.
> > > > >
> > > > > Alternatively, I had thought about using a VM attribute, given the
> > > > > fact that it is non-architectural information and we avoid ABI issues
> > > > > in KVM_GET_REG_LIST without buy-in through a KVM_CAP.
> > > >
> > > > The whole point is that these settings get exposed by
> > > > KVM_GET_REG_LIST, as this is QEMU's way to dump a VM state. Given that
> > > > we already have this for things like the spectre management state, we
> > > > can just as well expose the bitmaps that deal with the KVM-specific
> > > > hypercalls. After all, this falls into the realm of "KVM as VM
> > > > firmware".
> > > >
> > > > For ARM-architected hypercalls (TRNG, stolen time), we may need a
> > > > similar extension.
> > > >
> > >
> > > Thanks for including me Marc. I think you've mentioned all the examples
> > > of why we don't generally expect N+1 -> N migrations to work that I
> > > can think of. While some of the examples like get-reg-list could
> > > eventually be eliminated if we had CPU models to tighten our machine type
> > > state, I think N+1 -> N migrations will always be best effort at most.
> > >
> > > I agree with giving userspace control over the exposer of the hypercalls
> > > though. Using pseudo-registers for that purpose rather than a pile of
> > > CAPs also seems reasonable to me.
> > >
> > > And, while I don't think this patch is going to proceed, I thought I'd
> > > point out that the opt-out approach doesn't help much with expanding
> > > our migration support unless we require the VMM to be upgraded first.
> > >
> > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > work as expected, since the source enforce opt-out, but the destination
> > > won't.
> > 
> > Right, there's going to need to be a fence in both kernel and VMM
> > versions. Before the fence, you can't rollback with either component.
> > Once on the other side of the fence, the user may freely migrate
> > between kernel + VMM combinations.
> > 
> > > Also, since the VMM doesn't key off the kernel version, for the
> > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > leaving it to the user to ensure they consider everything. opt-in
> > > usually only needs the user to consider what machine type they want to
> > > launch.
> > 
> > Going the register route will implicitly require opt-out for all old
> > hypercalls. We exposed them unconditionally to the guest before, and
> > we must uphold that behavior. The default value for the bitmap will
> > have those features set. Any hypercalls added after that register
> > interface will then require explicit opt-in from userspace.
> > 
> > With regards to the pseudoregister interface, how would a VMM discover
> > new bits? From my perspective, you need to have two bitmaps that the
> > VMM can get at: the set of supported feature bits and the active
> > bitmap of features for a running guest.
> >
> 
> I think we should model the pseudo-register approach off of x86's
> CPUID approach. x86 has specific get/set ioctls for CPUIDs
> (KVM_GET/SET_CPUID2), but I think we should get by with just
> get/set-one-reg. However, it might be nice/necessary to have something
> like x86's KVM_GET_SUPPORTED_CPUID which returns all the registers
> at once as a bitmap and the set bits would inform userspace of what's
> supported by the hardware and KVM.
> 
> So a new ioctl similar to KVM_GET_SUPPORTED_CPUID would be your
> first bitmap that shows what's supported and then userpace can
> determine what it wants to change and calculate the appropriate
> pseudo-registers to set/clear bits on with set-one-reg, as x86
> would do with kvm-set-cpuid2.
>

I see Marc just replied stating we'll probably just have a single
register. The KVM_GET_SUPPORTED_CPUID type of ioctl would be
overkill in that case (get-one_reg is enough). Anyway it can
always be added later if we expand into more registers.

Thanks,
drew

