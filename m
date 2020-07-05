Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E99D214B33
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgGEInf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 04:43:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53515 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgGEInf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 04:43:35 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4B02Kd4FfGz9sSJ; Sun,  5 Jul 2020 18:43:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593938613;
        bh=Vdr+C7jMOZTKTqw46GAUMPvW/tZdesx/v+gEu7dJuEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZHjQh853bTzNSvfYDaziPwYJS1IQPGALZv7i+dVWeBQ8FinyZVlHyaL1g/sye2AEU
         K79+tWeFm9GYBnKDg29usaH2o/g9KGkeXbK6/KR+DxlTQyZ5FqGLchIzi4WWcJgJmo
         kpcSL1YOXuxR4mtCCebUeGn50c39fHseTOtH7Ie4=
Date:   Sun, 5 Jul 2020 17:38:13 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        cohuck@redhat.com, pasic@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Subject: Re: [PATCH v3 8/9] spapr: PEF: block migration
Message-ID: <20200705073813.GA12576@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-9-david@gibson.dropbear.id.au>
 <20200626103303.GE3087@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20200626103303.GE3087@work-vm>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2020 at 11:33:03AM +0100, Dr. David Alan Gilbert wrote:
> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > We haven't yet implemented the fairly involved handshaking that will be
> > needed to migrate PEF protected guests.  For now, just use a migration
> > blocker so we get a meaningful error if someone attempts this (this is =
the
> > same approach used by AMD SEV).
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>=20
> Do you expect this to happen if people run with -cpu host ?

Uh.. I don't really understand the question.  What's the connection
between cpu model and migration blocking?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8Bg2UACgkQbDjKyiDZ
s5LH7hAA5EZmRNXj1yivkiYNc1GtXGso5xsJ2GrV/CElKHDYr2mGDqCzzatQybF4
8obKns+u40a5L+QlnxwSo2HbH1svQ7/3y/mmUmgMIVqFaLDooWjjR0sp4GQnob83
AhhaSGD0HdwMH4sOvfKLTZzNoJ+GdIr3RWXArVRWxNG6DeWvdHKIzHE920Aj72dF
Mktk9hnrX2SIFgm0UJhIK5HP9U3gLaCHjsfO/asxjP5LbC4ZslVPZQrV1pD5Jehb
vDaFSkXKhlVdbnrfELub532PTJ5FRfDZb2OdKbO1AJyuZk4hbCinbc075PuOrmPB
sX/yW/Ho66UEhj5zZd7IxZ8NHMrbwBgXqh8I0pMKZ3Ml1tvoNtCMyJrH3lOR+RE6
yH4no8xbq/TF2NYKGQAwF9W1VZNeQYVBdaNpvr2F5ZMYIVDYFkOsmnS0XVZf9Qqx
qZmcpmvDdf4hiTE45eV9+mGPatvWbLcMCpvWEftOfOrGNbmsW8lF317GqXg4lAFo
mC04DVZczr5rFtEiX4RIYpF2QSh+SkESzqpXZgnSFTqT447X1ZDoXxBUx91q6EJX
ZlaacuLtRpl2wMasuvbqmjbnnAyoq/UEgH5BfA7LKptY0gOM74i7wgWsC+e3vuuf
L6GS4ETEKTen3kMjgW+o3NLRdFpgF5stP7mzdv5dsZhXtxEAWL0=
=kDum
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
