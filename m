Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFF23E531A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 07:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbhHJFuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 01:50:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237684AbhHJFuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 01:50:18 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4GkMVC12sBz9t1r; Tue, 10 Aug 2021 15:49:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1628574595;
        bh=YbLbuCNThcsSOrx2jsnQ+qzGIrL3Sa8qjMo2zoixYUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeeDGUoi3NfNePEFQSurbRphCjdsdRl92M3NlH0a65wrFgIloP1NN6EO9vuxoXjQl
         udEmuz3ZOLaCGmOkdxw46T2GZODcFJG3GGzxjvmKp9561SKItehYNy4VqRZ7gF8fvd
         MWmJCHrItKpAeDqd/tvw36MdmlpQzJ0M+OfZ+rrs=
Date:   Tue, 10 Aug 2021 14:47:49 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <YRIE9eDADmPoWWg9@yekko>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQig7EIVMAuzSgH4@yekko>
 <BN9PR11MB54338C2863EA94145710A1BA8CF09@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQy+ZsCab6Ni/sN7@yekko>
 <BN9PR11MB54338800A20821429D7C34038CF69@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wV885SpJ7rTOEsIJ"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54338800A20821429D7C34038CF69@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wV885SpJ7rTOEsIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 09, 2021 at 08:34:06AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Friday, August 6, 2021 12:45 PM
> > > > > In concept I feel the purpose of DMA endpoint is equivalent to the
> > routing
> > > > > info in this proposal.
> > > >
> > > > Maybe?  I'm afraid I never quite managed to understand the role of =
the
> > > > routing info in your proposal.
> > > >
> > >
> > > the IOMMU routes incoming DMA packets to a specific I/O page table,
> > > according to RID or RID+PASID carried in the packet. RID or RID+PASID
> > > is the routing information (represented by device cookie +PASID in
> > > proposed uAPI) and what the iommu driver really cares when activating
> > > the I/O page table in the iommu.
> >=20
> > Ok, so yes, endpoint is roughly equivalent to that.  But my point is
> > that the IOMMU layer really only cares about that (device+routing)
> > combination, not other aspects of what the device is.  So that's the
> > concept we should give a name and put front and center in the API.
> >=20
>=20
> This is how this proposal works, centered around the routing info. the=20
> uAPI doesn't care what the device is. It just requires the user to specif=
y=20
> the user view of routing info (device fd + optional pasid) to tag an IOAS=
=2E=20

Which works as long as (just device fd) and (device fd + PASID) covers
all the options.  If we have new possibilities we need new interfaces.
And, that can't even handle the case of one endpoint for multiple
devices (e.g. ACS-incapable bridge).

> the user view is then converted to the kernel view of routing (rid or=20
> rid+pasid) by vfio driver and then passed to iommu fd in the attaching=20
> operation. and GET_INFO interface is provided for the user to check=20
> whether a device supports multiple IOASes and whether pasid space is=20
> delegated to the user. We just need a better name if pasid is considered=
=20
> too pci specific...
>=20
> But creating an endpoint per ioasid and making it centered in uAPI is not=
=20
> what the IOMMU layer cares about.

It's not an endpoint per ioasid.  You can have multiple endpoints per
ioasid, just not the other way around.  As it is multiple IOASes per
device means *some* sort of disambiguation (generally by PASID) which
is hard to describe generall.  Having endpoints as a first-class
concept makes that simpler.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--wV885SpJ7rTOEsIJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmESBPMACgkQbDjKyiDZ
s5KILhAAr8fnsZWEExknNW7F+hGmqod7sHARGhdyn8YrbJrbReSFRrbiKDonU3Ac
Y2GRkVC2UY5HKw8uHyBcSlqYT0RQNuJxP4NsNrG67qJpvPIPsPIRAsys1RoRNkg9
/BsPhKbqMWmHneJvAzIa/+sC15AlWi3uqoXSfUI44j/UjHE+R/UIzPtntCjHtZvG
IWkR08OixLFBqd5SPxkLYs7YIeX088vUBk1bIkD8DeZLp7ZQnRBxQ3pEzwIrAYYA
iQyMnav9EkhI4NLzlN+4JVozFQ5yH1Yk89gbLNhgN4+AqdocNhrzROMzcmi4z/qd
PQSqKGTCbqklyM7TmrU3PZidR5ULFv4CNZR2mxUehIBHh0Hbiszfdw67jB7j8e7+
03nGDMwfyr1ZK4X6DJ0HjWI/CXA2vL0DAQjJnzz+wSAwJH7AxxCf9Wt/ykGIbWR9
+HIKRdVl2XVAzDOL9ySXeHFGTZ2ypQ1Xxm0DNS/RSDKPeUSmM2k6iHmZC8E/s58v
n0aXJSOR7Nvh+L9Gv5N56Ox8zxvUxfITNducyyMRa+JXT+UFfJIOEjRU9apAEJd6
GEO8C3NqSLG/jU78CKqQObOfATlFBt8iJM9gtZVCFCs57J5udZlse7YmokYK9AWa
ddjx/N6iMOaYdU0VJCG199aWbdU2ZEBVRNaQFuX8oQzZlgT+Szo=
=URlp
-----END PGP SIGNATURE-----

--wV885SpJ7rTOEsIJ--
