Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE93C234201
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbgGaJGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:06:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1910 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731818AbgGaJGe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:06:34 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V92DGd054887;
        Fri, 31 Jul 2020 05:06:33 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mc8wp47y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:06:32 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V92RPs056432;
        Fri, 31 Jul 2020 05:06:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mc8wp46c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:06:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V95vkk031903;
        Fri, 31 Jul 2020 09:06:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 32gcpx72t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 09:06:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V96Rhs60227982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:06:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1062FA4064;
        Fri, 31 Jul 2020 09:06:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ACFEA405F;
        Fri, 31 Jul 2020 09:06:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.62.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 09:06:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200727095415.494318-1-frankja@linux.ibm.com>
 <20200727095415.494318-4-frankja@linux.ibm.com>
 <20200730131617.7f7d5e5f.cohuck@redhat.com>
 <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
 <d9333547-b93e-629b-e004-53f1b581914f@linux.ibm.com>
 <20200731104205.37add810.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <16eee269-d773-26df-a517-08f2265318c4@linux.ibm.com>
Date:   Fri, 31 Jul 2020 11:06:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200731104205.37add810.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A70HuUQvq2qG9s6fjygJ0okS4JtmJJliV"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A70HuUQvq2qG9s6fjygJ0okS4JtmJJliV
Content-Type: multipart/mixed; boundary="X026MUpz8UTN0wCuU8m9I4QwoaXZ1wqxa"

--X026MUpz8UTN0wCuU8m9I4QwoaXZ1wqxa
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/31/20 10:42 AM, Cornelia Huck wrote:
> On Fri, 31 Jul 2020 09:34:41 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 7/30/20 5:58 PM, Thomas Huth wrote:
>>> On 30/07/2020 13.16, Cornelia Huck wrote: =20
>>>> On Mon, 27 Jul 2020 05:54:15 -0400
>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>> =20
>>>>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>>>>      * Query Ultravisor information
>>>>>      * Set shared access
>>>>>      * Remove shared access
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>> ---
>>>>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>>>>>  s390x/Makefile      |   1 +
>>>>>  s390x/unittests.cfg |   3 +
>>>>>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++=
++++
>>>>>  4 files changed, 231 insertions(+)
>>>>>  create mode 100644 lib/s390x/asm/uv.h
>>>>>  create mode 100644 s390x/uv-guest.c
>>>>> =20
>>>>
>>>> (...)
>>>> =20
>>>>> +static inline int uv_call(unsigned long r1, unsigned long r2)
>>>>> +{
>>>>> +	int cc;
>>>>> +
>>>>> +	asm volatile(
>>>>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>>>>> +		"		brc	3,0b\n"
>>>>> +		"		ipm	%[cc]\n"
>>>>> +		"		srl	%[cc],28\n"
>>>>> +		: [cc] "=3Dd" (cc)
>>>>> +		: [r1] "a" (r1), [r2] "a" (r2)
>>>>> +		: "memory", "cc");
>>>>> +	return cc;
>>>>> +} =20
>>>>
>>>> This returns the condition code, but no caller seems to check it
>>>> (instead, they look at header.rc, which is presumably only set if th=
e
>>>> instruction executed successfully in some way?)
>>>>
>>>> Looking at the kernel, it retries for cc > 1 (presumably busy
>>>> conditions), and cc !=3D 0 seems to be considered a failure. Do we w=
ant
>>>> to look at the cc here as well? =20
>>>
>>> It's there - but here it's in the assembly code, the "brc 3,0b". =20
>=20
> Ah yes, I missed that.
>=20
>>
>> Yes, we needed to factor that out in KVM because we sometimes need to
>> schedule and then it looks nicer handling that in C code. The branch o=
n
>> condition will jump back for cc 2 and 3. cc 0 and 1 are success and
>> error respectively and only then the rc and rrc in the UV header are s=
et.
>=20
> Yeah, it's a bit surprising that rc/rrc are also set with cc 1.

Is it?
The (r)rc *only* contain meaningful information on CC 1.
On CC 0 they will simply say everything is fine which CC 0 states
already anyway.

>=20
> (Can you add a comment? Just so that it is clear that callers never
> need to check the cc, as rc/rrc already contain more information than
> that.)

I'd rather fix my test code and also check the CC.
I did check it for my other UV tests so I've no idea why I didn't do it
here...


How about adding a comment for the cc 2/3 case?
"The brc instruction will take care of the cc 2/3 case where we need to
continue the execution because we were interrupted.
The inline assembly will only return on success/error i.e. cc 0/1."

>=20
>>
>>>
>>> Patch looks ok to me (but I didn't do a full review):
>>>
>>> Acked-by: Thomas Huth <thuth@redhat.com>
>>>  =20
>>
>>
>=20



--X026MUpz8UTN0wCuU8m9I4QwoaXZ1wqxa--

--A70HuUQvq2qG9s6fjygJ0okS4JtmJJliV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8j3xEACgkQ41TmuOI4
ufjjTA/8DbmGDl+NKT3CiHOO2bK2AX5wwmWxmD3SD5RAHlLQa8pf7zBA1NJKtk1Z
WhyOYlVGF24akHC0A9+4SpVwpXcbax/jn/jTywebg8tFm8LrR13pXo4eFW2aagqu
RjG95kxm3BrVUjhSzThGPXORd4Kxu2P4cb+d/E0LFOw6AaAzAMEw7GjCuUK9sArQ
KNIikE6SzBaNSnhUDKnVt6Ui8pioTTDSMAuW+uNDmo+O/d3hwGYVpQz3oeHUdbDE
0Ml2ycmlMhSVYf/OJf2hlfvsvo4TUZJ/IOBOhJDv01QjA86W4xHcFEmgcAQFcfy7
LGSqu/PG81PpuQLScBpEBfN3i3Ak6RGwI5HpcvfVk2GD+XKPFKWEXCVcaoxH6e/m
to8rPbFfxKu8FALHL1lkYH1PBstBHnmpjxmT5towr1Lq7lEIfvtFHK1ZnR2wtGOa
i+tLPhJ8PHmo/g7vYxdF24KA1w++8PSuZPBkN90yDjLnU34wZlTxfCGWmXe9/s1S
KD90nETKhcWGEAaqWTYijWxUUXnuxoSeD/CtKo9kSGluTOoy9QOxmqn85YDjKRQR
1q7CAd+EqA0WqN3wUfKcIdR1jp0RUb3lLLSDuAcGsm/+Yx6tUbncmaZDJ33kFQZE
P3zHWDfpOFISBw4NIlq5nk7jVbB2H1jTs5VxevFmsUDgtLxYe8E=
=nxo7
-----END PGP SIGNATURE-----

--A70HuUQvq2qG9s6fjygJ0okS4JtmJJliV--

