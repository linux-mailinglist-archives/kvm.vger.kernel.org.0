Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5145FDFAD
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfKOOIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:08:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbfKOOIP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 09:08:15 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFDtOKi003383
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 09:08:14 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9jttd9wf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 09:08:14 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 14:08:12 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 14:08:09 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFE7UxH36045136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 14:07:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87CCBAE051;
        Fri, 15 Nov 2019 14:08:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FA45AE05D;
        Fri, 15 Nov 2019 14:08:07 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 14:08:07 +0000 (GMT)
Subject: Re: [RFC 32/37] KVM: s390: protvirt: UV calls diag308 0, 1
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-33-frankja@linux.ibm.com>
 <6fb6b03f-5a33-34ec-53e6-d960ac7bbae6@redhat.com>
 <302337a3-5a1f-4ee9-2ee8-a10b7fe17479@linux.ibm.com>
 <76e04877-93c5-0785-290e-4d8739b4c4b8@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 15:08:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <76e04877-93c5-0785-290e-4d8739b4c4b8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CPmz1e8ItJrBNcHxfq8kHxKu5dJ1kIE68"
X-TM-AS-GCONF: 00
x-cbid: 19111514-0020-0000-0000-000003867999
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111514-0021-0000-0000-000021DC96B8
Message-Id: <e7bef954-6244-7a04-10ff-422490603f36@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_04:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=929 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 suspectscore=3 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CPmz1e8ItJrBNcHxfq8kHxKu5dJ1kIE68
Content-Type: multipart/mixed; boundary="lUA5fxpMNikueqjutFFqm3ZOFu8fsy5wY"

--lUA5fxpMNikueqjutFFqm3ZOFu8fsy5wY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 2:30 PM, Thomas Huth wrote:
> On 15/11/2019 12.39, Janosch Frank wrote:
>> On 11/15/19 11:07 AM, Thomas Huth wrote:
>>> On 24/10/2019 13.40, Janosch Frank wrote:
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  arch/s390/include/asm/uv.h | 25 +++++++++++++++++++++++++
>>>>  arch/s390/kvm/diag.c       |  1 +
>>>>  arch/s390/kvm/kvm-s390.c   | 20 ++++++++++++++++++++
>>>>  arch/s390/kvm/kvm-s390.h   |  2 ++
>>>>  arch/s390/kvm/pv.c         | 19 +++++++++++++++++++
>>>>  include/uapi/linux/kvm.h   |  2 ++
>>>>  6 files changed, 69 insertions(+)
>>>
>>> Add at least a short patch description what this patch is all about?
>>>
>>>  Thomas
>>>
>>
>> I'm thinking about taking out the set cpu state changes and move it in=
to
>> a later patch.
>>
>>
>> How about:
>> diag 308 subcode 0 and 1 require KVM and Ultravisor interaction, since=

>> the cpus have to be set into multiple reset states.
>>
>> * All cpus need to be stopped
>> * The unshare all UVC needs to be executed
>> * The perform reset UVC needs to be executed
>> * The cpus need to be reset via the set cpu state UVC
>> * The issuing cpu needs to set state 5 via set cpu state
>=20
> Could you put the UVC names into quotes? Like:
>=20
> * The "unshare all" UVC needs to be executed
>=20
> ... I first had to read the sentence three times to really understand i=
t.
>=20
>  Thomas
>=20

Sure, just did


--lUA5fxpMNikueqjutFFqm3ZOFu8fsy5wY--

--CPmz1e8ItJrBNcHxfq8kHxKu5dJ1kIE68
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3OsUYACgkQ41TmuOI4
ufhZlhAA1aG5W3aYZTV6zFy8rhFBSK3FyfNQFtWhS+nLwZd247Loit4uxbLwiCAm
NoFErkJ++3Dr/V20yw+BQ3Y81CtM5rOzDb6/2h2JBqkUbLiAuaMdo+/NfFFov5uO
QKBcgsnasZO9Ss+B4JxnojNruCkYxgtrFL45h8J1MBp1ubqvSlbBRW65Gd4FqDv3
vk46aHlRwkDCQD7HiS5Qw1jnsBM79Mi72X+VhWaQysM1HcioqzVi3WmkRM9lzKeJ
ABmLyjsFGQRhkUagaveIst4bnS9J7qFXAT/4iVlw28svpRm6P1ME52NkobJbovRE
2wnpR5vP5fyLdKzEQiivjxNm/0beMw1yquveTwrJVbVcsQDkwO0ZXlW+ITCHHC8N
7vYx9v41zzldw5yVp90yqVJ7raD+e42MruJ1U5aIiYqZ425B6MIk3P4ZVywSTGP3
AIOs4C1thQxjwo4xme8BcfmSjzuGy1TE2EMAdhptWrlAnxoWqM+A73aLQPJaSGC+
pz+Ig1o7qI8pumdFeykYr/GqlkC34yctQnc7QfC2RRzumQzr2cCI7BNkTG9s9Y6L
fsD9DG8eXJ009ht65xx2yvqew5/j8Ml2yqPrelHG77G6ojk9Oq73dMcovqtDRbYZ
+tWOFpjPPGxfFVJDSEOLzdLC5FdtG7ryiR26Op+uNahEGeIE5rk=
=uj5w
-----END PGP SIGNATURE-----

--CPmz1e8ItJrBNcHxfq8kHxKu5dJ1kIE68--

