Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2AFB4B3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKMQMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:12:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726491AbfKMQMt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 11:12:49 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADG4otQ039959
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 11:12:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8kkkc8fn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 11:12:47 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 13 Nov 2019 16:12:45 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 16:12:43 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADGCgas42336746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 16:12:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14C5242049;
        Wed, 13 Nov 2019 16:12:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D052C42045;
        Wed, 13 Nov 2019 16:12:41 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 16:12:41 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 13 Nov 2019 17:12:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1573647799-30584-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T7l0bocAsNY7PneeOXfo59mpPexWjFdhU"
X-TM-AS-GCONF: 00
x-cbid: 19111316-4275-0000-0000-0000037D6ECA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111316-4276-0000-0000-00003890D15D
Message-Id: <7f40bf69-6e34-7613-1ab5-83e09464c0b0@linux.ibm.com>
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
--T7l0bocAsNY7PneeOXfo59mpPexWjFdhU
Content-Type: multipart/mixed; boundary="DFiyH82n6Typ8JwZzB8MBpyrm6vAPBrxR"

--DFiyH82n6Typ8JwZzB8MBpyrm6vAPBrxR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/13/19 1:23 PM, Pierre Morel wrote:
> If we use multiple source of interrupts, for exemple, using SCLP consol=
e
> to print information while using I/O interrupts or during exceptions, w=
e
> need to have a re-entrant register saving interruption handling.
>=20
> Instead of saving at a static place, let's save the base registers on
> the stack.
>=20
> Note that we keep the static register saving that we need for the RESET=

> tests.
>=20
> We also care to give the handlers a pointer to the save registers in
> case the handler needs it (fixup_pgm_int needs the old psw address).

So you're still ignoring the FPRs...
I disassembled a test and looked at all stds and it looks like printf
and related functions use them. Wouldn't we overwrite test FPRs if
printing in a handler?

>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 15 ++++++++++-----
>  lib/s390x/interrupt.c     | 16 ++++++++--------
>  s390x/cstart64.S          | 17 ++++++++++++++---
>  3 files changed, 32 insertions(+), 16 deletions(-)
>=20
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 4cfade9..a39a3a3 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -15,11 +15,16 @@
>  #define EXT_IRQ_EXTERNAL_CALL	0x1202
>  #define EXT_IRQ_SERVICE_SIG	0x2401
> =20
> -void handle_pgm_int(void);
> -void handle_ext_int(void);
> -void handle_mcck_int(void);
> -void handle_io_int(void);
> -void handle_svc_int(void);
> +typedef struct saved_registers {
> +        unsigned long regs[15];
> +} sregs_t;
> +
> +void handle_pgm_int(sregs_t *regs);
> +void handle_ext_int(sregs_t *regs);
> +void handle_mcck_int(sregs_t *regs);
> +void handle_io_int(sregs_t *regs);
> +void handle_svc_int(sregs_t *regs);
> +
>  void expect_pgm_int(void);
>  void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 5cade23..7aecfc5 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -50,7 +50,7 @@ void check_pgm_int_code(uint16_t code)
>  	       code =3D=3D lc->pgm_int_code, code, lc->pgm_int_code);
>  }
> =20
> -static void fixup_pgm_int(void)
> +static void fixup_pgm_int(sregs_t *regs)
>  {
>  	switch (lc->pgm_int_code) {
>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
> @@ -64,7 +64,7 @@ static void fixup_pgm_int(void)
>  		/* Handling for iep.c test case. */
>  		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
>  		    !(lc->trans_exc_id & 0x08UL))
> -			lc->pgm_old_psw.addr =3D lc->sw_int_grs[14];
> +			lc->pgm_old_psw.addr =3D regs->regs[14];
>  		break;
>  	case PGM_INT_CODE_SEGMENT_TRANSLATION:
>  	case PGM_INT_CODE_PAGE_TRANSLATION:
> @@ -103,7 +103,7 @@ static void fixup_pgm_int(void)
>  	/* suppressed/terminated/completed point already at the next address =
*/
>  }
> =20
> -void handle_pgm_int(void)
> +void handle_pgm_int(sregs_t *regs)
>  {
>  	if (!pgm_int_expected)
>  		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
> @@ -111,10 +111,10 @@ void handle_pgm_int(void)
>  			     lc->pgm_int_id);
> =20
>  	pgm_int_expected =3D false;
> -	fixup_pgm_int();
> +	fixup_pgm_int(regs);
>  }
> =20
> -void handle_ext_int(void)
> +void handle_ext_int(sregs_t *regs)
>  {
>  	if (!ext_int_expected &&
>  	    lc->ext_int_code !=3D EXT_IRQ_SERVICE_SIG) {
> @@ -134,19 +134,19 @@ void handle_ext_int(void)
>  		lc->ext_old_psw.mask &=3D ~PSW_MASK_EXT;
>  }
> =20
> -void handle_mcck_int(void)
> +void handle_mcck_int(sregs_t *regs)
>  {
>  	report_abort("Unexpected machine check interrupt: at %#lx",
>  		     lc->mcck_old_psw.addr);
>  }
> =20
> -void handle_io_int(void)
> +void handle_io_int(sregs_t *regs)
>  {
>  	report_abort("Unexpected io interrupt: at %#lx",
>  		     lc->io_old_psw.addr);
>  }
> =20
> -void handle_svc_int(void)
> +void handle_svc_int(sregs_t *regs)
>  {
>  	report_abort("Unexpected supervisor call interrupt: at %#lx",
>  		     lc->svc_old_psw.addr);
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 8e2b21e..eaff481 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -90,6 +90,17 @@ memsetxc:
>  	xc 0(1,%r1),0(%r1)
> =20
>  	.macro SAVE_REGS
> +	slgfi	%r15, 15 * 8
> +	stmg	%r0, %r14, 0(%r15)
> +	lgr	%r2, %r15
> +	.endm
> +
> +	.macro RESTORE_REGS
> +	lmg     %r0, %r14, 0(%r15)
> +	algfi   %r15, 15 * 8
> +	.endm
> +
> +	.macro SAVE_REGS_RESET
>  	/* save grs 0-15 */
>  	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
>  	/* save cr0 */
> @@ -105,7 +116,7 @@ memsetxc:
>  	stfpc	GEN_LC_SW_INT_FPC
>  	.endm
> =20
> -	.macro RESTORE_REGS
> +	.macro RESTORE_REGS_RESET
>  	/* restore fprs 0-15 + fpc */
>  	la	%r1, GEN_LC_SW_INT_FPRS
>  	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> @@ -125,7 +136,7 @@ memsetxc:
>   */
>  .globl diag308_load_reset
>  diag308_load_reset:
> -	SAVE_REGS
> +	SAVE_REGS_RESET
>  	/* Save the first PSW word to the IPL PSW */
>  	epsw	%r0, %r1
>  	st	%r0, 0
> @@ -142,7 +153,7 @@ diag308_load_reset:
>  	/* We lost cr0 due to the reset */
>  0:	larl	%r1, initial_cr0
>  	lctlg	%c0, %c0, 0(%r1)
> -	RESTORE_REGS
> +	RESTORE_REGS_RESET
>  	lhi	%r2, 1
>  	br	%r14
> =20
>=20



--DFiyH82n6Typ8JwZzB8MBpyrm6vAPBrxR--

--T7l0bocAsNY7PneeOXfo59mpPexWjFdhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3MK3kACgkQ41TmuOI4
ufgp+g//d1yXGzI5IK/w9iUQQXYs3a0VyV6Bq23FSIIrwUYJh/iuVJxvG66yR6+V
XmaDrXG/kfpU63hpl2+Efqsh8U/plTFCc+fbe4olf1Lq+MWFYvyQ7oTWCwxxFd0p
g3NCKuEZW/7An9PPDvaGt5UP/1g75f2k6ZQgAJvbmiZzEJe+yCgCBNuxNe7pxi5q
Fqe0lKiQNN5Ht97nzbHbDjD36OAuyL7XjZXHBDD6Jw6lENlWEDBjV9JtMaRdK64u
WQFs2DRfXqSNEuxrXoL5c/fOjlbI5A8Zw6TeJHPtXwGIwsppcwtJAiX+wdU8b/Xh
WJRgZ6CTl2qiQv+SWAa2RYQ2uQYezovv14yjCHpZJrjAYE5c0ScQSBv6gIWfWAFs
VVhVjz32r8kz6XUGBBW9zoIq9iFNHBwVynMKH83e69uQBjnVNWWlkBPtrOWgJh/e
HFuVhoDQUUMd6OqWb/bKKDgcAoP8XF08WnI79prDW2O1YLPEISq4qlYFvezvuX/L
PJ0FT/4QFbZr4uIM+DyLtUzWsiBUlUxEUsdRv6woX54o90n1+zDTS0ptwHmHqh+y
MDeHZ2xjmIemkoxxw1pnU0nsQgosArm3XWqArdn+LBc8G7XKKI/p4nlNZOI/gKd8
FoVCNsHpSqrc+ciCoIjjHgyLHPHjQ4lRB1j9QsSRCmOWxbKogz8=
=4b+C
-----END PGP SIGNATURE-----

--T7l0bocAsNY7PneeOXfo59mpPexWjFdhU--

