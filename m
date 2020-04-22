Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793CA1B394D
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 09:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgDVHru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 03:47:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbgDVHru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 03:47:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M7WQws095317
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 03:47:49 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gg28pddn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 03:47:48 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 22 Apr 2020 08:47:00 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 08:46:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M7lgQ660358794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 07:47:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1338BA4055;
        Wed, 22 Apr 2020 07:47:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC326A4053;
        Wed, 22 Apr 2020 07:47:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.53.90])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 07:47:41 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 01/10] s390x: saving regs for interrupts
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 22 Apr 2020 09:47:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1582200043-21760-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GJaLqkBfGEmiLSCfLGIlw4CAjIGwPkjXQ"
X-TM-AS-GCONF: 00
x-cbid: 20042207-0016-0000-0000-000003091648
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042207-0017-0000-0000-0000336D30A5
Message-Id: <8c999975-bd94-67f1-98cc-3821f02a99c2@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_02:2020-04-21,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GJaLqkBfGEmiLSCfLGIlw4CAjIGwPkjXQ
Content-Type: multipart/mixed; boundary="BzCGfuw0onaQEWLZFlHtDroGACAI6hKRE"

--BzCGfuw0onaQEWLZFlHtDroGACAI6hKRE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/20/20 1:00 PM, Pierre Morel wrote:
> If we use multiple source of interrupts, for example, using SCLP
> console to print information while using I/O interrupts, we need
> to have a re-entrant register saving interruption handling.
>=20
> Instead of saving at a static memory address, let's save the base
> registers and the floating point registers on the stack.
>=20
> Note that we keep the static register saving to recover from the
> RESET tests.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/cstart64.S | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 9af6bb3..45da523 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -118,6 +118,25 @@ memsetxc:
>  	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
>  	.endm
> =20
> +/* Save registers on the stack, so we can have stacked interrupts. */
> +	.macro SAVE_IRQ_REGS
> +	slgfi   %r15, 15 * 8
> +	stmg    %r0, %r14, 0(%r15)

So this is just making some space on the stack and storing r0 - r14, righ=
t?

Same is done for the floating point registers below.

Could you add a comment above slgfi and stmg and explain what they do?
A few words are enough.

> +	slgfi   %r15, 16 * 8
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	std	\i, \i * 8(%r15)
> +	.endr
> +	.endm
> +
> +	.macro RESTORE_IRQ_REGS
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	ld	\i, \i * 8(%r15)
> +	.endr
> +	algfi   %r15, 16 * 8
> +	lmg     %r0, %r14, 0(%r15)
> +	algfi   %r15, 15 * 8
> +	.endm
> +
>  .section .text
>  /*
>   * load_reset calling convention:
> @@ -182,9 +201,9 @@ mcck_int:
>  	lpswe	GEN_LC_MCCK_OLD_PSW
> =20
>  io_int:
> -	SAVE_REGS
> +	SAVE_IRQ_REGS
>  	brasl	%r14, handle_io_int
> -	RESTORE_REGS
> +	RESTORE_IRQ_REGS
>  	lpswe	GEN_LC_IO_OLD_PSW
> =20
>  svc_int:
>=20



--BzCGfuw0onaQEWLZFlHtDroGACAI6hKRE--

--GJaLqkBfGEmiLSCfLGIlw4CAjIGwPkjXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6f9p0ACgkQ41TmuOI4
ufj8FBAAlSirQV2UDz6G66HVqznrehHKM+n4ghvRC+7yLgt30/FYQcyDZ+ZGR35c
4fORpxRyrtoLa6aD8+MUHrKNhDLT588eWrx+ugRWOXkJfyg+17mZd8XgQFRM55Bs
puSM0bGOtuQfN6bhwS3uKPWabMdNwECjenzX4z7N4+kT3M+LeCOyVw/Mriy7luDE
95MQ/4uflu+i25C5Wk4vYVwk5/X5c3/NZp5AbabBJqPomULK+JTs4S53lFu8worQ
Ahh8PpCmWbr42uNnqpX8OejKKzS8426QUG83o9CH/ABBpLs+8wsyF/Xt3HaZ9vY0
PDovAdNwMNeQPeb3Fqf974SZ3YF0Ll3X+hiYuJqay9XZ/lBwkbZCkh42maW7645E
qsXAstiaHGeb5nBaPDDCEN9oHQmM/1aVndG7bZTKybyaXwgM/XOOltritI8kkHxR
YeGTbViYHzGt3ixZcLTE4ruGvmJZpkcabAiNSRrCG/ni0WQDtLTeJeobp3bTo16T
CZZijYf4xIvbsFG2bboMbaMvyQ+44djlsVVn0LpKDAXQSVldag5cCeS93BZfmcAk
hZgKz7AuyWqnxtsiE1j2UqC6VS/zBTp+9y6GChTWOm30QvXmau3/XpBFQFQ2/6ev
JBEibirWdnDbdg6OKmwaRabLwOw3PC5H/UE/K4y/4NGUjzGlbdM=
=sui4
-----END PGP SIGNATURE-----

--GJaLqkBfGEmiLSCfLGIlw4CAjIGwPkjXQ--

