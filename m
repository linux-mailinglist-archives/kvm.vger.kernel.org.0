Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC76467CF6
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 19:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359246AbhLCSJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 13:09:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353418AbhLCSJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 13:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638554785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fz6eezRi2GcpSYDxj1WlJaCwG5RUZS4Oj5p6CympJw0=;
        b=QbEeAFa6VRv5bf1Ud7zZijRijPwgYTYgY3B834giKz4kbfg+R82ipJbGefKzCRBQTp25ED
        F5R6IS/cYJgFvoWUMaWGbLBPvsZySk8O+qCs6jG+niWyYBv5+5eSIr4Ifk+4wiZaMub6Bk
        rzDTT3jCAmIwYp3ouex9vzIxbsYcQHg=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322--r6fiCrKMuS_swwnwcvMpg-1; Fri, 03 Dec 2021 13:06:24 -0500
X-MC-Unique: -r6fiCrKMuS_swwnwcvMpg-1
Received: by mail-oi1-f200.google.com with SMTP id r65-20020aca4444000000b002bce52a8122so2616770oia.14
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 10:06:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fz6eezRi2GcpSYDxj1WlJaCwG5RUZS4Oj5p6CympJw0=;
        b=WWKu9K2o1UWnu0UNNQ8yLBMvHgU+rJsBJzi7GR9I0rUUXM9sFSVd4zPdsB5ks4oGWu
         lFKG2QEbdYs6Y6SZdcuxCA4Y5IKgjzDAsRPCHXXT1JZhUFgcMz47THxU/F8adrE+5k4g
         4xNcq79lnlrelmSa1A3vN8pfgh6ZxPW1AF82E7VTKzCyDp0qFdDAWRypveD6YkeUdQCW
         9UB3tu4JDJ29cWpqCEHUtvXlUqmksP+IDgq/WFYU7DqZjCc9BkY2Wp+7Oxw8mlxr3igv
         ubgboM5/pbSGay5FCXbZi6EDtiRnx0X55S6Ei/XediiCKSqcgCrsOV+eb2NzxTrqZRWK
         G/rA==
X-Gm-Message-State: AOAM532x2mGQGKmA2vjc6XjtBQfkbjF3zy946QExiXEfoM/8LoEybVuw
        uAR3PR/y/mFMBH47+o+FZ/Z4eBi+0tacVbgBtXukMZ5BJNCB6+Flacy+HTw6vscI+D1KqgFZ5/v
        S5/WzHEDIoDDG
X-Received: by 2002:a05:6808:150d:: with SMTP id u13mr11057403oiw.155.1638554782385;
        Fri, 03 Dec 2021 10:06:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5fjWxPexWIYvtOQimmFf5cN2dADOhc4ZVYhfspjYpjQemgO4mRbJK/GFo1hldxnr5AIDpGA==
X-Received: by 2002:a05:6808:150d:: with SMTP id u13mr11057367oiw.155.1638554781838;
        Fri, 03 Dec 2021 10:06:21 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r37sm775998otv.54.2021.12.03.10.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 10:06:21 -0800 (PST)
Date:   Fri, 3 Dec 2021 11:06:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211203110619.1835e584.alex.williamson@redhat.com>
In-Reply-To: <20211201232502.GO4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
        <20211130102611.71394253.alex.williamson@redhat.com>
        <20211130185910.GD4670@nvidia.com>
        <20211130153541.131c9729.alex.williamson@redhat.com>
        <20211201031407.GG4670@nvidia.com>
        <20211201130314.69ed679c@omen>
        <20211201232502.GO4670@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Dec 2021 19:25:02 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Dec 01, 2021 at 01:03:14PM -0700, Alex Williamson wrote:
> > On Tue, 30 Nov 2021 23:14:07 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:
> > >   
> > > > > From what HNS said the device driver would have to trap every MMIO to
> > > > > implement NDMA as it must prevent touches to the physical HW MMIO to
> > > > > maintain the NDMA state.
> > > > > 
> > > > > The issue is that the HW migration registers can stop processing the
> > > > > queue and thus enter NDMA but a MMIO touch can resume queue
> > > > > processing, so NDMA cannot be sustained.
> > > > > 
> > > > > Trapping every MMIO would have a huge negative performance impact.  So
> > > > > it doesn't make sense to do so for a device that is not intended to be
> > > > > used in any situation where NDMA is required.    
> > > > 
> > > > But migration is a cooperative activity with userspace.  If necessary
> > > > we can impose a requirement that mmap access to regions (other than the
> > > > migration region itself) are dropped when we're in the NDMA or !RUNNING
> > > > device_state.      
> > > 
> > > It is always NDMA|RUNNING, so we can't fully drop access to
> > > MMIO. Userspace would have to transfer from direct MMIO to
> > > trapping. With enough new kernel infrastructure and qemu support it
> > > could be done.  
> > 
> > This is simply toggling whether the mmap MemoryRegion in QEMU is
> > enabled, when not enabled access falls through to the read/write access
> > functions.  We already have this functionality for unmasking INTx
> > interrupts when we don't have EOI support.
> >  
> > > Even so, we can't trap accesses through the IOMMU so such a scheme
> > > would still require removing IOMMU acess to the device. Given that the
> > > basic qemu mitigation for no NDMA support is to eliminate P2P cases by
> > > removing the IOMMU mappings this doesn't seem to advance anything and
> > > only creates complexity.  
> > 
> > NDMA only requires that the device cease initiating DMA, so I suppose
> > you're suggesting that the MMIO of a device that doesn't expect to make
> > use of p2p DMA could be poked through DMA, which might cause the device
> > to initiate a DMA and potentially lose sync with mediation.  That would
> > be bad, but seems like a non-issue for hns.  
> 
> Yes, not sure how you get to a non-issue though? If the IOMMU map is
> present the huawei device can be attacked by a hostile VM and forced
> to exit NDMA. All this takes is any two DMA capable devices to be
> plugged in?

I'm confused by your idea of a "hostile VM".  Devices within a VM can
only DMA to memory owned by the VM.  So the only hostile VM that can
attack this device is the VM that owns the device in the first place.
Meanwhile the VMM is transitioning all devices to the NDMA state, so
the opportunity to poke one device from another device within the same
VM is pretty limited.  And for what gain?  Is this a DoS opportunity
that the guest might trigger the migration to abort or fail?

I suggest this might be a non-issue for hns because I understand it to
not support any sort of p2p, therefore this DMA write to the device
while it's under mediation would never happen in practice.  Skipping
the IOMMU mappings for the device would prevent it, but I'm still not
sure if this goes beyond a VM shooting itself scenario.

> > > At least I'm not going to insist that hns do all kinds of work like
> > > this for a edge case they don't care about as a precondition to get a
> > > migration driver.  
> > 
> > I wonder if we need a region flag to opt-out of IOMMU mappings for
> > devices that do not support p2p use cases.  If there were no IOMMU
> > mappings and mediation handled CPU driven MMIO accesses, then we'd have
> > a viable NDMA mode for hns.  
> 
> This is a good idea, if we want to make huawei support NDMA then
> flagging it to never be in the iommu map in the first place is a great
> solution. Then they can use CPU mmio trapping get the rest of the way.

NB, this flag would only be a hint to the VMM, the vfio IOMMU backend
would need to be involved if we intended to prevent such mappings, but
that seems like overkill if we're expecting userspace to follow the
rules to get working migration and migration drivers have sufficient
robustness to maintain device isolation.

> > > > There's no reason that mediation while in the NDMA state needs to
> > > > impose any performance penalty against the default RUNNING state.     
> > > 
> > > Eh? Mitigation of no NDMA support would have to mediate the MMIO on a
> > > a performance doorbell path, there is no escaping a performance
> > > hit. I'm not sure what you mean  
> > 
> > Read it again, I'm suggesting that mediation during NDMA doesn't need
> > to carry over any performance penalty to the default run state.  We
> > don't care if mediation imposes a performance penalty while NDMA is set,
> > we're specifically attempting to quiesce the device.  The slower it
> > runs the better ;)  
> 
> OK, I don't read it like that. It seems OK to have a performance hit
> in NDMA since it is only a short grace state.

Is it the length of time we're in the NDMA state or the utility of the
NDMA state itself?  If we're telling the device "no more outbound DMA,
no more interrupts", then it doesn't seem super relevant for the
majority of use cases what happens to the MMIO latency. 

> > > It would make userspace a bit simpler at the cost of excluding or
> > > complicating devices like hns for a use case they don't care about.
> > > 
> > > On the other hand, the simple solution in qemu is when there is no
> > > universal NDMA it simply doesn't include any MMIO ranges in the
> > > IOMMU.  
> > 
> > That leads to mysterious performance penalties when a VM was previously
> > able to make use of (ex.) GPUDirect,   
> 
> Not a penalty it will just explode somehow. There is no way right now
> for a VM to know P2P doesn't work. It is one of these annoying things
> that leaks to the VMM like the no-snoop mess. A VMM installing a
> device combination that is commonly used with P2P, like a GPU and a
> NIC, had a better make sure P2P works :)
> 
> > but adds an hns device and suddenly can no longer use p2p.  Or
> > rejected hotplugs if a device has existing NDMA capable devices, p2p
> > might be active, but the new device does not support NDMA.    
> 
> I don't think qemu can go back on what it already did, so rejected
> hotplug seems the only choice.

Agreed

> > This all makes it really complicated to get deterministic behavior
> > for devices.  I don't know how to make QEMU behavior predictable and
> > supportable in such an environment.  
> 
> And this is the thing that gives me pause to think maybe the huawei
> device should do the extra work?
> 
> On the other hand I suspect their use case is fine with qemu set to
> disable P2P completely.

I don't know how we look at that use case in isolation though.

> OTOH "supportable" qemu could certainly make the default choice to
> require devices for simplicity.

I get a bit lost every time I try to sketch out how QEMU would
implement it.  Forgive the stream of consciousness and rhetorical
discussion below...

 - Does it make sense that a device itself can opt-out of p2p mappings?
   This is simply an MMIO access from another device rather than from
   the CPU.  Vendors cannot preclude this use case on bare metal,
   should they be able to in a VM?  We create heterogeneous p2p maps,
   device A can access device B, but device B maybe can't access device
   A.  Seems troublesome.

 - If we can't have a per-device policy, then we'd need a per VM
   policy, likely some way to opt-out of all p2p mappings for vfio
   devices.  We need to support hotplug of devices though, so is it a
   per VM policy or is it a per device policy which needs to be
   consistent among all attached devices?  Perhaps a
   "enable_p2p=on/off" option on the vfio-pci device, default [on] to
   match current behavior.  For any case of this option being set to
   non-default, all devices would need to set it to the same value,
   non-compliant devices rejected.

 - We could possibly allow migration=on,enable_p2p=on for a non-NDMA
   device, but the rules change if additional devices are added, they
   need to be rejected or migration support implicitly disappears.  That
   seems hard to document, non-deterministic as far as a user is
   concerned. So maybe for a non-NDMA device we'd require
   enable_p2p=off in order to set migration=on.  That means we could
   never enable migration on non-NDMA devices by default, which
   probably means we also cannot enable it by default on NDMA devices
   or we get user confusion/inconsistency.

 - Can a user know which devices will require enable_p2p=off in order
   to set migration=on?  "Read the error log" is a poor user experience
   and difficult hurdle for libvirt.

So in order to create a predictable QEMU experience in the face of
optional NDMA per device, I think we preclude being able to enable
migration support for any vfio device by default and we have an
exercise to determine how a user or management tool could easily
determine NDMA compatibility :-\

> > > Since qemu is the only implementation it would be easy for drivers to
> > > rely on the implicit reset it seems to do, it seems an important point
> > > that should be written either way.
> > > 
> > > I don't have a particular requirement to have the reset, but it does
> > > seem like a good idea. If you feel strongly, then let's say the
> > > opposite that the driver must enter RESUME with no preconditions,
> > > doing an internal reset if required.  
> > 
> > It seems cleaner to me than unnecessarily requiring userspace to pass
> > through an ioctl in order to get to the next device_state.  
> 
> Ok, I'll add something like this.
> 
> > > Can you point to something please? I can't work with "I'm not sure"  
> > 
> > The reset behavior that I'm trying to clarify above is the primary
> > offender, but "I'm not sure" I understand the bit prioritization enough
> > to know that there isn't something there as well.  I'm also not sure if
> > the "end of stream" phrasing below matches the uAPI.  
> 
> Realistically I think userspace should not make use of the bit
> prioritization. It is more as something driver implementors should
> follow for consistent behavior.
>  
> > > IMO the header file doesn't really say much and can be read in a way
> > > that is consistent with this more specific document.  
> > 
> > But if this document is suggesting the mlx5/QEMU interpretation is the
> > only valid interpretations for driver authors, those clarifications
> > should be pushed back into the uAPI header.  
> 
> Can we go the other way and move more of the uAPI header text here?

Currently our Documentation/ file describes an overview of vfio, the
high level theory of groups, devices, and iommus, provides a detailed
userspace usage example, an overview of device registration and ops,
and a bunch of random spapr implementation notes largely around
userspace considerations on power platforms.

So I would generalize that our Documentation/ is currently focused on
userspace access and interaction with the uAPI.  The uAPI itself
therefore generally provides the detail regarding how a given interface
is intended to work from an implementation perspective.  I'd say the
proposed document here is mixing both of those in Documentation/, some
aspects relevant to implementation of the uAPI, others to userspace.

Currently I would clearly say that the uAPI header is the canonical
source of truth and I think it should continue to be so for describing
the implementation of the uAPI.

> > > I have no idea anymore. You asked for docs and complete picture as a
> > > percondition for merging a driver. Here it is.
> > > 
> > > What do you want?  
> > 
> > Looking through past conversations, I definitely asked that we figure
> > out how NDMA is going to work.  Are you thinking of a different request
> > from me?  
> 
> It was part of the whole etherpad thing. This was what we said we'd do
> to resolve the discussion.
> 
> I expect to come to some agreement with you and Connie on this text
> and we will go ahead.
>  
> > The restriction implied by lack of NDMA support are pretty significant.
> > Maybe a given device like hns doesn't care because they don't intend to
> > support p2p, but they should care if it means we can't hot-add their
> > device to a VM in the presences of devices that can support p2p and if
> > cold plugging their device into an existing configuration implies loss
> > of functionality or performance elsewhere.
> > 
> > I'd tend to expect though that we'd incorporate NDMA documentation into
> > the uAPI with a formal proposal for discovery and outline a number of
> > those usage implications.  
> 
> Yishai made a patch, but we have put the discussion of NDMA here, not
> hidden in a commit message
>  
> > > > We've tried to define a specification that's more flexible than a
> > > > single implementation and by these standards we seem to be flipping
> > > > that implementation back into the specification.    
> > > 
> > > What specification!?! All we have is a couple lines in a header file
> > > that is no where near detailed enough for multi-driver
> > > interoperability with userspace. You have no idea how much effort has
> > > been expended to get this far based on the few breadcrumbs that were
> > > left, and we have access to the team that made the only other
> > > implementation!
> > > 
> > > *flexible* is not a specification.  
> > 
> > There are approximately 220 lines of the uAPI header file dealing
> > specifically with the migration region.  A bit more than a couple.  
> 
> Unfortunately more than half of that describes how the data window
> works, and half of the rest is kind of obvious statements.

How does that rationalize forking implementation details to userspace
Documentation/ rather than resolving the issues you see with the uAPI
description?

> > We've tried to define it by looking at the device requirements to
> > support migration rather than tailor it specifically to the current QEMU
> > implementation of migration.  Attempting to undo that generality by
> > suggesting only current usage patterns are relevant is therefore going
> > to generate friction.  
> 
> In your mind you see generality, in our mind we want to know how to
> write an inter operable driver and there is no documention saying how
> to do that.

I didn't know there was a hive mind over there, maybe that explains
your quick replies ;)

There's a fine line between writing an inter-operable driver and
writing a driver for the current QEMU implementation.  Obviously we want
to support the current QEMU implementation, but we want an interface
that can accommodate how that implementation might evolve.  Once we
start telling driver authors to expect specific flows rather than
looking at the operation of each bit, then our implementations become
more fragile, less versatile relative to the user.

> > > > Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
> > > > so a driver needs to be prepared for such an attempted state change
> > > > either way.  So what's the advantage to telling a driver author that
> > > > they can expect a given behavior?    
> > > 
> > > The above didn't tell a driver author to expect a certain behavior, it
> > > tells userspace what to do.  
> > 
> >   "The migration driver can rely on user-space issuing a
> >    VFIO_DEVICE_RESET prior to starting RESUMING."  
> 
> I trimmed too much, the original text you quoted was
> 
> "To abort a RESUMING issue a VFIO_DEVICE_RESET."
> 
> Which I still think is fine.

If we're writing a specification, that's really a MAY statement,
userspace MAY issue a reset to abort the RESUMING process and return
the device to RUNNING.  They MAY also write the device_state directly,
which MAY return an error depending on various factors such as whether
data has been written to the migration state and whether that data is
complete.  If a failed transitions results in an ERROR device_state,
the user MUST issue a reset in order to return it to a RUNNING state
without closing the interface.

A recommendation to use reset to skip over potential error conditions
when the goal is simply a new, clean RUNNING state irrespective of data
written to the migration region, is fine.  But drivers shouldn't be
written with only that expectation, just like they shouldn't expect a
reset precondition to entering RESUMING.
 
> > Tracing that shows a reset preceding entering RESUMING doesn't suggest
> > to me that QEMU is performing a reset for the specific purpose of
> > entering RESUMING.  Correlation != causation.  
> 
> Kernel doesn't care why qemu did it - it was done. Intent doesn't
> matter :)

This is exactly the sort of "designed for QEMU implementation"
inter-operability that I want to avoid.  It doesn't take much of a
crystal ball to guess that gratuitous and redundant device resets slow
VM instantiation and are a likely target for optimization.

> > The order I see in the v5 mlx5 post is:
> > 
> > if RUNNING 1->0
> >   quiesce + freeze
> > if RUNNING or SAVING change && state == !RUNNING | SAVING
> >   save device state
> > if RESUMING 0->1
> >   reset device state
> > if RESUMING 1->0
> >   load device state
> > if RUNNING 0->1
> >   unfreeze + unquiesce  
> 
> Right, which matches the text:
> 
>  - !RUNNING
>  - SAVING | !RUNNING
>  - RESUMING
>  - !RESUMING
>  - RUNNING
>  
> > So maybe part of my confusion stems from the fact that the mlx5 driver
> > doesn't support pre-copy, which by the provided list is the highest
> > priority.    
> 
> Right.
> 
> > But what actually makes that the highest priority?  Any
> > combination of SAVING and RESUMING is invalid, so we can eliminate
> > those.  We obviously can't have RUNNING and !RUNNING, so we can
> > eliminate all cases of !RUNNING, so we can shorten the list relativeto
> > prioritizing SAVING|RUNNING to:  
> 
> There are several orders that can make sense. What we've found is
> following the reference flow order has given something workable for
> precedence.

I think though that your reference flow priority depends a lot on your
implementation that resuming state is stored somewhere and only
processed on the transition of the RESUMING bit.  You're sharing a
buffer between SAVING and RESUMING.  That's implementation, not
specification.  A device may choose to validate and incorporate data
written to the migration region as it's written.  A device may choose
to expose actual portions of on device memory through the migration
region during either SAVING or RESTORING.  Therefore setting or
clearing of these bits may not have the data dependencies that drive
the priority scheme of mlx5.

So why is this the one true implementation?

> > SAVING | RUNNING would need to be processed after !RESUMING, but
> > maybe before RUNNING itself.  
> 
> It is a good point, it does make more sense after RUNNING as a device
> should be already RUNNING before entering pre-copy. I moved it to
> before !NDMA
> 
> > NDMA only requires that the device cease initiating DMA before the call
> > returns and it only has meaning if RUNNING, so I'm not sure why setting
> > NDMA is given any priority.  I guess maybe we're trying
> > (unnecessarily?) to preempt any DMA that might occur as a result of
> > setting RUNNING (so why is it above cases including !RUNNING?)?  
> 
> Everything was given priority so there is no confusing omission. For
> the order, as NDMA has no meaning outside RUNNING, it makes sense you'd
> do a NDMA before making it meaningless / after making it meaningful.
> 
> This is made concrete by mlx5's scheme that always requires quiesce
> (NDMA) to happen before freeze (!RUNNING) and viceversa, so we get to
> this order. mlx5 implicitly does NDMA on !RUNNING 
> 
> > Obviously presenting a priority scheme without a discussion of the
> > associativity of the states and a barely sketched out nomenclature is
> > really not inviting an actual understanding how this is reasoned (imo).  
> 
> Sure, but how we got here isn't really important to the intent of the
> document to guide implementors.
> 
> Well, you wrote a lot, and found a correction, but I haven't been left
> with a way to write this more clearly? Now that you obviously
> understand what it is saying, what do you think?

I think implementation and clarification of the actual definition of
the uAPI should exist in the uAPI header, userspace clarification and
examples for the consumption of the uAPI should stay here in
Documentation/, and we should not assume either the QEMU or mlx5
implementations as the canonical reference for either.

> > I'm feeling like there's a bit of a chicken and egg problem here to
> > decide if this is sufficiently clear documentation before a new posting
> > of the mlx5 driver where the mlx5 driver is the authoritative source
> > for the reasoning of the priority scheme documented here (and doesn't
> > make use of pre-copy).  
> 
> I wouldn't fixate on the ordering, it is a small part of the
> document..
> 
> > The migration data stream is entirely opaque to userspace, so what's
> > the benefit to userspace to suggest anything about the content in each
> > phase?  This is presented in a userspace edge concerns section, but the
> > description is much more relevant to a driver author.  
> 
> It is informative for the device driver author to understand what
> device functionality to map to this.

Sounds like we're in agreement, so why does this belong in userspace
Documentation/?

> > > > I think the fact that a user is not required to run the pre-copy
> > > > phase until completion is also noteworthy.    
> > > 
> > > This text doesn't try to detail how the migration window works, that
> > > is a different large task. The intention is that the migration window
> > > must be fully drained to be successful.  
> > 
> > Clarification, the *!RUNNING* migration window must be fully drained.
> >   
> > > I added this for some clarity ""The entire migration data, up to each
> > > end of stream must be transported from the saving to resuming side.""  
> > 
> > Per the uAPI regarding pre-copy:
> > 
> >   "The user must not be required to consume all migration data before
> >   the device transitions to a new state, including the stop-and-copy
> >   state."
> > 
> > If "end of stream" suggests the driver defined end of the data stream
> > for pre-copy rather than simply the end of the user accumulated data
> > stream, that conflicts with the uAPI.  Thanks,  
> 
> Hmm, yes. I can try to clarify how this all works better. We don't
> implement pre-copy but it should still be described better than it has
> been.
> 
> I'm still not sure how this works. 
> 
> We are in SAVING|RUNNING and we dump all the dirty data and return end
> of stream.
> 
> We stay in SAVING|RUNNING and some more device state became dirty. How
> does userspace know? Should it poll and see if the stream got longer?

The uAPI might need some clarification here, but the only viable
scenario would seem to be that yes, userspace should continue to poll
the device so long as it remains in SAVING|RUNNING as internal state
can continue to change asynchronously from userspace polling.  It's
only when pending_bytes returns zero while !RUNNING that the data
stream is complete and the device is precluded from deciding any new
state is available.  Thanks,

Alex

