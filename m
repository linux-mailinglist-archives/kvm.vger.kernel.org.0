Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101E522EAA8
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgG0LEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:04:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726311AbgG0LEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 07:04:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RB24Jw112155
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 07:04:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32hs0s08jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 07:04:18 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06RB4Iml121040
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 07:04:18 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32hs0s08hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 07:04:17 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RB0XCQ001681;
        Mon, 27 Jul 2020 11:04:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 32gcr0h9tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 11:04:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RB4D4T66060668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 11:04:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12429A405B;
        Mon, 27 Jul 2020 11:04:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD4DAA4062;
        Mon, 27 Jul 2020 11:04:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.25])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 11:04:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix inline asm on gcc10
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        david@redhat.com
Cc:     thuth@redhat.com, borntraeger@de.ibm.com
References: <20200727102643.15439-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e7525ba5-3c08-79ad-1627-f4336038c843@linux.ibm.com>
Date:   Mon, 27 Jul 2020 13:04:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200727102643.15439-1-imbrenda@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g3V075eSEBvnpxX7aMSiS3yrlT259AT3q"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_07:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g3V075eSEBvnpxX7aMSiS3yrlT259AT3q
Content-Type: multipart/mixed; boundary="VRDQCdayJNGp9L27bPLFipS2YWl5EisR6"

--VRDQCdayJNGp9L27bPLFipS2YWl5EisR6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/20 12:26 PM, Claudio Imbrenda wrote:
> Fix compilation issues on 390x with gcc 10.
>=20
> Simply mark the inline functions that lead to a .insn with a variable
> opcode as __always_inline, to make gcc 10 happy.

Thanks, picked

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/cpacf.h |  5 +++--
>  s390x/emulator.c      | 25 +++++++++++++------------
>  2 files changed, 16 insertions(+), 14 deletions(-)
>=20
> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
> index ae2ec53..2146a01 100644
> --- a/lib/s390x/asm/cpacf.h
> +++ b/lib/s390x/asm/cpacf.h
> @@ -11,6 +11,7 @@
>  #define _ASM_S390_CPACF_H
> =20
>  #include <asm/facility.h>
> +#include <linux/compiler.h>
> =20
>  /*
>   * Instruction opcodes for the CPACF instructions
> @@ -145,7 +146,7 @@ typedef struct { unsigned char bytes[16]; } cpacf_m=
ask_t;
>   *
>   * Returns 1 if @func is available for @opcode, 0 otherwise
>   */
> -static inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *ma=
sk)
> +static __always_inline void __cpacf_query(unsigned int opcode, cpacf_m=
ask_t *mask)
>  {
>  	register unsigned long r0 asm("0") =3D 0;	/* query function */
>  	register unsigned long r1 asm("1") =3D (unsigned long) mask;
> @@ -183,7 +184,7 @@ static inline int __cpacf_check_opcode(unsigned int=
 opcode)
>  	}
>  }
> =20
> -static inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)=

> +static __always_inline int cpacf_query(unsigned int opcode, cpacf_mask=
_t *mask)
>  {
>  	if (__cpacf_check_opcode(opcode)) {
>  		__cpacf_query(opcode, mask);
> diff --git a/s390x/emulator.c b/s390x/emulator.c
> index 1ee0df5..70ef51a 100644
> --- a/s390x/emulator.c
> +++ b/s390x/emulator.c
> @@ -14,6 +14,7 @@
>  #include <asm/cpacf.h>
>  #include <asm/interrupt.h>
>  #include <asm/float.h>
> +#include <linux/compiler.h>
> =20
>  struct lowcore *lc =3D NULL;
> =20
> @@ -46,7 +47,7 @@ static void test_spm_ipm(void)
>  	__test_spm_ipm(0, 0);
>  }
> =20
> -static inline void __test_cpacf(unsigned int opcode, unsigned long fun=
c,
> +static __always_inline void __test_cpacf(unsigned int opcode, unsigned=
 long func,
>  				unsigned int r1, unsigned int r2,
>  				unsigned int r3)
>  {
> @@ -59,7 +60,7 @@ static inline void __test_cpacf(unsigned int opcode, =
unsigned long func,
>  		         [r1] "i" (r1), [r2] "i" (r2), [r3] "i" (r3));
>  }
> =20
> -static inline void __test_cpacf_r1_odd(unsigned int opcode)
> +static __always_inline void __test_cpacf_r1_odd(unsigned int opcode)
>  {
>  	report_prefix_push("r1 odd");
>  	expect_pgm_int();
> @@ -68,7 +69,7 @@ static inline void __test_cpacf_r1_odd(unsigned int o=
pcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_r1_null(unsigned int opcode)
> +static __always_inline void __test_cpacf_r1_null(unsigned int opcode)
>  {
>  	report_prefix_push("r1 null");
>  	expect_pgm_int();
> @@ -77,7 +78,7 @@ static inline void __test_cpacf_r1_null(unsigned int =
opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_r2_odd(unsigned int opcode)
> +static __always_inline void __test_cpacf_r2_odd(unsigned int opcode)
>  {
>  	report_prefix_push("r2 odd");
>  	expect_pgm_int();
> @@ -86,7 +87,7 @@ static inline void __test_cpacf_r2_odd(unsigned int o=
pcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_r2_null(unsigned int opcode)
> +static __always_inline void __test_cpacf_r2_null(unsigned int opcode)
>  {
>  	report_prefix_push("r2 null");
>  	expect_pgm_int();
> @@ -95,7 +96,7 @@ static inline void __test_cpacf_r2_null(unsigned int =
opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_r3_odd(unsigned int opcode)
> +static __always_inline void __test_cpacf_r3_odd(unsigned int opcode)
>  {
>  	report_prefix_push("r3 odd");
>  	expect_pgm_int();
> @@ -104,7 +105,7 @@ static inline void __test_cpacf_r3_odd(unsigned int=
 opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_r3_null(unsigned int opcode)
> +static __always_inline void __test_cpacf_r3_null(unsigned int opcode)
>  {
>  	report_prefix_push("r3 null");
>  	expect_pgm_int();
> @@ -113,7 +114,7 @@ static inline void __test_cpacf_r3_null(unsigned in=
t opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_mod_bit(unsigned int opcode)
> +static __always_inline void __test_cpacf_mod_bit(unsigned int opcode)
>  {
>  	report_prefix_push("mod bit");
>  	expect_pgm_int();
> @@ -122,7 +123,7 @@ static inline void __test_cpacf_mod_bit(unsigned in=
t opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_invalid_func(unsigned int opcode)
> +static __always_inline void __test_cpacf_invalid_func(unsigned int opc=
ode)
>  {
>  	report_prefix_push("invalid subfunction");
>  	expect_pgm_int();
> @@ -137,7 +138,7 @@ static inline void __test_cpacf_invalid_func(unsign=
ed int opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_invalid_parm(unsigned int opcode)
> +static __always_inline void __test_cpacf_invalid_parm(unsigned int opc=
ode)
>  {
>  	report_prefix_push("invalid parm address");
>  	expect_pgm_int();
> @@ -146,7 +147,7 @@ static inline void __test_cpacf_invalid_parm(unsign=
ed int opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_cpacf_protected_parm(unsigned int opcode)
> +static __always_inline void __test_cpacf_protected_parm(unsigned int o=
pcode)
>  {
>  	report_prefix_push("protected parm address");
>  	expect_pgm_int();
> @@ -157,7 +158,7 @@ static inline void __test_cpacf_protected_parm(unsi=
gned int opcode)
>  	report_prefix_pop();
>  }
> =20
> -static inline void __test_basic_cpacf_opcode(unsigned int opcode)
> +static __always_inline void __test_basic_cpacf_opcode(unsigned int opc=
ode)
>  {
>  	bool mod_bit_allowed =3D false;
> =20
>=20



--VRDQCdayJNGp9L27bPLFipS2YWl5EisR6--

--g3V075eSEBvnpxX7aMSiS3yrlT259AT3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8etKwACgkQ41TmuOI4
ufjvFRAAqc6UaUG7DZEERN9vO4Qjj6osCbbKZKNU9sKrmu+C3bkB9WgS2J/oVtDz
Kw/RfES7l09iQVEcj618jJ6zkv5EdPEH5ZgRMhJD/hGq/ETedwIvxVt1kVsURkoM
d5jAvP5UR9Xdd+07FEa6FTmECYI0iHIUavmXa246NnV/MIIt2J1hramPRJXUeDsz
vSOmp+8QgnbTyFtIDFmZdDBDXSbkC+HWriX+vWd3iUFXxe90ydx7IWLr3wbAZZMt
616tNkeXATC/gE7/Uf+Y26bottGIEr3IPD7EDchdgnOOwtc7BXEu+XGrrk+l9wb4
MFaQQvFppSIufwYJiGWpMo48q4NGg3qY5zBzWoukmppXAc5XbCuzNb3/9s7mhDE3
s41zvuKhRKBnXjaR1f7Ct2qVGrvZtV9bZUfPSW5Lk63gTGogShbJLLhRGWYpagtz
okHsNV1RLAHnPi4BKU7uqMLyV0tDTKT1o/dEVstpWtGFVdCeNrZH6rPAN/EIKK+9
0A2GG8u8aK0m44/lmgExlyVEnQFOsjdIdHSePozk+uM9oFeKrs2e9/6boisUDqwx
veYbb2Qd9A9JGehb2OfGigCPZo2X8zfHHGUtRssCLr764Z97GhntfJZ9J0vBLN3O
1AKUpHBI78ZCYBz9mxZ5BhmN6+KSHYCXEhsEZACwcOzOMAi7XS4=
=7AgU
-----END PGP SIGNATURE-----

--g3V075eSEBvnpxX7aMSiS3yrlT259AT3q--

