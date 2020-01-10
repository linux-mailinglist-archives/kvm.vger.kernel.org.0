Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E02136809
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 08:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgAJHOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 02:14:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47756 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbgAJHOb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 02:14:31 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A7Cess141607
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 02:14:30 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xea2k8j4x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 02:14:29 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 10 Jan 2020 07:14:28 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 07:14:25 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00A7EOnS50135086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 07:14:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E8B52050;
        Fri, 10 Jan 2020 07:14:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.153.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DD44452059;
        Fri, 10 Jan 2020 07:14:23 +0000 (GMT)
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
To:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200109155602.18985-1-frankja@linux.ibm.com>
 <20200109180841.6843cb92.cohuck@redhat.com>
 <f79b523e-f3e8-95b8-c242-1e7ca0083012@linux.ibm.com>
 <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 10 Jan 2020 08:14:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f18955c0-4002-c494-b14e-1b9733aad20e@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AqH1wuTRzmS75vwvntMdCDwO6DiXpSWSb"
X-TM-AS-GCONF: 00
x-cbid: 20011007-0020-0000-0000-0000039F7A1B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011007-0021-0000-0000-000021F6E100
Message-Id: <c0049bfb-9516-a382-c69c-0693cb0fbfda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AqH1wuTRzmS75vwvntMdCDwO6DiXpSWSb
Content-Type: multipart/mixed; boundary="ROCfofvATjlT9lp6GFcdErWzQ269k0nhI"

--ROCfofvATjlT9lp6GFcdErWzQ269k0nhI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/10/20 8:03 AM, Thomas Huth wrote:
> On 09/01/2020 18.51, Janosch Frank wrote:
>> On 1/9/20 6:08 PM, Cornelia Huck wrote:
>>> On Thu,  9 Jan 2020 10:56:01 -0500
>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>
>>>> The architecture states that we need to reset local IRQs for all CPU=

>>>> resets. Because the old reset interface did not support the normal C=
PU
>>>> reset we never did that on a normal reset.
>>>>
>>>> Let's implement an interface for the missing normal and clear resets=

>>>> and reset all local IRQs, registers and control structures as stated=

>>>> in the architecture.
>>>>
>>>> Userspace might already reset the registers via the vcpu run struct,=

>>>> but as we need the interface for the interrupt clearing part anyway,=

>>>> we implement the resets fully and don't rely on userspace to reset t=
he
>>>> rest.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>
>>>> I dropped the reviews, as I changed quite a lot. =20
>>>>
>>>> Keep in mind, that now we'll need a new parameter in normal and
>>>> initial reset for protected virtualization to indicate that we need =
to
>>>> do the reset via the UV call. The Ultravisor does only accept the
>>>> needed reset, not any subset resets.
>>>
>>> In the interface, or externally?
>>
>> ?
>>
>>>
>>> [Apologies, but the details of the protected virt stuff are no longer=

>>> in my cache.
>> Reworded explanation:
>> I can't use a fallthrough, because the UV will reject the normal reset=

>> if we do an initial reset (same goes for the clear reset). To address
>> this issue, I added a boolean to the normal and initial reset function=
s
>> which tells the function if it was called directly or was called becau=
se
>> of the fallthrough.
>>
>> Only if called directly a UV call for the reset is done, that way we c=
an
>> keep the fallthrough.
>=20
> Sounds complicated. And do we need the fallthrough stuff here at all?
> What about doing something like:

That would work and I thought about it, it just comes down to taste :-)
I don't have any strong feelings for a specific implementation.

>=20
> static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
> {
> 	...
> }
>=20
> static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
> {
> 	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> 	...
> }
>=20
> static int kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
> {
> 	kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> 	...
> }
>=20
> ...
>=20
> 	case KVM_S390_CLEAR_RESET:
> 		r =3D kvm_arch_vcpu_ioctl_clear_reset(vcpu);
> 		if (!r && protected) {
> 			r =3D uv_cmd_nodata(...,
>  				UVC_CMD_CPU_RESET_CLEAR, ...);
> 		}
> 		break;
>  	case KVM_S390_INITIAL_RESET:
>  		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> 		if (!r && protected) {
> 			r =3D uv_cmd_nodata(...,
>  				UVC_CMD_CPU_RESET_INITIAL, ...);
> 		}
> 	case KVM_S390_NORMAL_RESET:
> 		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> 		if (!r && protected) {
> 			r =3D uv_cmd_nodata(...,
>  				UVC_CMD_CPU_RESET, ...);
> 		}
>  		break;
>=20
> ... or does that not work due to some other constraints that I've misse=
d?
>=20
>  Thomas
>=20



--ROCfofvATjlT9lp6GFcdErWzQ269k0nhI--

--AqH1wuTRzmS75vwvntMdCDwO6DiXpSWSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4YJE8ACgkQ41TmuOI4
ufjcqA/+InBBT1PKzfrVe7smdEC70krE1wjBP2yuGeIEx2DXVEFOQjhZHYIFKW5y
DkVfdl3h+JU9m90Xl+qXtYdgol2pqpxq7/MfJW0lQwkcmwKaWADcSO7M+s6FSgQ6
zt/JI+rXUR7DNRbB/IJE15f8TcOn5ZHH+fsrpqlZ0cU1yk8CdwMdZpebWptY50l0
O/2DNQcix2AqsrQIaAInRylRrW6WB9yekpZfXJ4I7qyF+5KoIlsfqVVpsVb+UgGV
vCzSVBKtg+y3kbY5P6gAZNEPvIN58xRqIOjsNz+hTg9CAezaKMsoFXaYoLPqGbOJ
2LzI1ztQ9etXF4FbA0KMLsmNKbAW+qW/gVFFARuoyAXkNkDg1kc55lgez6wFV9Yt
leHJJJuaoL+0iUzRxLXZoy/Hcljgd4KwRHETvDFpCv4fs1afQ3+hDM5pNZPZFYd9
AEidNM1NhEhsq6xoIrR3yNXMMqYUzvh7PCDLkjl/YBPBBlgw5lv9cEPuLfs3xKyc
qiDBbWdQ4mJ3hM+Bx73CFEZjPv5STxLim0fzFImTGZDNsb+Q0nC8a2Glt3Xlz4y4
qyvacycQVlZDLlBMcbXFVq0r2OsKO3LRiB9saohQfznIzQ1WC+at38cEbsN/fGFb
6ZnDxRMPF4hu4wK+lckEJ6sig37Wjf1vbf8EFJbEcDaN2LSsKt8=
=zU4D
-----END PGP SIGNATURE-----

--AqH1wuTRzmS75vwvntMdCDwO6DiXpSWSb--

