Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953D7234005
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731685AbgGaHeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:34:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731669AbgGaHet (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 03:34:49 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V7Ukm5101156;
        Fri, 31 Jul 2020 03:34:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32maxxnsdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 03:34:48 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V7Unom102571;
        Fri, 31 Jul 2020 03:34:47 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32maxxnsd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 03:34:47 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V7VRpR025199;
        Fri, 31 Jul 2020 07:34:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 32gcqk4946-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 07:34:45 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V7YgfR27328802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 07:34:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D42BEA405B;
        Fri, 31 Jul 2020 07:34:42 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A1EA405C;
        Fri, 31 Jul 2020 07:34:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.62.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 07:34:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
To:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200727095415.494318-1-frankja@linux.ibm.com>
 <20200727095415.494318-4-frankja@linux.ibm.com>
 <20200730131617.7f7d5e5f.cohuck@redhat.com>
 <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d9333547-b93e-629b-e004-53f1b581914f@linux.ibm.com>
Date:   Fri, 31 Jul 2020 09:34:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gzOEqjHdnFoYeLi4AgG4RU5cJTaj1yabA"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-30,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310050
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gzOEqjHdnFoYeLi4AgG4RU5cJTaj1yabA
Content-Type: multipart/mixed; boundary="MYUINQtcUh4NQZUeoDgasgx3U0Vw7km82"

--MYUINQtcUh4NQZUeoDgasgx3U0Vw7km82
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/30/20 5:58 PM, Thomas Huth wrote:
> On 30/07/2020 13.16, Cornelia Huck wrote:
>> On Mon, 27 Jul 2020 05:54:15 -0400
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>>      * Query Ultravisor information
>>>      * Set shared access
>>>      * Remove shared access
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>>>  s390x/Makefile      |   1 +
>>>  s390x/unittests.cfg |   3 +
>>>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++++=
++
>>>  4 files changed, 231 insertions(+)
>>>  create mode 100644 lib/s390x/asm/uv.h
>>>  create mode 100644 s390x/uv-guest.c
>>>
>>
>> (...)
>>
>>> +static inline int uv_call(unsigned long r1, unsigned long r2)
>>> +{
>>> +	int cc;
>>> +
>>> +	asm volatile(
>>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>>> +		"		brc	3,0b\n"
>>> +		"		ipm	%[cc]\n"
>>> +		"		srl	%[cc],28\n"
>>> +		: [cc] "=3Dd" (cc)
>>> +		: [r1] "a" (r1), [r2] "a" (r2)
>>> +		: "memory", "cc");
>>> +	return cc;
>>> +}
>>
>> This returns the condition code, but no caller seems to check it
>> (instead, they look at header.rc, which is presumably only set if the
>> instruction executed successfully in some way?)
>>
>> Looking at the kernel, it retries for cc > 1 (presumably busy
>> conditions), and cc !=3D 0 seems to be considered a failure. Do we wan=
t
>> to look at the cc here as well?
>=20
> It's there - but here it's in the assembly code, the "brc 3,0b".

Yes, we needed to factor that out in KVM because we sometimes need to
schedule and then it looks nicer handling that in C code. The branch on
condition will jump back for cc 2 and 3. cc 0 and 1 are success and
error respectively and only then the rc and rrc in the UV header are set.=


>=20
> Patch looks ok to me (but I didn't do a full review):
>=20
> Acked-by: Thomas Huth <thuth@redhat.com>
>=20



--MYUINQtcUh4NQZUeoDgasgx3U0Vw7km82--

--gzOEqjHdnFoYeLi4AgG4RU5cJTaj1yabA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8jyZIACgkQ41TmuOI4
ufhmbw/8C367vtevYJ1CEEz5mNWY6MVMo+0TdXx1XAOkfn/pEAmAH6UJk6zt8Fve
8u9KKlYyTgKWhUDaDelWwdEs3TTI/4RtN/ABKuVUPyDX+zth8G4SqKYRHbmJ2Ta/
Xr4ISoBO1oOsGM0QOZjMoFjctTy+kKMe2OVjY0y4M6YK7SamfxB1zuLGbEoxGVDq
CunpfWPORun0QUZUkYIFxj6yIBTU45zvLOetuioqjDS7zt9vk/XsFJUujrLWj/Hi
tF+OPcSPT8mVSBdSSXHEYy9j+YdVUCD52QvgwkbXIQ3FKLCXJ3k2zGhUv0k+EPc7
+CtXP4OS6ek7Wvybj3xX/X5JCcJSbm3htIecNJDAvpwjHAcMgqQ+yrdmJMyPI8Q+
y+ewvrUfjtIbsAjP/xZrkRjIxbYrn/AU/+SKJCqaly6pz6wWGXqj4LrLSbUoxJ9L
5UD/v1ssRRe6pteQRcqwQoBpo+l3K4qzHETvP7hNlLQzL7HVywJTci923Xael3yz
C/NClKWaykbA4WOP4DKg3KrL4uFKpR16zWYRhKDkNhcyeSPHrI/xeo3DV2gw5RxF
VRWOER1+HMpLLfK/zsuDnqSHFDMWk2Iy25dUDS+30XsC98P6A5kDHQqq6GGAOHf4
QTFj5K+Wf8Cp1q1OR8gPqZVutmq5JyNZQKWgqRA/WQyoDJvSBQM=
=qSXU
-----END PGP SIGNATURE-----

--gzOEqjHdnFoYeLi4AgG4RU5cJTaj1yabA--

