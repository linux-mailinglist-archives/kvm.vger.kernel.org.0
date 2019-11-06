Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E760BF13BE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 11:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfKFKTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 05:19:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbfKFKTm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 05:19:42 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA69uUgB116683
        for <kvm@vger.kernel.org>; Wed, 6 Nov 2019 05:19:41 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3ue524w0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 05:19:41 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 6 Nov 2019 10:19:39 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 10:19:36 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA6AJZWA24510940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 10:19:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ED8A11C04A;
        Wed,  6 Nov 2019 10:19:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBA9811C05B;
        Wed,  6 Nov 2019 10:19:34 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Nov 2019 10:19:34 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Remove DAT and add short
 indication psw bits on diag308 reset
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com
References: <20191105162828.2490-1-frankja@linux.ibm.com>
 <20191105162828.2490-3-frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 6 Nov 2019 11:19:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191105162828.2490-3-frankja@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j4ML4Gy1U04lLyaz2OBIvyEIFgfoEoO27"
X-TM-AS-GCONF: 00
x-cbid: 19110610-4275-0000-0000-0000037B423A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110610-4276-0000-0000-0000388E8F86
Message-Id: <c53bab1c-3158-f9c2-bd36-c3eca857d26f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911060102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j4ML4Gy1U04lLyaz2OBIvyEIFgfoEoO27
Content-Type: multipart/mixed; boundary="SRfEZYxOf5YPbrjPL2QwqalbagPRCb2rx"

--SRfEZYxOf5YPbrjPL2QwqalbagPRCb2rx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/19 5:28 PM, Janosch Frank wrote:
> On a diag308 subcode 0 CRs will be reset, so we need to mask of PSW
> DAT indication until we restore our CRs.
>=20
> Also we need to set the short psw indication to be compliant with the
> architecture.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c  |  1 +
>  lib/s390x/asm/arch_def.h |  3 ++-
>  s390x/cstart64.S         | 20 ++++++++++++++------
>  3 files changed, 17 insertions(+), 7 deletions(-)
>=20
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index 4b213f8..61d2658 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -58,6 +58,7 @@ int main(void)
>  	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>  	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>  	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
> +	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>  	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>  	OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>  	OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 07d4e5e..7d25e4f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -79,7 +79,8 @@ struct lowcore {
>  	uint32_t	sw_int_fpc;			/* 0x0300 */
>  	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
>  	uint64_t	sw_int_crs[16];			/* 0x0308 */
> -	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
> +	struct psw	sw_int_psw;			/* 0x0388 */
> +	uint8_t		pad_0x0310[0x11b0 - 0x0390];	/* 0x0390 */

That's obviously not correct, the psw is two DWORDS long, not one...

>  	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
>  	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
>  	uint64_t	fprs_sa[16];			/* 0x1200 */
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 0455591..2e0dcf5 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -129,8 +129,15 @@ memsetxc:
>  .globl diag308_load_reset
>  diag308_load_reset:
>  	SAVE_REGS
> -	/* Save the first PSW word to the IPL PSW */
> +	/* Backup current PSW */
>  	epsw	%r0, %r1
> +	st	%r0, GEN_LC_SW_INT_PSW
> +	st	%r1, GEN_LC_SW_INT_PSW + 4
> +	/* Disable DAT as the CRs will be reset too */
> +	nilh	%r0, 0xfbff
> +	/* Add psw bit 12 to indicate short psw */
> +	oilh	%r0, 0x0008
> +	/* Save the first PSW word to the IPL PSW */
>  	st	%r0, 0
>  	/* Store the address and the bit for 31 bit addressing */
>  	larl    %r0, 0f
> @@ -142,12 +149,13 @@ diag308_load_reset:
>  	xgr	%r2, %r2
>  	br	%r14
>  	/* Success path */
> -	/* We lost cr0 due to the reset */
> -0:	larl	%r1, initial_cr0
> -	lctlg	%c0, %c0, 0(%r1)
> -	RESTORE_REGS
> +	/* Switch to z/Architecture mode and 64-bit */
> +0:	RESTORE_REGS
>  	lhi	%r2, 1
> -	br	%r14
> +	larl	%r0, 1f
> +	stg	%r0, GEN_LC_SW_INT_PSW + 8
> +	lpswe	GEN_LC_SW_INT_PSW
> +1:	br	%r14
> =20
>  .globl smp_cpu_setup_state
>  smp_cpu_setup_state:
>=20



--SRfEZYxOf5YPbrjPL2QwqalbagPRCb2rx--

--j4ML4Gy1U04lLyaz2OBIvyEIFgfoEoO27
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3CnjYACgkQ41TmuOI4
ufiMTBAAqT4SiXuVUybd2PMwg2w+wRrEMgvWLJBvIPfATV2SlrN9GbA925GHcgvd
gl+jGv613xGsH4egnx9AzaY2MSbebQOeNf8zIObmYagvxlba9qtrjKeh+PZw2SeT
+OAErjAp1IRtN/SQ3dT8QHyVnamhxeVGVQ3UWOE/lI3QyL3TkhmL1Gz6qDy+/BFg
kdw1yu9m19mQjEXSADGi17wB20ibLcYUHTobbjy05cUTcksMmrh8VNK9Wqhe2Z3q
MjkLc1yFLFE8rajICDO812eK39WmiDcY3R5zherPp7gHAKSW2mw6qQ9XNKXKY/t/
iMMyDfYOnNMiGt6M13wDlr9RXdhi7OpTaDwT+SXwddLaY6BKzuQ8N9tLMz8Np6Xt
1P8U4Mqfme3IhsvwiWByQZNRwHdK/CbmMu5g7LlYi4eLUvihWYkQQJIeBrrHmhQF
818vFt1D9uriG2a5JmbQZuFmhLCYPH8Nz1F/NFJjokE6Paxt6DjJyw9+2ttzifvT
2wAWO0cZDRQHhvG8fjYSapMC+aZoaULfI3dclLdCSgIYDVGkRiFHAh36YI+BHbbn
Hh8ZJHyCiYnvJbprOAXL+FpoGvbmT5ukRyNmRvKG4jMbpMm4LRCjUJQ4M4+P1gfI
HQ8M9Pu+nWyPt++vHwv9ETvPFKXwfhTMmYSzh1ssAVCgQVx2D3U=
=9n94
-----END PGP SIGNATURE-----

--j4ML4Gy1U04lLyaz2OBIvyEIFgfoEoO27--

