Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25932136CF9
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 13:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgAJMYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 07:24:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727965AbgAJMYZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 07:24:25 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00ACMW5S149504
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 07:24:23 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xef1u9a5m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 07:24:23 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 10 Jan 2020 12:24:21 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 12:24:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00ACOHNb51642608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 12:24:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D2E52051;
        Fri, 10 Jan 2020 12:24:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.153.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8D52752052;
        Fri, 10 Jan 2020 12:24:16 +0000 (GMT)
Subject: Re: [PATCH v7] KVM: s390: Add new reset vcpu API
To:     Thomas Huth <thuth@redhat.com>, borntraeger@de.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20200110114540.90713-1-frankja@linux.ibm.com>
 <f6c54d4e-6b31-d93f-e919-45781aadfd55@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 10 Jan 2020 13:24:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f6c54d4e-6b31-d93f-e919-45781aadfd55@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fbInxgi8zL8sS9XwYBpfcgOLDUzy8i4dp"
X-TM-AS-GCONF: 00
x-cbid: 20011012-0028-0000-0000-000003CFF678
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011012-0029-0000-0000-000024940EE1
Message-Id: <2d7610ee-e507-37f1-50c3-fe651499196d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 clxscore=1015 adultscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fbInxgi8zL8sS9XwYBpfcgOLDUzy8i4dp
Content-Type: multipart/mixed; boundary="hm2Rcg3P5CRUjpgJA8b5kBP2f2Kge4Gj5"

--hm2Rcg3P5CRUjpgJA8b5kBP2f2Kge4Gj5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/10/20 1:11 PM, Thomas Huth wrote:
> On 10/01/2020 12.45, Janosch Frank wrote:
>> The architecture states that we need to reset local IRQs for all CPU
>> resets. Because the old reset interface did not support the normal CPU=

>> reset we never did that on a normal reset.
>>
>> Let's implement an interface for the missing normal and clear resets
>> and reset all local IRQs, registers and control structures as stated
>> in the architecture.
>>
>> Userspace might already reset the registers via the vcpu run struct,
>> but as we need the interface for the interrupt clearing part anyway,
>> we implement the resets fully and don't rely on userspace to reset the=

>> rest.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  Documentation/virt/kvm/api.txt |  43 +++++++++++++
>>  arch/s390/kvm/kvm-s390.c       | 112 +++++++++++++++++++++++---------=
-
>>  include/uapi/linux/kvm.h       |   5 ++
>>  3 files changed, 127 insertions(+), 33 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/a=
pi.txt
>> index ebb37b34dcfc..73448764f544 100644
>> --- a/Documentation/virt/kvm/api.txt
>> +++ b/Documentation/virt/kvm/api.txt
>> @@ -4168,6 +4168,42 @@ This ioctl issues an ultravisor call to termina=
te the secure guest,
>>  unpins the VPA pages and releases all the device pages that are used =
to
>>  track the secure pages by hypervisor.
>> =20
>> +4.122 KVM_S390_NORMAL_RESET
>> +
>> +Capability: KVM_CAP_S390_VCPU_RESETS
>> +Architectures: s390
>> +Type: vcpu ioctl
>> +Parameters: none
>> +Returns: 0
>> +
>> +This ioctl resets VCPU registers and control structures according to
>> +the cpu reset definition in the POP (Principles Of Operation).
>> +
>> +4.123 KVM_S390_INITIAL_RESET
>> +
>> +Capability: none
>> +Architectures: s390
>> +Type: vcpu ioctl
>> +Parameters: none
>> +Returns: 0
>> +
>> +This ioctl resets VCPU registers and control structures according to
>> +the initial cpu reset definition in the POP. However, the cpu is not
>> +put into ESA mode. This reset is a superset of the normal reset.
>> +
>> +4.124 KVM_S390_CLEAR_RESET
>> +
>> +Capability: KVM_CAP_S390_VCPU_RESETS
>> +Architectures: s390
>> +Type: vcpu ioctl
>> +Parameters: none
>> +Returns: 0
>> +
>> +This ioctl resets VCPU registers and control structures according to
>> +the clear cpu reset definition in the POP. However, the cpu is not pu=
t
>> +into ESA mode. This reset is a superset of the initial reset.
>> +
>> +
>>  5. The kvm_run structure
>>  ------------------------
>> =20
>> @@ -5396,3 +5432,10 @@ handling by KVM (as some KVM hypercall may be m=
istakenly treated as TLB
>>  flush hypercalls by Hyper-V) so userspace should disable KVM identifi=
cation
>>  in CPUID and only exposes Hyper-V identification. In this case, guest=

>>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
>> +
>> +8.22 KVM_CAP_S390_VCPU_RESETS
>> +
>> +Architectures: s390
>> +
>> +This capability indicates that the KVM_S390_NORMAL_RESET and
>> +KVM_S390_CLEAR_RESET ioctls are available.
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d9e6bf3d54f0..5640f3d6f98d 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
>>  	case KVM_CAP_S390_CMMA_MIGRATION:
>>  	case KVM_CAP_S390_AIS:
>>  	case KVM_CAP_S390_AIS_MIGRATION:
>> +	case KVM_CAP_S390_VCPU_RESETS:
>>  		r =3D 1;
>>  		break;
>>  	case KVM_CAP_S390_HPAGE_1M:
>> @@ -2844,35 +2845,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>> =20
>>  }
>> =20
>> -static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
>> -{
>> -	/* this equals initial cpu reset in pop, but we don't switch to ESA =
*/
>> -	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
>> -	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
>> -	kvm_s390_set_prefix(vcpu, 0);
>> -	kvm_s390_set_cpu_timer(vcpu, 0);
>> -	vcpu->arch.sie_block->ckc       =3D 0UL;
>> -	vcpu->arch.sie_block->todpr     =3D 0;
>> -	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
>> -	vcpu->arch.sie_block->gcr[0]  =3D CR0_UNUSED_56 |
>> -					CR0_INTERRUPT_KEY_SUBMASK |
>> -					CR0_MEASUREMENT_ALERT_SUBMASK;
>> -	vcpu->arch.sie_block->gcr[14] =3D CR14_UNUSED_32 |
>> -					CR14_UNUSED_33 |
>> -					CR14_EXTERNAL_DAMAGE_SUBMASK;
>> -	/* make sure the new fpc will be lazily loaded */
>> -	save_fpu_regs();
>> -	current->thread.fpu.fpc =3D 0;
>> -	vcpu->arch.sie_block->gbea =3D 1;
>> -	vcpu->arch.sie_block->pp =3D 0;
>> -	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>> -	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
>> -	kvm_clear_async_pf_completion_queue(vcpu);
>> -	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>> -		kvm_s390_vcpu_stop(vcpu);
>> -	kvm_s390_clear_local_irqs(vcpu);
>> -}
>> -
>>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  {
>>  	mutex_lock(&vcpu->kvm->lock);
>> @@ -3287,10 +3259,75 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(str=
uct kvm_vcpu *vcpu,
>>  	return r;
>>  }
>> =20
>> -static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>> +static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_s390_vcpu_initial_reset(vcpu);
>> -	return 0;
>> +	vcpu->arch.sie_block->gpsw.mask =3D ~PSW_MASK_RI;
>> +	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
>> +	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));=

>> +
>> +	kvm_clear_async_pf_completion_queue(vcpu);
>> +	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>> +		kvm_s390_vcpu_stop(vcpu);
>> +	kvm_s390_clear_local_irqs(vcpu);
>> +}
>> +
>> +static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	/* Initial reset is a superset of the normal reset */
>> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>> +
>> +	/* this equals initial cpu reset in pop, but we don't switch to ESA =
*/
>> +	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
>> +	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
>> +	kvm_s390_set_prefix(vcpu, 0);
>> +	kvm_s390_set_cpu_timer(vcpu, 0);
>> +	vcpu->arch.sie_block->ckc       =3D 0UL;
>> +	vcpu->arch.sie_block->todpr     =3D 0;
>> +	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
>> +	vcpu->arch.sie_block->gcr[0]  =3D CR0_UNUSED_56 |
>> +					CR0_INTERRUPT_KEY_SUBMASK |
>> +					CR0_MEASUREMENT_ALERT_SUBMASK;
>> +	vcpu->arch.sie_block->gcr[14] =3D CR14_UNUSED_32 |
>> +					CR14_UNUSED_33 |
>> +					CR14_EXTERNAL_DAMAGE_SUBMASK;
>> +	/* make sure the new fpc will be lazily loaded */
>> +	save_fpu_regs();
>> +	current->thread.fpu.fpc =3D 0;
>> +	vcpu->arch.sie_block->gbea =3D 1;
>> +	vcpu->arch.sie_block->pp =3D 0;
>> +	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>> +}
>> +
>> +static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sync_regs *regs =3D &vcpu->run->s.regs;
>> +
>> +	/* Clear reset is a superset of the initial reset */
>> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
>=20
> s/kvm_arch_vcpu_ioctl_normal_reset/kvm_arch_vcpu_ioctl_initial_reset/

-_-
It seems like my vacation was not enough...

>=20
>> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
>> +	/* Will be picked up because of save_fpu_regs() in the initial reset=
 */
>> +	memset(&current->thread.fpu.vxrs, 0, sizeof(current->thread.fpu.vxrs=
));
>=20
> I'm still not 100% sure about whether current->thread.fpu.vxrs is alway=
s
> fine here? But I hope Christian can give an ACK for that...
>=20
>  Thomas
>=20



--hm2Rcg3P5CRUjpgJA8b5kBP2f2Kge4Gj5--

--fbInxgi8zL8sS9XwYBpfcgOLDUzy8i4dp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4YbPAACgkQ41TmuOI4
ufip1RAAqwg/QLYCGS8+X9Bf6Mp3caZgm6mwjWglW/6I/7dYpne+4FrzutIzFK92
q/XoX4Y3GRYx2QncEdIcYvGd1UOw7z+5wpJtWrwEO8lrhh82A/M2tBpDyfwKZfAI
3EH4sngf9+7vN+LJbll8KN5bWeNpxtXZjWokdb05GCYT8jFWo034qo2I5yQQr6wS
B71FGbAw07rgkAoLDMDkc8YOLCZwi7Pu8wDtZxgDYbFNyBbbZK9CEFI5UMCUiRmO
hTTUmkPn9njbAmBUJlnlc2MqwbQsrOlSdZBoXVJX+hFT8FFM4Hwen7tiVEQ5kmyJ
YheWbs1FSAW0C3vUX/hoTJq48c/q+1nO3iZ8bqzUQw0wBjdaWiyz8lfUSsmP8bpt
IHdexHWfhQUMSBVAUwiMsiCgGGIjWNV5ma6/RsaL9HWYL2nN5dza94o7+dBvFo2T
Hhj1mIREh8Ki2OnjTlXu8b0VnVwmUn8upQVxbLqtnlcv9uxYaopr4YdwRwjY8790
ckUYa/Rk8/bpnNcfsljr6r3WHk1Zp6P57wKONCYHfyGXftcBFbAo8mc8NuyD/1r9
rPV436kPamDJFGa9Le6mWRLL6djhzKRozoF+ISJsvqVp5kV07p2AQ6bFvjchFM+V
w5JR3oQukd0QjGrHC5++Np6fidoPTbQ7W4exw8e9wT96QY/B20s=
=Q5tx
-----END PGP SIGNATURE-----

--fbInxgi8zL8sS9XwYBpfcgOLDUzy8i4dp--

