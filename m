Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869C65B58C9
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 12:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiILKy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 06:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiILKy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 06:54:57 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4201CE080
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 03:54:54 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4MR3QN3Yrxz4xZS; Mon, 12 Sep 2022 20:54:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1662980092;
        bh=Jqer9Lkx5kx3CTVFQbI1gse1o6FkM2vShOdKJKllDRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1PHfLhprn9Dvc2eQQbdZzdKd8ggp3Imh3NAuTzQZyJ1gkQoegSgvwFJCCchMom+H
         cZzeVJ0FIbEdyktCH9a8Zfko9DJRMmCgA0IuKEwFRyofdPLNXy16+BgRgKHvB3ih2B
         zdjGiPfqzEOBAbB2KzS8Y1PtCzCl5T7dQ9cKcA58=
Date:   Mon, 12 Sep 2022 20:40:20 +1000
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
Message-ID: <Yx8MlOBPz1Zxig3V@yekko>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <Yxf2Z+wVa8Os02Hp@yekko>
 <YxuLaxIRNsQRmqI5@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yTVklgu6xyo6tvgA"
Content-Disposition: inline
In-Reply-To: <YxuLaxIRNsQRmqI5@nvidia.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yTVklgu6xyo6tvgA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2022 at 03:52:27PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 07, 2022 at 11:39:51AM +1000, David Gibson wrote:
>=20
> > > +expected to deprecate any proprietary IOMMU logic, if existing (e.g.
> >=20
> > I don't thing "propietary" is an accurate description.  Maybe
> > "existing" or "bespoke?
>=20
> How about "internal"

>  These drivers are eventually expected to deprecate any internal IOMMU
>  logic, if existing (e.g. vfio_iommu_type1.c).

That works.

> > > +All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
> > > +
> > > +Linkage between user-visible objects and external kernel datastructu=
res are
> > > +reflected by dotted line arrows below, with numbers referring to cer=
tain
> >=20
> > I'm a little bit confused by the reference to "dotted line arrows": I
> > only see one arrow style in the diagram.
>=20
> I think this means all the "dashed lines with arrows"
>=20
> How about "by the directed lines below"

Or simply "reflected by arrows below".

> > > +The iopt_pages is the center of the storage and motion of PFNs. Each=
 iopt_pages
> > > +represents a logical linear array of full PFNs. PFNs are stored in a=
 tiered
> > > +scheme:
> > > +
> > > + 1) iopt_pages::pinned_pfns xarray
> > > + 2) An iommu_domain
> > > + 3) The origin of the PFNs, i.e. the userspace pointer
> >=20
> > I can't follow what this "tiered scheme" is describing.
>=20
> Hum, I'm not sure how to address this.
>=20
> Is this better?
>=20
>  1) PFNs that have been "software accessed" stored in theiopt_pages::pinn=
ed_pfns
>     xarray
>  2) PFNs stored inside the IOPTEs accessed through an iommu_domain
>  3) The origin of the PFNs, i.e. the userspace VA in a mm_struct

Hmm.. only slightly.  What about:

   Each opt_pages represents a logical linear array of full PFNs.  The
   PFNs are ultimately derived from userspave VAs via an mm_struct.
   They are cached in .. <describe the pined_pfns and iommu_domain
   data structures>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yTVklgu6xyo6tvgA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmMfDI0ACgkQgypY4gEw
YSJWyhAAyUb6FKzQMARiSUOon4QtVcnRZZ9t5d/Gcx6z9K4iUZByk2zbMBm4UCzp
jbkAm5fVHdydwr5F65IphEcgpowqsy2Cz0STnWvoAGmWqSk6oel1OOXk4FggOUu4
EJjP4S0VeMMbVdHQoE4SWOjnD1J5ILeFCIzeOK+40QIJuRmJMFWKczgkRz/vajLj
yj8UWk/ccys8moSZyHIgZ977X1Y0J9l9G3Asg2AMchRLTzqGcemj+YV4Yfp4W9gA
iQEQwRw62wkbgzC2V9dVIOF9Zli4GmmzQGikeRZnp/TZeWf9U5cQy9lqJG4H1n5r
XkyNn1bjC0H/Yv6XRWDiYdLCqLurfXfcnwUK7rWbOkdjTaxTNOflLvj1WCC56+n5
8B5AUcXVBsNgO16YGOb28btGBpLPVOFKnytv7QmE3AMam/y2Avfhv+wjIT80XIKK
LvrFdOzjqTeDJohodefGtg+cavVGHjugl0C25dp/6HlznswgIUWNXC7cS06CI3B6
YPrkN1IOgPfbObYS8Vyk/9DOMVqynZXSfozADHqNuBhx8W6PsGydBhTQIKGgukR4
+Iq4yzqdEB0uiuvUtIOGygyzpx8PVdqYLqJiGitbwuOYLMYnHNniNa0S8DtX5G1C
83rN86teIVu9eJdv7Dn7ilAaCvdJUz66b3WxVf9KNtxJWZxhJHs=
=lklv
-----END PGP SIGNATURE-----

--yTVklgu6xyo6tvgA--
