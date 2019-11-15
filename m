Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E89CFDE8D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 14:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfKONG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 08:06:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727359AbfKONGz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 08:06:55 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFD2F0f128463
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 08:06:54 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9jttb3n7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 08:06:54 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 13:06:51 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 13:06:49 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFD6mhQ49217696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 13:06:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EFBEAE059;
        Fri, 15 Nov 2019 13:06:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8F42AE055;
        Fri, 15 Nov 2019 13:06:47 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 13:06:47 +0000 (GMT)
Subject: Re: [RFC 33/37] KVM: s390: Introduce VCPU reset IOCTL
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-34-frankja@linux.ibm.com>
 <e7a62927-7e0e-1309-d5ad-b4a59149bb6a@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 15 Nov 2019 14:06:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e7a62927-7e0e-1309-d5ad-b4a59149bb6a@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FInTHdGSJW5w35FgS19iuYyD6iNw8VEPw"
X-TM-AS-GCONF: 00
x-cbid: 19111513-0012-0000-0000-00000363E605
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111513-0013-0000-0000-0000219F638F
Message-Id: <fde8cd83-035e-5ef6-6b34-455857b3c579@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_03:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 suspectscore=3 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FInTHdGSJW5w35FgS19iuYyD6iNw8VEPw
Content-Type: multipart/mixed; boundary="iiJa9QxglP50i7DD6B7OdYg2HnQRFgyMt"

--iiJa9QxglP50i7DD6B7OdYg2HnQRFgyMt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/15/19 11:47 AM, Thomas Huth wrote:
> On 24/10/2019 13.40, Janosch Frank wrote:
>> With PV we need to do things for all reset types, not only initial...
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/kvm/kvm-s390.c | 53 +++++++++++++++++++++++++++++++++++++++=
+
>>  include/uapi/linux/kvm.h |  6 +++++
>>  2 files changed, 59 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d3fd3ad1d09b..d8ee3a98e961 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3472,6 +3472,53 @@ static int kvm_arch_vcpu_ioctl_initial_reset(st=
ruct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>> =20
>> +static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu,
>> +				     unsigned long type)
>> +{
>> +	int rc;
>> +	u32 ret;
>> +
>> +	switch (type) {
>> +	case KVM_S390_VCPU_RESET_NORMAL:
>> +		/*
>> +		 * Only very little is reset, userspace handles the
>> +		 * non-protected case.
>> +		 */
>> +		rc =3D 0;
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +					   UVC_CMD_CPU_RESET, &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET NORMAL VCPU: cpu %d rc %x rrc =
%x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>> +		break;
>> +	case KVM_S390_VCPU_RESET_INITIAL:
>> +		rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +				      UVC_CMD_CPU_RESET_INITIAL,
>> +				      &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET INITIAL VCPU: cpu %d rc %x rrc=
 %x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>> +		break;
>> +	case KVM_S390_VCPU_RESET_CLEAR:
>> +		rc =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>> +		if (kvm_s390_pv_handle_cpu(vcpu)) {
>> +			rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>> +					   UVC_CMD_CPU_RESET_CLEAR, &ret);
>> +			VCPU_EVENT(vcpu, 3, "PROTVIRT RESET CLEAR VCPU: cpu %d rc %x rrc %=
x",
>> +				   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
>> +		}
>> +		break;
>> +	default:
>> +		rc =3D -EINVAL;
>> +		break;
>=20
> (nit: you could drop the "break;" here)
>=20
>> +	}
>> +	return rc;
>> +}
>> +
>> +
>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_re=
gs *regs)
>>  {
>>  	vcpu_load(vcpu);
>> @@ -4633,8 +4680,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  		break;
>>  	}
>>  	case KVM_S390_INITIAL_RESET:
>> +		r =3D -EINVAL;
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm))
>> +			break;
>=20
> Wouldn't it be nicer to call
>=20
>   kvm_arch_vcpu_ioctl_reset(vcpu, KVM_S390_VCPU_RESET_INITIAL)
>=20
> in this case instead?

How about:
        case KVM_S390_INITIAL_RESET:


                arg =3D KVM_S390_VCPU_RESET_INITIAL;


        case KVM_S390_VCPU_RESET:


                r =3D kvm_arch_vcpu_ioctl_reset(vcpu, arg);


                break;



>=20
>>  		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>  		break;
>> +	case KVM_S390_VCPU_RESET:
>> +		r =3D kvm_arch_vcpu_ioctl_reset(vcpu, arg);
>> +		break;
>>  	case KVM_SET_ONE_REG:
>>  	case KVM_GET_ONE_REG: {
>>  		struct kvm_one_reg reg;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index f75a051a7705..2846ed5e5dd9 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1496,6 +1496,12 @@ struct kvm_pv_cmd {
>>  #define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc3, struct kvm_pv_cmd)
>>  #define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc4, struct kvm_pv_cmd)=

>> =20
>> +#define KVM_S390_VCPU_RESET_NORMAL	0
>> +#define KVM_S390_VCPU_RESET_INITIAL	1
>> +#define KVM_S390_VCPU_RESET_CLEAR	2
>> +
>> +#define KVM_S390_VCPU_RESET    _IO(KVMIO,   0xd0)
>=20
> Why not 0xc5 ?

Fixed

>=20
>  Thomas
>=20



--iiJa9QxglP50i7DD6B7OdYg2HnQRFgyMt--

--FInTHdGSJW5w35FgS19iuYyD6iNw8VEPw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3OoucACgkQ41TmuOI4
ufjbhRAAsCsc4E71QYJsHXgyeDy6TG8FUQibjsEErTL5eiwqmb+lkRVFN006f0JC
WFOdawfUnFyl4hCSczOU3hyfKIX0bTLdkbqFaUTREKj76Ug9vjRp14PCA7kOFYRs
a+lTRxh/K2WsONe3uC9lD6W4GIqeVEvj79eKiTFIHoJGI41nZq9xMwvVuvOdrPuL
qiUKeUxpUB4lJFT/m9D4KfxIbG0NWi1wh6iVhuUEPR5VeA2yjLU2THMfqJNtentC
T2sESQQN04sKsStAFSFoqBAaZ0Vx//BOYZkQvS1m+VqTbZZMef0PherD3RNoGcNS
lNiSpJVltap7Wzs5QrPxllSs7s7yCb9DtUBdWQHycM5ryPTOFN9nDB8MCGgJ/JN6
gMdSbMbjZ2CKYTlSWtzR6UsFy0GeTF5c3LUW53SBebKCrts61oTRf/V3YI30XPzy
4A4MTLbkMLTIcmJc+1m+gB4M6kAXKbb6+MpFPdWZmm78xWo5e6uRp50ePorXe4I/
+CaVqZjaoG9bg4e0TdA87awPQGWowDOq6tpnG3FFgieCV7RAlMkbmHNlbS1rgTKM
Pd1FejVD678Lh1fZ7afa98eSXBD9dGnsAPzz2FdMpqwTtoKwIiaIDi80GuCs9Yil
wNamewVUNpUvppGAR3De5eWeruVuC8gcqMowOhHIEc7ww800Mdc=
=IZyR
-----END PGP SIGNATURE-----

--FInTHdGSJW5w35FgS19iuYyD6iNw8VEPw--

