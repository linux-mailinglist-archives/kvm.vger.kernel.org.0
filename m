Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8A62BE5E
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiKPMkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 07:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiKPMju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 07:39:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5484D116C
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 04:39:48 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGBdYap009661;
        Wed, 16 Nov 2022 12:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=m6WiBs7GyAPFVARgKy/MKSARc9RK6vbpu7hf/mZYE3M=;
 b=G81yPu799OJ3ixa5FsWmjk8SHOhNPhMn4nMODTiDw9xssjosU6LsrenLKNWHRH31O8wM
 0oR/EnVFSrOP8Kl+LcbkqOn1IAq6siNwm1o/CcKiMYvDeaU1pto5zDoxIJWho/jOzaA6
 9DdBqrd2X9PEZ/5EEjpdoRFmCQMMk3CSaVpIX5+6+Jr/ECAg462prPu3MG8p2SXa7+Sk
 XXi4boHm82gLyD4vEWSEzRl3WT01I3BvTiGeLvEiMy4y6Gz9nzt7OjMIosmSRfFLlvEL
 aiYTHQLNxWDOjg8Ox8dLgIyVNw8AxnfDBdsjLh45SW9PJAhN7KCNV6tQiJw1AvIoTz5Y Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kvy639h93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 12:39:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AGBeMnw011433;
        Wed, 16 Nov 2022 12:39:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kvy639h89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 12:39:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AGCYtST025701;
        Wed, 16 Nov 2022 12:39:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3kt3494drj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 12:39:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AGCdQbN39452962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 12:39:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F1085204F;
        Wed, 16 Nov 2022 12:39:26 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 711575204E;
        Wed, 16 Nov 2022 12:39:25 +0000 (GMT)
Message-ID: <757660a9-97e7-5529-dcf2-a575c19cee28@linux.ibm.com>
Date:   Wed, 16 Nov 2022 13:39:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 09/11] s390x/cpu topology: add topology machine
 property
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-10-pmorel@linux.ibm.com>
 <b5540c7e-3c06-565a-6571-55c167ec347b@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b5540c7e-3c06-565a-6571-55c167ec347b@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7MB61aTf8Ve4-jmELiPFXgnmzrhmUmGQ
X-Proofpoint-ORIG-GUID: E1LjSLgDsEcE5AX7RYTEoSSrmBI7vgrX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/15/22 14:48, Cédric Le Goater wrote:
> On 11/3/22 18:01, Pierre Morel wrote:
>> We keep the possibility to switch on/off the topology on newer
>> machines with the property topology=[on|off].
> 
> The code has changed. You will need to rebase. May be after the
> 8.0 machine is introduced, or include Cornelia's patch in the
> respin.
> 
> https://lore.kernel.org/qemu-devel/20221111124534.129111-1-cohuck@redhat.com/
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/boards.h                |  3 +++
>>   include/hw/s390x/cpu-topology.h    |  8 +++-----
>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>   hw/core/machine.c                  |  3 +++
>>   hw/s390x/cpu-topology.c            | 19 +++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         | 28 ++++++++++++++++++++++++++++
>>   util/qemu-config.c                 |  4 ++++
>>   qemu-options.hx                    |  6 +++++-
>>   8 files changed, 66 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 311ed17e18..67147c47bf 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -379,6 +379,9 @@ struct MachineState {
>>       } \
>>       type_init(machine_initfn##_register_types)
>> +extern GlobalProperty hw_compat_7_2[];
>> +extern const size_t hw_compat_7_2_len;
>> +
>>   extern GlobalProperty hw_compat_7_1[];
>>   extern const size_t hw_compat_7_1_len;
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> index 6fec10e032..f566394302 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -12,6 +12,8 @@
>>   #include "hw/qdev-core.h"
>>   #include "qom/object.h"
>> +#include "cpu.h"
>> +#include "hw/s390x/s390-virtio-ccw.h"
>>   #define S390_TOPOLOGY_CPU_IFL 0x03
>>   #define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>> @@ -38,10 +40,6 @@ struct S390Topology {
>>   OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>>   void s390_topology_new_cpu(S390CPU *cpu);
>> -
>> -static inline bool s390_has_topology(void)
>> -{
>> -    return false;
>> -}
>> +bool s390_has_topology(void);
>>   #endif
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 89fca3f79f..d7602aedda 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>       bool dea_key_wrap;
>>       bool pv;
>>       bool zpcii_disable;
>> +    bool cpu_topology;
>>       uint8_t loadparm[8];
>>       void *topology;
>>   };
>> diff --git a/hw/core/machine.c b/hw/core/machine.c
>> index aa520e74a8..4f46d4ef23 100644
>> --- a/hw/core/machine.c
>> +++ b/hw/core/machine.c
>> @@ -40,6 +40,9 @@
>>   #include "hw/virtio/virtio-pci.h"
>>   #include "qom/object_interfaces.h"
>> +GlobalProperty hw_compat_7_2[] = {};
>> +const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
>> +
>>   GlobalProperty hw_compat_7_1[] = {};
>>   const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index fc220bd8ac..c1550cc1e8 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -73,6 +73,25 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, 
>> uintptr_t ra)
>>       }
>>   }
>> +bool s390_has_topology(void)
>> +{
>> +    static S390CcwMachineState *ccw;
>> +    Object *obj;
>> +
>> +    if (ccw) {
>> +        return ccw->cpu_topology;
> 
> Shouldn't we test the capability also ?
> 
>      return s390mc->topology_capable && ccw->cpu_topology;

yes thanks

> 
>> +    }
>> +
>> +    /* we have to bail out for the "none" machine */
>> +    obj = object_dynamic_cast(qdev_get_machine(),
>> +                              TYPE_S390_CCW_MACHINE);
>> +    if (!obj) {
>> +        return false;
>> +    }
> 
> Should be an assert I think.

OK

> 
>> +    ccw = S390_CCW_MACHINE(obj);
>> +    return ccw->cpu_topology;
>> +}
>> +
>>   /*
>>    * s390_topology_new_cpu:
>>    * @cpu: a pointer to the new CPU
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index f1a9d6e793..ebb5615337 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -710,6 +710,26 @@ bool hpage_1m_allowed(void)
>>       return get_machine_class()->hpage_1m_allowed;
>>   }
>> +static inline bool machine_get_topology(Object *obj, Error **errp)
>> +{
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>> +
>> +    return ms->cpu_topology;
>> +}
>> +
>> +static inline void machine_set_topology(Object *obj, bool value, 
>> Error **errp)
>> +{
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> 
> You could introduce :
> 
>         S390CcwMachineClass *s390mc = S390_CCW_MACHINE_GET_CLASS(ms);

Yes thanks

> 
> 
>> +
>> +    if (!get_machine_class()->topology_capable) {
> 
> and
>              !s390mc->topology_capable
> 
>> +        error_setg(errp, "Property cpu-topology not available on 
>> machine %s",
>> +                   get_machine_class()->parent_class.name);
>> +        return;
>> +    }
>> +
>> +    ms->cpu_topology = value;
>> +}
>> +
>>   static void machine_get_loadparm(Object *obj, Visitor *v,
>>                                    const char *name, void *opaque,
>>                                    Error **errp)
>> @@ -809,6 +829,12 @@ static void ccw_machine_class_init(ObjectClass 
>> *oc, void *data)
>>                                      machine_set_zpcii_disable);
>>       object_class_property_set_description(oc, "zpcii-disable",
>>               "disable zPCI interpretation facilties");
>> +
>> +    object_class_property_add_bool(oc, "topology",
>> +                                   machine_get_topology,
>> +                                   machine_set_topology);
>> +    object_class_property_set_description(oc, "topology",
>> +            "enable CPU topology");
>>   }
>>   static inline void s390_machine_initfn(Object *obj)
>> @@ -818,6 +844,7 @@ static inline void s390_machine_initfn(Object *obj)
>>       ms->aes_key_wrap = true;
>>       ms->dea_key_wrap = true;
>>       ms->zpcii_disable = false;
>> +    ms->cpu_topology = true;
>>   }
>>   static const TypeInfo ccw_machine_info = {
>> @@ -888,6 +915,7 @@ static void 
>> ccw_machine_7_1_instance_options(MachineState *machine)
>>       s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
>>       s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>>       ms->zpcii_disable = true;
>> +    ms->cpu_topology = true;
> 
> shouldn't this be false ?

:) yes
I forgot to change this when I change the logic.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
