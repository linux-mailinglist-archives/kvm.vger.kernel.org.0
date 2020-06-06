Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A811F05D4
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 10:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgFFIp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 04:45:56 -0400
Received: from ozlabs.org ([203.11.71.1]:59833 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFFIpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 04:45:54 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49fClh3xm1z9sSc; Sat,  6 Jun 2020 18:45:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591433152;
        bh=YoMdeniGBGn7TbfMONb8QyzbR+59Cq/gi2fKNL7nRBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZlhhrLEwdJSBK46arLMA0LpVtzngJJQ+Doq0U1Fz+A7y0PoSsylrPH7nEDkieKkS
         y3uxYbQKR17t4YdoDzNNzdl9JRYH8pTZAwX6Au9pB/spDiAkViWQ1uagufCwB643Zz
         skLebW6XgA2iVdVLqTKfWkzkKJTJDj5RyXFDCxjI=
Date:   Sat, 6 Jun 2020 18:24:58 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200606082458.GK228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <87tuzr5ts5.fsf@morokweng.localdomain>
 <20200604062124.GG228651@umbus.fritz.box>
 <87r1uu1opr.fsf@morokweng.localdomain>
 <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com>
 <87pnae1k99.fsf@morokweng.localdomain>
 <ec71a816-b9e6-6f06-def6-73eb5164b0cc@redhat.com>
 <87sgf9i8sy.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cy+5HEalSgyXkpVS"
Content-Disposition: inline
In-Reply-To: <87sgf9i8sy.fsf@morokweng.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Cy+5HEalSgyXkpVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 05, 2020 at 05:01:07PM -0300, Thiago Jung Bauermann wrote:
>=20
> Paolo Bonzini <pbonzini@redhat.com> writes:
>=20
> > On 05/06/20 01:30, Thiago Jung Bauermann wrote:
> >> Paolo Bonzini <pbonzini@redhat.com> writes:
> >>> On 04/06/20 23:54, Thiago Jung Bauermann wrote:
> >>>> QEMU could always create a PEF object, and if the command line defin=
es
> >>>> one, it will correspond to it. And if the command line doesn't defin=
e one,
> >>>> then it would also work because the PEF object is already there.
> >>>
> >>> How would you start a non-protected VM?
> >>> Currently it's the "-machine"
> >>> property that decides that, and the argument requires an id
> >>> corresponding to "-object".
> >>
> >> If there's only one object, there's no need to specify its id.
> >
> > This answers my question.  However, the property is defined for all
> > machines (it's in the "machine" class), so if it takes the id for one
> > machine it does so for all of them.
>=20
> I don't understand much about QEMU internals, so perhaps it's not
> practical to implement but from an end-user perspective I think this
> logic can apply to all architectures (since my understanding is that all
> of them use only one object): make the id optional. If it's not
> specified, then there must be only one object, and the property will
> implicitly refer to it.
>=20
> Then, if an architecture doesn't need to specify parameters at object
> creation time, it can be implicitly created and the user doesn't have to
> worry about this detail.

Seems overly complicated to me.  We could just have it always take an
ID, but for platforms with no extra configuration make the
pre-fabricated object available under a well-known name.

That's essentially the same as the way you can add a device to the
"pci.0" bus without having to instantiate and name that bus yourself.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Cy+5HEalSgyXkpVS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7bUtcACgkQbDjKyiDZ
s5KGWRAAx4ggMFCRE7+DfjUQOmDiAMZxpB19AEh1v3ohIYHDxx88pn0seVlvJqIx
ujGOc891w1XcGHuw3Umye5OOB1KM+qgYFvMlBYkqj7IrRIcU87P8bVb8WKWuCSJc
txUd2CYUHHWJpI8TRdKw/BzkflOF9NTQA51SFEzupj4mTpGDwnN9ZygS2Lxv+WbG
CNz5MyU1fP5GA3hKBDhp6HN1CK0SPk85DPx4gRCSE7mj5BDA7kElB+dCwvvvAl18
bD0UrVkpaENCNXLbPYTTRydi0OSF6NP6TWQ449dBHsjcOVOXhlwK+X5QtNYtFVzg
k5xYV4Rluu4JsgNO3fZIleFcZn1145FWpEokUPwqnCVRPW84zeRI5AhHu8dTEL+v
hgy/9cYZjPFWLBI8YPtdZxshUCFRHL0nNmPabxyO0xmg+kYaHuTasdS+nJMPSU/k
c3hGWBCsEIGE19akQDCyd1/oFumZJyqZXPlDLoHMS4+lQSP8o30q8TZAKGGFr+2B
FtjRYKIKltfAsapyXzHAIkEXy59anPnDMcFAG/xNh3P0WePC1p+CAjohfKK9oYG6
TunO7a27yInF7NowUhfcAmtTyRyEXS57A0XVmrfLeW3gdsn+J+ts+H8PeM2Kb4vP
ATwzQEghKh235o5aAQygw7QNi94VbS1mPHWa/kLnVHvxmFmKxcY=
=1I5c
-----END PGP SIGNATURE-----

--Cy+5HEalSgyXkpVS--
