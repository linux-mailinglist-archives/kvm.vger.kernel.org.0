Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FD05E9A5F
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiIZHXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 03:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiIZHX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 03:23:27 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645D8326E9
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 00:23:24 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4MbZ3q3q6Qz4xFt; Mon, 26 Sep 2022 17:23:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1664176999;
        bh=WFfOHx1xIgXuGxU//nX9avMvGbK3JU8CynxOvSEkiOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6i2RKZUUWclqNK/Kjpuhh7SgnUhWHBbdgq0/D9bvgyz7cFU4RfTq7LR3zjoCYRK8
         siAN5gfg34oNfQeA2tjwVqeIvjri3zFo56WhHYc88CHkGtT5sxZOQGwpLp3jaLZGiS
         Bz0DKWKo0Erov4aWAUbx7HRUVtVd1+A/Ait3ro3E=
Date:   Mon, 26 Sep 2022 16:34:01 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
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
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YzFH2bb1cguPpXuf@yekko>
References: <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com>
 <Yy20xURdYLzf0ikS@nvidia.com>
 <20220923080307.1d9a6166.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zPSW0XCHJZCxFT/C"
Content-Disposition: inline
In-Reply-To: <20220923080307.1d9a6166.alex.williamson@redhat.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zPSW0XCHJZCxFT/C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 23, 2022 at 08:03:07AM -0600, Alex Williamson wrote:
> On Fri, 23 Sep 2022 10:29:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrang=E9 wrote:
> >=20
> > > Yes, we use cgroups extensively already. =20
> >=20
> > Ok, I will try to see about this
> >=20
> > Can you also tell me if the selinux/seccomp will prevent qemu from
> > opening more than one /dev/vfio/vfio ? I suppose the answer is no?
>=20
> QEMU manages the container:group association with legacy vfio, so it
> can't be restricted from creating multiple containers.  Thanks,

=2E. and it absolutely will create multiple containers (i.e. open
/dev/vfio/vfio multiple times) if there are multiple guest-side vIOMMU
domains.

It can, however, open each /dev/vfio/NN group file only once each,
since they are exclusive access.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--zPSW0XCHJZCxFT/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmMxR9IACgkQgypY4gEw
YSKy9RAA1bDcpJHuQR/pXfAqSSPYcwHCyJ6Lq/4h8Gvb5QsRxPT98D92uRP78SWJ
DusKzRlI7OIAAj0iYzcTIm2tGj+4rEeOCwSGY5ubZyc5sR2RGatzw4RjOPtQg4Qo
w8i14niXiEuchHYQIIu4R6N/kZrU4ijSve0y8TXHh5aMOqzD3uiV4/23MOwXImcR
kpalF3u/w+maH3YSVxwycLBGGthmav6R9OE2N+dAXljhMnIbPHslU6VCj1jpZM10
2wNhaBFUGfG+SOpl6ZyvmxYqZ4noR7NoiYtQgDnc0BFTqTowIH2Hg2s0IzWBntNS
qMFknNnxtBWc6NbyTd+VszQb2eaA7G+/wbMCpOqWa9+m2dGceX8twwcQvS+pMG6S
EtMEraGyDiz2jT2yieytmFnYtpjlCYp/GGOjjBXvSnv8GKacOZcKAb0+hl2dFJ68
KNNmWyhzLtHoS2Ootv/Vp9ORM42Ow13IS5XN6wxvuLxyr7qo1f/6bGG80gGb7c06
ZVFsXfnQYysTN8Gq8/99BJZmwr1EfrRJCWphyWv9/T9SvDtpICslJJIvq6js5uYI
QCr6YhjsHOlZVGJ0vkPzvyvwfHGbnstKR0PWnksGf+38lf1f5raQWskWLYK9Q04t
UKHcOf0splCwOZ6iE1P99CQ3JYaYp96rlfFPMLnjF+FLGkMWgmc=
=72Yx
-----END PGP SIGNATURE-----

--zPSW0XCHJZCxFT/C--
