Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70651E1F80
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 12:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgEZKRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 06:17:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726944AbgEZKRr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 06:17:47 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QADJha081399;
        Tue, 26 May 2020 06:17:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 318yw6jftn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 06:17:45 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QADWTh082437;
        Tue, 26 May 2020 06:17:45 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 318yw6jfsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 06:17:45 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QAFsPi028663;
        Tue, 26 May 2020 10:17:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 316uf8j9y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 10:17:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QAHf6450462748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 10:17:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C1F11C04A;
        Tue, 26 May 2020 10:17:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 934E311C054;
        Tue, 26 May 2020 10:17:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.159.105])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 10:17:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 02/12] s390x: Use PSW bits definitions
 in cstart
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <dfe3446e-1d57-fc2b-e467-29b3010cb936@linux.ibm.com>
Date:   Tue, 26 May 2020 12:17:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1589818051-20549-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RIaHyS4Eca7uVKq4vHkKaYAvAidvvfSvU"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-25_12:2020-05-25,2020-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 phishscore=0 cotscore=-2147483648
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005260076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RIaHyS4Eca7uVKq4vHkKaYAvAidvvfSvU
Content-Type: multipart/mixed; boundary="SIgvDd7ey92eY20ECzOGfxouwHorppIRG"

--SIgvDd7ey92eY20ECzOGfxouwHorppIRG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/18/20 6:07 PM, Pierre Morel wrote:
> This patch defines the PSW bits EA/BA used to initialize the PSW masks
> for exceptions.
>=20
> Since some PSW mask definitions exist already in arch_def.h we add thes=
e
> definitions there.
> We move all PSW definitions together and protect assembler code against=

> C syntax.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Nice

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 15 +++++++++++----
>  s390x/cstart64.S         | 15 ++++++++-------
>  2 files changed, 19 insertions(+), 11 deletions(-)
>=20
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15a4d49..820af93 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -10,15 +10,21 @@
>  #ifndef _ASM_S390X_ARCH_DEF_H_
>  #define _ASM_S390X_ARCH_DEF_H_
> =20
> +#define PSW_MASK_EXT			0x0100000000000000UL
> +#define PSW_MASK_DAT			0x0400000000000000UL
> +#define PSW_MASK_SHORT_PSW		0x0008000000000000UL
> +#define PSW_MASK_PSTATE			0x0001000000000000UL
> +#define PSW_MASK_BA			0x0000000080000000UL
> +#define PSW_MASK_EA			0x0000000100000000UL
> +
> +#define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
> +
> +#ifndef __ASSEMBLER__
>  struct psw {
>  	uint64_t	mask;
>  	uint64_t	addr;
>  };
> =20
> -#define PSW_MASK_EXT			0x0100000000000000UL
> -#define PSW_MASK_DAT			0x0400000000000000UL
> -#define PSW_MASK_PSTATE			0x0001000000000000UL
> -
>  #define CR0_EXTM_SCLP			0X0000000000000200UL
>  #define CR0_EXTM_EXTC			0X0000000000002000UL
>  #define CR0_EXTM_EMGC			0X0000000000004000UL
> @@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
>  	return current_prefix;
>  }
> =20
> +#endif /* __ASSEMBLER */
>  #endif
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 3c7d8a9..e890568 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -12,6 +12,7 @@
>   */
>  #include <asm/asm-offsets.h>
>  #include <asm/sigp.h>
> +#include <asm/arch_def.h>
> =20
>  .section .init
> =20
> @@ -232,19 +233,19 @@ svc_int:
> =20
>  	.align	8
>  reset_psw:
> -	.quad	0x0008000180000000
> +	.quad	PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PSW
>  initial_psw:
> -	.quad	0x0000000180000000, clear_bss_start
> +	.quad	PSW_EXCEPTION_MASK, clear_bss_start
>  pgm_int_psw:
> -	.quad	0x0000000180000000, pgm_int
> +	.quad	PSW_EXCEPTION_MASK, pgm_int
>  ext_int_psw:
> -	.quad	0x0000000180000000, ext_int
> +	.quad	PSW_EXCEPTION_MASK, ext_int
>  mcck_int_psw:
> -	.quad	0x0000000180000000, mcck_int
> +	.quad	PSW_EXCEPTION_MASK, mcck_int
>  io_int_psw:
> -	.quad	0x0000000180000000, io_int
> +	.quad	PSW_EXCEPTION_MASK, io_int
>  svc_int_psw:
> -	.quad	0x0000000180000000, svc_int
> +	.quad	PSW_EXCEPTION_MASK, svc_int
>  initial_cr0:
>  	/* enable AFP-register control, so FP regs (+BFP instr) can be used *=
/
>  	.quad	0x0000000000040000
>=20



--SIgvDd7ey92eY20ECzOGfxouwHorppIRG--

--RIaHyS4Eca7uVKq4vHkKaYAvAidvvfSvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7M7MQACgkQ41TmuOI4
ufjIMw//cDVNKIvpHNmqcD//EnTLTd73Ckg+Wp3799uBQUPd223s0cKqP6+A4klF
HD/Gxxj3Qxb8VflSBEqHvVxsuvTN3+sS1YDCW9iIqqzLIs1VhuGfI+/ON/qgyWr8
WUCH5KHd3uGe4RG34mwyjLK7NWFMgt8t36PK0mlm2l3FVy+v7JzfgvXt6Q/RJWXH
GDXvCiOTvDG0cTp+KWIJ2Y39zpqNTHZvUKbyIc+XrjWxsInt7GSFU65CoAs4Yyxc
5LUpIFSrkFkD1k/4GYnjkLchiFopIWWm0UOtNMdYwmkmJ6lHHTFDYBS3oXPFyNdM
5uJS/JFh3NTbfxaIp3DFcQ2GaRo4HqTCuyd4Gx7KFYEYV+87zQOJmsUWF1g/unTe
7p1Hqe4szz7uSQ8MK8vHTDxiHDIQmI/7gNWsNdL96zFSAPChsZZ+j+5O6fAJWrG6
r4t4N2OjPIJjRRZb7GjIoFndXJxV6dSRHb2bJbKWuk8Kc74nhpxBZpRx2sIhZwNu
tT0La2FT6F+icfu6qFoiYhZ4ODKjyryzEcYVp7UY1jAysOb+gLfrUaA/0Lx4plLl
9/dHDf1Qfb1IskLBMV9LeSUsyEqavgbXG66yJiLa8D+jZG9JoiBDLZif2rYx94vK
2n+S5ZcJh6xd/C4FfwPwg3UBRX603PzLC7eo+D49M01lcj+o5Cc=
=8a3C
-----END PGP SIGNATURE-----

--RIaHyS4Eca7uVKq4vHkKaYAvAidvvfSvU--

