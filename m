Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2E6463CB1
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244793AbhK3R3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 12:29:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232874AbhK3R3g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 12:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638293176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3eUnV/iIwt8nPjvkajxyxXPeBi9b5nVinhmKhsdgU8=;
        b=Sk+pDFa51Hm6cT0FzlTRLKZZZZ0DdeCKsDU8n+pgToz8YNnALq7dAmnV7IUnTjMPXPG00Z
        3HQSYUXMG4VGdT7nlvKvPFAv2YjQHqLs9L1vBuvCHUjVuB53Ukl6yJypaRvYAC7iuzHOct
        8exXoTvzNSWyeZ4DSpnoIjMILz5l4Fk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-123-I0GgAw3TOXuI4w9rRd59GQ-1; Tue, 30 Nov 2021 12:26:14 -0500
X-MC-Unique: I0GgAw3TOXuI4w9rRd59GQ-1
Received: by mail-oi1-f198.google.com with SMTP id y20-20020acaaf14000000b002a817a23a1eso14323183oie.23
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 09:26:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3eUnV/iIwt8nPjvkajxyxXPeBi9b5nVinhmKhsdgU8=;
        b=lwoq9uhGGpotFkVGuRfAPd3vF1bhcAHYd2OlXFoYtsHSPBQUkZPGwH9jIkU7nnCsQA
         oyqyGw/F2QKKDkfXvAG0T4JS76xEuDpkZGG1rT3p9KpzOIOQVEvvz2kctZvSzDK4HX5R
         UUNnFp0nuaURYbRtnBv1PYyS0I2Nq0F7tIRLP/GDFz7uasPT2qAOe7f/bjf9fTf51brQ
         b/BWxPTakpL9LZ7WXVqVFPYXumsl4RhAsdwlXmo22WryXJtoTTjxUPWYgnsCcBnu0IMI
         4h1NkiVto7FS7T4XZg+a9AYSCT0bOUXF08v1v1RoUr6O4fybJKyHawhF1/NDXXHmILzt
         lnzg==
X-Gm-Message-State: AOAM532+PuBx9QXAUqbScreceQy+Hs0grBtb7ipUDS8XVHr8RDbs8RLJ
        QDwtrKE/293a+Cuy6YXbiC/OydiziaFOlOq+revA43hcacuKUsGxa+I0fnEduVfUpOf2YTDliD0
        xbFYxMs15V2Cw
X-Received: by 2002:a9d:4a8:: with SMTP id 37mr562996otm.83.1638293173642;
        Tue, 30 Nov 2021 09:26:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNSlmjehN0V7hEL2o9iJf45IYAvQlsJs1gva6X0+YSlAcErNszyIJLvlhHn1ZT7uFPqQOV2Q==
X-Received: by 2002:a9d:4a8:: with SMTP id 37mr562956otm.83.1638293173215;
        Tue, 30 Nov 2021 09:26:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w4sm4079716oiv.37.2021.11.30.09.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:26:12 -0800 (PST)
Date:   Tue, 30 Nov 2021 10:26:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211130102611.71394253.alex.williamson@redhat.com>
In-Reply-To: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Nov 2021 10:45:52 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Provide some more complete documentation for the migration regions
> behavior, specifically focusing on the device_state bits and the whole
> system view from a VMM.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst | 277 +++++++++++++++++++++++++++++-
>  1 file changed, 276 insertions(+), 1 deletion(-)
> 
> Alex/Cornelia, here is the second draft of the requested documentation I promised
> 
> We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
> 
> Our thinking is that NDMA would be implemented like this:
> 
>    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
> 
> And a .add_capability ops will be used to signal to userspace driver support:
> 
>    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6

So based on this and the discussion later in the doc, NDMA is an
optional device feature, is this specifically to support HNS?  IIRC,
this is a simple queue based device, but is it the fact that the queue
lives in non-device memory that makes it such that the driver cannot
mediate queue entries and simply add them to the to migration stream?
Some discussion of this requirement would be useful in the doc,
otherwise it seems easier to deprecate the v1 migration region
sub-type, and increment to a v2 where NDMA is a required feature.

> I've described DIRTY TRACKING as a seperate concept here. With the current
> uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
> change in direction this would be per-tracker control, but no semantic change.
> 
> Upon some agreement we'll include this patch in the next iteration of the mlx5
> driver along with the NDMA bits.
> 
> v2:
>  - RST fixups for sphinx rendering
>  - Inclue the priority order for multi-bit-changes
>  - Add a small discussion on devices like hns with migration control inside
>    the same function as is being migrated.
>  - Language cleanups from v1, the diff says almost every line was touched in some way
> v1: https://lore.kernel.org/r/0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f978255b..d9be47570f878c 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,282 @@ group and can access them as follows::
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
> +
> +Along with the device_state the migration driver provides a data window which
> +allows streaming migration data into or out of the device.
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
> +  0
> +     Device is halted
> +
> +and the reference flow for resuming:
> +
> +  RUNNING
> +     Issue VFIO_DEVICE_RESET to clear the internal device state
> +  0
> +     Device is halted
> +  RESUMING
> +     Push in migration data. Data captured during pre-copy should be
> +     prepended to data captured during SAVING.
> +  NDMA | RUNNING
> +     Peer to Peer DMA grace state
> +  RUNNING, VCPU_RUNNING
> +     Normal operating state
> +

There are so many implicit concepts here, I'm not sure I'm making a
correct interpretation, let alone someone coming to this document for
understanding.

> +If the VMM has multiple VFIO devices undergoing migration then the grace
> +states act as cross device synchronization points. The VMM must bring all
> +devices to the grace state before advancing past it.
> +
> +The above reference flows are built around specific requirements on the
> +migration driver for its implementation of the migration_state input.

I can't glean any meaning from this sentence.  "device_state" here and
throughout?  We don't have a "migration_state".

> +The migration_state cannot change asynchronously, upon writing the
> +migration_state the driver will either keep the current state and return
> +failure, return failure and go to ERROR, or succeed and go to the new state.
> +
> +Event triggered actions happen when user-space requests a new migration_state
> +that differs from the current migration_state. Actions happen on a bit group
> +basis:
> +
> + SAVING | RUNNING
> +   The device clears the data window and begins streaming 'pre copy' migration
> +   data through the window. Devices that cannot log internal state changes
> +   return a 0 length migration stream.
> +
> + SAVING | !RUNNING
> +   The device captures its internal state that is not covered by internal
> +   logging, as well as any logged changes.
> +
> +   The device clears the data window and begins streaming the captured
> +   migration data through the window. Devices that cannot log internal state
> +   changes stream all their device state here.
> +
> + RESUMING
> +   The data window is cleared, opened, and can receive the migration data
> +   stream.
> +
> + !RESUMING
> +   All the data transferred into the data window is loaded into the device's
> +   internal state. The migration driver can rely on user-space issuing a
> +   VFIO_DEVICE_RESET prior to starting RESUMING.

We can't really rely on userspace to do anything, nor has this sequence
been part of the specified protocol.

As with the previous flows, it seems like there's a ton of implicit
knowledge here.  Why are we documenting these here rather than in the
uAPI header?  I'm having a difficult time trying to understand what are
proposals to modify the uAPI and what are interpretations of the
existing protocol.

> +
> +   To abort a RESUMING issue a VFIO_DEVICE_RESET.

Again, this is not explicitly part of the current protocol.  Any use of
VFIO_DEVICE_RESET should return the device to the default state, but a
user is free to try to use device_state to transition from RESUMING to
any other state.  The driver can choose to fail that transition and
even make use of the error device_state, but there's no expectation
that a VFIO_DEVICE_RESET is the first choice for userspace to abort a
resume session.

> +
> +   If the migration data is invalid then the ERROR state must be set.

This is the only place the uAPI defines intervention via the RESET
ioctl.

> +
> +Continuous actions are in effect when migration_state bit groups are active:
> +
> + RUNNING | NDMA
> +   The device is not allowed to issue new DMA operations.
> +
> +   Whenever the kernel returns with a migration_state of NDMA there can be no
> +   in progress DMAs.
> +

There are certainly event triggered actions based on setting NDMA as
well, ex. completion of outstanding DMA.

> + !RUNNING
> +   The device should not change its internal state. Further implies the NDMA
> +   behavior above.

Does this also imply other device regions cannot be accessed as has
previously been suggested?  Which?

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
> +
> + ERROR
> +   The behavior of the device is largely undefined. The device must be
> +   recovered by issuing VFIO_DEVICE_RESET or closing the device file
> +   descriptor.
> +
> +   However, devices supporting NDMA must behave as though NDMA is asserted
> +   during ERROR to avoid corrupting other devices or a VM during a failed
> +   migration.
> +
> +When multiple bits change in the migration_state they may describe multiple
> +event triggered actions, and multiple changes to continuous actions.  The
> +migration driver must process them in a priority order:
> +
> + - SAVING | RUNNING
> + - NDMA
> + - !RUNNING
> + - SAVING | !RUNNING
> + - RESUMING
> + - !RESUMING
> + - RUNNING
> + - !NDMA

Lots of deduction left to the reader...

> +
> +In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
> +device back to device_state RUNNING. When a migration driver executes this
> +ioctl it should discard the data window and set migration_state to RUNNING as
> +part of resetting the device to a clean state. This must happen even if the
> +migration_state has errored. A freshly opened device FD should always be in
> +the RUNNING state.
> +
> +The migration driver has limitations on what device state it can affect. Any
> +device state controlled by general kernel subsystems must not be changed
> +during RESUME, and SAVING must tolerate mutation of this state. Change to
> +externally controlled device state can happen at any time, asynchronously, to
> +the migration (ie interrupt rebalancing).
> +
> +Some examples of externally controlled state:
> + - MSI-X interrupt page

More specifically, vector table and pba, but probably also config
capability.

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
> +
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
> +  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
> +  device does not support NDMA and rely on that to guarantee quiet MMIO.

Seems that would have its own set of consequences.

> +  The Peer to Peer Grace States exist so that all devices may reach RUNNING
> +  before any device is subjected to a MMIO access.
> +
> +  Failure to guarantee quiet MMIO may allow a hostile VM to use P2P to violate
> +  the no-MMIO restriction during SAVING or RESUMING and corrupt the migration
> +  on devices that cannot protect themselves.
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

So the VMM is required to hide features like PRI based on NDMA support?

> +
> +- pre-copy allows the device to implement a dirty log for its internal state.
> +  During the SAVING | RUNNING state the data window should present the device
> +  state being logged and during SAVING | !RUNNING the data window should present
> +  the unlogged device state as well as the changes from the internal dirty log.
> +

This is getting a bit close to specifying an implementation.  The goal
of the pre-copy is to minimize downtime during the stop-and-copy,
therefore the specific data exposed in each phase depends on the usage
model and data size of the device.

> +  On RESUME these two data streams are concatenated together.
> +
> +  pre-copy is only concerned with internal device state. External DMAs are
> +  covered by the separate DIRTY_TRACKING function.
> +
> +- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
> +  cannot support this, then NDMA could be used to synthesize it less
> +  efficiently.
> +
> +- NDMA is optional. If the device does not support this then the NDMA States
> +  are pushed down to the next step in the sequence and various behaviors that
> +  rely on NDMA cannot be used.
> +
> +- Migration control registers inside the same iommu_group as the VFIO device.

Not a complete sentence, is this meant as a topic header?

> +  This immediately raises a security concern as user-space can use Peer to Peer
> +  DMA to manipulate these migration control registers concurrently with
> +  any kernel actions.
> +

We haven't defined "migration control registers" beyond device_state,
which is software defined "register".  What physical registers that are
subject to p2p DMA is this actually referring to?

> +  A device driver operating such a device must ensure that kernel integrity
> +  cannot be broken by hostile user space operating the migration MMIO
> +  registers via peer to peer, at any point in the sequence. Notably the kernel
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
> +
> +
> +TDB - discoverable feature flag for NDMA

Is the goal to release mlx5 support without the NDMA feature and add it
later?  Thanks,

Alex

> +TDB IMS xlation
> +TBD PASID xlation
>  
>  VFIO bus driver API
>  -------------------------------------------------------------------------------
> 
> base-commit: ae0351a976d1880cf152de2bc680f1dff14d9049

