Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70619BDFB
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387800AbgDBIuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:50:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14260 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728612AbgDBIuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:50:13 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0328YAdm016039
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 04:50:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304mcc63fh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 04:50:11 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 2 Apr 2020 09:50:07 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 09:50:04 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0328o5da44040402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 08:50:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39FEEA4068;
        Thu,  2 Apr 2020 08:50:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D415FA405F;
        Thu,  2 Apr 2020 08:50:04 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.14.236])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 08:50:04 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1] s390x: STFLE operates on doublewords
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200401163305.31550-1-david@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 2 Apr 2020 10:50:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200401163305.31550-1-david@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UsDvhk0g9B3sfToay3EvpnGmFphf1GFNl"
X-TM-AS-GCONF: 00
x-cbid: 20040208-0028-0000-0000-000003F08498
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040208-0029-0000-0000-000024B60DCA
Message-Id: <b2f9a3d7-7da7-4363-44ba-6446d879bf95@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004020073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UsDvhk0g9B3sfToay3EvpnGmFphf1GFNl
Content-Type: multipart/mixed; boundary="efkOKO1AOV0PVnpHyhfsFu80JbY59zBaA"

--efkOKO1AOV0PVnpHyhfsFu80JbY59zBaA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/1/20 6:33 PM, David Hildenbrand wrote:
> STFLE operates on doublewords, not bytes. Passing in "256" resulted in
> some ignored bits getting set. Not bad, but also not clean.
>=20
> Let's just convert our stfle handling code to operate on doublewords.
>=20
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/facility.h | 14 +++++++-------
>  lib/s390x/io.c           |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index e34dc2c..def2705 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -14,12 +14,12 @@
>  #include <asm/facility.h>
>  #include <asm/arch_def.h>
> =20
> -#define NR_STFL_BYTES 256
> -extern uint8_t stfl_bytes[];
> +#define NB_STFL_DOUBLEWORDS 32
> +extern uint64_t stfl_doublewords[];
> =20
>  static inline bool test_facility(int nr)
>  {
> -	return stfl_bytes[nr / 8] & (0x80U >> (nr % 8));
> +	return stfl_doublewords[nr / 64] & (0x8000000000000000UL >> (nr % 64)=
);
>  }
> =20
>  static inline void stfl(void)
> @@ -27,9 +27,9 @@ static inline void stfl(void)
>  	asm volatile("	stfl	0(0)\n" : : : "memory");
>  }
> =20
> -static inline void stfle(uint8_t *fac, unsigned int len)
> +static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
>  {
> -	register unsigned long r0 asm("0") =3D len - 1;
> +	register unsigned long r0 asm("0") =3D nb_doublewords - 1;
> =20
>  	asm volatile("	.insn	s,0xb2b00000,0(%1)\n"
>  		     : "+d" (r0) : "a" (fac) : "memory", "cc");
> @@ -40,9 +40,9 @@ static inline void setup_facilities(void)
>  	struct lowcore *lc =3D NULL;
> =20
>  	stfl();
> -	memcpy(stfl_bytes, &lc->stfl, sizeof(lc->stfl));
> +	memcpy(stfl_doublewords, &lc->stfl, sizeof(lc->stfl));
>  	if (test_facility(7))
> -		stfle(stfl_bytes, NR_STFL_BYTES);
> +		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
>  }
> =20
>  #endif
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index e091c37..c0f0bf7 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -19,7 +19,7 @@
>  #include "smp.h"
> =20
>  extern char ipl_args[];
> -uint8_t stfl_bytes[NR_STFL_BYTES] __attribute__((aligned(8)));
> +uint64_t stfl_doublewords[NB_STFL_DOUBLEWORDS];
> =20
>  static struct spinlock lock;
> =20
>=20



--efkOKO1AOV0PVnpHyhfsFu80JbY59zBaA--

--UsDvhk0g9B3sfToay3EvpnGmFphf1GFNl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6FpzwACgkQ41TmuOI4
ufjh1w/7Bx1dHrWze7oNPyHSiPep2m9CCm+JeRIQUH0hAK3lgMhHSsROlz/al4/t
VOzuzXRgWIZGk8klFOH5/z6vwJfeZvmeLCcXmjAuaH0m6g7/s92cTB5ls4e8saaA
OgidyNAjRD99+MzOijbtoj7JnZ0IakUy1OPjyXO7N+4UPcPQzeT+1QfAnTE6jTZB
+orNoKYlbVvTnW+KrRBujJXQiziQN4/Yqjdjw0yO69wgaJFQySpGnTKlTdvi9wnB
OWHjZZN6r5WUU5pHoB2AlN+UCsHUMFz7DUyFnrpliWZbOyE1Jp0IvPZVo+C0BUnW
iv8u3A6sFpShKNetX53roi0Tb4/JjJgoYvtf89YQDr2IXzZA1rYFMgWRPvjs3DB5
keafTsoCcNbnimR5nF96WkIqbhZfac3caxYv/m48DN8Uy3mL5S06VXc1ToIVBs+S
lW5gtiaZaug+Jh9bUKwCAzRldxKDT9+AGlgdxa0genj1sbWLtotzvZMXP8CNMKXN
UQyqZ2QWihSzfflOzAJmNLhYPfn76qlvpmP8b+EmHTIaVgGvI5GQHAOpWM1Y84IB
otdl6mrGJy9WbI/diQXwO+9pLStNafpwXyekgKxt6iFto2VJMjJ0Pbfrr8WRTPnd
rIVwsLBXHEREis+1LcUUIwnqKqSXKrJ0NF73GYgiYnshfaWu56c=
=7pKU
-----END PGP SIGNATURE-----

--UsDvhk0g9B3sfToay3EvpnGmFphf1GFNl--

