Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4211F93BD
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgFOJlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgFOJlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 05:41:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F23C061A0E;
        Mon, 15 Jun 2020 02:41:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r9so13938946wmh.2;
        Mon, 15 Jun 2020 02:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KX2ULwgHf9kOaWMhPVMslim8oE0KSCOv/pZ2klCyRGI=;
        b=MADKiMUvO5q+6PpA7O/3H1wZ356C+bn7YJCQLTnaUNSoHutxT+2j5eIE9ZkXJ+DWxi
         NPrNRkA7Qdfa8fRr1zoKHDZTaZQLLGM1Ttq8bcuqecfCz/x3VhjouNbfQd08q6QLw2PY
         iNNqd0yr1mQvOJ0mN2hoblfClSj1xRs5n1jd9khVou1+7h9W2TT1NHEgxDTQgptOYJ53
         i2iJmywNJC9aksGIjW+YdbRYdKSB7uUCgPElSqa+ITDHQ0gXm+tRkTSxHS0wtwWvJ5/S
         dI2aUdQLDhB0Yj+9pWpcew4a9wV9L2cRkb/ti/IyjfoG6xrcZgOisuQsMrCj6nGtO+AN
         y/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KX2ULwgHf9kOaWMhPVMslim8oE0KSCOv/pZ2klCyRGI=;
        b=ZK7y791GRTOhIMT+wCh4lsiMS5rxMuPOxbtidI9QY3mBQH35np0lNa7IyDsL0cF/Yk
         uMHAfJH3v1y4RhtD7UAyEFKEV3jBj/71WPBADAnBmZm+I28ssjeTpeTCNBgaeyOm6CMH
         u/lLcAIqNwVWqcG/UM6z4RFeargx6jbn1e2Z1zDJAAD2L2zZC/FgN+yWSH6kb10wyPuP
         GmXaZtsEouMcAH4rrJyFWFZSFsDVOOEV2ioa3DiGvAIJ0zrO2mFOanybBlYMat0mlSt/
         Hf27ZN//L3qqZCliFqG7Pm34TcxdLUf4u+3+v+nftLbGFfFH6/Fi1reTGcFblOVOVtjs
         ZeAg==
X-Gm-Message-State: AOAM532bw21YInEt97tRc+tbYQqhTgr1lacwxpyC1UPj2BMxvaRpZ8cV
        6e0S98ucF0pJ/Qw19t4gTvg=
X-Google-Smtp-Source: ABdhPJyVaVd7y3qPeu+QQyc6wGoty9uDZd9oVpwHAHUFCZmUiI3IHbcATQ+TsPgQKHhygmoNJ17xlA==
X-Received: by 2002:a1c:6006:: with SMTP id u6mr12071103wmb.39.1592214090818;
        Mon, 15 Jun 2020 02:41:30 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b8sm24305884wrs.36.2020.06.15.02.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 02:41:29 -0700 (PDT)
Date:   Mon, 15 Jun 2020 10:41:28 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/15] vfio: Document dual stage control
Message-ID: <20200615094128.GB1491454@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <1591877734-66527-15-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <1591877734-66527-15-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2020 at 05:15:33AM -0700, Liu Yi L wrote:
> From: Eric Auger <eric.auger@redhat.com>
>=20
> The VFIO API was enhanced to support nested stage control: a bunch of
> new iotcls and usage guideline.
>=20
> Let's document the process to follow to set up nested mode.
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
> v1 -> v2:
> *) new in v2, compared with Eric's original version, pasid table bind
>    and fault reporting is removed as this series doesn't cover them.
>    Original version from Eric.
>    https://lkml.org/lkml/2020/3/20/700
>=20
>  Documentation/driver-api/vfio.rst | 64 +++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 64 insertions(+)
>=20
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api=
/vfio.rst
> index f1a4d3c..06224bd 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -239,6 +239,70 @@ group and can access them as follows::
>  	/* Gratuitous device reset and go... */
>  	ioctl(device, VFIO_DEVICE_RESET);
> =20
> +IOMMU Dual Stage Control
> +------------------------
> +
> +Some IOMMUs support 2 stages/levels of translation. Stage corresponds to
> +the ARM terminology while level corresponds to Intel's VTD terminology.
> +In the following text we use either without distinction.
> +
> +This is useful when the guest is exposed with a virtual IOMMU and some
> +devices are assigned to the guest through VFIO. Then the guest OS can use
> +stage 1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage 2 for
> +VM isolation (GPA -> HPA).
> +
> +Under dual stage translation, the guest gets ownership of the stage 1 pa=
ge
> +tables and also owns stage 1 configuration structures. The hypervisor ow=
ns
> +the root configuration structure (for security reason), including stage 2
> +configuration. This works as long configuration structures and page table

s/as long configuration/as long as configuration/

> +format are compatible between the virtual IOMMU and the physical IOMMU.

s/format/formats/

> +
> +Assuming the HW supports it, this nested mode is selected by choosing the
> +VFIO_TYPE1_NESTING_IOMMU type through:
> +
> +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> +
> +This forces the hypervisor to use the stage 2, leaving stage 1 available
> +for guest usage. The guest stage 1 format depends on IOMMU vendor, and
> +it is the same with the nesting configuration method. User space should
> +check the format and configuration method after setting nesting type by
> +using:
> +
> +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> +
> +Details can be found in Documentation/userspace-api/iommu.rst. For Intel
> +VT-d, each stage 1 page table is bound to host by:
> +
> +    nesting_op->flags =3D VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GPA.
> +GVA->GPA page tables are available when PASID (Process Address Space ID)
> +is exposed to guest. e.g. guest with PASID-capable devices assigned. For
> +such page table binding, the bind_data should include PASID info, which
> +is allocated by guest itself or by host. This depends on hardware vendor
> +e.g. Intel VT-d requires to allocate PASID from host. This requirement is
> +available by VFIO_IOMMU_GET_INFO. User space could allocate PASID from
> +host by:
> +
> +    req.flags =3D VFIO_IOMMU_ALLOC_PASID;
> +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);

It is not clear how the userspace application determines whether PASIDs
must be allocated from the host via VFIO_IOMMU_PASID_REQUEST or if the
guest itself can allocate PASIDs. The text mentions VFIO_IOMMU_GET_INFO
but what exactly should the userspace application check?

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7nQkgACgkQnKSrs4Gr
c8jZ0gf/XFjQsLCysIADPfVm33C/7VK8W+efHOrirtgQ8Hq2FEuki7UjwGgs933f
RRuvRaPuVCeVMuM9pEXT7uZyAVNS8uKoTVv0Z0gzQsRv/wNHKH6SrgW+n+o6Yhyo
6z200NLZZ9HrIt7J5cCYEqLv56KVSam5UfaX1LJMBF1I9YFNF7mo4oE12RJ69sT4
f3cjbmN3DmUpuB4AhVxYxn6/cdE5nFa3wkxqFE68yExNbNjcvUvZumLbEiQnEZYW
c4BVsNb71Q76yXB340m6RN4fU5pcS91eK9XAiDdPGYHtdFGNbSGA6Iadj8vbz++c
qlxF2QhlrFHPiXHRgrnzLKJcvmmZrA==
=/aVG
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
