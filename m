Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6D55CC21
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiF0N0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 09:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiF0N0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 09:26:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514E5641B;
        Mon, 27 Jun 2022 06:26:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RDCRHH030242;
        Mon, 27 Jun 2022 13:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=s99/+dMCP5Na2oGeAku/6BNxmRFkfv++KVJ6JpH6NO0=;
 b=G4kMKYTHYBtHRZHH9UZ6IYgTKZGU2bSFaF5IzidM0V38cHVNJOkFQSr/yT2QC40VnziQ
 iZ5om3oZ6k3ewoL0HZUAalPHrhbjHGD1yoDiVPJmnxaxBbZ4GKSLS+Pr+Z3jQ2mNYjg+
 kW8BooifsrkrIgr4Tj/PxFIPypM/sD0nm0sj6z05+OH5gRn5Iadc9cq+usC3EZrXFFVe
 RzYySrwtmKvNzsAeaeU4rNXEVkd+JkcuoCIJC7hIy5ps/8irAQfdCsNAoQ5XsycQDJt+
 Tuj2QECBCV2dQgeret+ImMhrl7RLBrBv9ElLkNx6t4NG6DaRTJXS3E1F3gfM0USl53wJ vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyd7kgc0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:26:17 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RDCjsf030982;
        Mon, 27 Jun 2022 13:26:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyd7kgbyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:26:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RDLQto029676;
        Mon, 27 Jun 2022 13:26:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj3120-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:26:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RDQCwR15729074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 13:26:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00D8011C04A;
        Mon, 27 Jun 2022 13:26:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4856611C04C;
        Mon, 27 Jun 2022 13:26:11 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 13:26:11 +0000 (GMT)
Message-ID: <00fcc248-5b11-3cb0-f4be-c8b94819cc54@linux.ibm.com>
Date:   Mon, 27 Jun 2022 15:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <5217b1ec-c170-d046-5158-e17ffcfe8316@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5217b1ec-c170-d046-5158-e17ffcfe8316@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -wGU27bUG4dDRKCxBg47hhCIVxR8bWS1
X-Proofpoint-ORIG-GUID: 2OJW--9fdFaoidh3LOKqiLKZW4owSL_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 08:22, Janosch Frank wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> We report a topology change to the guest for any CPU hotplug.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> On every vCPU creation we set the MCTR bit to let the guest know the
>> next time he uses the PTF with command 2 instruction that the
>> topology changed and that he should use the STSI(15.1.x) instruction
>> to get the topology details.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>>   arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>>   arch/s390/kvm/priv.c             | 15 +++++++++++----
>>   arch/s390/kvm/vsie.c             |  3 +++
>>   4 files changed, 48 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index 766028d54a3e..bb54196d4ed6 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -97,15 +97,19 @@ struct bsca_block {
>>       union ipte_control ipte_control;
>>       __u64    reserved[5];
>>       __u64    mcn;
>> -    __u64    reserved2;
>> +#define SCA_UTILITY_MTCR    0x8000
> 
> I'm not too happy having this in the bsca but not in the esca. I'd 
> suggest putting it outside the structs or to go with my next suggestion:
> 
> Just make it a bit field struct and make that a member in bsca/esca.
> No messing about with ANDing, ORing etc.
> 
> It's unfortunate that we only use one bit in that field but I'd still 
> find it easier to read.

OK

> 
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
>>       struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
>>   };
>> @@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
>>   #define ECB_SPECI    0x08
>>   #define ECB_SRSI    0x04
>>   #define ECB_HOSTPROTINT    0x02
>> +#define ECB_PTF        0x01
>>       __u8    ecb;            /* 0x0061 */
>>   #define ECB2_CMMA    0x80
>>   #define ECB2_IEP    0x20
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 8fcb56141689..95b96019ca8e 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm 
>> *kvm, struct kvm_device_attr *attr)
>>       return ret;
>>   }
>> +/**
>> + * kvm_s390_sca_set_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
> 
> I'm not sure that this statement make sense since you set the mctr in 
> kvm_s390_vcpu_setup() unconditionally and don't check stfle 11.
> 
> I think we can remove the second line from this.
> 
>> + *
>> + * Updates the Multiprocessor Topology-Change-Report to signal
>> + * the guest with a topology change.
> 
> Please swap those two comments
> 
>> + */
>> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>> +{
>> +    struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't 
>> matter */
> 
> Please put the comment above the statement and maybe extend it a bit:
> SCA version doesn't matter, the utility field always has the same offset.
> 
>> +
>> +    ipte_lock(kvm);
>> +    sca->utility |= SCA_UTILITY_MTCR;
>> +    ipte_unlock(kvm);
>> +}
>> +
>>   static int kvm_s390_vm_set_attr(struct kvm *kvm, struct 
>> kvm_device_attr *attr)
>>   {
>>       int ret;
>> @@ -3143,7 +3162,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   {
>> -
> 
> Please remove that change
> 
>>       gmap_enable(vcpu->arch.enabled_gmap);
>>       kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>>       if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>> @@ -3272,6 +3290,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu 
>> *vcpu)
>>           vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>>       if (test_kvm_facility(vcpu->kvm, 9))
>>           vcpu->arch.sie_block->ecb |= ECB_SRSI;
>> +
>> +    /* PTF needs guest facilities to enable interpretation */
>> +    if (test_kvm_facility(vcpu->kvm, 11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
>> +
>>       if (test_kvm_facility(vcpu->kvm, 73))
>>           vcpu->arch.sie_block->ecb |= ECB_TE;
>>       if (!kvm_is_ucontrol(vcpu->kvm))
>> @@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>       rc = kvm_s390_vcpu_setup(vcpu);
>>       if (rc)
>>           goto out_ucontrol_uninit;
>> +
>> +    kvm_s390_sca_set_mtcr(vcpu->kvm);
>>       return 0;
>>   out_ucontrol_uninit:
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 12c464c7cddf..77a692238585 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>       if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> -    if (fc > 3) {
>> -        kvm_s390_set_psw_cc(vcpu, 3);
>> -        return 0;
>> -    }
>> +    /* Bailout forbidden function codes */
>> +    if (fc > 3 && fc != 15)
>> +        goto out_no_data;
>> +
>> +    /* fc 15 is provided with PTF/CPU topology support */
>> +    if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
>> +        goto out_no_data;
>>       if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
>>           || vcpu->run->s.regs.gprs[1] & 0xffff0000)
>> @@ -910,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>               goto out_no_data;
>>           handle_stsi_3_2_2(vcpu, (void *) mem);
>>           break;
>> +    case 15:
>> +        trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>> +        insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>> +        return -EREMOTE;
>>       }
>>       if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>           memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index dada78b92691..4f4fee697550 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, 
>> struct vsie_page *vsie_page)
>>       /* Host-protection-interruption introduced with ESOP */
>>       if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
>>           scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
>> +    /* CPU Topology */
> 
> Maybe also add:
> This facility only uses the utility field of the SCA and none of the cpu 
> entries that are problematic with the other interpretation facilities so 
> we can pass it through.
> 
>> +    if (test_kvm_facility(vcpu->kvm, 11))
>> +        scb_s->ecb |= scb_o->ecb & ECB_PTF;
>>       /* transactional execution */
>>       if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
>>           /* remap the prefix is tx is toggled on */
> 


OK with all comments,
I make the changes.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
