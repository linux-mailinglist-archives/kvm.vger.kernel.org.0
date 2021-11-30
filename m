Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D973046415A
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 23:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbhK3WjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 17:39:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232707AbhK3WjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 17:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638311747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aehA/LyWSA8yjoOnZsODq8zQuC97nuUVPDCPz8dLdpg=;
        b=hf84C/wzfKvl6ShJoOkFH3xpAGPnDPgSWDvu4HXabVTiufllMeZaZiEZANxlkUalVyo8Wn
        vCmKY51EvEgx2wlS5xGpNzVbhzCrSJFfOfbMpZTAQQxYTrzr991aTQgiQkcMqQJl8JUrUO
        IYu2HnRF2kD3BHCPUyjJMFAq3HxRr+s=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-291-yp2uRZU9MKWGSCuodVvM0w-1; Tue, 30 Nov 2021 17:35:46 -0500
X-MC-Unique: yp2uRZU9MKWGSCuodVvM0w-1
Received: by mail-oo1-f70.google.com with SMTP id i27-20020a4a929b000000b002c672a291dfso11358617ooh.23
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 14:35:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aehA/LyWSA8yjoOnZsODq8zQuC97nuUVPDCPz8dLdpg=;
        b=dBjfs6C+l8wbOmTZCPIFK0GiW/IuecGUmJrhMl8PX1/4YensnD5RH3Jle4nqqhKyrd
         mgC1OluWNpwv9LyF2l3ZVdHyso9aW7ZtliZlWcxWwohqMhVxW7geSrcr86Rrn8+j0tcn
         jPoDRbg0J+xNvYTcFE1M4SLWm7bimcxKrIU4zuwzI+RNQdv6bX6yI1Vp4E3vyU/iko66
         w7QeduzOsB7xdwZONJWvNpbe+DxKsgj9ef+pKg4IJXRsO6EiwnwF4HKtenX0s4J2zG17
         KD2NcsuxfuLdXTxNc4tSMtKfcS+hCbWdIlsSlLpgMT0gFTXFS7xqr2EM1nJ53Tsrrmzz
         QDbw==
X-Gm-Message-State: AOAM531SRrdrIKd5bg3/7T0AWND5BI/qRGXgvsPKzvb5O4xmULvP0fXO
        ym4bk04QxP+J2vwyVFrtQ9qV9k5AYkfAnY/+5EFUOTnGrzxltlXpUY7S56i/3EMbMCuXGvdRDtn
        8htyWthJzd3bt
X-Received: by 2002:a9d:20a1:: with SMTP id x30mr2039794ota.44.1638311744814;
        Tue, 30 Nov 2021 14:35:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUA40o4VxHQgEcKf6j7upM+X29sYaRycFjGleV4PlyLhGyA0XVNon2/IwIESM2PW/fI5latQ==
X-Received: by 2002:a9d:20a1:: with SMTP id x30mr2039754ota.44.1638311744412;
        Tue, 30 Nov 2021 14:35:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n23sm3977198oic.26.2021.11.30.14.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 14:35:43 -0800 (PST)
Date:   Tue, 30 Nov 2021 15:35:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211130153541.131c9729.alex.williamson@redhat.com>
In-Reply-To: <20211130185910.GD4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
        <20211130102611.71394253.alex.williamson@redhat.com>
        <20211130185910.GD4670@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Nov 2021 14:59:10 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 30, 2021 at 10:26:11AM -0700, Alex Williamson wrote:
> > On Mon, 29 Nov 2021 10:45:52 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > Provide some more complete documentation for the migration regions
> > > behavior, specifically focusing on the device_state bits and the whole
> > > system view from a VMM.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  Documentation/driver-api/vfio.rst | 277 +++++++++++++++++++++++++++++-
> > >  1 file changed, 276 insertions(+), 1 deletion(-)
> > > 
> > > Alex/Cornelia, here is the second draft of the requested documentation I promised
> > > 
> > > We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
> > > 
> > > Our thinking is that NDMA would be implemented like this:
> > > 
> > >    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
> > > 
> > > And a .add_capability ops will be used to signal to userspace driver support:
> > > 
> > >    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6  
> > 
> > So based on this and the discussion later in the doc, NDMA is an
> > optional device feature, is this specifically to support HNS?   
> 
> Yes. It is not trivial to implement NDMA in a device, we already have
> HNS as a public existing example that cannot do it, so it is a
> permanent optional feature.
> 
> > IIRC, this is a simple queue based device, but is it the fact that
> > the queue lives in non-device memory that makes it such that the
> > driver cannot mediate queue entries and simply add them to the to
> > migration stream?  
> 
> From what HNS said the device driver would have to trap every MMIO to
> implement NDMA as it must prevent touches to the physical HW MMIO to
> maintain the NDMA state.
> 
> The issue is that the HW migration registers can stop processing the
> queue and thus enter NDMA but a MMIO touch can resume queue
> processing, so NDMA cannot be sustained.
> 
> Trapping every MMIO would have a huge negative performance impact.  So
> it doesn't make sense to do so for a device that is not intended to be
> used in any situation where NDMA is required.

But migration is a cooperative activity with userspace.  If necessary
we can impose a requirement that mmap access to regions (other than the
migration region itself) are dropped when we're in the NDMA or !RUNNING
device_state.  We can define additional sparse mmap capabilities for
regions for various device states if we need more fine grained control.
There's no reason that mediation while in the NDMA state needs to
impose any performance penalty against the default RUNNING state.  In
fact, it seems rather the migration driver's job to provide such
mediation.

> > Some discussion of this requirement would be useful in the doc,
> > otherwise it seems easier to deprecate the v1 migration region
> > sub-type, and increment to a v2 where NDMA is a required feature.  
> 
> I can add some words a the bottom, but since NDMA is a completely
> transparent optional feature I don't see any reason to have v2.

It's hardly transparent, aiui userspace is going to need to impose a
variety of loosely defined restrictions for devices without NDMA
support.  It would be far easier if we could declare NDMA support to be
a requirement.

> > There are so many implicit concepts here, I'm not sure I'm making a
> > correct interpretation, let alone someone coming to this document for
> > understanding.  
> 
> That isn't really helpful feedback..
> 
> The above is something like a summary to give context to the below
> which provides a lot of detail to each step.
> 
> If you read the above/below together and find stuff is lacking, then
> please point to it and let's add it

As I think Connie also had trouble with, combining device_state with
IOMMU migration features and VMM state, without any preceding context
and visual cues makes the section confusing.  I did gain context as I
read further though the doc, but I also had the advantage of being
rather familiar with the topic.  Maybe a table format would help to
segment the responsibilities?

> > > +If the VMM has multiple VFIO devices undergoing migration then the grace
> > > +states act as cross device synchronization points. The VMM must bring all
> > > +devices to the grace state before advancing past it.
> > > +
> > > +The above reference flows are built around specific requirements on the
> > > +migration driver for its implementation of the migration_state input.  
> > 
> > I can't glean any meaning from this sentence.  "device_state" here and
> > throughout?  We don't have a "migration_state".  
> 
> Yes, migration_state is a spello for device_state, I'll fix them all
> 
> > > + !RESUMING
> > > +   All the data transferred into the data window is loaded into the device's
> > > +   internal state. The migration driver can rely on user-space issuing a
> > > +   VFIO_DEVICE_RESET prior to starting RESUMING.  
> > 
> > We can't really rely on userspace to do anything, nor has this sequence
> > been part of the specified protocol.  
> 
> It is exsisting behavior of qemu - which is why we documented it.

QEMU resets devices as part of initializing the VM, but I don't see
that QEMU specifically resets a device in order to transition it to
the RESUMING device_state. 

> Either qemu shouldn't do it as devices must fully self-reset, or we
> should have it part of the canonical flow and devices may as well
> expect it. It is useful because post VFIO_DEVICE_RESET all DMA is
> quiet, no outstanding PRIs exist, etc etc.

It's valid for QEMU to reset the device any time it wants, saying that
it cannot perform a reset before transitioning to the RESUMING state is
absurd.  Userspace can do redundant things for their own convenience.

We don't currently specify any precondition for a device to enter the
RESUMING state.  The driver can of course nak the state change with an
errno, or hard nak it with an errno and ERROR device_state, which would
require userspace to make use of VFIO_DEVICE_RESET.  I think I would
also consider if valid if the driver internally performed a reset on a
RUNNING -> RESUMING state change, but we've never previously expressed
any linkage of a userspace requirement to reset the device here. 

> > As with the previous flows, it seems like there's a ton of implicit
> > knowledge here.  Why are we documenting these here rather than in the
> > uAPI header?  
> 
> Because this is 300 lines already and is too complicated/long to
> properly live in a uapi header.

Minimally we need to resolve that this document must be consistent with
the uAPI.  I'm not sure that's entirely the case in this draft.

> >  I'm having a difficult time trying to understand what are
> > proposals to modify the uAPI and what are interpretations of the
> > existing protocol.  
> 
> As far as we know this describes what current qemu does in the success
> path with a single VFIO device. ie we think mlx5 conforms to this spec
> and we see it works as-is with qemu, up to qemu's limitations:
> 
>  - qemu has no support for errors or error recovery, it just calls
>    abort()
>  - qemu does not stress the device_state and only does a few
>    transition patterns
>  - qemu doesn't support P2P cases due to the NDMA topic

Or rather QEMU does support p2p cases regardless of the NDMA topic.

>  - simple devices like HNS will work, but not robustly in the face of
>    a hostile VM and multiple VFIO devices.

So what's the goal here, are we trying to make the one currently
implemented and unsupported userspace be the gold standard to which
drivers should base their implementation?  We've tried to define a
specification that's more flexible than a single implementation and by
these standards we seem to be flipping that implementation back into
the specification.

> > > +   To abort a RESUMING issue a VFIO_DEVICE_RESET.  
> >
> > Any use of VFIO_DEVICE_RESET should return the device to the default
> > state, but a user is free to try to use device_state to transition
> > from RESUMING to any other state.    
> 
> Userspace can attempt all transitions, of course. 
> 
> However, notice this spec doesn't specify what happens on non-success
> RESUMING->RUNNING. So, I'm calling that undefined behavior.
> 
> As you say:
> 
> > The driver can choose to fail that transition and even make use of
> > the error device_state, but there's no expectation that a  
> 
> Thus, the above advice. To reliably abort RESUMING use DEVICE_RESET,
> do not use ->RUNNING.

Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
so a driver needs to be prepared for such an attempted state change
either way.  So what's the advantage to telling a driver author that
they can expect a given behavior?

It doesn't make much sense to me to glue two separate userspace
operations together to say these must be done in this sequence, back to
back.  If we want the device to be reset in order to enter RESUMING, the
driver should simply reset the device as necessary during the state
transition.  The outward effect to the user is to specify that device
internal state may not be retained on transition from RUNNING ->
RESUMING.
 
> > > +Continuous actions are in effect when migration_state bit groups are active:
> > > +
> > > + RUNNING | NDMA
> > > +   The device is not allowed to issue new DMA operations.
> > > +
> > > +   Whenever the kernel returns with a migration_state of NDMA there can be no
> > > +   in progress DMAs.
> > > +  
> > 
> > There are certainly event triggered actions based on setting NDMA as
> > well, ex. completion of outstanding DMA.  
> 
> I'm leaving it implied that there is always some work required to
> begin/end these continuous behaviors
> 
> > > + !RUNNING
> > > +   The device should not change its internal state. Further implies the NDMA
> > > +   behavior above.  
> > 
> > Does this also imply other device regions cannot be accessed as has
> > previously been suggested?  Which?  
> 
> This question is discussed/answered below
> 
> > > + - SAVING | RUNNING
> > > + - NDMA
> > > + - !RUNNING
> > > + - SAVING | !RUNNING
> > > + - RESUMING
> > > + - !RESUMING
> > > + - RUNNING
> > > + - !NDMA  
> > 
> > Lots of deduction left to the reader...  
> 
> Do you have an alternative language? This is quite complicated, I
> advise people to refer to mlx5's implementation.

I agree with Connie on this, if the reader of the documentation needs
to look at a specific driver implementation to understand the
reasoning, the documentation has failed.  If it can be worked out by
looking at the device_state write function of the mlx5 driver, then
surely a sentence or two for each priority item can be added here.

Part of the problem is that the nomenclature is unclear, we're listing
bit combinations, but not the changed bit(s) and we need to infer the
state.  The mlx5 driver specifically looks for individual state bit
flips in the presence of an existing state.  I'm not able to obviously
map the listing above to the latest posted version of the mlx5 driver.

> > > +  As Peer to Peer DMA is a MMIO touch like any other, it is important that
> > > +  userspace suspend these accesses before entering any device_state where MMIO
> > > +  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
> > > +  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
> > > +  device does not support NDMA and rely on that to guarantee quiet MMIO.  
> > 
> > Seems that would have its own set of consequences.  
> 
> Sure, userspace has to make choices here.

It seems a bit loaded to suggest an alternative choice if it's not
practical or equivalent.  Maybe it's largely the phrasing, I read
"remove MMIO mappings" as to drop them dynamically, when I think we've
discussed that userspace might actually preclude these mappings for
non-NDMA devices such that p2p DMA cannot exist, ever.

> > > +  Device that do not support NDMA cannot be configured to generate page faults
> > > +  that require the VCPU to complete.  
> > 
> > So the VMM is required to hide features like PRI based on NDMA support?  
> 
> Yep, looks like.
> 
> > > +- pre-copy allows the device to implement a dirty log for its internal state.
> > > +  During the SAVING | RUNNING state the data window should present the device
> > > +  state being logged and during SAVING | !RUNNING the data window should present
> > > +  the unlogged device state as well as the changes from the internal dirty log.  
> > 
> > This is getting a bit close to specifying an implementation.  
> 
> Bit close, but not too close :) I think it is clarifying to
> describe the general working of pre-copy - at least people here raised
> questions about what it is doing.
> 
> Overall it must work in this basic way, and devices have freedom about
> what internal state they can/will log. There is just a clear division
> that every internal state in the first step is either immutable or
> logged, and that the second step is a delta over the first.

I agree that it's a reasonable approach, though as I read the proposed
text, there's no mention of immutable state and no reason a driver
would implement a dirty log for immutable state, therefore we seem to
be suggesting such data for the stop-and-copy phase when it would
actually be preferable to include it in pre-copy.  I think the fact
that a user is not required to run the pre-copy phase until completion
is also noteworthy.

> > > +- Migration control registers inside the same iommu_group as the VFIO device.  
> > 
> > Not a complete sentence, is this meant as a topic header?  
> 
> Sure
>  
> > > +  This immediately raises a security concern as user-space can use Peer to Peer
> > > +  DMA to manipulate these migration control registers concurrently with
> > > +  any kernel actions.
> > > +  
> > 
> > We haven't defined "migration control registers" beyond device_state,
> > which is software defined "register".  What physical registers that are
> > subject to p2p DMA is this actually referring to?  
> 
> Here this is talking about the device's physical HW control registers.
> 
> > > +TDB - discoverable feature flag for NDMA  
> > 
> > Is the goal to release mlx5 support without the NDMA feature and add it
> > later?    
> 
> Yishai has a patch already to add NDMA to mlx5, it will come in the
> next iteration once we can agree on this document. qemu will follow
> sometime later.

So it's not really a TBD, it's resolved in a uAPI update that will be
included with the next revision?  Thanks,

Alex

