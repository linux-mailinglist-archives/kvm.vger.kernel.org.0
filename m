Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C24203386
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgFVJfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:35:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726391AbgFVJfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 05:35:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05M9YAl5028434;
        Mon, 22 Jun 2020 05:35:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31swq38xhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 05:35:34 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05M9YpSp031314;
        Mon, 22 Jun 2020 05:35:34 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31swq38xgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 05:35:34 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05M9KAns009210;
        Mon, 22 Jun 2020 09:35:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31sa3833t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 09:35:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05M9ZUDw16318772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 09:35:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAE174C064;
        Mon, 22 Jun 2020 09:35:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F92F4C059;
        Mon, 22 Jun 2020 09:35:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.171])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 09:35:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 09/12] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <55412942-21fb-817b-8645-4711a985f068@linux.ibm.com>
Date:   Mon, 22 Jun 2020 11:35:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lxSYNQElsvrCqU8I4g5tCJtptKzt3pUBO"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_03:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lxSYNQElsvrCqU8I4g5tCJtptKzt3pUBO
Content-Type: multipart/mixed; boundary="ETJjmlxEB98Y5rkSJ1ENhzLVYDDRs99wo"

--ETJjmlxEB98Y5rkSJ1ENhzLVYDDRs99wo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/15/20 11:31 AM, Pierre Morel wrote:
> Provide some definitions and library routines that can be used by
> tests targeting the channel subsystem.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Acked-by: Janosch Frank <frankja@de.ibm.com>

> ---
>  lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++=

>  lib/s390x/css_dump.c | 153 ++++++++++++++++++++++++++
>  s390x/Makefile       |   1 +
>  3 files changed, 410 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
>=20
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..0ddceb1
> --- /dev/null
> +++ b/lib/s390x/css.h
> @@ -0,0 +1,256 @@
> +/*
> + * CSS definitions
> + *
> + * Copyright IBM, Corp. 2020
> + * Author: Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#ifndef CSS_H
> +#define CSS_H
> +
> +/* subchannel ID bit 16 must always be one */
> +#define SCHID_ONE	0x00010000
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
> +struct ccw1 {
> +	uint8_t code;
> +	uint8_t flags;
> +	uint16_t count;
> +	uint32_t data_address;
> +} __attribute__ ((aligned(8)));
> +
> +#define ORB_CTRL_KEY	0xf0000000
> +#define ORB_CTRL_SPND	0x08000000
> +#define ORB_CTRL_STR	0x04000000
> +#define ORB_CTRL_MOD	0x02000000
> +#define ORB_CTRL_SYNC	0x01000000
> +#define ORB_CTRL_FMT	0x00800000
> +#define ORB_CTRL_PFCH	0x00400000
> +#define ORB_CTRL_ISIC	0x00200000
> +#define ORB_CTRL_ALCC	0x00100000
> +#define ORB_CTRL_SSIC	0x00080000
> +#define ORB_CTRL_CPTC	0x00040000
> +#define ORB_CTRL_C64	0x00020000
> +#define ORB_CTRL_I2K	0x00010000
> +#define ORB_CTRL_LPM	0x0000ff00
> +#define ORB_CTRL_ILS	0x00000080
> +#define ORB_CTRL_MIDAW	0x00000040
> +#define ORB_CTRL_ORBX	0x00000001
> +
> +#define ORB_LPM_DFLT	0x00008000
> +
> +struct orb {
> +	uint32_t intparm;
> +	uint32_t ctrl;
> +	uint32_t cpa;
> +	uint32_t prio;
> +	uint32_t reserved[4];
> +} __attribute__ ((aligned(4)));
> +
> +struct scsw {
> +	uint32_t ctrl;
> +	uint32_t ccw_addr;
> +	uint8_t  dev_stat;
> +	uint8_t  sch_stat;
> +	uint16_t count;
> +};
> +
> +struct pmcw {
> +	uint32_t intparm;
> +#define PMCW_DNV        0x0001
> +#define PMCW_ENABLE     0x0080
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
> +	uint32_t flags2;
> +};
> +#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
> +
> +struct schib {
> +	struct pmcw pmcw;
> +	struct scsw scsw;
> +	uint8_t  md[12];
> +} __attribute__ ((aligned(4)));
> +
> +struct irb {
> +	struct scsw scsw;
> +	uint32_t esw[5];
> +	uint32_t ecw[8];
> +	uint32_t emw[8];
> +} __attribute__ ((aligned(4)));
> +
> +/* CSS low level access functions */
> +
> +static inline int ssch(unsigned long schid, struct orb *addr)
> +{
> +	register long long reg1 asm("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	ssch	0(%2)\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28\n"
> +		: "=3Dd" (cc)
> +		: "d" (reg1), "a" (addr), "m" (*addr)
> +		: "cc", "memory");
> +	return cc;
> +}
> +
> +static inline int stsch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	stsch	0(%3)\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int msch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	msch	0(%3)\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1), "m" (*addr), "a" (addr)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int tsch(unsigned long schid, struct irb *addr)
> +{
> +	register unsigned long reg1 asm ("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	tsch	0(%3)\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int hsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	hsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int xsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	xsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int csch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	csch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int rsch(unsigned long schid)
> +{
> +	register unsigned long reg1 asm("1") =3D schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	rsch\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int rchp(unsigned long chpid)
> +{
> +	register unsigned long reg1 asm("1") =3D chpid;
> +	int cc;
> +
> +	asm volatile(
> +		"	rchp\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=3Dd" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}
> +
> +/* Debug functions */
> +char *dump_pmcw_flags(uint16_t f);
> +char *dump_scsw_flags(uint32_t f);
> +
> +void dump_scsw(struct scsw *scsw);
> +void dump_irb(struct irb *irbp);
> +void dump_schib(struct schib *sch);
> +struct ccw1 *dump_ccw(struct ccw1 *cp);
> +void dump_irb(struct irb *irbp);
> +void dump_pmcw(struct pmcw *p);
> +void dump_orb(struct orb *op);
> +
> +int css_enumerate(void);
> +#define MAX_ENABLE_RETRIES      5
> +int css_enable(int schid);
> +
> +#endif
> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..0c2b64e
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,153 @@
> +/*
> + * Channel subsystem structures dumping
> + *
> + * Copyright (c) 2020 IBM Corp.
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + *
> + * Description:
> + * Provides the dumping functions for various structures used by subch=
annels:
> + * - ORB  : Operation request block, describes the I/O operation and p=
oints to
> + *          a CCW chain
> + * - CCW  : Channel Command Word, describes the command, data and flow=
 control
> + * - IRB  : Interuption response Block, describes the result of an ope=
ration;
> + *          holds a SCSW and model-dependent data.
> + * - SCHIB: SubCHannel Information Block composed of:
> + *   - SCSW: SubChannel Status Word, status of the channel.
> + *   - PMCW: Path Management Control Word
> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfe=
rs.
> + */
> +
> +#include <libcflat.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +#include <string.h>
> +
> +#include <css.h>
> +
> +/*
> + * Try to have a more human representation of the SCSW flags:
> + * each letter in the two strings represents the first
> + * letter of the associated bit in the flag fields.
> + */
> +static const char *scsw_str =3D "kkkkslccfpixuzen";
> +static const char *scsw_str2 =3D "1SHCrshcsdsAIPSs";
> +static char scsw_line[64] =3D {};
> +
> +char *dump_scsw_flags(uint32_t f)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < 16; i++) {
> +		if ((f << i) & 0x80000000)
> +			scsw_line[i] =3D scsw_str[i];
> +		else
> +			scsw_line[i] =3D '_';
> +	}
> +	scsw_line[i] =3D ' ';
> +	for (; i < 32; i++) {
> +		if ((f << i) & 0x80000000)
> +			scsw_line[i + 1] =3D scsw_str2[i - 16];
> +		else
> +			scsw_line[i + 1] =3D '_';
> +	}
> +	return scsw_line;
> +}
> +
> +/*
> + * Try to have a more human representation of the PMCW flags
> + * each letter in the string represents the first
> + * letter of the associated bit in the flag fields.
> + */
> +static const char *pmcw_str =3D "11iii111ellmmdtv";
> +static char pcmw_line[32] =3D {};
> +char *dump_pmcw_flags(uint16_t f)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < 16; i++) {
> +		if ((f << i) & 0x8000)
> +			pcmw_line[i] =3D pmcw_str[i];
> +		else
> +			pcmw_line[i] =3D '_';
> +	}
> +	return pcmw_line;
> +}
> +
> +void dump_scsw(struct scsw *s)
> +{
> +	dump_scsw_flags(s->ctrl);
> +	printf("scsw->flags: %s\n", scsw_line);
> +	printf("scsw->addr : %08x\n", s->ccw_addr);
> +	printf("scsw->devs : %02x\n", s->dev_stat);
> +	printf("scsw->schs : %02x\n", s->sch_stat);
> +	printf("scsw->count: %04x\n", s->count);
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
> +	printf("pmcw->flags2  : %08x\n", p->flags2);
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
> +struct ccw1 *dump_ccw(struct ccw1 *cp)
> +{
> +	printf("CCW: code: %02x flags: %02x count: %04x data: %08x\n", cp->co=
de,
> +	    cp->flags, cp->count, cp->data_address);
> +
> +	if (cp->code =3D=3D CCW_C_TIC)
> +		return (struct ccw1 *)(long)cp->data_address;
> +
> +	return (cp->flags & CCW_F_CC) ? cp + 1 : NULL;
> +}
> +
> +void dump_orb(struct orb *op)
> +{
> +	struct ccw1 *cp;
> +
> +	printf("ORB: intparm : %08x\n", op->intparm);
> +	printf("ORB: ctrl    : %08x\n", op->ctrl);
> +	printf("ORB: prio    : %08x\n", op->prio);
> +	cp =3D (struct ccw1 *)(long) (op->cpa);
> +	while (cp)
> +		cp =3D dump_ccw(cp);
> +}
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 47a94cc..3cb97da 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -52,6 +52,7 @@ cflatobjs +=3D lib/s390x/interrupt.o
>  cflatobjs +=3D lib/s390x/mmu.o
>  cflatobjs +=3D lib/s390x/smp.o
>  cflatobjs +=3D lib/s390x/kernel-args.o
> +cflatobjs +=3D lib/s390x/css_dump.o
> =20
>  OBJDIRS +=3D lib/s390x
> =20
>=20



--ETJjmlxEB98Y5rkSJ1ENhzLVYDDRs99wo--

--lxSYNQElsvrCqU8I4g5tCJtptKzt3pUBO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7we2EACgkQ41TmuOI4
ufi+Cg/+M3TeMUHNyCqeAeOpSbQBCmuWdk+tLbQEE9DnkIA3n9r7nFa3D/Me6mJ8
P8sQgQHPp9U463lK+8dD0jyIMplKHUCrrwnAZjS4uqejaxjAqmr7WvBBGZGwF6QP
U6dVRLjaGiw5wkXrf2EZNmVu1Lz4ZKEt67RGYLwS/Jb8jN8bXxm7q4zTPZKp3yET
o/Uz5r8WgI99ghhO8yym2ZKE1xt2qz5tofuvFYiej+W3OZfXByCOWndKZ/cUJeTE
gM8aPlCVd6K/lb3bHg7EozVa7F2WHn9Db6g2RG6stt0fpAGnBEvv1XSEUiW5B/W4
FzsvPLWgOT+t3bJ5PdTTA6ID7WvjF8XP7YEaZ5IydnMjat6A7opfapi7xgGNSKE3
PgYXPo86OvW+oQ8VNUssFIMV6ZWr+lyDHRUfkmuu5KQFDMtPla5yFrKvtGNk3hPx
ADFrsf66/EGeR3D+MHrNwr+v0PLUPlBfJcNVU2sZGg8NQ0djo9tbGUcsy9PpaCq2
s62IRgdOu113m6hL2pnNjJvcWgHftIVbFrBBSXyL+pc6VmzEACi1vy4QWi4uV7M/
545Zm/mkS62/tG0/4pEVWtkyKbqZSPFV5gpS9D50kK+U7VVo8thK0C8H4c0OAuE3
Z8rXbNXHd+fHjJcNT6D2gf5PAhmzm5KGqv1kGbwndO0HLX50FAo=
=kAWt
-----END PGP SIGNATURE-----

--lxSYNQElsvrCqU8I4g5tCJtptKzt3pUBO--

