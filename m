Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3CB1EDD57
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFDGm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgFDGm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:42:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B813C05BD1E
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 23:42:28 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cx6B6VvTz9sSn; Thu,  4 Jun 2020 16:42:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591252946;
        bh=6G/gF3437maKhqjxu2Yk3xugw2aP4N0KazG6x+U1Dfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B/XRLQ5p7DfKz9GX83a8grChBaB0/LnOBbK+vpwaijYcdSBw4QTvRU4kSico5gfi6
         dxL7akTHVgNPjsb27akPHzZoEM1tQbRSpy+AE+FROEV4XGQQFo1MfIEFVUPBgqBwba
         Hca1pdSBSyhwEZDwcY3WB1hxOPO0JvHI4npyk0UE=
Date:   Thu, 4 Jun 2020 16:25:15 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>, pair@us.ibm.com,
        brijesh.singh@amd.com, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        cohuck@redhat.com, qemu-devel@nongnu.org, dgilbert@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, mdroth@linux.vnet.ibm.com,
        frankja@linux.ibm.com
Subject: Re: [RFC v2 14/18] guest memory protection: Rework the
 "memory-encryption" property
Message-ID: <20200604062515.GH228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-15-david@gibson.dropbear.id.au>
 <4061fcf0-ba76-5124-74eb-401a0b91d900@linaro.org>
 <20200604055638.GF228651@umbus.fritz.box>
 <18d57013-e17d-18c0-25b5-af2b2554f029@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Content-Disposition: inline
In-Reply-To: <18d57013-e17d-18c0-25b5-af2b2554f029@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 04, 2020 at 08:19:41AM +0200, Thomas Huth wrote:
> On 04/06/2020 07.56, David Gibson wrote:
> > On Mon, Jun 01, 2020 at 08:54:42PM -0700, Richard Henderson wrote:
> >> On 5/20/20 8:43 PM, David Gibson wrote:
> >>> +++ b/include/hw/boards.h
> >>> @@ -12,6 +12,8 @@
> >>>  #include "qom/object.h"
> >>>  #include "hw/core/cpu.h"
> >>> =20
> >>> +typedef struct GuestMemoryProtection GuestMemoryProtection;
> >>> +
> >>
> >> I think this needs to be in include/qemu/typedefs.h,
> >> and the other typedef in patch 10 needs to be moved there.
> >>
> >> IIRC, clang warns about duplicate typedefs.
> >=20
> > Not, apparently, with the clang version I have, but I've made the
> > change anyway.
>=20
> FWIW, we got rid of that duplicated typedef problem in commit
> e6e90feedb706b1b92, no need to worry about that anymore.

Ah, right.  I think I'll leave it as is though - it kind of makes
sense to have all the incomplete structure typedefs in one place.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7Yk8sACgkQbDjKyiDZ
s5IpLhAAwWHyQzsLr9RyJimMwiORUlOZsfAhbZVu7EkIL3kLBvFbyfp0NPiy9TKf
0NnXZcOW43cOnJH/W5cBjOhyoVgAIT3op9CTINXxowRiOErhWzLNSuH6G9TzA2Tt
p9Jbe9i6qzoaptGbs5uSkyJLp/NuKIC7araOVNaVqqVyTQHcdeYhOmaiwEAvqlrA
vw2wQYnOqiFISRFq/HoMyqqYl8FEKC1HgR5sXLl0cqXpPDtBCZYQr7zK5DMY25K9
hE3pS5PW7kce1g4mhrbkBGVnB9JpSpFVjV2KC4OKjaLCq6rFUHbxTKXEDGHB5WKi
K80IkOEF/62gn+xX3sNue1AYkNtm2Ylo8XGpvlfPG0MpwNnWs3tgOFbgFKCdyiKa
VbV9HAdQYC5PfFnqzeWc5ykvbiPFPNbHThqmlpvnLC+zLT1slPNMlslaNXQswxen
IxuiKI+4Ckk0SoI8/QOckrfJ81uT0hsVd1SWkx2XJd/RCCY/lwY7elfPAl4XF/Jb
1KhJlksitH74u11Frc4Z1Ypz75q225XIu3ojzM59nY9wmdxwzu5+G3Xlj02dypT/
n2bGNPscFjytp4zQmtpJJ3od1Aet7GN4hNRyJ58lN2vaOQOZW519FsyCq0dkxtwP
MtV+uMM/o3o8gzIafgeSS1h0fwxJOFBAfh8i+A+71UH3vnZBDf0=
=jYs3
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
