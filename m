Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36346F77D
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 00:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhLIXij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 18:38:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhLIXih (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 18:38:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639092903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Re4HGfXPzmQPGh/iU1kXuhdR3fx9vGXzaT75QibZns=;
        b=awFpLRR5UA+Z+Nt8zGTX30bt7dmGsowfqifWrTbxOJt6YAoArrrHK3QbS+o13rAWO+yIf1
        a/5jeFXMEfQH1gaeV69iPJLLuFaKqKro/KJjVWBydkTwS4F9OE4k2L0yen/a8WB5CEnYxC
        fJ4Ed8ONASrLgiM3ePjfoeNgRw8mCE8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-zPRtG5MfPp-o2ahi6SfQUQ-1; Thu, 09 Dec 2021 18:35:02 -0500
X-MC-Unique: zPRtG5MfPp-o2ahi6SfQUQ-1
Received: by mail-oi1-f198.google.com with SMTP id bj40-20020a05680819a800b002bc9d122f13so4931071oib.2
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 15:35:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Re4HGfXPzmQPGh/iU1kXuhdR3fx9vGXzaT75QibZns=;
        b=3vjFALGZBwOqOEYqQgNcmTLVm/OJ6UvGtcx9uhIOgSxxIVQtli5GARIFaZPCfziV69
         B8aeXv1fsV4KeQe0qlxVihayt60rxW4qU03bX6pbVjebC6ECQi2Cagfx3rR+zZ+8/bKo
         ADgY/fs5Dcu9z1F67RNk15jTecV4OD8Y+s/v/Vj8cX/NpA6dV2owGAwhGChBUnJfPIof
         NZQs7SBjhbjnhKl5cRjsrEafp5rkbXprrLbWWO/AoXUXB/y8qmQEVMRyOpimUcowRZj+
         d2qKsraG4sxhqjjQhWtG2EpPh92OCjwXnwrn0HaylZDsjIbBYv5xKufshbJsEiUt2F0h
         uVlg==
X-Gm-Message-State: AOAM531R0u0yeb/weoUDkc30TQcewphpchWhFRVhY2dL+69hJbNIWLVX
        jtbTWYCCF6Dyq0lWxw8NoHPgSDYr+GfSYqSVSTt3iSPL8xe5v+9UafA5wMUsYGeqfNmuQLUs8Rc
        93kqPPWHyuY5q
X-Received: by 2002:a05:6808:228a:: with SMTP id bo10mr9330616oib.72.1639092900935;
        Thu, 09 Dec 2021 15:35:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/IBMIahPBjGAvw/x2wmljA5HZ533jdcZADNVE0NXRoA9fbM4jSSegeiN0DcAwJOsOZpdqjQ==
X-Received: by 2002:a05:6808:228a:: with SMTP id bo10mr9330576oib.72.1639092900460;
        Thu, 09 Dec 2021 15:35:00 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n19sm228330otq.11.2021.12.09.15.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 15:34:59 -0800 (PST)
Date:   Thu, 9 Dec 2021 16:34:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] vfio: Documentation for the migration region
Message-ID: <20211209163457.3e74ebaf.alex.williamson@redhat.com>
In-Reply-To: <0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com>
References: <0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 13:13:00 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Provide some more complete documentation for the migration regions
> behavior, specifically focusing on the device_state bits and the whole
> system view from a VMM.
> 
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst | 301 +++++++++++++++++++++++++++++-
>  1 file changed, 300 insertions(+), 1 deletion(-)

I'm sending a rewrite of the uAPI separately.  I hope this brings it
more in line with what you consider to be a viable specification and
perhaps makes some of the below new documentation unnecessary.  I took
a stab at including the new documentation here in that rewrite, but
frankly there are sections here that I don't know what you're trying to
show.  That makes it really, really hard to give the specific revision
advice you're looking for.

As noted in the changelog for my patch, I've removed the QEMU
terminology and any relation to use by a VMM.  That's the sort of thing
that makes sense to me to move here.

I'll attempt to provide more specifics regarding my stumbling blocks
for this document below...

> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f978255b..2ff47823a889b4 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,306 @@ group and can access them as follows::
>  VFIO User API
>  -------------------------------------------------------------------------------
>  
> -Please see include/linux/vfio.h for complete API documentation.
> +Please see include/uapi/linux/vfio.h for complete API documentation.
> +
> +-------------------------------------------------------------------------------
> +
> +VFIO migration driver API
> +-------------------------------------------------------------------------------
> +
> +VFIO drivers that support migration implement a migration control register
> +called device_state in the struct vfio_device_migration_info which is in its
> +VFIO_REGION_TYPE_MIGRATION region.
> +
> +The device_state controls both device action and continuous behavior.
> +Setting/clearing bit groups triggers device action, and each bit controls a
> +continuous device behavior.

This notion of device actions and continuous behavior seems to make
such a simple concept incredibly complicated.  We have "is the device
running or not" and a new modifier bit to that, and which mode is the
migration region, off, saving, or resuming.  Seems simple enough, but I
can't follow your bit groups below.

> +
> +Along with the device_state the migration driver provides a data window which
> +allows streaming migration data into or out of the device. The entire
> +migration data, up to the end of stream must be transported from the saving to
> +resuming side.
> +
> +A lot of flexibility is provided to user-space in how it operates these
> +bits. What follows is a reference flow for saving device state in a live
> +migration, with all features, and an illustration how other external non-VFIO
> +entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
> +
> +  RUNNING, VCPU_RUNNING
> +     Normal operating state
> +  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> +     Log DMAs
> +
> +     Stream all memory
> +  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
> +     Log internal device changes (pre-copy)
> +
> +     Stream device state through the migration window
> +
> +     While in this state repeat as desired:
> +
> +	Atomic Read and Clear DMA Dirty log
> +
> +	Stream dirty memory
> +  SAVING | NDMA | RUNNING, VCPU_RUNNING
> +     vIOMMU grace state
> +
> +     Complete all in progress IO page faults, idle the vIOMMU
> +  SAVING | NDMA | RUNNING
> +     Peer to Peer DMA grace state
> +
> +     Final snapshot of DMA dirty log (atomic not required)
> +  SAVING
> +     Stream final device state through the migration window
> +
> +     Copy final dirty data

So yes, let's move use of migration region in support of a VMM here,
but as I mentioned in the last round, these notes per state are all
over the map and some of them barely provide enough of a clue to know
what you're getting at.  Let's start simple and build.


> +  0
> +     Device is halted

We don't care what the device state goes to after we're done collecting
data from it.

> +
> +and the reference flow for resuming:
> +
> +  RUNNING
> +     Use ioctl(VFIO_GROUP_GET_DEVICE_FD) to obtain a fresh device
> +  RESUMING
> +     Push in migration data.
> +  NDMA | RUNNING
> +     Peer to Peer DMA grace state
> +  RUNNING, VCPU_RUNNING
> +     Normal operating state
> +
> +If the VMM has multiple VFIO devices undergoing migration then the grace
> +states act as cross device synchronization points. The VMM must bring all
> +devices to the grace state before advancing past it.

Why?  (rhetorical)  Describe that we can't stop all device atomically
therefore we need to running-but-not-initiating state to quiesce the
system to finish up saving and the same because we can't atomically
release all devices on the restoring end.

> +
> +The above reference flows are built around specific requirements on the
> +migration driver for its implementation of the device_state input.

As noted in previous review, the above sentence is just words that
convey no meaning, at least not to me.

> +The device_state cannot change asynchronously, upon writing the
> +device_state the driver will either keep the current state and return
> +failure, return failure and go to ERROR, or succeed and go to the new state.

This is spelled out pretty clearly in the uAPI.

> +Event triggered actions happen when user-space requests a new device_state
> +that differs from the current device_state. Actions happen on a bit group
> +basis:
> +
> + SAVING

Does this mean the entire new device_state is (SAVING) or does this
mean that we set the SAVING bit independent of all other bits.

> +   The device clears the data window and prepares to stream migration data.
> +   The entire data from the start of SAVING to the end of stream is transfered
> +   to the other side to execute a resume.

"Clearing the data window" is an implementation, each iteration of the
migration protocol provides "something" in the data window.  The
migration driver could take no action when SAVING is set and simply
evaluate what the current device state is when pending_bytes is read.

> +
> + SAVING | RUNNING

If we're trying to model typical usage scenarios, it's confusing that
we started with SAVING and jumped back to (SAVING | RUNNING).

> +   The device beings streaming 'pre copy' migration data through the window.
> +
> +   A device that does not support internal state logging should return a 0
> +   length stream.
> +
> +   The migration window may reach an end of stream, this can be a permanent or
> +   temporary condition.
> +
> +   User space can do SAVING | !RUNNING at any time, any in progress transfer
> +   through the migration window is carried forward.

By these "bit groups", does a device get from SAVING | RUNNING to
SAVING | !RUNNING by a !RUNNING action?  I'm clearly still lost in the
terminology.

> +
> +   This allows the device to implement a dirty log for its internal state.
> +   During this state the data window should present the device state being
> +   logged and during SAVING | !RUNNING the data window should transfer the
> +   dirtied state and conclude the migration data.

As we discussed in the previous revision, invariant data could also
reasonably be included here.  We're again sort of pushing an
implementation agenda, but the more useful thing to include here would
be to say something about how drivers and devices should attempt to
support any bulk data in this pre-copy phase in order to allow
userspace to perform a migration with minimal actual time in the next
state.

> +
> +   The state is only concerned with internal device state. External DMAs are
> +   covered by the separate DIRTY_TRACKING function.
> +
> + SAVING | !RUNNING

And this means we set SAVING and cleared RUNNING, and only those bits
or independent of other bits?  Give your reader a chance to follow
along even if you do expect them to read it a few times for it all to
sink in.

> +   The device captures its internal state and streams it through the
> +   migration window.
> +
> +   When the migration window reaches an end of stream the saving is concluded
> +   and there is no further data. All of the migration data streamed from the
> +   time SAVING starts to this final end of stream is concatenated together
> +   and provided to RESUMING.
> +
> +   Devices that cannot log internal state changes stream all their device
> +   state here.
> +
> + RESUMING
> +   The data window is cleared, opened, and can receive the migration data
> +   stream. The device must always be able to enter resuming and it may reset
> +   the device to do so.
> +
> + !RESUMING
> +   All the data transferred into the data window is loaded into the device's
> +   internal state.
> +
> +   The internal state of a device is undefined while in RESUMING. To abort a
> +   RESUMING and return to a known state issue a VFIO_DEVICE_RESET.

I've clarified aspects of this in the uAPI, maybe we don't need to make
this recommendation.

> +
> +   If the migration data is invalid then the ERROR state must be set.

I don't know why we're specifying this, it's at the driver discretion
to use the ERROR state, but we tend to suggest it for irrecoverable
errors.  Maybe any such error here could be considered irrecoverable,
or maybe the last data segment was missing and once it's added we can
continue.

> +
> +Continuous actions are in effect when device_state bit groups are active:
> +
> + RUNNING | NDMA
> +   The device is not allowed to issue new DMA operations.
> +
> +   Whenever the kernel returns with a device_state of NDMA there can be no
> +   in progress DMAs.

"kernel returns with" is rather strange here, the kernel can't
autonomously get to NDMA.

> +
> + !RUNNING
> +   The device should not change its internal state. Further implies the NDMA
> +   behavior above.
> +
> + SAVING | !RUNNING
> +   RESUMING | !RUNNING
> +   The device may assume there are no incoming MMIO operations.
> +
> +   Internal state logging can stop.
> +
> + RUNNING
> +   The device can alter its internal state and must respond to incoming MMIO.
> +
> + SAVING | RUNNING
> +   The device is logging changes to the internal state.

It all rather seems like a hodgepodge of random notes that are hard to
piece together.  Can we collect them better?

> +
> + ERROR
> +   The behavior of the device is largely undefined. The device must be
> +   recovered by issuing VFIO_DEVICE_RESET or closing the device file
> +   descriptor.
> +
> +   However, devices supporting NDMA must behave as though NDMA is asserted
> +   during ERROR to avoid corrupting other devices or a VM during a failed
> +   migration.

As clarified in the uAPI, we chose the invalid state that we did as the
error state specifically because of the !RUNNING value.  Migration
drivers should honor that, therefore NDMA in ERROR state is irrelevant.

> +
> +When multiple bits change in the device_state they may describe multiple event
> +triggered actions, and multiple changes to continuous actions.  The migration
> +driver must process the new device_state bits in a priority order:
> +
> + - NDMA
> + - !RUNNING
> + - SAVING | !RUNNING
> + - RESUMING
> + - !RESUMING
> + - RUNNING
> + - SAVING | RUNNING
> + - !NDMA

I'll hold my comments on this since you proposed another variant later.

> +
> +In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
> +device back to device_state RUNNING. When a migration driver executes this
> +ioctl it should discard the data window and set device_state to RUNNING as
> +part of resetting the device to a clean state. This must happen even if the
> +device_state has errored. A freshly opened device FD should always be in
> +the RUNNING state.

Pretty clear in the uAPI imo.

> +
> +The migration driver has limitations on what device state it can affect. Any
> +device state controlled by general kernel subsystems must not be changed
> +during RESUME, and SAVING must tolerate mutation of this state. Change to
> +externally controlled device state can happen at any time, asynchronously, to
> +the migration (ie interrupt rebalancing).
> +
> +Some examples of externally controlled state:
> + - MSI-X interrupt page
> + - MSI/legacy interrupt configuration
> + - Large parts of the PCI configuration space, ie common control bits
> + - PCI power management
> + - Changes via VFIO_DEVICE_SET_IRQS
> +
> +During !RUNNING, especially during SAVING and RESUMING, the device may have
> +limitations on what it can tolerate. An ideal device will discard/return all
> +ones to all incoming MMIO, PIO, or equivalent operations (exclusive of the
> +external state above) in !RUNNING. However, devices are free to have undefined
> +behavior if they receive incoming operations. This includes
> +corrupting/aborting the migration, dirtying pages, and segfaulting user-space.
> +
> +However, a device may not compromise system integrity if it is subjected to a
> +MMIO. It cannot trigger an error TLP, it cannot trigger an x86 Machine Check
> +or similar, and it cannot compromise device isolation.

Yes, this is the sort of stuff that makes sense to me here.

> +There are several edge cases that user-space should keep in mind when
> +implementing migration:
> +
> +- Device Peer to Peer DMA. In this case devices are able issue DMAs to each
> +  other's MMIO regions. The VMM can permit this if it maps the MMIO memory into
> +  the IOMMU.
> +
> +  As Peer to Peer DMA is a MMIO touch like any other, it is important that
> +  userspace suspend these accesses before entering any device_state where MMIO
> +  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
> +  state. Userspace may also choose to never install MMIO mappings into the
> +  IOMMU if devices do not support NDMA and rely on that to guarantee quiet
> +  MMIO.
> +
> +  The Peer to Peer Grace States exist so that all devices may reach RUNNING
> +  before any device is subjected to a MMIO access.
> +
> +  Failure to guarantee quiet MMIO may allow a hostile VM to use P2P to violate
> +  the no-MMIO restriction during SAVING or RESUMING and corrupt the migration
> +  on devices that cannot protect themselves.

Some of the stuff in the beginning would make a lot more sense
following this description.  This is definitely the type of thing that
belongs in this document.

> +
> +- IOMMU Page faults handled in user-space can occur at any time. A migration
> +  driver is not required to serialize in-progress page faults. It can assume
> +  that all page faults are completed before entering SAVING | !RUNNING. Since
> +  the guest VCPU is required to complete page faults the VMM can accomplish
> +  this by asserting NDMA | VCPU_RUNNING and clearing all pending page faults
> +  before clearing VCPU_RUNNING.
> +
> +  Device that do not support NDMA cannot be configured to generate page faults
> +  that require the VCPU to complete.
> +
> +- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
> +  cannot support this, then NDMA could be used to synthesize it less
> +  efficiently.
> +
> +- NDMA is optional. If the device does not support this then the NDMA States
> +  are pushed down to the next step in the sequence and various behaviors that
> +  rely on NDMA cannot be used.
> +
> +  NDMA is made optional to support simple HW implementations that either just
> +  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
> +  necessary for special features like P2P and PRI, so devices can omit it in
> +  exchange for limitations on the guest.

Maybe we can emphasize this a little more as it's potentially pretty
significant.  Developers should not just think of their own device in
isolation, but their device in the context of devices that may have
performance, if not functional, restrictions with those limitations.

> +
> +- Devices that have their HW migration control MMIO registers inside the same
> +  iommu_group as the VFIO device have some special considerations. In this
> +  case a driver will be operating HW registers from kernel space that are also
> +  subjected to userspace controlled DMA due to the iommu_group.
> +
> +  This immediately raises a security concern as user-space can use Peer to
> +  Peer DMA to manipulate these migration control registers concurrently with
> +  any kernel actions.
> +
> +  A device driver operating such a device must ensure that kernel integrity
> +  cannot be broken by hostile user space operating the migration MMIO
> +  registers via peer to peer, at any point in the sequence. Further the kernel
> +  cannot use DMA to transfer any migration data.
> +
> +  However, as discussed above in the "Device Peer to Peer DMA" section, it can
> +  assume quiet MMIO as a condition to have a successful and uncorrupted
> +  migration.
> +
> +To elaborate details on the reference flows, they assume the following details
> +about the external behaviors:
> +
> + !VCPU_RUNNING
> +   User-space must not generate dirty pages or issue MMIO, PIO or equivalent
> +   operations to devices.  For a VMM this would typically be controlled by
> +   KVM.
> +
> + DIRTY_TRACKING
> +   Clear the DMA log and start DMA logging
> +
> +   DMA logs should be readable with an "atomic test and clear" to allow
> +   continuous non-disruptive sampling of the log.
> +
> +   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
> +   fd.
> +
> + !DIRTY_TRACKING
> +   Freeze the DMA log, stop tracking and allow user-space to read it.
> +
> +   If user-space is going to have any use of the dirty log it must ensure that
> +   all DMA is suspended before clearing DIRTY_TRACKING, for instance by using
> +   NDMA or !RUNNING on all VFIO devices.

Minimally there should be reference markers to direct to these
definitions before they were thrown at the reader in the beginning, but
better yet would be to adjust the flow to make them unnecessary.

> +
> +
> +TDB - discoverable feature flag for NDMA

Updated in the uAPI spec.  Thanks,

Alex

> +TDB IMS xlation
> +TBD PASID xlation
>  
>  VFIO bus driver API
>  -------------------------------------------------------------------------------
> 
> base-commit: ae0351a976d1880cf152de2bc680f1dff14d9049

