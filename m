Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0F514298
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 08:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354752AbiD2Grj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 02:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354664AbiD2Grb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 02:47:31 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8D9BB095
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 23:44:14 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KqNHt04N5z4ySt; Fri, 29 Apr 2022 16:44:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651214650;
        bh=KLL/swhJOnqznMFffQpsuCbHhT8ZtLpQASoU/DYSWm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J9SioNqjWCz67rFVY48Sp4fS7JMwE0ZhFy2GIfBaNWxOFTTInYknmN71d6q2jhlmO
         AodYMksHBdRg8OcJM25Vb4nec9fsl9GlU7s9b5zH3VTcHXgOr7yZjaHWfA2Rlo93YH
         asGTYV3nFC5OfmWFjOaOfvGEfE0kb+2moQJEr9C4=
Date:   Fri, 29 Apr 2022 16:22:56 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <YmuEQCRqyzSsH270@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <BN9PR11MB5276C4C51B3EB6AD77DEFFCD8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4KY3Wn/sOLHsVQnF"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C4C51B3EB6AD77DEFFCD8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4KY3Wn/sOLHsVQnF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2022 at 01:21:30AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 28, 2022 11:11 PM
> >=20
> >=20
> > > 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for
> > 2 IOVA
> > > windows, which aren't contiguous with each other.  The base addresses
> > > of each of these are fixed, but the size of each window, the pagesize
> > > (i.e. granularity) of each window and the number of levels in the
> > > IOMMU pagetable are runtime configurable.  Because it's true in the
> > > hardware, it's also true of the vIOMMU interface defined by the IBM
> > > hypervisor (and adpoted by KVM as well).  So, guests can request
> > > changes in how these windows are handled.  Typical Linux guests will
> > > use the "low" window (IOVA 0..2GiB) dynamically, and the high window
> > > (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> > > can't count on that; the guest can use them however it wants.
> >=20
> > As part of nesting iommufd will have a 'create iommu_domain using
> > iommu driver specific data' primitive.
> >=20
> > The driver specific data for PPC can include a description of these
> > windows so the PPC specific qemu driver can issue this new ioctl
> > using the information provided by the guest.
> >=20
> > The main issue is that internally to the iommu subsystem the
> > iommu_domain aperture is assumed to be a single window. This kAPI will
> > have to be improved to model the PPC multi-window iommu_domain.
> >=20
>=20
> From the point of nesting probably each window can be a separate
> domain then the existing aperture should still work?

Maybe.  There might be several different ways to represent it, but the
vital piece is that any individual device (well, group, technically)
must atomically join/leave both windows at once.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4KY3Wn/sOLHsVQnF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJrhDkACgkQgypY4gEw
YSK42w/9Hq0y2D5y+zf9WXYECB3hwB2FjainWxP5fgEL18DgNzoQrJYn6XvZxjhg
OgURotSMbpVnAmgu4KcpMEKFOk+KaASyEu/TYAynjlNrOj1h2s+mTgpMPQe17cYo
9XXJrDnbXKTuxthSUkugyg8JIBkKqh7rdGb1L66xXzDTN6YbK19KtreSWxi9DJfB
tdDKafhQ8Xg79wcXgQ9Q6iqAA9EIeIyiEflpLt4WvI+TV5hu6E6+xKVS4SnWdsSd
KC5Dy8BtZryemK5cHCV2NDP2alkm7ieUT/BmLNfOsLxqFzQhAVHlUOYnwpkljgvs
Q4ufD+0IF6bLJA00b32u7OMZLBmwkq7ta9YxSNOtBzoOxnAwcmCzyy3KIKM3bWrw
pFwx3jQmzhkp6UiwNavDuY33nhuM+2uz9jK7sfjhuxhbev6pkE1CsIiPzKX+fGXH
00bqQr14CSiNFH0Ba6OqPCwXtkLUB1Z2JxKgg5l9EuDMXk3VHisC6GkazTV4hDfA
lv3Da1iFy8xPl8fbuylOj5SmZDPdlGOlqyaQdilupqBShrhxDgHzI/KRx1CP+l7R
0j6+CDTUieYFKLgdgGt4DjWeY6Kb7LJiK8brK3WcUX4Q9aqYIU+LWsVwNNW62wK4
pBrFHSXkhc033Wv5OzrGD6cTAmqhReB+FRLfQEN3pIiMqt3wnZ0=
=6Jjv
-----END PGP SIGNATURE-----

--4KY3Wn/sOLHsVQnF--
