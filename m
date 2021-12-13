Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF58472949
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbhLMKTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:19:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241151AbhLMKPz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:15:55 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDA2oJN008489;
        Mon, 13 Dec 2021 10:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vs5S2zVMMY17j69nvV+eAL+nwv16G3rv0XJC50/b134=;
 b=D+z6o8a2jZf20aTU0xDTTwEsgyms8G+umwpe3qEYLiz00EsoF/ciIfxBH6xX6eknMK63
 UGiNsKYPEx2pNh/eIsQL4aiCcG7WLW4emmRKQwEmT6PC6jD4cb2kp8ZOzFCptsooYb1z
 26cVnBWvvxHay4dER7uwMXjkTM0nr46EHkJTtkWnoXUtL0mDt4lZqJ7EJDKjXkmaU2hU
 Tjs9Djp1EpfJrm0X1jqqqT0RnpxomKqb1cy4RBRTw30QiQZnWc8LcSy41M9p2NmC3KmS
 ZQc0F5AuRgBN+vwtd73IQzFLgD88DEBNS2xkg7zlGoLA3F10rs9cUNdGuYx1fyrhXwVJ IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx430g70x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:15:53 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDA7uWx029832;
        Mon, 13 Dec 2021 10:15:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx430g70e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:15:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDAF4dc024500;
        Mon, 13 Dec 2021 10:15:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3cvkm9tne1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 10:15:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDA7r0b27918812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 10:07:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C62B911C054;
        Mon, 13 Dec 2021 10:15:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D8A611C052;
        Mon, 13 Dec 2021 10:15:47 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Dec 2021 10:15:47 +0000 (GMT)
Message-ID: <acf26e48-733b-06ab-e172-0f058c3d8624@linux.ibm.com>
Date:   Mon, 13 Dec 2021 11:16:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 1/1] s390x: KVM: accept STSI for CPU topology
 information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
 <20211122131443.66632-2-pmorel@linux.ibm.com>
 <4f564761-a646-f80e-2aa7-b4dfca596d02@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <4f564761-a646-f80e-2aa7-b4dfca596d02@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JYqABVoIs-vUO_TXhK61OhuD0JHab3zi
X-Proofpoint-ORIG-GUID: JRQOFhjwl8PPqC5oG49U5Vt5kx0uroHd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_03,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 impostorscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/21 17:08, Janosch Frank wrote:
> On 11/22/21 14:14, Pierre Morel wrote:
>> We let the userland hypervisor know if the machine support the CPU
>> topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>
>> The PTF instruction will report a topology change if there is any change
>> with a previous STSI_15_1_2 SYSIB.
>> Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
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
>> We assume in this patch:
>> - no polarization change: only horizontal polarization is currently
>>    used in linux.
>> - no CPU Type change: only IFL Type are supported in Linux
>> - Dedication: with this patch, only a complete dedicated CPU stack can
>>    take benefit of the CPU Topology.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   Documentation/virt/kvm/api.rst   | 16 ++++++++++
>>   arch/s390/include/asm/kvm_host.h | 14 ++++++---
>>   arch/s390/kvm/kvm-s390.c         | 52 +++++++++++++++++++++++++++++++-
>>   arch/s390/kvm/priv.c             |  7 ++++-
>>   arch/s390/kvm/vsie.c             |  3 ++
>>   include/uapi/linux/kvm.h         |  1 +
>>   6 files changed, 87 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst 
>> b/Documentation/virt/kvm/api.rst
>> index aeeb071c7688..e5c9da0782a6 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -7484,3 +7484,19 @@ The argument to KVM_ENABLE_CAP is also a 
>> bitmask, and must be a subset
>>   of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>>   the hypercalls whose corresponding bit is in the argument, and return
>>   ENOSYS for the others.
>> +
>> +8.17 KVM_CAP_S390_CPU_TOPOLOGY
>> +------------------------------
>> +
>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>> +:Architectures: s390
>> +:Type: vm
>> +
>> +This capability indicates that kvm will provide the S390 CPU Topology 
>> facility
>> +which consist of the interpretation of the PTF instruction for the 
>> Function
>> +Code 2 along with interception and forwarding of both the PTF 
>> instruction
>> +with function Codes 0 or 1 and the STSI(15,1,x) instruction to the 
>> userland
> 
> The capitalization of "Function code" is inconsistent.

ok

> 
>> +hypervisor.
>> +
>> +The stfle facility 11, CPU Topology facility, should not be provided 
>> to the
>> +guest without this capability.
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index a604d51acfc8..cccc09a8fdab 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -95,15 +95,19 @@ struct bsca_block {
>>       union ipte_control ipte_control;
>>       __u64    reserved[5];
>>       __u64    mcn;
>> -    __u64    reserved2;
>> +#define ESCA_UTILITY_MTCR    0x8000
>> +    __u16    utility;
>> +    __u8    reserved2[6];
>>       struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>>   };
>>   struct esca_block {
>>       union ipte_control ipte_control;
>> -    __u64   reserved1[7];
>> +    __u64   reserved1[6];
>> +    __u16    utility;
>> +    __u8    reserved2[6];
>>       __u64   mcn[4];
>> -    __u64   reserved2[20];
>> +    __u64   reserved3[20];
> 
> Note to self: Prime example for a move to reserved member names based on 
> offsets.

yes

> 
>>       struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>>   };
>> @@ -228,7 +232,7 @@ struct kvm_s390_sie_block {
>>       __u8    icptcode;        /* 0x0050 */
>>       __u8    icptstatus;        /* 0x0051 */
>>       __u16    ihcpu;            /* 0x0052 */
>> -    __u8    reserved54;        /* 0x0054 */
>> +    __u8    mtcr;            /* 0x0054 */
>>   #define IICTL_CODE_NONE         0x00
>>   #define IICTL_CODE_MCHK         0x01
>>   #define IICTL_CODE_EXT         0x02
>> @@ -247,6 +251,7 @@ struct kvm_s390_sie_block {
>>   #define ECB_SPECI    0x08
>>   #define ECB_SRSI    0x04
>>   #define ECB_HOSTPROTINT    0x02
>> +#define ECB_PTF        0x01
>>       __u8    ecb;            /* 0x0061 */
>>   #define ECB2_CMMA    0x80
>>   #define ECB2_IEP    0x20
>> @@ -748,6 +753,7 @@ struct kvm_vcpu_arch {
>>       bool skey_enabled;
>>       struct kvm_s390_pv_vcpu pv;
>>       union diag318_info diag318_info;
>> +    int prev_cpu;
>>   };
>>   struct kvm_vm_stat {
> 
> [..]
> 
>>   }
>> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +static void kvm_s390_set_mtcr(struct kvm_vcpu *vcpu)
> 
> We change a vcpu related data structure, there should be "vcpu" in the 
> function name to indicate that.

ok

> 
>>   {
>> +    struct esca_block *esca = vcpu->kvm->arch.sca;
>> +    if (vcpu->arch.sie_block->ecb & ECB_PTF) {
> 
> I'm wondering if we should replace these checks with the 
> test_kvm_facility() ones. ECB_PTF is never changed after vcpu setup, right?

sure, it is left from the first draw as the patch supported both 
interpretation and interception.

> 
>> +        ipte_lock(vcpu);
>> +        WRITE_ONCE(esca->utility, ESCA_UTILITY_MTCR);
>> +        ipte_unlock(vcpu);
>> +    }
>> +}
>> +
>> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>>       gmap_enable(vcpu->arch.enabled_gmap);
>>       kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>>       if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>>           __start_cpu_timer_accounting(vcpu);
>>       vcpu->cpu = cpu;
>> +
>> +    /*
>> +     * With PTF interpretation the guest will be aware of topology
>> +     * change when the Multiprocessor Topology-Change-Report is pending.
>> +     * We check for events modifying the result of STSI_15_2:
>> +     * - A new vCPU has been hotplugged (prev_cpu == -1)
>> +     * - The real CPU backing up the vCPU moved to another socket
>> +     */
>> +    if (vcpu->arch.sie_block->ecb & ECB_PTF) {
>> +        if (vcpu->arch.prev_cpu == -1 ||
>> +            (topology_physical_package_id(cpu) !=
>> +             topology_physical_package_id(vcpu->arch.prev_cpu)))
> 
> This is barely readable, might be good to put this check in a separate 
> function in kvm-s390.h.

ok

> 
>> +            kvm_s390_set_mtcr(vcpu);
>> +    }
>>   }
>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>> +    /* Remember which CPU was backing the vCPU */
>> +    vcpu->arch.prev_cpu = vcpu->cpu;
>>       vcpu->cpu = -1;
>>       if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>>           __stop_cpu_timer_accounting(vcpu);
>> @@ -3220,6 +3263,13 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu 
>> *vcpu)
>>           vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>>       if (test_kvm_facility(vcpu->kvm, 9))
>>           vcpu->arch.sie_block->ecb |= ECB_SRSI;
>> +
>> +    /* PTF needs guest facilities to enable interpretation */
> 
> Please explain.
> How is this different from any other facility a few lines above in this 
> function?

it is not I remove the comment, here again left from the time the patch 
supported interception.

> 
>> +    if (test_kvm_facility(vcpu->kvm, 11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
>> +    /* Set the prev_cpu value to an impossible value to detect a new 
>> vcpu */
> 
> We can either change this to:
> "A prev_value of -1 indicates this is a new vcpu"
> 
> Or we define a constant which will also make the check in 
> kvm_arch_vcpu_load() easier to understand.

ok, the constant would be clearer.

> 
>> +    vcpu->arch.prev_cpu = -1;
>> +
>>       if (test_kvm_facility(vcpu->kvm, 73))
>>           vcpu->arch.sie_block->ecb |= ECB_TE;
>>       if (!kvm_is_ucontrol(vcpu->kvm))
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 417154b314a6..26d165733496 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -861,7 +861,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>       if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> -    if (fc > 3) {
>> +    if ((fc > 3 && fc != 15) ||
>> +        (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
>>           kvm_s390_set_psw_cc(vcpu, 3);
>>           return 0;
>>       }
> 
> How about:
> 
> if (fc > 3 && fc != 15)
>      goto out_no_data;
> 
> /* fc 15 is provided with PTF/CPU topology support */
> if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>      goto out_no_data;

ok, clearer


Thanks for review,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
