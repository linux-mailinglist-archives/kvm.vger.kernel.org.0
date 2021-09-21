Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99372413A07
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhIUSXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbhIUSXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 14:23:47 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F996C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 11:22:09 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h129so4194715iof.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9+MHxSXYWf62H1mi1zwglh1AL9XfTUwDuHjSd9t/urI=;
        b=jyujWDhde9Ijat2B16V/yQFlxPDr13NnlzjpfFtbN/4jk4xVU5OLGyChRGgfFmiXEf
         17pwo3aMGu4v0FWTN96FMwOVx0HdSEeCJ+7wkdtk4JUYaDxEQbuf2WnEBLE3qTc6NCEJ
         128fHPjCV0jY/+/G0916Bz0MK+UcCJ2RMVLryO23dF42QcZRJtWwLrGq10JGSk37NEhl
         DYWU+Ew1iSYu8FV2BX4Q7uYsRpPZDyyOnSZzQoqqU4a/74glpc3LlyZ6HtAGwd74hn7I
         uqByjmnxA/EzblonHNyVc/aN2CZOQ8r+6PY1ZZBNbaNdOYE36rcMq+0gD009RAKIUV0k
         r51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9+MHxSXYWf62H1mi1zwglh1AL9XfTUwDuHjSd9t/urI=;
        b=zgm+WChCVRqDxV2hMfibHBR+O46bRRTe70xY1UKD9TU5Z7roLglDCre4j1ndkiFMsw
         jh0siD2ez57tp3Q27Vg70UnDOVBCLC125Ms8nNqSONxbgzSJVdULssbuzwsa3vQIEoMj
         mu1+8L0zAk+/BlCKclpbQ13rBdh5wosTm6tUqojAoDOpmwZVXLXrQKEPHGr9Xvumq3Mi
         oOryugI7a4qI8DtmADKIwuEzB+FHgVW3Zh55wazcRuUaI8pukE4Pp0/c08y+xg62E/A8
         JcRxOuYgmSJ8KNQmn0NxTFgkbMU0Ix3wwEEKUUOnxI5QhAHRwihrgSscPY8vUerjltbO
         Xeng==
X-Gm-Message-State: AOAM531JPYcW3USI4A8aIYM6PSMx2G9okRiQLZCkvrPYdUn1EewXrRB6
        b0VWCyJhHIqH0zEJ+rgXPx6ZAw==
X-Google-Smtp-Source: ABdhPJxbTKfRsy2+nMboYmvHPECb+3i1VPhDhlxB7htZ/MIZ22coBg216qMnOQCeKMbph/gje7gM7Q==
X-Received: by 2002:a05:6638:2393:: with SMTP id q19mr1249131jat.109.1632248528551;
        Tue, 21 Sep 2021 11:22:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id w4sm3355197iox.25.2021.09.21.11.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:22:07 -0700 (PDT)
Date:   Tue, 21 Sep 2021 18:22:04 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
Message-ID: <YUoizIJ+xQTreLtP@google.com>
References: <20210819223640.3564975-1-oupton@google.com>
 <87ilzecbkj.wl-maz@kernel.org>
 <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com>
 <87a6kocmcx.wl-maz@kernel.org>
 <CAOQ_QshZe8ay03XqCo4DkM6zUaOuEoS5bRbrOy+FsuXaJ=YyKA@mail.gmail.com>
 <87k0jauurx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0jauurx.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Tue, Sep 21, 2021 at 10:45:22AM +0100, Marc Zyngier wrote:
> > > > > - How do you define which interrupts are actual wake-up events?
> > > > >   Nothing in the GIC architecture defines what a wake-up is (let alone
> > > > >   a wake-up event).
> > > >
> > > > Good point.
> > > >
> > > > One possible implementation of suspend could just be a `WFI` in a
> > > > higher EL. In this case, KVM could emulate WFI wake up events
> > > > according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
> > > > clear what constitutes a wakeup from powered down state.
> > >
> > > It isn't, and it is actually IMPDEF (there isn't much in the ARM ARM
> > > in terms of what constitutes a low power state). And even if you
> > > wanted to emulate a WFI in userspace, the problem of interrupts that
> > > have their source in the kernel remains. How to you tell userspace
> > > that such an event has occurred if the vcpu thread isn't in the
> > > kernel?
> > 
> > Well, are there any objections to saying for the KVM implementation we
> > observe the WFI wake-up events per the cited section of the ARM ARM?
> 
> These are fine. However, what of the GIC, for example? Can any GIC
> interrupt wake-up the guest? I'm happy to say "yes" to this, but I
> suspect others will have a different idea, and the thought of
> introducing an IMPDEF wake-up interrupt controller doesn't fill me
> with joy.
>

I'm planning to propose exactly this in the next series; any GIC
interrupt will wake the guest. I'd argue that if someone wants to do
anything else, their window of opportunity is the exit to userspace.

[...]

> > Just to check understanding for v2:
> > 
> > We agree that an exit to userspace is fine so it has the opportunity
> > to do something crazy when the guest attempts a suspend. If a VMM does
> > nothing and immediately re-enters the kernel, we emulate the suspend
> > there by waiting for some event to fire, which for our purposes we
> > will say is an interrupt originating from userspace or the kernel
> > (WFI). In all, the SUSPEND exit type does not indicate that emulation
> > terminates with the VMM. It only indicates we are about to block in
> > the kernel.
> > 
> > If there is some IMPDEF event specific to the VMM, it should signal
> > the vCPU thread to kick it out of the kernel, make it runnable, and
> > re-enter. No need to do anything special from the kernel perspective
> > for this. This is only for the case where we decide to block in the
> > kernel.
> 
> This looks sensible. One question though: I think there is an implicit
> requirement that the guest should be "migratable" in that state. How
> does the above handles it? If the "suspend state" is solely held in
> the kernel, we need to be able to snapshot it, and I don't like the
> sound of that...
> 
> We could instead keep the "suspend state" in the VMM:
> 
> On PSCI_SUSPEND, the guest exits to userspace. If the VMM wants to
> honour the supend request, it reenters the guest with RUN+SUSPEND,
> which results in a WFI. On each wake-up, the guest exits to userspace,
> and it is the VMM responsibility to either perform the wake-up (RUN)
> or stay in suspend (RUN+SUSPEND).
> 
> This ensures that the guest never transitions out of suspend without
> the VMM knowing, and the VMM can always force a resume by kicking the
> thread back to userspace.
> 
> Thoughts?

Agreed. I was mulling on exactly how to clue in the VMM about the
suspend state. What if we just encode it in KVM_{GET,SET}_MP_STATE? We'd
avoid the need for new UAPI that way. We could introduce a new state,
KVM_MP_STATE_SUSPENDED, which would clue KVM to do the suspend as we've
discussed. We would exit to userspace with KVM_MP_STATE_RUNNABLE,
meaning the VMM would need to set the MP state explicitly for the
in-kernel suspend to work.

[...]

> > > > On the contrary, it is up to KVM's implementation to
> > > > guarantee caches are clean when servicing the guest request.
> > >
> > > This last point is pretty unclear to me. If the guest doesn't clean to
> > > the PoC (or even to one of the PoPs) when it calls into suspend,
> > > that's a clear indication that it doesn't care about its data. Why
> > > should KVM be more conservative here? It shouldn't be in the business
> > > of working around guest bugs.
> > 
> > PSCI is vague on this, sadly. DEN0022D.b, 5.4.8 "Implementation
> > responsibilities: Cache and coherency management states" that for
> > CPU_SUSPEND, the PSCI implementation must perform a cache clean
> > operation before entering the powerdown state. I don't see any reason
> > why SYSTEM_SUSPEND should be excluded from this requirement.
> 
> I'm not sure that's the case. CPU_SUSPEND may not use the resume
> entry-point if the suspend results is a shallower state than expected
> (i.e. the call just returns instead of behaving like a CPU boot).
> 
> However, a successful SYSTEM_SUSPEND always results in the deepest
> possible state. The guest should know that. There is also the fact
> that performing a full clean to the PoC is going to be pretty
> expensive, and I'd like to avoid that.
> 
> I'll try and reach out to some of the ARM folks for clarification on
> the matter.

That'd be very helpful!

--
Thanks,
Oliver
