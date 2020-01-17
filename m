Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDBF140824
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgAQKlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:41:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726409AbgAQKlI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jan 2020 05:41:08 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00HAbvZB144505
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:41:07 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xk0qrgc1r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 05:41:07 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 17 Jan 2020 10:41:05 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Jan 2020 10:41:02 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00HAf1ho22348238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 10:41:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54F6DA4057;
        Fri, 17 Jan 2020 10:41:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA60A405B;
        Fri, 17 Jan 2020 10:41:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.184.110])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jan 2020 10:41:00 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 7/7] s390x: smp: Dirty fpc before
 initial reset test
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        cohuck@redhat.com
References: <20200116120513.2244-1-frankja@linux.ibm.com>
 <20200116120513.2244-8-frankja@linux.ibm.com>
 <0ddfb1ce-16e4-017f-078b-80146bfa29a6@redhat.com>
 <3f034419-2342-0571-ea68-0474d45ba552@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 17 Jan 2020 11:41:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3f034419-2342-0571-ea68-0474d45ba552@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L0yNv4pyfJXFCX2MOHGsVBsAmzhoupazW"
X-TM-AS-GCONF: 00
x-cbid: 20011710-0016-0000-0000-000002DE3898
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011710-0017-0000-0000-00003340D400
Message-Id: <39a948f0-d30a-2e98-a836-b87721be5139@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_02:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L0yNv4pyfJXFCX2MOHGsVBsAmzhoupazW
Content-Type: multipart/mixed; boundary="hg0V4YwW6dOBEbvGe5nupV3AIfEa58pkt"

--hg0V4YwW6dOBEbvGe5nupV3AIfEa58pkt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/17/20 11:29 AM, Thomas Huth wrote:
> On 17/01/2020 11.20, David Hildenbrand wrote:
>> On 16.01.20 13:05, Janosch Frank wrote:
>>> Let's dirty the fpc, before we test if the initial reset sets it to 0=
=2E
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  s390x/smp.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>> index ce3215d..97a9dda 100644
>>> --- a/s390x/smp.c
>>> +++ b/s390x/smp.c
>>> @@ -179,6 +179,9 @@ static void test_emcall(void)
>>>  /* Used to dirty registers of cpu #1 before it is reset */
>>>  static void test_func_initial(void)
>>>  {
>>> +	asm volatile(
>>> +		"	sfpc	%0\n"
>>> +		: : "d" (0x11) : );
>>
>> FWIW, I'd make this one easier to read
>>
>> asm volatile("sfpc %0\n" :: "d" (0x11));
>=20
> By the way, since it's only one line, you can also drop the \n here.
>=20
>  Thomas
>=20

Both suggestions applied :)
Thanks!


--hg0V4YwW6dOBEbvGe5nupV3AIfEa58pkt--

--L0yNv4pyfJXFCX2MOHGsVBsAmzhoupazW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4hjzwACgkQ41TmuOI4
ufhSZg/+Nd/UkZA5v2rRgManexbPR9tnfQ/O6+VXxz5hz3LVW8ZzrGe1IaAGuvLM
iDBvjKRhfLSvXBjXy8A5p/y5KaUt5WSKT8pNwV9dCMxcz5+KqDKwwwyjmRuzKsze
eLqFKHllLPASprnVosKDsicadZ2cMSEaE0ZPWo0Dw7dOMP2TwWJ8pN9i/8hPpYMb
yOFsBJantUb0ZMcFD2ATCGvb4VxQ7DhzVIEbn6w4q8IcjwmNLIH43kOTDQ7Gpj7N
+XY6k7DK+v/eXXTRPYevP6fhnrJVFaCnIESq1ECG8lc+JAFRASkjbRrI+uJ05xB7
0sPsPt/+KnSXwcEXVusnr9Kj7xhTuL7AV0Kt3GwO3fitJzvKDuvH/wH2kc666dun
JyPr1wJHGor0o206ANErN9dTUN81SJMm56vr8VzVDBODY+mcrOCLy+CeXMbwOBkI
6E1gF7Q40s6hV7YDMdHsFi8jXNoaSPN09nMZW0/eMkTqAEHUu0/nX27SJOjoIOvd
JfAJ7FUJ/OCnAT/XKXv3A2tjnB8kfIE1sDHx5yKrlyF3PUJJyPdoGUDGoYVRhS8y
gYC4QisnduEIvG91NGoFTB8boTqNeqCONvwFjRwSzkvMUKR4KeowlwW/wPWZAQKE
Hv5gZBj1xO/lo3NXdh1yTNCFPzWdZDyu9VIn7eF45qaa9KR2LRo=
=6gu5
-----END PGP SIGNATURE-----

--L0yNv4pyfJXFCX2MOHGsVBsAmzhoupazW--

