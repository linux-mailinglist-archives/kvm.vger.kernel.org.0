Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD80A14DC8B
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgA3OLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:11:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbgA3OLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 09:11:03 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UE99gK111983
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 09:11:03 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xue971qn1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 09:11:02 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 14:11:00 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 14:10:57 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UEAuVE44236936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 14:10:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA752A405F;
        Thu, 30 Jan 2020 14:10:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9771AA405B;
        Thu, 30 Jan 2020 14:10:56 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 14:10:56 +0000 (GMT)
Subject: Re: [PATCH v8 2/4] selftests: KVM: Add fpu and one reg set/get
 library functions
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-3-frankja@linux.ibm.com>
 <72ff36e1-9170-dfb0-4050-f398f9a467eb@redhat.com>
 <20200130135512.diyyu3wvwqlwpqlx@kamzik.brq.redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 30 Jan 2020 15:10:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200130135512.diyyu3wvwqlwpqlx@kamzik.brq.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F90N2UgJRM9jKCWTGktKxesdld9lYnfGG"
X-TM-AS-GCONF: 00
x-cbid: 20013014-0016-0000-0000-000002E2312F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013014-0017-0000-0000-00003344FBC9
Message-Id: <9d9e0e7a-b006-98b1-6bf0-8c46006835bc@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_04:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=3 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F90N2UgJRM9jKCWTGktKxesdld9lYnfGG
Content-Type: multipart/mixed; boundary="3qn7yA9kyZYG3nohlLHuHJgXuVItI9ozd"

--3qn7yA9kyZYG3nohlLHuHJgXuVItI9ozd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/30/20 2:55 PM, Andrew Jones wrote:
> On Thu, Jan 30, 2020 at 11:36:21AM +0100, Thomas Huth wrote:
>> On 29/01/2020 21.03, Janosch Frank wrote:
>>> Add library access to more registers.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
>>>  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++=
++
>>>  2 files changed, 54 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/t=
esting/selftests/kvm/include/kvm_util.h
>>> index 29cccaf96baf..ae0d14c2540a 100644
>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>>> @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t =
vcpuid,
>>>  		    struct kvm_sregs *sregs);
>>>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>>>  		    struct kvm_sregs *sregs);
>>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
>>> +		  struct kvm_fpu *fpu);
>>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
>>> +		  struct kvm_fpu *fpu);
>>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one=
_reg *reg);
>>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one=
_reg *reg);
>>>  #ifdef __KVM_HAVE_VCPU_EVENTS
>>>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>>>  		     struct kvm_vcpu_events *events);
>>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testi=
ng/selftests/kvm/lib/kvm_util.c
>>> index 41cf45416060..dae117728ec6 100644
>>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>>> @@ -1373,6 +1373,54 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_=
t vcpuid, struct kvm_sregs *sregs)
>>>  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
>>>  }
>>> =20
>>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu=
 *fpu)
>>> +{
>>> +	struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
>>> +	int ret;
>>> +
>>> +	TEST_ASSERT(vcpu !=3D NULL, "vcpu not found, vcpuid: %u", vcpuid);
>>> +
>>> +	ret =3D ioctl(vcpu->fd, KVM_GET_FPU, fpu);
>>> +	TEST_ASSERT(ret =3D=3D 0, "KVM_GET_FPU failed, rc: %i errno: %i",
>>> +		    ret, errno);
>>> +}
>>> +
>>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu=
 *fpu)
>>> +{
>>> +	struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
>>> +	int ret;
>>> +
>>> +	TEST_ASSERT(vcpu !=3D NULL, "vcpu not found, vcpuid: %u", vcpuid);
>>> +
>>> +	ret =3D ioctl(vcpu->fd, KVM_SET_FPU, fpu);
>>> +	TEST_ASSERT(ret =3D=3D 0, "KVM_SET_FPU failed, rc: %i errno: %i",
>>> +		    ret, errno);
>>> +}
>>> +
>>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one=
_reg *reg)
>>> +{
>>> +	struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
>>> +	int ret;
>>> +
>>> +	TEST_ASSERT(vcpu !=3D NULL, "vcpu not found, vcpuid: %u", vcpuid);
>>> +
>>> +	ret =3D ioctl(vcpu->fd, KVM_GET_ONE_REG, reg);
>>> +	TEST_ASSERT(ret =3D=3D 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i=
",
>>> +		    ret, errno);
>>> +}
>>> +
>>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one=
_reg *reg)
>>> +{
>>> +	struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
>>> +	int ret;
>>> +
>>> +	TEST_ASSERT(vcpu !=3D NULL, "vcpu not found, vcpuid: %u", vcpuid);
>>> +
>>> +	ret =3D ioctl(vcpu->fd, KVM_SET_ONE_REG, reg);
>>> +	TEST_ASSERT(ret =3D=3D 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i=
",
>>> +		    ret, errno);
>>> +}
>>> +
>>>  /*
>>>   * VCPU Ioctl
>>>   *
>>>
>>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>
>=20
> How about what's below instead. It should be equivalent.

With your proposed changes we loose a bit verbosity in the error
messages. I need to think about which I like more.

>=20
> Thanks,
> drew
>=20
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/tes=
ting/selftests/kvm/include/kvm_util.h
> index 29cccaf96baf..d96a072e69bf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -125,6 +125,31 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vc=
puid,
>  		    struct kvm_sregs *sregs);
>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		    struct kvm_sregs *sregs);
> +
> +static inline void
> +vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
> +}
> +
> +static inline void
> +vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
> +}
> +
> +static inline void
> +vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *r=
eg)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
> +}
> +
> +static inline void
> +vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *r=
eg)
> +{
> +	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
> +}
> +
>  #ifdef __KVM_HAVE_VCPU_EVENTS
>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>  		     struct kvm_vcpu_events *events);
>=20



--3qn7yA9kyZYG3nohlLHuHJgXuVItI9ozd--

--F90N2UgJRM9jKCWTGktKxesdld9lYnfGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4y4/AACgkQ41TmuOI4
ufhTBBAAgQuSqyT9u3OkxSaggV8NMVmd7uNO0C4sbFFM0bC1wmXPtLwir82e1QDA
Q9zQKsLzLhIKbuSV3GFXWYnunRk9yk5brGzKMpPijSIhpsjZdaModGklCMTord8y
av518MqVsI8SZKLk5fwGqzRvjH4zOu4kEalDV5ZZ8hAYjdMpgg/OgyFpFrYpH5xp
eAHyVo7JclKZF3DBff/vLddD/4dj/qBJRW8ls6AeibCz1FKSX20ROn7u6ElOEchz
htJSnx84ikg5cLD64hWeU4QTv8ekFenyL3mN/agdoJ97BnqiT7lutHKHO84fxYI9
sJ+YK+Wv5zas3x62W/Swg8qEB6TegciR5gwTqKXyR8ddlsFjjv2mJrJzCQGWYRcr
c+OAAAvZVk//xn8UzMLzEoOrYAwUZUb2ie49tt9OI394gPjksojy0uOI+j2/5+AQ
EpWjPGY4uV4hTpaXO8g67e2Bbfuxj4mZglU/rg7djgkNW+PpWxClQzByjMijhVP8
U8+4VVSwRVyPMV9hdVFlU68YeFIVubPNgHkqrMptMJzzk3c+8iutPjLNImfzG29O
QRav8LxCplpcqdhTVt7am4G5/r8O4y75ov9aYFWP69q1RU87lY3Bb6QMGGpavTv0
tgVBH1siRq1HllNkfe5veB+hzPqXbdlhICz+ykrNaCfWAWvqcsg=
=jcZ2
-----END PGP SIGNATURE-----

--F90N2UgJRM9jKCWTGktKxesdld9lYnfGG--

