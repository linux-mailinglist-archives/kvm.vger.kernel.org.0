Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B6211C9E8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 10:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbfLLJwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 04:52:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728373AbfLLJwC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 04:52:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC9lmL6057872
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 04:51:59 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wuhscb4nj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 04:51:59 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 12 Dec 2019 09:51:56 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 09:51:53 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBC9pqwV57606356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 09:51:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A5FC11C04A;
        Thu, 12 Dec 2019 09:51:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE71911C05C;
        Thu, 12 Dec 2019 09:51:51 +0000 (GMT)
Received: from dyn-9-152-224-51.boeblingen.de.ibm.com (unknown [9.152.224.51])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 09:51:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 5/9] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-6-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 12 Dec 2019 10:51:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1576079170-7244-6-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dc96MCbcXyr8pnzWxZtH3l4mj9pXmphNV"
X-TM-AS-GCONF: 00
x-cbid: 19121209-0016-0000-0000-000002D40FE5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121209-0017-0000-0000-000033363356
Message-Id: <dd5b82c6-f5bd-ff3d-b65f-300cacfee8a3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_02:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dc96MCbcXyr8pnzWxZtH3l4mj9pXmphNV
Content-Type: multipart/mixed; boundary="iMmnz3r5pZUe2SD6BDaEd5FGQl8CKApWQ"

--iMmnz3r5pZUe2SD6BDaEd5FGQl8CKApWQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/11/19 4:46 PM, Pierre Morel wrote:
> These are the include and library utilities for the css tests patch
> series.
>=20
> Debug function can be activated by defining DEBUG_CSS before the
> inclusion of the css.h header file.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++=

>  lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>  2 files changed, 416 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
>=20
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..fd086aa
> --- /dev/null
> +++ b/lib/s390x/css.h
> @@ -0,0 +1,259 @@
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
> +struct ccw1 {
> +	unsigned char code;
> +	unsigned char flags;
> +	unsigned short count;
> +	uint32_t data_address;
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

That looks weird.

> +
> +struct orb {
> +	uint32_t intparm;
> +	uint32_t ctrl;
> +	uint32_t cpa;
> +	uint32_t prio;
> +	uint32_t reserved[4];
> +} __attribute__ ((aligned(4)));

Are any of these ever stack allocated and therefore need alignment?

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
> +	int cc =3D -1;

Why is this one initialized but no other cc is?

> +
> +	asm volatile(
> +		"	   ssch	0(%2)\n"
> +		"0:	 ipm	 %0\n"
> +		"	   srl	 %0,28\n"

Formatting?

> +		"1:\n"

What do these jump labels do?

> +		: "+d" (cc)
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
> +		"	   stsch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
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
> +		"	   msch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=3Dd" (cc), "=3Dm" (*addr)
> +		: "d" (reg1), "a" (addr)
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
> +		"	   tsch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
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
> +#ifdef DEBUG_CSS
> +void dump_scsw(struct scsw *);
> +void dump_irb(struct irb *irbp);
> +void dump_schib(struct schib *sch);
> +struct ccw *dump_ccw(struct ccw *cp);
> +#else
> +static inline void dump_scsw(struct scsw *scsw) {}
> +static inline void dump_irb(struct irb *irbp) {}
> +static inline void dump_pmcw(struct pmcw *p) {}
> +static inline void dump_schib(struct schib *sch) {}
> +static inline void dump_orb(struct orb *op) {}
> +static inline struct ccw *dump_ccw(struct ccw *cp)
> +{
> +	return NULL;
> +}
> +#endif
> +
> +extern unsigned long stacktop;

That should be exported somewhere else, we also use it in
lib/s390x/sclp.c. Btw. why is it in here at all?

> +#endif
> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..ff1a812
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,157 @@
> +/*
> + * Channel subsystem structures dumping
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
> + * - ORB  : Operation request block, describes the I/O operation and p=
oints to
> + *          a CCW chain
> + * - CCW  : Channel Command Word, describes the data and flow control
> + * - IRB  : Interuption response Block, describes the result of an ope=
ration
> + *          holds a SCSW and model-dependent data.
> + * - SCHIB: SubCHannel Information Block composed of:
> + *   - SCSW: SubChannel Status Word, status of the channel.
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
> +#undef DEBUG_CSS
> +#include <css.h>
> +
> +/*
> + * Try to have a more human representation of the SCSW flags:
> + * each letter in the two strings he under represent the first

s/he under//

> + * letter of the associated bit in the flag.

in the flag fields?

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
> + * Try o have a more human representation of the PMCW flags
> + * each letter in the two strings he under represent the first
> + * letter of the associated bit in the flag.

Please rephrase

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
> +#ifdef DEBUG_CSS
> +void dump_scsw(struct scsw *s)
> +{
> +	dump_scsw_flags(s->ctrl);
> +	printf("scsw->flags: %s\n", line);
> +	printf("scsw->addr : %08x\n", s->addr);
> +	printf("scsw->devs : %02x\n", s->devs);
> +	printf("scsw->schs : %02x\n", s->schs);
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
> +#endif
>=20



--iMmnz3r5pZUe2SD6BDaEd5FGQl8CKApWQ--

--dc96MCbcXyr8pnzWxZtH3l4mj9pXmphNV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3yDbcACgkQ41TmuOI4
ufjXwhAAhmKJNnuLdw3JLHhpsDuab6cxfiI16QY+8+oKZVOq7/6jJamB8BUN6k73
Vn7iKEdHyy8wQuAeXeVXaaJiJT1zOfN326/iY01eSHeuUkJ9EzZK/bG75/VRosvR
AekvpSfA0Puki1lpf89AqDOzWVvwd3MX1mfGYC9ZLY6PFhYS9l0bsVdLcuxPDpjA
1GZMj5mmb903OBI0aACxqSmtAlgtgU/np8v+zLmT05hgsrnWElleR24AimGaKz98
GhVB1YQ1jhIcQ/de63bZkLpWcP5qyxMb81YpZ7BHCd0Y4w268ZZM2MheRo8Or3pV
3mvRq230ZmCnZwiv8IgxZIbWzX4h2A2fcixIZwoJsHtqgzsJsGQcggdqG8/sHq8R
ETuHnEn7VbYev1waGvzp9e1H9k8V3zc7ypS12RuFMg/5TWHV43SZ4TCScKkQ0Hby
VR1spXLplDXH5dljTXlamO/N1pYCvSqTPOsJb1sxTbiLyR+KCxlJHdZMdTOA7NxO
4sUcZwlgOKDY9me0g0gqRpQFVqm4OnQugtQ7jFA6PnvLmUhEUYqWA7mbKpFwMXUm
6qcjZYosxzsqlfD6KKZCUm6pWJJkz5EYY16q6KLysnvbE6/jZMJYYMpuDwok0x8b
zCtIp5BXVYf0slltBtp3pjiHt9yTkkM6hCurGpSvO9mYM+ZehAE=
=szOv
-----END PGP SIGNATURE-----

--dc96MCbcXyr8pnzWxZtH3l4mj9pXmphNV--

