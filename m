Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5271710D728
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 15:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfK2Ojs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 09:39:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfK2Ojs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 09:39:48 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xATEdgvE121891
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:39:47 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wje2jsj3k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 09:39:46 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 29 Nov 2019 14:38:11 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 14:38:07 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xATEc6PI38731926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 14:38:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5ECEFA4053;
        Fri, 29 Nov 2019 14:38:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F308BA404D;
        Fri, 29 Nov 2019 14:38:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.188.128])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Nov 2019 14:38:05 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Add new reset vcpu API
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191129142122.21528-1-frankja@linux.ibm.com>
 <bc1d057f-03a0-b850-dff8-a7156bfe3274@redhat.com>
 <8e1aa1af-d929-e36b-f341-aa7dbe27f6a4@linux.ibm.com>
 <227a8fce-7e14-030e-b0a4-17e4521eed98@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 29 Nov 2019 15:38:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <227a8fce-7e14-030e-b0a4-17e4521eed98@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="O7ZyLn69Q7iRXtPD42loc0ahgJtYCs7ZN"
X-TM-AS-GCONF: 00
x-cbid: 19112914-0008-0000-0000-00000339F277
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112914-0009-0000-0000-00004A5902D6
Message-Id: <dedd1d55-bebb-059e-c8c9-7c2771afa157@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_04:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O7ZyLn69Q7iRXtPD42loc0ahgJtYCs7ZN
Content-Type: multipart/mixed; boundary="5PhmEEphpWeC52LNOo9hagPm6Jzf7QKO3"

--5PhmEEphpWeC52LNOo9hagPm6Jzf7QKO3
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/29/19 3:33 PM, David Hildenbrand wrote:
> On 29.11.19 15:33, Janosch Frank wrote:
>> On 11/29/19 3:31 PM, David Hildenbrand wrote:
>>> On 29.11.19 15:21, Janosch Frank wrote:
>>>> The architecture states that we need to reset local IRQs for all CPU=

>>>> resets. Because the old reset interface did not support the normal C=
PU
>>>> reset we never did that.
>>>>
>>>> Now that we have a new interface, let's properly clear out local IRQ=
s
>>>> and let this commit be a reminder.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++++++++-
>>>>  include/uapi/linux/kvm.h |  7 +++++++
>>>>  2 files changed, 31 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index d9e6bf3d54f0..2f74ff46b176 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm=
, long ext)
>>>>  	case KVM_CAP_S390_CMMA_MIGRATION:
>>>>  	case KVM_CAP_S390_AIS:
>>>>  	case KVM_CAP_S390_AIS_MIGRATION:
>>>> +	case KVM_CAP_S390_VCPU_RESETS:
>>>>  		r =3D 1;
>>>>  		break;
>>>>  	case KVM_CAP_S390_HPAGE_1M:
>>>> @@ -3293,6 +3294,25 @@ static int kvm_arch_vcpu_ioctl_initial_reset(=
struct kvm_vcpu *vcpu)
>>>>  	return 0;
>>>>  }
>>>> =20
>>>> +static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu, unsigne=
d long type)
>>>> +{
>>>> +	int rc =3D -EINVAL;
>>>> +
>>>> +	switch (type) {
>>>> +	case KVM_S390_VCPU_RESET_NORMAL:
>>>> +		rc =3D 0;
>>>> +		kvm_clear_async_pf_completion_queue(vcpu);
>>>> +		kvm_s390_clear_local_irqs(vcpu);
>>>> +		break;
>>>> +	case KVM_S390_VCPU_RESET_INITIAL:
>>>> +		/* fallthrough */
>>>> +	case KVM_S390_VCPU_RESET_CLEAR:
>>>> +		rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>>
>>> As we now have two interfaces to achieve the same thing (initial rese=
t),
>>> I do wonder if we should simply introduce
>>>
>>> KVM_S390_NORMAL_RESET
>>> KVM_S390_CLEAR_RESET
>>>
>>> instead ...
>>>
>>> Then you can do KVM_S390_NORMAL_RESET for the bugfix and
>>> KVM_S390_CLEAR_RESET later for PV.
>>>
>>> Does anything speak against that?
>>
>> Apart from loosing one more ioctl number probably not
>=20
> Do we care? (I think not, but maybe I am missing something :) )
>=20

I don't, maybe somebody else does
Btw. I'm struggling to find a good name for the capability:
KVM_CAP_S390_VCPU_ADDITIONAL_RESETS ?


--5PhmEEphpWeC52LNOo9hagPm6Jzf7QKO3--

--O7ZyLn69Q7iRXtPD42loc0ahgJtYCs7ZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3hLU0ACgkQ41TmuOI4
ufhIAw//Yb+eOtFEGZnQsCfQ75MFU416FSQXZr3hHiGoSE6I8mjcJDuxcZF4SLPK
DPL2mR0GYGuwcrYa5HtzTLhK3yf8rQeV3OT5ldDs8/kfMMRULWQpdjufezfpPQnP
U7X/uDOpZzlYiyquSgWh2iwtj5JZipAkZaZo2otrj3ce1BRTcQBm6SdHMorltCgf
69tYKFEYhNRlYqhAveADDWX/OE+7MfbhV6MWvntWgAlAxMlXNgLypy7OWaV/oAma
gNPLqIWD/fy1yo18Ma0p7Kw8Qs8pGVaKWRLuPY7g1uEjpHqHmaPmxvAfF5GvsXSf
Ys9fY5rDM6tnGoPomF6I8zYrKOiFI/GL4YPefpHCxn5rLBXZmMSsYI9uPsJlH43p
LQDtYIsfEaxchi26luXAj0FpqUenZycRX4TA8mii4HZNg1N/U7IntH1WXBKszsG+
q/Ca87u/H0w8tdDYms/S/MQSzOLpEj7m0cZsIQ4TF09hTmmJy/XsfAevC3TglART
9XJjk7hl2JBTD/YsSjZTQYKE2KM+kVF8ZFGUwAmYP7TuO4KPiuBlU7WyV3siz7i2
tNa/wxAhM7FHZ+r3iantOrrsfRXZv7xPVp1Hif73GL3URkqzGR12ZPSZm1o4p0CJ
Y8vEFr0HTWsUqlffJr7DUr2KcOeCWnRDHgeCuPShD2gHSgu8ajc=
=SZ+G
-----END PGP SIGNATURE-----

--O7ZyLn69Q7iRXtPD42loc0ahgJtYCs7ZN--

