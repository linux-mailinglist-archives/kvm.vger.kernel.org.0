Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EE776029
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 09:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfGZHyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 03:54:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbfGZHyC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jul 2019 03:54:02 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6Q7mG72055177
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 03:54:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tyvx89erh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 03:54:01 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 26 Jul 2019 08:53:59 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 26 Jul 2019 08:53:56 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6Q7rt3255771368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 07:53:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57C085204E;
        Fri, 26 Jul 2019 07:53:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.12.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1DE7252054;
        Fri, 26 Jul 2019 07:53:55 +0000 (GMT)
Subject: Re: [ v3 1/1] kvm-unit-tests: s390: add cpu model checks
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190726065412.175785-1-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 26 Jul 2019 09:53:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190726065412.175785-1-borntraeger@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s6q7Fmif8N68ZUwzarw2qTKYCEP7OOrtt"
X-TM-AS-GCONF: 00
x-cbid: 19072607-0012-0000-0000-0000033665CC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072607-0013-0000-0000-0000216FFFD7
Message-Id: <c4c45a04-a644-b51c-41a0-6b35008e828d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s6q7Fmif8N68ZUwzarw2qTKYCEP7OOrtt
Content-Type: multipart/mixed; boundary="sIbB8J9xtu7uwzvXyOCnlw4TtzS7YghZT";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org
Message-ID: <c4c45a04-a644-b51c-41a0-6b35008e828d@linux.ibm.com>
Subject: Re: [ v3 1/1] kvm-unit-tests: s390: add cpu model checks
References: <20190726065412.175785-1-borntraeger@de.ibm.com>
In-Reply-To: <20190726065412.175785-1-borntraeger@de.ibm.com>

--sIbB8J9xtu7uwzvXyOCnlw4TtzS7YghZT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/19 8:54 AM, Christian Borntraeger wrote:
> This adds a check for documented stfle dependencies.
>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
> V2->V3:
> 	- add 135,129
> 	- add spaces between number and curly braces
> 	- simplify check
>  s390x/Makefile      |  1 +
>  s390x/cpumodel.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++=

>  s390x/unittests.cfg |  3 +++
>  3 files changed, 62 insertions(+)
>  create mode 100644 s390x/cpumodel.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 1f21ddb9c943..574a9a20824d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -11,6 +11,7 @@ tests +=3D $(TEST_DIR)/cmm.elf
>  tests +=3D $(TEST_DIR)/vector.elf
>  tests +=3D $(TEST_DIR)/gs.elf
>  tests +=3D $(TEST_DIR)/iep.elf
> +tests +=3D $(TEST_DIR)/cpumodel.elf
>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> =20
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> new file mode 100644
> index 000000000000..1e4cc39026b9
> --- /dev/null
> +++ b/s390x/cpumodel.c
> @@ -0,0 +1,58 @@
> +/*
> + * Test the known dependencies for facilities
> + *
> + * Copyright 2019 IBM Corp.
> + *
> + * Authors:
> + *    Christian Borntraeger <borntraeger@de.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU Library General Public License version 2=
=2E
> + */
> +
> +#include <asm/facility.h>
> +
> +static int dep[][2] =3D {
> +	/* from SA22-7832-11 4-98 facility indications */
> +	{   4,   3 },
> +	{   5,   3 },
> +	{   5,   4 },
> +	{  19,  18 },
> +	{  37,  42 },
> +	{  43,  42 },
> +	{  73,  49 },
> +	{ 134, 129 },
> +	{ 135, 129 },
> +	{ 139,  25 },
> +	{ 139,  28 },
> +	{ 146,  76 },
> +	/* indirectly documented in description */
> +	{  78,   8 },  /* EDAT */
> +	/* new dependencies from gen15 */
> +	{  61,  45 },
> +	{ 148, 129 },
> +	{ 148, 135 },
> +	{ 152, 129 },
> +	{ 152, 134 },
> +	{ 155,  76 },
> +	{ 155,  77 },

I'd generally appreciate comments for the left part of the bits.
At some point I have to look up bit 50, it says it is only meaningful
with bit 73, but there's no hard requirement from the wording.

> +};
> +
> +int main(void)
> +{
> +	int i;
> +
> +	report_prefix_push("cpumodel");
> +
> +	report_prefix_push("dependency");
> +	for (i =3D 0; i < ARRAY_SIZE(dep); i++) {
> +		if (test_facility(dep[i][0])) {
> +			report("%d implies %d", test_facility(dep[i][1]),
> +				dep[i][0], dep[i][1]);
> +		} else {
> +			report_skip("facility %d not present", dep[i][0]);
> +		}
> +	}
> +	report_prefix_pop();

There's a pop missing and formatting therefore doesn't match the pushs.

> +	return report_summary();
> +}

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 546b1f281f8f..db58bad5a038 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -61,3 +61,6 @@ file =3D gs.elf
> =20
>  [iep]
>  file =3D iep.elf
> +
> +[cpumodel]
> +file =3D cpumodel.elf
>=20



--sIbB8J9xtu7uwzvXyOCnlw4TtzS7YghZT--

--s6q7Fmif8N68ZUwzarw2qTKYCEP7OOrtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl06sZIACgkQ41TmuOI4
ufi6KxAAqdNGUS4voMqwzgn3oqJ6lu91769j9h0ONszDBuxHTX3/zC6X2us0Mb4C
g+ti0AWxPY1V4JBh9Unja+onbcjiJkkMm5ByhhO/qYX/pAHt0q9tfVS8q8OzTvq3
st/+cKYxcoY14MhwQD7STYvhduQljuBOaTMIxDoByTgHQsnXRabg7tDXyTzIeSpA
XyjyePmDfdrMD6rt1lKxAw8AAJm/JnYiw89YdxqPz1+IU105w1oygU36BWoomVsC
KraNUkN+0XF+mHMS9jkBdjmTKgv1lcA6q8GMvo8W4WnuiPa+334F6ufmC9DqzHWU
2GcvK3vhoh+qA+sxgjA2UIZ/IhVKF4GqcJeq2zQL7i0yK68ZLWo5BH/mgjVGeC2H
fOVODwFsF0qKWM81bar7++RJ5csB/x9HoOSOviCj/6BZ9kuE5NOAmon8ihhEz1Fa
i5gNeIivfj+mLeNkij0WISCUT9mbvkIs9WKe2Hnwm0nqp+d0S1zT7JwtKbhXSQbz
MJmsMtqNC79DkgGvy+felAgXp1r+HuK/OfL7SipEMHts6tPy7soAxVd/f+BoddZk
Y/Kwx8Di8jldfiJDEepmq/ZkZ7lG6IEt7GVAsSQPl1vSrH5g5gQffUU8hJgTZNUD
Lv9tLLXPTdv9T0B7hEB1mRWTgLa/wMIgIfl20JxpEHVpdWu1MdA=
=ubcY
-----END PGP SIGNATURE-----

--s6q7Fmif8N68ZUwzarw2qTKYCEP7OOrtt--

