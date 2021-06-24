Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF403B2692
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFXEy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37373 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhFXEyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT3YPMz9srZ; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=EHvfXmcln2cuvHUfIp1Ef7p8K3ajzOq94RDeey096tE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLx424KuLQp4RlGrMdd/XU1zskLB9aQBL7f+kySPUHLCC3lqX9LWrh12zvpA+TcOr
         0StJ/pb2zu0SG9Y0IiFFtsyzTFOs8YMMnsQ7Xl5Oy/8tVeSv8nw3Nz8qwSpgUoHTfg
         JWwQ8QJOV4hokfVSaRLQ1EUzu8E+KejVDr94Jz50=
Date:   Thu, 24 Jun 2021 14:23:36 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <YNQIyP4RR0PmVtLo@yekko>
References: <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VbemreCsSMMcmVQr"
Content-Disposition: inline
In-Reply-To: <20210617151452.08beadae.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--VbemreCsSMMcmVQr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
> On Thu, 17 Jun 2021 07:31:03 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, June 17, 2021 3:40 AM
> > > On Wed, 16 Jun 2021 06:43:23 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Wednesday, June 16, 2021 12:12 AM
> > > > > On Tue, 15 Jun 2021 02:31:39 +0000
> > > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Sent: Tuesday, June 15, 2021 12:28 AM
[snip]

> > > > > 3) A dual-function conventional PCI e1000 NIC where the functions=
 are
> > > > >    grouped together due to shared RID.
> > > > >
> > > > >    a) Repeat 2.a) and 2.b) such that we have a valid, user access=
ible
> > > > >       devices in the same IOMMU context.
> > > > >
> > > > >    b) Function 1 is detached from the IOASID.
> > > > >
> > > > >    I think function 1 cannot be placed into a different IOMMU con=
text
> > > > >    here, does the detach work?  What's the IOMMU context now? =20
> > > >
> > > > Yes. Function 1 is back to block-DMA. Since both functions share RI=
D,
> > > > essentially it implies function 0 is in block-DMA state too (though=
 its
> > > > tracking state may not change yet) since the shared IOMMU context
> > > > entry blocks DMA now. In IOMMU fd function 0 is still attached to t=
he
> > > > IOASID thus the user still needs do an explicit detach to clear the
> > > > tracking state for function 0.
> > > > =20
> > > > >
> > > > >    c) A new IOASID is alloc'd within the existing iommu_fd and fu=
nction
> > > > >       1 is attached to the new IOASID.
> > > > >
> > > > >    Where, how, by whom does this fail? =20
> > > >
> > > > No need to fail. It can succeed since doing so just hurts user's ow=
n foot.
> > > >
> > > > The only question is how user knows the fact that a group of devices
> > > > share RID thus avoid such thing. I'm curious how it is communicated
> > > > with today's VFIO mechanism. Yes the group-centric VFIO uAPI preven=
ts
> > > > a group of devices from attaching to multiple IOMMU contexts, but
> > > > suppose we still need a way to tell the user to not do so. Especial=
ly
> > > > such knowledge would be also reflected in the virtual PCI topology
> > > > when the entire group is assigned to the guest which needs to know
> > > > this fact when vIOMMU is exposed. I haven't found time to investiga=
te
> > > > it but suppose if such channel exists it could be reused, or in the=
 worst
> > > > case we may have the new device capability interface to convey... =
=20
> > >=20
> > > No such channel currently exists, it's not an issue today, IOMMU
> > > context is group-based. =20
> >=20
> > Interesting... If such group of devices are assigned to a guest, how do=
es
> > Qemu decide the virtual PCI topology for them? Do they have same
> > vRID or different?
>=20
> That's the beauty of it, it doesn't matter how many RIDs exist in the
> group, or which devices have aliases, the group is the minimum
> granularity of a container where QEMU knows that a container provides
> a single address space.  Therefore a container must exist in a single
> address space in the PCI topology.  In a conventional or non-vIOMMU
> topology, the PCI address space is equivalent to the system memory
> address space.  When vIOMMU gets involved, multiple devices within the
> same group must exist in the same address space.  A vPCIe-to-PCI bridge
> can be used to create that shared address space.
>=20
> I've referred to this as a limitation of type1, that we can't put
> devices within the same group into different address spaces, such as
> behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
> As isolation support improves we see fewer multi-device groups, this
> scenario becomes the exception.  Buy better hardware to use the devices
> independently.

Also, that limitation is fundamental.  Groups in a guest must always
be the same or strictly bigger than groups in the host, because if the
real hardware can't isolate them, then the virtual hardware certainly
can't and the guest kernel shouldn't be given the impression that it
can separate them.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--VbemreCsSMMcmVQr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUCMYACgkQbDjKyiDZ
s5IbcQ//RRnk6578Dd3RoItAw/ouSkamizbOnDMKW7uaqK9YsPPO02q6NleujshT
GRaG2DwHv5YMH3GGLpS7zFa9iitJezuIC/0WuLH/Ypq735SPTU7NVbRpsB5ijbUR
HW06YH5mmYETGwtp+vb8zxq7AWcKk7KqlHYBjvwK8nU5Klr27m8gqth7qW5DqB0k
9uhcJZXOaFCDYMdVX1DTaOQ3TdJLf7+Rwf8gfVM3Ma1sq0jgv3rzxCz6tLqoJ0pe
pQW/yd0/iwz/tIYYWK8xB6YnT+u+ozEFJHqehdxY5yaC+c/GN8tzd4UNCJv5F0is
CTdwipKta3C9Mxzv4x1s74NkDnT6b1SSN0ZjyVA/md10KLnyRFjSxVoYh7Ab/ODk
+u70Zl2lBBScUksTyeqG5QDVa/y0T8O9b6yTsh4aY4XdtpR2FZSY/kVS6gyq0uyr
1Epw5S1E9JSmYaGuYcdaAHD3b8+HxTVvn1RfdWXcfNvhSjDrmPtmUyWnqWTo64OV
PEWuw4FcaSPDMLZMqvFFMWE2heNyWfLpzvU9ym+cgj4L6bImaY8k6jAaEu3HfWQZ
25XxtcXaWhBHrCT66YWjeqPtMZypAZCaiabGEt29+ijNqBRiaO8+tGwBtAuYiWvK
K9v+f84XO3+e+kCvEdIf0a5+Xn2N04QDnb6fs41xkCE8hasvUVQ=
=Tqsh
-----END PGP SIGNATURE-----

--VbemreCsSMMcmVQr--
