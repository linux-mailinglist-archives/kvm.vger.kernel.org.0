Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0D1D2AAE
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgENIwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:52:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37043 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbgENIwk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 04:52:40 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E8XeCn062999;
        Thu, 14 May 2020 04:52:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310t9n5tdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 04:52:38 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04E8Y5oa064781;
        Thu, 14 May 2020 04:52:38 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 310t9n5td7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 04:52:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04E8oLJi013874;
        Thu, 14 May 2020 08:52:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3100ub38te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 08:52:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04E8qXDp63897612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 08:52:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7F1AA405D;
        Thu, 14 May 2020 08:52:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15BA7A404D;
        Thu, 14 May 2020 08:52:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.183.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 May 2020 08:52:33 +0000 (GMT)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Thomas Huth <thuth@redhat.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
Date:   Thu, 14 May 2020 10:52:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VjgOWtZg7w4SqUZIQPJ8NS0aVF4aauNvv"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_01:2020-05-13,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 cotscore=-2147483648 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VjgOWtZg7w4SqUZIQPJ8NS0aVF4aauNvv
Content-Type: multipart/mixed; boundary="rPAJjeY4rSxZbyGBv8MDXXEaQCskEJr0u"

--rPAJjeY4rSxZbyGBv8MDXXEaQCskEJr0u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/14/20 9:53 AM, Thomas Huth wrote:
> On 14/05/2020 00.15, Collin Walling wrote:
>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>> be intercepted by SIE and handled via KVM. Let's introduce some
>> functions to communicate between userspace and KVM via ioctls. These
>> will be used to get/set the diag318 related information, as well as
>> check the system if KVM supports handling this instruction.
>>
>> This information can help with diagnosing the environment the VM is
>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>
>> By default, this feature is disabled and can only be enabled if a
>> user space program (such as QEMU) explicitly requests it.
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block
>> and a copy is retained in each VCPU. The Control Program Version
>> Code (CPVC) is not designed to be stored in the SIE block, so we
>> retain a copy in each VCPU next to the CPNC.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>  arch/s390/kvm/kvm-s390.c              | 89 ++++++++++++++++++++++++++=
+
>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>  arch/s390/kvm/vsie.c                  |  2 +
>>  7 files changed, 151 insertions(+), 1 deletion(-)
> [...]
>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>> index 563429dece03..3caed4b880c8 100644
>> --- a/arch/s390/kvm/diag.c
>> +++ b/arch/s390/kvm/diag.c
>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcp=
u *vcpu)
>>  	return ret < 0 ? ret : 0;
>>  }
>> =20
>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned int reg =3D (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>> +	u64 info =3D vcpu->run->s.regs.gprs[reg];
>> +
>> +	if (!vcpu->kvm->arch.use_diag318)
>> +		return -EOPNOTSUPP;
>> +
>> +	vcpu->stat.diagnose_318++;
>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>> +
>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
>> +
>> +	return 0;
>> +}
>> +
>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>  {
>>  	int code =3D kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>  		return __diag_page_ref_service(vcpu);
>>  	case 0x308:
>>  		return __diag_ipl_functions(vcpu);
>> +	case 0x318:
>> +		return __diag_set_diag318_info(vcpu);
>>  	case 0x500:
>>  		return __diag_virtio_hypercall(vcpu);
>=20
> I wonder whether it would make more sense to simply drop to userspace
> and handle the diag 318 call there? That way the userspace would always=

> be up-to-date, and as we've seen in the past (e.g. with the various SIG=
P
> handling), it's better if the userspace is in control... e.g. userspace=

> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
> guest just executed the diag 318 instruction.
>=20
> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
> could also be simply used by the diag 318 handler in userspace?
>=20
>>  	default:
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d05bb040fd42..c3eee468815f 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -159,6 +159,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D=
 {
>>  	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
>>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
>> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>>  	{ NULL }
>> @@ -1243,6 +1244,76 @@ static int kvm_s390_get_tod(struct kvm *kvm, st=
ruct kvm_device_attr *attr)
>>  	return ret;
>>  }
>> =20
>> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	int i;
>> +
>> +	kvm->arch.diag318_info.val =3D info;
>> +
>> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
>> +		 kvm->arch.diag318_info.cpnc, kvm->arch.diag318_info.cpvc);
>> +
>> +	if (sclp.has_diag318) {
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			vcpu->arch.sie_block->cpnc =3D kvm->arch.diag318_info.cpnc;
>> +		}
>> +	}
>> +}
>> +
>> +static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_at=
tr *attr)
>> +{
>> +	int ret;
>> +	u64 diag318_info;
>> +
>> +	switch (attr->attr) {
>> +	case KVM_S390_VM_MISC_ENABLE_DIAG318:
>> +		kvm->arch.use_diag318 =3D 1;
>> +		ret =3D 0;
>> +		break;
>=20
> Would it make sense to set kvm->arch.use_diag318 =3D 1 during the first=

> execution of KVM_S390_VM_MISC_DIAG318 instead, so that we could get
> along without the KVM_S390_VM_MISC_ENABLE_DIAG318 ?

I'm not an expert in feature negotiation, but why isn't this a cpu
feature like sief2 instead of a attribute?

@David?

>=20
>> +	case KVM_S390_VM_MISC_DIAG318:
>> +		ret =3D -EFAULT;
>> +		if (!kvm->arch.use_diag318)
>> +			return -EOPNOTSUPP;
>> +		if (get_user(diag318_info, (u64 __user *)attr->addr))
>> +			break;
>> +		kvm_s390_set_diag318_info(kvm, diag318_info);
>> +		ret =3D 0;
>> +		break;
>> +	default:
>> +		ret =3D -ENXIO;
>> +		break;
>> +	}
>> +	return ret;
>> +}
>=20
> What about a reset of the guest VM? If a user first boots into a Linux
> kernel that supports diag 318, then reboots and selects a Linux kernel
> that does not support diag 318? I'd expect that the cpnc / cpnv values
> need to be cleared here somewhere? Otherwise the information might not
> be accurate anymore?

He resets via QEMU on a machine reset.

>=20
>  Thomas
>=20



--rPAJjeY4rSxZbyGBv8MDXXEaQCskEJr0u--

--VjgOWtZg7w4SqUZIQPJ8NS0aVF4aauNvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl69BtAACgkQ41TmuOI4
ufgDfA/+MWund0H2pDnNaNlJB5A5YO3doYK4we8YKa0asvnM4/L+jf6FXcNkpuOq
6QvJnAHXjegYEzYBNJEwQ6ZNeODrdCia2+gO6T5Adk3Is2pB71uCFM1t+r338AB+
I+K8lFocCoLDbsr7iaLY+s4A3tAngFKSYj7f1KxMg2gYDPtdR/wfTkixuB53rq98
/Xnz6fLuuWOXwLnzzzl/pe0TvMPZK7qrmKPx+OSCCWcf46qekSHpvzrNjpan3V4e
xQGgqPMzIYvDi69yaGcxTi1by8ciDRUnGRNNleAo4vSmydUA2rKapZm9J0BCvQvM
Vr4oWrJEqK0wxk/j9xl7Hr2D+6zxv1kziXNHVYpItPpC2AhdF7B8uPo3qr5c222l
XuzVM9eDJPLnnzBFhJAuNVATn4DcfMrgu0st462nrqPr+iwrln3xMBf5dH0wQ+6w
quoMtNxbTIXmpf1Ams5MH2PGVE6YPwmjyFamJnE3ZgLcuP1SiEYUNi9akLfecWkN
WpUvDQuBkLzhMmdAeSNpu3lflORDPPekJAWNIoLVEoWa/6Rr67TY6942B1z4xZJ8
fM9SuFEJgGuK1vAnlbz2sYwQxbyOYkif5KJIetS22BPRqSZSa+e4v6FMT39Y2Pxk
nBuViViS/MJZsUrLvA2tQOoJhCCrYR2YYKfwY5c7pGi1EBlytJQ=
=Jib6
-----END PGP SIGNATURE-----

--VjgOWtZg7w4SqUZIQPJ8NS0aVF4aauNvv--

