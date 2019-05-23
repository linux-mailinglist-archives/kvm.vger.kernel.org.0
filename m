Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0EB27967
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 11:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfEWJhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 05:37:34 -0400
Received: from 2.mo7.mail-out.ovh.net ([87.98.143.68]:48608 "EHLO
        2.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEWJhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 05:37:33 -0400
Received: from player797.ha.ovh.net (unknown [10.109.146.106])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 7E0B311DCE5
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 08:01:29 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player797.ha.ovh.net (Postfix) with ESMTPSA id 1729262D9AF4;
        Thu, 23 May 2019 06:01:24 +0000 (UTC)
Date:   Thu, 23 May 2019 08:01:23 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU
 and RAM limits
Message-ID: <20190523080123.6e700a1e@bahia.lan>
In-Reply-To: <20190522233043.GO30423@umbus.fritz.box>
References: <20190520071514.9308-1-clg@kaod.org>
        <20190522233043.GO30423@umbus.fritz.box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bHinS0IXP.Nh/xogOoPORG1"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 3979211747638352358
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/bHinS0IXP.Nh/xogOoPORG1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 May 2019 09:30:43 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Mon, May 20, 2019 at 09:15:11AM +0200, C=C3=A9dric Le Goater wrote:
> > Hello,
> >=20
> > Here are a couple of fixes for issues in the XIVE KVM device when
> > testing the limits : RAM size and number of vCPUS. =20
>=20
> How serious are the problems these patches fix?  I'm wondering if I
> need to make a backport for RHEL8.1.
>=20

Patch 2/3 fixes a QEMU error when hot-unplugging a vCPU:

qemu-system-ppc64: KVM_SET_DEVICE_ATTR failed: Group 4 attr 0x0000000000000=
046: Invalid argument


Patch 3/3 fixes an issue where the guest freezes at some point when doing
vCPU hot-plug/unplug in a loop.


Both issues have a BZ at IBM. They can be mirrored to RH if needed.

> >=20
> > Based on 5.2-rc1.
> >=20
> > Available on GitHub:
> >=20
> >     https://github.com/legoater/linux/commits/xive-5.2
> >=20
> > Thanks,
> >=20
> > C.=20
> >=20
> > C=C3=A9dric Le Goater (3):
> >   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
> >   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
> >     reseting
> >   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
> >     identifier
> >=20
> >  arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++-----------
> >  1 file changed, 27 insertions(+), 19 deletions(-)
> >  =20
>=20


--Sig_/bHinS0IXP.Nh/xogOoPORG1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAlzmNzMACgkQcdTV5YIv
c9aj2xAAo/lpIZAk8uAymFmCacMO880OG62USpKrjcLOo9CDLFC5BmrteRsnsUXl
JSDkLGVJPMUHHsFFRV2jmPre/e6zZ1bOovS/4MQ+kld/zUzYfIxuN2pAv3L/BP+W
2wXwq+M/ugMTK5d1kb8YyyqmVBCRQqbiDknGsYRe/mdigVrv/Q8xzwjtFVVQgGWY
8pubnBPZJJglGw3aryuE1UHt9U3b5mfpC1TIc5+sACi2fk2Rp6/3AHht/n6v/S89
D7Y3e19FcxB8C+q0TcpDnA3Gx/0TJzk0H+ROers8njFeeAD42ROzr4fBmx45OHxF
jX7TKJABfTRtJEvrojYjnVEjuWT8N611Fs3U480hQ/atkkb32EI10FQOmkTXgC3m
t3TmZbiyu/aLDUaLqg59IsRe9mEp9xGMauO6sADC3NLJB7LVUQEthp0Wv6yz/ej/
tvnV+bUG9s0OOO4MRSfKq+LqhgD6Xj9591zfc1/2YBl5+QZAolRi4re32KjJ6CUN
xqBC6MCuG9ggjedivLZWIMm3btfVQdQYyFqBo3XAPjJAPk+niGaSY9Uk4+J65O69
hjBjw5+dtenCqcp8FSX70rqCNukDj5FrTDHCp0JegOACC8gN281up6mPUcIyrkUa
UX3Hn4rasBGmrTvK0NkDZ3YZjaqm9+KBFU8SwU1Yd/Fh5GqxldI=
=GjBz
-----END PGP SIGNATURE-----

--Sig_/bHinS0IXP.Nh/xogOoPORG1--
