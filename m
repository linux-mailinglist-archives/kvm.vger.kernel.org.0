Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECA143DA9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgAUNIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:08:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgAUNID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:08:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LD2fYe123206
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:08:03 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xmg5tdu7r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:08:02 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 21 Jan 2020 13:08:00 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Jan 2020 13:07:57 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00LD7uFT44957718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 13:07:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0134C11C052;
        Tue, 21 Jan 2020 13:07:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C779A11C06F;
        Tue, 21 Jan 2020 13:07:55 +0000 (GMT)
Received: from dyn-9-152-224-211.boeblingen.de.ibm.com (unknown [9.152.224.211])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jan 2020 13:07:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: smp: Remove unneeded cpu
 loops
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200117104640.1983-1-frankja@linux.ibm.com>
 <20200117104640.1983-8-frankja@linux.ibm.com>
 <20200120122956.6879d159.cohuck@redhat.com>
 <97f7f794-e0be-3984-99b2-ba229212fd3e@linux.ibm.com>
 <20200120171113.02a9b807.cohuck@redhat.com>
 <f0f17e60-29b6-12b1-6692-5da745cbe60a@linux.ibm.com>
 <20200121135911.4d41c418.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 21 Jan 2020 14:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200121135911.4d41c418.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bCmHwAiM1FvN6J4364I56N1i753EkjL6r"
X-TM-AS-GCONF: 00
x-cbid: 20012113-0028-0000-0000-000003D31798
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012113-0029-0000-0000-000024974C57
Message-Id: <9236567e-f70a-1e0b-6582-150ec83f9604@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-21_04:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 suspectscore=3 bulkscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bCmHwAiM1FvN6J4364I56N1i753EkjL6r
Content-Type: multipart/mixed; boundary="92Hi3je3Cq1vBcrlMeshqfdBRVnBqtOZD"

--92Hi3je3Cq1vBcrlMeshqfdBRVnBqtOZD
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/21/20 1:59 PM, Cornelia Huck wrote:
> On Tue, 21 Jan 2020 13:46:51 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 1/20/20 5:11 PM, Cornelia Huck wrote:
>>> On Mon, 20 Jan 2020 15:41:52 +0100
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>  =20
>>>> On 1/20/20 12:29 PM, Cornelia Huck wrote: =20
>>>>> On Fri, 17 Jan 2020 05:46:38 -0500
>>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>>>    =20
>>>>>> Now that we have a loop which is executed after we return from the=

>>>>>> main function of a secondary cpu, we can remove the surplus loops.=

>>>>>>
>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>> ---
>>>>>>  s390x/smp.c | 8 +-------
>>>>>>  1 file changed, 1 insertion(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>>>> index 555ed72..c12a3db 100644
>>>>>> --- a/s390x/smp.c
>>>>>> +++ b/s390x/smp.c
>>>>>> @@ -29,15 +29,9 @@ static void wait_for_flag(void)
>>>>>>  	}
>>>>>>  }
>>>>>> =20
>>>>>> -static void cpu_loop(void)
>>>>>> -{
>>>>>> -	for (;;) {}
>>>>>> -}
>>>>>> -
>>>>>>  static void test_func(void)
>>>>>>  {
>>>>>>  	testflag =3D 1;
>>>>>> -	cpu_loop();
>>>>>>  }
>>>>>> =20
>>>>>>  static void test_start(void)
>>>>>> @@ -234,7 +228,7 @@ int main(void)
>>>>>> =20
>>>>>>  	/* Setting up the cpu to give it a stack and lowcore */
>>>>>>  	psw.mask =3D extract_psw_mask();
>>>>>> -	psw.addr =3D (unsigned long)cpu_loop;
>>>>>> +	psw.addr =3D (unsigned long)test_func;   =20
>>>>>
>>>>> Before, you did not set testflag here... intended change?   =20
>>>>
>>>> Yes
>>>> It is set to 0 before the first test, so it shouldn't matter. =20
>>>
>>> Hm... I got a bit lost in all those changes, so I checked your branch=

>>> on github, and I don't see it being set to 0 before test_start() is
>>> called? =20
>>
>> Well, that's because test_start doesn't care about the flag.
>=20
> But I see a wait_for_flag() in there? What am I missing?
>=20
>> ecall and emcall are the first users, and they set it to 0 before usin=
g it.

Well, cpu #1 will update tesflag to 1 in ecall() and emcall()

>>
>>>  =20
>>>> =20
>>>>>    =20
>>>>>>  	smp_cpu_setup(1, psw);
>>>>>>  	smp_cpu_stop(1);
>>>>>>     =20
>>>>>    =20
>>>>
>>>> =20
>>>  =20
>>
>>
>=20



--92Hi3je3Cq1vBcrlMeshqfdBRVnBqtOZD--

--bCmHwAiM1FvN6J4364I56N1i753EkjL6r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4m96sACgkQ41TmuOI4
ufho3RAAg9W0beHShrEc54rHfXPbCYyzzDWdJSRhjk2o9UHiKGlXtHTeeEbDND5l
0E0LL8SKzCIv0O0r3AWcjZnaRUus48M7piKP5bTt9Zs1yzGz7T3bCS2MbWZXcmdg
AS1d2XzZhdkLQs8yBqwkwINk/FdC4LwTvCc3tUeXBk80KAt7qtblJvkeCANIOwfD
MTIMOJX1/acq2PaeMup8b8iNmo05ZqDhxfnhc049FE8XPfhXcIVCqm1d3j7ve5vH
05QbBgpOsE8HmLVzXy3mTwm9JKeCacqwhAYw3tLc+kSuJ3WQXdaAIYEstKxDkWF9
kGRoNccHF4QKsrCKMPzqpLkhVX0YR8a3Yx0rQ7QJXBLdZpIWKwCp2hfgLOndmGHQ
TDCd/eBXpMsG9nkLzDJ87azDcfn9vhOv1nHIbuKa2IYajhnCzyC59ZwwFtmjgk4m
Iz2RcAl9AQCoiQ+KfIWXA25M6ymB3LY8M1jcxjUL3NJFT13pKESSNKYRNcANStQw
bX5SO/rnUpSmDg705qfMtMCpIlRiZpnZjjggG7SPsvTe2fdGOvHmqE1tInXbeh9Z
I52H6PGWTqtt/pb2GyRkHjtAz0oXw+ZfijpXdUZESPhxHznPIUV42PiNT3y8HSnJ
Cg0WWjVcvr7ZvnVQlvwTAy2vcudkpsCCdzUq1yH9Lj/Qsay6j/o=
=tdsv
-----END PGP SIGNATURE-----

--bCmHwAiM1FvN6J4364I56N1i753EkjL6r--

