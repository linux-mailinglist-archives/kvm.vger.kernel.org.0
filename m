Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338951B7373
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgDXLvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:51:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbgDXLvw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 07:51:52 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OBXq58059420;
        Fri, 24 Apr 2020 07:51:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrj7wpse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 07:51:51 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OBa59Y067085;
        Fri, 24 Apr 2020 07:51:50 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrj7wps3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 07:51:50 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OBnqad026626;
        Fri, 24 Apr 2020 11:51:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 30fs65gy95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 11:51:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OBpkAO27197636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 11:51:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B146A4055;
        Fri, 24 Apr 2020 11:51:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35C14A4051;
        Fri, 24 Apr 2020 11:51:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.157.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 11:51:46 +0000 (GMT)
Subject: Re: [PATCH v2 04/10] s390x: smp: Test local interrupts after cpu
 reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com
References: <20200423091013.11587-1-frankja@linux.ibm.com>
 <20200423091013.11587-5-frankja@linux.ibm.com>
 <8bdbe934-fff9-cc2a-3043-4851365735f3@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c92a928a-aa94-38b6-f8af-d0bf28e368fd@linux.ibm.com>
Date:   Fri, 24 Apr 2020 13:51:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8bdbe934-fff9-cc2a-3043-4851365735f3@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aOrwj5xvk38smJvn6YESLUkGSJZgLIb52"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_04:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aOrwj5xvk38smJvn6YESLUkGSJZgLIb52
Content-Type: multipart/mixed; boundary="lZfKXrBz9XIErdMhMDpoUgWKD9h2NyaY3"

--lZfKXrBz9XIErdMhMDpoUgWKD9h2NyaY3
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/24/20 12:07 PM, David Hildenbrand wrote:
> On 23.04.20 11:10, Janosch Frank wrote:
>> Local interrupts (external and emergency call) should be cleared after=

>> any cpu reset.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  s390x/smp.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index 8a6cd1d..a8e3dd7 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -243,6 +243,20 @@ static void test_reset_initial(void)
>>  	report_prefix_pop();
>>  }
>> =20
>> +static void test_local_ints(void)
>> +{
>> +	unsigned long mask;
>> +
>> +	expect_ext_int();
>> +	/* Open masks for ecall and emcall */
>> +	ctl_set_bit(0, 13);
>> +	ctl_set_bit(0, 14);
>> +	mask =3D extract_psw_mask();
>> +	mask |=3D PSW_MASK_EXT;
>> +	load_psw_mask(mask);
>> +	set_flag(1);
>> +}
>=20
> I think last time I looked at this I got it all wrong. So, we actually
> don't expect that an interrupt triggers here, correct?

Correct

>=20
> The SIGP_CPU_RESET should have cleared both interrupts on this cpu. So
> once we enable them, none should trigger.

Yes

>=20
> Why do we have "expect_ext_int()" ?

Excellent question, that should not be there.
Fortunately removing it doesn't change the test results.

>=20
>> +
>>  static void test_reset(void)
>>  {
>>  	struct psw psw;
>> @@ -251,10 +265,18 @@ static void test_reset(void)
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>>  	report_prefix_push("cpu reset");
>> +	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>>  	smp_cpu_start(1, psw);
>> =20
>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>  	report(smp_cpu_stopped(1), "cpu stopped");
>> +
>> +	set_flag(0);
>> +	psw.addr =3D (unsigned long)test_local_ints;
>> +	smp_cpu_start(1, psw);
>> +	wait_for_flag();
>> +	report(true, "local interrupts cleared");
>>  	report_prefix_pop();
>>  }
>> =20
>>
>=20
>=20



--lZfKXrBz9XIErdMhMDpoUgWKD9h2NyaY3--

--aOrwj5xvk38smJvn6YESLUkGSJZgLIb52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6i0tEACgkQ41TmuOI4
ufj4EA//aXAKunI1QR4Ntu+FV3GAd2rgU8RBpTd1kDK/MvbYUykdg7tW4VYjvRAG
eO7fiYX92s+ARdvlU4hc5LMfdcMi1ftxotKnq83DP450ZqbBZcrzkYL3IcXqLnl0
rmUs4gihMloe9Yan7qY+F/Etemoaa0aqBCXikK1q3Gnmm/UG2QkfNTr8cWAnn0M7
UUxxpt9zbMGJ8yyAdSC7Da9t4+95nFfd3avnNokTjh7LIaZY6cTaN+oPwSVvHMqh
TqsrgLRsylABJoGkwTZNVUtlV9pPk/lBuxZUsDvekCOdxvG2899s85jAvnXn+ylP
n0TyqA4hsRLV9K0uINXBnibUQnR5hYdOoE3sieBkUGncrJBwoRRavR6N3u+5d2e8
CGbcr0kYGi4ObPFpbF3v0kXUfnFWpglb0YZ4PIyiMGh9NXBjOEOfxq1l8uBUSwEn
FtSWmEzU9Vid2le/V3pZL4VVRDzqU7jIX+59hZCriQRU3meObX5APv9JbpItFw0d
X8v4hKybMV82nBtSYsAp8349ukskupj9p6wS9nHCcpk4wNk6LwG+9TubYj5yURLz
qq6s/eEMJwqcbrRP484TDyyinUVjz0shh77PIXGT/R6iE+2/2ET7C3uL3babPhEL
9ylVZ6Bt4uemlFw1iyL3cjKffRz9nF4u66ECc3/1brunw+9qTFk=
=f38m
-----END PGP SIGNATURE-----

--aOrwj5xvk38smJvn6YESLUkGSJZgLIb52--

