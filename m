Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230F15AF970
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 03:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIGBpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 21:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGBpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 21:45:20 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BFD49B77
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 18:45:17 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4MMlSS5b5yz4xP6; Wed,  7 Sep 2022 11:45:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1662515112;
        bh=4ITm6lBWH3aFLLragzXxiwFW53uZ3/R8humKvXd4yfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxHjWiKgLv4Z0yK3EUgO0NL3Gro/a+ky+eFS2zSYBnuDYBEbXdpbXYhzpnb1HbAwn
         PyK4QPz+CFNhSlzzdmEHvEyTwAxQD9e3JLO0HJxRk+b7IJ6btOsed2P5CnngkCONG7
         qGluvDFz7LT5aKWDvnx8XinRac18dcN7Ji6pZoZI=
Date:   Wed, 7 Sep 2022 11:39:51 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 02/13] iommufd: Overview documentation
Message-ID: <Yxf2Z+wVa8Os02Hp@yekko>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n4mH9Jdsyvfl1BEb"
Content-Disposition: inline
In-Reply-To: <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--n4mH9Jdsyvfl1BEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 02, 2022 at 04:59:18PM -0300, Jason Gunthorpe wrote:
> From: Kevin Tian <kevin.tian@intel.com>
>=20
> Add iommufd to the documentation tree.
>=20
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/userspace-api/index.rst   |   1 +
>  Documentation/userspace-api/iommufd.rst | 224 ++++++++++++++++++++++++
>  2 files changed, 225 insertions(+)
>  create mode 100644 Documentation/userspace-api/iommufd.rst
>=20
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/usersp=
ace-api/index.rst
> index a61eac0c73f825..3815f013e4aebd 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -25,6 +25,7 @@ place where this information is gathered.
>     ebpf/index
>     ioctl/index
>     iommu
> +   iommufd
>     media/index
>     sysfs-platform_profile
>     vduse
> diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/user=
space-api/iommufd.rst
> new file mode 100644
> index 00000000000000..38035b3822fd23
> --- /dev/null
> +++ b/Documentation/userspace-api/iommufd.rst
> @@ -0,0 +1,224 @@
> +.. SPDX-License-Identifier: GPL-2.0+
> +
> +=3D=3D=3D=3D=3D=3D=3D
> +IOMMUFD
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +:Author: Jason Gunthorpe
> +:Author: Kevin Tian
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +IOMMUFD is the user API to control the IOMMU subsystem as it relates to =
managing
> +IO page tables that point at user space memory. It intends to be general=
 and
> +consumable by any driver that wants to DMA to userspace. Those drivers a=
re

s/Those/These/

> +expected to deprecate any proprietary IOMMU logic, if existing (e.g.

I don't thing "propietary" is an accurate description.  Maybe
"existing" or "bespoke?

> +vfio_iommu_type1.c).
> +
> +At minimum iommufd provides a universal support of managing I/O address =
spaces
> +and I/O page tables for all IOMMUs, with room in the design to add non-g=
eneric
> +features to cater to specific hardware functionality.
> +
> +In this context the capital letter (IOMMUFD) refers to the subsystem whi=
le the
> +small letter (iommufd) refers to the file descriptors created via /dev/i=
ommu to
> +run the user API over.
> +
> +Key Concepts
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +User Visible Objects
> +--------------------
> +
> +Following IOMMUFD objects are exposed to userspace:
> +
> +- IOMMUFD_OBJ_IOAS, representing an I/O address space (IOAS) allowing ma=
p/unmap
> +  of user space memory into ranges of I/O Virtual Address (IOVA).
> +
> +  The IOAS is a functional replacement for the VFIO container, and like =
the VFIO
> +  container copies its IOVA map to a list of iommu_domains held within i=
t.
> +
> +- IOMMUFD_OBJ_DEVICE, representing a device that is bound to iommufd by =
an
> +  external driver.
> +
> +- IOMMUFD_OBJ_HW_PAGETABLE, wrapping an actual hardware I/O page table (=
i.e. a

s/wrapping/representing/ for consistency.

> +  single struct iommu_domain) managed by the iommu driver.
> +
> +  The IOAS has a list of HW_PAGETABLES that share the same IOVA mapping =
and the
> +  IOAS will synchronize its mapping with each member HW_PAGETABLE.
> +
> +All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
> +
> +Linkage between user-visible objects and external kernel datastructures =
are
> +reflected by dotted line arrows below, with numbers referring to certain

I'm a little bit confused by the reference to "dotted line arrows": I
only see one arrow style in the diagram.

> +operations creating the objects and links::
> +
> +  _________________________________________________________
> + |                         iommufd                         |
> + |       [1]                                               |
> + |  _________________                                      |
> + | |                 |                                     |
> + | |                 |                                     |
> + | |                 |                                     |
> + | |                 |                                     |
> + | |                 |                                     |
> + | |                 |                                     |
> + | |                 |        [3]                 [2]      |
> + | |                 |    ____________         __________  |
> + | |      IOAS       |<--|            |<------|          | |
> + | |                 |   |HW_PAGETABLE|       |  DEVICE  | |
> + | |                 |   |____________|       |__________| |
> + | |                 |         |                   |       |
> + | |                 |         |                   |       |
> + | |                 |         |                   |       |
> + | |                 |         |                   |       |
> + | |                 |         |                   |       |
> + | |_________________|         |                   |       |
> + |         |                   |                   |       |
> + |_________|___________________|___________________|_______|
> +           |                   |                   |
> +           |              _____v______      _______v_____
> +           | PFN storage |            |    |             |
> +           |------------>|iommu_domain|    |struct device|
> +                         |____________|    |_____________|
> +
> +1. IOMMUFD_OBJ_IOAS is created via the IOMMU_IOAS_ALLOC uAPI. One iommuf=
d can
> +   hold multiple IOAS objects. IOAS is the most generic object and does =
not
> +   expose interfaces that are specific to single IOMMU drivers. All oper=
ations
> +   on the IOAS must operate equally on each of the iommu_domains that ar=
e inside
> +   it.
> +
> +2. IOMMUFD_OBJ_DEVICE is created when an external driver calls the IOMMU=
FD kAPI
> +   to bind a device to an iommufd. The external driver is expected to im=
plement
> +   proper uAPI for userspace to initiate the binding operation. Successf=
ul
> +   completion of this operation establishes the desired DMA ownership ov=
er the
> +   device. The external driver must set driver_managed_dma flag and must=
 not
> +   touch the device until this operation succeeds.
> +
> +3. IOMMUFD_OBJ_HW_PAGETABLE is created when an external driver calls the=
 IOMMUFD
> +   kAPI to attach a bound device to an IOAS. Similarly the external driv=
er uAPI
> +   allows userspace to initiate the attaching operation. If a compatible
> +   pagetable already exists then it is reused for the attachment. Otherw=
ise a
> +   new pagetable object (and a new iommu_domain) is created. Successful
> +   completion of this operation sets up the linkages among an IOAS, a de=
vice and
> +   an iommu_domain. Once this completes the device could do DMA.
> +
> +   Every iommu_domain inside the IOAS is also represented to userspace a=
s a
> +   HW_PAGETABLE object.
> +
> +   NOTE: Future additions to IOMMUFD will provide an API to create and
> +   manipulate the HW_PAGETABLE directly.
> +
> +One device can only bind to one iommufd (due to DMA ownership claim) and=
 attach
> +to at most one IOAS object (no support of PASID yet).
> +
> +Currently only PCI device is allowed.
> +
> +Kernel Datastructure
> +--------------------
> +
> +User visible objects are backed by following datastructures:
> +
> +- iommufd_ioas for IOMMUFD_OBJ_IOAS.
> +- iommufd_device for IOMMUFD_OBJ_DEVICE.
> +- iommufd_hw_pagetable for IOMMUFD_OBJ_HW_PAGETABLE.
> +
> +Several terminologies when looking at these datastructures:
> +
> +- Automatic domain, referring to an iommu domain created automatically w=
hen
> +  attaching a device to an IOAS object. This is compatible to the semant=
ics of
> +  VFIO type1.
> +
> +- Manual domain, referring to an iommu domain designated by the user as =
the
> +  target pagetable to be attached to by a device. Though currently no us=
er API
> +  for userspace to directly create such domain, the datastructure and al=
gorithms
> +  are ready for that usage.
> +
> +- In-kernel user, referring to something like a VFIO mdev that is access=
ing the
> +  IOAS and using a 'struct page \*' for CPU based access. Such users req=
uire an
> +  isolation granularity smaller than what an iommu domain can afford. Th=
ey must
> +  manually enforce the IOAS constraints on DMA buffers before those buff=
ers can
> +  be accessed by mdev. Though no kernel API for an external driver to bi=
nd a
> +  mdev, the datastructure and algorithms are ready for such usage.
> +
> +iommufd_ioas serves as the metadata datastructure to manage how IOVA ran=
ges are
> +mapped to memory pages, composed of:
> +
> +- struct io_pagetable holding the IOVA map
> +- struct iopt_areas representing populated portions of IOVA
> +- struct iopt_pages representing the storage of PFNs
> +- struct iommu_domain representing the IO page table in the IOMMU
> +- struct iopt_pages_user representing in-kernel users of PFNs
> +- struct xarray pinned_pfns holding a list of pages pinned by
> +   in-kernel Users
> +
> +The iopt_pages is the center of the storage and motion of PFNs. Each iop=
t_pages
> +represents a logical linear array of full PFNs. PFNs are stored in a tie=
red
> +scheme:
> +
> + 1) iopt_pages::pinned_pfns xarray
> + 2) An iommu_domain
> + 3) The origin of the PFNs, i.e. the userspace pointer

I can't follow what this "tiered scheme" is describing.

> +PFN have to be copied between all combinations of tiers, depending on the
> +configuration (i.e. attached domains and in-kernel users).
> +
> +An io_pagetable is composed of iopt_areas pointing at iopt_pages, along =
with a
> +list of iommu_domains that mirror the IOVA to PFN map.
> +
> +Multiple io_pagetable's, through their iopt_area's, can share a single
> +iopt_pages which avoids multi-pinning and double accounting of page cons=
umption.
> +
> +iommufd_ioas is sharable between subsystems, e.g. VFIO and VDPA, as long=
 as
> +devices managed by different subsystems are bound to a same iommufd.
> +
> +IOMMUFD User API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. kernel-doc:: include/uapi/linux/iommufd.h
> +
> +IOMMUFD Kernel API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The IOMMUFD kAPI is device-centric with group-related tricks managed beh=
ind the
> +scene. This allows the external driver calling such kAPI to implement a =
simple
> +device-centric uAPI for connecting its device to an iommufd, instead of
> +explicitly imposing the group semantics in its uAPI (as VFIO does).
> +
> +.. kernel-doc:: drivers/iommu/iommufd/device.c
> +   :export:
> +
> +VFIO and IOMMUFD
> +----------------
> +
> +Connecting VFIO device to iommufd can be done in two approaches.

s/approaches/ways/

> +
> +First is a VFIO compatible way by directly implementing the /dev/vfio/vf=
io
> +container IOCTLs by mapping them into io_pagetable operations. Doing so =
allows
> +the use of iommufd in legacy VFIO applications by symlinking /dev/vfio/v=
fio to
> +/dev/iommufd or extending VFIO to SET_CONTAINER using an iommufd instead=
 of a
> +container fd.
> +
> +The second approach directly extends VFIO to support a new set of device=
-centric
> +user API based on aforementioned IOMMUFD kernel API. It requires userspa=
ce
> +change but better matches the IOMMUFD API semantics and easier to suppor=
t new
> +iommufd features when comparing it to the first approach.
> +
> +Currently both approaches are still work-in-progress.
> +
> +There are still a few gaps to be resolved to catch up with VFIO type1, as
> +documented in iommufd_vfio_check_extension().
> +
> +Future TODOs
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Currently IOMMUFD supports only kernel-managed I/O page table, similar t=
o VFIO
> +type1. New features on the radar include:
> +
> + - Binding iommu_domain's to PASID/SSID
> + - Userspace page tables, for ARM, x86 and S390
> + - Kernel bypass'd invalidation of user page tables
> + - Re-use of the KVM page table in the IOMMU
> + - Dirty page tracking in the IOMMU
> + - Runtime Increase/Decrease of IOPTE size
> + - PRI support with faults resolved in userspace

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--n4mH9Jdsyvfl1BEb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmMX9mAACgkQgypY4gEw
YSJWUA/9HiyUwCtBooriB5aiYrN8Wi3wnepY4Qoo3fn4i3s/q9/Pm+vUC/m7Y2cs
5ceS+rTgRJHIv2fzXQy8VQ5pWv6ZXWRQU9BZqmYwqEv7XcL7/nF6BbJ/DINVBgC1
VkVXIThLyx+u7/BuUtwaSPBwiIjt5XnoiS4dWj5lJ/JBVt+N1zJhmJH0HodqF6WZ
8XDmbz5to/3UbJuH++dx3ZGnAD7waw7nj/Pf7a/rGkoOjTSkHz7IH5bHpqNZuV/n
XRXxgTL3EvtSk8ghLpveXVAgefgT4fyslr8Os3h/xrrsne9G0irRO/1BOwB6Cc4L
GkNb/JCj+H5vIhnOBLaKKJJ/SM5bdX7xUrf6dCM7EH/LOjanZ+QVlPcjr2dY6Y8c
btPmUqJlH2PI73khr3Q8cdQMk7vOnnBvdkRasBsfqNKKKxmA3DqNcKeCrFSg1ft1
MRo3sQd32OvHy/4dUMmpYbMXL+WnStL1GlZsHuJubMGO8sy91u3lGuBNYPoVO1oX
6xuSHh1eo9+6sVsIp2jFYUw+ujnoihFqdKKxFCPhsfLUpUW3Dc0pWOA63f6gHyHl
ha3ei32Ve1YBvMyzFaQbyhRYKPbqZJBe5XSpa0/+PnWu9sdaZ9FVla7e4p79g3lT
9KM0o5RQXZzybThj5LLXUL/XfV4vTDrnrWHRx9C/wXEEfswOamU=
=dWx0
-----END PGP SIGNATURE-----

--n4mH9Jdsyvfl1BEb--
