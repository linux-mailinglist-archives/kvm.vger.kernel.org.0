Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B69047362A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 21:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbhLMUkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 15:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243002AbhLMUkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 15:40:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639428042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yc31ZE8ekGUkLJ+TWGrK8RqoXHEMVbzOIpcut2h9qak=;
        b=MQuqs2U4/C3yjom2b/+diPJ5Jz6eOU/N3imBxc0eiPdEzDCiT5i6EdrrmD28TqS0oU7Uju
        EDWYuyOX6wZ9UpL3z074wSDF9HiZcfQAF6i+D0YWHyWRuyYYvWxn+aIIN1OrKMSVj8HDgP
        0vm7gjXqc3C8g9HFkvwPh9cdWVYDFV0=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-_4knM24uOXWXY_jj8bB2Qw-1; Mon, 13 Dec 2021 15:40:41 -0500
X-MC-Unique: _4knM24uOXWXY_jj8bB2Qw-1
Received: by mail-oi1-f200.google.com with SMTP id bd7-20020a056808220700b002bd5095a720so11586638oib.10
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 12:40:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yc31ZE8ekGUkLJ+TWGrK8RqoXHEMVbzOIpcut2h9qak=;
        b=akgC0rP6SrBuZG4S/LbWTRIbdl3XMZM4RnrqyufoD46vzHxPUKmV42sJt0wKkitVFM
         3ssuxSx268e8lp8kszhmhHzuIg25qc7BfFuvxtBL/GzQy9wtXVA6DOQRlFzVj9hppSIC
         CpMawbWV+hcdOafQe3b+LvwCee0gu0vhWK+56p0YHlFTZCdSpnyu8miOSzhBCpZgrYIR
         m+l2mEaP6ttJGZpi81va7SH+ELCYedpk/f+Cm7np5MIwSR14y9BTKX1WkdU1BJy02Ssc
         T79aGeZ62iqum7XWOKrIEHD9ekxHW3h1i0/mCPmUlFmK8ZHAhc8WoN+W2eLQ54jyfqQV
         aaPA==
X-Gm-Message-State: AOAM532eIto9qA62L1+WtBbYAA2cpYt96XKL0lH5i3rwKR0NSKtF3vLe
        gxObafldn7iAiw0oTJ4vnWxxLa0TNtOaDUxlnaFE/fui4h3AnBw2Dmy76vLAi/KrDoCBi6Oz40l
        FXADV0T6CtjnH
X-Received: by 2002:a05:6830:199:: with SMTP id q25mr748599ota.150.1639428040639;
        Mon, 13 Dec 2021 12:40:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZdMN+snE1mpRoto1kX+k+b957dECtccYKPOyuC85k2BHVWP2ASH5kiH34s5tKxBuLbFoIOQ==
X-Received: by 2002:a05:6830:199:: with SMTP id q25mr748571ota.150.1639428040195;
        Mon, 13 Dec 2021 12:40:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l39sm2450982otv.63.2021.12.13.12.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 12:40:39 -0800 (PST)
Date:   Mon, 13 Dec 2021 13:40:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20211213134038.39bb0618.alex.williamson@redhat.com>
In-Reply-To: <20211210012529.GC6385@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <20211210012529.GC6385@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Dec 2021 21:25:29 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Dec 09, 2021 at 04:34:29PM -0700, Alex Williamson wrote:
> > A new NDMA state is being proposed to support a quiescent state for
> > contexts containing multiple devices with peer-to-peer DMA support.
> > Formally define it.
> > 
> > Clarify various aspects of the migration region data fields and
> > protocol.  Remove QEMU related terminology and flows from the uAPI;
> > these will be provided in Documentation/ so as not to confuse the
> > device_state bitfield with a finite state machine with restricted
> > state transitions.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >  include/uapi/linux/vfio.h |  405 ++++++++++++++++++++++++---------------------
> >  1 file changed, 214 insertions(+), 191 deletions(-)  
> 
> I need other peope to look this over, so these are just some quick
> remarks. Thanks for doing it, it is very good.
> 
> Given I'm almost on vacation till Jan I think we will shortly have to
> table this discussion to January.
> 
> But, if you are happy with this as all that is needed to do mlx5 we
> can possibly have the v6 updated in early January, after the next
> merge window.
> 
> Though lets try to quickly decide on what to do about the "change
> multiple bits" below, please.
> 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index ef33ea002b0b..1fdbc928f886 100644
> > +++ b/include/uapi/linux/vfio.h
> > @@ -408,199 +408,211 @@ struct vfio_region_gfx_edid {
> >  #define VFIO_REGION_SUBTYPE_MIGRATION           (1)
> >  
> >  /*
> > + * The structure vfio_device_migration_info is placed at the immediate start of
> > + * the per-device VFIO_REGION_SUBTYPE_MIGRATION region to manage the device
> > + * state and migration information for the device.  Field accesses for this
> > + * structure are only supported using their native width and alignment,
> > + * accesses otherwise are undefined and the kernel migration driver should
> > + * return an error.
> >   *
> >   * device_state: (read/write)
> > + *   The device_state field is a bitfield written by the user to transition
> > + *   the associated device between valid migration states using these rules:
> > + *     - The user may read or write the device state register at any time.
> > + *     - The kernel migration driver must fully transition the device to the
> > + *       new state value before the write(2) operation returns to the user.
> > + *     - The user may change multiple bits of the bitfield in the same write
> > + *       operation, so long as the resulting state is valid.  
> 
> I would like to forbid this. It is really too complicated, and if
> there is not a strongly defined device behavior when this is done it
> is not inter-operable for userspace to do it.
> 
> > + *     - The kernel migration driver must not generate asynchronous device
> > + *       state transitions outside of manipulation by the user or the
> > + *       VFIO_DEVICE_RESET ioctl as described below.
> > + *     - In the event of a device state transition failure, the kernel
> > + *       migration driver must return a write(2) error with appropriate errno
> > + *       to the user.
> > + *     - Upon such an error, re-reading the device_state field must indicate
> > + *       the device migration state as either the same state as prior to the
> > + *       failing write or, at the migration driver discretion, indicate the
> > + *       device state as VFIO_DEVICE_STATE_ERROR.  
> 
> It is because this is complete nightmare. Let's say the user goes from
> 0 -> SAVING | RUNNING and SAVING fails after we succeed to do
> RUNNING. We have to also backtrack and undo RUNNING, but what if that
> fails too? Oh and we have to keep track of all this backtracking while
> executing the new state and write a bunch of complicated never tested
> error handling code.

We do specify that a migration driver has discretion in using the error
state for failed transitions, so there are options to simplify error
handling.

If we look at bit flips, we have:

Initial state
|  Resuming
|  |  Saving
|  |  |  Running
|  |  |  |  Next states with multiple bit flips

a) 0, 0, 0  (d)
b) 0, 0, 1  (c) (e)
c) 0, 1, 0  (b) (e)
d) 0, 1, 1  (a) (e)
e) 1, 0, 0  (b) (c) (d)
f) 1, 0, 1 UNSUPPORTED
g) 1, 1, 0 ERROR
h) 1, 1, 1 INVALID

We specify that we cannot pass through any invalid states during
transition, so if I consider each bit to be a discrete operation and
map all these multi-bit changes to a sequence of single bit flips, the
only requirements are:

  1) RESUMING must be cleared before setting SAVING or RUNNING
  2) SAVING or RUNNING must be cleared before setting RESUMING

I think the basis of your priority scheme comes from that.  Ordering
of the remaining items is more subtle though, for instance
0 -> SAVING | RUNNING can be broken down as:

  0 -> SAVING
  SAVING -> SAVING | RUNNING 

  vs

  0 -> RUNNING
  RUNNING -> SAVING | RUNNING

I'd give preference to enabling logging before running and I believe
that holds for transition (e) -> (d) as well.

In the reverse case, SAVING | RUNNING -> 0

  SAVING | RUNNING -> RUNNING
  RUNNING -> 0

  vs

  SAVING | RUNNING -> SAVING
  SAVING -> 0

This one is more arbitrary.  I tend to favor clearing RUNNING to stop
the device first, largely because it creates nice symmetry in the
resulting algorithm and follows the general principle that you
discovered as well, converge towards zero by addressing bit clearing
before setting.  So a valid algorithm would include:

int set_device_state(u32 old, u32 new, bool is_unwind)
{
	if (old.RUNNING && !new.RUNNING) {
		curr.RUNNING = 0;
		if (ERROR) goto unwind;
	}
	if (old.SAVING && !new.SAVING) {
		curr.SAVING = 0;
		if (ERROR) goto unwind;
	}
	if (old.RESUMING && !new.RESUMING) {
		curr.RESUMING = 0;
		if (ERROR) goto unwind;
	}
	if (!old.RESUMING && new.RESUMING) {
		curr.RESUMING = 1;
		if (ERROR) goto unwind;
	}
	if (!old.SAVING && new.SAVING) {
		curr.saving = 1;
		if (ERROR) goto unwind;
	}
	if (!old.RUNNING && new.RUNNING) {
		curr.RUNNING = 1;
		if (ERROR) goto unwind;
        }

	return 0;

unwind:
	if (!is_unwind) {
		ret = set_device_state(curr, old, true);
		if (ret) {
			curr.raw = ERROR;
			return ret;
		}
	}

	return -EIO;
}

And I think that also addresses the claim that we're doomed to untested
and complicated error code handling, we unwind by simply swapping the
args to our set state function and enter the ERROR state should that
recursive call fail.

I think it would be reasonable for documentation to present similar
pseudo code as a recommendation, but ultimately the migration driver
needs to come up with something that fits all the requirements.

(Ignoring NDMA for the moment until we determine if it's even a
synchronous operations)

If we put it in the user's hands and prescribe only single bit flips,
they don't really have device knowledge to optimize further than this
like a migration driver might be able to do.

> Assuming we can even figure out what the precedence of multiple bits
> even means for interoperability.
> 
> Backed into this is an assumption that any device transition is fully
> atomic - that just isn't what I see any of the HW has done.

We only specify that the transition needs to be complete before the
write(2) operation returns, there's no specified atomicity versus any
other event.  "Synchronous" is maybe your concern?

> I thought we could tackled this when you first suggested it (eg copy
> the mlx5 logic and be OK), but now I'm very skeptical. The idea that
> every driver can do this right in all the corner cases doesn't seem
> reasonable given we've made so many errors here already just in mlx5.
> 
> > + *     - Bit 1 (SAVING) [REQUIRED]:
> > + *        - Setting this bit enables and initializes the migration region data  
> 
> I would use the word clear instead of initialize - the point of this
> is to throw away any data that may be left over in the window from any
> prior actions.

"Clear" to me suggests that there's some sort of internal shared buffer
implementation that needs to be wiped between different modes.  I chose
"initialize" because I think it offers more independence to the
implementation.
 
> > + *          window and associated fields within vfio_device_migration_info for
> > + *          capturing the migration data stream for the device.  The migration
> > + *          driver may perform actions such as enabling dirty logging of device
> > + *          state with this bit.  The SAVING bit is mutually exclusive with the
> > + *          RESUMING bit defined below.
> > + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> > + *          data window and indicates the completion or termination of the
> > + *          migration data stream for the device.  
> 
> I don't know what "de-initialized" means as something a device should
> do? IMHO there is no need to talk about the migration window here,
> SAVING says initialize/clear - and data_offset/etc say their values
> are undefined outside SAVING/RUNNING. That is enough.

If "initializing" the migration data region puts in place handlers for
pending_bytes and friends, "de-initializing" would undo that operation.
Perhaps I should use "deactivates"?

> > + *     - Bit 2 (RESUMING) [REQUIRED]:
> > + *        - Setting this bit enables and initializes the migration region data
> > + *          window and associated fields within vfio_device_migration_info for
> > + *          restoring the device from a migration data stream captured from a
> > + *          SAVING session with a compatible device.  The migration driver may
> > + *          perform internal device resets as necessary to reinitialize the
> > + *          internal device state for the incoming migration data.
> > + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> > + *          region data window and indicates the end of a resuming session for
> > + *          the device.  The kernel migration driver should complete the
> > + *          incorporation of data written to the migration data window into the
> > + *          device internal state and perform final validity and consistency
> > + *          checking of the new device state.  If the user provided data is
> > + *          found to be incomplete, inconsistent, or otherwise invalid, the
> > + *          migration driver must indicate a write(2) error and follow the
> > + *          previously described protocol to return either the previous state
> > + *          or an error state.  
> 
> Prefer this is just 'go to an error state' to avoid unnecessary
> implementation differences.

Then it becomes a special case versus other device_state changes and
we're forcing what you've described as an undefined state into the
protocol.  Use of the error state is at the driver's discretion, but
the spec is written such a driver only needs to make use of it if it
encounters some sort of irrecoverable internal error.

> > + *     - Bit 3 (NDMA) [OPTIONAL]:
> > + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> > + *        the device for the purposes of managing multiple devices within a
> > + *        user context where peer-to-peer DMA between devices may be active.
> > + *        Support for the NDMA bit is indicated through the presence of the
> > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> > + *        region.
> > + *        - Setting this bit must prevent the device from initiating any
> > + *          new DMA or interrupt transactions.  The migration driver must  
> 
> I'm not sure about interrupts.

In the common case an interrupt is a DMA write, so the name, if not
intention of this state gets a bit shaky if interrupts are allowed.
 
> > + *          complete any such outstanding operations prior to completing
> > + *          the transition to the NDMA state.  The NDMA device_state  
> 
> Reading this as you wrote it and I suddenly have a doubt about the PRI
> use case. Is it reasonable that the kernel driver will block on NDMA
> waiting for another userspace thread to resolve any outstanding PRIs?
> 
> Can that allow userspace to deadlock the kernel or device? Is there an
> alterative?

I'd hope we could avoid deadlock in the kernel, but it seems trickier
for userspace to be waiting on a write(2) operation to the device while
also handling page request events for that same device.  Is this
something more like a pending transaction bit where userspace asks the
device to go quiescent and polls for that to occur?

> > + *   All combinations for the above defined device_state bits are considered
> > + *   valid with the following exceptions:
> > + *     - RESUMING and SAVING are mutually exclusive, all combinations of
> > + *       (RESUMING | SAVING) are invalid.  Furthermore the specific combination
> > + *       (!NDMA | RESUMING | SAVING | !RUNNING) is reserved to indicate the
> > + *       device error state VFIO_DEVICE_STATE_ERROR.  This variant is
> > + *       specifically chosen due to the !RUNNING state of the device as the
> > + *       migration driver should do everything possible, including an internal
> > + *       reset of the device, to ensure that the device is fully stopped in
> > + *       this state.    
> 
> Prefer we don't specify this. ERROR is undefined behavior and
> userspace should reset. Any path that leads along to ERROR already
> includes possiblities for wild DMAs and what not, so there is nothing
> to be gained by this other than causing a lot of driver complexity,
> IMHO.

This seems contrary to your push for consistent, interoperable behavior.
What's the benefit to actually leaving the state undefined or the
drawback to preemptively resetting a device if the migration driver
cannot determine if the device is quiesced, especially when the user
would need to reset the device to enter a new state anyway?  I added
this because language in your doc suggested the error state was far
more undefined that I understood it to be, ie. !RUNNING.

> > + *   Migration drivers should attempt to support any transition between valid  
> 
> should? must, I think.

I think that "must" terminology is a bit contrary to the fact that we
have a defined error state that can be used at the discretion of the
migration driver.  To me, "should" tells the migration drivers that they
ought to make an attempt to support all transitions, but userspace
needs to be be prepared that they might not work.  If a driver fails to
implement some transitions necessary for a given application, the
application should fail gracefully, but migration features may not be
available for the device.

> The whole migration window definition seems quite straightforward now!

Great!
 
> > + * a) The user reads pending_bytes.  If the read value is zero, no data is
> > + *    currently available for the device.  If the device is !RUNNING and a
> > + *    zero value is read, this indicates the end of the device migration
> > + *    stream and the device must not generate any new migration data.  If
> > + *    the read value is non-zero, the user may proceed to collect device
> > + *    migration data in step b).  Repeated reads of pending_bytes is allowed
> > + *    and must not compromise the migration data stream provided the user does
> > + *    not proceed to the following step.  
> 
> Add what to do in SAVING|RUNNING if pending bytes is 0?

Maybe it's too subtle, but that's why I phrased it as "no data is
currently available" and went on to specify the implications in the
!RUNNING state.  "Currently", suggesting that in the RUNNING state the
value is essentially volatile.

> >  #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> > -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> > -					     VFIO_DEVICE_STATE_RESUMING)
> > +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_ERROR)  
> 
> We should delete this macro. It only makes sense used in a driver does
> not belong in the uapi header.

I may have gotten sloppy here, I thought I was incorporating what had
been proposed in the mlx5 series.  Thanks,

Alex

