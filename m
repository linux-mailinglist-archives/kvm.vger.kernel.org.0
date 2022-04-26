Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F951033C
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347494AbiDZQZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241979AbiDZQZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AB87161BB7
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650990124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zGZ0c19UOYNIFPHkBnm5Z4ZDrm/gdum8i5HQX1C3eZw=;
        b=Q4NJCcNHq1qf/sFUefYjqTK0O4Mx/cOlg2OSEAjsjv0UEUoilKhk/riUQw24zvzu3o0Xn4
        g29lxVMvGcAHJEYUkyZkPZXChT+TuZVCI4JLTiP64JW7pL8bPpkHW4H/hKOLduOhx3wUSd
        D2SqkMQj0LWxHo/rT0HFb3m+13psKC4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-q2vPZ06OPgG14ZFXQdFGVw-1; Tue, 26 Apr 2022 12:22:03 -0400
X-MC-Unique: q2vPZ06OPgG14ZFXQdFGVw-1
Received: by mail-io1-f70.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so14582419ioo.0
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zGZ0c19UOYNIFPHkBnm5Z4ZDrm/gdum8i5HQX1C3eZw=;
        b=394qH3uSVf7BnZpTdW+WEjrEbCyxYgo0ab6GAb6EulR3oPg0Q9aI/hRJhD+idpI+TD
         +oTiWtT//+0kKHS4LyQbHBTkU4iwGGLVRU5kdvRKp5+42Uj/Sk94ZPSW8h9M7xVb7R2U
         zkyKKyR44J7BoGXX7N9RVprh+9EQQx60qB9/chhbPmu9l7xEPWkjScLG8ODCWxobt/Hq
         Q60p7lZx8YS4A8xuembZ4WWqS3SEfudqilqKkcUpWiixCkCvfxER1ae3i+UqjkWhm93E
         TDJtKgee+oqEcN3/sXgNcLeoD0s76p7mPyohu8svhwnlq3TfmlHjha28ZkrUGxx0gD4C
         gGuw==
X-Gm-Message-State: AOAM530gOyp+jgACz/Vl+/lzokcLk+wb98hp8uyq41AIO1lfMycaguKW
        yWMlwQmfSs2dvecMbjX33i8u2HF/vSVcmxmH14+SAN/Em1MtyodwvQk1kPJ+gX3BqAhORSE0tMr
        VPq98E/jnJEMY
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id j19-20020a056638053300b0032ad418b77bmr6808538jar.237.1650990122423;
        Tue, 26 Apr 2022 09:22:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwxxqc4dnDfzNCYOy8s/UWECcXyiOBGUZLjbvVuUOPPjs8DjJRfoZC8Wcsr08kyrWwg6nGWA==
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id j19-20020a056638053300b0032ad418b77bmr6808517jar.237.1650990122069;
        Tue, 26 Apr 2022 09:22:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o19-20020a056e0214d300b002cbec3af6casm8316098ilk.30.2022.04.26.09.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 09:22:01 -0700 (PDT)
Date:   Tue, 26 Apr 2022 10:21:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220426102159.5ece8c1f.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
        <20220425083748.3465c50f.alex.williamson@redhat.com>
        <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 08:37:41 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Monday, April 25, 2022 10:38 PM
> >=20
> > On Mon, 25 Apr 2022 11:10:14 +0100
> > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> >  =20
> > > On Fri, Apr 22, 2022 at 04:09:43PM -0600, Alex Williamson wrote: =20
> > > > [Cc +libvirt folks]
> > > >
> > > > On Thu, 14 Apr 2022 03:46:52 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > =20
> > > > > With the introduction of iommufd[1], the linux kernel provides a =
=20
> > generic =20
> > > > > interface for userspace drivers to propagate their DMA mappings t=
o =20
> > kernel =20
> > > > > for assigned devices. This series does the porting of the VFIO de=
vices
> > > > > onto the /dev/iommu uapi and let it coexist with the legacy =20
> > implementation. =20
> > > > > Other devices like vpda, vfio mdev and etc. are not considered ye=
t. =20
> > >
> > > snip
> > > =20
> > > > > The selection of the backend is made on a device basis using the =
new
> > > > > iommufd option (on/off/auto). By default the iommufd backend is =
=20
> > selected =20
> > > > > if supported by the host and by QEMU (iommufd KConfig). This opti=
on =20
> > is =20
> > > > > currently available only for the vfio-pci device. For other types=
 of
> > > > > devices, it does not yet exist and the legacy BE is chosen by def=
ault. =20
> > > >
> > > > I've discussed this a bit with Eric, but let me propose a different
> > > > command line interface.  Libvirt generally likes to pass file
> > > > descriptors to QEMU rather than grant it access to those files
> > > > directly.  This was problematic with vfio-pci because libvirt can't
> > > > easily know when QEMU will want to grab another /dev/vfio/vfio
> > > > container.  Therefore we abandoned this approach and instead libvirt
> > > > grants file permissions.
> > > >
> > > > However, with iommufd there's no reason that QEMU ever needs more =
=20
> > than =20
> > > > a single instance of /dev/iommufd and we're using per device vfio f=
ile
> > > > descriptors, so it seems like a good time to revisit this. =20
> > >
> > > I assume access to '/dev/iommufd' gives the process somewhat elevated
> > > privileges, such that you don't want to unconditionally give QEMU
> > > access to this device ? =20
> >=20
> > It's not that much dissimilar to /dev/vfio/vfio, it's an unprivileged
> > interface which should have limited scope for abuse, but more so here
> > the goal would be to de-privilege QEMU that one step further that it
> > cannot open the device file itself.
> >  =20
> > > > The interface I was considering would be to add an iommufd object to
> > > > QEMU, so we might have a:
> > > >
> > > > -device iommufd[,fd=3D#][,id=3Dfoo]
> > > >
> > > > For non-libivrt usage this would have the ability to open /dev/iomm=
ufd
> > > > itself if an fd is not provided.  This object could be shared with
> > > > other iommufd users in the VM and maybe we'd allow multiple instanc=
es
> > > > for more esoteric use cases.  [NB, maybe this should be a -object r=
ather =20
> > than =20
> > > > -device since the iommufd is not a guest visible device?] =20
> > >
> > > Yes,  -object would be the right answer for something that's purely
> > > a host side backend impl selector.
> > > =20
> > > > The vfio-pci device might then become:
> > > >
> > > > -device vfio- =20
> > pci[,host=3DDDDD:BB:DD.f][,sysfsdev=3D/sys/path/to/device][,fd=3D#][,io=
mmufd=3Df
> > oo] =20
> > > >
> > > > So essentially we can specify the device via host, sysfsdev, or pas=
sing
> > > > an fd to the vfio device file.  When an iommufd object is specified,
> > > > "foo" in the example above, each of those options would use the
> > > > vfio-device access mechanism, essentially the same as iommufd=3Don =
in
> > > > your example.  With the fd passing option, an iommufd object would =
be
> > > > required and necessarily use device level access.
> > > >
> > > > In your example, the iommufd=3Dauto seems especially troublesome for
> > > > libvirt because QEMU is going to have different locked memory
> > > > requirements based on whether we're using type1 or iommufd, where =
=20
> > the =20
> > > > latter resolves the duplicate accounting issues.  libvirt needs to =
know =20
>=20
> Based on current plan there is probably a transition window between the
> point where the first vfio device type (vfio-pci) gaining iommufd support
> and the point where all vfio types supporting iommufd. Libvirt can figure
> out which one to use iommufd by checking the presence of
> /dev/vfio/devices/vfioX. But what would be the resource limit policy
> in Libvirt in such transition window when both type1 and iommufd might
> be used? Or do we just expect Libvirt to support iommufd only after the
> transition window ends to avoid handling such mess?

Good point regarding libvirt testing for the vfio device files for use
with iommufd, so libvirt would test if /dev/iommufd exists and if the
device they want to assign maps to a /dev/vfio/devices/vfioX file.  This
was essentially implicit in the fd=3D# option to the vfio-pci device.

In mixed combinations, I'd expect libvirt to continue to add the full
VM memory to the locked memory limit for each non-iommufd device added.

> > > > deterministically which backed is being used, which this proposal s=
eems
> > > > to provide, while at the same time bringing us more in line with fd
> > > > passing.  Thoughts?  Thanks, =20
> > >
> > > Yep, I agree that libvirt needs to have more direct control over this.
> > > This is also even more important if there are notable feature differe=
nces
> > > in the 2 backends.
> > >
> > > I wonder if anyone has considered an even more distinct impl, whereby
> > > we have a completely different device type on the backend, eg
> > >
> > >   -device vfio-iommu- =20
> > pci[,host=3DDDDD:BB:DD.f][,sysfsdev=3D/sys/path/to/device][,fd=3D#][,io=
mmufd=3Df
> > oo] =20
> > >
> > > If a vendor wants to fully remove the legacy impl, they can then use =
the
> > > Kconfig mechanism to disable the build of the legacy impl device, whi=
le
> > > keeping the iommu impl (or vica-verca if the new iommu impl isn't =20
> > considered =20
> > > reliable enough for them to support yet).
> > >
> > > Libvirt would use
> > >
> > >    -object iommu,id=3Diommu0,fd=3DNNN
> > >    -device vfio-iommu-pci,fd=3DMMM,iommu=3Diommu0
> > >
> > > Non-libvirt would use a simpler
> > >
> > >    -device vfio-iommu-pci,host=3D0000:03:22.1
> > >
> > > with QEMU auto-creating a 'iommu' object in the background.
> > >
> > > This would fit into libvirt's existing modelling better. We currently=
 have
> > > a concept of a PCI assignment backend, which previously supported the
> > > legacy PCI assignment, vs the VFIO PCI assignment. This new iommu impl
> > > feels like a 3rd PCI assignment approach, and so fits with how we mod=
elled
> > > it as a different device type in the past. =20
> >=20
> > I don't think we want to conflate "iommu" and "iommufd", we're creating
> > an object that interfaces into the iommufd uAPI, not an iommu itself.
> > Likewise "vfio-iommu-pci" is just confusing, there was an iommu
> > interface previously, it's just a different implementation now and as
> > far as the VM interface to the device, it's identical.  Note that a
> > "vfio-iommufd-pci" device multiplies the matrix of every vfio device
> > for a rather subtle implementation detail.
> >=20
> > My expectation would be that libvirt uses:
> >=20
> >  -object iommufd,id=3Diommufd0,fd=3DNNN
> >  -device vfio-pci,fd=3DMMM,iommufd=3Diommufd0
> >=20
> > Whereas simple QEMU command line would be:
> >=20
> >  -object iommufd,id=3Diommufd0
> >  -device vfio-pci,iommufd=3Diommufd0,host=3D0000:02:00.0
> >=20
> > The iommufd object would open /dev/iommufd itself.  Creating an
> > implicit iommufd object is someone problematic because one of the
> > things I forgot to highlight in my previous description is that the
> > iommufd object is meant to be shared across not only various vfio
> > devices (platform, ccw, ap, nvme, etc), but also across subsystems, ex.
> > vdpa. =20
>=20
> Out of curiosity - in concept one iommufd is sufficient to support all
> ioas requirements across subsystems while having multiple iommufd's
> instead lose the benefit of centralized accounting. The latter will also
> cause some trouble when we start virtualizing ENQCMD which requires
> VM-wide PASID virtualization thus further needs to share that=20
> information across iommufd's. Not unsolvable but really no gain by
> adding such complexity. So I'm curious whether Qemu provide
> a way to restrict that certain object type can only have one instance
> to discourage such multi-iommufd attempt?

I don't see any reason for QEMU to restrict iommufd objects.  The QEMU
philosophy seems to be to let users create whatever configuration they
want.  For libvirt though, the assumption would be that a single
iommufd object can be used across subsystems, so libvirt would never
automatically create multiple objects.

We also need to be able to advise libvirt as to how each iommufd object
or user of that object factors into the VM locked memory requirement.
When used by vfio-pci, we're only mapping VM RAM, so we'd ask libvirt
to set the locked memory limit to the size of VM RAM per iommufd,
regardless of the number of devices using a given iommufd.  However, I
don't know if all users of iommufd will be exclusively mapping VM RAM.
Combinations of devices where some map VM RAM and others map QEMU
buffer space could still require some incremental increase per device
(I'm not sure if vfio-nvme is such a device).  It seems like heuristics
will still be involved even after iommufd solves the per-device
vfio-pci locked memory limit issue.  Thanks,

Alex

