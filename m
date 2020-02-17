Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE97161651
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 16:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgBQPiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 10:38:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728142AbgBQPiZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 10:38:25 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HFTba7164808
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 10:38:23 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6b55nq1u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 10:38:23 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 17 Feb 2020 15:38:21 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:38:18 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HFcEWM21037410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:38:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BED6AE058;
        Mon, 17 Feb 2020 15:38:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1952CAE055;
        Mon, 17 Feb 2020 15:38:14 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:38:13 +0000 (GMT)
Subject: Re: [PATCH v2 20/42] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-21-borntraeger@de.ibm.com>
 <ad84934a-3d18-d56e-5658-1d8b8292f6b3@redhat.com>
 <d16b7ba2-38fc-5128-bd40-587d96e7936f@linux.ibm.com>
 <f98d702f-1e71-c051-6bd0-efb639658822@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 17 Feb 2020 16:38:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f98d702f-1e71-c051-6bd0-efb639658822@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PxVEJGBXDqaTjsKXym4MNK2zGI1jn7SFx"
X-TM-AS-GCONF: 00
x-cbid: 20021715-0008-0000-0000-00000353D162
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-0009-0000-0000-00004A74D7E7
Message-Id: <17ed7342-0bf9-2697-8475-813de72d30b1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_10:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PxVEJGBXDqaTjsKXym4MNK2zGI1jn7SFx
Content-Type: multipart/mixed; boundary="02GUYYd1Ws0ow40DslifhwNU77OMKBRK0"

--02GUYYd1Ws0ow40DslifhwNU77OMKBRK0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/17/20 4:00 PM, Christian Borntraeger wrote:
>=20
>=20
> On 17.02.20 15:47, Janosch Frank wrote:
>> On 2/17/20 12:08 PM, David Hildenbrand wrote:
>>>> @@ -4460,6 +4489,10 @@ static long kvm_s390_guest_mem_op(struct kvm_=
vcpu *vcpu,
>>>> =20
>>>>  	switch (mop->op) {
>>>>  	case KVM_S390_MEMOP_LOGICAL_READ:
>>>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>>>> +			r =3D -EINVAL;
>>>> +			break;
>>>> +		}
>>>
>>> Could we have a possible race with disabling code, especially while
>>> concurrently freeing? (sorry if I ask again, there was just a flood o=
f
>>> emails)
>=20
> see my other reply. Hopefully fixed soon.[...]
>=20
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index 207915488502..0fdee1bc3798 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -475,11 +475,15 @@ struct kvm_s390_mem_op {
>>>>  	__u32 op;		/* type of operation */
>>>>  	__u64 buf;		/* buffer in userspace */
>>>>  	__u8 ar;		/* the access register number */
>>>> -	__u8 reserved[31];	/* should be set to 0 */
>>>> +	__u8 reserved21[3];	/* should be set to 0 */
>>>> +	__u32 sida_offset;	/* offset into the sida */
>>>> +	__u8 reserved28[24];	/* should be set to 0 */
>>>>  };
>>>
>>> As discussed, I'd prefer an overlaying layout for the sida, as the ar=

>>> does not make any sense (correct me if I'm wrong :) )
>>
>> That wouldn't work, because we still check mop->ar < 16 in
>> kvm_s390_guest_mem_op(). Also we currently check mop contents twice
>> because we overload mem_op() with the SIDA operations.
>>
>> Using a separate IOCTL is cleaner...
>=20
> I would rather use the current patch instead of adding a new ioctl.
>=20

Well, then I'd suggest moving the normal memop ops into an own function
and also move the ar check into there.


--02GUYYd1Ws0ow40DslifhwNU77OMKBRK0--

--PxVEJGBXDqaTjsKXym4MNK2zGI1jn7SFx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl5Ks2UACgkQ41TmuOI4
ufhKuxAAsO2ZBbJEip0Fp9U503WSqbKx33pab/DktprmCihGIdaTRn+FD3g/iRh2
lWbRFSjT3yE9FfY1xI+geBb+hP7fym3GEVZDr599sbzJU1V1TvaTEwWWIGcRRoOq
eJp+31+GMin0HCzK7+IAlJ8ZQ/Somn7mQ9tnnZgY6UanzHg0u3Ua2farEsB4ZElZ
Z5dnB+xiqqkmhezsNHNAKgKvHeSNlBuq5BZRK+zgVFahDiZENDtZl/ZI7fTAsU0K
vqIiyikiAIla7tz12NLijk35C/A3QkkwoEqvFFecikazZxwH8NReyrlnqc6C5I0/
F1VgAHQwBmxaZDygBNEC3mxWMcTD/78lSZ/OPunnE5nrEUKqT0wGc7gvessvxmHM
5f0Fequc5QqO9hkKqeBVGoJtnFIJJ8Bi+HeRZb50/1X7bp/6XYkhGorIL1Gu5fgo
y2iObT78hZ6tN0ywrO2mr0yFyn/VmevkQpGNJGQeM9rHTqJPAOg5tKltlvUhywIk
mUwB/7SmT5lncx8rw4FcpVdicFHqu8Pt0Qfr0c2hNkdWNDRX97AaZfclCyT3yII+
ZapdPB/BxK/ZT2lv41YHANpsWReCpMO2XGeemXDnFRg16MhX90b8ZpUuRssXfYgZ
RpEvESwcrVdGwBCkT99gWtBAMkn7Z0tO5qA/isdL8za/jed2W3o=
=1eVJ
-----END PGP SIGNATURE-----

--PxVEJGBXDqaTjsKXym4MNK2zGI1jn7SFx--

