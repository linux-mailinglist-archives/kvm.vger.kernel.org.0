Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DD41ECF6E
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 14:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFCMHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 08:07:51 -0400
Received: from ozlabs.org ([203.11.71.1]:59683 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgFCMHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 08:07:50 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cSN44kFLz9sRW; Wed,  3 Jun 2020 22:07:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591186068;
        bh=sWOqdQiTvVrA52FGlNQ09smhuyYbRnbpUOcmb9tq01I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6C1nGLfceWXHb/W6iKaDeojmlFpvcJWyq7DTmCDeOAjbgrTincTDxC4hCxaQ5saa
         cRIpkXU/FG9pANqzg0WwH1ARi8YdEzcrWaOhGXdbIM1u4l7adN2F6tKUFdDiR5/jDj
         zhuo5TBI+iG0BEq1VAIEXibRJjx9j5TUKHyOSchQ=
Date:   Wed, 3 Jun 2020 20:09:30 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 10/18] guest memory protection: Add guest memory
 protection interface
Message-ID: <20200603100930.GB11091@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-11-david@gibson.dropbear.id.au>
 <75221e39-837e-7cd0-6ed8-42610b539370@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <75221e39-837e-7cd0-6ed8-42610b539370@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 06:44:50PM -0700, Richard Henderson wrote:
> On 5/20/20 8:42 PM, David Gibson wrote:
> > @@ -0,0 +1,29 @@
> > +#/*
>=20
> Two extraneous # at the beginning of the new files.

Huh, weird.  Fixed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7XdtoACgkQbDjKyiDZ
s5LP2w//cVaecXbxrQlZSuEdEz7dUteRJqPDww5olxL0dz61E29mF59djvhId9Bq
H7adPUalIvRCr1cZ9pR1kDbjiBS8DUcqvhaF5e6sSVm2kmJYkxyflK4aMj2XOnrb
CIYWNTadTEx1GJ4t+/kfsgVzRzuwN0dw/i0xSF3TlVCgRNlFHaFxhTNQbT7N+T58
s/ivATJc/epebCK9zRLB3fJOVB+9UtBjary0BMfD+u1DL+NM4nlVBzqF8sKzbKNH
+vf90Ts83V2JV1se7t1lrzJj/jnoae0XyphiWpvf2zoaYUh51pjqGTeRVCJ4xEdy
uFXmkE43zEWArDCaqhY0B7Q9gbecGSvxgaQ/oKAa2g7DnHYjrHCBVB3tOO6Wk4Ej
GpB6hMM8Ykpd63Cb1F96m1exGCbkhE/WBivw+itFXNyMPjBpQBb2V7V8zrAonMrb
m9TaQoi6Hw0JEOGJxzeOYc5Z08Zx7tDY27+3oG2xLWIzO0sBFVRM8Nq54g7BMSWX
UazOTABS9tJYGd8n+A+C9RAjAzJHAKLfG3L5YAhz15fh/ZrMyCgiOiEDhwnq1mte
FfjPkoLfgh2l0NMpPG8mADOQAVDPNroJ4fhx72hGQPI79dCeKU5ivpdmFDPLZUqO
Tvwk/YG99Hw27mZdbdWsnAtyiWiRKGaShWJROAHwoiL5D5kSXAw=
=WUE/
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
