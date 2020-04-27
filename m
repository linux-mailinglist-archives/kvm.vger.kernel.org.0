Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753291BA438
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgD0NG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 09:06:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgD0NG4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 09:06:56 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RD257V046103;
        Mon, 27 Apr 2020 09:06:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhcxh7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 09:06:54 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03RD4ISS055914;
        Mon, 27 Apr 2020 09:06:54 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhcxh6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 09:06:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RCoXBL019535;
        Mon, 27 Apr 2020 13:06:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7uvwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 13:06:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RD6nZ357540698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 13:06:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ADD95204F;
        Mon, 27 Apr 2020 13:06:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.33.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E314A52050;
        Mon, 27 Apr 2020 13:06:48 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 06/10] s390x: css: stsch, enumeration
 test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2f1e27a9-1cb2-79b2-b655-6f170431a14f@linux.ibm.com>
Date:   Mon, 27 Apr 2020 15:06:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Aq0bUnkXJUTuQNnQsgaJGCELpHbwGkafP"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_09:2020-04-24,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Aq0bUnkXJUTuQNnQsgaJGCELpHbwGkafP
Content-Type: multipart/mixed; boundary="Y95dPwLfgyXzPR3Grej7fTOORbhD9gPwz"

--Y95dPwLfgyXzPR3Grej7fTOORbhD9gPwz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/24/20 12:45 PM, Pierre Morel wrote:
> First step for testing the channel subsystem is to enumerate the css an=
d
> retrieve the css devices.
>=20
> This tests the success of STSCH I/O instruction, we do not test the
> reaction of the VM for an instruction with wrong parameters.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  s390x/Makefile      |  2 +
>  s390x/css.c         | 92 +++++++++++++++++++++++++++++++++++++++++++++=

>  s390x/unittests.cfg |  4 ++
>  4 files changed, 99 insertions(+)
>  create mode 100644 s390x/css.c
>=20
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index bab0dd5..9417541 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -82,6 +82,7 @@ struct pmcw {
>  	uint8_t  chpid[8];
>  	uint32_t flags2;
>  };
> +#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)

Why isn't this in the library patch?

> =20
>  struct schib {
>  	struct pmcw pmcw;
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ddb4b48..baebf18 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -17,6 +17,7 @@ tests +=3D $(TEST_DIR)/stsi.elf
>  tests +=3D $(TEST_DIR)/skrf.elf
>  tests +=3D $(TEST_DIR)/smp.elf
>  tests +=3D $(TEST_DIR)/sclp.elf
> +tests +=3D $(TEST_DIR)/css.elf
>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> =20
>  all: directories test_cases test_cases_binary
> @@ -51,6 +52,7 @@ cflatobjs +=3D lib/s390x/sclp-console.o
>  cflatobjs +=3D lib/s390x/interrupt.o
>  cflatobjs +=3D lib/s390x/mmu.o
>  cflatobjs +=3D lib/s390x/smp.o
> +cflatobjs +=3D lib/s390x/css_dump.o

Why isn't this in the library patch?

> =20
>  OBJDIRS +=3D lib/s390x
> =20
> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..cc97e79
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,92 @@
> +/*
> + * Channel Subsystem tests
> + *
> + * Copyright (c) 2020 IBM Corp
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
> +#include <interrupt.h>
> +#include <asm/arch_def.h>
> +
> +#include <css.h>
> +
> +#define SID_ONE		0x00010000

Why isn't this in the library patch?

> +
> +static struct schib schib;
> +static int test_device_sid;
> +
> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw =3D &schib.pmcw;
> +	int cc;
> +	int scn;
> +	int scn_found =3D 0;
> +	int dev_found =3D 0;
> +
> +	for (scn =3D 0; scn < 0xffff; scn++) {
> +		cc =3D stsch(scn|SID_ONE, &schib);
> +		switch (cc) {
> +		case 0:		/* 0 means SCHIB stored */
> +			break;
> +		case 3:		/* 3 means no more channels */
> +			goto out;
> +		default:	/* 1 or 2 should never happened for STSCH */
> +			report(0, "Unexpected cc=3D%d on subchannel number 0x%x",
> +			       cc, scn);
> +			return;
> +		}
> +		/* We currently only support type 0, a.k.a. I/O channels */
> +		if (PMCW_CHANNEL_TYPE(pmcw) !=3D 0)
> +			continue;
> +		/* We ignore I/O channels without valid devices */
> +		scn_found++;
> +		if (!(pmcw->flags & PMCW_DNV))
> +			continue;
> +		/* We keep track of the first device as our test device */
> +		if (!test_device_sid)
> +			test_device_sid =3D scn|SID_ONE;

Give the pipe some space :)

> +		dev_found++;

Newlines would make this more readable.

> +	}
> +out:

We can report dev_found instead of 0/1 and a if/else

report(dev_found,
	"Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
                    scn, scn_found, dev_found);=09

> +	if (!dev_found) {
> +		report(0,
> +		       "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d=
",
> +		       scn, scn_found, dev_found);
> +		return;
> +	}
> +	report(1,
> +	       "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d"=
,
> +	       scn, scn_found, dev_found);
> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] =3D {
> +	{ "enumerate (stsch)", test_enumerate },
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("Channel Subsystem");
> +	for (i =3D 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 07013b2..a436ec0 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -83,3 +83,7 @@ extra_params =3D -m 1G
>  [sclp-3g]
>  file =3D sclp.elf
>  extra_params =3D -m 3G
> +
> +[css]
> +file =3D css.elf
> +extra_params =3D-device ccw-pong
>=20



--Y95dPwLfgyXzPR3Grej7fTOORbhD9gPwz--

--Aq0bUnkXJUTuQNnQsgaJGCELpHbwGkafP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6m2OgACgkQ41TmuOI4
ufimLg/+Kt1j5l3VyTURlS5kWRzPhJf4kcLS79Xdj/b/Wdmny6e62anAuEptD+5A
aRinGtalQ5UC1EebK7U+k8bsmeuwoU4J/h2ZSqDmcvKEj8xAp/SkMKWggOvJNveI
ojjLnt0313WCFn7i6oYZqkCdqOYraNg8rBQHfuoejOoNHJqITiV33m94U7P/71ZW
HIzKtAE1WpTe5dt/8mxzpbJT2GNiDb1AlqmBwSh84qrgWEtmpw7f0dx3TlL5mqzi
DGo8+r51mpaWHndSu0TIHbwF6HBYT/T5jmCabAE0NtGAhOCe23xQdiX2H92/8LYI
xY35YGVwjfDcSGX0v2RUq6uUKl4tJlG3+TG5O0rEJmJ6FYmVYstCIVfN6FJI5CSP
YBqqHZO7z8+3wRMCL6HloiS4O3VADLL/YbwmSKVGDBhoxtEvhZk7PmlBf69NqKDn
Zxsy8ocILtuExcOlRAhtGyEcbksK4Gsk3q4t00r2OocsgGG+1bFEd0o6NrAmasCV
x4ADyumzf1ymWmZiHKePbN30mx2F6YdOPmj5CYib/ALBkaoy7V0R6+959v/jmEvw
i88JnT7zMr9GKlW0HSdkxhCE/Xnt2BxVHZ45fdMs6fk/8gddifKewwPNsy8D/bqk
N19IQlc+UrY0+q36CEFhPd1U1qPJPl5LODWZ8svHtRJ3HDpeGy4=
=tLCB
-----END PGP SIGNATURE-----

--Aq0bUnkXJUTuQNnQsgaJGCELpHbwGkafP--

