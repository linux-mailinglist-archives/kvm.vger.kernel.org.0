Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89CC404780
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 11:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhIIJEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 05:04:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4894 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhIIJEr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 05:04:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1898YEo2032371;
        Thu, 9 Sep 2021 05:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/YAY+eCn01Bm0F0GNC2e0tGhJEKRvIHGBmxosDd3nlM=;
 b=BS3rX89tzk+Qq88MhMUAqoOXk546p8/5pzUKo0zDWEvIQwH2wb9Xr0XVjkhyUCVIHz6z
 VvUbtQ6g00AE07QR08qqYT+/iQAkbo9AC4Mf6sKHfVZ4TJdFL45Zvb0TOEu7twC53Yy1
 SxW+sakV2DxHm5A7sqlXjf+v90Z7zr/XSK/7BlkvVfCKwuaCboX0UWRkKVatsywY1dBn
 SoTPTioX7NQX55/9HtYCc+KBuaFo5KtIzIeG5ng1iGk8XxWaWZvTYbCsaeCz5daCyD75
 +stnUBPRYy5eFmh0WOxGrxeVitrAq1u9omhOZFewWXbUSXLcz9rABcAukqjkre6up1m3 aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aydx71yye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 05:03:38 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18990xIq136832;
        Thu, 9 Sep 2021 05:03:37 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aydx71yxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 05:03:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1898rLdH004379;
        Thu, 9 Sep 2021 09:03:35 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3axcnntdgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 09:03:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1898xBhd51577216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 08:59:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CE9811C04C;
        Thu,  9 Sep 2021 09:03:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9A0E11C05B;
        Thu,  9 Sep 2021 09:03:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.118])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Sep 2021 09:03:30 +0000 (GMT)
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
Message-ID: <8b30dd8b-45f6-c04f-a23a-2a4477e21938@linux.ibm.com>
Date:   Thu, 9 Sep 2021 11:03:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d85a6998-0f86-44d9-4eae-3051b65c2b4e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zN9Py9ZmH3zH8nFBdx_Atj6pPIPPx9SP
X-Proofpoint-ORIG-GUID: hXbG9DTZ19VRKYmdZ0mn1Oubx-WbhEnM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_02:2021-09-07,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109090050
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

I will change to this as we decided not to support emulation if the hist 
does not support facility 11.


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

No more, after Christian comments we do not want to support emulation at 
all.

> 
> 

...snip...

>> +
>> +    /* PTF needs both host and guest facilities to enable 
>> interpretation */
>> +    if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
> 
> Here you say we need both ...
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

do we really need to check at all, even for test_kvm_facility() ?
as facilities do not change during a guest session and we checked for 
setting it at first time.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
