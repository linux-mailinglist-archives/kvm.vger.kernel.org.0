Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03B517B7E
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 03:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiECBMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 21:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiECBMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 21:12:52 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D1159BA9
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 18:09:16 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Kshd02q3pz4yST; Tue,  3 May 2022 11:07:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651540020;
        bh=tl+xQY7b5PWuVIwdVZUBcQmBxqJUgBDX+VVK3NshUdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iwNAkgDTUM+C/hJsi3IqYspRuR24yJ0wEje5rmgyXA9e20Dkmj0pHsv59zE/oEtHB
         C9J9ajMauFSPh2frlNXP/F/irO8ifYQsce6O4CAqk/AGeWmL6Z7K1gdB8V+PTOIzxs
         Zgezn1XyMSxv8Kr/bVHCbVB7YDNXjKhKI4DXonik=
Date:   Mon, 2 May 2022 14:10:07 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <Ym9Zn6P5Rrxl7ktM@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <BN9PR11MB5276C4C51B3EB6AD77DEFFCD8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YmuEQCRqyzSsH270@yekko>
 <20220429125030.GX8364@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NOL/Vueg46+c6vaG"
Content-Disposition: inline
In-Reply-To: <20220429125030.GX8364@nvidia.com>
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NOL/Vueg46+c6vaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2022 at 09:50:30AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 04:22:56PM +1000, David Gibson wrote:
> > On Fri, Apr 29, 2022 at 01:21:30AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, April 28, 2022 11:11 PM
> > > >=20
> > > >=20
> > > > > 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for
> > > > 2 IOVA
> > > > > windows, which aren't contiguous with each other.  The base addre=
sses
> > > > > of each of these are fixed, but the size of each window, the page=
size
> > > > > (i.e. granularity) of each window and the number of levels in the
> > > > > IOMMU pagetable are runtime configurable.  Because it's true in t=
he
> > > > > hardware, it's also true of the vIOMMU interface defined by the I=
BM
> > > > > hypervisor (and adpoted by KVM as well).  So, guests can request
> > > > > changes in how these windows are handled.  Typical Linux guests w=
ill
> > > > > use the "low" window (IOVA 0..2GiB) dynamically, and the high win=
dow
> > > > > (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> > > > > can't count on that; the guest can use them however it wants.
> > > >=20
> > > > As part of nesting iommufd will have a 'create iommu_domain using
> > > > iommu driver specific data' primitive.
> > > >=20
> > > > The driver specific data for PPC can include a description of these
> > > > windows so the PPC specific qemu driver can issue this new ioctl
> > > > using the information provided by the guest.
> > > >=20
> > > > The main issue is that internally to the iommu subsystem the
> > > > iommu_domain aperture is assumed to be a single window. This kAPI w=
ill
> > > > have to be improved to model the PPC multi-window iommu_domain.
> > > >=20
> > >=20
> > > From the point of nesting probably each window can be a separate
> > > domain then the existing aperture should still work?
> >=20
> > Maybe.  There might be several different ways to represent it, but the
> > vital piece is that any individual device (well, group, technically)
> > must atomically join/leave both windows at once.
>=20
> I'm not keen on the multi-iommu_domains because it means we have to
> create the idea that a device can be attached to multiple
> iommu_domains, which we don't have at all today.
>=20
> Since iommu_domain allows PPC to implement its special rules, like the
> atomicness above.

I tend to agree; I think extending the iommu domain concept to
incorporate multiple windows makes more sense than extending to allow
multiple domains per device.  I'm just saying there might be other
ways of representing this, and that's not a sticking point for me as
long as the right properties can be preserved.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--NOL/Vueg46+c6vaG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJvWX0ACgkQgypY4gEw
YSIRyxAAsxY5Gh6o+Ak9QpzgluzTikqf2kOCRvhTCTBH+BSubWH7U0uasbYmdtMN
ZrWKQRul/w8mKuuPp2IiUHuqA+TqNy/R69c8zcRN39Dt3RCpW0TaRrZXjhVsbliY
+2cgGXtemupprEgymq+njipYOX27ydhVHCRY18EYlrabldciOk2uv9rD7b00LIe8
PPjpUN4KAIx8cRgcS5IEw9dyORlWdduaZtj38m4295IbsxdadQvH8TUPAkeXMnhR
a/SVpdw3+EPrBeZlCIFsYZ+jCTyGLvc2knlJHskE6D+NVuNUnUnjv9e2MZ6f1hut
ezDCfYJI988qaxQ+iAA+fvJmqBN+2/7ioh0nntvbhrrF8My2jwGOsT/ehVwlANcQ
R63aCi4gyXosS7shQHHDDPhBRztviVnCq+biGG/4ly+7TSFhAklDzNYAUlex6mQ1
fNrwTf9lI+gnQhi072S2q0dSlkNSV3zEU+ScAXPCJf4bgpLV93Vhy+EHLDpUEYP/
iply4hG+UMVVJQw6LK0iTrgiKAEn9QdcWoqghB9mkl5q9G4Otw7t+nWeU0PmuFuA
YqE7qx19N9IDcg3X/bo8ywaN2iwHp3G+6F8opzMKIFDI5vLDu2A9fHJ0CYPP/N0y
sMhx7wNveaQS7S74n44F+HLdpzvkBfUkZ1oSWztWD3AhyALr9mI=
=roey
-----END PGP SIGNATURE-----

--NOL/Vueg46+c6vaG--
