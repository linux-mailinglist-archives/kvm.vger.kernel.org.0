Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4E363AAD
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 06:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhDSEyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 00:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhDSEyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 00:54:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC3C061760
        for <kvm@vger.kernel.org>; Sun, 18 Apr 2021 21:54:02 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FNvbn620Gz9vGS; Mon, 19 Apr 2021 14:53:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1618808037;
        bh=w8w/Una9oTYFSRCztOk/A2HhBtupl3pZZIKnl5xDCZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fh5wZyMuInOcnJE9nCOf3udTitwttN847nVSMu6pdkv7DkprlaIRn85UsSuf4jrKx
         4NTIODyQy8Lfa3GTXs3Fs+dCFDMBxiZN22otpwjkKURqsoMV7dHaU8PKaUu/q6dHkJ
         BIBKOf+L1qbxVn/YWTLtwwC9lHMgda8agPEGyMJQ=
Date:   Mon, 19 Apr 2021 14:47:12 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, groug@kaod.org
Subject: Re: [PATCH v5 2/3] ppc: Rename current DAWR macros and variables
Message-ID: <YH0LUDQKOu6WBA3Z@yekko.fritz.box>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-3-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uKhbdfvihr3S9uQx"
Content-Disposition: inline
In-Reply-To: <20210412114433.129702-3-ravi.bangoria@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--uKhbdfvihr3S9uQx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2021 at 05:14:32PM +0530, Ravi Bangoria wrote:
> Power10 is introducing second DAWR. Use real register names (with
> suffix 0) from ISA for current macros and variables used by Qemu.
>=20
> One exception to this is KVM_REG_PPC_DAWR[X]. This is from kernel
> uapi header and thus not changed in kernel as well as Qemu.
>=20
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

This stands independently of the other patches, so I've applied it to ppc-f=
or-6.1.

> ---
>  include/hw/ppc/spapr.h          | 2 +-
>  target/ppc/cpu.h                | 4 ++--
>  target/ppc/translate_init.c.inc | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index bf7cab7a2c..5f90bb26d5 100644
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

--uKhbdfvihr3S9uQx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmB9C1AACgkQbDjKyiDZ
s5Ib1BAAl3mnY3gtl1SjsG9umEhO9nqR1kJZAJGsP25qrQGs2WubfgWnqKKa5gOz
PhbCiZLUIb7aLc9en2pQDH5ZztA/UjbeS63u3EngGPRgBIQ0UWqyoUg2SVmLcI00
brmgd9/Hm4rGwaMtcijoRDWFTvIVpstm46VcfpXc36jEcTfBsNEqD41A8+sTTt1K
tP0/COUrSKnuR1E6Bs45x0Mpa3i6nw6QNTYQnOFbm6WuSa83A57gxRnxKjKkWjWu
mOUei/oUgN2Z+OMnK1HnqrfoNT1DLwkOG2AsAaso+Zv9Y10TOjkAHcX3hvCL71Sy
6qAUs1pph1MIideMkmBsjhmKo77Y16Ba7K0T+3KcfEjxGBf8mo1Fc8KTVZdX/3bz
QKael58ipjOqIJus1EymrQuO1gOPqrMNncHruv0qOTWYHZmINqfBHKs6zWMAl7O8
pIaQr+RHncB7alv7dmOHqmSyp2x5ohp6+5fL0rM1QhkGlB3T1hC5I07se1uKIOJp
vJ/GQJdLqojQ6zmckD3sJe7hNEk6i2FVSOg9zs9BisaZF2EoTXnah9bk6kjmqWN3
Wvis+ooTyNCy+WORLKpxCMf57kVyFK1ref0svvsidYtOuEtQmBiH8cFG9aZcXzo6
2NDGVNxsjmVbWQclsjtAx3pQJXc2h9bfQ885uoVZcKKfScAoPNM=
=Fj6p
-----END PGP SIGNATURE-----

--uKhbdfvihr3S9uQx--
