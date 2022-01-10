Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E71489E70
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 18:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiAJReJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 12:34:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238113AbiAJReI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 12:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641836048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEOKgAdmhtsYSxH0kllgevXPqM4NVOjsRtscjlSlQkA=;
        b=dchFJzPE4r7yXlGRh5mKnhcakxVcwmdixmNUSAWz1tOsDRxoeaFL7o/v9XYxxngkF2093R
        ROQr5layNp6kwGuA4cRv2QAZZtrDgcvc2Oinawp8RMaLZzgHTY4fchahIkKXkIwI8jTusK
        ifxecUfBFWGRcLLqMvKfoQ/HLGINN+w=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-uuiNM6MEPpWOkPoWMRVHow-1; Mon, 10 Jan 2022 12:34:06 -0500
X-MC-Unique: uuiNM6MEPpWOkPoWMRVHow-1
Received: by mail-oo1-f69.google.com with SMTP id w25-20020a4a6d59000000b002daaed72624so8889353oof.23
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aEOKgAdmhtsYSxH0kllgevXPqM4NVOjsRtscjlSlQkA=;
        b=n4jZkzxvbnKVpBwowTLiZbmUXAeHBK+UjXGP3/lr6OhbCNA363yA70tQ7lgT0umUeC
         Y5SmoE4mp/ICEzfBgmx00cyoh2IZdu/TBEC+9bYe37jWRi6Yg/LCZ+v3DsKr2yxmSdZZ
         ebMZJJyP3gSqFlCHVTEF/uWMQwHUHIjQfccM2Dt6A3Y9ztycisN4o4trNcd7UwxhY8MN
         tzNFG+7S4hUOOA6QR7Exk3uhYaIOigP8HdUIr4JXqisNci2TWvZ/RalOCiI5aR0z6T6G
         HsjoeBGPAB1NgZ2RsBRNCDcJ9KapsO/f/pG4owfbx84ZdfWNltWC1/ZsWTcJrq6UXgqZ
         XPpA==
X-Gm-Message-State: AOAM532LTiCExwxdbYpKkXk1xR3EhhULpPUQS83s1omtrwKBN9y2HSrx
        9rt6BSGyW64q7j7yRHs0oB+OVDAkM/cRQhuvjH5WyGkLJvXyAIftGrB0ujuaEh6wFjTKkG4f3LF
        DKks/asmyV/1q
X-Received: by 2002:a4a:e50e:: with SMTP id r14mr574416oot.27.1641836045795;
        Mon, 10 Jan 2022 09:34:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7oehhXFGZzJaTJK03EjNdoCOkOZXOgblncw9L+9yyhkPMSjKF2CnsLeIH1GxdKn8FDbGNiQ==
X-Received: by 2002:a4a:e50e:: with SMTP id r14mr574390oot.27.1641836045512;
        Mon, 10 Jan 2022 09:34:05 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r12sm616948ota.54.2022.01.10.09.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 09:34:05 -0800 (PST)
Date:   Mon, 10 Jan 2022 10:34:04 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220110103404.6130bc65.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <20211210012529.GC6385@nvidia.com>
        <20211213134038.39bb0618.alex.williamson@redhat.com>
        <20211214162654.GJ6385@nvidia.com>
        <20211220152623.50d753ec.alex.williamson@redhat.com>
        <20220104202834.GM2328285@nvidia.com>
        <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
        <20220106212057.GM2328285@nvidia.com>
        <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jan 2022 07:55:16 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, January 7, 2022 5:21 AM
> >=20
> > We were also thinking to retain STOP. SAVING -> STOP could possibly
> > serve as the abort path to avoid a double action, and some of the use
> > cases you ID'd below are achievable if STOP remains. =20
>=20
> what is the exact difference between a null state {} (implying !RUNNING)
> and STOP in this context?
>=20
> If they are different, who (user or driver) should conduct and when do=20
> we expect transitioning the device into a null state?

Sorry if I added confusion here, the null, ie. {}, state fit my
notation better.  The null state is simply no bits set in device_state,
it's equivalent to "STOP" without coming up with a new name for every
set of bit combinations.

> > > We have 20 possible transitions.  I've marked those available via the
> > > "odd ascii art" diagram as (a), that's 7 transitions.  We could
> > > essentially remove the NULL state as unreachable as there seems little
> > > value in the 2 transitions marked (a)* if we look only at migration,
> > > that would bring us down to 5 of 12 possible transitions.  We need to
> > > give userspace an abort path though, so we minimally need the 2
> > > transitions marked (b) (7/12). =20
> >  =20
> > > So now we can discuss the remaining 5 transitions:
> > >
> > > {SAVING} -> {RESUMING}
> > > 	If not supported, user can achieve this via:
> > > 		{SAVING}->{RUNNING}->{RESUMING}
> > > 		{SAVING}-RESET->{RUNNING}->{RESUMING} =20
> >=20
> > This can be:
> >=20
> > SAVING -> STOP -> RESUMING =20
>=20
> From Alex's original description the default device state is RUNNING.
> This supposed to be the initial state on the dest machine for the
> device assigned to Qemu before Qemu resumes the device state.
> Then how do we eliminate the RUNNING state in above flow? Who
> makes STOP as the initial state on the dest node?

The device must be RUNNING by default.  This is a requirement that
introduction of migration support for a device cannot break
compatibility with existing userspace that may no support migration
features.  It would be QEMU's responsibility to transition a migration
target device from the default state to a state to accept a migration.
There's no discussion here of eliminating the {RUNNING}->{RESUMING}
transition.
=20
> > > drivers follow the previously provided pseudo algorithm with the
> > > requirement that they cannot pass through an invalid state, we need to
> > > formally address whether the NULL state is invalid or just not
> > > reachable by the user. =20
> >=20
> > What is a NULL state? =20
>=20
> Hah, seems I'm not the only one having this confusion. =F0=9F=98=8A

Sorry again, I thought it could easily be deduced by including it in
the state transitions.

> > We have defined (from memory, forgive me I don't have access to
> > Yishai's latest code at the moment) 8 formal FSM states:
> >=20
> >  RUNNING
> >  PRECOPY
> >  PRECOPY_NDMA
> >  STOP_COPY
> >  STOP
> >  RESUMING
> >  RESUMING_NDMA
> >  ERROR (perhaps MUST_RESET) =20
>=20
> ERROR->SHUTDOWN? Usually a shutdown state implies reset required...

The userspace process can go away at any time, what exactly is a
"SHUTDOWN" state representing?
=20
> > > But I think you've identified two classes of DMA, MSI and everything
> > > else.  The device can assume that an MSI is special and not included =
in
> > > NDMA, but it can't know whether other arbitrary DMAs are p2p or memor=
y.
> > > If we define that the minimum requirement for multi-device migration =
is
> > > to quiesce p2p DMA, ex. by not allowing it at all, then NDMA is
> > > actually significantly more restrictive while it's enabled. =20
> >=20
> > You are right, but in any practical physical device NDMA will be
> > implemented by halting all DMAs, not just p2p ones.
> >=20
> > I don't mind what we label this, so long as we understand that halting
> > all DMA is a valid device implementation.
> >=20
> > Actually, having reflected on this now, one of the things on my list
> > to fix in iommufd, is that mdevs can get access to P2P pages at all.
> >=20
> > This is currently buggy as-is because they cannot DMA map these
> > things, touch them with the CPU and kmap, or do, really, anything with
> > them. =20
>=20
> Can you elaborate why mdev cannot access p2p pages?
>=20
> >=20
> > So we should be blocking mdev's from accessing P2P, and in that case a
> > mdev driver can quite rightly say it doesn't support P2P at all and
> > safely NOP NDMA if NDMA is defined to only impact P2P transactions.
> >=20
> > Perhaps that answers the question for the S390 drivers as well.
> >  =20
> > > Should a device in the ERROR state continue operation or be in a
> > > quiesced state?  It seems obvious to me that since the ERROR state is
> > > essentially undefined, the device should cease operations and be
> > > quiesced by the driver.  If the device is continuing to operate in the
> > > previous state, why would the driver place the device in the ERROR
> > > state?  It should have returned an errno and left the device in the
> > > previous state. =20
> >=20
> > What we found while implementing is the use of ERROR arises when the
> > driver has been forced to do multiple actions and is unable to fully
> > unwind the state. So the device_state is not fully the original state
> > or fully the target state. Thus it is ERROR.
> >=20
> > The additional requirement that the driver do another action to
> > quiesce the device only introduces the possiblity for triple failure.
> >=20
> > Since it doesn't bring any value to userspace, I prefer we not define
> > things in this complicated way. =20
>=20
> So ERROR is really about unrecoverable failures. If recoverable suppose
> errno should have been returned and the device is still in the original
> state. Is this understanding correct?

Yes, that's how I understand it.  The ERROR state should be used if the
driver can neither provide the requested new state nor remain/return to
the old state.
=20
> btw which errno indicates to the user that the device is back to the
> original state or in the ERROR state? or want the user to always check
> the device state upon any transition error?

No such encoding is defined or required, per the existing uAPI the user
is to re-evaluate device_state on any non-zero errno.  Thanks,

Alex

