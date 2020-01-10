Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53329136E79
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgAJNrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 08:47:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727641AbgAJNrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 08:47:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00ADlI8V140383
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 08:47:23 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xe98nddvm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 08:47:21 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 10 Jan 2020 13:47:14 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 13:47:12 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00ADlBmh39190782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 13:47:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94FA311C04A;
        Fri, 10 Jan 2020 13:47:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E95B11C050;
        Fri, 10 Jan 2020 13:47:11 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.226])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jan 2020 13:47:11 +0000 (GMT)
Subject: Re: [PATCH v7] KVM: s390: Add new reset vcpu API
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20200110114540.90713-1-frankja@linux.ibm.com>
 <f6c54d4e-6b31-d93f-e919-45781aadfd55@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 10 Jan 2020 14:47:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f6c54d4e-6b31-d93f-e919-45781aadfd55@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011013-0008-0000-0000-00000348447A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011013-0009-0000-0000-00004A688E38
Message-Id: <5f82c5fd-4332-73b5-50cb-195fc56b28db@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.01.20 13:11, Thomas Huth wrote:
> On 10/01/2020 12.45, Janosch Frank wrote:
>> The architecture states that we need to reset local IRQs for all CPU
>> resets. Because the old reset interface did not support the normal CPU
>> reset we never did that on a normal reset.
>>
>> Let's implement an interface for the missing normal and clear resets
>> and reset all local IRQs, registers and control structures as stated
>> in the architecture.
>>
>> Userspace might already reset the registers via the vcpu run struct,
>> but as we need the interface for the interrupt clearing part anyway,
>> we implement the resets fully and don't rely on userspace to reset the
>> rest.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  Documentation/virt/kvm/api.txt |  43 +++++++++++++
>>  arch/s390/kvm/kvm-s390.c       | 112 +++++++++++++++++++++++----------
>>  include/uapi/linux/kvm.h       |   5 ++
>>  3 files changed, 127 insertions(+), 33 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
>> index ebb37b34dcfc..73448764f544 100644
>> --- a/Documentation/virt/kvm/api.txt
>> +++ b/Documentation/virt/kvm/api.txt
>> @@ -4168,6 +4168,42 @@ This ioctl issues an ultravisor call to terminate the secure guest,
>>  unpins the VPA pages and releases all the device pages that are used to
>>  track the secure pages by hypervisor.
>>  
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
>> +the clear cpu reset definition in the POP. However, the cpu is not put
>> +into ESA mode. This reset is a superset of the initial reset.
>> +
>> +
>>  5. The kvm_run structure
>>  ------------------------
>>  
>> @@ -5396,3 +5432,10 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
>>  flush hypercalls by Hyper-V) so userspace should disable KVM identification
>>  in CPUID and only exposes Hyper-V identification. In this case, guest
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
>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_S390_CMMA_MIGRATION:
>>  	case KVM_CAP_S390_AIS:
>>  	case KVM_CAP_S390_AIS_MIGRATION:
>> +	case KVM_CAP_S390_VCPU_RESETS:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_S390_HPAGE_1M:
>> @@ -2844,35 +2845,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  
>>  }
>>  
>> -static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
>> -{
>> -	/* this equals initial cpu reset in pop, but we don't switch to ESA */
>> -	vcpu->arch.sie_block->gpsw.mask = 0UL;
>> -	vcpu->arch.sie_block->gpsw.addr = 0UL;
>> -	kvm_s390_set_prefix(vcpu, 0);
>> -	kvm_s390_set_cpu_timer(vcpu, 0);
>> -	vcpu->arch.sie_block->ckc       = 0UL;
>> -	vcpu->arch.sie_block->todpr     = 0;
>> -	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
>> -	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
>> -					CR0_INTERRUPT_KEY_SUBMASK |
>> -					CR0_MEASUREMENT_ALERT_SUBMASK;
>> -	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
>> -					CR14_UNUSED_33 |
>> -					CR14_EXTERNAL_DAMAGE_SUBMASK;
>> -	/* make sure the new fpc will be lazily loaded */
>> -	save_fpu_regs();
>> -	current->thread.fpu.fpc = 0;
>> -	vcpu->arch.sie_block->gbea = 1;
>> -	vcpu->arch.sie_block->pp = 0;
>> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>> -	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>> -	kvm_clear_async_pf_completion_queue(vcpu);
>> -	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>> -		kvm_s390_vcpu_stop(vcpu);
>> -	kvm_s390_clear_local_irqs(vcpu);
>> -}
>> -
>>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  {
>>  	mutex_lock(&vcpu->kvm->lock);
>> @@ -3287,10 +3259,75 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
>>  	return r;
>>  }
>>  
>> -static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>> +static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_s390_vcpu_initial_reset(vcpu);
>> -	return 0;
>> +	vcpu->arch.sie_block->gpsw.mask = ~PSW_MASK_RI;
>> +	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>> +	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
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
>> +	/* this equals initial cpu reset in pop, but we don't switch to ESA */
>> +	vcpu->arch.sie_block->gpsw.mask = 0UL;
>> +	vcpu->arch.sie_block->gpsw.addr = 0UL;
>> +	kvm_s390_set_prefix(vcpu, 0);
>> +	kvm_s390_set_cpu_timer(vcpu, 0);
>> +	vcpu->arch.sie_block->ckc       = 0UL;
>> +	vcpu->arch.sie_block->todpr     = 0;
>> +	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
>> +	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
>> +					CR0_INTERRUPT_KEY_SUBMASK |
>> +					CR0_MEASUREMENT_ALERT_SUBMASK;
>> +	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
>> +					CR14_UNUSED_33 |
>> +					CR14_EXTERNAL_DAMAGE_SUBMASK;
>> +	/* make sure the new fpc will be lazily loaded */
>> +	save_fpu_regs();
>> +	current->thread.fpu.fpc = 0;
>> +	vcpu->arch.sie_block->gbea = 1;
>> +	vcpu->arch.sie_block->pp = 0;
>> +	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>> +}
>> +
>> +static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
>> +
>> +	/* Clear reset is a superset of the initial reset */
>> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> 
> s/kvm_arch_vcpu_ioctl_normal_reset/kvm_arch_vcpu_ioctl_initial_reset/
> 
>> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
>> +	/* Will be picked up because of save_fpu_regs() in the initial reset */
>> +	memset(&current->thread.fpu.vxrs, 0, sizeof(current->thread.fpu.vxrs));
> 
> I'm still not 100% sure about whether current->thread.fpu.vxrs is always
> fine here? But I hope Christian can give an ACK for that...

We do not have done the sync reg call for this ioctl, so current->thread.fpu.vxrs
still points to the userspace save area and not the kvm_run structure.
I think we must memset the kvm run structure. This might also imply that the
current code for fpc is wrong and that the initial cpu reset ioctl is clearing
the wrong fpc. 
Need to look at this again.

