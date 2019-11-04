Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008FDEDC34
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfKDKM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:12:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfKDKM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:12:57 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA4AB4Fw134396
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 05:12:55 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w2j0w82em-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 05:12:55 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 10:12:52 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 10:12:50 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4ACnqs51052678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 10:12:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EC325205A;
        Mon,  4 Nov 2019 10:12:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C308252054;
        Mon,  4 Nov 2019 10:12:48 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] alloc: Add more memalign asserts
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com
References: <20191104092055.5679-1-frankja@linux.ibm.com>
 <6f7795ac-5700-c132-e3b1-708e9451956f@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 4 Nov 2019 11:12:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6f7795ac-5700-c132-e3b1-708e9451956f@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BIT53sADu6tlx5uynqwdldTQUYzNUrzSo"
X-TM-AS-GCONF: 00
x-cbid: 19110410-0028-0000-0000-000003B2756A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110410-0029-0000-0000-00002474C836
Message-Id: <af428ca3-09b2-a1dc-61f8-a6eee290e36b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BIT53sADu6tlx5uynqwdldTQUYzNUrzSo
Content-Type: multipart/mixed; boundary="fGDY2kSMno9DsMGMfrpfZYd1bOfSWi7Sq"

--fGDY2kSMno9DsMGMfrpfZYd1bOfSWi7Sq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/4/19 11:07 AM, Paolo Bonzini wrote:
> On 04/11/19 10:20, Janosch Frank wrote:
>> Let's test for size and alignment in memalign to catch invalid input
>> data. Also we need to test for NULL after calling the memalign
>> function of the registered alloc operations.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>
>> Tested only under s390, tests under other architectures are highly
>> appreciated.
>>
>> ---
>>  lib/alloc.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/lib/alloc.c b/lib/alloc.c
>> index ecdbbc4..eba9dd6 100644
>> --- a/lib/alloc.c
>> +++ b/lib/alloc.c
>> @@ -46,6 +46,7 @@ void *memalign(size_t alignment, size_t size)
>>  	uintptr_t blkalign;
>>  	uintptr_t mem;
>> =20
>> +	assert(size && alignment);
>=20
> Do we want to return NULL instead on !size?  This is how malloc(3) is
> documented.
>=20
> Paolo

I myself never check for NULL on a unit test and therefore added the
asserts to have it fail visibly.

But sure, we can return NULL for both asserts.

>=20
>>  	assert(alloc_ops && alloc_ops->memalign);
>>  	if (alignment <=3D sizeof(uintptr_t))
>>  		alignment =3D sizeof(uintptr_t);
>> @@ -56,6 +57,8 @@ void *memalign(size_t alignment, size_t size)
>>  	size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>>  	p =3D alloc_ops->memalign(blkalign, size);
>> =20
>> +	assert(p !=3D NULL);
>> +
>>  	/* Leave room for metadata before aligning the result.  */
>>  	mem =3D (uintptr_t)p + METADATA_EXTRA;
>>  	mem =3D ALIGN(mem, alignment);
>>
>=20



--fGDY2kSMno9DsMGMfrpfZYd1bOfSWi7Sq--

--BIT53sADu6tlx5uynqwdldTQUYzNUrzSo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2/+aAACgkQ41TmuOI4
ufiTRw//Z9VDpHHCYUGLvQplhiWOCMjvD7LUeAHKuPF1F8uP7oMfFzlgvSxE1x2L
JwXvFSy2HYMbqz1O5SVs1710USqGe8x+BxQHhGVHoHFcHuqdhAyElpyK+HklO9S1
IlYiPXfvYtDTgmJVNJ1cKZcAaG7lHbQWG5PFpynvPExnJTcT+r1s1XWkaL7D9oa9
jAd94ef9E1tB/fqUUqQuQd91FoQyF0h1USwPt2UWFSixUgCN8uGzOg+h+asE0T0I
KAt9WUEyP2tQhd0vhh07UUPfDQ8j19k0f5nPWOcI5S5QKMgu0o/yu3UXAgX01WXh
YCo7pknsTQp59o+PAnVrabotkKZFjBJrcDfeZWDHRAM9NIaR6z5fwn+yO2/hC9CK
bpDKxriYOIpYVNcRg0Fx9bzKQ/fhHORi44uO3SfRbWXrbwA1Kbvu/NcFwwm/ZFmS
io7Qd4fJ2hUfYfnjEC2bDSj+bQUPF/VHWRNYXVawb5aojtCNcSLnhbBoCl0BqDhX
fhYCswfoi1fHJB4gB+7Zqw931TuPhnEqidLEEvkNEgCMk3IKN41/UwgfRCRF9KXM
6np5VretqD4PPFXjIPSSgVW7w4/BCdMG1bHZCB8Gj0WHvSnU+FtM49707Fd8uEs7
g6UcFtH1/CoZLGoLoPyIyOYASY7yC3ZbYij9Aq/MxeQM3pf2mbA=
=Z77D
-----END PGP SIGNATURE-----

--BIT53sADu6tlx5uynqwdldTQUYzNUrzSo--

