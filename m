Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7291EDCFC
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgFDGMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49159 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgFDGMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:30 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRc6t8lz9sSy; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251148;
        bh=UfHpIetu+x/sdr/nACJK1BSB+jKFre6qOnaLAnl7EJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzqaisgWWJgjbD8dV3icCSi5cQzy6y9IW1peDkPPtTg8SKJuj5Yc5sAGfnNr9y2bs
         t8o/abqTw9cXJe1FqNd7QpJTAc3nWXahDplyl3vd5k8+OtBUU4Y0Tg/vMmJjZvWP/5
         Vjsrc2dRgbCNzW/xH+klIv2H7jj/KjtaC4gritTg=
Date:   Thu, 4 Jun 2020 15:56:38 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 14/18] guest memory protection: Rework the
 "memory-encryption" property
Message-ID: <20200604055638.GF228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-15-david@gibson.dropbear.id.au>
 <4061fcf0-ba76-5124-74eb-401a0b91d900@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <4061fcf0-ba76-5124-74eb-401a0b91d900@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 08:54:42PM -0700, Richard Henderson wrote:
> On 5/20/20 8:43 PM, David Gibson wrote:
> > +++ b/include/hw/boards.h
> > @@ -12,6 +12,8 @@
> >  #include "qom/object.h"
> >  #include "hw/core/cpu.h"
> > =20
> > +typedef struct GuestMemoryProtection GuestMemoryProtection;
> > +
>=20
> I think this needs to be in include/qemu/typedefs.h,
> and the other typedef in patch 10 needs to be moved there.
>=20
> IIRC, clang warns about duplicate typedefs.

Not, apparently, with the clang version I have, but I've made the
change anyway.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YjRQACgkQbDjKyiDZ
s5IpmQ/+JtlwtOGwoMALm7UoBUn1GIlIXce9xTHg9BnZan8axwvpQc46HsCtjcK8
CPcTRq5w6MXbxIskXMo3+hmkYRWIcH/SkSbzTVxWm4Tl8Bit7AWyaGOoFzZTqahz
2/hyCdcRoKjQ6Ur2pWRhtdImFl1hT/tFW8pkfzhn9s5N8s/C5Re2JjugdYvKFljs
ICcUgtqJzbsG1MPEBy1SL3S7FQpqTTwe57+KkGZ0YdY2v1zTY9tUREPp+HlFBXx+
mdaleEekfAbqC4Eddxhjgyg74332oNYooMOAAqx1X5+kJww0MiptBABGH99iFlyJ
lVNbJ3ZCuF+Tm0m4JqBsnTnVcElyi5vHthwgrduj7u9nJXtic8tveHDvLvdWxqbh
mr/Mi4pMfozVqgfmce6cXiNnupqMhcLUuST5CgpOkKw0shZZUU+YmR3Jv3+koAaI
r+d9mW3dtzdnupNafpckbBJB0NX6VUslT82mJxj8yC0xBZnec9G0n14qYyD4cn/X
pAjGu0US6lA5U8iLZJmjmV9HY4G4xUmdoQKwgTGTJoOyZzZ0WOYtq3MSAmrDK2xk
jpvUrzleaQLAAdsaAjUUHto0rVmtSId0UgLvDPlUpoUxSvIF2BQTjNJBz7miomWr
NZ/Q8Vpfl+YpjSkQNTfJFjA0tAAlHzwLapJEwDsy8bqCFCvf3oM=
=sAi+
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
