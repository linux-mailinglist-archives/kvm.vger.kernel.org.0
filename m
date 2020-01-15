Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E914813BA7C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 08:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAOHu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 02:50:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgAOHu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 02:50:28 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F7gTTv020176
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 02:50:27 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xhbprvpn7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 02:50:26 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 15 Jan 2020 07:50:25 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Jan 2020 07:50:23 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00F7oME150790576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 07:50:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DC435204E;
        Wed, 15 Jan 2020 07:50:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.31.155])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BEE4952051;
        Wed, 15 Jan 2020 07:50:21 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: smp: Only use smp_cpu_setup
 once
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-3-frankja@linux.ibm.com>
 <9db91398-0371-cd4a-9758-a185b74467a0@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 15 Jan 2020 08:50:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9db91398-0371-cd4a-9758-a185b74467a0@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="97w2nfovMSVWyv80OK2EJ22C0b2QWNq3E"
X-TM-AS-GCONF: 00
x-cbid: 20011507-0028-0000-0000-000003D130B0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011507-0029-0000-0000-0000249554A1
Message-Id: <5c880248-bd35-a5f8-0526-80defc5864e5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--97w2nfovMSVWyv80OK2EJ22C0b2QWNq3E
Content-Type: multipart/mixed; boundary="kudNxptmPkuI8tcyCsnTcY4cP4belrBle"

--kudNxptmPkuI8tcyCsnTcY4cP4belrBle
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/14/20 5:45 PM, Thomas Huth wrote:
> On 14/01/2020 16.30, Janosch Frank wrote:
>> Let's stop and start instead of using setup to run a function on a
>> cpu.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/smp.c | 19 ++++++++++++-------
>>  1 file changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index 4dee43e..767d167 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -47,7 +47,7 @@ static void test_start(void)
>>  	psw.mask =3D extract_psw_mask();
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	report(1, "start");
>>  }
>> @@ -131,9 +131,8 @@ static void test_ecall(void)
>> =20
>>  	report_prefix_push("ecall");
>>  	testflag =3D 0;
>> -	smp_cpu_destroy(1);
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	testflag =3D 0;
>>  	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>> @@ -166,9 +165,8 @@ static void test_emcall(void)
>> =20
>>  	report_prefix_push("emcall");
>>  	testflag =3D 0;
>> -	smp_cpu_destroy(1);
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	testflag =3D 0;
>>  	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>> @@ -186,7 +184,7 @@ static void test_reset_initial(void)
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>>  	report_prefix_push("reset initial");
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>> =20
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> @@ -217,7 +215,7 @@ static void test_reset(void)
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>>  	report_prefix_push("cpu reset");
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>=20
> I think this also fixes a memory leak in case the code did not call
> smp_cpu_destroy() inbetween (since smp_cpu_setup() allocates new memory=

> for the low-core). So as far as I can see, this is a good idea:

Well, if the cpu is active, we should just return in the setup function.
But I have another patch in the queue which cleans up lowcore allocation.=


>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20



--kudNxptmPkuI8tcyCsnTcY4cP4belrBle--

--97w2nfovMSVWyv80OK2EJ22C0b2QWNq3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4exD0ACgkQ41TmuOI4
ufgCOw//eZPLhJYGZ0W9au+moydeJ710NZT8ZL21dhQAeZGDUUBWQzUM3UnupULU
ycMqgoj2clqm3VKSNsM5EkwVaBicmCq4OUD/phCp4hY7G657fgLhUvkWyH1EeVUH
cDovPHFvc9zSqfLaskT01E+59mNmczl99gjrFxBJjYp6aRLHKoC5KGB2ti7eiwya
oNhaUJk3XKzvgBNRx2IS6OjSV6du1zAMsKKn0ly1Dze+evQoBm4+w6Hwv/pXMTxw
8MghDk5Op+uvEYuQL3mCERlyXh7IMYT+0JCb0+WHTDYzPTASijTUfg8OrVJHMGR3
NZj+O0t+CzxsHbgFtrR53IUqrBMeovW6ZYn6l++vKEvFBOQ2/HH7R/Uj/BCR+XTY
jXK9pvESisLNr6u6Yzt9Xuf86eeW5TzcWlXpkM0AjRa8Ee1Pj1YSDNPQT0kQad1R
edfdoPLjEa97YF6IYrLfOmQ9S89j9ZenWmH/fTXuazX67wNz1fJ+YePUcOhWBPeV
ohErsl3ALrzp2lHT6ZkEov9GLhGilwFLyrNs5weXztI2hoopib7BYoD5yDwYl6yH
MaPP8piOTAg7yeEnAz4Ys2yY4ml52jJljwzi9dvYbjr2h/C3Got55OQYSZbg/44h
9xMJSosXp9ZTwbrBmJl2miwpJInUtYFEP3YG7FvNOXLaPRUGSLk=
=n5ay
-----END PGP SIGNATURE-----

--97w2nfovMSVWyv80OK2EJ22C0b2QWNq3E--

