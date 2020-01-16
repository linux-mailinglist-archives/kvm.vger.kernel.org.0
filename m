Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA2E13DB20
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 14:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgAPNH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 08:07:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgAPNH0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 08:07:26 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GD7FOH005479
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:07:25 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xh8d669jq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:07:21 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 13:07:17 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 13:07:15 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GD7Enw47448512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 13:07:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BEBF42056;
        Thu, 16 Jan 2020 13:07:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 305AE42061;
        Thu, 16 Jan 2020 13:07:14 +0000 (GMT)
Received: from dyn-9-152-224-123.boeblingen.de.ibm.com (unknown [9.152.224.123])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jan 2020 13:07:14 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/7] s390x: smp: Test all CRs on initial
 reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, cohuck@redhat.com
References: <20200116120513.2244-1-frankja@linux.ibm.com>
 <20200116120513.2244-7-frankja@linux.ibm.com>
 <7e85ec92-4d0a-f673-00c8-a9ab9a22118c@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 16 Jan 2020 14:07:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7e85ec92-4d0a-f673-00c8-a9ab9a22118c@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8XDH7mI6QSSZ8DwtB4XqTYuIGbQIVRJnp"
X-TM-AS-GCONF: 00
x-cbid: 20011613-0028-0000-0000-000003D19B4C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011613-0029-0000-0000-00002495C393
Message-Id: <400dc0d2-86bc-cdc8-ec8a-7d1148ebd5fa@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 phishscore=0 suspectscore=3 adultscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8XDH7mI6QSSZ8DwtB4XqTYuIGbQIVRJnp
Content-Type: multipart/mixed; boundary="7coQ9ksdeHYirCVdNkLo49dtMkX2UHpIj"

--7coQ9ksdeHYirCVdNkLo49dtMkX2UHpIj
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/16/20 1:24 PM, David Hildenbrand wrote:
> On 16.01.20 13:05, Janosch Frank wrote:
>> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
>> so we also need to test 1-13 and 15 for 0.
>>
>> And while we're at it, let's also set some values to cr 1, 7 and 13, s=
o
>> we can actually be sure that they will be zeroed.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/smp.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index d430638..ce3215d 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -176,16 +176,31 @@ static void test_emcall(void)
>>  	report_prefix_pop();
>>  }
>> =20
>> +/* Used to dirty registers of cpu #1 before it is reset */
>> +static void test_func_initial(void)
>> +{
>> +	lctlg(1, 0x42000UL);
>> +	lctlg(7, 0x43000UL);
>> +	lctlg(13, 0x44000UL);
>> +	testflag =3D 1;
>> +	mb();
>> +	cpu_loop();
>=20
> Can we make cpu_loop() the default when this function returns? (IOW, an=

> endless loop whenever a cpu finished executing the function?)

So adding it to cstart64.S after the br 14?

>=20
> Do we need the mb() here?

Would the compiler reorder the lctlcg and testflag if it could?

>=20
>> +}
>> +
>>  static void test_reset_initial(void)
>>  {
>>  	struct cpu_status *status =3D alloc_pages(0);
>> +	uint64_t nullp[12] =3D {};
>>  	struct psw psw;
>> =20
>>  	psw.mask =3D extract_psw_mask();
>> -	psw.addr =3D (unsigned long)test_func;
>> +	psw.addr =3D (unsigned long)test_func_initial;
>> =20
>>  	report_prefix_push("reset initial");
>> +	testflag =3D 0;
>> +	mb();
>>  	smp_cpu_start(1, psw);
>> +	wait_for_flag();
>> =20
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> @@ -196,6 +211,8 @@ static void test_reset_initial(void)
>>  	report(!status->fpc, "fpc");
>>  	report(!status->cputm, "cpu timer");
>>  	report(!status->todpr, "todpr");
>> +	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12),=
 "cr1-13 =3D=3D 0");
>> +	report(status->crs[15] =3D=3D 0, "cr15 =3D=3D 0");
>>  	report_prefix_pop();
>> =20
>>  	report_prefix_push("initialized");
>>
>=20
>=20



--7coQ9ksdeHYirCVdNkLo49dtMkX2UHpIj--

--8XDH7mI6QSSZ8DwtB4XqTYuIGbQIVRJnp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4gYAEACgkQ41TmuOI4
ufjcixAArqxzA6JhVk4CN7MukoAuAi/NpK9BWYY3Y1jDMkK9kWlOYxpKUIPD8JX4
vbjrtUjYh6PSdJad6WRf+GJc6Uzw2wJP3v45DS/RfMpVSQN13/IoZPh4pK3/bm7L
YgSJf1+QHFwyPeTCAPLnRwG0Xm9ogDwC3mkzmMef0XzrY04hw7MgRFD+WQhjYAW1
8sC+hmaUtnjZ1PCJi9SEPxTd02JmRemXoei2M0KX4bqzP4VN2TYNxZDDWnlUFb/K
QnPMCzr27pnNYTYOq7sw6NouU4ZXEDzcWPwx6dzXx/amrMbTCUDsiPMlC/KkyN9S
lQHLmsmHDHezRdlIbnf64GSweI+BwlIzKgI6iXbFkCid/1Plz1RMjLmxiZ3KOxsK
IB/Sd5NpEh+oBXqH4nqyLXa+MDhQNfp6Ae4c9JewhlwJP0P1Ygouzbj+QvZm4TOY
4FvYiPVNq63KdTYdZCnAKz18PtBoGzEROZ/AqtPVWCDJX8hVHb8z7TWvsRDAFpbO
GjFvDKmZ7Uzd1XryFjMKJPZC452tGR6/PWU0iD4Dqs59G0m+LdoHTsKpk+GsDLgg
8/G/iWOu/TQU4D1ysbZrkWhtLVAvTxufLBJm+3luAwcR9fsm1PnOJfaLoBkxGgvt
aoY5YP3SOSSGqbKXGEmF3QyC2lbW9mPQqEy/0d5tHs2wIsLI9RU=
=84BG
-----END PGP SIGNATURE-----

--8XDH7mI6QSSZ8DwtB4XqTYuIGbQIVRJnp--

