Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED2D9AE31
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392770AbfHWLeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:34:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388767AbfHWLeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Aug 2019 07:34:06 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7NBWTNC083511
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 07:34:05 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uje6vthmc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 07:34:04 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 23 Aug 2019 12:34:02 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 12:33:59 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7NBXx2q59834594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 11:33:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E917DA405B;
        Fri, 23 Aug 2019 11:33:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B605A4054;
        Fri, 23 Aug 2019 11:33:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.28.218])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 11:33:58 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190822111100.4444-1-frankja@linux.ibm.com>
 <34c8d077-fc5e-1d62-f946-17d067573c23@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 23 Aug 2019 13:33:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <34c8d077-fc5e-1d62-f946-17d067573c23@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5RQrRxo71WalowrG9pGdPdjB84oxhSWVk"
X-TM-AS-GCONF: 00
x-cbid: 19082311-0008-0000-0000-0000030C7EAE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082311-0009-0000-0000-00004A2AB0ED
Message-Id: <72f07777-0f11-5cbe-da37-ace2ddfce78c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5RQrRxo71WalowrG9pGdPdjB84oxhSWVk
Content-Type: multipart/mixed; boundary="Mk9dvYBknQupxKytoulKQVenyIsb7ew6i";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <72f07777-0f11-5cbe-da37-ace2ddfce78c@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190822111100.4444-1-frankja@linux.ibm.com>
 <34c8d077-fc5e-1d62-f946-17d067573c23@redhat.com>
In-Reply-To: <34c8d077-fc5e-1d62-f946-17d067573c23@redhat.com>

--Mk9dvYBknQupxKytoulKQVenyIsb7ew6i
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/23/19 1:00 PM, David Hildenbrand wrote:
> On 22.08.19 13:11, Janosch Frank wrote:
>> By adding a load reset routine to cstart.S we can also test the clear
>> reset done by subcode 0, as we now can restore our registers again.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>> I managed to extract this from another bigger test, so let's add it to=
 the bunch.
>> I'd be very happy about assembly review :-)
>> ---
>>  s390x/cstart64.S | 27 +++++++++++++++++++++++++++
>>  s390x/diag308.c  | 31 ++++++++++---------------------
>>  2 files changed, 37 insertions(+), 21 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index dedfe80..47045e1 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -145,6 +145,33 @@ memsetxc:
>>  	.endm
>> =20
>>  .section .text
>> +/*
>> + * load_reset calling convention:
>> + * %r2 subcode (0 or 1)
>> + */
>> +.globl load_reset
>> +load_reset:
>> +	SAVE_REGS
>> +	/* Save the first PSW word to the IPL PSW */
>> +	epsw	%r0, %r1
>> +	st	%r0, 0
>> +	/* Store the address and the bit for 31 bit addressing */
>> +	larl    %r0, 0f
>> +	oilh    %r0, 0x8000
>> +	st      %r0, 0x4
>> +	/* Do the reset */
>> +	diag    %r0,%r2,0x308
>> +	/* Failure path */
>> +	xgr	%r2, %r2
>> +	br	%r14
>> +	/* Success path */
>> +	/* We lost cr0 due to the reset */
>> +0:	larl	%r1, initial_cr0
>> +	lctlg	%c0, %c0, 0(%r1)
>> +	RESTORE_REGS
>> +	lhi	%r2, 1
>> +	br	%r14
>> +
>>  pgm_int:
>>  	SAVE_REGS
>>  	brasl	%r14, handle_pgm_int
>> diff --git a/s390x/diag308.c b/s390x/diag308.c
>> index f085b1a..baf9fd3 100644
>> --- a/s390x/diag308.c
>> +++ b/s390x/diag308.c
>> @@ -21,32 +21,20 @@ static void test_priv(void)
>>  	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>>  }
>> =20
>> +
>>  /*
>> - * Check that diag308 with subcode 1 loads the PSW at address 0, i.e.=

>> + * Check that diag308 with subcode 0 and 1 loads the PSW at address 0=
, i.e.
>>   * that we can put a pointer into address 4 which then gets executed.=

>>   */
>> +extern int load_reset(u64);
>> +static void test_subcode0(void)
>> +{
>> +	report("load modified clear done", load_reset(0));
>> +}
>> +
>>  static void test_subcode1(void)
>>  {
>> -	uint64_t saved_psw =3D *(uint64_t *)0;
>> -	long subcode =3D 1;
>> -	long ret, tmp;
>> -
>> -	asm volatile (
>> -		"	epsw	%0,%1\n"
>> -		"	st	%0,0\n"
>> -		"	larl	%0,0f\n"
>> -		"	oilh	%0,0x8000\n"
>> -		"	st	%0,4\n"
>> -		"	diag	0,%2,0x308\n"
>> -		"	lghi	%0,0\n"
>> -		"	j	1f\n"
>> -		"0:	lghi	%0,1\n"
>> -		"1:"
>> -		: "=3D&d"(ret), "=3D&d"(tmp) : "d"(subcode) : "memory");
>> -
>> -	*(uint64_t *)0 =3D saved_psw;
>> -
>> -	report("load normal reset done", ret =3D=3D 1);
>> +	report("load normal reset done", load_reset(1));
>>  }
>> =20
>>  /* Expect a specification exception when using an uneven register */
>> @@ -107,6 +95,7 @@ static struct {
>>  	void (*func)(void);
>>  } tests[] =3D {
>>  	{ "privileged", test_priv },
>> +	{ "subcode 0", test_subcode0 },
>>  	{ "subcode 1", test_subcode1 },
>>  	{ "subcode 5", test_subcode5 },
>>  	{ "subcode 6", test_subcode6 },
>>
>=20
> So, in general I am wondering if we should restore the original IPL_PSW=

> after we used it - is there any chance we might require the old value
> again (I guess we're fine with cpu resets)?

I currently don't see a need, but we could cache it in the restart old
psw address. Or we just store back the two word constant.



--Mk9dvYBknQupxKytoulKQVenyIsb7ew6i--

--5RQrRxo71WalowrG9pGdPdjB84oxhSWVk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1fzyYACgkQ41TmuOI4
ufgDCw//em1tMQ2mHvWcoJ9KG/5zapv6Vbc5KDFjSmloVpJIpwGSwmBV6sxgOCm/
Kq0feZKJd1+wPR6T4/F9BeLeDxbFwwd8NdpyeAADgjFHv7ivfq1nNZu0RY19ExGd
28dZ88AzhuwPuiHyf4FNdzB6KKlx6Dqs9Hzzg9Nx2rYNqvCpeFeDMwgwgahqm6vI
sZESiE0aK4k7eXiiZ6X+OyFNBZZhumKUo0s0eHinybISplzALEStb09an20CqeE/
7+6Ww2P3+pZT08gfp22EyCqw5VyZiE20cZz+s/38Qe5Pa6gQYsQosWBop9vDDoLa
kJEXvEPMu94SgDAFJKz14UAGOrHewuIdwR7ANk3yLPPIbH55i2wDlZwwxkrM/InI
9sBH6fONugyDAiBBVSiZquXUP4dnyPZSu9A1ssI601jceGzrBAgWGI5K4ZP3yQtM
UoZC0qIn60IstWZrZjp0+nW6tInpLUsUcmOc8tW81QZCnn6mt2nXOJO/IajWUhhJ
VYRxYq2MPAjMM1SlCPlOZmNc1Re006RsALTsYRcziyO3q70laZ5od1qdwALuCOiZ
5O8vVGl7Ar1uaHDrIw89jqP6zs78LyCKkliyGA4EdAIubCDSvxg52zkxMbvqy4SI
g6dCyFomHWVpuXh6RNQJzm+feq8H1gxRZ/J+Xm68i0kddHO/VpM=
=ChDn
-----END PGP SIGNATURE-----

--5RQrRxo71WalowrG9pGdPdjB84oxhSWVk--

