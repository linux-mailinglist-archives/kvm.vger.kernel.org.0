Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD3F29F4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 09:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbfKGI76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 03:59:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbfKGI75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 03:59:57 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA78wSZ5112697
        for <kvm@vger.kernel.org>; Thu, 7 Nov 2019 03:59:56 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w4e80vcjk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 03:59:56 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 7 Nov 2019 08:59:54 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 7 Nov 2019 08:59:51 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA78xoHp50659390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 08:59:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F1B14C050;
        Thu,  7 Nov 2019 08:59:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDD044C040;
        Thu,  7 Nov 2019 08:59:49 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.27.136])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 08:59:49 +0000 (GMT)
Subject: Re: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-31-frankja@linux.ibm.com>
 <20191106174855.13a50f42.cohuck@redhat.com>
 <6dd98dfe-63ce-374c-9b04-00cdeceee905@linux.ibm.com>
 <20191106183754.68e1be0f.cohuck@redhat.com>
 <faacad49-3f91-08f3-d1ee-d31f31ac38bb@linux.ibm.com>
 <20191107095323.0ede44b5.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 7 Nov 2019 09:59:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191107095323.0ede44b5.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ItZ2vptM4eZ6xUoUd2jOtqT7MuqSuqZM2"
X-TM-AS-GCONF: 00
x-cbid: 19110708-0020-0000-0000-0000038357C0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110708-0021-0000-0000-000021D98AD4
Message-Id: <be94339f-90cf-3ce9-aaec-f6031dc11aeb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ItZ2vptM4eZ6xUoUd2jOtqT7MuqSuqZM2
Content-Type: multipart/mixed; boundary="FL9wyKq4wi5P9CXhZ7lUKwCELV7ie8FM1"

--FL9wyKq4wi5P9CXhZ7lUKwCELV7ie8FM1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/7/19 9:53 AM, Cornelia Huck wrote:
> On Wed, 6 Nov 2019 22:02:41 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 11/6/19 6:37 PM, Cornelia Huck wrote:
>>> On Wed, 6 Nov 2019 18:05:22 +0100
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>  =20
>>>> On 11/6/19 5:48 PM, Cornelia Huck wrote: =20
>>>>> On Thu, 24 Oct 2019 07:40:52 -0400
>>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>>>    =20
>>>>>> Description of changes that are necessary to move a KVM VM into
>>>>>> Protected Virtualization mode.
>>>>>>
>>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>>> ---
>>>>>>  Documentation/virtual/kvm/s390-pv-boot.txt | 62 +++++++++++++++++=
+++++
>>>>>>  1 file changed, 62 insertions(+)
>>>>>>  create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt =20
>>>  =20
>>>>> So... what do we IPL from? Is there still a need for the bios?
>>>>>
>>>>> (Sorry, I'm a bit confused here.)
>>>>>    =20
>>>>
>>>> We load a blob via the bios (all methods are supported) and that blo=
b
>>>> moves itself into protected mode. I.e. it has a small unprotected st=
ub,
>>>> the rest is an encrypted kernel.
>>>> =20
>>>
>>> Ok. The magic is in the loaded kernel, and we don't need modification=
s
>>> to the bios?
>>>  =20
>>
>> Yes.
>>
>> The order is:
>> * We load a blob via the bios or direct kernel boot.
>> * That blob consists of a small stub, a header and an encrypted blob
>> glued together
>> * The small stub does the diag 308 subcode 8 and 10.
>> * Subcode 8 basically passes the header that describes the encrypted
>> blob to the Ultravisor (well rather registers it with qemu to pass on =
later)
>> * Subcode 10 tells QEMU to move the VM into protected mode
>> * A lot of APIs in KVM and the Ultravisor are called
>> * The protected VM starts
>> * A memory mover copies the now unencrypted, but protected kernel to i=
ts
>> intended place and jumps into the entry function
>> * Linux boots and detects, that it is protected and needs to use bounc=
e
>> buffers
>>
>=20
> Thanks, this explanation makes things much clearer.

NP
We seem to assume that all of this is easily understandable, but we are
obviously biased :-)
I'll try to improve Documentation by adding Pierre to the discussion, as
he wasn't involved in the project yet.



--FL9wyKq4wi5P9CXhZ7lUKwCELV7ie8FM1--

--ItZ2vptM4eZ6xUoUd2jOtqT7MuqSuqZM2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3D3QUACgkQ41TmuOI4
ufj6Pg//ZJTbUfemkydo3lvAjiJQYdOwQjrin7iFQg5HqwQv7+AjChfCt7hJ+n5T
Q4Vz0Dm1l4iIfhnchptUiYYBW4Eez9GMmo9VQc27Gs/4jbBAjCIlVN7MrYwg72Pf
X9tH4kH+cYqfeORf+Qs20unIIr854GYVMwjm5zLMMtqaEiK+dc0eD41sGc5csLJF
H5VHwrSufIS89auWLf7AWDU/L4ix1+XOrBEpHjogjEWzDk0GaqGiibsVxbNbeVLa
THtv/vE1ZoHlvznnrNLXA6g14OG75GMa0FicijtdNEqSVzJfzReYPlirC3u9BSma
uU52cv3ARpZ55xC7K5a4puYokX5z8zlGYRmcYK6mhbW4RUehWlm3ELE2mN3MBoZc
WIdAZJynsOaiVbiN2XD8PgME19Bud1TPprJUn0ElvGXRTU8zrx7OnIMDX8yNZuae
yCLl+lVOy3b/VWOydw8NdLQB7aGGAa9+i0nF1fNJC0VRK1gQGWo1XyK6Xed/eb3x
PWr4dlKaeUpJYn/lhOznbt95FzShHUg6Im2eoHH7mT+z0JFSi0QVVgL2wbk4Ki9C
7jy9OFdXQ857Ambq4ftP1D8iJjZmxJVP8f6gRmVxUbI38F14ThKAIZp+OYGgxIe3
VczRdDQlVZ1zJk2u4W8X/g/hG1Ty4dKL3Y0HiAyXhCJOBfMBSDw=
=4u0W
-----END PGP SIGNATURE-----

--ItZ2vptM4eZ6xUoUd2jOtqT7MuqSuqZM2--

