Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7A6533838
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 10:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiEYITF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 04:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiEYITD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 04:19:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D667091F
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 01:19:00 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P7PehW005134;
        Wed, 25 May 2022 08:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rRGaEJHNQieD0jc0yRNWdjVyVl1TWIFeKno8quyBR+U=;
 b=iKfkrLkngakZE8SrDSo2gosZhVxom5AATRr+pwEpyAyDTkisE/meLXBCoHyWTQCjCjKn
 c4FbrrZxfB2rmXCl8LdqePhzNl5DSbVCOYuFLgnw++XO3Ne7n77SgcAN+epjLJbvRJkM
 lJzEJc48L6j368JJls14XqQvorx6b4VEyIdTzvYDEZV+i98DMP/TS+u1i65w7vIpcZOC
 DqWbRO8m6+udSECvQnUzM+UZu9/VC0WFRT/g9dPdrbHRgGAMClcUInCuD73QpSYqGRcZ
 Gg+kSsNQRWXkVd8RtwzCp6VBGSrrtImmvAQMsel1qTOpTuF/YxJqUXPbzgL4sOZ21vKr Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9g2c90n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:18:52 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24P8AfNa021442;
        Wed, 25 May 2022 08:18:51 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9g2c90ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:18:51 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24P8InWW009333;
        Wed, 25 May 2022 08:18:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g93ur8mkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 08:18:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24P8Hsgl35062068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 08:17:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5BE1A4051;
        Wed, 25 May 2022 08:18:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1EF9A4040;
        Wed, 25 May 2022 08:18:44 +0000 (GMT)
Received: from [9.171.31.97] (unknown [9.171.31.97])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 08:18:44 +0000 (GMT)
Message-ID: <535cefde-61ff-70d6-505d-170de7308df7@linux.ibm.com>
Date:   Wed, 25 May 2022 10:22:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 10/13] s390x: kvm: topology: interception of PTF
 instruction
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-11-pmorel@linux.ibm.com>
 <87783273-6abd-f31e-f5f3-a5cf21b1594f@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <87783273-6abd-f31e-f5f3-a5cf21b1594f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nlz3vwT8v37hiz0Cszz4pT4O_ibzptL5
X-Proofpoint-ORIG-GUID: uxUfBwYWaCULmbBDZ5KM6Ua7XrATd8rA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_02,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250037
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/22 13:27, Thomas Huth wrote:
> On 20/04/2022 13.57, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervizor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervizor.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/s390-virtio-ccw.c         | 50 ++++++++++++++++++++++++++++++
>>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>>   target/s390x/kvm/kvm.c             | 14 +++++++++
>>   3 files changed, 70 insertions(+)
>>
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 93d1a43583..1ffaddebcc 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
> 
> Why do you put this into s390-virtio-ccw.c and not into cpu_topology.c ?

Should have historical reason I forgot in between.
I will move it in cpu_topology.c

> 
>> @@ -434,6 +434,56 @@ static void 
>> s390_pv_prepare_reset(S390CcwMachineState *ms)
>>       s390_pv_prep_reset();
>>   }
>> +/*
>> + * s390_handle_ptf:
>> + *
>> + * @register 1: contains the function code
>> + *
>> + * Function codes 0 and 1 handle the CPU polarization.
>> + * We assume an horizontal topology, the only one supported currently
>> + * by Linux, consequently we answer to function code 0, requesting
>> + * horizontal polarization that it is already the current polarization
>> + * and reject vertical polarization request without further explanation.
>> + *
>> + * Function code 2 is handling topology changes and is interpreted
>> + * by the SIE.
>> + */
>> +int s390_has390_handle_ptfndle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
>> +{
>> +    CPUS390XState *env = &cpu->env;
>> +    uint64_t reg = env->regs[r1];
>> +    uint8_t fc = reg & S390_TOPO_FC_MASK;
>> +
>> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>> +        s390_program_interrupt(env, PGM_OPERATION, ra);
>> +        return 0;
>> +    }
>> +
>> +    if (env->psw.mask & PSW_MASK_PSTATE) {
>> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
>> +        return 0;
>> +    }
>> +
>> +    if (reg & ~S390_TOPO_FC_MASK) {
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +        return 0;
>> +    }
>> +
>> +    switch (fc) {
>> +    case 0:    /* Horizontal polarization is already set */
>> +        env->regs[r1] |= S390_PTF_REASON_DONE;
>> +        return 2;
>> +    case 1:    /* Vertical polarization is not supported */
>> +        env->regs[r1] |= S390_PTF_REASON_NONE;
>> +        return 2;
>> +    default:
>> +        /* Note that fc == 2 is interpreted by the SIE */
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static void s390_machine_reset(MachineState *machine)
>>   {
>>       S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 3331990e02..ac4b4a92e7 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>>       uint8_t loadparm[8];
>>   };
>> +#define S390_PTF_REASON_NONE (0x00 << 8)
>> +#define S390_PTF_REASON_DONE (0x01 << 8)
>> +#define S390_PTF_REASON_BUSY (0x02 << 8)
>> +#define S390_TOPO_FC_MASK 0xffUL
>> +int s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
>> +
>>   struct S390CcwMachineClass {
>>       /*< private >*/
>>       MachineClass parent_class;
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index 27b3fbfa09..e3792e52c2 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -98,6 +98,7 @@
>>   #define PRIV_B9_EQBS                    0x9c
>>   #define PRIV_B9_CLP                     0xa0
>> +#define PRIV_B9_PTF                     0xa2
>>   #define PRIV_B9_PCISTG                  0xd0
>>   #define PRIV_B9_PCILG                   0xd2
>>   #define PRIV_B9_RPCIT                   0xd3
>> @@ -1453,6 +1454,16 @@ static int kvm_mpcifc_service_call(S390CPU 
>> *cpu, struct kvm_run *run)
>>       }
>>   }
>> +static int kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
>> +{
>> +    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
>> +    int ret;
>> +
>> +    ret = s390_handle_ptf(cpu, r1, RA_IGNORED);
>> +    setcc(cpu, ret);
> 
> So you're still setting the CC in case the s390_handle_ptf() function 
> injected a program interrupt? ... feels wrong. Maybe the CC should be 
> set within s390_handle_ptf() instead?

OK, I will have a look and change it.

Thanks,
Pierre

> 
>   Thomas
> 
> 
>> +    return 0;
>> +}
>> +
>>   static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>>   {
>>       int r = 0;
>> @@ -1470,6 +1481,9 @@ static int handle_b9(S390CPU *cpu, struct 
>> kvm_run *run, uint8_t ipa1)
>>       case PRIV_B9_RPCIT:
>>           r = kvm_rpcit_service_call(cpu, run);
>>           break;
>> +    case PRIV_B9_PTF:
>> +        r = kvm_handle_ptf(cpu, run);
>> +        break;
>>       case PRIV_B9_EQBS:
>>           /* just inject exception */
>>           r = -1;
> 

-- 
Pierre Morel
IBM Lab Boeblingen
