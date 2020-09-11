Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F9B26594F
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 08:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKGZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 02:25:59 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:35461 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgIKGZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 02:25:57 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.180])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id BD8D959DC40A;
        Fri, 11 Sep 2020 08:25:54 +0200 (CEST)
Received: from kaod.org (37.59.142.97) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 11 Sep
 2020 08:25:53 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G0020f8465f2-d2aa-420c-b116-c932b61acd28,
                    864FBEA0465FE1F0C66A9C6AC37977A76827B8ED) smtp.auth=groug@kaod.org
Date:   Fri, 11 Sep 2020 08:25:52 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Halil Pasic <pasic@linux.ibm.com>, <pair@us.ibm.com>,
        <brijesh.singh@amd.com>, <frankja@linux.ibm.com>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Hildenbrand" <david@redhat.com>, <qemu-devel@nongnu.org>,
        <dgilbert@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        <qemu-s390x@nongnu.org>, <qemu-ppc@nongnu.org>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>,
        <pbonzini@redhat.com>, Richard Henderson <rth@twiddle.net>,
        <mdroth@linux.vnet.ibm.com>, <ehabkost@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200911082552.1b7d7bde@bahia.lan>
In-Reply-To: <20200911000718.GF66834@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-11-david@gibson.dropbear.id.au>
        <20200907172253.0a51f5f7.pasic@linux.ibm.com>
        <20200910133609.4ac88c25.cohuck@redhat.com>
        <20200910202924.3616935a.pasic@linux.ibm.com>
        <20200911000718.GF66834@yekko.fritz.box>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qq16TA.RbBJtpBs.5w6QU1y";
        protocol="application/pgp-signature"; micalg=pgp-sha256
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 603d3a54-b52f-44da-a31e-7633abf7e05f
X-Ovh-Tracer-Id: 1761470407334599123
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrudehkedguddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtghisehgtderreertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelgffgfeeugedugeekveeiveevjeffhfduvdegffetkeeiveeufefgledtgfeiteenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegvhhgrsghkohhsthesrhgvughhrghtrdgtohhm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/qq16TA.RbBJtpBs.5w6QU1y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Sep 2020 10:07:18 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Thu, Sep 10, 2020 at 08:29:24PM +0200, Halil Pasic wrote:
> > On Thu, 10 Sep 2020 13:36:09 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >=20
> > > On Mon, 7 Sep 2020 17:22:53 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:
> > >=20
> > > > On Fri, 24 Jul 2020 12:57:44 +1000
> > > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > > >=20
> > > > > At least some s390 cpu models support "Protected Virtualization" =
(PV),
> > > > > a mechanism to protect guests from eavesdropping by a compromised
> > > > > hypervisor.
> > > > >=20
> > > > > This is similar in function to other mechanisms like AMD's SEV and
> > > > > POWER's PEF, which are controlled bythe "host-trust-limitation"
> > > > > machine option.  s390 is a slightly special case, because we alre=
ady
> > > > > supported PV, simply by using a CPU model with the required featu=
re
> > > > > (S390_FEAT_UNPACK).
> > > > >=20
> > > > > To integrate this with the option used by other platforms, we
> > > > > implement the following compromise:
> > > > >=20
> > > > >  - When the host-trust-limitation option is set, s390 will recogn=
ize
> > > > >    it, verify that the CPU can support PV (failing if not) and set
> > > > >    virtio default options necessary for encrypted or protected gu=
ests,
> > > > >    as on other platforms.  i.e. if host-trust-limitation is set, =
we
> > > > >    will either create a guest capable of entering PV mode, or fail
> > > > >    outright =20
> > > >=20
> > > > Shouldn't we also fail outright if the virtio features are not PV
> > > > compatible (invalid configuration)?
> > > >=20
> > > > I would like to see something like follows as a part of this series.
> > > > ----------------------------8<--------------------------
> > > > From: Halil Pasic <pasic@linux.ibm.com>
> > > > Date: Mon, 7 Sep 2020 15:00:17 +0200
> > > > Subject: [PATCH] virtio: handle host trust limitation
> > > >=20
> > > > If host_trust_limitation_enabled() returns true, then emulated virt=
io
> > > > devices must offer VIRTIO_F_ACCESS_PLATFORM, because the device is =
not
> > > > capable of accessing all of the guest memory. Otherwise we are in
> > > > violation of the virtio specification.
> > > >=20
> > > > Let's fail realize if we detect that VIRTIO_F_ACCESS_PLATFORM featu=
re is
> > > > obligatory but missing.
> > > >=20
> > > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > > ---
> > > >  hw/virtio/virtio.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >=20
> > > > diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> > > > index 5bd2a2f621..19b4b0a37a 100644
> > > > --- a/hw/virtio/virtio.c
> > > > +++ b/hw/virtio/virtio.c
> > > > @@ -27,6 +27,7 @@
> > > >  #include "hw/virtio/virtio-access.h"
> > > >  #include "sysemu/dma.h"
> > > >  #include "sysemu/runstate.h"
> > > > +#include "exec/host-trust-limitation.h"
> > > > =20
> > > >  /*
> > > >   * The alignment to use between consumer and producer parts of vri=
ng.
> > > > @@ -3618,6 +3619,12 @@ static void virtio_device_realize(DeviceStat=
e *dev, Error **errp)
> > > >      /* Devices should either use vmsd or the load/save methods */
> > > >      assert(!vdc->vmsd || !vdc->load);
> > > > =20
> > > > +    if (host_trust_limitation_enabled(MACHINE(qdev_get_machine()))
> > > > +        && !virtio_host_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM)=
) {
> > > > +        error_setg(&err, "devices without VIRTIO_F_ACCESS_PLATFORM=
 are not compatible with host trust imitation");
> > > > +        error_propagate(errp, err);
> > > > +        return;
> > >=20
> > > How can we get here? I assume only if the user explicitly turned the
> > > feature off while turning HTL on, as otherwise patch 9 should have
> > > taken care of it?
> > >=20
> >=20
> > Yes, we can get here only if iommu_platform is explicitly turned off.
>=20
> Right.. my assumption was that if you really want to specify
> contradictory options, you get to keep both pieces.  Or, more
> seriously, there might be some weird experimental cases where this
> combination could do something useful if you really know what you're
> doing, and explicitly telling qemu to do this implies you know what
> you're doing.
>=20

I guess this deserves at least a warning for the case of someone that
doesn't really know what they're doing, eg. borrowing a complex QEMU
command line or libvirt XML from somewhere else ?

--Sig_/qq16TA.RbBJtpBs.5w6QU1y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAl9bGHAACgkQcdTV5YIv
c9aLFw//SBEpcqO6AeWXyaEf1IuQO8Jdfa+YbYgQ+f3kss0PYrJVnbHDS6NKGHEV
VCHF1PfT4R7ELXOFc8cCIEmbF0X0giH4fDoTxhSUNz33hC5GRYe5mJp2DKHcuDYo
6wH0mmBu0OqU3Sa7Bce7kaWSovngQqxlTBFLSK44szJ/W+Pm5uG8F6LYEEJbQLr+
L0fMyJusrozpPESWcHoRAk9C2EiUi7xGVUUcCBEkF9Iqa5f5D2h/bNzqVHzRQhTm
LIaL5M8rH21Np/UYD23HZEDf4TDgfJo2NoZFkdGUDnQ9QNS5xBdG5xFuNlPEixTi
RyWWogofOp06IEmmFi3KitZ7EjATJSVi+Zl2xcdK3LMj8ehd6GPOqzNOK1oNzVUS
T8vfgzjGG8NtcV4GAzrX8NdRdg+4q8d7nWleUiSxh5acDCFkvrsjKoSVZGh3XAOX
9p4Rk9aXKB2eSQirglsgbqbUMgAH0VpOpury69BM1CSMFGJlFdgY4M/JrGhlsldM
/Io/Dv/C91UyCG52P5Nv7KD0C5hkpFsvKO207LuR+jbRu9seOiF6cLrnRyS6F+w3
6UGAub1oZamWpnbLZ3/c/WWhymR8MIFKaUe+YCxjI+qRJPUj/WcuLKCy+/0zjWCl
qph/FWyVqrKJRkoqDJUz+0Q8rvI1sYTuWc6ljJbemtXQyGT7tHo=
=/qie
-----END PGP SIGNATURE-----

--Sig_/qq16TA.RbBJtpBs.5w6QU1y--
