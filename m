Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E099F47B5DE
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 23:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhLTW0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 17:26:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231994AbhLTW0a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 17:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640039189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=emx9UNcufTg5ljqwXEgsyyAj+XH1AHd70GHIvHSUCik=;
        b=ehduGr9d+P5zynQH1YNG9hCF9ysELErN2ewRpLFx0yG2iLlsvJqf0O/TBHPtWubuiORHWJ
        9f5nCbIxe8GqlPOpnI5a6aaYQjiYALB5PV/c27dlEmjroqoh378akMlncx10/mFX3CQzNt
        GcutHzN5nIqTVRDbdFNQ1JDUCigvcjg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-1mD2WHW3Msyfc-RzqIKxtw-1; Mon, 20 Dec 2021 17:26:27 -0500
X-MC-Unique: 1mD2WHW3Msyfc-RzqIKxtw-1
Received: by mail-ot1-f71.google.com with SMTP id z16-20020a056830129000b0055c7b3ceaf5so3793751otp.8
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 14:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=emx9UNcufTg5ljqwXEgsyyAj+XH1AHd70GHIvHSUCik=;
        b=k21y6hLhdVf2qXGkyD0xr2YpHZtkqFyws9ioKEB6sLM5daW2epbwiVs+uOfY6en6j7
         2Jt/7srPJXcGsjbH21u91hBXhAc2zp2k+k8/OvHPdGmMDV3xuU1pmWdUiI4ul5foy6ff
         Vx02fZqh+QWIb3rzViTWsdvhwYbOSwWK1TiqYz1S0kmzCvIGvR0I0wxYtlRbnPTjNgCw
         Wfs8Sjb7SmQZbJF/SyzmojZEf7MvSU13QZU50dqmQGukmafsTj4ry9ZF6Pd8XrWa25Go
         7yX/TMLz4s5m5+c5w/DlsPOt8n0P1QjmKlmeN7fVPCyKpyiTGQrZ60jTvSjLjDU9/TPb
         AzHw==
X-Gm-Message-State: AOAM5333+1imbvQg5/QpKZEjYbwKG7nsmJq5U2I+57HcglvjnrbXhZhH
        ZvRnL3+hwodAuPhCPPqkhUtI2+n2x+XegDTuJJ/iRQMkiPolJhtMfS3DX/Xy/9urY+cB7NXHtjW
        6etHjJsGrnlEU
X-Received: by 2002:a05:6808:1784:: with SMTP id bg4mr138377oib.70.1640039186694;
        Mon, 20 Dec 2021 14:26:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaG9Auh081YHPjxp6+PzJrUuShNaWfw0/NQvujUgZYNr1P59EWRoQ2FVh4c3n6s6HCkiUfKg==
X-Received: by 2002:a05:6808:1784:: with SMTP id bg4mr138354oib.70.1640039186157;
        Mon, 20 Dec 2021 14:26:26 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e14sm3428832oow.3.2021.12.20.14.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 14:26:25 -0800 (PST)
Date:   Mon, 20 Dec 2021 15:26:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20211220152623.50d753ec.alex.williamson@redhat.com>
In-Reply-To: <20211214162654.GJ6385@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <20211210012529.GC6385@nvidia.com>
        <20211213134038.39bb0618.alex.williamson@redhat.com>
        <20211214162654.GJ6385@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Dec 2021 12:26:54 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Dec 13, 2021 at 01:40:38PM -0700, Alex Williamson wrote:
> 
> > We do specify that a migration driver has discretion in using the error
> > state for failed transitions, so there are options to simplify error
> > handling.  
> 
> This could be OK if we can agree ERROR has undefined behavior.
> 
> > I think the basis of your priority scheme comes from that.  Ordering
> > of the remaining items is more subtle though, for instance
> > 0 -> SAVING | RUNNING can be broken down as:
> > 
> >   0 -> SAVING
> >   SAVING -> SAVING | RUNNING 
> > 
> >   vs
> > 
> >   0 -> RUNNING
> >   RUNNING -> SAVING | RUNNING
> >
> > I'd give preference to enabling logging before running and I believe
> > that holds for transition (e) -> (d) as well.  
> 
> IMHO, any resolution to an arbitary choice should pick an order that
> follows the reference flow because we know those are useful sequences
> to have today.
> 
> Generally we have no use for the sequence SAVING -> SAVING | RUNNING,
> while RUNNING -> SAVING | RUNNING is part of the standard flow.

SAVING -> SAVING | RUNNING or SAVING -> RUNNING could both be used as
recovery sequences should the target VM fail.  The latter might be a
full abort of the migration while the former might be a means to reset
the downtime clock without fully restarting the migration.

> It also raises the question that it seems not well defined what the
> sequence:
> 
> SAVING -> SAVING | RUNNING
> 
> Even does to the migration window?
> 
> Nor can I imagine what mlx5 could do beyond fail this or corrupt the
> migration..

I think this comes down to the robustness of the migration driver.  The
migration data window and control of how userspace is to interact with
it is essentially meant to allow the migration driver to implement its
own transport protocol.  In the case of mlx5 where it expects only to
apply the received migration data on the RESUMING -> RUNNING
transition, a "short" data segment might be reserved for providing
sequencing information.  Each time the device enters SAVING | !RUNNING
the driver might begin by presenting a new sequence header.  On the
target, a new sequence header would cause any previously received
migration data to be discarded.  A similar header would also be
suggested to validate the migration data stream is appropriate for the
target device.

Also, I hope it goes without saying, but I'll say it anyway, the
migration data stream would make for an excellent exploit vector and
each migration driver needs to be responsible to make sure that
userspace cannot use it to break containment of the device.
 
> If we keep the "should implement transitions" language below then I
> expect mlx5 to fail this, and then we have a conflict where mlx5
> cannot implement these precedence rules.

Per above, I think it can.

> This is the kind of precedence resolution I was trying to avoid.
> 
> As far as I can see the requirements are broadly:
>  - Do not transit through an invalid state
>  - Do not loose NDMA during the transit, eg NDMA | SAVING | RUNNING -> 0
>    should not have a race where a DMA can leak out
>  - Do not do transit through things like SAVING -> SAVING | RUNNING,
>    and I'm not confident I have a good list of these

"Things like", yeah, that's not really spec material.  There's nothing
special about that transition.  The migration driver should take into
account management of the migration data stream and support such
states, or error the transition if it isn't sufficient ROI and expect
device specific bug reports at some point in the future.

For NDMA, that's a valid consideration.  I think that means though that
NDMA doesn't simply bookend the pseudo algorithm I provided.  Perhaps
it's nested between RUNNING and SAVING handlers on either end.
 
> > And I think that also addresses the claim that we're doomed to untested
> > and complicated error code handling, we unwind by simply swapping the
> > args to our set state function and enter the ERROR state should that
> > recursive call fail.  
> 
> I had the same thought the day after I wrote this, it seems workable.
> 
> I remain concerned however that we still can't seem to reach to a
> working precedence after all this time. This is a very bad sign. 
> 
> Even if we work something out adding a new state someday is
> terrifying. What if we can't work out any precedence that is
> compatible with todays and supports the new state?
> 
> IMHO, we should be simplifing this before it becomes permanent API,
> not trying to force it to work.

I agree, this is our opportunity to simplify before we're committed,
but I don't see how we can throw out perfectly valid transitions like
SAVING -> SAVING | RUNNING just because the driver hasn't accounted for
managing data in the data stream.

> > If we put it in the user's hands and prescribe only single bit flips,
> > they don't really have device knowledge to optimize further than this
> > like a migration driver might be able to do.  
> 
> If so this argues we should go back to the enforced FSM that the v1
> mlx5 posting had and forget about device_state as a bunch of bits.
> 
> Most of things I brought up in this post are resolved by the forced
> FSM.

Until userspace tries to do something different than exactly what it
does today, and then what?
 
> Yes, we give up some flexability, but I think the quest for
> flexability is a little misguided. If the drivers don't consistently
> implement the flexability then it is just cruft we cannot make use of
> from userspace.
> 
> eg what practical use is SAVING -> SAVING | RUNNING if today's mlx5
> implementation silently corrupts the migration stream? That instantly
> makes that a no-go for userspace from an interoperability perspective
> and we've accomplished nothing by allowing for it.

Failure to support that transition is a deficiency of the driver and
represented by a non-silent error in making that transition.  Silently
corrupting the migration stream is simply a driver bug.
 
> Please think about it, it looks like an easy resolution to all this
> discussion to simply specify a fixed FSM and be done with it.
> 
> > > I thought we could tackled this when you first suggested it (eg copy
> > > the mlx5 logic and be OK), but now I'm very skeptical. The idea that
> > > every driver can do this right in all the corner cases doesn't seem
> > > reasonable given we've made so many errors here already just in mlx5.
> > >   
> > > > + *     - Bit 1 (SAVING) [REQUIRED]:
> > > > + *        - Setting this bit enables and initializes the migration region data    
> > > 
> > > I would use the word clear instead of initialize - the point of this
> > > is to throw away any data that may be left over in the window from any
> > > prior actions.  
> > 
> > "Clear" to me suggests that there's some sort of internal shared buffer
> > implementation that needs to be wiped between different modes.  I chose
> > "initialize" because I think it offers more independence to the
> > implementation.  
> 
> The data window is expressed as a shared buffer in this API, there is
> only one data_offset/size and data window for everything.

Any access to the data window outside of that directed by the driver is
undefined, it's up to the driver where and how to populate the data.  A
driver might make a portion of the data window available as an mmap
that gets zapped and faulted to the correct device backing between
operations.
 
> I think it is fine to rely on that for the description, and like all
> abstractions an implementation can do whatever so long as externally
> it looks like this shared buffer API.
> 
> The requirement here is that anything that pre-existed in the data
> window from any prior operation is cleaned and the data window starts
> empty before any data related to this SAVING is transfered.

IOW, it's initialized.  We're picking out colors for the bike shed at
this point.

> > > > + *          window and associated fields within vfio_device_migration_info for
> > > > + *          capturing the migration data stream for the device.  The migration
> > > > + *          driver may perform actions such as enabling dirty logging of device
> > > > + *          state with this bit.  The SAVING bit is mutually exclusive with the
> > > > + *          RESUMING bit defined below.
> > > > + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> > > > + *          data window and indicates the completion or termination of the
> > > > + *          migration data stream for the device.    
> > > 
> > > I don't know what "de-initialized" means as something a device should
> > > do? IMHO there is no need to talk about the migration window here,
> > > SAVING says initialize/clear - and data_offset/etc say their values
> > > are undefined outside SAVING/RUNNING. That is enough.  
> > 
> > If "initializing" the migration data region puts in place handlers for
> > pending_bytes and friends, "de-initializing" would undo that operation.
> > Perhaps I should use "deactivates"?  
> 
> And if you don't use "initializing" we don't need to talk about
> "de-initializating".
> 
> Reading the data window outside SAVING is undefined behavior it seems,
> so nothing needs to be said.

Exactly why I thought simply describing it as the reciprocal of setting
the bit would be sufficient.  Taupe!

> > > > + *     - Bit 2 (RESUMING) [REQUIRED]:
> > > > + *        - Setting this bit enables and initializes the migration region data
> > > > + *          window and associated fields within vfio_device_migration_info for
> > > > + *          restoring the device from a migration data stream captured from a
> > > > + *          SAVING session with a compatible device.  The migration driver may
> > > > + *          perform internal device resets as necessary to reinitialize the
> > > > + *          internal device state for the incoming migration data.
> > > > + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> > > > + *          region data window and indicates the end of a resuming session for
> > > > + *          the device.  The kernel migration driver should complete the
> > > > + *          incorporation of data written to the migration data window into the
> > > > + *          device internal state and perform final validity and consistency
> > > > + *          checking of the new device state.  If the user provided data is
> > > > + *          found to be incomplete, inconsistent, or otherwise invalid, the
> > > > + *          migration driver must indicate a write(2) error and follow the
> > > > + *          previously described protocol to return either the previous state
> > > > + *          or an error state.    
> > > 
> > > Prefer this is just 'go to an error state' to avoid unnecessary
> > > implementation differences.  
> > 
> > Then it becomes a special case versus other device_state changes and
> > we're forcing what you've described as an undefined state into the
> > protocol.  
> 
> Lets look at what recovery actions something the VMM would need to
> take along the reference flow:
> 
> RUNNING -> SAVING | RUNNING
>   If this fails and we are still in RUNNING and can continue
> 
>  -> SAVING | RUNNING | NDMA
>  -> SAVING  
>   If these fail we need to go to RUNNING
>   -> RUNNING  
>     If this fails we need to RESET

I won't argue that there aren't transition failures where the next
logical step is likely a reset, but I also don't see the point in
defining special rules for certain cases.  When in doubt, leave policy
decisions to userspace?

> 
>  -> 0  
>   Migration succeeded? Failure here should RESET
>
> RUNNING -> RESUMING
>   If this fails and we are still in RUNNING continue
>  -> NDMA | RUNNING  
>   If this fails RESET
>  -> RUNNING  
>   If this fails RESET, VM could be corrupted.
> 
> One view is that what the device does is irrelevant as qemu should
> simply unconditionally reset in these case.
> 
> Another view is that staying in a useless state is also pointless and
> we may as well return ERROR anyhow. Eg if exiting RESUMING failed
> there is no other action to take besides RESET, so why didn't we
> return ERROR to tell this directly to userspace?

And then the last packet arrives, gets written to the device that's
still in RESUMING, and now can transition to RUNNING.
 
> Both are reasonable views, which is why I wrote "prefer".

There's no going back from the ERROR state, the only path the user has
forward is to reset the device.  Therefore the only case I'm willing to
say it's the preferred next state is in the case of an irrecoverable
internal fault.  I'd also like to avoid another lengthy discussion
trying to define which specific transitions should default to an ERROR
state if they fail versus simply return -errno.  Userspace is free to
define a policy where an -errno is considered fatal for the device.  I
prefer consistent userspace handling, letting userspace define policy,
and robust drivers that avoid forcing unnecessary user decisions.

> > > > + *     - Bit 3 (NDMA) [OPTIONAL]:
> > > > + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> > > > + *        the device for the purposes of managing multiple devices within a
> > > > + *        user context where peer-to-peer DMA between devices may be active.
> > > > + *        Support for the NDMA bit is indicated through the presence of the
> > > > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> > > > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> > > > + *        region.
> > > > + *        - Setting this bit must prevent the device from initiating any
> > > > + *          new DMA or interrupt transactions.  The migration driver must    
> > > 
> > > I'm not sure about interrupts.  
> > 
> > In the common case an interrupt is a DMA write, so the name, if not
> > intention of this state gets a bit shaky if interrupts are allowed.  
> 
> Interrupts have their own masking protocol. For instance a device like
> the huawei one is halting DMA by manipulating the queue registers, it
> may still generate interrupts.
> 
> Yes, MSI is a MemWr, but I've never heard anyone call it a DMA - there
> is no memory access here since the TLP is routed to the interrupt
> controller.

That's a pretty subtle distinction.  Can't that controller live in MMIO
space and isn't it then just a peer-to-peer DMA?  I know I'm not the
first to consider MSI to be just another DMA, that seems to be the
basis of it's handling on ARM SMMU.
 
> This is why I'm not sure. A hostile VM certainly can corrupt the MSI,
> even today and thus turn it into a DMA. As we talked before this may
> be OK, but is security risky that it allows the guest to impact the
> hypervisor.
>
> Overall it seems like this is more trouble for a device like huawei's
> if they want to implement NDMA using the trapping or something. Given
> your right concern that NDMA should be implemented as widely as
> possible making it more difficult that stricly necessary is perhaps
> not good.
> 
> Other peope should comment here.

Yeah, I'm not clear on what devices can and cannot do in the NDMA state.
Ultimately the goal is that once all devices are in the NDMA state, we
can safely transition them to the !RUNNING state without concern
regarding access from another device.  Specifically we want to avoid
things like DeviceA moves to !RUNNING while DeviceB initiates a DMA
access to DeviceA which now cannot respond without advancing internal
state which violates the condition of !RUNNING.

But I think we're really only after that p2p behavior and we've
discussed that disabling p2p mappings in the VM would be a sufficient
condition to support multiple devices without NDMA support.  I think
that means DMA to memory is fine and DMA related to MSI is fine... but
how does a device know which DMA is memory and which DMA is another
device?

> > > > + *          complete any such outstanding operations prior to completing
> > > > + *          the transition to the NDMA state.  The NDMA device_state    
> > > 
> > > Reading this as you wrote it and I suddenly have a doubt about the PRI
> > > use case. Is it reasonable that the kernel driver will block on NDMA
> > > waiting for another userspace thread to resolve any outstanding PRIs?
> > > 
> > > Can that allow userspace to deadlock the kernel or device? Is there an
> > > alterative?  
> > 
> > I'd hope we could avoid deadlock in the kernel, but it seems trickier
> > for userspace to be waiting on a write(2) operation to the device while
> > also handling page request events for that same device.  Is this
> > something more like a pending transaction bit where userspace asks the
> > device to go quiescent and polls for that to occur?  
> 
> Hum. I'm still looking into this question, but some further thoughts.
> 
> PRI doesn't do DMA, it just transfers a physical address into the PCI
> device's cache that can be later used with DMA.
> 
> PRI also doesn't imply the vPRI Intel is talking about.
> 
> For PRI controlled by the hypervisor, it is completely reasonable that
> NDMA returns synchronously after the PRI and the DMA that triggered it
> completes. The VMM would have to understand this and ensure it doesn't
> block the kernel's fault path while going to NDMA eg with userfaultfd
> or something else crazy.
> 
> The other reasonable option is that NDMA cancels the DMA that
> triggered the PRI and simply doesn't care how the PRI is completed
> after NDMA returns.
> 
> The later is interesting because it is a possible better path to solve
> the vPRI problem Intel brought up. Waiting for the VCPU is just asking
> for a DOS, if NDMA can cancel the DMAs we can then just directly fail
> the open PRI in the hypervisor and we don't need to care about the
> VCPU. Some mess to fixup in the vIOMMU protocol on resume, but the
> resume'd device simply issues a new DMA with an empty ATS cache and
> does a new PRI.
> 
> It is uncertain enough that qemu should not support vPRI with
> migration until we define protocol(s) and a cap flag to say the device
> supports it.
> 
> > > > + *   All combinations for the above defined device_state bits are considered
> > > > + *   valid with the following exceptions:
> > > > + *     - RESUMING and SAVING are mutually exclusive, all combinations of
> > > > + *       (RESUMING | SAVING) are invalid.  Furthermore the specific combination
> > > > + *       (!NDMA | RESUMING | SAVING | !RUNNING) is reserved to indicate the
> > > > + *       device error state VFIO_DEVICE_STATE_ERROR.  This variant is
> > > > + *       specifically chosen due to the !RUNNING state of the device as the
> > > > + *       migration driver should do everything possible, including an internal
> > > > + *       reset of the device, to ensure that the device is fully stopped in
> > > > + *       this state.      
> > > 
> > > Prefer we don't specify this. ERROR is undefined behavior and
> > > userspace should reset. Any path that leads along to ERROR already
> > > includes possiblities for wild DMAs and what not, so there is nothing
> > > to be gained by this other than causing a lot of driver complexity,
> > > IMHO.  
> > 
> > This seems contrary to your push for consistent, interoperable
> > behavior.  
> 
> Formal "undefined behavior" can be a useful part of a spec, especially
> if the spec is 'when you see ERROR you must do RESET', we don't really
> need to constrain the device further to continue to have
> interoperability.
> 
> > What's the benefit to actually leaving the state undefined or the
> > drawback to preemptively resetting a device if the migration driver
> > cannot determine if the device is quiesced,   
> 
> RESET puts the device back to RUNNING, so RESET alone does not remedy
> the problem.
> 
> RESET followed by !RUNNING can fail, meaning the best mlx5 can do is
> "SHOULD", in which case lets omit the RESET since userspace can't rely
> on it.
> 
> Even if it did work reliably, the requirement is userspace must issue
> RESET to exit ERROR and if we say the driver has to issue reset to
> enter ERROR we are just doing a pointless double RESET.

Please read what I wrote:

    This variant is specifically chosen due to the !RUNNING state of
    the device as the migration driver should do everything possible,
    including an internal reset of the device, to ensure that the
    device is fully stopped in this state.

That does not say that a driver must issue a reset to enter the ERROR
state.  Perhaps it's wrong that I'm equating this so formally to the
!RUNNING state when really we don't care about the internal state of
the device, we just want it to not corrupt memory or generate spurious
interrupts.  I'm thinking the equivalent of clear bus-master for PCI
devices.  Would it be sufficient if I clarified !RUNNING relative to
DMA and interrupt generation?

> > would need to reset the device to enter a new state anyway?  I added
> > this because language in your doc suggested the error state was far
> > more undefined that I understood it to be, ie. !RUNNING.  
> 
> Yes it was like that, because the implementation of this strict
> requirement is not nice.
> 
> Perhaps a middle ground can work:
> 
>   For device_state ERROR the device SHOULD have the device
>   !RUNNING. If the ERROR arose due to a device_state change and
>   if the new and old states have NDMA behavior then the device MUST
>   maintain NDMA behavior while processing the device_state and
>   continuing while in ERROR. Userspace MUST reset the device to
>   recover from ERROR, therefore devices SHOULD NOT do a redundant
>   internal reset

I don't have a problem if the reset is redundant to one the user needs
to do anyway, I'd rather see any externally visible operation of the
device stopped ASAP.  The new and old state NDMA-like properties is
also irrelevant, if a device enters an ERROR state moving from RUNNING
-> SAVING | RUNNING it shouldn't continue manipulating memory and
generating interrupts in the background.  What about:

    The !RUNNING variant is used here specifically to reflect that the
    device should immediately cease all external operations such as DMA
    and interrupts.  The migration driver should do everything
    possible, up to and including an internal reset of the device, to
    ensure that the device is externally quiescent in this state.

> > > > + *   Migration drivers should attempt to support any
> > > >     transition between valid    
> > > 
> > > should? must, I think.  
> > 
> > I think that "must" terminology is a bit contrary to the fact that
> >     we have a defined error state that can be used at the
> >     discretion of the migration driver.  To me, "should" tells the
> >     migration drivers that they ought to make an attempt to support
> >     all transitions, but userspace needs to be be prepared that
> >     they might not work.    
> 
> IMHO this is not inter-operable. At a minimum we should expect that a
> driver implements a set of standard transitions, or it has to
> implement all of them.
> 
> Otherwise what is the point?
> 
> If you go back to the mlx5 v1 version it did effectively this. It
> enforced a FSM and only allowed some transitions. That meets the
> language here with "should" but you didn't like it, and I agreed with
> you then.
> 
> This is when the trouble stated :)
> 
> The mlx5 v1 with the FSM didn't have alot of these problems we are
> discussing. It didn't have precedence issues, it didn't have problems
> executing odd combinations it can't support, it worked and was simple
> to understand.

And an audit of that driver during review found that it grossly failed
to meet the spirit of a "should" requirement.

Using "should" terminology here is meant to give the driver some
leeway, it's not an invitation for abuse.  Even below there's still a
notion that a given state transitions is unsupportable by your device,
what if that was actually true?

> So, if we say should here, then I vote mlx5 goes back to enforcing
> its FSM and that becomes the LCD that userspace must implement to.
> 
> In which case, why not formally specify the FSM now and avoid a driver
> pushing a defacto spec?

It really only takes one driver implementing something like SAVING ->
SAVING | RUNNING and QEMU taking advantage of it as a supported
transition per the uAPI for mlx5 to be left out of the feature that
might provide.

> If we say MUST here then we need to figure out a precedence and 
> say that some transitions are undefined behavior, like SAVING ->
> SAVING|RUNNING.

If we say "should" and don't do those thing, then we're still not
implementing to the spirit of the uAPI.  I'm hearing a lot of "may" in
your interpretation of "should".  And again, nothing wrong with that
transition, manage the migration stream better.  Thanks,

Alex

