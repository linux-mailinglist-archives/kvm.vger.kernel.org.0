Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC64A473753
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhLMWQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:16:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235327AbhLMWQi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 17:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639433798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mPQpNeqcZ83eIiiua1etHsxbGoZK3PI7rklCcuhwsg=;
        b=iLtjv5YTuLUu14sFiyVrQVsox8qWY1BJjeWGGD3ZTfzgzl3lcaN7LDThBmadQx9O2YLyWR
        WEPpiluKb4Vpc1Z8Ar7xq+Lsal2ESZBD7z43yt9r2baUeSag2p/RrZN9FQK5tJaVNItXCh
        Y9seFsq4123DXVkHBqw1JoYrejv46RU=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-sujHEa-yP8OqTg7MFrkwrw-1; Mon, 13 Dec 2021 17:16:36 -0500
X-MC-Unique: sujHEa-yP8OqTg7MFrkwrw-1
Received: by mail-ot1-f69.google.com with SMTP id p7-20020a9d7447000000b0057a4ef67426so6926263otk.23
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:16:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5mPQpNeqcZ83eIiiua1etHsxbGoZK3PI7rklCcuhwsg=;
        b=bzl8p43JoRnPkCWb3DQSgZg/s4xPAxeDgIec/xfk3YN+zKak9CvF9s7gZi6OjYqcRh
         Ve9roae48kvR87Knaz8ELmFXfFUxy4z0A1fOgDTeHSmmBkD6xtilq7KD0EgZl5nfPdAH
         sHZOzmwayEdgRzD8M9Veef0RAqusWH0o+YIprDvQfG/xP12m3wftCbkM+cR+MZcGGVym
         wv73otA24Zyo7Hg2qbpRxrxrQQ3TbA+HvDCE1SDHrdyEd3bMH7wndzj8G1cGAN4gey7V
         oydCFPZiawF5ebgcdVA89elagXtyhTE8Ll87qWv6dY9t7kN9oO8Fjs6KqTncmNfiTMdq
         MkNw==
X-Gm-Message-State: AOAM533eth6cYBWOHJWZeEJfIqBOamQTZo4upLHnbqGK/gsowIYr5yzS
        5MPHAFITwk1gEkIgePWMh5nFq+OJ5c7yeWvNLM4wPNz0IWuo+BxdWX+qSBX9JoSStt9RupSFXY4
        mMRFEYQPMVQ5b
X-Received: by 2002:a05:6830:1d87:: with SMTP id y7mr1057569oti.269.1639433796082;
        Mon, 13 Dec 2021 14:16:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxk2Ir+89A4vzh7l05D/iGE0gZl/NBKcKhwiGxPjLxRs4R6P/sUoKSrj6i+UkYp9HL+RpStDQ==
X-Received: by 2002:a05:6830:1d87:: with SMTP id y7mr1057552oti.269.1639433795813;
        Mon, 13 Dec 2021 14:16:35 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m23sm2391339otj.39.2021.12.13.14.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:16:35 -0800 (PST)
Date:   Mon, 13 Dec 2021 15:16:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] vfio: Documentation for the migration region
Message-ID: <20211213151634.24bd80bb.alex.williamson@redhat.com>
In-Reply-To: <20211210004659.GB6385@nvidia.com>
References: <0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com>
        <20211209163457.3e74ebaf.alex.williamson@redhat.com>
        <20211210004659.GB6385@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Dec 2021 20:46:59 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Dec 09, 2021 at 04:34:57PM -0700, Alex Williamson wrote:
> > On Tue,  7 Dec 2021 13:13:00 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > Provide some more complete documentation for the migration regions
> > > behavior, specifically focusing on the device_state bits and the whole
> > > system view from a VMM.
> > > 
> > > To: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > > Cc: Yishai Hadas <yishaih@nvidia.com>
> > > Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  Documentation/driver-api/vfio.rst | 301 +++++++++++++++++++++++++++++-
> > >  1 file changed, 300 insertions(+), 1 deletion(-)  
> > 
> > I'm sending a rewrite of the uAPI separately.  I hope this brings it
> > more in line with what you consider to be a viable specification and
> > perhaps makes some of the below new documentation unnecessary.  
> 
> It is far better than what was there before, and sufficiently terse it
> is OK in a header file. Really, it is quite a great job what you've
> got there.
> 
> Honestly, I don't think I can write something at quite that level, if
> that is your expectation of what we need to achieve here..
> 
> > > +-------------------------------------------------------------------------------
> > > +
> > > +VFIO migration driver API
> > > +-------------------------------------------------------------------------------
> > > +
> > > +VFIO drivers that support migration implement a migration control register
> > > +called device_state in the struct vfio_device_migration_info which is in its
> > > +VFIO_REGION_TYPE_MIGRATION region.
> > > +
> > > +The device_state controls both device action and continuous behavior.
> > > +Setting/clearing bit groups triggers device action, and each bit controls a
> > > +continuous device behavior.  
> > 
> > This notion of device actions and continuous behavior seems to make
> > such a simple concept incredibly complicated.  We have "is the device
> > running or not" and a new modifier bit to that, and which mode is the
> > migration region, off, saving, or resuming.  Seems simple enough, but I
> > can't follow your bit groups below.  
> 
> It is an effort to bridge from the very simple view you wrote to a
> fuller understanding what the driver should be implementing.
> 
> We must talk about SAVING|RUNING / SAVING|!RUNNING together to be able
> to explain everything that is going on.
> 
> But we probably don't want the introductory paragraphs at all. Lets
> just refer to the header file and explain the following discussion
> elaborates on that.
> 
> > > +Along with the device_state the migration driver provides a data window which
> > > +allows streaming migration data into or out of the device. The entire
> > > +migration data, up to the end of stream must be transported from the saving to
> > > +resuming side.
> > > +
> > > +A lot of flexibility is provided to user-space in how it operates these
> > > +bits. What follows is a reference flow for saving device state in a live
> > > +migration, with all features, and an illustration how other external non-VFIO
> > > +entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
> > > +
> > > +  RUNNING, VCPU_RUNNING
> > > +     Normal operating state
> > > +  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> > > +     Log DMAs
> > > +
> > > +     Stream all memory
> > > +  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> > > +     Log internal device changes (pre-copy)
> > > +
> > > +     Stream device state through the migration window
> > > +
> > > +     While in this state repeat as desired:
> > > +
> > > +	Atomic Read and Clear DMA Dirty log
> > > +
> > > +	Stream dirty memory
> > > +  SAVING | NDMA | RUNNING, VCPU_RUNNING
> > > +     vIOMMU grace state
> > > +
> > > +     Complete all in progress IO page faults, idle the vIOMMU
> > > +  SAVING | NDMA | RUNNING
> > > +     Peer to Peer DMA grace state
> > > +
> > > +     Final snapshot of DMA dirty log (atomic not required)
> > > +  SAVING
> > > +     Stream final device state through the migration window
> > > +
> > > +     Copy final dirty data  
> > 
> > So yes, let's move use of migration region in support of a VMM here,
> > but as I mentioned in the last round, these notes per state are all
> > over the map and some of them barely provide enough of a clue to know
> > what you're getting at.  Let's start simple and build.  
> 
> I'm not sure what you are suggesting?

I'm suggesting that we need to start with the basic device level view
of migration, ie. the device starts RUNNING, the VMM may optionally
have a pre-copy stage where the device is both RUNNING and SAVING where
the value of this state relative to both the device and VMM are briefly
discussed, the mandatory stop-and-copy phase, and the interaction of
data streams collected during those phases to a device in the RESUMING
state.

The next section might fold in how device dirtied pages fit into the
picture.

Another section would fit the idea of DMA grace periods to support
devices engaging in p2p.

I don't expect this to be an entirely self supporting document, the
reader should have some idea how migration of a VMM works, but at the
same time we can't just write a phrase with insufficient context and
expect that if someone reads it enough times they'll figure it out.

> Combined with the new header file this is much better, it tersely
> explains from a VMM point of view what each state is about
> 
> Do you think this section should be longer and the section below much
> shorter? That might be a better document.

My proposed uAPI update removes the mapping of device_state to VMM
migration terminology, so I'd like to see that moved here.  Your
discussion about externally controlled states relative to !RUNNING and
what userspace is allowed to touch without risking interfering with the
migration data stream, as well as the edge cases discussion are all
things that I would think this document update would focus on.

> > > +  0
> > > +     Device is halted  
> > 
> > We don't care what the device state goes to after we're done collecting
> > data from it.  
> 
> The reference flow is just a reference, choosing to go to 0 is fine,
> right?

It's fine that a user can do this, my question is more whether it's
relevant to the flow and if a migration driver author might read
"reference" in ways other than "example" and code their support to
expect such a terminating transition.
 
> > > +and the reference flow for resuming:
> > > +
> > > +  RUNNING
> > > +     Use ioctl(VFIO_GROUP_GET_DEVICE_FD) to obtain a fresh device
> > > +  RESUMING
> > > +     Push in migration data.
> > > +  NDMA | RUNNING
> > > +     Peer to Peer DMA grace state
> > > +  RUNNING, VCPU_RUNNING
> > > +     Normal operating state
> > > +
> > > +If the VMM has multiple VFIO devices undergoing migration then the grace
> > > +states act as cross device synchronization points. The VMM must bring all
> > > +devices to the grace state before advancing past it.  
> > 
> > Why?  (rhetorical)  Describe that we can't stop all device atomically
> > therefore we need to running-but-not-initiating state to quiesce the
> > system to finish up saving and the same because we can't atomically
> > release all devices on the restoring end.  
> 
> OK
> 
> > > +Event triggered actions happen when user-space requests a new device_state
> > > +that differs from the current device_state. Actions happen on a bit group
> > > +basis:
> > > +
> > > + SAVING  
> > 
> > Does this mean the entire new device_state is (SAVING) or does this
> > mean that we set the SAVING bit independent of all other bits.  
> 
> It says "actions happen on a bit group basis", so independent of all
> other bits as you say
> 
> But perhaps we don't need this at all anymore as the header file is
> sufficent enough

That would be ideal, otherwise we need to be really careful about
alignment with the header.  I really want the header to be the source
of truth and this document to supplement that with typical usage flows,
considerations how to handle multiple devices, clarifying what !RUNNING
means to the device internal state and resilience to generating host
fault, user access to devices while !RUNNING, etc.
 
> > > +   The device clears the data window and prepares to stream migration data.
> > > +   The entire data from the start of SAVING to the end of stream is transfered
> > > +   to the other side to execute a resume.  
> > 
> > "Clearing the data window" is an implementation, each iteration of the
> > migration protocol provides "something" in the data window.  The
> > migration driver could take no action when SAVING is set and simply
> > evaluate what the current device state is when pending_bytes is read.  
> 
> It is the same as what you said: "initializes the migration region
> data window" 

The connotation is different for me.  If I'm clearing the data window,
I infer that there's something backing the data window that can be
cleared.  The data window might just be a mapping of the internal
device registers.  Clearing those would probably not be a good idea.
OTOH, initializing the data window only suggests to me that the driver
does what is necessary to make the data window usable in this mode for
their implementation.

> > > + SAVING | RUNNING  
> > 
> > If we're trying to model typical usage scenarios, it's confusing that
> > we started with SAVING and jumped back to (SAVING | RUNNING).  
> 
> This section isn't about usage scenarios this is talking about what
> the driver must do in all the state combinations. SAVING is
> "initializing the data window"
> 
> And then the two variations of RUNNING have their own special behaviors.
> 
> > > +   This allows the device to implement a dirty log for its internal state.
> > > +   During this state the data window should present the device state being
> > > +   logged and during SAVING | !RUNNING the data window should transfer the
> > > +   dirtied state and conclude the migration data.  
> > 
> > As we discussed in the previous revision, invariant data could also
> > reasonably be included here.  We're again sort of pushing an
> > implementation agenda, but the more useful thing to include here would
> > be to say something about how drivers and devices should attempt to
> > support any bulk data in this pre-copy phase in order to allow
> > userspace to perform a migration with minimal actual time in the next
> > state.  
> 
> Invarient data is implicitly already "device state being logged" - the
> log is always 'no change'

That's subtle.  In any case, I was confused last time, I'm still
confused.  I'd suggest this falls into the category that we describe
how SAVING | RUNNING vs SAVING is consumed by userspace and possible
strategies for both invariant and state that supports dirty logging and
let the migration driver figure out an optimal implementation.
 
> > > +   The state is only concerned with internal device state. External DMAs are
> > > +   covered by the separate DIRTY_TRACKING function.
> > > +
> > > + SAVING | !RUNNING  
> > 
> > And this means we set SAVING and cleared RUNNING, and only those bits
> > or independent of other bits?  Give your reader a chance to follow
> > along even if you do expect them to read it a few times for it all to
> > sink in.  
> 
> None of this is about set or cleared, where did you get that? The top
> paragph said: "requests a new device_state" - that means only the new
> device_state value matters, the change to get there is irrelevant.

All I can say is that I read it many times and was still not clear how
to process it.  My intention Thursday was to try to contribute some
rewrites to this as well, but I didn't understand it well enough for
that.
 
> > > +   If the migration data is invalid then the ERROR state must be set.  
> > 
> > I don't know why we're specifying this, it's at the driver discretion
> > to use the ERROR state, but we tend to suggest it for irrecoverable
> > errors.  Maybe any such error here could be considered irrecoverable,
> > or maybe the last data segment was missing and once it's added we can
> > continue.  
> 
> This was an explicit statement that seems to contridict what you wrote
> in the header. I prefer we are deterministic, if the RESUME fails then
> go to ERROR, always. Devices do not have the choice to do something
> else.

The determinism is that if clearing RESUMING fails, the user gets an
errno.  But defining that if that transition fails then the device must
enter the ERROR state removes any opportunity that the failure could be
transient or recoverable.  For what?  It also makes this state
transition failure different than other state transitions and makes
the ERROR state a required state for the device, whereas it's really
meant as a catch-all, internal error recovery path.
 
> > > + ERROR
> > > +   The behavior of the device is largely undefined. The device must be
> > > +   recovered by issuing VFIO_DEVICE_RESET or closing the device file
> > > +   descriptor.
> > > +
> > > +   However, devices supporting NDMA must behave as though NDMA is asserted
> > > +   during ERROR to avoid corrupting other devices or a VM during a failed
> > > +   migration.  
> > 
> > As clarified in the uAPI, we chose the invalid state that we did as the
> > error state specifically because of the !RUNNING value.  Migration
> > drivers should honor that, therefore NDMA in ERROR state is irrelevant.  
> 
> This is another explict statement that you have contridicted in the
> header. I'm not sure mlx5 can implement this. Certainly, it becomes
> very hard if we continue to support precedence.
> 
> Unwinding an error during a multi-bit sequence and guaranteeing that
> we can somehow make it back to !RUNNING is far very complex. Several
> error scenarios mean the driver has lost control of the device.
> 
> I'm not even sure we can do the !NDMA I wrote, in hindsight I don't
> think we checked that enough. Yishai noticed all the error unwinding
> was broken in mlx5 for precedence cases after I wrote this.

I think I phrased it along the lines that the driver should make every
effort to make sure the device is equivalently !RUNNING in the ERROR
state, including device resets.  So there's room should that not be
possible, but I'd expect such a state to be the goal.  We require
device supporting migration to support the RESET ioctl, so the worst
case of unwinding state changes should be to internally reset the
device and report ERROR state.  If the device is still wedged/lost
beyond that, the RESET ioctl from the user should also errno.  At that
point the device remains in ERROR state and cannot be used.

I have concerns if that's not a model mlx5 can support.
 
> > > +  NDMA is made optional to support simple HW implementations that either just
> > > +  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
> > > +  necessary for special features like P2P and PRI, so devices can omit it in
> > > +  exchange for limitations on the guest.  
> > 
> > Maybe we can emphasize this a little more as it's potentially pretty
> > significant.  Developers should not just think of their own device in
> > isolation, but their device in the context of devices that may have
> > performance, if not functional, restrictions with those limitations.  
> 
> Ok
> 
> > > +
> > > +- Devices that have their HW migration control MMIO registers inside the same
> > > +  iommu_group as the VFIO device have some special considerations. In this
> > > +  case a driver will be operating HW registers from kernel space that are also
> > > +  subjected to userspace controlled DMA due to the iommu_group.
> > > +
> > > +  This immediately raises a security concern as user-space can use Peer to
> > > +  Peer DMA to manipulate these migration control registers concurrently with
> > > +  any kernel actions.
> > > +
> > > +  A device driver operating such a device must ensure that kernel integrity
> > > +  cannot be broken by hostile user space operating the migration MMIO
> > > +  registers via peer to peer, at any point in the sequence. Further the kernel
> > > +  cannot use DMA to transfer any migration data.
> > > +
> > > +  However, as discussed above in the "Device Peer to Peer DMA" section, it can
> > > +  assume quiet MMIO as a condition to have a successful and uncorrupted
> > > +  migration.
> > > +
> > > +To elaborate details on the reference flows, they assume the following details
> > > +about the external behaviors:
> > > +
> > > + !VCPU_RUNNING
> > > +   User-space must not generate dirty pages or issue MMIO, PIO or equivalent
> > > +   operations to devices.  For a VMM this would typically be controlled by
> > > +   KVM.
> > > +
> > > + DIRTY_TRACKING
> > > +   Clear the DMA log and start DMA logging
> > > +
> > > +   DMA logs should be readable with an "atomic test and clear" to allow
> > > +   continuous non-disruptive sampling of the log.
> > > +
> > > +   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
> > > +   fd.
> > > +
> > > + !DIRTY_TRACKING
> > > +   Freeze the DMA log, stop tracking and allow user-space to read it.
> > > +
> > > +   If user-space is going to have any use of the dirty log it must ensure that
> > > +   all DMA is suspended before clearing DIRTY_TRACKING, for instance by using
> > > +   NDMA or !RUNNING on all VFIO devices.  
> > 
> > Minimally there should be reference markers to direct to these
> > definitions before they were thrown at the reader in the beginning, but
> > better yet would be to adjust the flow to make them unnecessary.  
> 
> The first draft was orderd like this, Connie felt that was confusing,
> so it was moved to the end :)

I only read the comments on the first draft since I was on PTO and v2
was out when I returned.
 
> > > +TDB - discoverable feature flag for NDMA  
> > 
> > Updated in the uAPI spec.  Thanks,  
> 
> It matches what Yishai did

Cool.  Thanks,

Alex

