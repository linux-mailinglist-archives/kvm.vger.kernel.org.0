Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E834F544
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhCaAEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 20:04:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58577 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhCaAEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 20:04:10 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F96486FpFz9sXb; Wed, 31 Mar 2021 11:04:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1617149048;
        bh=1wESX0fM69PYD4lcvODC8vbHakR3U26mBjouI2BnPxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfLzQ+EaUIuPVkJNQLikHcVagjyd62ZAkhNV6BjYOYgKcJ0gz2KCZ+fBQcCYv806q
         o56g2ajY7KUdzwv31G6FjK0n8tSXHL0YCujpZ9SgeFFKXmYOcmW1IPjIMj3FWSh9Xm
         3OrQwPX4uzkuI8UHekY9k57WzHnbhXz2dLqMek1E=
Date:   Wed, 31 Mar 2021 10:34:59 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: Re: [PATCH v3 2/3] ppc: Rename current DAWR macros and variables
Message-ID: <YGO1o/tdrOx8upon@yekko.fritz.box>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
 <20210330095350.36309-3-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EeM0UwKCuSFFeCYh"
Content-Disposition: inline
In-Reply-To: <20210330095350.36309-3-ravi.bangoria@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--EeM0UwKCuSFFeCYh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 03:23:49PM +0530, Ravi Bangoria wrote:
> Power10 is introducing second DAWR. Use real register names (with
> suffix 0) from ISA for current macros and variables used by Qemu.
>=20
> One exception to this is KVM_REG_PPC_DAWR[X]. This is from kernel
> uapi header and thus not changed in kernel as well as Qemu.
>=20
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  include/hw/ppc/spapr.h          | 2 +-
>  target/ppc/cpu.h                | 4 ++--
>  target/ppc/translate_init.c.inc | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 47cebaf3ac..b8985fab5b 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -363,7 +363,7 @@ struct SpaprMachineState {
> =20
>  /* Values for 2nd argument to H_SET_MODE */
>  #define H_SET_MODE_RESOURCE_SET_CIABR           1
> -#define H_SET_MODE_RESOURCE_SET_DAWR            2
> +#define H_SET_MODE_RESOURCE_SET_DAWR0           2
>  #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>  #define H_SET_MODE_RESOURCE_LE                  4
> =20
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index e73416da68..cd02d65303 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1459,10 +1459,10 @@ typedef PowerPCCPU ArchCPU;
>  #define SPR_MPC_BAR           (0x09F)
>  #define SPR_PSPB              (0x09F)
>  #define SPR_DPDES             (0x0B0)
> -#define SPR_DAWR              (0x0B4)
> +#define SPR_DAWR0             (0x0B4)
>  #define SPR_RPR               (0x0BA)
>  #define SPR_CIABR             (0x0BB)
> -#define SPR_DAWRX             (0x0BC)
> +#define SPR_DAWRX0            (0x0BC)
>  #define SPR_HFSCR             (0x0BE)
>  #define SPR_VRSAVE            (0x100)
>  #define SPR_USPRG0            (0x100)
> diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.=
c.inc
> index c03a7c4f52..879e6df217 100644
> --- a/target/ppc/translate_init.c.inc
> +++ b/target/ppc/translate_init.c.inc
> @@ -7748,12 +7748,12 @@ static void gen_spr_book3s_dbg(CPUPPCState *env)
> =20
>  static void gen_spr_book3s_207_dbg(CPUPPCState *env)
>  {
> -    spr_register_kvm_hv(env, SPR_DAWR, "DAWR",
> +    spr_register_kvm_hv(env, SPR_DAWR0, "DAWR0",
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          &spr_read_generic, &spr_write_generic,
>                          KVM_REG_PPC_DAWR, 0x00000000);
> -    spr_register_kvm_hv(env, SPR_DAWRX, "DAWRX",
> +    spr_register_kvm_hv(env, SPR_DAWRX0, "DAWRX0",
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          SPR_NOACCESS, SPR_NOACCESS,
>                          &spr_read_generic, &spr_write_generic,

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--EeM0UwKCuSFFeCYh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBjtaEACgkQbDjKyiDZ
s5KbCw//fM9/nwuCd4wH/uS/k4Mq7JsD3mINY6zUVTnjSWy0oZqUkjOnhZayeFXT
P8QGmXOFgOs59APhcm7GPevI6snGIgwLuKlY7S+CcLVANh75Mx+Ha+IxEr5av/DI
5dpOkG9MfmOJKy362MdNlMTK2JFG8zFfljTvLNf/ciAI9k+mcFt7DO2BqGkqvUmy
u953UP6KjZx/17KaO/E92JEAtFeDcw6w0qqyMktezI1tMJKioovnn2Z4fUcynAZ4
Gb1tzXAMtsYA6BN+VtjGGk6lBBwnBtQLOjoBYoMzrQ6Aru8NjzysYxFcRJhTMOIc
UBg9nYLEP5b4J7470Aoz/ANgvONHbR0YSEX9ruOHadv6tmWv+4Yd+Z1r83aFJB92
eSfU8bmBAxWP6lS0HDAoJPjEJvMKVJSYcXTOBwUwSGXIcafvhUPzGelwZBE7PVyf
HsQX+z1rfNwtC0tQGzsKsRC4YWBOMyKEUyGJewToyjXgTcLQXmSpnm/UaPh7zEpZ
YgI1mqxwuiTQljVoDc8/XyHCCdtCEDPEaZjO8lJS8evGNP2v+Ejct6RJ0Biqofl9
WXQK5MrvR1GjmjILhZZEOnMNzCBDFDuJv0gZyv27w1DzvzARNIyWimLnfF+udUuS
H4ETsfeYOgt9AfSUqER307Dx+D1TzRJPgEBk724ohmWI83EIZYg=
=U0o3
-----END PGP SIGNATURE-----

--EeM0UwKCuSFFeCYh--
