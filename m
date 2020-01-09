Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD7135EDD
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgAIRFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:05:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731444AbgAIRFw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 12:05:52 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009H2dvq192361
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 12:05:50 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xe2vsp5fr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 12:05:50 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 9 Jan 2020 17:05:48 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 17:05:45 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009H5hRk25886906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 17:05:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A51A4053;
        Thu,  9 Jan 2020 17:05:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14949A4040;
        Thu,  9 Jan 2020 17:05:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.166.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 17:05:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com
References: <20200109161625.154894-1-imbrenda@linux.ibm.com>
 <20200109161625.154894-4-imbrenda@linux.ibm.com>
 <5c6f563e-3d09-5274-b050-a64122097e9b@redhat.com>
 <20200109175027.362d8440@p-imbrenda>
 <3dc2cf13-4829-53cd-a0a6-734fdddeb0ac@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 9 Jan 2020 18:05:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3dc2cf13-4829-53cd-a0a6-734fdddeb0ac@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zr67qUUwMF4HbjZpi0SDrVLCAGEKlUtFu"
X-TM-AS-GCONF: 00
x-cbid: 20010917-0016-0000-0000-000002DBFA19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010917-0017-0000-0000-0000333E79FF
Message-Id: <920208a7-562f-9a54-11cc-6ece021469ec@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zr67qUUwMF4HbjZpi0SDrVLCAGEKlUtFu
Content-Type: multipart/mixed; boundary="qEuZ6r7k8Bu8J0ttgt5ZJgwqJGKX7UwDd"

--qEuZ6r7k8Bu8J0ttgt5ZJgwqJGKX7UwDd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/9/20 5:58 PM, Thomas Huth wrote:
> On 09/01/2020 17.50, Claudio Imbrenda wrote:
>> On Thu, 9 Jan 2020 17:43:55 +0100
>> Thomas Huth <thuth@redhat.com> wrote:
>>
>>> On 09/01/2020 17.16, Claudio Imbrenda wrote:
>>>> Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
>>>> use it instead of using inline assembly everywhere.
>>>>
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> ---
>>>>  lib/s390x/asm/arch_def.h | 10 ++++++++++
>>>>  s390x/intercept.c        | 33 +++++++++++++--------------------
>>>>  2 files changed, 23 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>>> index 1a5e3c6..465fe0f 100644
>>>> --- a/lib/s390x/asm/arch_def.h
>>>> +++ b/lib/s390x/asm/arch_def.h
>>>> @@ -284,4 +284,14 @@ static inline int servc(uint32_t command,
>>>> unsigned long sccb) return cc;
>>>>  }
>>>> =20
>>>> +static inline void spx(uint32_t *new_prefix) =20
>>>
>>> Looking at this a second time ... why is new_prefix a pointer? A
>>> normal value should be sufficient here, shouldn't it?
>>
>> no. if you look at the code in the same patch, intercept.c at some
>> points needs to pass "wrong" pointers to spx and stpx in order to test=

>> them, so this needs to be a pointer
>>
>> the instructions themselves expect pointers (base register + offset)
>=20
> Ah, you're right, that "Q" constraint always confuses me... I guess you=

> could do it without pointers when using the "r" constraint, but it's
> likely better to do it the same way as stpx, so your patch should be fi=
ne.

Honestly, I'd rather have stpx return a u32 than passing a ptr.
That's how the kernel does it and is in-line with epswe/lpswe and
sctlg/lctlg which are already in the library.

Also, if possible names like set_prefix and store_prefix (or better
get_prefix) prefix would make it much more readable.

>=20
>>>> +{
>>>> +	asm volatile("spx %0" : : "Q" (*new_prefix) : "memory");
>>>> +}
>>>> +
>>>> +static inline void stpx(uint32_t *current_prefix)
>>>> +{
>>>> +	asm volatile("stpx %0" : "=3DQ" (*current_prefix));
>>>> +}
>>>> + =20
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20



--qEuZ6r7k8Bu8J0ttgt5ZJgwqJGKX7UwDd--

--zr67qUUwMF4HbjZpi0SDrVLCAGEKlUtFu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4XXWYACgkQ41TmuOI4
ufjBWhAA0BLaCmqO5xIMN106t3qhouiw4IyXNW9CicOtalmcGSDQtU6JJufArLko
3XT/wxE3OWEzPPSmQloRbiJP72NZhxOtaK8+rbl3gMFOTC5e2eKwvGLv7V3ryn2U
UI8PtCzXhsDIWNee7YoaLl857/7bbT9kiYsQIOUZdxBKAgsSFXK1H0zWRRCZ5xiL
km5a9pT6BEC587UBViwgO/VKClLttCZXvBEeNkWkg2sb2R9/2MK9G5f68cn197DJ
lc7Lc00RdmT2bpucfl0RxS0TUl45L8ymReBFgYXiV85pmS9SqvXtQFF/fEHZPrGJ
FAJoupLpSPsqk2ipq0YMYIfZsalQ/8FF4dyp/xcZ/cIlgtglKwq0QRLAbbvpsGQr
coF4klQWtn15n1tJ7QlxoTOSkjXTF8OSnsdHcFV6YlChDy0tax8jXxrHSGOIi6AS
d1VgsyezeEjk9Oel8c80dcXA6Rx5sQB6twABLv8lXcwAuhW+CG7hmRv8GsMMtjxU
95CPut4po955lpsb+v79nJRuMnvtFT48tk1DvS7l8XHpeykHEWLnGUCcAZr2G1R5
+aeR0/MVdW7+nsJkyuxG5O7Ue6bLWPHipe2TWFSrFDyRawbO7qZJuXi7ctqzwXLy
I6miNvZDhkDcKZLdMs+UYa26vBU/AJFYH40jPhQ0Y6ynnhQ3iGA=
=fB/S
-----END PGP SIGNATURE-----

--zr67qUUwMF4HbjZpi0SDrVLCAGEKlUtFu--

