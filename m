Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A983B268B
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFXEyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:55 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58469 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhFXEyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:50 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT58RKz9t0p; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=Sm55XzzGfIQHnANDiUMDuvbZ7IYjUCtojFRRcEiqmdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZuxeZjTQrfzT56BXV29tLxlyIOHOXy7GQrcr5dBHMdRwtRLepAJHBZ5QOStm+KtB9
         y/cqy+JBpGt3PhpRnK8A4w9a+1QeLo6AY7yDNB6p+zQ7fzd3+URtYF1LoCqsBD7qyE
         RJM+qZc3B2GADxb/auGsSb1b+o/5v4GHaOrRSSXE=
Date:   Thu, 24 Jun 2021 14:37:31 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
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
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YNQMC4GcV3gxjerb@yekko>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <YMrXaWfAyLBnI3eP@yekko>
 <20210617230438.GZ1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yoFsgJzPurSq8+17"
Content-Disposition: inline
In-Reply-To: <20210617230438.GZ1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yoFsgJzPurSq8+17
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 08:04:38PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 17, 2021 at 03:02:33PM +1000, David Gibson wrote:
>=20
> > In other words, do we really have use cases where we need to identify
> > different devices IDs, even though we know they're not isolated.
>=20
> I think when PASID is added in and all the complexity that brings, it
> does become more important, yes.
>=20
> At the minimum we should scope the complexity.
>=20
> I'm not convinced it is so complicated, really it is just a single bit
> of information toward userspace: 'all devices in this group must use
> the same IOASID'

Um.. no?  You could have devA and devB sharing a RID, but then also
sharing a group but not a RID with devC because of different isolation
issues.  So you now have (at least) two levels of group structure to
expose somehow.

>=20
> Something like qemu consumes this bit and creates the pci/pcie bridge
> to model this to the guest and so on.
>=20
> Something like dpdk just doesn't care (same as today).
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yoFsgJzPurSq8+17
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUDAsACgkQbDjKyiDZ
s5K4XA//Y4QIGGAGVVbJfKrlf5JkN2/2a7VHx4vaUfc4NR5mVhkNYwvGbSYutZQ7
AjjTm5pfpoAem4nB8Q6U3GfaFTsj2YUg6Vodt8xJhSilvNHENa04nCVQMhACfYUn
SaQAMbx4gnuxaL02rl5NzWe5u5j1Vm1L485cfpMvdDae0Huq4qiMV4zCASCxGkO3
vIRkdPSdp8legFimjVdQJPLVnAIFG1nJk/9toYcNpXp0esbOxYMHszvcXkMM3F2l
1qyY4HbXOHBGQTvuAAAATYZve/p9YqYQ8ePzuYuLo8q4HAzL3V1uB9Dy9sGgXhFL
g46MfO3FKjnjrMxpanmv6ztsnoY4WOxMJundhPQ1ANayPNAPVSn3KaCSzX7hcfQH
xSOX8kjr5RDi1F3BYKPmOOGRK0dmGMRaWlCapWSLkobKzUUAaUT43jMa2843gP9O
b9PSXzODLGUu3fIUITRoMLGI881jigBWg/gmtV1egbi0s/qngiheJFzP9mptbzfw
eciggSqjH/4ZBuBpRhNDnICQNNF/39/r9qOeWeiBicfW+8HciMvcsjvcWVgOnAhl
/nIFGSMu6uTSWnSP6WR4fYDy7WRlsQM+GUk58WekBW19yzvoaoubmBXRCHq5eHmF
hKf3A9OxFZRJNs0G8wp6e6R3RSp67s+4+AUyEmEdzsJ6863Z9xw=
=1/9P
-----END PGP SIGNATURE-----

--yoFsgJzPurSq8+17--
