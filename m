Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFC227B18
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 10:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgGUIw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 04:52:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728850AbgGUIw0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 04:52:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06L8Y539074146;
        Tue, 21 Jul 2020 04:52:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32cdyaqd66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 04:52:25 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06L8Y9NK074539;
        Tue, 21 Jul 2020 04:52:24 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32cdyaqd4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 04:52:24 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06L8oOhJ009890;
        Tue, 21 Jul 2020 08:52:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 32brq81uwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 08:52:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06L8qJHh28442980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 08:52:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AD984C046;
        Tue, 21 Jul 2020 08:52:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1F944C044;
        Tue, 21 Jul 2020 08:52:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 08:52:18 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-3-frankja@linux.ibm.com>
 <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <032c1103-3020-9deb-a307-70ded3bdb55e@linux.ibm.com>
Date:   Tue, 21 Jul 2020 10:52:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xMZyrpipTA2KqjcA3SYYgxjli9C4GwRh9"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_02:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xMZyrpipTA2KqjcA3SYYgxjli9C4GwRh9
Content-Type: multipart/mixed; boundary="Pgy1o91AOZpK5E76FrGO7T6I0fTfchkNW"

--Pgy1o91AOZpK5E76FrGO7T6I0fTfchkNW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/21/20 9:28 AM, Thomas Huth wrote:
> On 17/07/2020 16.58, Janosch Frank wrote:
>> If a exception new psw mask contains a key a specification exception
>> instead of a special operation exception is presented.
>=20
> I have troubles parsing that sentence... could you write that different=
ly?
> (and: "s/a exception/an exception/")

How about:

When an exception psw new with a storage key in its mask is loaded from
lowcore a specification exception is raised instead of the special
operation exception that is normally presented when skrf is active.

>=20
>> Let's test
>> that.
>>
>> Also let's add the test to unittests.cfg so it is run more often.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/skrf.c        | 81 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |  4 +++
>>  2 files changed, 85 insertions(+)
>>
>> diff --git a/s390x/skrf.c b/s390x/skrf.c
>> index 9cae589..9733412 100644
>> --- a/s390x/skrf.c
>> +++ b/s390x/skrf.c
>> @@ -15,6 +15,8 @@
>>  #include <asm/page.h>
>>  #include <asm/facility.h>
>>  #include <asm/mem.h>
>> +#include <asm/sigp.h>
>> +#include <smp.h>
>> =20
>>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
>> =20
>> @@ -106,6 +108,84 @@ static void test_tprot(void)
>>  	report_prefix_pop();
>>  }
>> =20
>> +#include <asm-generic/barrier.h>
>=20
> Can we keep the #includes at the top of the file, please?

Yes

>=20
>> +static int testflag =3D 0;
>> +
>> +static void wait_for_flag(void)
>> +{
>> +	while (!testflag)
>> +		mb();
>> +}
>> +
>> +static void set_flag(int val)
>> +{
>> +	mb();
>> +	testflag =3D val;
>> +	mb();
>> +}
>> +
>> +static void ecall_cleanup(void)
>> +{
>> +	struct lowcore *lc =3D (void *)0x0;
>> +
>> +	lc->ext_new_psw.mask =3D 0x0000000180000000UL;
>=20
> Don't we have defines for the PSW values yet?

Pierre dropped that patch because of your old binutils version...

>=20
>> +	lc->sw_int_crs[0] =3D 0x0000000000040000;
>> +
>> +	/*
>> +	 * PGM old contains the ext new PSW, we need to clean it up,
>> +	 * so we don't get a special oepration exception on the lpswe
>=20
> operation

fixed

>=20
>> +	 * of pgm old.
>> +	 */
>> +	lc->pgm_old_psw.mask =3D 0x0000000180000000UL;
>> +	lc->pgm_old_psw.addr =3D (unsigned long)wait_for_flag;
>> +
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	set_flag(1);
>> +}
>=20
>  Thomas
>=20



--Pgy1o91AOZpK5E76FrGO7T6I0fTfchkNW--

--xMZyrpipTA2KqjcA3SYYgxjli9C4GwRh9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8WrMIACgkQ41TmuOI4
ufikrBAAt3tuzugHWo+wRVmTna4z83VE4T4EreGnRr0dLChOM3ulqk/XwIKzNpPJ
9OQzdpvYsY2Si9Z9FKElMOVe+9OLXe0D78ksRBzdEC7WphdLUxVXawSeB+cLqIEW
vn4hDvPJipg6J2fAjG1sOeErWQbGmjra1P/GFEY15rGQ23AHqCWXIz+w1OicCrtb
pPDWPluK98UTiqYAg9OjJxHrvjr/dvxQijMdW97XEKQ4OeHV0XT9zhKrTtKAoGp9
gD1goKDJNr64fPoVnduzKgZdiPPbPlrci9daVhgsAzF4cTlWqm7xBiVFdNPpH54U
wbVUzAwCmxkfknW7WhwwXeW8zLy3HrfYiaK5vaZm6FO25roUO6HTadgHqC8t6wwa
B3c8IBjFXllF1Y+OyufTbVu4kc0N3l9dMQAWE9nrVgkYZqVS4KVSKqWlQJqdJ3i0
KtbQSI7HttkkVW/bCR4W9ofOOpmSxCQnJ1jfavQ+ZQHASRkbsgCB9tEuCJ0blXBT
TDrsCcKQj4HDY1S8wsD/bwZV3ZBzKbCopakLBUv1W4eUR4VF3mj+rODtmF7iiwkk
DBcYV3ppUjopSLSr6eQb68TQRvTDj9QR24GOPZOVKO9ozXqnOjzGfQqxBInZN3z7
31vyubSNkWvBeTnFN2TGuv96h5PJiTBWa59djLE0N0ArQab9U8s=
=2BGP
-----END PGP SIGNATURE-----

--xMZyrpipTA2KqjcA3SYYgxjli9C4GwRh9--

