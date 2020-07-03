Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A15421384E
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgGCJ7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgGCJ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 05:59:07 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B786C08C5C1;
        Fri,  3 Jul 2020 02:59:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so31463427wmh.4;
        Fri, 03 Jul 2020 02:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QUEUp6b8vPDcIaWddrAW3ZEk4ffVMz6gDvJ97V6JC3I=;
        b=s7T3av6Zlf5LjNrAlTJRA/DPxA46Drkl8vngBzMoKPYFaKzxUCVL2uIUWNUJ5W1jGh
         u3MRA5hewnpD7T6n3k22zJBGdg1QLXyq6T4oq57RIl/2EzjkGZnc4dPqxSHDnf5KLpxO
         Dys9uPs8RhVjo2UK3QPe14QRzGNFIR0RFgniZB1Lzd2Xu+OhNRMumiBS16o90jnzSsNT
         u4F0TefJjTDfNL0h+VepvzhDJjXY+1p68Wnu+e8GJhoDOhWWQj47RocEzpcW17cBP2Tu
         T807cj0Nw4S1ALktlqHnsMnzVcdzp9GZylj7exjeeycf5Fl/khg5Zbv2imP/WNCC9uEj
         5GuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QUEUp6b8vPDcIaWddrAW3ZEk4ffVMz6gDvJ97V6JC3I=;
        b=DviFCZ6wfkx0lHwmmzXXFQb1tfu7aTj8E+fmnhmsRC+ZTgGenqtcqiCMcBgEQddeDY
         RuNeuTbGN03Erh45hKrqr1WLUSRfTcgpsC+M4+WOoL82F6R71tnv6OA8XbVdL+noqjDP
         C9bfn/Jp1FzOeA0DrJ4gP4ZzRdBDTejZlLgFzPuQYomptfovN9QY2B8Q3rtEeRE6LlfV
         A7Vy0QvZqDN6R+zQM7uoc0z5SM1jTsR5HTtzqqVpJEnf7jc9KzcGu4JYcJZbqVymXcBr
         INp6sRncuIksSaaO5yBECC0Nv7Z5FYBcPQKXlDDreRc44pQi+GbQBIMYd0dA3/XyZfyi
         i5nw==
X-Gm-Message-State: AOAM5315ss6QGcVPCXDabfXxthKctjMGw/WRuTrB+lyiw7p724hOParY
        l6zciRVDTWzgF4nbvnhxwd4=
X-Google-Smtp-Source: ABdhPJx9V3qkXxE6+xfAnBW+gkh8aYYsqnhCRO2ir1LYp4KS6eyYLQGPC4beUpoKXhlPxe9nr7Xy3w==
X-Received: by 2002:a1c:f30a:: with SMTP id q10mr35060334wmq.3.1593770345218;
        Fri, 03 Jul 2020 02:59:05 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id l1sm851038wrb.12.2020.07.03.02.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 02:59:04 -0700 (PDT)
Date:   Fri, 3 Jul 2020 10:59:02 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: Re: [PATCH v3 02/14] iommu: Report domain nesting info
Message-ID: <20200703095902.GA178149@stefanha-x1.localdomain>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
 <20200629092448.GB31392@stefanha-x1.localdomain>
 <DM5PR11MB1435FC14F2E8AC075DE41205C36E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB1645B09EBDC76514ADC897A68C6F0@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645B09EBDC76514ADC897A68C6F0@MWHPR11MB1645.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2020 at 02:00:49AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, June 29, 2020 8:23 PM
> >=20
> > Hi Stefan,
> >=20
> > > From: Stefan Hajnoczi <stefanha@gmail.com>
> > > Sent: Monday, June 29, 2020 5:25 PM
> > >
> > > On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
> > > > +/*
> > > > + * struct iommu_nesting_info - Information for nesting-capable IOM=
MU.
> > > > + *				user space should check it before using
> > > > + *				nesting capability.
> > > > + *
> > > > + * @size:	size of the whole structure
> > > > + * @format:	PASID table entry format, the same definition with
> > > > + *		@format of struct iommu_gpasid_bind_data.
> > > > + * @features:	supported nesting features.
> > > > + * @flags:	currently reserved for future extension.
> > > > + * @data:	vendor specific cap info.
> > > > + *
> > > > + * +---------------+----------------------------------------------=
------+
> > > > + * | feature       |  Notes                                       =
      |
> > > > + *
> > >
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =3D=3D=3D=3D
> > > =3D+
> > > > + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs
> > used  |
> > > > + * |               |  in the system should be allocated by host ke=
rnel  |
> > > > + * +---------------+----------------------------------------------=
------+
> > > > + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID co=
uld   |
> > > > + * |               |  either be a host PASID passed in bind reques=
t or  |
> > > > + * |               |  default PASIDs (e.g. default PASID of aux-do=
main) |
> > > > + * +---------------+----------------------------------------------=
------+
> > > > + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU
> > |
> > > > + * +---------------+----------------------------------------------=
------+
> > >
> > > This feature description is vague about what CACHE_INVLD does and how
> > to
> > > use it. If I understand correctly, the presence of this feature means
> > > that VFIO_IOMMU_NESTING_OP_CACHE_INVLD must be used?
> > >
> > > The same kind of clarification could be done for SYSWIDE_PASID and
> > > BIND_PGTBL too.
> >=20
> > For SYSWIDE_PASID and BIND_PGTBL, yes, presence of the feature bit
> > means must use. So the two are requirements to user space if it wants
> > to setup nesting. While for CACHE_INVLD, it's kind of availability
> > here. How about removing CACHE_INVLD as presence of BIND_PGTBL should
> > indicates support of CACHE_INVLD?
> >=20
>=20
> So far this assumption is correct but it may not be true when thinking fo=
rward.
> For example, a vendor might find a way to allow the owner of 1st-level pa=
ge
> table to directly invalidate cache w/o going through host IOMMU driver. F=
rom
> this angle I feel explicitly reporting this capability is more robust.
>=20
> Regarding to the description, what about below?
>=20
> --
> SYSWIDE_PASID: PASIDs are managed in system-wide, instead of per device.
> When a device is assigned to userspace or VM, proper uAPI (provided by=20
> userspace driver framework, e.g. VFIO) must be used to allocate/free PASI=
Ds
> for the assigned device.
>=20
> BIND_PGTBL: The owner of the first-level/stage-1 page table must explicit=
ly=20
> bind the page table to associated PASID (either the one specified in bind=
=20
> request or the default PASID of the iommu domain), through VFIO_IOMMU
> _NESTING_OP
>=20
> CACHE_INVLD: The owner of the first-level/stage-1 page table must
> explicitly invalidate the IOMMU cache through VFIO_IOMMU_NESTING_OP,
> according to vendor-specific requirement when changing the page table.
> --

Mentioning the API to allocate/free PASIDs and VFIO_IOMMU_NESTING_OP has
made this clearer. This lets someone reading the documentation know
where to look for further information on using these features.

Thank you!

Stefan

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7/AWYACgkQnKSrs4Gr
c8gjgAf+Nal5JGppiGxNvF8o+N4PQxI9ucEsipPeQkGzfMdGwEPBPWyLHEhwTEKG
4sbBPMw8FjPaBGk54Za1CxjNMXuIAFIaFV/srTfaHYVHrZq4CeUOlR02+bKqTnb6
bGjUkIQ3GNb3zwGsi2FFeamD0WeKl4ccQ1CrVH0vpMXqF7m9mEa5YXx1VUyN9p0A
VyranfGTurVQctbIa0iG02d5iMqGPPHKhFhRFpsQ66cS0m3yMXO72z+nFJs8tBCy
ezdnCkNMkeBXEHQrpdm1HnOtcMCUxZV13jPs7advb1Xv+oZnEQrfMzwzmG5N3z2w
PHoBHT/EpP06jcjIcGOcBFS8KVXJ6w==
=1OHs
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
