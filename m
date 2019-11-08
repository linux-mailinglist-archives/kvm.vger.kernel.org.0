Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26558F4169
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 08:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHHgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 02:36:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24780 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfKHHgo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 02:36:44 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA87YU5m059109
        for <kvm@vger.kernel.org>; Fri, 8 Nov 2019 02:36:43 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w5439g3yj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 02:36:43 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 8 Nov 2019 07:36:40 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 8 Nov 2019 07:36:38 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA87aai435193034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 07:36:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72694A4040;
        Fri,  8 Nov 2019 07:36:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19488A4053;
        Fri,  8 Nov 2019 07:36:36 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.5.111])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Nov 2019 07:36:36 +0000 (GMT)
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-5-frankja@linux.ibm.com>
 <20191107172956.4f4d8a90.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABtCVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+iQI3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbauQINBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABiQIfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
Date:   Fri, 8 Nov 2019 08:36:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191107172956.4f4d8a90.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UGkhotNZgKUySzlg3WmGIsATWGy5vEiVB"
X-TM-AS-GCONF: 00
x-cbid: 19110807-0020-0000-0000-00000383A5D2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110807-0021-0000-0000-000021D9DD09
Message-Id: <8989f705-ce14-7b85-e5b6-6d87803db491@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-08_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911080075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UGkhotNZgKUySzlg3WmGIsATWGy5vEiVB
Content-Type: multipart/mixed; boundary="92l716vdYBFs2aAbM0kOtdRaT7f81yQfS"

--92l716vdYBFs2aAbM0kOtdRaT7f81yQfS
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/7/19 5:29 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:26 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Let's add a KVM interface to create and destroy protected VMs.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  24 +++-
>>  arch/s390/include/asm/uv.h       | 110 ++++++++++++++
>>  arch/s390/kvm/Makefile           |   2 +-
>>  arch/s390/kvm/kvm-s390.c         | 173 +++++++++++++++++++++-
>>  arch/s390/kvm/kvm-s390.h         |  47 ++++++
>>  arch/s390/kvm/pv.c               | 237 ++++++++++++++++++++++++++++++=
+
>>  include/uapi/linux/kvm.h         |  33 +++++
>=20
> Any new ioctls and caps probably want a mention in
> Documentation/virt/kvm/api.txt :)

Noted

>=20
>>  7 files changed, 622 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/s390/kvm/pv.c
>=20
> (...)
>=20
>> @@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm *k=
vm,
>>  	return r;
>>  }
>> =20
>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd=
)
>> +{
>> +	int r =3D 0;
>> +	void __user *argp =3D (void __user *)cmd->data;
>> +
>> +	switch (cmd->cmd) {
>> +	case KVM_PV_VM_CREATE: {
>> +		r =3D kvm_s390_pv_alloc_vm(kvm);
>> +		if (r)
>> +			break;
>> +
>> +		mutex_lock(&kvm->lock);
>> +		kvm_s390_vcpu_block_all(kvm);
>> +		/* FMT 4 SIE needs esca */
>> +		r =3D sca_switch_to_extended(kvm);
>> +		if (!r)
>> +			r =3D kvm_s390_pv_create_vm(kvm);
>> +		kvm_s390_vcpu_unblock_all(kvm);
>> +		mutex_unlock(&kvm->lock);
>> +		break;
>> +	}
>> +	case KVM_PV_VM_DESTROY: {
>> +		/* All VCPUs have to be destroyed before this call. */
>> +		mutex_lock(&kvm->lock);
>> +		kvm_s390_vcpu_block_all(kvm);
>> +		r =3D kvm_s390_pv_destroy_vm(kvm);
>> +		if (!r)
>> +			kvm_s390_pv_dealloc_vm(kvm);
>> +		kvm_s390_vcpu_unblock_all(kvm);
>> +		mutex_unlock(&kvm->lock);
>> +		break;
>> +	}
>=20
> Would be helpful to have some code that shows when/how these are called=

> - do you have any plans to post something soon?

Qemu patches will be in internal review soonish and afterwards I'll post
them upstream

>=20
> (...)
>=20
>> @@ -2529,6 +2642,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu=
)
>> =20
>>  	if (vcpu->kvm->arch.use_cmma)
>>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
>> +	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
>> +	    kvm_s390_pv_handle_cpu(vcpu))
>=20
> I was a bit confused by that function name... maybe
> kvm_s390_pv_cpu_get_handle()?

Sure

>=20
> Also, if this always returns 0 if the config option is off, you
> probably don't need to check for that option?

Hmm, if we decide to remove the config option altogether then it's not
needed anyway and I think that's what Christian wants.

>=20
>> +		kvm_s390_pv_destroy_cpu(vcpu);
>>  	free_page((unsigned long)(vcpu->arch.sie_block));
>> =20
>>  	kvm_vcpu_uninit(vcpu);
>> @@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>  {
>>  	kvm_free_vcpus(kvm);
>>  	sca_dispose(kvm);
>> -	debug_unregister(kvm->arch.dbf);
>>  	kvm_s390_gisa_destroy(kvm);
>> +	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
>> +	    kvm_s390_pv_is_protected(kvm)) {
>> +		kvm_s390_pv_destroy_vm(kvm);
>> +		kvm_s390_pv_dealloc_vm(kvm);
>=20
> It seems the pv vm can be either destroyed via the ioctl above or in
> the course of normal vm destruction. When is which way supposed to be
> used? Also, it seems kvm_s390_pv_destroy_vm() can fail -- can that be a=

> problem in this code path?

On a reboot we need to tear down the protected VM and boot from
unprotected mode again. If the VM shuts down we go through this cleanup
path. If it fails the kernel will loose the memory that was allocated to
start the VM.

>=20
>> +	}
>> +	debug_unregister(kvm->arch.dbf);
>>  	free_page((unsigned long)kvm->arch.sie_page2);
>>  	if (!kvm_is_ucontrol(kvm))
>>  		gmap_remove(kvm->arch.gmap);
>=20
> (...)
>=20
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 6d9448dbd052..0d61dcc51f0e 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -196,6 +196,53 @@ static inline int kvm_s390_user_cpu_state_ctrl(st=
ruct kvm *kvm)
>>  	return kvm->arch.user_cpu_state_ctrl !=3D 0;
>>  }
>> =20
>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>> +/* implemented in pv.c */
>> +void kvm_s390_pv_unpin(struct kvm *kvm);
>> +void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
>> +int kvm_s390_pv_alloc_vm(struct kvm *kvm);
>> +int kvm_s390_pv_create_vm(struct kvm *kvm);
>> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
>> +int kvm_s390_pv_destroy_vm(struct kvm *kvm);
>> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
>> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length)=
;
>> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned =
long size,
>> +		       unsigned long tweak);
>> +int kvm_s390_pv_verify(struct kvm *kvm);
>> +
>> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
>> +{
>> +	return !!kvm->arch.pv.handle;
>> +}
>> +
>> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm)
>=20
> This function name is less confusing than the one below, but maybe also=

> rename this to kvm_s390_pv_get_handle() for consistency?

kvm_s390_pv_kvm_handle?

>=20
>> +{
>> +	return kvm->arch.pv.handle;
>> +}
>> +
>> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.pv.handle;
>> +}
>> +#else
>> +static inline void kvm_s390_pv_unpin(struct kvm *kvm) {}
>> +static inline void kvm_s390_pv_dealloc_vm(struct kvm *kvm) {}
>> +static inline int kvm_s390_pv_alloc_vm(struct kvm *kvm) { return 0; }=

>> +static inline int kvm_s390_pv_create_vm(struct kvm *kvm) { return 0; =
}
>> +static inline int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu) { ret=
urn 0; }
>> +static inline int kvm_s390_pv_destroy_vm(struct kvm *kvm) { return 0;=
 }
>> +static inline int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu) { re=
turn 0; }
>> +static inline int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
>> +					    u64 origin, u64 length) { return 0; }
>> +static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long a=
ddr,
>> +				     unsigned long size,  unsigned long tweak)
>> +{ return 0; }
>> +static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
>> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return=
 0; }
>> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
>> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { ret=
urn 0; }
>> +#endif
>> +
>>  /* implemented in interrupt.c */
>>  int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
>>  void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
>=20
> (...)
>=20
>> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
>> +{
>> +	int rc;
>> +	struct uv_cb_csc uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_CREATE_SEC_CPU,
>> +		.header.len =3D sizeof(uvcb),
>> +	};
>> +
>> +	/* EEXIST and ENOENT? */
>=20
> ?

I was asking myself if EEXIST or ENOENT would be better error values
than EINVAL.

>=20
>> +	if (kvm_s390_pv_handle_cpu(vcpu))
>> +		return -EINVAL;
>> +
>> +	vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL,
>> +						   get_order(uv_info.guest_cpu_stor_len));
>> +	if (!vcpu->arch.pv.stor_base)
>> +		return -ENOMEM;
>> +
>> +	/* Input */
>> +	uvcb.guest_handle =3D kvm_s390_pv_handle(vcpu->kvm);
>> +	uvcb.num =3D vcpu->arch.sie_block->icpua;
>> +	uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
>> +	uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
>> +
>> +	rc =3D uv_call(0, (u64)&uvcb);
>> +	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x =
rrc %x",
>> +		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
>> +		   uvcb.header.rrc);
>> +
>> +	/* Output */
>> +	vcpu->arch.pv.handle =3D uvcb.cpu_handle;
>> +	vcpu->arch.sie_block->pv_handle_cpu =3D uvcb.cpu_handle;
>> +	vcpu->arch.sie_block->pv_handle_config =3D kvm_s390_pv_handle(vcpu->=
kvm);
>> +	vcpu->arch.sie_block->sdf =3D 2;
>> +	if (!rc)
>> +		return 0;
>> +
>> +	kvm_s390_pv_destroy_cpu(vcpu);
>> +	return -EINVAL;
>> +}
>=20
> (...)
>=20
> Only a quick readthrough, as this patch is longish.
>=20



--92l716vdYBFs2aAbM0kOtdRaT7f81yQfS--

--UGkhotNZgKUySzlg3WmGIsATWGy5vEiVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3FGwMACgkQ41TmuOI4
ufiPXA//YF3ulKyBnYnxIx22CUKdQX9lNPFQXwgrpYudWNW+x8OliajJdFh1RJxt
N/+5QYHM7fS77Zjf/yaLSVXaNuVoA3Ax72arwG4aLEgEvICWaahPrSFYc0uHIEak
oiDl+/H36XJOviXs3ri4Aq7o+/NUqRVTIiHcNCpOmbfOmfmKiY0EDcxX1IHHJ7DE
i6LPBpEqgRXs5fA7cqIT9IzTuPhHCXnltXfGIgQWX7DfwIXkctgVMGOVpPV2ihaA
sD9CZJIPg87bTZREjM4qELe4oMlGX8ONobUYz02FcLVbctJqa53ZPHsxRLtc2fdx
hQADbY3AiY2DdubEpps+hFDxdZGQALq8xenAc+VooFlG6ho+zQQZLHBipobX3IjI
zYSpPODmmZz/kvxII+BoDG6YkFFCKshLriJytWmlEDBMpbduIOyhvRY3Q9bPTDa/
Efn4XH58IRF7hR2s5A1rBLBGv45XzPNBrZYeZsE19kxc6RcxmIvfR6oKcCovNu7g
2v3JPCArT3jm+M3CKPbH0S3sNaF732c5Bp+RZgRt+aQBtY3AzdSKXmmJ7NYJTVzU
TUbzTMmut/B+gibOSJyCB0qiDmUAjPpaD9MpA2Z6YruHrzWVuG/hg0kkTcAGz0/S
2jY41gyhG2fcTI13+w/lIBrdMiJWd0CnTxThWnECaDGohTJKtsA=
=ClVo
-----END PGP SIGNATURE-----

--UGkhotNZgKUySzlg3WmGIsATWGy5vEiVB--

