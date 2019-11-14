Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7AEFC266
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 10:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfKNJP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 04:15:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbfKNJPZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 04:15:25 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAE9Cd8I156273
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:15:21 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w91m7ckap-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:15:20 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 09:15:17 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 09:15:15 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAE9FElp47055002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 09:15:14 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2C98A4054;
        Thu, 14 Nov 2019 09:15:14 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678AFA405F;
        Thu, 14 Nov 2019 09:15:14 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 09:15:14 +0000 (GMT)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 10:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xX85mMJVpGy3Km4BO3ThkGru4WIBot7Kt"
X-TM-AS-GCONF: 00
x-cbid: 19111409-0028-0000-0000-000003B6C86C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111409-0029-0000-0000-00002479D469
Message-Id: <db451544-fcb1-9d81-7042-ef91c8324204@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xX85mMJVpGy3Km4BO3ThkGru4WIBot7Kt
Content-Type: multipart/mixed; boundary="TQV5y4ZR4OmHk7MkwsJcHZpsChWEp0e5x"

--TQV5y4ZR4OmHk7MkwsJcHZpsChWEp0e5x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/13/19 1:23 PM, Pierre Morel wrote:
> This simple test test the I/O reading by the SUB Channel by:
> - initializing the Channel SubSystem with predefined CSSID:
>   0xfe000000 CSSID for a Virtual CCW
>   0x00090000 SSID for CCW-PONG
> - initializing the ORB pointing to a single READ CCW
> - starts the STSH command with the ORB
> - Expect an interrupt
> - writes the read data to output
>=20
> The test implements lots of traces when DEBUG is on and
> tests if memory above the stack is corrupted.

What happens if we do not habe the pong device?

>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 244 +++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  lib/s390x/css_dump.c | 141 +++++++++++++++++++++++++++++

Hmm, what about splitting the patch into css.h/css_dump.c and the actual
test in s390x/css.c?

>  s390x/Makefile       |   2 +
>  s390x/css.c          | 222 +++++++++++++++++++++++++++++++++++++++++++=
+++
>  s390x/unittests.cfg  |   4 +
>  5 files changed, 613 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
>  create mode 100644 s390x/css.c
>=20
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..a7c42fd
> --- /dev/null
> +++ b/lib/s390x/css.h
> @@ -0,0 +1,244 @@
> +/*
> + * CSS definitions
> + *
> + * Copyright IBM, Corp. 2019
> + * Author: Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or =
(at
> + * your option) any later version. See the COPYING file in the top-lev=
el
> + * directory.
> + */
> +
> +#ifndef CSS_H
> +#define CSS_H
> +
> +#define CCW_F_CD	0x80
> +#define CCW_F_CC	0x40
> +#define CCW_F_SLI	0x20
> +#define CCW_F_SKP	0x10
> +#define CCW_F_PCI	0x08
> +#define CCW_F_IDA	0x04
> +#define CCW_F_S		0x02
> +#define CCW_F_MIDA	0x01
> +
> +#define CCW_C_NOP	0x03
> +#define CCW_C_TIC	0x08
> +
> +struct ccw {
> +	unsigned char code;
> +	unsigned char flags;
> +	unsigned short count;
> +	unsigned int data;
> +} __attribute__ ((aligned(4)));
> +
> +#define ORB_M_KEY	0xf0000000
> +#define ORB_F_SUSPEND	0x08000000
> +#define ORB_F_STREAMING	0x04000000
> +#define ORB_F_MODIFCTRL	0x02000000
> +#define ORB_F_SYNC	0x01000000
> +#define ORB_F_FORMAT	0x00800000
> +#define ORB_F_PREFETCH	0x00400000
> +#define ORB_F_INIT_IRQ	0x00200000
> +#define ORB_F_ADDRLIMIT	0x00100000
> +#define ORB_F_SUSP_IRQ	0x00080000
> +#define ORB_F_TRANSPORT	0x00040000
> +#define ORB_F_IDAW2	0x00020000
> +#define ORB_F_IDAW_2K	0x00010000
> +#define ORB_M_LPM	0x0000ff00
> +#define ORB_F_LPM_DFLT	0x00008000
> +#define ORB_F_ILSM	0x00000080
> +#define ORB_F_CCW_IND	0x00000040
> +#define ORB_F_ORB_EXT	0x00000001

\n

> +struct orb {
> +	unsigned int	intparm;
> +	unsigned int	ctrl;
> +	unsigned int	cpa;
> +	unsigned int	prio;
> +	unsigned int	reserved[4];
> +} __attribute__ ((aligned(4)));;

Double ;;

> +
> +struct scsw {
> +	uint32_t ctrl;
> +	uint32_t addr;
> +	uint8_t  devs;
> +	uint8_t  schs;
> +	uint16_t count;
> +};
> +
> +struct pmcw {
> +	uint32_t intparm;
> +	uint16_t flags;
> +	uint16_t devnum;
> +	uint8_t  lpm;
> +	uint8_t  pnom;
> +	uint8_t  lpum;
> +	uint8_t  pim;
> +	uint16_t mbi;
> +	uint8_t  pom;
> +	uint8_t  pam;
> +	uint8_t  chpid[8];
> +	uint32_t flag2;
> +};
> +struct schib {
> +	struct pmcw pmcw;
> +	struct scsw scsw;
> +	uint32_t  md0;
> +	uint32_t  md1;
> +	uint32_t  md2;
> +} __attribute__ ((aligned(4)));
> +
> +struct irb {
> +	struct scsw scsw;
> +	uint32_t esw[5];
> +	uint32_t ecw[8];
> +	uint32_t emw[8];
> +} __attribute__ ((aligned(4)));;

Double ;;

> +
> +/* CSS low level access functions */
> +
> +static inline int ssch(unsigned long schid, struct orb *addr)
> +{
> +	register long long reg1 asm("1") =3D schid;
> +	int ccode =3D -1;

s/ccode/cc/

> +
> +	asm volatile(
> +		"	   ssch	0(%2)\n"
> +		"0:	 ipm	 %0\n"
> +		"	   srl	 %0,28\n"
> +		"1:\n"
> +		: "+d" (ccode)
> +		: "d" (reg1), "a" (addr), "m" (*addr)
> +		: "cc", "memory");
> +	return ccode;
> +}
> +
> +static inline int stsch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	   stsch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=3Dd" (ccode), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int msch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	   msch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=3Dd" (ccode), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int tsch(unsigned long schid, struct irb *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	   tsch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=3Dd" (ccode), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int hsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	hsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (ccode)
> +		: "d" (reg1)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int xsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	xsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (ccode)
> +		: "d" (reg1)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int csch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int ccode;> +
> +	asm volatile(
> +		"	csch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (ccode)
> +		: "d" (reg1)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int rsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	rsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (ccode)
> +		: "d" (reg1)
> +		: "cc");
> +	return ccode;
> +}
> +
> +static inline int rchp(unsigned long chpid)
> +{
> +	register unsigned long reg1 asm("1") =3D chpid;
> +	int ccode;
> +
> +	asm volatile(
> +		"	rchp\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (ccode)
> +		: "d" (reg1)
> +		: "cc");
> +	return ccode;
> +}
> +
> +void dump_scsw(struct scsw *);
> +void dump_irb(struct irb *irbp);
> +void dump_pmcw_flags(uint16_t f);
> +void dump_pmcw(struct pmcw *p);
> +void dump_schib(struct schib *sch);
> +struct ccw *dump_ccw(struct ccw *cp);
> +void dump_orb(struct orb *op);
> +
> +extern unsigned long stacktop;
> +#endif
> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..4f6b628
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,141 @@
> +/*
> + * Channel Sub-System structures dumping
> + *
> + * Copyright (c) 2019 IBM Corp.
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU Library General Public License version 2=
=2E
> + *
> + * Description:
> + * Provides the dumping functions for various structures used by subch=
annels:
> + * - ORB  : Operation request block, describe the I/O operation and po=
int to
> + *          a CCW chain
> + * - CCW  : Channel Command Word, describe the data and flow control
> + * - IRB  : Interuption response Block, describe the result of an oper=
ation
> + *          hold a SCSW and several channel type dependent fields.
> + * - SCHIB: SubChannel Information Block composed of:
> + *   - SCSW: SubChannel Status Word, status of the channel as a result=
 of an
> + *           operation when in IRB.
> + *   - PMCW: Path Management Control Word
> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfe=
rs.
> + */
> +
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <string.h>
> +
> +#include <css.h>
> +
> +static const char *scsw_str =3D "kkkkslccfpixuzen";
> +static const char *scsw_str2 =3D "1SHCrshcsdsAIPSs";
> +
> +void dump_scsw(struct scsw *s)
> +{
> +	int i;
> +	uint32_t scsw =3D s->ctrl;
> +	char line[64] =3D {};
> +
> +	for (i =3D 0; i < 16; i++) {
> +		if ((scsw << i) & 0x80000000)
> +			line[i] =3D scsw_str[i];
> +		else
> +			line[i] =3D '_';
> +	}
> +	line[i] =3D ' ';
> +	for (; i < 32; i++) {
> +		if ((scsw << i) & 0x80000000)
> +			line[i + 1] =3D scsw_str2[i - 16];
> +		else
> +			line[i + 1] =3D '_';
> +	}
> +	printf("scsw->flags: %s\n", line);
> +	printf("scsw->addr : %08x\n", s->addr);
> +	printf("scsw->devs : %02x\n", s->devs);
> +	printf("scsw->schs : %02x\n", s->schs);
> +	printf("scsw->count: %04x\n", s->count);
> +

Stray \n

> +}
> +
> +void dump_irb(struct irb *irbp)
> +{
> +	int i;
> +	uint32_t *p =3D (uint32_t *)irbp;
> +
> +	dump_scsw(&irbp->scsw);
> +	for (i =3D 0; i < sizeof(*irbp)/sizeof(*p); i++, p++)
> +		printf("irb[%02x] : %08x\n", i, *p);
> +}
> +
> +static const char *pmcw_str =3D "11iii111ellmmdtv";
> +void dump_pmcw_flags(uint16_t f)
> +{
> +	int i;
> +	char line[32] =3D {};
> +
> +	for (i =3D 0; i < 16; i++) {
> +		if ((f << i) & 0x8000)
> +			line[i] =3D pmcw_str[i];
> +		else
> +			line[i] =3D '_';
> +	}
> +	printf("pmcw->pmcw flgs: %s\n", line);
> +}
> +
> +void dump_pmcw(struct pmcw *p)
> +{
> +	int i;
> +
> +	printf("pmcw->intparm  : %08x\n", p->intparm);
> +	printf("pmcw->flags    : %04x\n", p->flags);
> +	dump_pmcw_flags(p->flags);
> +	printf("pmcw->devnum   : %04x\n", p->devnum);
> +	printf("pmcw->lpm      : %02x\n", p->lpm);
> +	printf("pmcw->pnom     : %02x\n", p->pnom);
> +	printf("pmcw->lpum     : %02x\n", p->lpum);
> +	printf("pmcw->pim      : %02x\n", p->pim);
> +	printf("pmcw->mbi      : %04x\n", p->mbi);
> +	printf("pmcw->pom      : %02x\n", p->pom);
> +	printf("pmcw->pam      : %02x\n", p->pam);
> +	printf("pmcw->mbi      : %04x\n", p->mbi);
> +	for (i =3D 0; i < 8; i++)
> +		printf("pmcw->chpid[%d]: %02x\n", i, p->chpid[i]);
> +	printf("pmcw->flags2  : %08x\n", p->flag2);
> +}
> +
> +void dump_schib(struct schib *sch)
> +{
> +	struct pmcw *p =3D &sch->pmcw;
> +	struct scsw *s =3D &sch->scsw;
> +
> +	printf("--SCHIB--\n");
> +	dump_pmcw(p);
> +	dump_scsw(s);
> +}
> +
> +struct ccw *dump_ccw(struct ccw *cp)
> +{
> +	printf("CCW: code: %02x flags: %02x count: %04x data: %08x\n", cp->co=
de,
> +	    cp->flags, cp->count, cp->data);
> +
> +	if (cp->code =3D=3D CCW_C_TIC)
> +		return (struct ccw *)(long)cp->data;
> +
> +	return (cp->flags & CCW_F_CC) ? cp + 1 : NULL;
> +}
> +
> +void dump_orb(struct orb *op)
> +{
> +	struct ccw *cp;
> +
> +	printf("ORB: intparm : %08x\n", op->intparm);
> +	printf("ORB: ctrl    : %08x\n", op->ctrl);
> +	printf("ORB: prio    : %08x\n", op->prio);
> +	cp =3D (struct ccw *)(long) (op->cpa);
> +	while (cp)
> +		cp =3D dump_ccw(cp);
> +}
> +
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3744372..9ebbb84 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
>  tests +=3D $(TEST_DIR)/stsi.elf
>  tests +=3D $(TEST_DIR)/skrf.elf
>  tests +=3D $(TEST_DIR)/smp.elf
> +tests +=3D $(TEST_DIR)/css.elf
>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> =20
>  all: directories test_cases test_cases_binary
> @@ -50,6 +51,7 @@ cflatobjs +=3D lib/s390x/sclp-console.o
>  cflatobjs +=3D lib/s390x/interrupt.o
>  cflatobjs +=3D lib/s390x/mmu.o
>  cflatobjs +=3D lib/s390x/smp.o
> +cflatobjs +=3D lib/s390x/css_dump.o
> =20
>  OBJDIRS +=3D lib/s390x
> =20
> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..6cdaf61
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,222 @@
> +/*
> + * Channel Sub-System tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_phys.h>
> +#include <asm/page.h>
> +#include <string.h>
> +#include <asm/interrupt.h>
> +#include <asm/arch_def.h>
> +
> +#include <css.h>
> +
> +#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
> +
> +#define DEBUG 1
> +#ifdef DEBUG
> +#define DBG(format, arg...) \
> +	printf("KT_%s:%d " format "\n", __func__, __LINE__, ##arg)
> +#else
> +#define DBG(format, arg...) do {} while (0)
> +#endif
> +
> +#define CSSID_PONG	(0xfe000000 | 0x00090000)
> +
> +struct lowcore *lowcore =3D (void *)0x0;
> +
> +#define NB_CCW  100
> +static struct ccw ccw[NB_CCW];
> +
> +#define NB_ORB  100
> +static struct orb orb[NB_ORB];
> +
> +static struct irb irb;
> +static struct schib schib;
> +
> +static char buffer[4096];
> +
> +static void delay(int d)
> +{
> +	int i, j;
> +
> +	while (d--)
> +		for (i =3D 1000000; i; i--)
> +			for (j =3D 1000000; j; j--)
> +				;
> +}

You could set a timer.

> +
> +static void set_io_irq_subclass_mask(uint64_t const new_mask)
> +{
> +	asm volatile (
> +		"lctlg %%c6, %%c6, %[source]\n"
> +		: /* No outputs */
> +		: [source] "R" (new_mask));

arch_def.h has lctlg() and ctl_set/clear_bit

> +}
> +
> +static void set_system_mask(uint8_t new_mask)
> +{
> +	asm volatile (
> +		"ssm %[source]\n"
> +		: /* No outputs */
> +		: [source] "R" (new_mask));
> +}
> +
> +static void enable_io_irq(void)
> +{
> +	set_io_irq_subclass_mask(0x00000000ff000000);
> +	set_system_mask(PSW_PRG_MASK >> 56);

load_psw_mask(extract_psw_mask() | PSW_PRG_MASK); no need for another
inline asm function :)

Or add a psw_set/clear_bit function and fixup enter_pstate()

> +}
> +
> +void handle_io_int(sregs_t *regs)
> +{
> +	int ret =3D 0;
> +
> +	DBG("IO IRQ: subsys_id_word=3D%08x", lowcore->subsys_id_word);
> +	DBG("......: io_int_parm   =3D%08x", lowcore->io_int_param);
> +	DBG("......: io_int_word   =3D%08x", lowcore->io_int_word);
> +	ret =3D tsch(lowcore->subsys_id_word, &irb);
> +	dump_irb(&irb);
> +	if (ret)
> +		DBG("......: tsch retval %d", ret);
> +	DBG("IO IRQ: END");
> +}
> +
> +static void set_schib(struct schib *sch)
> +{
> +	struct pmcw *p =3D &sch->pmcw;
> +
> +	p->intparm =3D 0xdeadbeef;
> +	p->devnum =3D 0xc0ca;
> +	p->lpm =3D 0x80;
> +	p->flags =3D 0x3081;
> +	p->chpid[7] =3D 0x22;
> +	p->pim =3D 0x0f;
> +	p->pam =3D 0x0f;
> +	p->pom =3D 0x0f;
> +	p->lpm =3D 0x0f;
> +	p->lpum =3D 0xaa;
> +	p->pnom =3D 0xf0;
> +	p->mbi =3D 0xaa;
> +	p->mbi =3D 0xaaaa;
> +}
> +
> +static void css_enable(void)
> +{
> +	int ret;
> +
> +	ret =3D stsch(CSSID_PONG, &schib);
> +	if (ret)
> +		DBG("stsch: %x\n", ret);
> +	dump_schib(&schib);
> +	set_schib(&schib);
> +	dump_schib(&schib);
> +	ret =3D msch(CSSID_PONG, &schib);
> +	if (ret)
> +		DBG("msch : %x\n", ret);
> +}
> +
> +/* These two definitions are part of the QEMU PONG interface */
> +#define PONG_WRITE 0x21
> +#define PONG_READ  0x22
> +
> +static int css_run(int fake)
> +{
> +	struct orb *p =3D orb;
> +	int cc;
> +
> +	if (fake)
> +		return 0;
> +	css_enable();
> +
> +	enable_io_irq();
> +
> +	ccw[0].code =3D PONG_READ;
> +	ccw[0].flags =3D CCW_F_PCI;
> +	ccw[0].count =3D 80;
> +	ccw[0].data =3D (unsigned int)(unsigned long) &buffer;
> +
> +	p->intparm =3D 0xcafec0ca;
> +	p->ctrl =3D ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
> +	p->cpa =3D (unsigned int) (unsigned long)&ccw[0];
> +
> +	printf("ORB AT %p\n", orb);
> +	dump_orb(p);
> +	cc =3D ssch(CSSID_PONG, p);
> +	if (cc) {
> +		DBG("cc: %x\n", cc);
> +		return cc;
> +	}
> +
> +	delay(1);
> +
> +	stsch(CSSID_PONG, &schib);
> +	dump_schib(&schib);

Is all that dumping necessary or just a dev remainder?

> +	DBG("got: %s\n", buffer);
> +
> +	return 0;
> +}
> +
> +#define MAX_ERRORS 10
> +static int checkmem(phys_addr_t start, phys_addr_t end)
> +{
> +	phys_addr_t curr;
> +	int err =3D 0;
> +
> +	for (curr =3D start; curr !=3D end; curr +=3D PAGE_SIZE)
> +		if (memcmp((void *)start, (void *)curr, PAGE_SIZE)) {
> +			report("memcmp failed %lx", true, curr);

How many errors do you normally run into (hopefully 0)?

> +			if (err++ > MAX_ERRORS)
> +				break;
> +		}
> +	return err;
> +}
> +
> +extern unsigned long bss_end;
> +
> +int main(int argc, char *argv[])
> +{
> +	phys_addr_t base, top;
> +	int check_mem =3D 0;
> +	int err =3D 0;
> +
> +	if (argc =3D=3D 2 && !strcmp(argv[1], "-i"))
> +		check_mem =3D 1;
> +
> +	report_prefix_push("css");
> +	phys_alloc_get_unused(&base, &top);
> +
> +	top =3D 0x08000000; /* 128MB Need to be updated */
> +	base =3D (phys_addr_t)&stacktop;
> +
> +	if (check_mem)
> +		memset((void *)base, 0x00, top - base);
> +
> +	if (check_mem)
> +		err =3D checkmem(base, top);
> +	if (err)
> +		goto out;
> +
> +	err =3D css_run(0);
> +	if (err)
> +		goto out;
> +
> +	if (check_mem)
> +		err =3D checkmem(base, top);
> +
> +out:
> +	if (err)
> +		report("Tested", 0);
> +	else
> +		report("Tested", 1);

Normally we report the sucsess or failure of single actions and a
summary will tell us if the whole test ran into errors.

> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f1b07cd..1755d9e 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -75,3 +75,7 @@ file =3D stsi.elf
>  [smp]
>  file =3D smp.elf
>  extra_params =3D-smp 2
> +
> +[css]
> +file =3D css.elf
> +extra_params =3D-device ccw-pong
>=20



--TQV5y4ZR4OmHk7MkwsJcHZpsChWEp0e5x--

--xX85mMJVpGy3Km4BO3ThkGru4WIBot7Kt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NGyIACgkQ41TmuOI4
ufhUVxAAwpxtDLyRoxeZewZl7IZgbwoJtALbtZNJFx5q3ft8Ul5VgWIq015zoUMW
gdr17SxMO8JEs/l/cYqnvGKu5A/t4ce3PPikX44vBjAsoktYqOmcptv5tT7ZN8cL
0gNh3i0EgQk1DO9o/vsnnu094N4grQwB+oLVV/8n+TIorq1e7/mXw07TuRCEN2jY
OesAe0PwE3sB0SvNdd5MR1JJBdKc9tyZ0zbLbEUZtXx0qeRF6XJEpNTrVu9XcSLA
HCW8sRrK4u34qjuVXkGGKaVSrGf2VrNovjrErKkpDHCHK0+zHWGoRviTdTHMJ8n0
sV5uyRzIXsAM8RmMdjTjU7nU0QxpsFn1J/kx8X227NupvSzsgxOUSthJz4zZK9NC
lcSKsagcMX7nqx5renwseFRYWiynFA+9yI8esJ5KcbfYRVguckEChi5pdkFAA88b
cmO4U4ruC7oBWLNqhFhgIZu/Z2c0TayZ+ShgY4zgyi91Ucme3goQ7Ceqw49BM8va
rq19RgIzIvt30MaaY9eOE8mv3ilQAfRSDUH0mNeBGTrw7DgaZ4kWDV2AglWsA4ZD
pT+EHiVeohrjb706MKUToB7ZDSsVSyTY+huB6pQlIt+mkrQYt+vdyHEH/boSpLUm
l+jGeFo0z8KZBusDJ55BLdILP0K/aCqYJRxwi+DiLKzD6piUAlo=
=dOph
-----END PGP SIGNATURE-----

--xX85mMJVpGy3Km4BO3ThkGru4WIBot7Kt--

