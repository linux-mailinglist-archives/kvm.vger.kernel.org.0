Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A17FCA54
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfKNPzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:55:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfKNPzz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:55:55 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEFt66p050143
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:55:53 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w99e2sa12-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:55:53 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 15:55:51 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 15:55:49 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEFtlVl51052666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 15:55:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9AB8A4054;
        Thu, 14 Nov 2019 15:55:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F444A405C;
        Thu, 14 Nov 2019 15:55:47 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 15:55:47 +0000 (GMT)
Subject: Re: [RFC 17/37] DOCUMENTATION: protvirt: Instruction emulation
To:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-18-frankja@linux.ibm.com>
 <20191114161526.1100f4fe.cohuck@redhat.com>
 <20191114162024.13f17aa9@p-imbrenda.boeblingen.de.ibm.com>
 <20191114164136.0be3f058.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 16:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191114164136.0be3f058.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7oTW1KzE7oZpXbnhSASZuIPVL0KnmW5c6"
X-TM-AS-GCONF: 00
x-cbid: 19111415-0012-0000-0000-00000363A2F8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111415-0013-0000-0000-0000219F1D0B
Message-Id: <b94125ec-256c-7d7b-929e-fdbabcacb142@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7oTW1KzE7oZpXbnhSASZuIPVL0KnmW5c6
Content-Type: multipart/mixed; boundary="SFGLotJ7JEKaTdK83l8JHuGv6NCstqEFP"

--SFGLotJ7JEKaTdK83l8JHuGv6NCstqEFP
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 4:41 PM, Cornelia Huck wrote:
> On Thu, 14 Nov 2019 16:20:24 +0100
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>=20
>> On Thu, 14 Nov 2019 16:15:26 +0100
>> Cornelia Huck <cohuck@redhat.com> wrote:
>>
>>> On Thu, 24 Oct 2019 07:40:39 -0400
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>  =20
>>>> As guest memory is inaccessible and information about the guest's
>>>> state is very limited, new ways for instruction emulation have been
>>>> introduced.
>>>>
>>>> With a bounce area for guest GRs and instruction data, guest state
>>>> leaks can be limited by the Ultravisor. KVM now has to move
>>>> instruction input and output through these areas.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  Documentation/virtual/kvm/s390-pv.txt | 47
>>>> +++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
>>>>
>>>> diff --git a/Documentation/virtual/kvm/s390-pv.txt
>>>> b/Documentation/virtual/kvm/s390-pv.txt index
>>>> e09f2dc5f164..cb08d78a7922 100644 ---
>>>> a/Documentation/virtual/kvm/s390-pv.txt +++
>>>> b/Documentation/virtual/kvm/s390-pv.txt @@ -48,3 +48,50 @@
>>>> interception codes have been introduced. One which tells us that
>>>> CRs have changed. And one for PSW bit 13 changes. The CRs and the
>>>> PSW in the state description only contain the mask bits and no
>>>> further info like the current instruction address. +
>>>> +
>>>> +Instruction emulation:
>>>> +With the format 4 state description the SIE instruction already    =

>>>
>>> s/description/description,/
>>>  =20
>>>> +interprets more instructions than it does with format 2. As it is
>>>> not +able to interpret all instruction, the SIE and the UV
>>>> safeguard KVM's   =20
>>>
>>> s/instruction/instructions/
>>>  =20
>>>> +emulation inputs and outputs.
>>>> +
>>>> +Guest GRs and most of the instruction data, like IO data
>>>> structures   =20
>>>
>>> Hm, what 'IO data structures'? =20
>>
>> the various IRB and ORB of I/O instructions
>=20
> Would be good to mention them as examples :)
>=20
>>
>>>> +are filtered. Instruction data is copied to and from the Secure
>>>> +Instruction Data Area. Guest GRs are put into / retrieved from the
>>>> +Interception-Data block.
>>>> +
>>>> +The Interception-Data block from the state description's offset
>>>> 0x380 +contains GRs 0 - 16. Only GR values needed to emulate an
>>>> instruction +will be copied into this area.
>>>> +
>>>> +The Interception Parameters state description field still contains
>>>> the +the bytes of the instruction text but with pre-set register
>>>> +values. I.e. each instruction always uses the same instruction
>>>> text, +to not leak guest instruction text.
>>>> +
>>>> +The Secure Instruction Data Area contains instruction storage
>>>> +data. Data for diag 500 is exempt from that and has to be moved
>>>> +through shared buffers to KVM.   =20
>>>
>>> I find this paragraph a bit confusing. What does that imply for diag
>>> 500 interception? Data is still present in gprs 1-4? =20
>>
>> no registers are leaked in the registers. registers are always only
>> exposed through the state description.
>=20
> So, what is so special about diag 500, then?

That's mostly a confusion on my side.
The SIDAD is 4k max, so we can only move IO "management" data over it
like ORBs and stuff. My intention was to point out, that the data which
is to be transferred (disk contents, etc.) can't go over the SIDAD but
needs to be in a shared page.

diag500 was mostly a notification mechanism without a lot of data, right?=


>=20
>>
>>> (Also, why only diag 500? Because it is the 'reserved for kvm'
>>> diagnose call?)
>>>  =20
>>>> +
>>>> +When SIE intercepts an instruction, it will only allow data and
>>>> +program interrupts for this instruction to be moved to the guest
>>>> via +the two data areas discussed before. Other data is ignored or
>>>> results +in validity interceptions.
>>>> +
>>>> +
>>>> +Instruction emulation interceptions:
>>>> +There are two types of SIE secure instruction intercepts. The
>>>> normal +and the notification type. Normal secure instruction
>>>> intercepts will +make the guest pending for instruction completion
>>>> of the intercepted +instruction type, i.e. on SIE entry it is
>>>> attempted to complete +emulation of the instruction with the data
>>>> provided by KVM. That might +be a program exception or instruction
>>>> completion. +
>>>> +The notification type intercepts inform KVM about guest environment=

>>>> +changes due to guest instruction interpretation. Such an
>>>> interception   =20
>>>
>>> 'interpretation by SIE' ?
>>>  =20
>>>> +is recognized for the store prefix instruction and provides the new=

>>>> +lowcore location for mapping change notification arming. Any KVM
>>>> data +in the data areas is ignored, program exceptions are not
>>>> injected and +execution continues on next SIE entry, as if no
>>>> intercept had +happened.   =20
>>>  =20
>>
>=20



--SFGLotJ7JEKaTdK83l8JHuGv6NCstqEFP--

--7oTW1KzE7oZpXbnhSASZuIPVL0KnmW5c6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NeQMACgkQ41TmuOI4
ufjymxAAkKvX6s0mMCFk64FWdTfj9/62C/uTkTBXN7gGMnyYjYcBsyaIMbXA2OZ5
Ca7vMI4oIXHAPn08v4VNXtqgZu2vrsFCnrdnuws9mHNDdoPn9p4vl3Q8ECvVzG1m
WxtjtXKbtzUFDGvSfET3vLBJJjw1F3vtBWBLvbwyvLY24GhG8x4Zcagz9AoJhEzr
fKL4rwWyUD9RF7f525UYFUsPnoajW5korofNteYnyUxCQzuASZzC9cGTNjRw2h+a
3INbuX6nzq9hgrth9YQqhU/X0kGTQVC1A3qwc41EHtcMLXsUhm2anxBqNltsZsgy
FPe3ccMnqcecCM03IT7G3gbFlHT3ZOPs3EqS9wugFrhaRNgeEQbHbqbtOqUFjFAi
G58EpRQaJgaCVIzX44x68MapzQ0683AZZw9UEbHuegnG8w+crVqYQwIWIwZiAlFu
nIg9SWkNDmc+9wqbZvXpUAUVurBA3my3CxodL0YEvosyOF159YTVGufMUHqMefSI
dA6wjhYjZdZngg/dMzvJz9tV8L9D9RVYqttI8kZJgRUuuVPsqBUTach0RKDD43Ta
CMbzXndtoiVkuBitrUCvl7ujpj9dSlunMwJnjKb/Zfn0b6BeaEeVfTgWjXu48U2L
S4Bv6BkGyq8xbHxZuW569MSQrJvuuiUAPJ2t4u9ZPvCgGZTLDFA=
=R0AQ
-----END PGP SIGNATURE-----

--7oTW1KzE7oZpXbnhSASZuIPVL0KnmW5c6--

