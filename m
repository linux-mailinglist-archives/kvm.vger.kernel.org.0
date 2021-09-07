Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E540B402714
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245376AbhIGKZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:25:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhIGKZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 06:25:39 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187A5Ux1139009;
        Tue, 7 Sep 2021 06:24:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QQ7fHKswlegI2/x9sDIv7Dbzho/4PLMRu7uZKcGhe6w=;
 b=Atb6bOEsY0Pg4vlGP1mzwGV7Vgth/tbE9AkG/icVasC6b0uXMhvzSUse/fYbFQUhPuP9
 P2+QjaZMAOQY+7luqEhW2pvClzjr23hQLyByM1myLKhYI+PSe6e1ff0bVOvacc+cxDBS
 7YGg7tVSWO1O3axm+XxLDQaZaPW4+VdTx/GRLTFc++DnufY8XDF/fqCwwWdrzlEDegf4
 gwE0mW60HHpyFXLVNR0Ia8NRwyjCASqBVApDV3Ovx2W+SyJg94TmH9SFyCWfr8nSVB8c
 q8DTpr1mBQOHqRWpu827ANOhaOkamxUhCqcA3EBt0nJsMeZdQbP8g1XG03yx+mVt2QI3 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awvb5v1t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 06:24:33 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 187A5YAU139331;
        Tue, 7 Sep 2021 06:24:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awvb5v1sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 06:24:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187AE3nl027716;
        Tue, 7 Sep 2021 10:24:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3av0e9dmke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 10:24:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187AKBfg58458390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Sep 2021 10:20:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32612AE045;
        Tue,  7 Sep 2021 10:24:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5FBFAE058;
        Tue,  7 Sep 2021 10:24:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.9.165])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Sep 2021 10:24:26 +0000 (GMT)
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
 <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <59ff09e8-6975-20c2-78de-282585e2953d@linux.ibm.com>
Date:   Tue, 7 Sep 2021 12:24:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ofogf204S8lVADvOZn9It16C-Zkaq7DO
X-Proofpoint-ORIG-GUID: TWKcuo6aY2yZ6Ccn5K_-55ttUYg8oJ-4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_03:2021-09-03,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/21 8:37 PM, David Hildenbrand wrote:
> On 03.08.21 10:26, Pierre Morel wrote:
>> We let the userland hypervisor know if the machine support the CPU
>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>
>> The PTF instruction will report a topology change if there is any change
>> with a previous STSI_15_2 SYSIB.
>> Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
>> inside the CPU Topology List Entry CPU mask field, which happens with
>> changes in CPU polarization, dedication, CPU types and adding or
>> removing CPUs in a socket.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> To check if the topology has been modified we use a new field of the
>> arch vCPU to save the previous real CPU ID at the end of a schedule
>> and verify on next schedule that the CPU used is in the same socket.
>>
>> We deliberatly ignore:
>> - polarization: only horizontal polarization is currently used in linux.
>> - CPU Type: only IFL Type are supported in Linux
>> - Dedication: we consider that only a complete dedicated CPU stack can
>>    take benefit of the CPU Topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> 
>> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>>       __u8    icptcode;        /* 0x0050 */
>>       __u8    icptstatus;        /* 0x0051 */
>>       __u16    ihcpu;            /* 0x0052 */
>> -    __u8    reserved54;        /* 0x0054 */
>> +    __u8    mtcr;            /* 0x0054 */
>>   #define IICTL_CODE_NONE         0x00
>>   #define IICTL_CODE_MCHK         0x01
>>   #define IICTL_CODE_EXT         0x02
>> @@ -246,6 +250,7 @@ struct kvm_s390_sie_block {
>>   #define ECB_TE        0x10
>>   #define ECB_SRSI    0x04
>>   #define ECB_HOSTPROTINT    0x02
>> +#define ECB_PTF        0x01
> 
>  From below I understand, that ECB_PTF can be used with stfl(11) in the 
> hypervisor.
> 
> What is to happen if the hypervisor doesn't support stfl(11) and we 
> consequently cannot use ECB_PTF? Will QEMU be able to emulate PTF fully?

Yes.

> 
> 
>>       __u8    ecb;            /* 0x0061 */
>>   #define ECB2_CMMA    0x80
>>   #define ECB2_IEP    0x20
>> @@ -747,6 +752,7 @@ struct kvm_vcpu_arch {
>>       bool skey_enabled;
>>       struct kvm_s390_pv_vcpu pv;
>>       union diag318_info diag318_info;
>> +    int prev_cpu;
>>   };
>>   struct kvm_vm_stat {
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index b655a7d82bf0..ff6d8a2b511c 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_S390_VCPU_RESETS:
>>       case KVM_CAP_SET_GUEST_DEBUG:
>>       case KVM_CAP_S390_DIAG318:
>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
> 
> I would have expected instead
> 
> r = test_facility(11);
> break

The idea is that QEMU will emulate both PTF and SYSIB_15 in this case.

> 
> ...
> 
>>           r = 1;
>>           break;
>>       case KVM_CAP_SET_GUEST_DEBUG2:
>> @@ -819,6 +820,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, 
>> struct kvm_enable_cap *cap)
>>           icpt_operexc_on_all_vcpus(kvm);
>>           r = 0;
>>           break;
>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>> +        mutex_lock(&kvm->lock);
>> +        if (kvm->created_vcpus) {
>> +            r = -EBUSY;
>> +        } else {
> 
> ...
> } else if (test_facility(11)) {
>      set_kvm_facility(kvm->arch.model.fac_mask, 11);
>      set_kvm_facility(kvm->arch.model.fac_list, 11);
>      r = 0;
> } else {
>      r = -EINVAL;
> }
> 
> similar to how we handle KVM_CAP_S390_VECTOR_REGISTERS.
> 
> But I assume you want to be able to support hosts without ECB_PTF, correct?

yes, this was the idea.

> 
> 
>> +            set_kvm_facility(kvm->arch.model.fac_mask, 11);
>> +            set_kvm_facility(kvm->arch.model.fac_list, 11);
>> +            r = 0;
>> +        }
>> +        mutex_unlock(&kvm->lock);
>> +        VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
>> +             r ? "(not available)" : "(success)");
>> +        break;
>> +
>> +        r = -EINVAL;
>> +        break;
> 
> ^ dead code
> 

:) indeed , sorry.

> [...]
> 
>>   }
>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>> +    vcpu->arch.prev_cpu = vcpu->cpu;
>>       vcpu->cpu = -1;
>>       if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>>           __stop_cpu_timer_accounting(vcpu);
>> @@ -3198,6 +3239,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu 
>> *vcpu)
>>           vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>>       if (test_kvm_facility(vcpu->kvm, 9))
>>           vcpu->arch.sie_block->ecb |= ECB_SRSI;
>> +
>> +    /* PTF needs both host and guest facilities to enable 
>> interpretation */
>> +    if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
> 
> Here you say we need both ...

Yes because for interpretation we need both.
But if PTF is not interpreted we will emulate it in QEMU.

> 
>> +
>>       if (test_kvm_facility(vcpu->kvm, 73))
>>           vcpu->arch.sie_block->ecb |= ECB_TE;
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 4002a24bc43a..50d67190bf65 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, 
>> struct vsie_page *vsie_page)
>>       /* Host-protection-interruption introduced with ESOP */
>>       if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>>           scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
>> +    /* CPU Topology */
>> +    if (test_kvm_facility(vcpu->kvm, 11))
>> +        scb_s->ecb |= scb_o->ecb & ECB_PTF;
> 
> but here you don't check?

Arrrg, yes, this is false, we must check both here too.

> 
>>       /* transactional execution */
>>       if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>>           /* remap the prefix is tx is toggled on */
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index d9e4aabcb31a..081ce0cd44b9 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_BINARY_STATS_FD 203
>>   #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>>   #define KVM_CAP_ARM_MTE 205
>> +#define KVM_CAP_S390_CPU_TOPOLOGY 206
> 
> We'll need a Documentation/virt/kvm/api.rst description.
> 
> I'm not completely confident that the way we're handling the 
> capability+facility is the right approach. It all feels a bit suboptimal.
> 
> Except stfl(74) -- STHYI --, we never enable a facility via 
> set_kvm_facility() that's not available in the host. And STHYI is 
> special such that it is never implemented in hardware.

Then we can fall back to KVM_facility + in kernel emulation but if for 
PTF it will be quite simple, for STSI_15 it will be much bigger.

> 
> I'll think about what might be cleaner once I get some more details 
> about the interaction with stfl(11) in the hypervisor.
> 

And I just saw I for an unknown reason forgot two patches in the QEMU 
series:

s390x: kvm: make topology change report pending
s390x: kvm: enable CPU Topology Function

So I will publish a new QEMU series this afternoon with the comments 
from Thomas.

thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
