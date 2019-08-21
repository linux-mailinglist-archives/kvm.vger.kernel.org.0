Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337639754C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 10:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfHUIrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 04:47:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726712AbfHUIrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Aug 2019 04:47:01 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7L8fKoW046802
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 04:47:00 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh2nu08bt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 04:47:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 21 Aug 2019 09:46:58 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 09:46:56 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7L8ktNa57737304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 08:46:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93A4252051;
        Wed, 21 Aug 2019 08:46:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5097152050;
        Wed, 21 Aug 2019 08:46:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: STSI tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-4-frankja@linux.ibm.com>
 <ef4faf31-e9db-f984-94ec-f3c332823b6f@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 21 Aug 2019 10:46:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ef4faf31-e9db-f984-94ec-f3c332823b6f@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i46DJLcmY8aRHGp7zothYhcO0H3zCuEZ6"
X-TM-AS-GCONF: 00
x-cbid: 19082108-4275-0000-0000-0000035B6E65
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082108-4276-0000-0000-0000386D90B3
Message-Id: <08a4f2f8-5654-7883-615a-5a8d5f9b72b1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i46DJLcmY8aRHGp7zothYhcO0H3zCuEZ6
Content-Type: multipart/mixed; boundary="2YH4lhAejYvP9htODCU6luvP6d6AcGZDD";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <08a4f2f8-5654-7883-615a-5a8d5f9b72b1@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: STSI tests
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-4-frankja@linux.ibm.com>
 <ef4faf31-e9db-f984-94ec-f3c332823b6f@redhat.com>
In-Reply-To: <ef4faf31-e9db-f984-94ec-f3c332823b6f@redhat.com>

--2YH4lhAejYvP9htODCU6luvP6d6AcGZDD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/20/19 3:21 PM, Thomas Huth wrote:
> On 8/20/19 12:55 PM, Janosch Frank wrote:
>> For now let's concentrate on the error conditions.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/stsi.c        | 123 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |   5 +-
>>  3 files changed, 128 insertions(+), 1 deletion(-)
>>  create mode 100644 s390x/stsi.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index b654c56..311ab77 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -12,6 +12,7 @@ tests +=3D $(TEST_DIR)/vector.elf
>>  tests +=3D $(TEST_DIR)/gs.elf
>>  tests +=3D $(TEST_DIR)/iep.elf
>>  tests +=3D $(TEST_DIR)/diag288.elf
>> +tests +=3D $(TEST_DIR)/stsi.elf
>>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>> =20
>>  all: directories test_cases test_cases_binary
>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>> new file mode 100644
>> index 0000000..005f337
>> --- /dev/null
>> +++ b/s390x/stsi.c
>> @@ -0,0 +1,123 @@
>> +/*
>> + * Store System Information tests
>> + *
>> + * Copyright (c) 2019 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify =
it
>> + * under the terms of the GNU Library General Public License version =
2.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +
>> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
>> +
>> +static inline unsigned long stsi(unsigned long *addr,
>> +				 unsigned long fc, uint8_t sel1, uint8_t sel2)
>=20
> Return code should be "int", not "long".
>=20
> I'd also suggest to use "void *addr" instead of "unsigned long *addr",
> then you don't have to cast the pagebuf when you're calling this functi=
on.

Ok

>=20
>> +{
>> +	register unsigned long r0 asm("0") =3D (fc << 28) | sel1;
>> +	register unsigned long r1 asm("1") =3D sel2;
>> +	int cc;
>> +
>> +	asm volatile("stsi	0(%3)\n"
>> +		     "ipm	 %[cc]\n"
>> +		     "srl	 %[cc],28\n"
>> +		     : "+d" (r0), [cc] "=3Dd" (cc)
>> +		     : "d" (r1), "a" (addr)
>> +		     : "cc", "memory");
>> +	return cc;
>> +}
>=20
> Bonus points for putting that function into a header and re-use it in
> skey.c (maybe in a separate patch, though).

I forgot that you added that...
How about moving it to lib/s390/asm/arch_def.h ?

[...]

>> +static void test_fc(void)
>> +{
>> +	report("cc =3D=3D 3", stsi((void *)pagebuf, 7, 0, 0));
>=20
> Shouldn't that line look like this instead:
>=20
>     	report("cc =3D=3D 3", stsi((void *)pagebuf, 7, 0, 0) =3D=3D 3);
>=20
> ?

Yes

>=20
>> +	report("r0 =3D=3D 3", stsi_get_fc((void *)pagebuf));
>=20
>     report("r0 >=3D 3", stsi_get_fc((void *)pagebuf) >=3D 3);
>=20
> ?

Well rather >=3D 2 because we can also run on lpar with some additional
patches applied. Time to test this under lpar...

>=20
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("stsi");
>> +	test_priv();
>> +	test_specs();
>> +	test_fc();
>> +	return report_summary();
>> +}
>=20
> How about adding another test for access exceptions? Activate low
> address protection, then store to address 4096 ... and/or check
> "stsi((void *)-0xdeadadd, 1, 0, 0);" ?

Sounds good

>=20
>  Thomas
>=20



--2YH4lhAejYvP9htODCU6luvP6d6AcGZDD--

--i46DJLcmY8aRHGp7zothYhcO0H3zCuEZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1dBP4ACgkQ41TmuOI4
ufh0+RAAzk77Kl+NrJ5MT6YKtiS+Fl7XqYS69sQlBQaAlHFUAMVsmhslFwSZybn+
FT5fUFewNhIU6kGjNnnX5MzMrBOCnkuB7s+GJ8B19EQtfrzvtXdqKIcx+Ro3jOCm
DeM8hr4cbsSNcj4VgSOxiN08nEMAZWnb0XtjIfQgOkkje6sMpU5TkE00EHKHZDbP
xHnIJyev7B04USALDEiwhOUL8Diw30Fp6zbayrBVzOYjFPwoBGr7lyuhWCUcHx4p
hrfhWZIaX7LgTRaaL4R/16nrc02PfFek5y18p4dw3XHgTjhEUBwsXWZweeVaInOL
OuVv6oVpC5lz/BO37CW3OMjFaSy2MZe9wklrK8L8N8uBeouuq0v77uTYPS/Yc7bu
ApE1Ck46NSdqympKR0PutR1cjGUriRK1UMzSKzGOQKjzm42oel1S6rRROce7elEy
GIwGOPL7fC0xBKvYOARDkPMz7lgZ9jpdsqJuAdW3l51yIslpOMRoCWR2Yiq8zc/I
MAIqlbRKVWIlFZuTCrYvRlf3qyphZdX8D4KSTh5lvmEf3ZBtl3ltrUR8aG1x1nV4
HEdoawzQXmRta4pfp4Y4SgHx0E0oilVnzpVIE7DuAwvYfode+P15DfCF2Z9+OVKS
hOfa+O6H4HWIRv47WiTyIIX9BlZJhNiaL58HmvnLfP90DlYe/IU=
=6Lxl
-----END PGP SIGNATURE-----

--i46DJLcmY8aRHGp7zothYhcO0H3zCuEZ6--

