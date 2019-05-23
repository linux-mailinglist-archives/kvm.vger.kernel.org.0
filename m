Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D227EF7
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfEWOA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 10:00:56 -0400
Received: from 1.mo6.mail-out.ovh.net ([46.105.56.136]:58044 "EHLO
        1.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfEWOA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 10:00:56 -0400
X-Greylist: delayed 3607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 10:00:54 EDT
Received: from player760.ha.ovh.net (unknown [10.109.159.152])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 19C831CD0E7
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 14:44:29 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: groug@kaod.org)
        by player760.ha.ovh.net (Postfix) with ESMTPSA id 50A3B61B7FE5;
        Thu, 23 May 2019 12:44:23 +0000 (UTC)
Date:   Thu, 23 May 2019 14:44:19 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU
 and RAM limits
Message-ID: <20190523144419.4dfddcd5@bahia.lan>
In-Reply-To: <20190523062715.GR30423@umbus.fritz.box>
References: <20190520071514.9308-1-clg@kaod.org>
        <20190522233043.GO30423@umbus.fritz.box>
        <20190523080123.6e700a1e@bahia.lan>
        <20190523062715.GR30423@umbus.fritz.box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/D_opXZ085nm8qQAhT4NnT+H"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 10784995209467501030
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgheejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/D_opXZ085nm8qQAhT4NnT+H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 May 2019 16:27:15 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Thu, May 23, 2019 at 08:01:23AM +0200, Greg Kurz wrote:
> > On Thu, 23 May 2019 09:30:43 +1000
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > On Mon, May 20, 2019 at 09:15:11AM +0200, C=C3=A9dric Le Goater wrote=
: =20
> > > > Hello,
> > > >=20
> > > > Here are a couple of fixes for issues in the XIVE KVM device when
> > > > testing the limits : RAM size and number of vCPUS.   =20
> > >=20
> > > How serious are the problems these patches fix?  I'm wondering if I
> > > need to make a backport for RHEL8.1.
> > >  =20
> >=20
> > Patch 2/3 fixes a QEMU error when hot-unplugging a vCPU:
> >=20
> > qemu-system-ppc64: KVM_SET_DEVICE_ATTR failed: Group 4 attr 0x000000000=
0000046: Invalid argument
> >=20
> >=20
> > Patch 3/3 fixes an issue where the guest freezes at some point when doi=
ng
> > vCPU hot-plug/unplug in a loop. =20
>=20
> Oh.. weird.  It's not clear to me how it would do that.
>=20

Cedric provided a better description in some other mail: guest with 1024
vCPUs.

> > Both issues have a BZ at IBM. They can be mirrored to RH if needed. =20
>=20
> That would be helpful, thanks.
>=20

Ok, I'll take care of that.

>=20
>=20
>=20
> >  =20
> > > >=20
> > > > Based on 5.2-rc1.
> > > >=20
> > > > Available on GitHub:
> > > >=20
> > > >     https://github.com/legoater/linux/commits/xive-5.2
> > > >=20
> > > > Thanks,
> > > >=20
> > > > C.=20
> > > >=20
> > > > C=C3=A9dric Le Goater (3):
> > > >   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is rele=
ased
> > > >   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
> > > >     reseting
> > > >   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
> > > >     identifier
> > > >=20
> > > >  arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++-------=
----
> > > >  1 file changed, 27 insertions(+), 19 deletions(-)
> > > >    =20
> > >  =20
> >  =20
>=20
>=20
>=20


--Sig_/D_opXZ085nm8qQAhT4NnT+H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAlzmlaMACgkQcdTV5YIv
c9a9+w//c1q0mjRXWkXMCNkSnRSkMhwGGeelqnnnn7yjzwbgzg4A2Bnhd1BClQeb
sdV/AipzZFQWLrdJVApWh4t3xVIw+FweGn/JgDZisN6sThYA+ZGIwaVE2FrCVREF
P+QgxwjsBKPp+hFcY3Funn5oqbkY0TlrKlQ/855OigSSPa/1DAYuyN8RNeNkBnQo
y2fry50dy4duVQnr6/Kltfli8tYua95djvuDqls4jMHV4vd12+3fTERNifmCqruN
U85YpjlYw8qNY1DRBO8jH70gDx2gX6POunrZs+yrngDDgcJJ/98s6Toxn3RljGwL
vogK5/W09FjSEFWx20Fhb8ZvljRqq4EeJjTvW4gWHIANeGw4LK5EgCx/9iResdJK
LXSmQkRBhaqG2V4IeTpkGZ3eAdkH04YWCh0OIT6s4CLXJ/5R92xq7yQCAO9fu4sP
iQ0s1OHEwElaefzOvCNVBSbzF2DQ69LdNemISgH5FxzW7VPWaiDxMpanuCNjwCwl
p3XuCXTYCZArpAWKXlnoPlgdzVeDUu/dcKK6E/e6O/54R/k11ONp3Kg8OQ2xl7TP
LkXat/F2G7PyM3ZaCL4IOwzCtdfBy0eSlkV/nslK0+MsCnne11WW6uHPK3s/bd3S
k+TLtT7cSye9b7DvHXa/VpmpVonEFIcLhwpQlZWJym5ITZYAWPU=
=jacf
-----END PGP SIGNATURE-----

--Sig_/D_opXZ085nm8qQAhT4NnT+H--
