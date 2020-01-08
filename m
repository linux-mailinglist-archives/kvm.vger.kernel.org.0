Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029C913453B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 15:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgAHOmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 09:42:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726697AbgAHOmv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 09:42:51 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008EglMQ071170
        for <kvm@vger.kernel.org>; Wed, 8 Jan 2020 09:42:49 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xdeayx9c2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:42:48 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 8 Jan 2020 14:42:34 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Jan 2020 14:42:30 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 008EgT3d43385168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 14:42:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A364D42042;
        Wed,  8 Jan 2020 14:42:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7220542041;
        Wed,  8 Jan 2020 14:42:29 +0000 (GMT)
Received: from dyn-9-152-224-51.boeblingen.de.ibm.com (unknown [9.152.224.51])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 14:42:29 +0000 (GMT)
Subject: Re: [PATCH v3] KVM: s390: Add new reset vcpu API
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191205120956.50930-1-frankja@linux.ibm.com>
 <dd724da0-9bba-079e-6b6f-756762dbc942@de.ibm.com>
 <3b37f523-d67f-ba6c-8e14-77183f73a58a@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 8 Jan 2020 15:42:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3b37f523-d67f-ba6c-8e14-77183f73a58a@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s16VNpgLwBoSSHNUICg803qFy8EVHnIEJ"
X-TM-AS-GCONF: 00
x-cbid: 20010814-0008-0000-0000-00000347A0BD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010814-0009-0000-0000-00004A67E4F1
Message-Id: <12d48cb4-40be-3044-d417-debceddcf011@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_03:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s16VNpgLwBoSSHNUICg803qFy8EVHnIEJ
Content-Type: multipart/mixed; boundary="zWs3JpglHZLx1Cp2bLz70nnMm5WHvIMlC"

--zWs3JpglHZLx1Cp2bLz70nnMm5WHvIMlC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/8/20 3:35 PM, Christian Borntraeger wrote:
>=20
>=20
> On 08.01.20 15:28, Christian Borntraeger wrote:
>>
>>
>> On 05.12.19 13:09, Janosch Frank wrote:
>> [...]
>>> +4.123 KVM_S390_CLEAR_RESET
>>> +
>>> +Capability: KVM_CAP_S390_VCPU_RESETS
>>> +Architectures: s390
>>> +Type: vcpu ioctl
>>> +Parameters: none
>>> +Returns: 0
>>> +
>>> +This ioctl resets VCPU registers and control structures that QEMU
>>> +can't access via the kvm_run structure. The clear reset is a superse=
t
>>> +of the initial reset and additionally clears general, access, floati=
ng
>>> +and vector registers.
>>
>> As Thomas outlined, make it more obvious that userspace does the remai=
ning
>> parts. I do not think that we want the kernel to do the things (unless=
 it
>> helps you in some way for the ultravisor guests)
>=20
> On the other hand. todays initial cpu reset DOES everything. So I guess=

> the other ones should do the same. That actually makes the semantics cl=
earer -
> when you call it it will have done whatever reset you have asked for.

Ok, will do, thanks for the clearup

>=20
>=20
>>
>> [...]
>>> =20
>>> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>>> +{
>>> +	kvm_clear_async_pf_completion_queue(vcpu);
>>> +	kvm_s390_clear_local_irqs(vcpu);
>>> +	return 0;
>>
>> Shouldnt we also do=20
>>         if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>>                 kvm_s390_vcpu_stop(vcpu);
>>
>> here?
>>
>>
>>> +}
>>> +
>>>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>>  {
>>>  	kvm_s390_vcpu_initial_reset(vcpu);
>>> @@ -4363,9 +4371,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>>  		r =3D kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>>>  		break;
>>>  	}
>>> +
>>> +	case KVM_S390_CLEAR_RESET:
>>> +		/* fallthrough */
>>>  	case KVM_S390_INITIAL_RESET:
>>>  		r =3D kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>>  		break;
>>
>> Then we could also do a fallthrough here and do:
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d9e6bf3..c715ae3 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2867,10 +2867,6 @@ static void kvm_s390_vcpu_initial_reset(struct =
kvm_vcpu *vcpu)
>>         vcpu->arch.sie_block->pp =3D 0;
>>         vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>>         vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
>> -       kvm_clear_async_pf_completion_queue(vcpu);
>> -       if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>> -               kvm_s390_vcpu_stop(vcpu);
>> -       kvm_s390_clear_local_irqs(vcpu);
>>  }
>> =20
>>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>
>>
>>
>>
>>> +	case KVM_S390_NORMAL_RESET:
>>> +		r =3D kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>>> +		break;
>>>  	case KVM_SET_ONE_REG:
>>>  	case KVM_GET_ONE_REG: {
>=20



--zWs3JpglHZLx1Cp2bLz70nnMm5WHvIMlC--

--s16VNpgLwBoSSHNUICg803qFy8EVHnIEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4V6lUACgkQ41TmuOI4
ufgCMQ/6AkBkCw6oX1vSOWmARTZABYD2992zCpZ7ZomAKJl8OqWnI0oSV61b4EbN
z4ZjlrH4V2TPMaftuCbiqbOt4MPVOd/wYA9cT0Ir7rZde5MznJ5ZRdr9WIyVlf9B
LoezAreXU4M2Csmh84Uf2YKo/auNVC4H1dT8JpWNwVvLSJUPiax/uK4KC7ol47WB
W7/BiM9m+afK1FUjGJmRVkW7v4Pifh08ShPT7oxPIEofOq6qaoabv3kqeubcD7me
L4iPwOHsgUdB0ZrIoJZCiuuVCtEF3vCWvtrVSbDbN8dJbT6UZyw8Bn6lwWicXGpl
KdzTyObwiqj8h5WJ2WKWYy31XjOyWjMARFvkZERO270RcSg09gINPOYil2FPtb7+
p329l8ug8/dy662EputbCVqGefbYT2ud/BhUbZNn10rmfzQV6F/aKfFqOJslMGVO
39194Nz1hsNJu3+QvltiO2aVd8rE5ILs+2lSW2iqDmdTFAo5N1yNDaAtYBgKeyWY
LMLM3C0aGkH4uuVWvgNZe6PLp0uvNYyJfA9Gxv5cIzJmOjOzLS8oGvEUaIkTrjRs
XEyoA4EnIenxfECMHLOY/VIiHfSuMI1lCUgvMxWfzoFoxpWWx8OeM0jYr07M3WCV
xX8J0Gv7ZO5NLF/Gp18rx4/LrKlFyhjaAxyE+KjCG/XGVsmZ9gA=
=+zyq
-----END PGP SIGNATURE-----

--s16VNpgLwBoSSHNUICg803qFy8EVHnIEJ--

