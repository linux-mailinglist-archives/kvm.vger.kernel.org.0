Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD42FB0B60
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 11:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfILJ2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 05:28:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730218AbfILJ2O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Sep 2019 05:28:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8C9IE7s005704
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 05:28:12 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uyhj848tk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 05:28:12 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 12 Sep 2019 10:28:10 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Sep 2019 10:28:07 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8C9S6Kn24510618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 09:28:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 869CCAE064;
        Thu, 12 Sep 2019 09:28:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17400AE056;
        Thu, 12 Sep 2019 09:28:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.92.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Sep 2019 09:28:06 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Do not leak kernel stack data in the
 KVM_S390_INTERRUPT ioctl
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190912090050.20295-1-thuth@redhat.com>
 <6905df78-95f0-3d6d-aaae-910cd2d7a232@redhat.com>
 <253e67f6-0a41-13e8-4ca2-c651d5fcdb69@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 12 Sep 2019 11:28:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <253e67f6-0a41-13e8-4ca2-c651d5fcdb69@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RPvOYPwnVuIf8SY9NmEhIEE0AZLwMgBpN"
X-TM-AS-GCONF: 00
x-cbid: 19091209-0020-0000-0000-0000036B5BEE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091209-0021-0000-0000-000021C0ECBC
Message-Id: <1c8e5098-06fa-02b2-6af7-a356927ac5c4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909120099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RPvOYPwnVuIf8SY9NmEhIEE0AZLwMgBpN
Content-Type: multipart/mixed; boundary="cjG9B14QKHqLUU5MFwg4X6fAHDdTuBMQk";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc: Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <1c8e5098-06fa-02b2-6af7-a356927ac5c4@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: Do not leak kernel stack data in the
 KVM_S390_INTERRUPT ioctl
References: <20190912090050.20295-1-thuth@redhat.com>
 <6905df78-95f0-3d6d-aaae-910cd2d7a232@redhat.com>
 <253e67f6-0a41-13e8-4ca2-c651d5fcdb69@redhat.com>
In-Reply-To: <253e67f6-0a41-13e8-4ca2-c651d5fcdb69@redhat.com>

--cjG9B14QKHqLUU5MFwg4X6fAHDdTuBMQk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/12/19 11:20 AM, Thomas Huth wrote:
> On 12/09/2019 11.14, David Hildenbrand wrote:
>> On 12.09.19 11:00, Thomas Huth wrote:
>>> When the userspace program runs the KVM_S390_INTERRUPT ioctl to injec=
t
>>> an interrupt, we convert them from the legacy struct kvm_s390_interru=
pt
>>> to the new struct kvm_s390_irq via the s390int_to_s390irq() function.=

>>> However, this function does not take care of all types of interrupts
>>> that we can inject into the guest later (see do_inject_vcpu()). Since=
 we
>>> do not clear out the s390irq values before calling s390int_to_s390irq=
(),
>>> there is a chance that we copy unwanted data from the kernel stack
>>> into the guest memory later if the interrupt data has not been proper=
ly
>>> initialized by s390int_to_s390irq().
>>>
>>> Specifically, the problem exists with the KVM_S390_INT_PFAULT_INIT
>>> interrupt: s390int_to_s390irq() does not handle it, but the function
>>> __deliver_pfault_init() will later copy the uninitialized stack data
>>> from the ext.ext_params2 into the guest memory.
>>>
>>> Fix it by handling that interrupt type in s390int_to_s390irq(), too.
>>> And while we're at it, make sure that s390int_to_s390irq() now
>>> directly returns -EINVAL for unknown interrupt types, so that we
>>> do not run into this problem again in case we add more interrupt
>>> types to do_inject_vcpu() sometime in the future.
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  arch/s390/kvm/interrupt.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>>> index 3e7efdd9228a..165dea4c7f19 100644
>>> --- a/arch/s390/kvm/interrupt.c
>>> +++ b/arch/s390/kvm/interrupt.c
>>> @@ -1960,6 +1960,16 @@ int s390int_to_s390irq(struct kvm_s390_interru=
pt *s390int,
>>>  	case KVM_S390_MCHK:
>>>  		irq->u.mchk.mcic =3D s390int->parm64;
>>>  		break;
>>> +	case KVM_S390_INT_PFAULT_INIT:
>>> +		irq->u.ext.ext_params =3D s390int->parm;
>>> +		irq->u.ext.ext_params2 =3D s390int->parm64;
>>> +		break;
>>> +	case KVM_S390_RESTART:
>>> +	case KVM_S390_INT_CLOCK_COMP:
>>> +	case KVM_S390_INT_CPU_TIMER:
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>>  	}
>>>  	return 0;
>>>  }
>>>
>>
>> Wouldn't a safe fix be to initialize the struct to zero in the caller?=

>=20
> That's of course possible, too. But that means that we always have to
> zero out the whole structure, so that's a little bit more of overhead
> (well, it likely doesn't matter for such a legacy ioctl).

Or memset it in s390int_to_s390irq so the caller doesn't need to know.
That should be fast enough for such a small struct.

>=20
> But the more important question: Do we then still care of fixing the
> PFAULT_INIT interrupt here? Since it requires a parameter, the "case
> KVM_S390_INT_PFAULT_INIT:" part would be required here anyway.

Let's wait for Christian's opinion on that.


--cjG9B14QKHqLUU5MFwg4X6fAHDdTuBMQk--

--RPvOYPwnVuIf8SY9NmEhIEE0AZLwMgBpN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl16D6UACgkQ41TmuOI4
ufgeoBAApRNlMJkqvyukjvF8OKQUGVO8jXQeceq+WZwGKV6LX5cmJUlmBroHkHi8
Yjak7EbSLBK1PhZng0SHQXoFCBEteqLc3UjY+siwKk5DSPZMcdACFEZPbqDgI8NH
JFXJ9lnGa5bRDASY4vu//ujYWj5hppTrHSpDJoCbJJVDZAVIan1N/BF7/yR5qJdn
+pNM5PyQo4o3nl7MxarKhDy2l0jcvCnNDUWRbqaBu3CoWID1eh9xvqbmQBrYuFZ+
9Ds2wOhbN4yX06yPEw4JbNK8WfWuhSW3gPL09l4CAYU24rI0UWzNMPYfgps0Y1Sk
5VbAjOyUV39I8X8K2b0s2vcSV6TP1rDRg8d3wb9f4AjCJZ4wDRMFMpr44Lr5hBT+
sY9+3UdbBqmx1Ou4QMJJe1NvqpJomGVjR597Nohn2m6r3UcOqqApRAI+AHZnZzCu
5yEvw9fosFvnKgYD344OJ3CUYvxVZ/kMs+/0VnLxYWxdf+GpDNwjLZX9RhKwmFOx
rM/rt66dF0wJbmX2HQjRbdN8rwImo0oHxOwotGw1NKkCjE9Fn3hnJ0WhjK34VXJ0
nbBT3ojZbv2PH1nO0VrVVQkE3kRziq4JiiD0nDycTKPZGDTT8drgcoYbijVMNQoR
oCJ2bxwQu6lUjWg2Qt8QMsy1hZ07cIKjQBt1pm6igZxQXkFzYYg=
=JmeN
-----END PGP SIGNATURE-----

--RPvOYPwnVuIf8SY9NmEhIEE0AZLwMgBpN--

