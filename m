Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3AEDC73
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfKDKZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:25:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfKDKZM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:25:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA4A6wsc036508
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 05:25:11 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w2hxp0px5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 05:25:11 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 10:25:09 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 10:25:07 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4AP5mw34472144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 10:25:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D67652059;
        Mon,  4 Nov 2019 10:25:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1F81D52051;
        Mon,  4 Nov 2019 10:25:05 +0000 (GMT)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
 <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
 <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 4 Nov 2019 11:25:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <84bd87f0-37bf-caa8-5762-d8da58f37a8f@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ll9ofum3paBG7u8XY2oUHCxD5vFOm6S4o"
X-TM-AS-GCONF: 00
x-cbid: 19110410-0016-0000-0000-000002C07FC5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110410-0017-0000-0000-00003321EF33
Message-Id: <5a630f24-4d17-7844-e4e7-d3ab1c8507a4@linux.ibm.com>
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
--ll9ofum3paBG7u8XY2oUHCxD5vFOm6S4o
Content-Type: multipart/mixed; boundary="6ZJCxyP15pXbd7WZ9PsALd6qUutBNqhsg"

--6ZJCxyP15pXbd7WZ9PsALd6qUutBNqhsg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/4/19 11:19 AM, David Hildenbrand wrote:
>>>> to synchronize page import/export with the I/O for paging. For examp=
le you can actually
>>>> fault in a page that is currently under paging I/O. What do you do? =
import (so that the
>>>> guest can run) or export (so that the I/O will work). As this turned=
 out to be harder then
>>>> we though we decided to defer paging to a later point in time.
>>>
>>> I don't quite see the issue yet. If you page out, the page will
>>> automatically (on access) be converted to !secure/encrypted memory. I=
f
>>> the UV/guest wants to access it, it will be automatically converted t=
o
>>> secure/unencrypted memory. If you have concurrent access, it will be
>>> converted back and forth until one party is done.
>>
>> IO does not trigger an export on an imported page, but an error
>> condition in the IO subsystem. The page code does not read pages throu=
gh
>=20
> Ah, that makes it much clearer. Thanks!
>=20
>> the cpu, but often just asks the device to read directly and that's
>> where everything goes wrong. We could bounce swapping, but chose to pi=
n
>> for now until we find a proper solution to that problem which nicely
>> integrates into linux.
>=20
> How hard would it be to
>=20
> 1. Detect the error condition
> 2. Try a read on the affected page from the CPU (will will automaticall=
y=20
> convert to encrypted/!secure)
> 3. Restart the I/O
>=20
> I assume that this is a corner case where we don't really have to care =

> about performance in the first shot.

Restarting IO can be quite difficult with CCW, we might need to change
request data...

>=20
>>
>>>
>>> A proper automatic conversion should make this work. What am I missin=
g?
>>>
>>>>
>>>> As we do not want to rely on the userspace to do the mlock this is n=
ow done in the kernel.
>>>
>>> I wonder if we could come up with an alternative (similar to how we
>>> override VM_MERGEABLE in the kernel) that can be called and ensured i=
n
>>> the kernel. E.g., marking whole VMAs as "don't page" (I remember
>>> something like "special VMAs" like used for VDSOs that achieve exactl=
y
>>> that, but I am absolutely no expert on that). That would be much nice=
r
>>> than pinning all pages and remembering what you pinned in huge page
>>> arrays ...
>>
>> It might be more worthwhile to just accept one or two releases with
>> pinning and fix the root of the problem than design a nice stopgap.
>=20
> Quite honestly, to me this feels like a prototype hack that deserves a =

> proper solution first. The issue with this hack is that it affects user=
=20
> space (esp. MADV_DONTNEED no longer working correctly). It's not just=20
> something you once fix in the kernel and be done with it.

It is a hack, yes.
But we're not the only architecture to need it x86 pins all the memory
at the start of the VM and that code is already upstream...

>>
>> Btw. s390 is not alone with the problem and we'll try to have another
>> discussion tomorrow with AMD to find a solution which works for more
>> than one architecture.
>=20
> Let me know if there was an interesting outcome.
>=20



--6ZJCxyP15pXbd7WZ9PsALd6qUutBNqhsg--

--ll9ofum3paBG7u8XY2oUHCxD5vFOm6S4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2//IAACgkQ41TmuOI4
ufi+NhAAv6jnjE4NeOye1Yy1exuQ65rT2L7f5MfNwEW50vw7ULmFXbWUO8TjWX/R
Mw87PacIXx0U9ImWHGYI8mLlU7El9K8CsFwBjEc19ajqQ1zP7d0qzYsp/xBxObEy
BXxa4WAfNukH/LyyIm/2bBhNFV4gO7Spq0QeCzb0xckEmux1BAMOnaG3a2TQxLNR
8zhRf06nTmeNbYUl0epPOWyixWBVwGwvKlHjFQx80PzJooovDl0eNYqH7RGz/SHg
JYC1PQcNnaVxweHc1m41ahhwpev2WycGX70v/luasuXyltDnXkfx0SMgq8uuARHN
nq6HidlO4qEergHhzNvum4ft9dKcT9R45ldIxDfi0bHvlxdNcBkRWl8Oshj2m4jI
WJh7E3XmrZcG2hBR6RZpkDP81Ml8RBIdP+lx7vTRM4B0lOdtrZVEwPcFsScyHLuQ
wy2Djawqqf8icePBinCzNNvpYkS6Tvr+O/jcqPUNQuI6bRFR+Jof0XZD1PuSN6FP
SQpXHyqEN+4ibDUAhordLpzYbqNYPxdfT4C0YRsjICMK4LR4HKZ+iWwP6NoneSS9
dkNQkV0DodxHpHpUwDIINogVsjUa2XfSeeNptqefTLgyKywel76HoilYaa+yMDne
aUdk3pwW4NF8W22IlTNfoCavNnTfJ7kzQ0b46T3Ml9lHwkJWC6o=
=HOrR
-----END PGP SIGNATURE-----

--ll9ofum3paBG7u8XY2oUHCxD5vFOm6S4o--

