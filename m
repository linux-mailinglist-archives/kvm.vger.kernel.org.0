Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB84E3EBE2B
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 00:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbhHMWJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 18:09:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235059AbhHMWJj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 18:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628892551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=usaJn38f6PQ2CzV8drMKktA3mbOE//g70lzrQ5h58AU=;
        b=Q91w6U4GVeLXgnN7is/at6MSpYiOzebYkPZ9pkmciYvqSrT4TSW8JAO6MpcovpheT6NPeW
        AxGTPuZON6aMvMi4ydg9f2cZrkI+I5UYlkp3uO9A07ywMwUxh7lIlBv4Uz0Gls48MeMOOp
        xl1F1pWsmD1Sm2WwZOpB7WlXzOq87c0=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-TZnjs6p3MmiFSMtFPNzybQ-1; Fri, 13 Aug 2021 18:09:10 -0400
X-MC-Unique: TZnjs6p3MmiFSMtFPNzybQ-1
Received: by mail-ot1-f69.google.com with SMTP id x47-20020a056830246fb0290451891192f0so4253994otr.1
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 15:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=usaJn38f6PQ2CzV8drMKktA3mbOE//g70lzrQ5h58AU=;
        b=D0zYYqk050d40QtZohxfcJuBdzHsAo5YUskXMY2D0k/DOi6nGJz/lTuI9wUDHBhl7r
         Ksw3u7Ws9IqfzLY4tdIA8VVpn9a+z3x7XtSa6wofqxR3WdFCGuY+h6LvUMmpNeRDape3
         Pxd/0JOEl4lYaLyzELZeyyA5cbfbAQnKcuU8yCqf+RP4g6M2uUvbmmfY6txQ5dD5YETd
         jsfiLNTWYvn92wHJoR1So3v0wZiSDRBx2wUx/JErb0xCjjGQZcDHjhIcJOnkfzWBeRhK
         ugddND2WzHMi2pY2JIZ+4MH8xWOFpCmDKBNY+1xN0gwgQ0eHgxjiyh++ZP5T1WUPvM8c
         O3Jg==
X-Gm-Message-State: AOAM531V9AKBicU0FgpDhqsYFbxhUmLm7z+OBvMhLgm0Q5/R+kLss3Fe
        P4JzsX/YuolBiAZczJfkda4DzE1wtNKqSGFniwEElDi6hjwCIzaErqIIuBs2XZTjrUxCXK80597
        L2ve7W6hnU2P3
X-Received: by 2002:a54:4406:: with SMTP id k6mr3854320oiw.179.1628892549455;
        Fri, 13 Aug 2021 15:09:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrtmAC9v5cTUDvPTZBFMmcfmQM8HkAFjsF0PeUK7JuAMy5pZyoyDzsd6OWX3BtLoSAuKKw4w==
X-Received: by 2002:a54:4406:: with SMTP id k6mr3854309oiw.179.1628892549258;
        Fri, 13 Aug 2021 15:09:09 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id i8sm576186otk.51.2021.08.13.15.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:09:08 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:09:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Russ Weight <russell.h.weight@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Adler, Michael" <michael.adler@intel.com>,
        "Whisonant, Tim" <tim.whisonant@intel.com>, <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Rix <trix@redhat.com>
Subject: Re: BUG REPORT: vfio_pci driver
Message-ID: <20210813160907.7b143b51.alex.williamson@redhat.com>
In-Reply-To: <ca6977da-5657-51aa-0ef2-fb4a7e8c15dd@intel.com>
References: <ca6977da-5657-51aa-0ef2-fb4a7e8c15dd@intel.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 11:34:51 -0700
Russ Weight <russell.h.weight@intel.com> wrote:

> Bug Description:
>=20
> A bug in the vfio_pci driver was reported in junction with work on FPGA

This looks like the documented behavior of an IRQ index reporting the
VFIO_IRQ_INFO_NORESIZE flag.  We can certainly work towards trying to
remove the flag from this index, but it seems the userspace driver is
currently ignoring the flag and expecting exactly the behavior the flag
indicates is not available.  Thanks,

Alex

> cards. We were able to reproduce and root-cause the bug using system-tap.
> The original bug description is below. An understanding of the referenced
> dfl and opae tools is not required - it is the sequence of IOCTL calls and
> IRQ vectors that matters:
>=20
> > I=E2=80=99m trying to get an example AFU working that uses 2 IRQs, acti=
ve at the same=20
> > time. I=E2=80=99m hitting what looks to be a dfl_pci driver bug.
> >
> > The code tries to allocate two IRQ vectors: 0 and 1. I see opaevfio.c d=
oing the=20
> > right thing, picking the MSIX index. Allocating either IRQ 0 or IRQ 1 w=
orks fine=20
> > and I confirm that the VFIO_DEVICE_SET_IRQS looks reasonable, choosing =
MSIX and=20
> > either start of 0 or 1 and count 1.
> >
> > Note that opaevfio.c always passes count 1, so it will make separate ca=
lls for=20
> > each IRQ vector.
> >
> > When I try to allocate both, I see the following:
> >
> >   * If the VFIO_DEVICE_SET_IRQS ioctl is called first with start 0 and =
then
> >     start 1 (always count 1), the start 1 (second) ioctl trap returns E=
INVAL.
> >   * If I set up the vectors in decreasing order, so start 1 followed by=
 start 0,
> >     the program works!
> >   * I ruled out OPAE SDK user space problems by setting up my program to
> >     allocate in increasing order, which would normally fail. I changed =
only the
> >     ioctl call in user space opaevfio.c, inverting bit 0 of start so th=
at the
> >     driver is called in decreasing index order. Of course this binds th=
e wrong
> >     vectors to the fds, but I don=E2=80=99t care about that for now. Th=
is works! From
> >     this, I conclude that it can=E2=80=99t be a user space problem sinc=
e the difference
> >     between working and failing is solely the order in which IRQ vector=
s are
> >     bound in ioctl calls. =20
>=20
> The EINVAL is coming from vfio_msi_set_block() here:
> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_i=
ntrs.c#L373
>=20
> vfio_msi_set_block() is being called from vfio_pci_set_msi_trigger() here=
 on
> the second IRQ request:
> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_i=
ntrs.c#L530
>=20
> We believe the bug is in vfio_pci_set_msi_trigger(), in the 2nd parameter=
 to the call
> to vfio_msi_enable() here:
> https://github.com/torvalds/linux/blob/master/drivers/vfio/pci/vfio_pci_i=
ntrs.c#L533
>=20
> In both the passing and failing cases, the first IRQ request results in a=
 call
> to vfio_msi_enable() at line 533 and the second IRQ request results in the
> call to vfio_msi_set_block() at line 530. It is during the first IRQ requ=
est
> that vfio_msi_enable() sets vdev->num_ctx based on the 2nd parameter (nve=
c).
> vdev->num_ctx is part of the conditional that results in the EINVAL for t=
he
> failing case.
>=20
> In the passing case, vdev->num_ctx is 2. In the failing case, it is 1.
>=20
> I am attaching two text files containing trace information from systemtap=
: one for
> the failing case and one for the passing case. They contain a lot more in=
formation
> than is needed, but if you search for vfio_pci_set_msi_trigger and vfio_m=
si_set_block,
> you will see values for some of the call parameters.
>=20
> - Russ
>=20

