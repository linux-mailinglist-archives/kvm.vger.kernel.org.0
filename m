Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC0FB49E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfKMQGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:06:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbfKMQGc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 11:06:32 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADG3Af1099796
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 11:06:31 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w7qdbhtm7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 11:06:27 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 13 Nov 2019 16:05:47 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 16:05:45 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADG5iEq49414296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 16:05:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A7B4204B;
        Wed, 13 Nov 2019 16:05:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E1F042045;
        Wed, 13 Nov 2019 16:05:44 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 16:05:44 +0000 (GMT)
Subject: Re: [PATCH v1 2/4] s390x: Define the PSW bits
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 13 Nov 2019 17:05:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1573647799-30584-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r6LilpwTr9TbDNSPSWL1oDoptgo0xTTfp"
X-TM-AS-GCONF: 00
x-cbid: 19111316-0028-0000-0000-000003B6964D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111316-0029-0000-0000-000024799F38
Message-Id: <5796f620-7ee6-6333-e4f4-5e904284a331@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r6LilpwTr9TbDNSPSWL1oDoptgo0xTTfp
Content-Type: multipart/mixed; boundary="OsN9bhzKnYOUfx87CoQ2XbRQNiXBPd6wW"

--OsN9bhzKnYOUfx87CoQ2XbRQNiXBPd6wW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/13/19 1:23 PM, Pierre Morel wrote:
> Instead of assigning obfuscated masks to the PSW dedicated to the
> exceptions, let's define the masks explicitely, it will clarify the

s/explicitely/explicitly/
Try to break that up into sentences.

> usage.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_bits.h | 32 ++++++++++++++++++++++++++++++++
>  lib/s390x/asm/arch_def.h  |  6 ++----
>  s390x/cstart64.S          | 13 +++++++------
>  3 files changed, 41 insertions(+), 10 deletions(-)
>  create mode 100644 lib/s390x/asm/arch_bits.h
>=20
> diff --git a/lib/s390x/asm/arch_bits.h b/lib/s390x/asm/arch_bits.h
> new file mode 100644
> index 0000000..0521125
> --- /dev/null
> +++ b/lib/s390x/asm/arch_bits.h
> @@ -0,0 +1,32 @@
> +
> +/*
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU Library General Public License version 2=
=2E
> + */
> +#ifndef _ASM_S390X_ARCH_BITS_H_
> +#define _ASM_S390X_ARCH_BITS_H_
> +
> +#define PSW_MASK_PER		0x4000000000000000
> +#define PSW_MASK_DAT		0x0400000000000000
> +#define PSW_MASK_IO		0x0200000000000000
> +#define PSW_MASK_EXT		0x0100000000000000
> +#define PSW_MASK_BASE		0x0000000000000000
> +#define PSW_MASK_KEY		0x00F0000000000000
> +#define PSW_MASK_MCHECK		0x0004000000000000
> +#define PSW_MASK_WAIT		0x0002000000000000
> +#define PSW_MASK_PSTATE		0x0001000000000000
> +#define PSW_MASK_ASC		0x0000C00000000000
> +#define PSW_MASK_CC		0x0000300000000000
> +#define PSW_MASK_PM		0x00000F0000000000
> +#define PSW_MASK_RI		0x0000008000000000
> +#define PSW_MASK_EA		0x0000000100000000
> +#define PSW_MASK_BA		0x0000000080000000

a-f should be lower case in hex values.
Also, do we need all of them?
I'd like to keep it as small as possible.

> +
> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)

That's not a bit anymore, shouldn't that be in arch_def.h?
Also please add a comment, that this is 64 bit addressing.

> +
> +#endif
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 96cca2e..34c1188 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -10,15 +10,13 @@
>  #ifndef _ASM_S390X_ARCH_DEF_H_
>  #define _ASM_S390X_ARCH_DEF_H_
> =20
> +#include <asm/arch_bits.h>
> +
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
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index eaff481..7475f32 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -11,6 +11,7 @@
>   * under the terms of the GNU Library General Public License version 2=
=2E
>   */
>  #include <asm/asm-offsets.h>
> +#include <asm/arch_bits.h>
>  #include <asm/sigp.h>
> =20
>  .section .init
> @@ -196,17 +197,17 @@ svc_int:
> =20
>  	.align	8
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



--OsN9bhzKnYOUfx87CoQ2XbRQNiXBPd6wW--

--r6LilpwTr9TbDNSPSWL1oDoptgo0xTTfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3MKdgACgkQ41TmuOI4
ufiULQ/+KAOZr4oZPPU6rgejOXLz0O5SS8znVAOuoVIy60keg9MgjmuRP9RIQrw0
nZBG/IMp/RqRvk03+qx8XR2RS6weRo0dj5VkKz4Nefi2Aio3PnMKj/PAmkoedVJe
57G6kbQIZsgEza15DPntwkrhDPNNp4rciVQMLyUMAnCI6USewYewludRaWWclSqr
kci6eio0i01eWgHrvBuFzpJPTzVGVFYer7uaYJZJZ2upbngNMY7WwkS3IExD2xbP
KMQgSf48KyQwe0oa22RuY7lt9DUI2NoqDlUWE18iz8++i/NjvIhwkgSF85PkWH73
GUHVXdNTcmTZBO96h8r3d9mmvuz+VV8XTA4AZ6FaTRTtoRm45rHYI8Q21zWIq95L
oefcxsvqKIbgMNdxhKPCDDvcx8E1lpr1uEFC6UKQqb+++7Cm5NmS0rTVjgocOkyy
kuaP8nySBETZUhfdFg4Py3wMb4Dzzh06U0SswLA0MJwBsnziH2sJu4xgAdBbjrgf
AAQe90w2h4RMWh15WugVzqqWGiIlWUhLNWkIH6avICkJr9RT9FekGIgaPpo4OTcC
WH5vhXM5IfnfO1Cb+UjmkBGR5ZO70Ic9R4mI+GbiAslW4ktIVt4aKVqcO6SCboSM
Dz+XzscC3HW308crg9JYHLFjqi6phkG2hrG9txMQvtFHaK6uQvU=
=gPle
-----END PGP SIGNATURE-----

--r6LilpwTr9TbDNSPSWL1oDoptgo0xTTfp--

