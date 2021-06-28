Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC33B6AF8
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhF1WeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234540AbhF1WeQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 18:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624919509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8XGtEdANUVt2mXeyRNxrhe0L7TYkYXWNRbYkehzeNA=;
        b=fmDdCcYJAbkdCVPL0xcmjVG4hSJzTsykrtsfdV7pqHUDHa+yqmdscpITp9vcvcUDeyxKoJ
        z4MKAw/XzIbVsWqb5l5Ef1Q7NbDhjqDgV4ca+Yp0WB+le88kKnB5w7eeHbB4179LsBCGiy
        CaAoa/Agb23QV/OT/lheMU7Pxz5Xm0U=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-E3Xy7-l4OW-NvLqTRaIKoQ-1; Mon, 28 Jun 2021 18:31:48 -0400
X-MC-Unique: E3Xy7-l4OW-NvLqTRaIKoQ-1
Received: by mail-oo1-f72.google.com with SMTP id 127-20020a4a15850000b029024c83573b9dso3480703oon.23
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8XGtEdANUVt2mXeyRNxrhe0L7TYkYXWNRbYkehzeNA=;
        b=KyZ37HMZ1MlYTWtxmSS2t3RPssss9I5g7uUzwdFXuduOE8lTiVmM0eaZAbzhEaZNou
         5A/1yE0K24E5oaNABk92rw+DeXadfz4+RPEx0ppH/2VqdjY6VmT+DlNTsFWlDK/U5aBw
         JrOs+XYO9BexMoflrXBgwj7H43cKeOuyogR66I7JTCxxtJHV0jD+obQ//yjBRbsnR5s6
         pHIBnfibXOYfy++8TveuN2+jyqHKYxe8lQvABheSGsc8IIaJHNNausTiYberfYYZx6F2
         BXEB3ijXOszgKSf75QIAm3ObMLPMl10p+0I4TVI99gmJY9tbJU8JF36WD2DyBXZddbpJ
         QoAw==
X-Gm-Message-State: AOAM533mS0NfQGW5eYRZ7gk0+gQCxChtMxQIvaIzCggmEpiSfjYZ6J3h
        wYFwL+ofR1vZpDdEsGDi21mOcnm4WFfRjceD9Z22aojfPIyagdfawqypbnjQhsYWJkuIhFf7kUa
        ZbqImbe2ZxmF+
X-Received: by 2002:a9d:6219:: with SMTP id g25mr1586540otj.262.1624919507662;
        Mon, 28 Jun 2021 15:31:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyseKceU6IT0HP1k2nx0wDzLm7HSSZMWZSAeWgAdz0mPZZLAzQ4VusQyiwpVah22Rg3tvX5pA==
X-Received: by 2002:a9d:6219:: with SMTP id g25mr1586520otj.262.1624919507429;
        Mon, 28 Jun 2021 15:31:47 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p18sm1091723oth.60.2021.06.28.15.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:31:47 -0700 (PDT)
Date:   Mon, 28 Jun 2021 16:31:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210628163145.1a21cca9.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210617151452.08beadae.alex.williamson@redhat.com>
        <20210618001956.GA1987166@nvidia.com>
        <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210618182306.GI1002214@nvidia.com>
        <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210625143616.GT2371267@nvidia.com>
        <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Jun 2021 01:09:18 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, June 25, 2021 10:36 PM
> >=20
> > On Fri, Jun 25, 2021 at 10:27:18AM +0000, Tian, Kevin wrote:
> >  =20
> > > -   When receiving the binding call for the 1st device in a group, io=
mmu_fd
> > >     calls iommu_group_set_block_dma(group, dev->driver) which does
> > >     several things: =20
> >=20
> > The whole problem here is trying to match this new world where we want
> > devices to be in charge of their own IOMMU configuration and the old
> > world where groups are in charge.
> >=20
> > Inserting the group fd and then calling a device-centric
> > VFIO_GROUP_GET_DEVICE_FD_NEW doesn't solve this conflict, and isn't
> > necessary.  =20
>=20
> No, this was not what I meant. There is no group fd required when
> calling this device-centric interface. I was actually talking about:
>=20
> 	iommu_group_set_block_dma(dev->group, dev->driver)
>=20
> just because current iommu layer API is group-centric. Whether this
> should be improved could be next-level thing. Sorry for not making
> it clear in the first place.
>=20
> > We can always get the group back from the device at any
> > point in the sequence do to a group wide operation. =20
>=20
> yes.
>=20
> >=20
> > What I saw as the appeal of the sort of idea was to just completely
> > leave all the difficult multi-device-group scenarios behind on the old
> > group centric API and then we don't have to deal with them at all, or
> > least not right away. =20
>=20
> yes, this is the staged approach that we discussed earlier. and
> the reason why I refined this proposal about multi-devices group=20
> here is because you want to see some confidence along this
> direction. Thus I expanded your idea and hope to achieve consensus
> with Alex/Joerg who obviously have not been convinced yet.
>=20
> >=20
> > I'd see some progression where iommu_fd only works with 1:1 groups at
> > the start. Other scenarios continue with the old API. =20
>=20
> One uAPI open after completing this new sketch. v1 proposed to
> conduct binding (VFIO_BIND_IOMMU_FD) after device_fd is acquired.
> With this sketch we need a new VFIO_GROUP_GET_DEVICE_FD_NEW
> to complete both in one step. I want to get Alex's confirmation whether
> it sounds good to him, since it's better to unify the uAPI between 1:1=20
> group and 1:N group even if we don't support 1:N in the start.=20

I don't like it.  It doesn't make sense to me.  You have the
group-centric world, which must continue to exist and cannot change
because we cannot break the vfio uapi.  We can make extensions, we can
define a new parallel uapi, we can deprecate the uapi, but in the short
term, it can't change.

AIUI, the new device-centric model starts with vfio device files that
can be opened directly.  So what then is the purpose of a *GROUP* get
device fd?  Why is a vfio uapi involved in setting a device cookie for
another subsystem?

I'd expect that /dev/iommu will be used by multiple subsystems.  All
will want to bind devices to address spaces, so shouldn't binding a
device to an iommufd be an ioctl on the iommufd, ie.
IOMMU_BIND_VFIO_DEVICE_FD.  Maybe we don't even need "VFIO" in there and
the iommufd code can figure it out internally.

You're essentially trying to reduce vfio to the device interface.  That
necessarily implies that ioctls on the container, group, or passed
through the container to the iommu no longer exist.  From my
perspective, there should ideally be no new vfio ioctls.  The user gets
a limited access vfio device fd and enables full access to the device
by registering it to the iommufd subsystem (100% this needs to be
enforced until close() to avoid revoke issues).  The user interacts
exclusively with vfio via the device fd and performs all DMA address
space related operations through the iommufd.

> > Then maybe groups where all devices use the same IOASID.
> >=20
> > Then 1:N groups if the source device is reliably identifiable, this
> > requires iommu subystem work to attach domains to sub-group objects -
> > not sure it is worthwhile.
> >=20
> > But at least we can talk about each step with well thought out patches
> >=20
> > The only thing that needs to be done to get the 1:1 step is to broadly
> > define how the other two cases will work so we don't get into trouble
> > and set some way to exclude the problematic cases from even getting to
> > iommu_fd in the first place.
> >=20
> > For instance if we go ahead and create /dev/vfio/device nodes we could
> > do this only if the group was 1:1, otherwise the group cdev has to be
> > used, along with its API. =20
>=20
> I feel for VFIO possibly we don't need significant change to its uAPI=20
> sequence, since it anyway needs to support existing semantics for=20
> backward compatibility. With this sketch we can keep vfio container/
> group by introducing an external iommu type which implies a different
> GET_DEVICE_FD semantics. /dev/iommu can report a fd-wide capability
> for whether 1:N group is supported to vfio user.

Ideally vfio would also at least be able to register a type1 IOMMU
backend through the existing uapi, backed by this iommu code, ie. we'd
create a new "iommufd" (but without the user visible fd), bind all the
group devices to it, generating our own device cookies, create a single
ioasid and attach all the devices to it (all internal).  When using the
compatibility mode, userspace doesn't get device cookies, doesn't get
an iommufd, they do mappings through the container, where vfio owns the
cookies and ioasid.
=20
> For new subsystems they can directly create device nodes and rely on
> iommu fd to manage group isolation, without introducing any group=20
> semantics in its uAPI.

Create device nodes, bind them to iommufd, associate cookies, attach
ioasids, etc.  That should be the same for all subsystems, including
vfio, it's just the magic internal handshake between the device
subsystem and the iommufd subsystem that changes.

> > >         a) Check group viability. A group is viable only when all dev=
ices in
> > >             the group are in one of below states:
> > >
> > >                 * driver-less
> > >                 * bound to a driver which is same as dev->driver (vfi=
o in this case)
> > >                 * bound to an otherwise allowed driver (same list as =
in vfio) =20
> >=20
> > This really shouldn't use hardwired driver checks. Attached drivers
> > should generically indicate to the iommu layer that they are safe for
> > iommu_fd usage by calling some function around probe() =20
>=20
> good idea.
>=20
> >=20
> > Thus a group must contain only iommu_fd safe drivers, or drivers-less
> > devices before any of it can be used. It is the more general
> > refactoring of what VFIO is doing.
> >  =20
> > >         c) The iommu layer also verifies group viability on BUS_NOTIF=
Y_
> > >             BOUND_DRIVER event. BUG_ON if viability is broken while =
=20
> > block_dma =20
> > >             is set. =20
> >=20
> > And with this concept of iommu_fd safety being first-class maybe we
> > can somehow eliminate this gross BUG_ON (and the 100's of lines of
> > code that are used to create it) by denying probe to non-iommu-safe
> > drivers, somehow. =20
>=20
> yes.
>=20
> >  =20
> > > -   Binding other devices in the group to iommu_fd just succeeds since
> > >     the group is already in block_dma. =20
> >=20
> > I think the rest of this more or less describes the device centric
> > logic for multi-device groups we've already talked about. I don't
> > think it benifits from having the group fd
> >  =20
>=20
> sure. All of this new sketch doesn't have group fd in any iommu fd
> API. Just try to elaborate a full sketch to sync the base.
>=20
> Alex/Joerg, look forward to your thoughts now. =F0=9F=98=8A

Some provided.  Thanks,

Alex

