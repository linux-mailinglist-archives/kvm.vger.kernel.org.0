Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A867233CC7
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbgGaBKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 21:10:01 -0400
Received: from ozlabs.org ([203.11.71.1]:53909 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730904AbgGaBKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 21:10:00 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BHq2H0fgrz9sTC; Fri, 31 Jul 2020 11:09:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1596157799;
        bh=2jWGzFrX2arc6ubChZExLNp+G15CQRbN3NIzN2ZoFTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUrRiev07QhEDqFPfEVWZpmi2W7Ogd7HT53SYkHGWtlaJCp+4L7q1FFcIx/8TuPXA
         c7f1wabp1rJPPFu2/L2TW678AdRUY+0uFPt83r0xGIUHur2Qplfhhi9TEWrXxkO9LJ
         S5scm3refphd/STkC2ryHrKSYyXXTYuVzwn3Ga5I=
Date:   Fri, 31 Jul 2020 10:09:34 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org,
        Kaige Li <likaige@loongson.cn>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-for-5.1? v2 1/2] qemu/osdep: Make QEMU_VMALLOC_ALIGN
 unsigned long
Message-ID: <20200731000934.GA12398@yekko.fritz.box>
References: <20200730141245.21739-1-philmd@redhat.com>
 <20200730141245.21739-2-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20200730141245.21739-2-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 04:12:44PM +0200, Philippe Mathieu-Daud=E9 wrote:
> QEMU_VMALLOC_ALIGN is sometimes expanded to signed type,
> other times to unsigned. Unify using unsigned.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  include/qemu/osdep.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index 20872e793e..085df8d508 100644
> --- a/include/qemu/osdep.h
> +++ b/include/qemu/osdep.h
> @@ -454,10 +454,10 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>     /* Use 2 MiB alignment so transparent hugepages can be used by KVM.
>        Valgrind does not support alignments larger than 1 MiB,
>        therefore we need special code which handles running on Valgrind. =
*/
> -#  define QEMU_VMALLOC_ALIGN (512 * 4096)
> +#  define QEMU_VMALLOC_ALIGN (512 * 4096UL)
>  #elif defined(__linux__) && defined(__s390x__)
>     /* Use 1 MiB (segment size) alignment so gmap can be used by KVM. */
> -#  define QEMU_VMALLOC_ALIGN (256 * 4096)
> +#  define QEMU_VMALLOC_ALIGN (256 * 4096UL)
>  #elif defined(__linux__) && defined(__sparc__)
>  #include <sys/shm.h>
>  #  define QEMU_VMALLOC_ALIGN MAX(qemu_real_host_page_size, SHMLBA)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8jYT0ACgkQbDjKyiDZ
s5KjwA//eKV+bR6DCp87g7ELnLlOb6HbZW5XRxIG0gdQMtPQ+ToM4HaYm4q2fnCx
Th/siEebjy9xc2Z/6Tx7dOlc7U0eceaJj+6JlowbzadZSV8C/Da2XQh1BcHyA1Uy
OUuFb8lH9YuetFVOYsL23HVRScDNtD+jueTQhnhIMsBHrnFReKcjUMWmiAUu5Z+H
+9ggSarO53o4F9w/QBfavaonRPWIZn++81zZGImJhfNvz8dUbjRjiRnEQ6eSS60H
DQoNollFlDh6r+Pp5g8h/NL/Z3Z2FpjmEh786IBsgnSDSD2JKDwpug6pXnV+Urpo
0QT1JRZ2+odhM669wCVs8oYNdm4M4r9pcATQmzeMFeWk6duzwkGYxVPpEyWhj4b8
9urtEXOgpoT3kjo/XN2T8g/zAXGaApkSBHCZQ0hyCUCx5Akvh+DHSphYVuC5B++Q
JJIWrKhXHecKzNcirHuZVBdMFlLK+W3S9rZ94AwrXV5h2iCD35uHurAqQleRraL3
zfWU5431urLrLtGMFd6AV6+72huqmA66nbO+gPFotPrDYgR+V/bbm4dtUin8SR7u
BWqAIneDqN9cmtimHi3D76vx7hoxMXSf4LI1XrNz7R9dTk94VwY96maqK1r1+s7T
AshAH9KGb8pgC1ZERj6e+BkY/shfNCleDBg2+8wVK2xiZNWbjxw=
=2zfA
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
