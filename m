Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F022AEF5
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgGWMX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:23:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15418 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728180AbgGWMX4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 08:23:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NC28uA142532;
        Thu, 23 Jul 2020 08:23:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32f1pped66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 08:23:54 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06NC3Abr146699;
        Thu, 23 Jul 2020 08:23:54 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32f1pped58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 08:23:53 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NCBLo6006288;
        Thu, 23 Jul 2020 12:23:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 32brbgu8et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 12:23:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NCMPpX52822484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 12:22:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C067A4051;
        Thu, 23 Jul 2020 12:23:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1506A4040;
        Thu, 23 Jul 2020 12:23:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.184.48])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 12:23:48 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add custom pgm cleanup function
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-2-frankja@linux.ibm.com>
 <20200723140112.6525ddba.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8a7c9e38-8d92-0353-b883-368c2dcdec04@linux.ibm.com>
Date:   Thu, 23 Jul 2020 14:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200723140112.6525ddba.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HahkwqycjwN8Ar8ZBVPAAf2ELi3zUYIBA"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_03:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HahkwqycjwN8Ar8ZBVPAAf2ELi3zUYIBA
Content-Type: multipart/mixed; boundary="BnezAcZawUheR1KIft8DXVrTK6A3niqU4"

--BnezAcZawUheR1KIft8DXVrTK6A3niqU4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/23/20 2:01 PM, Cornelia Huck wrote:
> On Fri, 17 Jul 2020 10:58:11 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Sometimes we need to do cleanup which we don't necessarily want to add=

>> to interrupt.c, so lets add a way to register a cleanup function.
>=20
> s/lets/let's/ :)
>=20
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/interrupt.h | 1 +
>>  lib/s390x/interrupt.c     | 9 +++++++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
>> index 4cfade9..b2a7c83 100644
>> --- a/lib/s390x/asm/interrupt.h
>> +++ b/lib/s390x/asm/interrupt.h
>> @@ -15,6 +15,7 @@
>>  #define EXT_IRQ_EXTERNAL_CALL	0x1202
>>  #define EXT_IRQ_SERVICE_SIG	0x2401
>> =20
>> +void register_pgm_int_func(void (*f)(void));
>>  void handle_pgm_int(void);
>>  void handle_ext_int(void);
>>  void handle_mcck_int(void);
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 243b9c2..36ba720 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -16,6 +16,7 @@
>> =20
>>  static bool pgm_int_expected;
>>  static bool ext_int_expected;
>> +static void (*pgm_int_func)(void);
>>  static struct lowcore *lc;
>> =20
>>  void expect_pgm_int(void)
>> @@ -51,8 +52,16 @@ void check_pgm_int_code(uint16_t code)
>>  	       lc->pgm_int_code);
>>  }
>> =20
>> +void register_pgm_int_func(void (*f)(void))
>> +{
>> +	pgm_int_func =3D f;
>> +}
>> +
>>  static void fixup_pgm_int(void)
>>  {
>> +	if (pgm_int_func)
>> +		return (*pgm_int_func)();
>> +
>=20
> Maybe rather call this function, if set, instead of fixup_pgm_int() in
> handle_pgm_int()? Feels a bit cleaner to me.

Well it's currently a cleanup function so it should be in
fixup_pgm_int() because it fixes up.

I don't need a handler here like Pierre with his IO changes.

So it might more sense to change the name of the function ptr and
registration function:

register_pgm_cleanup_func()
static void (*pgm_cleanup_func)(void);

> 	=09
>>  	switch (lc->pgm_int_code) {
>>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>>  		/* Normal operation is in supervisor state, so this exception
>=20



--BnezAcZawUheR1KIft8DXVrTK6A3niqU4--

--HahkwqycjwN8Ar8ZBVPAAf2ELi3zUYIBA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8ZgVQACgkQ41TmuOI4
ufjirRAAvFdeOdRL18jIQlAnvHPn5MMxrdB1IZojjCr77KU9BW0ZOFCYdBM3toJY
fYz/i4NUcGOOG5hH5Y4YErb6JofDb4fSf+740vdvJHYyoaYL1+McuM/fDMMrhMDB
yiYsWdO7+xF4r3q0X7INAnyhwEcaWdhqhULTBSSMe+whgKUTz8CC6Cavuj2sYvoO
PsbHOA2krAA8HrckJbieNZ0UZ5aOU/N3uhUAYwePKZn7KCuS7Rezhpv9FvcumVTo
B5glnQuV5dKXuR8cTxTicGZWQE441F12+hcGtRArAm+UAJVA4DYsvNfuYBzVexTa
v9zOKBdBojBu5+5tu0IgmXbBUDM6RUHknCMcFxMFILEsZmxI811m0hSkcsvPtp7v
eF3vZJ2YvOSEA1vaHEywQSf70bSxq7OvrcORoEoFGR1J3ruAB8f8JJ5yrytpBxnf
lsOndJuIGWau6kMLLuWaWwrpHoC4wk9dcrBOzGT/fh5l5EiLP437sBhyEmIDFmPY
kRqKr3otMFNKKBsXxmbJWUR9Sq7oXXAfBH7EJ9s/pgeziBPZ6Kk1yZiHkO+2eRCM
qnhgo1azNTXhKCCNflO9D6IzNJjbe0lUWEKbaAahGIiWP7OdLmgEqg/QGXVeyQYH
OdzbivggKt3iVn20r0fg/1e9fm4PFxIzziaj6ybpzXzQdDDoY68=
=Zdds
-----END PGP SIGNATURE-----

--HahkwqycjwN8Ar8ZBVPAAf2ELi3zUYIBA--

