Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D7486999
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbiAFSRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:17:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240458AbiAFSRX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 13:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641493043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/j4cxBc6rKegUkMMwuJt6SPOIyiy3SX3KpJBSpYn888=;
        b=a1LkCGlWwHorV6cnkA70WteaS6om2Sc6N9RKUpGO7Gx3D361B7d4enAB6PTX1RF8XjytDw
        59Ltb9zNRXeWFw7jgGe/IxdKMovVyLny0k8fIybXteKWx6uUapm/Lj4vTemyKg8ayJbAeg
        7nLSxafI4N209ErR49OVbw3LVXkCo7U=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591--_yul9WkPt-PX_vdAzs7uA-1; Thu, 06 Jan 2022 13:17:21 -0500
X-MC-Unique: -_yul9WkPt-PX_vdAzs7uA-1
Received: by mail-oi1-f200.google.com with SMTP id w133-20020acadf8b000000b002c6c86f4afbso2303250oig.16
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 10:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/j4cxBc6rKegUkMMwuJt6SPOIyiy3SX3KpJBSpYn888=;
        b=S0eymsnFJrmmVSoIFJz0elRcNtH7pLFtS22Xj8LjBXMQPyfLBR7qIXcCB5ucHFnY8b
         Tz38+ka3hOswcVI2eSILj2LG48QKvgkH8ES89ENfA72lpDq54pGBygxPfEj8l94VpTJa
         SnoSR+1HVK0taqaXEHeC00s43qxrK27HfJXkooCnpNCpHmFQk2IEvHKzE4RIC+zRSSYN
         6OFSmH7m9WYmgqfSefPVDQqnQV3NmdCCGn4HUcxrfJWvM86R779dFJ4CMxt93qYCpjcP
         tlXy5BjdCJH9UmAoTzE7XWeDVfsLjLEWIrQOKQZZhA+F/JDwxOkRpXqAbIA9+fbz/hin
         SxnA==
X-Gm-Message-State: AOAM5318xzWLi+XgQN5SZitY/OrsZ5g1PWdbQiIg5gJeBr/QR1WdbvCE
        Z7uEY5BFmG23yYNL/dHHEX/H4OuScbnT1JPEW4Ak2+UQ5qM99b5nB7aJCH46O8l679tVT4hkpfc
        awmJFZMO9nTmh
X-Received: by 2002:a9d:7c86:: with SMTP id q6mr40080otn.229.1641493040840;
        Thu, 06 Jan 2022 10:17:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdBW3TmdVELU3zlzTEGuP5O8HUrm1lnIKLYHatMhqiXwGRILH3lMnCIsI8VRgiJurtN4aK1Q==
X-Received: by 2002:a9d:7c86:: with SMTP id q6mr40023otn.229.1641493040020;
        Thu, 06 Jan 2022 10:17:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bq5sm534812oib.55.2022.01.06.10.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 10:17:19 -0800 (PST)
Date:   Thu, 6 Jan 2022 11:17:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
In-Reply-To: <20220104202834.GM2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <20211210012529.GC6385@nvidia.com>
        <20211213134038.39bb0618.alex.williamson@redhat.com>
        <20211214162654.GJ6385@nvidia.com>
        <20211220152623.50d753ec.alex.williamson@redhat.com>
        <20220104202834.GM2328285@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Jan 2022 16:28:34 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Dec 20, 2021 at 03:26:23PM -0700, Alex Williamson wrote:
> 
> > > It also raises the question that it seems not well defined what the
> > > sequence:
> > > 
> > > SAVING -> SAVING | RUNNING
> > > 
> > > Even does to the migration window?
> > > 
> > > Nor can I imagine what mlx5 could do beyond fail this or corrupt the
> > > migration..  
> > 
> > I think this comes down to the robustness of the migration driver.  The
> > migration data window and control of how userspace is to interact with
> > it is essentially meant to allow the migration driver to implement its
> > own transport protocol.  In the case of mlx5 where it expects only to
> > apply the received migration data on the RESUMING -> RUNNING
> > transition, a "short" data segment might be reserved for providing
> > sequencing information.  Each time the device enters SAVING | !RUNNING
> > the driver might begin by presenting a new sequence header.  On the
> > target, a new sequence header would cause any previously received
> > migration data to be discarded.  A similar header would also be
> > suggested to validate the migration data stream is appropriate for the
> > target device.  
> 
> Honestly, I have no interest in implementing something so complicated
> for what should be a simple operation. We have no use case for this,
> no desire to test it, it is just pure kernel cruft and complexity to
> do this kind of extra work.

Migration is not a simple operation, we have a device with a host
kernel driver exporting and importing device state through userspace.
It's a playground for potential exploit vectors.  I assume this also
means that you're not performing any sort of validation that the
incoming data is from a compatible device or providing any versioning
accommodations in the data stream, all features that would generally be
considered best practices.

> I think it is very telling that we are, what, 10 weeks into this now,
> we have seen two HW drivers posted, and NOTHING implements like you
> are imagining here. I doubt the closed drivers do any better.
>
> Let's not make up busy work that can't be strongly justified! 

I think I'm portraying the uAPI as it was designed and envisioned to
work.  Of course I also have doubts whether the closed drivers perform
any sort of validation or consistency checking, and we can only guess
what sort of attack vectors might exist as a result.
 
> That is substantially what I see as wrong with this whole line of
> thinking that the device_state must be independent bits, not a
> constrained FSM.
> 
> We are actively failing, again and again, to tell if drivers are
> implementing this mulit-bit vision correctly, or even specify properly
> how it should work in an implementable way.
> 
> > > IMHO, we should be simplifing this before it becomes permanent API,
> > > not trying to force it to work.  
> > 
> > I agree, this is our opportunity to simplify before we're committed,
> > but I don't see how we can throw out perfectly valid transitions like
> > SAVING -> SAVING | RUNNING just because the driver hasn't accounted for
> > managing data in the data stream.  
> 
> Don't see? What do you mean? We showed how to do this exactly in the
> v1.
> 
> We define the meaning of device_state to be actual FSM and write out
> the allowed FSM arcs and then properly describe them.
> 
> This is what everyone else though this was already.
> 
> AFAICT you are the only person to view this as a bunch of bits. It is
> why the original header file comment gave names to each of the states
> and roughtly sketches out legal state transition arcs with the odd
> ascii art.
> 
> So I want to stop trying to make the bunch of bits idea work. Let's
> make it a FSM, let's define exactly the legal arcs, and then define
> the behaviors in each FSM state. It is easy to understand and we have
> a hope to get inter-operable implementations.
> 
> All the driver postings so far are demonstrating they don't get
> oddball transition arcs correct, and we are clearly not able to find
> these things during review.
> 
> And now you are asking for alot of extra work and complications in the
> driver to support arcs that will never be used - that is really too
> far, sorry.

It's the uAPI as I understand it.  If you want a new uAPI, propose one.
I'm not willing to accept a driver that partially implements the uAPI
with an addendum document vaguely hinting at the ways it might be
limited, with the purpose of subverting the written uAPI by a de facto
standard.

> > > Most of things I brought up in this post are resolved by the forced
> > > FSM.  
> > 
> > Until userspace tries to do something different than exactly what it
> > does today, and then what?  
> 
> It can't. We define the API to be exactly the permited arcs and no
> others. That is what simplify means.

IOW, define the uAPI based on what happens to be the current QEMU
implementation and limitations.  That's exactly what we were trying to
avoid in the uAPI design.
 
> If we need to add new FSM arcs and new states later then their support
> can be exposed via a cap flag.
> 
> This is much better than trying to define all arcs as legal, only
> testing/using a small subset and hoping the somehow in the future this
> results in extensible interoperability.

A proposal of which states transitions you want to keep would be useful
here.  Let's look at all the possibilities:

{}
	-> {RUNNING}
	-> {SAVING}
	-> {RESUMING}
	-> {RUNNING|SAVING}

{RUNNING}
	-> {} (a)*
	-> {SAVING} (a)
	-> {RESUMING} (a)
	-> {RUNNING|SAVING} (a)

{SAVING}
	-> {} (a)*
	-> {RUNNING} (b)
	-> {RESUMING}
	-> {RUNNING|SAVING}

{RESUMING}
	-> {}
	-> {RUNNING} (a)
	-> {SAVING}
	-> {RUNNING|SAVING}

{RUNNING|SAVING}
	-> {}
	-> {RUNNING} (b)
	-> {SAVING} (a)
	-> {RESUMING}

We have 20 possible transitions.  I've marked those available via the
"odd ascii art" diagram as (a), that's 7 transitions.  We could
essentially remove the NULL state as unreachable as there seems little
value in the 2 transitions marked (a)* if we look only at migration,
that would bring us down to 5 of 12 possible transitions.  We need to
give userspace an abort path though, so we minimally need the 2
transitions marked (b) (7/12).

So now we can discuss the remaining 5 transitions:

{SAVING} -> {RESUMING}
	If not supported, user can achieve this via:
		{SAVING}->{RUNNING}->{RESUMING}
		{SAVING}-RESET->{RUNNING}->{RESUMING}
	It would likely be dis-recommended to return a device to
	{RUNNING} for this use case, so the latter would be preferred.

	Potential use case: ping-pong migration

{SAVING} -> {RUNNING|SAVING}
	If not supported, user can achieve this via:
		{SAVING}->{RUNNING}->{RUNNING|SAVING}

	Potential use case: downtime exceeded, avoid full migration
	restart (likely not achieved with the alternative flow).

{RESUMING} -> {SAVING}
	If not supported:
		{RESUMING}->{RUNNING}->{SAVING}
		{RESUMING}-RESET->{RUNNING}->{SAVING}

	Potential use case: validate migration data in = data out (also
	cannot be achieved with alternative flow, as device passes
	through RUNNING)

{RESUMING} -> {RUNNING|SAVING}
	If not supported:
		{RESUMING}->{RUNNING}->{RUNNING|SAVING}

	Potential use case: live ping-pong migration (alternative flow
	is likely sufficient)

{RUNNING|SAVING} -> {RESUMING}
	If not supported:
		{RUNNING|SAVING}->{RUNNING}->{RESUMING}
		{RUNNING|SAVING}-RESET->{RUNNING}->{RESUMING}
	(again former is likely dis-recommended)

	Potential use case: ???

So what's the proposal?  Do we ditch all of these?  Some of these?  If
drivers follow the previously provided pseudo algorithm with the
requirement that they cannot pass through an invalid state, we need to
formally address whether the NULL state is invalid or just not
reachable by the user.

> > > Another view is that staying in a useless state is also pointless and
> > > we may as well return ERROR anyhow. Eg if exiting RESUMING failed
> > > there is no other action to take besides RESET, so why didn't we
> > > return ERROR to tell this directly to userspace?  
> > 
> > And then the last packet arrives, gets written to the device that's
> > still in RESUMING, and now can transition to RUNNING.  
> 
> Huh? If the device indicated error during RESUMING userspace should
> probably stop shoving packets into it or it will possibly corrupt the
> migration stream.

If a {RESUMING}->{RUNNING} transition fails and the device remains in
{RESUMING}, it should be valid for userspace to push data to it.  If
the driver wants to indicate the transition attempt failed AND it won't
accept continuing data or a re-initialized data stream, it probably
should put the device into {ERROR} instead.
 
> > But I think we're really only after that p2p behavior and we've
> > discussed that disabling p2p mappings in the VM would be a sufficient
> > condition to support multiple devices without NDMA support.  I think
> > that means DMA to memory is fine and DMA related to MSI is fine... but
> > how does a device know which DMA is memory and which DMA is another
> > device?  
> 
> The device doesn't know if a particular DMA is P2P or not. This is why
> the device action is called 'NO DMA'.
> 
> MSI is fine to be left unspecified because we currently virtualize all
> the MSI register writes and it is impossible for a hostile guest to
> corrupt them to point the address to anything but the interrupt
> controller. If a MSI triggers or not in NDMA doesn't practically
> matter.

The vector table is directly accessible via the region mmap.  It
previously was not, but that becomes a problem with 64k page sizes, and
even some poorly designed devices on 4k systems when they don't honor
the PCI spec recommended alignments.  But I think that's beside the
point, if the user has vectors pointed at memory or other devices,
they've rather already broken their contract for using the device.

But I think you've identified two classes of DMA, MSI and everything
else.  The device can assume that an MSI is special and not included in
NDMA, but it can't know whether other arbitrary DMAs are p2p or memory.
If we define that the minimum requirement for multi-device migration is
to quiesce p2p DMA, ex. by not allowing it at all, then NDMA is
actually significantly more restrictive while it's enabled.

> It only starts to matter someday if we get the world Thomas is
> thinking about where the guest can directly program the MSI registers.
> 
> > > Even if it did work reliably, the requirement is userspace must issue
> > > RESET to exit ERROR and if we say the driver has to issue reset to
> > > enter ERROR we are just doing a pointless double RESET.  
> > 
> > Please read what I wrote:
> > 
> >     This variant is specifically chosen due to the !RUNNING state of
> >     the device as the migration driver should do everything possible,
> >     including an internal reset of the device, to ensure that the
> >     device is fully stopped in this state.
> > 
> > That does not say that a driver must issue a reset to enter the ERROR
> > state.    
> 
> Huh? "everything possible including an internal reset" sure sounds
> like a device must issue a reset in some cases. If we keep with your
> idea to rarely use ERROR then I think all the mlx5 cases that would
> hit it are already so messed up that RESET will be mandatory.
> 
> > I don't have a problem if the reset is redundant to one the user needs
> > to do anyway, I'd rather see any externally visible operation of the
> > device stopped ASAP.    
> 
> Why? It was doing all those things before it had an error, why
> should it suddenly stop now? What is this extra work helping?
> 
> Remember if we choose to return an error code instead of ERROR the
> device is still running as it was, I don't see an benifit to making
> ERROR different here.
> 
> ERROR just means the device has to be reset, we don't need the device
> to stop doing what it was doing.

Should a device in the ERROR state continue operation or be in a
quiesced state?  It seems obvious to me that since the ERROR state is
essentially undefined, the device should cease operations and be
quiesced by the driver.  If the device is continuing to operate in the
previous state, why would the driver place the device in the ERROR
state?  It should have returned an errno and left the device in the
previous state.
 
> > The new and old state NDMA-like properties is also irrelevant, if a
> > device enters an ERROR state moving from RUNNING -> SAVING | RUNNING
> > it shouldn't continue manipulating memory and generating interrupts
> > in the background.  
> 
> I prefer a model where the device is allowed to keep doing whatever it
> was doing before it hit the error. You are pushing for a model where
> upon error we must force the device to stop.

If the device continues operating in the previous mode then it
shouldn't enter the ERROR state, it should return errno and re-reading
device_state should indicate it's in the previous state.

> For this view it is why the old state matters, if it was previously
> allowed to DMA then it continues to be allowed to do DMA, etc.

If it's still running normally, it shouldn't have been reported in the
ERROR state.

> > > The mlx5 v1 with the FSM didn't have alot of these problems we are
> > > discussing. It didn't have precedence issues, it didn't have problems
> > > executing odd combinations it can't support, it worked and was simple
> > > to understand.  
> > 
> > And an audit of that driver during review found that it grossly failed
> > to meet the spirit of a "should" requirement.  
> 
> That isn't how I see things.. The v1 driver implemented the uAPI we
> all thought existed, was the FSM based uAPI the original patch authors
> intended, and implemented only the FSM arcs discussed in the header
> file comment.
> 
> Your idea that this is not a FSM seems to be unique here. I think
> we've explored it to a reasonable conclusion to find it isn't working
> out. Let's stop please.
> 
> Yishai can prepare a version with the FSM design back in including
> NDMA and we can look at it.

Sorry, but I was actually there and participating in original
development of the uAPI.  If you'd like to propose a different uAPI do
so, but again, I'm not going to accept a driver specifically looking to
compromise what I understand to be the intent of the current
specification in order to create a de facto standard outside of that
specification.  Thanks,

Alex

