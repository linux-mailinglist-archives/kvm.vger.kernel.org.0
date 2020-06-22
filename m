Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2975D203741
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgFVMvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgFVMvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:51:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9441EC061794;
        Mon, 22 Jun 2020 05:51:18 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b6so16535331wrs.11;
        Mon, 22 Jun 2020 05:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zX/vQrH+HC/mucizOa8U1pMYcedLXVgLImbH/v3tPS0=;
        b=JhLP70RcDDFMFYc7ZxEIe1hTIp69j0N7fT3eiKD5NEVpzW5wivY2d+4xyEwBnxOaxv
         kJ68t97XxfsUkhGvW3aG4q9UBhw6y3EvZxj3lPilWMgdauvT787Lklprdc80s2ovc6Im
         GN3kidGgoUdqo1XM6djT4h7yZ9BkY6aB04ivnbcv+IU46wv5MxffJ7Txa3+7IWRWKzDr
         Zz6iPqaMUTsoHjTXZ43ACXzCS24kNWkVYJjvh6f6OT0QEWT3692CS7N7gHbv/UwdVobK
         irbQKcl7rKS/ublt8UznIOojLVAjN8nzVWkKRqVj9cJYY0UcLpW20HZ52cu11PnxgE4v
         lRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zX/vQrH+HC/mucizOa8U1pMYcedLXVgLImbH/v3tPS0=;
        b=EZ2wOwrWwmTdiFR+m2Fh2y6xXNlw9KDYPIrxzEGD6Qc7nvITH/SvzKmlzSPaJUopve
         9x4397V3fO6IyE8f6H+0dtSHGdbd+TK+6G4/+OD339VNs1yglsdZwRr56VlckVykP0KI
         fH29q7/QjkahfSSF6qk0pmBltp3EHGI3OLmu4xOjFBvRborRxYON56KbBLBbKZbFFjQP
         b1qg1ZyDMYulMaUCg6uAkOEl6xd8hirGJaEimIIRSNEifcrmgWz74V5kIk1Ysb8obqIC
         s+fnx+5WPZp1pOPtyhJtCkzFqLQKD7kJhBSIbKB9dxz3sN0z4jtf/q4Z8aSH64IU2X8c
         4l+g==
X-Gm-Message-State: AOAM533eLz6HeC9rdq3I/8v/GJ4rG9yn0VCmuV2RQBb7hnpo8IhRgts/
        MJ9JjTkNY/Gm0aP2F1CMVw4=
X-Google-Smtp-Source: ABdhPJxI4UVX4dTZ/ry3z9DrcIkJ3kGLDq/UM07+8O+yaTZxSbSNFRHTH8ZBS3yAurbDt/ZM22UjyQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr18730878wrw.63.1592830277348;
        Mon, 22 Jun 2020 05:51:17 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b201sm16893800wmb.36.2020.06.22.05.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:51:16 -0700 (PDT)
Date:   Mon, 22 Jun 2020 13:51:14 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 14/15] vfio: Document dual stage control
Message-ID: <20200622125114.GC15683@stefanha-x1.localdomain>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <1591877734-66527-15-git-send-email-yi.l.liu@intel.com>
 <20200615094128.GB1491454@stefanha-x1.localdomain>
 <DM5PR11MB1435C484283BDCD75F19EDB5C39A0@DM5PR11MB1435.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <DM5PR11MB1435C484283BDCD75F19EDB5C39A0@DM5PR11MB1435.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2020 at 06:27:27AM +0000, Liu, Yi L wrote:
> > From: Stefan Hajnoczi <stefanha@gmail.com>
> > Sent: Monday, June 15, 2020 5:41 PM
> > On Thu, Jun 11, 2020 at 05:15:33AM -0700, Liu Yi L wrote:
> >
> > > From: Eric Auger <eric.auger@redhat.com>
> > >
> > > The VFIO API was enhanced to support nested stage control: a bunch of
> > > new iotcls and usage guideline.
> > >
> > > Let's document the process to follow to set up nested mode.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > > v1 -> v2:
> > > *) new in v2, compared with Eric's original version, pasid table bind
> > >    and fault reporting is removed as this series doesn't cover them.
> > >    Original version from Eric.
> > >    https://lkml.org/lkml/2020/3/20/700
> > >
> > >  Documentation/driver-api/vfio.rst | 64
> > > +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 64 insertions(+)
> > >
> > > diff --git a/Documentation/driver-api/vfio.rst
> > > b/Documentation/driver-api/vfio.rst
> > > index f1a4d3c..06224bd 100644
> > > --- a/Documentation/driver-api/vfio.rst
> > > +++ b/Documentation/driver-api/vfio.rst
> > > @@ -239,6 +239,70 @@ group and can access them as follows::
> > >  	/* Gratuitous device reset and go... */
> > >  	ioctl(device, VFIO_DEVICE_RESET);
> > >
> > > +IOMMU Dual Stage Control
> > > +------------------------
> > > +
> > > +Some IOMMUs support 2 stages/levels of translation. Stage corresponds
> > > +to the ARM terminology while level corresponds to Intel's VTD termin=
ology.
> > > +In the following text we use either without distinction.
> > > +
> > > +This is useful when the guest is exposed with a virtual IOMMU and
> > > +some devices are assigned to the guest through VFIO. Then the guest
> > > +OS can use stage 1 (GIOVA -> GPA or GVA->GPA), while the hypervisor
> > > +uses stage 2 for VM isolation (GPA -> HPA).
> > > +
> > > +Under dual stage translation, the guest gets ownership of the stage 1
> > > +page tables and also owns stage 1 configuration structures. The
> > > +hypervisor owns the root configuration structure (for security
> > > +reason), including stage 2 configuration. This works as long
> > > +configuration structures and page table
> >=20
> > s/as long configuration/as long as configuration/
>=20
> got it.
>=20
> >=20
> > > +format are compatible between the virtual IOMMU and the physical IOM=
MU.
> >=20
> > s/format/formats/
>=20
> I see.
>=20
> > > +
> > > +Assuming the HW supports it, this nested mode is selected by choosing
> > > +the VFIO_TYPE1_NESTING_IOMMU type through:
> > > +
> > > +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> > > +
> > > +This forces the hypervisor to use the stage 2, leaving stage 1
> > > +available for guest usage. The guest stage 1 format depends on IOMMU
> > > +vendor, and it is the same with the nesting configuration method.
> > > +User space should check the format and configuration method after
> > > +setting nesting type by
> > > +using:
> > > +
> > > +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> > > +
> > > +Details can be found in Documentation/userspace-api/iommu.rst. For
> > > +Intel VT-d, each stage 1 page table is bound to host by:
> > > +
> > > +    nesting_op->flags =3D VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> > > +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> > > +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> > > +
> > > +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->=
GPA.
> > > +GVA->GPA page tables are available when PASID (Process Address Space
> > > +GVA->ID)
> > > +is exposed to guest. e.g. guest with PASID-capable devices assigned.
> > > +For such page table binding, the bind_data should include PASID info,
> > > +which is allocated by guest itself or by host. This depends on
> > > +hardware vendor e.g. Intel VT-d requires to allocate PASID from host.
> > > +This requirement is available by VFIO_IOMMU_GET_INFO. User space
> > > +could allocate PASID from host by:
> > > +
> > > +    req.flags =3D VFIO_IOMMU_ALLOC_PASID;
> > > +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
> >=20
> > It is not clear how the userspace application determines whether PASIDs=
 must be
> > allocated from the host via VFIO_IOMMU_PASID_REQUEST or if the guest it=
self can
> > allocate PASIDs. The text mentions VFIO_IOMMU_GET_INFO but what exactly
> > should the userspace application check?
>=20
> For VT-d, spec 3.0 introduced Virtual Cmd interface for PASID allocation,
> guest request PASID from host if it detects the interface. Application
> should check the IOMMU_NESTING_FEAT_SYSWIDE_PASID setting in the below
> info reported by VFIO_IOMMU_GET_INFO. And virtual VT-d should not report
> SVA related capabilities to guest if  SYSWIDE_PASID is not supported by
> kernel.
>=20
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;
> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	flags;
> +	__u8	data[];
> +};
> https://lore.kernel.org/linux-iommu/1591877734-66527-3-git-send-email-yi.=
l.liu@intel.com/

I see. Is it possible to add this information into this patch or at
least a reference so readers know where to find out exactly how to do
this?

Stefan

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7wqUIACgkQnKSrs4Gr
c8gEXAf/ZQH8CodMq4v9KMj2p9NfiCaoPCLUovRUE5HN/T65F4Ws54FqyH1P7o1D
D1+HFmvmqlTxWeYPGQezE0oPyHHXoklhwabmOsZfvNdXcCxLCT/Ly8KtqSQvrGtY
6726z2oGqGsKG9P1VS363mcwFXGAS4bsSiq/lKfaPqsK0ixQhIZ6W7uYDd+ftcO9
RF+fAaZo+HfTgbOjtXNJEBloLq9+hKfC8DzUlndGVuscAZrzw9IFKBaYDI23Mrmu
NP48KNAT7EkIIqpO7g+1wUo+CsKN0QrZsaMk7mOY3UAFfv2n9kUqQHeNVCNq7rc/
J1A0bqVto/R4LzTP6oY6Txi+4dTSBQ==
=D21M
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
