Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B40FCAC6
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNQds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:33:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726410AbfKNQds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:33:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEGVSMo159870
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:33:46 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w99d43d9m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:33:46 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 16:33:44 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:33:42 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEGXf0q50593830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:33:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB625A4065;
        Thu, 14 Nov 2019 16:33:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B17AA4064;
        Thu, 14 Nov 2019 16:33:40 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 16:33:40 +0000 (GMT)
Subject: Re: [RFC 11/37] DOCUMENTATION: protvirt: Interrupt injection
To:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-12-frankja@linux.ibm.com>
 <20191114140946.7bca2350.cohuck@redhat.com>
 <20191114142500.55f985b1@p-imbrenda.boeblingen.de.ibm.com>
 <20191114144738.19915998.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 14 Nov 2019 17:33:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191114144738.19915998.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MBzN60MPSGru1NYgV1opQPDJwbSSjjNaG"
X-TM-AS-GCONF: 00
x-cbid: 19111416-0008-0000-0000-0000032F0978
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-0009-0000-0000-00004A4E1917
Message-Id: <f5c70db5-dbf7-f5eb-7968-a2887328f00b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MBzN60MPSGru1NYgV1opQPDJwbSSjjNaG
Content-Type: multipart/mixed; boundary="Gbvy7fHyJc1OJBZWCoKPUEg5fomA2FJ45"

--Gbvy7fHyJc1OJBZWCoKPUEg5fomA2FJ45
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/14/19 2:47 PM, Cornelia Huck wrote:
> On Thu, 14 Nov 2019 14:25:00 +0100
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>=20
>> On Thu, 14 Nov 2019 14:09:46 +0100
>> Cornelia Huck <cohuck@redhat.com> wrote:
>>
>>> On Thu, 24 Oct 2019 07:40:33 -0400
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>  =20
>>>> Interrupt injection has changed a lot for protected guests, as KVM
>>>> can't access the cpus' lowcores. New fields in the state
>>>> description, like the interrupt injection control, and masked
>>>> values safeguard the guest from KVM.
>>>>
>>>> Let's add some documentation to the interrupt injection basics for
>>>> protected guests.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  Documentation/virtual/kvm/s390-pv.txt | 27
>>>> +++++++++++++++++++++++++++ 1 file changed, 27 insertions(+)
>>>>
>>>> diff --git a/Documentation/virtual/kvm/s390-pv.txt
>>>> b/Documentation/virtual/kvm/s390-pv.txt index
>>>> 86ed95f36759..e09f2dc5f164 100644 ---
>>>> a/Documentation/virtual/kvm/s390-pv.txt +++
>>>> b/Documentation/virtual/kvm/s390-pv.txt @@ -21,3 +21,30 @@ normally
>>>> needed to be able to run a VM, some changes have been made in SIE
>>>> behavior and fields have different meaning for a PVM. SIE exits are
>>>> minimized as much as possible to improve speed and reduce exposed
>>>> guest state. +
>>>> +
>>>> +Interrupt injection:
>>>> +
>>>> +Interrupt injection is safeguarded by the Ultravisor and, as KVM
>>>> lost +access to the VCPUs' lowcores, is handled via the format 4
>>>> state +description.
>>>> +
>>>> +Machine check, external, IO and restart interruptions each can be
>>>> +injected on SIE entry via a bit in the interrupt injection control
>>>> +field (offset 0x54). If the guest cpu is not enabled for the
>>>> interrupt +at the time of injection, a validity interception is
>>>> recognized. The +interrupt's data is transported via parts of the
>>>> interception data +block.   =20
>>>
>>> "Data associated with the interrupt needs to be placed into the
>>> respective fields in the interception data block to be injected into
>>> the guest."
>>>
>>> ? =20
>>
>> when a normal guest intercepts an exception, depending on the exceptio=
n
>> type, the parameters are saved in the state description at specified
>> offsets, between 0xC0 amd 0xF8
>>
>> to perform interrupt injection for secure guests, the same fields are
>> used to specify the interrupt parameters that should be injected into
>> the guest
>=20
> Ok, maybe add that as well.
>=20
>>
>>>> +
>>>> +Program and Service Call exceptions have another layer of
>>>> +safeguarding, they are only injectable, when instructions have
>>>> +intercepted into KVM and such an exception can be an emulation
>>>> result.   =20
>>>
>>> I find this sentence hard to parse... not sure if I understand it
>>> correctly.
>>>
>>> "They can only be injected if the exception can be encountered during=

>>> emulation of instructions that had been intercepted into KVM." =20
>> =20
>> yes
>>
>>>  =20
>>>> +
>>>> +
>>>> +Mask notification interceptions:
>>>> +As a replacement for the lctl(g) and lpsw(e) interception, two new
>>>> +interception codes have been introduced. One which tells us that
>>>> CRs +0, 6 or 14 have been changed and therefore interrupt masking
>>>> might +have changed. And one for PSW bit 13 changes. The CRs and
>>>> the PSW in   =20
>>>
>>> Might be helpful to mention that this bit covers machine checks, whic=
h
>>> do not get a separate bit in the control block :)
>>>  =20
>>>> +the state description only contain the mask bits and no further
>>>> info +like the current instruction address.   =20
>>>
>>> "The CRs and the PSW in the state description only contain the bits
>>> referring to interrupt masking; other fields like e.g. the current
>>> instruction address are zero." =20
>>
>> wait state is saved too
>>
>> CC is write only, and is only inspected by hardware/firmware when
>> KVM/qemu is interpreting an instruction that expects a new CC to be se=
t,
>> and then only the expected CCs are allowed (e.g. if an instruction onl=
y
>> allows CC 0 or 3, 2 cannot be specified)
>=20
> So I'm wondering how much of that should go into the document... maybe
> just
>=20
> "The CRs and the PSW in the state description contain less information
> than for normal guests: most information that does not refer to
> interrupt masking is not available to the hypervisor."
>=20
> ?
>=20

I'm not liking that too much and I'm also asking myself it makes sense
to fix documentation via mails. How about an etherpad?


--Gbvy7fHyJc1OJBZWCoKPUEg5fomA2FJ45--

--MBzN60MPSGru1NYgV1opQPDJwbSSjjNaG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3NgeQACgkQ41TmuOI4
ufgQLxAAp5Vke5I27CoSNJLZs1wwmAkPdq6/SqqNHGmSGWVHtXL4nbR4UlH4u11K
6XRBml3bDM1IzWkL4CR3wOvzz/AVOgif6iS37RlnmcQ+QxMlGHWDcjCGSObFSo2t
GqZjZ6+JskzIzQYahM/joBDEHCYHPn7djUNOzTj50vOui7aaR4XyL9MBKvKvmQ5x
5JsFqNYwFQMDQCMvgUsJFEG0MKMcaYUrE5qQ01IiDRee9wF5rQtj3x4gdCN2VBzt
wRpoSg6IR6Rs85LMUVh9pBE6Ytz9npvK0dRFHIAi+7mmZGW58m/eZxu4JWzjrW+t
f58HmamnVsyW88t6nuvB8aehuex8rBtr4d5BKOZl3iWx0KUs/7Czc8/k81IfQIoU
KKmYucwk8MEZnOBxESEO/dj0iHsSTpKqjbyaNP+7FJ86hnIJZPKNa/EJgnfTG4Wv
fQ4qmXvpMFtA77nbpn/dIYnWY1A+zjB4dyrhZHE4Q604Kp9N86gnLcl4naZSxihA
wrAU7bzk9YU/NHBhhbYB8Wrk2U+j/0vqgcjzN78n2sabQ0fmi8lGlmkgAqALNwiw
4y2049ArgIMKuI25+fc+B9KyjMKmzTqtBcRmlZhBv08lqk6lhN3a1OInuH7/msp1
F7ysv1EnkUBPqddyySZB+qVPmho1QyMtCC5jelGpYZlZfRAChrY=
=9wRV
-----END PGP SIGNATURE-----

--MBzN60MPSGru1NYgV1opQPDJwbSSjjNaG--

