Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F162220D2
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGPKnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 06:43:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726239AbgGPKne (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 06:43:34 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GAUmXK008237
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 06:43:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329r20tk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 06:43:31 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06GAWXeb013790
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 06:43:31 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329r20tk8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 06:43:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GAe4Wh029733;
        Thu, 16 Jul 2020 10:43:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyhpuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 10:43:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GAhRE444761232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 10:43:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50508AE045;
        Thu, 16 Jul 2020 10:43:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9A7BAE051;
        Thu, 16 Jul 2020 10:43:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.148.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 10:43:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests v3 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
To:     Thomas Huth <thuth@redhat.com>, david@redhat.com,
        kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20200708150025.20631-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d1c735ad-d06e-766d-9f74-f2e9a5392209@linux.ibm.com>
Date:   Thu, 16 Jul 2020 12:43:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708150025.20631-1-thuth@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1ipfBpHMXpjOJhOB57VDc1L228BrbKnMU"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1ipfBpHMXpjOJhOB57VDc1L228BrbKnMU
Content-Type: multipart/mixed; boundary="5OCZrvxvF1brBsX8Blrfl0SO2eWZf2ehX"

--5OCZrvxvF1brBsX8Blrfl0SO2eWZf2ehX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/8/20 5:00 PM, Thomas Huth wrote:
> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)=

> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead=
,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Thanks, applied to:
https://github.com/frankjaa/kvm-unit-tests/commits/next


> ---
>  v3:
>  - Moved the is_tcg() function to the library so that it can be used
>    later by other tests, too
>  - Make sure to call alloc_page() and stsi() only once
>=20
>  v2:
>  - Rewrote the logic, introduced expected_tcg_fail flag
>  - Use manufacturer string instead of VM name to detect TCG
>=20
>  lib/s390x/vm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h   | 14 ++++++++++++++
>  s390x/Makefile   |  1 +
>  s390x/cpumodel.c | 19 +++++++++++++------
>  4 files changed, 74 insertions(+), 6 deletions(-)
>  create mode 100644 lib/s390x/vm.c
>  create mode 100644 lib/s390x/vm.h
>=20
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> new file mode 100644
> index 0000000..c852713
> --- /dev/null
> +++ b/lib/s390x/vm.c
> @@ -0,0 +1,46 @@
> +/*
> + * Functions to retrieve VM-specific information
> + *
> + * Copyright (c) 2020 Red Hat Inc
> + *
> + * Authors:
> + *  Thomas Huth <thuth@redhat.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.1-or-later
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/arch_def.h>
> +#include "vm.h"
> +
> +/**
> + * Detect whether we are running with TCG (instead of KVM)
> + */
> +bool vm_is_tcg(void)
> +{
> +	const char qemu_ebcdic[] =3D { 0xd8, 0xc5, 0xd4, 0xe4 };
> +	static bool initialized =3D false;
> +	static bool is_tcg =3D false;
> +	uint8_t *buf;
> +
> +	if (initialized)
> +		return is_tcg;
> +
> +	buf =3D alloc_page();
> +	if (!buf)
> +		return false;
> +
> +	if (stsi(buf, 1, 1, 1))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "QEMU" in EBCDIC, then we
> +	 * are on TCG (otherwise the string is "IBM" in EBCDIC)
> +	 */
> +	is_tcg =3D !memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic));
> +	initialized =3D true;
> +out:
> +	free_page(buf);
> +	return is_tcg;
> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> new file mode 100644
> index 0000000..33008d8
> --- /dev/null
> +++ b/lib/s390x/vm.h
> @@ -0,0 +1,14 @@
> +/*
> + * Functions to retrieve VM-specific information
> + *
> + * Copyright (c) 2020 Red Hat Inc
> + *
> + * SPDX-License-Identifier: LGPL-2.1-or-later
> + */
> +
> +#ifndef S390X_VM_H
> +#define S390X_VM_H
> +
> +bool vm_is_tcg(void);
> +
> +#endif  /* S390X_VM_H */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ddb4b48..98ac29e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -51,6 +51,7 @@ cflatobjs +=3D lib/s390x/sclp-console.o
>  cflatobjs +=3D lib/s390x/interrupt.o
>  cflatobjs +=3D lib/s390x/mmu.o
>  cflatobjs +=3D lib/s390x/smp.o
> +cflatobjs +=3D lib/s390x/vm.o
> =20
>  OBJDIRS +=3D lib/s390x
> =20
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 5d232c6..116a966 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -11,14 +11,19 @@
>   */
> =20
>  #include <asm/facility.h>
> +#include <vm.h>
> =20
> -static int dep[][2] =3D {
> +static struct {
> +	int facility;
> +	int implied;
> +	bool expected_tcg_fail;
> +} dep[] =3D {
>  	/* from SA22-7832-11 4-98 facility indications */
>  	{   4,   3 },
>  	{   5,   3 },
>  	{   5,   4 },
>  	{  19,  18 },
> -	{  37,  42 },
> +	{  37,  42, true },  /* TCG does not have DFP and won't get it soon *=
/
>  	{  43,  42 },
>  	{  73,  49 },
>  	{ 134, 129 },
> @@ -46,11 +51,13 @@ int main(void)
> =20
>  	report_prefix_push("dependency");
>  	for (i =3D 0; i < ARRAY_SIZE(dep); i++) {
> -		if (test_facility(dep[i][0])) {
> -			report(test_facility(dep[i][1]), "%d implies %d",
> -				dep[i][0], dep[i][1]);
> +		if (test_facility(dep[i].facility)) {
> +			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
> +				     test_facility(dep[i].implied),
> +				     "%d implies %d",
> +				     dep[i].facility, dep[i].implied);
>  		} else {
> -			report_skip("facility %d not present", dep[i][0]);
> +			report_skip("facility %d not present", dep[i].facility);
>  		}
>  	}
>  	report_prefix_pop();
>=20



--5OCZrvxvF1brBsX8Blrfl0SO2eWZf2ehX--

--1ipfBpHMXpjOJhOB57VDc1L228BrbKnMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8QL04ACgkQ41TmuOI4
ufjSDQ/9HWOLsR8GsqQBBLqhoJP58ST+ydFItfp0trGx+4Vac4xF7Gnhh6iYEHKr
4P61Hqoy4Xd66vQoLgKXXc+pKnlDWJdRfV6gk7XJciJjFWf4kQrnYp2/ahOeuoBS
rvkOUkDYVgmetycGWq70pnbu3Bqpy1w0nyNEXyujMOTCUUacBhnX0G7Ik2VUEupo
Ho8slwPL/47YBOfKVPbxeQXzK5nD3beswWP3jNWPIagzSvB/XwY3mqPISisD3qe1
q5nhmhvL9sQt6gBbVjAqotArQVXYmTXuSM0yelewIuLK3vZdylmARB4oNVCFFiOr
OO3GSEnZLukhmmpUEXcai7cjvd+iSOEbdFhZvHb8XdmO9gyCpK8I0sM7Y8OwS0Tv
DGdG7xZ2iLuvfvpY26kS7IlXFJmhEvT5tg/urNjrez06a280WOFR8X+HwuEvoi3j
DVrsQdhZJBLoDGA02+cNlue1m4cpCLQewQh85S2aDjzruVqywwO/LfEdi3HDH1tA
dC07t6LVL1faPnR7gUPMgrzoST4j457OkyzXbZP1CP3Fni5MX2wA4QRGf+LjIGxa
KfELh+GDb1MkiEsG7yLBctHFyVwno9be0OGGrsEt3BDaQ3UPPxFzLw0ve/v1pYiC
nayM0r5wXlLMMiHplQNa0zbD7YA4kmKUhsoJS5FbRnh7CiAxTQU=
=Rh4t
-----END PGP SIGNATURE-----

--1ipfBpHMXpjOJhOB57VDc1L228BrbKnMU--

