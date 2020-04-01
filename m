Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A405019A62A
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbgDAHUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 03:20:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732059AbgDAHUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 03:20:03 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031739wF141258
        for <kvm@vger.kernel.org>; Wed, 1 Apr 2020 03:20:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303wrx16r9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 03:20:01 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 1 Apr 2020 08:19:49 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 08:19:46 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0317JuAu54001784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 07:19:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3174342045;
        Wed,  1 Apr 2020 07:19:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9ACE42042;
        Wed,  1 Apr 2020 07:19:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.149.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 07:19:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 04/10] s390x: smp: Test local interrupts
 after cpu reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org
References: <20200324081251.28810-1-frankja@linux.ibm.com>
 <20200324081251.28810-5-frankja@linux.ibm.com>
 <b6f1d06b-aaa5-bdd5-5491-32c8338f9ead@redhat.com>
 <126883fa-6c1e-a1e3-34f0-689cd2c0b7c4@linux.ibm.com>
 <3631ad95-6920-1089-6e87-8687c9f100b6@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 1 Apr 2020 09:19:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3631ad95-6920-1089-6e87-8687c9f100b6@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vkJC8xElT4Mmm5cGMn7V5xz2B3fUqL2PA"
X-TM-AS-GCONF: 00
x-cbid: 20040107-0008-0000-0000-0000036850C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040107-0009-0000-0000-00004A89D7F9
Message-Id: <9c11caa4-04ff-7cc9-8f62-371d2d200048@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vkJC8xElT4Mmm5cGMn7V5xz2B3fUqL2PA
Content-Type: multipart/mixed; boundary="61YDvkVaaaKDiIBR2yHRg4Skc4mSea2kn"

--61YDvkVaaaKDiIBR2yHRg4Skc4mSea2kn
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/31/20 7:27 PM, David Hildenbrand wrote:
> On 31.03.20 11:28, Janosch Frank wrote:
>> On 3/31/20 11:07 AM, David Hildenbrand wrote:
>>> On 24.03.20 09:12, Janosch Frank wrote:
>>>> Local interrupts (external and emergency call) should be cleared aft=
er
>>>> any cpu reset.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  s390x/smp.c | 22 ++++++++++++++++++++++
>>>>  1 file changed, 22 insertions(+)
>>>>
>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>> index 8a6cd1d8b17d76c6..a8e3dd7aac0c788c 100644
>>>> --- a/s390x/smp.c
>>>> +++ b/s390x/smp.c
>>>> @@ -243,6 +243,20 @@ static void test_reset_initial(void)
>>>>  	report_prefix_pop();
>>>>  }
>>>> =20
>>>> +static void test_local_ints(void)
>>>> +{
>>>> +	unsigned long mask;
>>>> +
>>>> +	expect_ext_int();
>>>> +	/* Open masks for ecall and emcall */
>>>> +	ctl_set_bit(0, 13);
>>>> +	ctl_set_bit(0, 14);
>>>> +	mask =3D extract_psw_mask();
>>>> +	mask |=3D PSW_MASK_EXT;
>>>> +	load_psw_mask(mask);
>>>> +	set_flag(1);
>>>> +}
>>>> +
>>>>  static void test_reset(void)
>>>>  {
>>>>  	struct psw psw;
>>>> @@ -251,10 +265,18 @@ static void test_reset(void)
>>>>  	psw.addr =3D (unsigned long)test_func;
>>>> =20
>>>>  	report_prefix_push("cpu reset");
>>>> +	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>>>> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>>>>  	smp_cpu_start(1, psw);
>>>> =20
>>>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>>>  	report(smp_cpu_stopped(1), "cpu stopped");
>>>> +
>>>> +	set_flag(0);
>>>> +	psw.addr =3D (unsigned long)test_local_ints;
>>>> +	smp_cpu_start(1, psw);
>>>> +	wait_for_flag();
>>>> +	report(true, "local interrupts cleared");
>>>
>>>
>>> How can you be sure they were actually cleared/delivered?
>>>
>> Because cpu 1 would get a ext int it didn't expect and would do a
>> report_abort() as pecified in lib/s390x/interrupt.c
>=20
> But what if it *didn't* get the interrupts delivered.

Well, the target is still looping until the reset initial test is
executed and from personal experience I can say that this test bites
rather fast.

We could execute an instruction with a mandatory exit which will prompt
KVM to inject any remaining IRQs before setting the flag to 1.

Unfortunately we do not have a polling instruction for non-IO interrupts
at the moment to verify this test.

>=20
> Then cpu 1 will simply (test_local_ints()) unlock interrupts, load the
> psw mask, set the flag and be done with it. What am I missing? How can
> you be sure the interrupts on cpu 1 were actually delivered?
>


--61YDvkVaaaKDiIBR2yHRg4Skc4mSea2kn--

--vkJC8xElT4Mmm5cGMn7V5xz2B3fUqL2PA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6EQJsACgkQ41TmuOI4
ufiTRBAAuzGx7dNmrudZWnWZc+cruG5A8mUhao6pZRuPeDowoqAo0o2GEyocu02r
ILtR9fWfP+Q4aCahFa8s9taGRNAaYGwaGmDkRfORP1WqmuPEwFxYVtXGh+HhjTMQ
LLcAnkmSWEIZNDPCLxcDv5cBK7+KRipgt11YYEoEiv2Ei19OoVfnODFXX79NT1S2
ku4Cw++WT2ZAvtAdeK0143XrnTx5LEgm3CffJDUk7LMVBwGQ+9TSq8DwNdG1K7BS
XNSBJIZTkX94kysFYjs99/Yn30G0zUliIAtPZtV3cn8vv9uQl5zJd9iUwk85y4lG
zBIQNTyz8CcQU7w9ZSD8UetoEAyMvQ2DVmqwTESjTPdOfoRuZIT9k4tL1Mq8X9BM
6aRda/CqeNC97N9w7Q7KWxjvwa/Qsx1UAeCCtbtHLZAvDfYZetMEMPLjYOjE5EmZ
0vY0eaWC23TaTkBnqv7gUa5kaLiJZKyM8P9HEsdOSwPbR5/yNqsuFva+DmiOUJuT
6a/4mI0GSuhV8W/eyeLxyHf9glAE9T7dzS1+CbZSQSH2HkKYE9QpybyblPgLJ/Y2
1k6LclfXbzV4Dfvz92zFpo5wdikMZDQFPzq2WCaJzkdANrlO73VAAuUY69KcjhbI
vXnlAKu4FByH3uYZP4BkbrgMXE7nKZqP3la24VTpc16rLCor3qU=
=dgVV
-----END PGP SIGNATURE-----

--vkJC8xElT4Mmm5cGMn7V5xz2B3fUqL2PA--

