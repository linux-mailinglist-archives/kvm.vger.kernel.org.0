Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51A7403A72
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 15:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348769AbhIHNSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 09:18:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235294AbhIHNSI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 09:18:08 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188D3juN048008;
        Wed, 8 Sep 2021 09:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YtU/1ejT9cLLIvPIdNQY7xGhHSrpolXAwCniJVt5B7A=;
 b=VydepfyWo8V4Mf6Cy3mOGU8z0Hz7n6nozY+12Gh6lj3rLCId+VehSY3vfnAnmnwTihAk
 ivk4qBmzg+tpiak9hge8TOqZJy2XLPBkLdlX74I1sPeqP4Vlo93q39hqBhr4tCbTpoNV
 5OEjbUj7Lx79hnze7hDlXg7p94UoHIDiI4n4Ol7qE5qkpfEAqEdvAUMOZ4W5EUVdz79L
 Olx+s0ST/7FzOoTO2BfrSJGutjHwKnvhb3zQjcT3JzYIF3Or65ZMREqeIIDTaYobBsqa
 VOSh6WQf3wJYu9Gb6QuShAPrYB9/P/62WKH+1p7SlCEn+qqL5Rw3yKroGOtNAAvk/cvQ iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axp74ub7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:16:59 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 188D47UZ050222;
        Wed, 8 Sep 2021 09:16:59 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axp74ub6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:16:59 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 188DDGfU009233;
        Wed, 8 Sep 2021 13:16:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3axcnq0xhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 13:16:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188DCXdc56557942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Sep 2021 13:12:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE66A11C058;
        Wed,  8 Sep 2021 13:16:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63A9211C069;
        Wed,  8 Sep 2021 13:16:50 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.79.242])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Sep 2021 13:16:50 +0000 (GMT)
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
To:     Pierre Morel <pmorel@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
 <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
 <c4cfc6b1-44b5-eda7-c602-a54858971f01@linux.ibm.com>
 <720762c5-01ab-55f6-e585-b46c9b62ce8c@de.ibm.com>
 <9e062d47-ef96-4028-38a7-ffb54a451643@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <2952e19f-2bb4-35d1-b3dd-042fbb08f9eb@de.ibm.com>
Date:   Wed, 8 Sep 2021 15:16:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9e062d47-ef96-4028-38a7-ffb54a451643@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nkSR_PJIB_iAishBsR6k3y76oRUg6SEI
X-Proofpoint-ORIG-GUID: loq3_n1Z6Sgdk8KXCUf3fy9If1fpLuWI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_06:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.09.21 15:09, Pierre Morel wrote:
> 
> 
> On 9/8/21 9:07 AM, Christian Borntraeger wrote:
>>
>>
>> On 07.09.21 14:28, Pierre Morel wrote:
>>>
>>>
>>> On 9/6/21 8:37 PM, David Hildenbrand wrote:
>>>> On 03.08.21 10:26, Pierre Morel wrote:
>>>>> We let the userland hypervisor know if the machine support the CPU
>>>>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>
>>>>> The PTF instruction will report a topology change if there is any change
>>>>> with a previous STSI_15_2 SYSIB.
>>>>> Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
>>>>> inside the CPU Topology List Entry CPU mask field, which happens with
>>>>> changes in CPU polarization, dedication, CPU types and adding or
>>>>> removing CPUs in a socket.
>>>>>
>>>>> The reporting to the guest is done using the Multiprocessor
>>>>> Topology-Change-Report (MTCR) bit of the utility entry of the guest's
>>>>> SCA which will be cleared during the interpretation of PTF.
>>>>>
>>>>> To check if the topology has been modified we use a new field of the
>>>>> arch vCPU to save the previous real CPU ID at the end of a schedule
>>>>> and verify on next schedule that the CPU used is in the same socket.
>>>>>
>>>>> We deliberatly ignore:
>>>>> - polarization: only horizontal polarization is currently used in linux.
>>>>> - CPU Type: only IFL Type are supported in Linux
>>>>> - Dedication: we consider that only a complete dedicated CPU stack can
>>>>>    take benefit of the CPU Topology.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>
>>>>
>>>>> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>>>>>       __u8    icptcode;        /* 0x0050 */
>>>>>       __u8    icptstatus;        /* 0x0051 */
>>>>>       __u16    ihcpu;            /* 0x0052 */
>>>>> -    __u8    reserved54;        /* 0x0054 */
>>>>> +    __u8    mtcr;            /* 0x0054 */
>>>>>   #define IICTL_CODE_NONE         0x00
>>>>>   #define IICTL_CODE_MCHK         0x01
>>>>>   #define IICTL_CODE_EXT         0x02
>>>>> @@ -246,6 +250,7 @@ struct kvm_s390_sie_block {
>>>>>   #define ECB_TE        0x10
>>>>>   #define ECB_SRSI    0x04
>>>>>   #define ECB_HOSTPROTINT    0x02
>>>>> +#define ECB_PTF        0x01
>>>>
>>>>  From below I understand, that ECB_PTF can be used with stfl(11) in the hypervisor.
>>>>
>>>> What is to happen if the hypervisor doesn't support stfl(11) and we consequently cannot use ECB_PTF? Will QEMU be able to emulate PTF fully?
>>>>
>>>>
>>>>>       __u8    ecb;            /* 0x0061 */
>>>>>   #define ECB2_CMMA    0x80
>>>>>   #define ECB2_IEP    0x20
>>>>> @@ -747,6 +752,7 @@ struct kvm_vcpu_arch {
>>>>>       bool skey_enabled;
>>>>>       struct kvm_s390_pv_vcpu pv;
>>>>>       union diag318_info diag318_info;
>>>>> +    int prev_cpu;
>>>>>   };
>>>>>   struct kvm_vm_stat {
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index b655a7d82bf0..ff6d8a2b511c 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>       case KVM_CAP_S390_VCPU_RESETS:
>>>>>       case KVM_CAP_SET_GUEST_DEBUG:
>>>>>       case KVM_CAP_S390_DIAG318:
>>>>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>>>>
>>>> I would have expected instead
>>>>
>>>> r = test_facility(11);
>>>> break
>>>>
>>>> ...
>>>>
>>>>>           r = 1;
>>>>>           break;
>>>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>>>> @@ -819,6 +820,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>>>>           icpt_operexc_on_all_vcpus(kvm);
>>>>>           r = 0;
>>>>>           break;
>>>>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>>>>> +        mutex_lock(&kvm->lock);
>>>>> +        if (kvm->created_vcpus) {
>>>>> +            r = -EBUSY;
>>>>> +        } else {
>>>>
>>>> ...
>>>> } else if (test_facility(11)) {
>>>>      set_kvm_facility(kvm->arch.model.fac_mask, 11);
>>>>      set_kvm_facility(kvm->arch.model.fac_list, 11);
>>>>      r = 0;
>>>> } else {
>>>>      r = -EINVAL;
>>>> }
>>>>
>>>> similar to how we handle KVM_CAP_S390_VECTOR_REGISTERS.
>>>>
>>>> But I assume you want to be able to support hosts without ECB_PTF, correct?
>>>>
>>>>
>>>>> +            set_kvm_facility(kvm->arch.model.fac_mask, 11);
>>>>> +            set_kvm_facility(kvm->arch.model.fac_list, 11);
>>>>> +            r = 0;
>>>>> +        }
>>>>> +        mutex_unlock(&kvm->lock);
>>>>> +        VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
>>>>> +             r ? "(not available)" : "(success)");
>>>>> +        break;
>>>>> +
>>>>> +        r = -EINVAL;
>>>>> +        break;
>>>>
>>>> ^ dead code
>>>>
>>>> [...]
>>>>
>>>>>   }
>>>>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>>>   {
>>>>> +    vcpu->arch.prev_cpu = vcpu->cpu;
>>>>>       vcpu->cpu = -1;
>>>>>       if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>>>>>           __stop_cpu_timer_accounting(vcpu);
>>>>> @@ -3198,6 +3239,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>>>>           vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>>>>>       if (test_kvm_facility(vcpu->kvm, 9))
>>>>>           vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>>>> +
>>>>> +    /* PTF needs both host and guest facilities to enable interpretation */
>>>>> +    if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
>>>>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
>>>>
>>>> Here you say we need both ...
>>>>
>>>>> +
>>>>>       if (test_kvm_facility(vcpu->kvm, 73))
>>>>>           vcpu->arch.sie_block->ecb |= ECB_TE;
>>>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>>>> index 4002a24bc43a..50d67190bf65 100644
>>>>> --- a/arch/s390/kvm/vsie.c
>>>>> +++ b/arch/s390/kvm/vsie.c
>>>>> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>>>>       /* Host-protection-interruption introduced with ESOP */
>>>>>       if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>>>>>           scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
>>>>> +    /* CPU Topology */
>>>>> +    if (test_kvm_facility(vcpu->kvm, 11))
>>>>> +        scb_s->ecb |= scb_o->ecb & ECB_PTF;
>>>>
>>>> but here you don't check?
>>>>
>>>>>       /* transactional execution */
>>>>>       if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>>>>>           /* remap the prefix is tx is toggled on */
>>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>>> index d9e4aabcb31a..081ce0cd44b9 100644
>>>>> --- a/include/uapi/linux/kvm.h
>>>>> +++ b/include/uapi/linux/kvm.h
>>>>> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>>>>>   #define KVM_CAP_BINARY_STATS_FD 203
>>>>>   #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>>>>>   #define KVM_CAP_ARM_MTE 205
>>>>> +#define KVM_CAP_S390_CPU_TOPOLOGY 206
>>>>
>>>> We'll need a Documentation/virt/kvm/api.rst description.
>>>>
>>>> I'm not completely confident that the way we're handling the capability+facility is the right approach. It all feels a bit suboptimal.
>>>>
>>>> Except stfl(74) -- STHYI --, we never enable a facility via set_kvm_facility() that's not available in the host. And STHYI is special such that it is never implemented in hardware.
>>>>
>>>> I'll think about what might be cleaner once I get some more details about the interaction with stfl(11) in the hypervisor.
>>>>
>>>
>>> OK, may be we do not need to handle the case stfl(11) is not present in the host, these are pre GA10...
>>
>> What about VSIE? For all existing KVM guests, stfl11 is off.
> 
> In VSIE the patch activates stfl(11) only if the host has stfl(11).
> 
> I do not see any problem to activate the interpretation in VSIE with ECB_PTF (ECB.7) when the host has stfl(11) and QEMU asks to enable it for the guest using the CAPABILITY as it is done in this patch.
> 
> if any intermediary hypervizor decide to not advertize stfl(11) for the guest like an old QEMU not having the CAPABILITY, or a QEMU with ctop=off, KVM will not set ECB_PTF and the PTF instruction will trigger a program check as before.
> 
> Is it OK or did I missed something?

Yes, sure.
My point was regarding the pre z10 statement.  We will see hosts without stfl(e)11 when running nested on z14, z15 and co.
