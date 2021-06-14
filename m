Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6073A3A6E4F
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhFNSpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 14:45:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232802AbhFNSo7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 14:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623696175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYPULGJaxNrE7OW2+HTX1onKHypT59LT86+cAi5+zC8=;
        b=AUXqUyDZogW9wHmRXEuCh0kzIFbX0tEjwuPKx3X9kTwg5Dy606/vEdjG2boaImrVMBGBTW
        jI6jlLvpRKI8zDbAaS/lN2XxEUvMQAOotmrsXBiy+rZZU0Nc+VaXmHyh7revQ8BmA+XEnd
        ZKXregDozc/Jwyj4fubvr9WLt3/F3/s=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-sMj9CFOZNyOgEOBR7OgWaA-1; Mon, 14 Jun 2021 14:42:54 -0400
X-MC-Unique: sMj9CFOZNyOgEOBR7OgWaA-1
Received: by mail-ot1-f69.google.com with SMTP id k11-20020a056830242bb0290400324955afso7806786ots.14
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 11:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tYPULGJaxNrE7OW2+HTX1onKHypT59LT86+cAi5+zC8=;
        b=lRHF85eGFcY7c53NaEZCW41t24unZ0PSwvQbLkiWLW8voXGEgZSXy45X3ywIPvFTct
         YpXaLNSs2+ozMeLLQgmmFcGyaLZcoZVP6BT285EwBUCircLYtlEjjKZ+k6PvLODnp2N+
         F3nwxmfQa2I9shs27vc19mF2zn8jFSqzKyu6v6ogtK8oi2sym1e/bEID7mLq8IyX+T2R
         V4acVVfXtEZsvTiMpIO7y24epcc2sX8zhuxfg4l7EG9Hd6P4E4pmry884lLZ4KE2dk84
         kw4CDQ9HPPlAycds9pATVjAUO8coDfd1dtoAp/InEgQWqQW1Mw0c1N0Fsu3JLLiuBkKU
         V+sg==
X-Gm-Message-State: AOAM532eINUTdWxUkXrTsRLimGPdzg9JOEB1jIPSqDpH6w6Qyboz9RS3
        iM/rXbikhLVxxzW62DyQs5/NLYREG5kTpZaEdfukZ5LrwlfF0PBXZbYk0AmntLWe3jmvDH53IzL
        yfq3u2aKJQm3J
X-Received: by 2002:a05:6830:2476:: with SMTP id x54mr14672486otr.293.1623696173803;
        Mon, 14 Jun 2021 11:42:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzySs6LU2JHVe6vycK52lrxMvVRLCBOGMepzyqQPlZ6Jiia1Sb3dldrBYFR/i4+kUid/t1iDA==
X-Received: by 2002:a05:6830:2476:: with SMTP id x54mr14672464otr.293.1623696173516;
        Mon, 14 Jun 2021 11:42:53 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a7sm3265107ooo.9.2021.06.14.11.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 11:42:53 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:42:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210614124250.0d32537c.alex.williamson@redhat.com>
In-Reply-To: <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-10-mgurtovoy@nvidia.com>
        <20210608152643.2d3400c1.alex.williamson@redhat.com>
        <20210608224517.GQ1002214@nvidia.com>
        <20210608192711.4956cda2.alex.williamson@redhat.com>
        <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 13 Jun 2021 11:19:46 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 6/9/2021 4:27 AM, Alex Williamson wrote:
> > On Tue, 8 Jun 2021 19:45:17 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > =20
> >> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote: =20
> >>>> drivers that specifically opt into this feature and the driver now h=
as
> >>>> the opportunity to provide a proper match table that indicates what =
HW
> >>>> it can properly support. vfio-pci continues to support everything. =
=20
> >>> In doing so, this also breaks the new_id method for vfio-pci. =20
> >> Does it? How? The driver_override flag is per match entry not for the
> >> entire device so new_id added things will work the same as before as
> >> their new match entry's flags will be zero. =20
> > Hmm, that might have been a testing issue; combining driverctl with
> > manual new_id testing might have left a driver_override in place.
> >    =20
> >>> Sorry, with so many userspace regressions, crippling the
> >>> driver_override interface with an assumption of such a narrow focus,
> >>> creating a vfio specific match flag, I don't see where this can go.
> >>> Thanks, =20
> >> On the other hand it overcomes all the objections from the last go
> >> round: how userspace figures out which driver to use with
> >> driver_override and integrating the universal driver into the scheme.
> >>
> >> pci_stub could be delt with by marking it for driver_override like
> >> vfio_pci. =20
> > By marking it a "vfio driver override"? :-\
> > =20
> >> But driverctl as a general tool working with any module is not really
> >> addressable.
> >>
> >> Is the only issue the blocking of the arbitary binding? That is not a
> >> critical peice of this, IIRC =20
> > We can't break userspace, which means new_id and driver_override need
> > to work as they do now.  There are scads of driver binding scripts in
> > the wild, for vfio-pci and other drivers.  We can't assume such a
> > narrow scope.  Thanks, =20
>=20
> what about the following code ?
>=20
> @@ -152,12 +152,28 @@ static const struct pci_device_id=20
> *pci_match_device(struct pci_driver *drv,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&drv->dynids.lock=
);
>=20
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!found_id)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 found_id =3D pci_match_id(drv->id_table, dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_id)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return found_id;

a) A dynamic ID match always works regardless of driver override...

>=20
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* driver_override will always matc=
h, send a dummy id */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!found_id && dev->driver_overri=
de)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 found_id =3D pci_match_id(drv->id_t=
able, dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (found_id) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * if we found id in the static table, we must fulfill the
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * matching flags (i.e. if PCI_ID_F_DRIVER_OVERRIDE flag =
is
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * set, driver_override should be provided).
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 bool is_driver_override =3D
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (found_id->fla=
gs & PCI_ID_F_DRIVER_OVERRIDE) !=3D 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if ((is_driver_override && !dev->driver_override) ||

b) A static ID match fails if the driver provides an override flag and
the device does not have an override set, or...=20

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (dev->driver_override && !is_driver_ov=
erride))

c) The device has an override set and the driver does not support the
override flag.

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (dev->driver_override) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * if we didn't find suitable id in the static table,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 * driver_override will still , send a dummy id
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 found_id =3D &pci_device_id_any;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return found_id;
>  =C2=A0}
>=20
>=20
> dynamic ids (new_id) works as before.
>=20
> Old driver_override works as before.

This is deceptively complicated, but no, I don't believe it does.  By
my understanding of c) an "old" driver can no longer use
driver_override for binding a known device.  It seems that if we have a
static ID match, then we cannot have a driver_override set for the
device in such a case.  This is a userspace regression.

> For "new" driver_override we must fulfill the new rules.

For override'able drivers, the static table is almost useless other
than using it for modules.alias support and potentially to provide
driver_data.  As above, I find this all pretty confusing and I'd advise
trying to write a concise set of rules outlining the behavior of
driver_override vs dynamic IDs vs static IDs vs "override'able" driver
flags.  I tried, I can't, it's convoluted and full of exceptions.
Thanks,

Alex

