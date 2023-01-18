Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBB467199A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjARKtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjARKsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:48:30 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570EB3018A
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:54:32 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8CLMU027698;
        Wed, 18 Jan 2023 09:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G8GESOAdrRjdUmpGxaMVbsEmzn8nQvWNQ3bad9m+swE=;
 b=oWNSGHGuQaIzUIE8HvPCoH9JPq3ZHv8ZbKYNUpoegpqt59TEHShp+ywddKsI7e9wvcST
 ppmAltYQwfbHRwMxAPaPTMhlbDcB58r+Y4UCCtwdZIt9dr7yFTKgB0H1DmLkLoGjqoqo
 vfGa8T/RKsDYY15npFXlFBz+AcsbGlzNI797IxlQmlCegkYeaBEsuLC1USJXafD23ifw
 dYLvHfRHOQqClhu+ZP8lPJbvxW7uI4cg2tktmX1ObDHWdUfK1J/tkY/ITDF1IsHommf+
 YKhXFOSQ9IDuiRv70gCjksVLp0xDq8rOKjwgEfQXMogsDd601inYWotQ2y3L5cdmFwZ9 HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6a2m63jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:54:18 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I9ruoS030796;
        Wed, 18 Jan 2023 09:54:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6a2m63hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:54:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HN0W6Z004723;
        Wed, 18 Jan 2023 09:54:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16n2q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 09:54:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I9sBpv39846362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 09:54:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0ED620049;
        Wed, 18 Jan 2023 09:54:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5F2B20043;
        Wed, 18 Jan 2023 09:54:10 +0000 (GMT)
Received: from [9.171.39.117] (unknown [9.171.39.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 09:54:10 +0000 (GMT)
Message-ID: <aca908a0-e0d0-dfec-0276-b197b4fb9d3a@linux.ibm.com>
Date:   Wed, 18 Jan 2023 10:54:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 06/11] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-7-pmorel@linux.ibm.com>
 <e27e12b2535736dcadd08a3b14caf70566487214.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e27e12b2535736dcadd08a3b14caf70566487214.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GuqNfQOjlRenrN9MUHqqXWH1J-v2kqQl
X-Proofpoint-ORIG-GUID: QlWQIVpY7UvNT5ZwqK5WQOn-0Ry14j9X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/16/23 19:24, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervizor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervizor.
>>
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h    |  3 +
>>   include/hw/s390x/s390-virtio-ccw.h |  6 ++
>>   target/s390x/cpu.h                 |  1 +
>>   hw/s390x/cpu-topology.c            | 92 ++++++++++++++++++++++++++++++
>>   target/s390x/cpu-sysemu.c          | 16 ++++++
>>   target/s390x/kvm/kvm.c             | 11 ++++
>>   6 files changed, 129 insertions(+)
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> index 9571aa70e5..33e23d78b9 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -55,11 +55,13 @@ typedef struct S390Topology {
>>       QTAILQ_HEAD(, S390TopologyEntry) list;
>>       uint8_t *sockets;
>>       CpuTopology *smp;
>> +    int polarity;
>>   } S390Topology;
>>   
>>   #ifdef CONFIG_KVM
>>   bool s390_has_topology(void);
>>   void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
>> +void s390_topology_set_polarity(int polarity);
>>   #else
>>   static inline bool s390_has_topology(void)
>>   {
>> @@ -68,6 +70,7 @@ static inline bool s390_has_topology(void)
>>   static inline void s390_topology_set_cpu(MachineState *ms,
>>                                            S390CPU *cpu,
>>                                            Error **errp) {}
>> +static inline void s390_topology_set_polarity(int polarity) {}
>>   #endif
>>   extern S390Topology s390_topology;
>>   
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
>> index 9bba21a916..c1d46e78af 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>>       uint8_t loadparm[8];
>>   };
>>   
>> +#define S390_PTF_REASON_NONE (0x00 << 8)
>> +#define S390_PTF_REASON_DONE (0x01 << 8)
>> +#define S390_PTF_REASON_BUSY (0x02 << 8)
>> +#define S390_TOPO_FC_MASK 0xffUL
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
>> +
>>   struct S390CcwMachineClass {
>>       /*< private >*/
>>       MachineClass parent_class;
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 01ade07009..5da4041576 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -864,6 +864,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
>>   int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
>>                                   int vq, bool assign);
>>   void s390_cpu_topology_reset(void);
>> +void s390_cpu_topology_set(void);
> 
> I don't like this name much, it's nondescript.
> s390_cpu_topology_set_modified ?

yes, better.

> 
>>   #ifndef CONFIG_USER_ONLY
>>   unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
>>   #else
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 438055c612..e6b4692581 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -97,6 +97,98 @@ static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>>   }
>>   
>>   /**
>> + * s390_topology_set_polarity
>> + * @polarity: horizontal or vertical
>> + *
>> + * Changes the polarity of all the CPU in the configuration.
>> + *
>> + * If the dedicated CPU modifier attribute is set a vertical
>> + * polarization is always high (Architecture).
>> + * Otherwise we decide to set it as medium.
>> + *
>> + * Once done, advertise a topology change.
>> + */
>> +void s390_topology_set_polarity(int polarity)
> 
> I don't like that this function ignores what kind of vertical polarization is passed,
> it's confusing.
> That seems like a further reason to split horizontal/vertical from the entitlement.

OK, you are right.
I remove this function and put the s390_cpu_topology_set() inside the 
handle_ptf()

> 
>> +{
>> +    S390TopologyEntry *entry;
> 
> I also expected this function to set s390_topology.polarization, but it doesn't.
>> +
>> +    QTAILQ_FOREACH(entry, &s390_topology.list, next) {
>> +        if (polarity == S390_TOPOLOGY_POLARITY_HORIZONTAL) {
>> +            entry->id.p = polarity;
>> +        } else {
>> +            if (entry->id.d) {
>> +                entry->id.p = S390_TOPOLOGY_POLARITY_VERTICAL_HIGH;
>> +            } else {
>> +                entry->id.p = S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM;
>> +            }
>> +        }
>> +    }
>> +    s390_cpu_topology_set();
>> +}
>> +
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
> 
> This comment is outdated, right? Same for those in the function body.
> 
>> + *
>> + * Function code 2 is handling topology changes and is interpreted
>> + * by the SIE.
>> + */
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
>> +{
>> +    CPUS390XState *env = &cpu->env;
>> +    uint64_t reg = env->regs[r1];
>> +    uint8_t fc = reg & S390_TOPO_FC_MASK;
>> +
>> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>> +        s390_program_interrupt(env, PGM_OPERATION, ra);
>> +        return;
>> +    }
>> +
>> +    if (env->psw.mask & PSW_MASK_PSTATE) {
>> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
>> +        return;
>> +    }
>> +
>> +    if (reg & ~S390_TOPO_FC_MASK) {
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +        return;
>> +    }
>> +
>> +    switch (fc) {
>> +    case 0:    /* Horizontal polarization is already set */
>> +        if (s390_topology.polarity == S390_TOPOLOGY_POLARITY_HORIZONTAL) {
>> +            env->regs[r1] |= S390_PTF_REASON_DONE;
>> +            setcc(cpu, 2);
>> +        } else {
>> +            s390_topology_set_polarity(S390_TOPOLOGY_POLARITY_HORIZONTAL);
>> +            s390_topology.polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
>> +            setcc(cpu, 0);
>> +        }
>> +        break;
>> +    case 1:    /* Vertical polarization is not supported */
>> +        if (s390_topology.polarity != S390_TOPOLOGY_POLARITY_HORIZONTAL) {
>> +            env->regs[r1] |= S390_PTF_REASON_DONE;
>> +            setcc(cpu, 2);
>> +        } else {
>> +            s390_topology_set_polarity(S390_TOPOLOGY_POLARITY_VERTICAL_LOW);
> 
> This is why I said it's confusing, nothing gets set to LOW.
> 
>> +            s390_topology.polarity = S390_TOPOLOGY_POLARITY_VERTICAL_LOW;
> 
> Why LOW here?
I wanted something not being S390_TOPOLOGY_POLARITY_HORIZONTAL and did 
not want to define a S390_TOPOLOGY_POLARITY_VERTICAL.

OK I define S390_TOPOLOGY_POLARITY_HORIZONTAL=0 and ..._VERTICAL=1



> 
>> +            setcc(cpu, 0);
>> +        }
>> +        break;
>> +    default:
>> +        /* Note that fc == 2 is interpreted by the SIE */
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +    }
> 
> You can simplify this by doing:
> 
> int new_polarity;
> switch (fc) {
> case 0:
> 	new_polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
> 	break;
> case 1:
> 	new_polarity = S390_TOPOLOGY_POLARITY_VERTICAL_?;
> 	break;
> default:
> 	/* Note that fc == 2 is interpreted by the SIE */
> 	s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> 	return;
> }
> 
> if same polarity:
> 	rc done, rejected
> else
> 	set polarity, initiated
> 
> Might be a good idea to turn the polarity values into an enum.
> 
>> +}
> [...]
> 

Even I never really understood the added value of an enum I can do this.

Thanks,

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
