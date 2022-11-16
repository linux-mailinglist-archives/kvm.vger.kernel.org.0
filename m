Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B562B790
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 11:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiKPKSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 05:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiKPKSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 05:18:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1B1573D
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 02:18:03 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AG8mvOG029735;
        Wed, 16 Nov 2022 10:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hsCK5oAssZcDcSpCm8qAahByPqFupFQwLOZJCv9GQhw=;
 b=ZxYm8KCizwu22GkKM3d7D4pidKhPnwAoW2uzYU36NQLJmYIjlHg+xf8B8ejwsdlZXrxY
 C4RErfd7PKqR3tc8yDFMk9vgW6G2EqhpmY8v4YiARt2lYseXMrfTfOzDLyUCeJKhQgcK
 av9JkNs42jlNRYRcl19Gs+uuU8YUEpAKT7XLuKmjMU6MdXlRBYI6A6gF/pSSoGzH60Ui
 bYpGHoVlq0XcRDGsb9LrBEIJnioZrgdSLhFndYylt+7KYM6nQQJ+pyCoFtP+6nS15QhV
 wrSM1gi5+jFXdiS29k4GwOGDtRkD2SAQo6DA94jFY+s9UqdWU+0MPk1/MLlwdh7o4jAa 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kvvpc9yub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 10:17:51 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AG9sRaU011215;
        Wed, 16 Nov 2022 10:17:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kvvpc9ytr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 10:17:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AGABheY015940;
        Wed, 16 Nov 2022 10:17:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3kt348wqfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 10:17:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AGAHj1J63963524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 10:17:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FF3052052;
        Wed, 16 Nov 2022 10:17:45 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B7DE652050;
        Wed, 16 Nov 2022 10:17:44 +0000 (GMT)
Message-ID: <8e184318-d362-36e7-1930-671660cfddea@linux.ibm.com>
Date:   Wed, 16 Nov 2022 11:17:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 03/11] s390x/cpu topology: core_id sets s390x CPU
 topology
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
 <20221103170150.20789-4-pmorel@linux.ibm.com>
 <a21a6342-1fe2-e6c0-61f9-6bb68cbd2574@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <a21a6342-1fe2-e6c0-61f9-6bb68cbd2574@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yOWL_QqN0oqOI0llYfj3Up48o3lG1nwA
X-Proofpoint-ORIG-GUID: 2NYA6kl-3RUmWjYgpjon7URPEd2jXCir
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_01,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/15/22 12:15, Cédric Le Goater wrote:
> Hello Pierre,
> 
> On 11/3/22 18:01, Pierre Morel wrote:
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the core withing the topology.
>>
>> Let's build the topology based on the core_id.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h    |  41 ++++++++++
>>   include/hw/s390x/s390-virtio-ccw.h |   1 +
>>   target/s390x/cpu.h                 |   2 +
>>   hw/s390x/cpu-topology.c            | 125 +++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         |  23 ++++++
>>   hw/s390x/meson.build               |   1 +
>>   6 files changed, 193 insertions(+)
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..4e16a2153d
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,41 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>> +#define HW_S390X_CPU_TOPOLOGY_H
>> +
>> +#include "hw/qdev-core.h"
>> +#include "qom/object.h"
>> +
>> +#define S390_TOPOLOGY_CPU_IFL 0x03
>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>> +
>> +typedef struct S390TopoSocket {
>> +    int active_count;
>> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>> +} S390TopoSocket;
>> +
>> +struct S390Topology {
>> +    SysBusDevice parent_obj;
>> +    uint32_t nr_cpus;
>> +    uint32_t nr_sockets;
>> +    S390TopoSocket *socket;
>> +};
>> +
>> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>> +
>> +void s390_topology_new_cpu(S390CPU *cpu);
>> +
>> +static inline bool s390_has_topology(void)
>> +{
>> +    return false;
>> +}
>> +
>> +#endif
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 4f8a39abda..23b472708d 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -29,6 +29,7 @@ struct S390CcwMachineState {
>>       bool pv;
>>       bool zpcii_disable;
>>       uint8_t loadparm[8];
>> +    void *topology;
> 
> I think it is safe to use 'DeviceState *' or 'Object *' for the pointer
> under machine. What is most practical.

OK, DeviceState bring one less cast..

> 
>>   };
>>   struct S390CcwMachineClass {
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..c9066b2496 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -175,6 +175,8 @@ struct ArchCPU {
>>       /* needed for live migration */
>>       void *irqstate;
>>       uint32_t irqstate_saved_size;
>> +    /* Topology this CPU belongs too */
>> +    void *topology;
> 
> However, under the CPU, we don't know what the future changes reserve
> for us and I would call the attribute 'opaque' or 'machine_data'.
> 
> For now, it only holds a reference to the S390Topology device model
> but it could become a struct with time.

OK, I use machine_data

> 
> 
>>   };
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..6af41d3d7b
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,125 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> +
>> + * This work is licensed under the terms of the GNU GPL, version 2 or 
>> (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qapi/error.h"
>> +#include "qemu/error-report.h"
>> +#include "hw/sysbus.h"
>> +#include "hw/qdev-properties.h"
>> +#include "hw/boards.h"
>> +#include "qemu/typedefs.h"
>> +#include "target/s390x/cpu.h"
>> +#include "hw/s390x/s390-virtio-ccw.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +
>> +/*
>> + * s390_topology_new_cpu:
>> + * @cpu: a pointer to the new CPU
>> + *
>> + * The topology pointed by S390CPU, gives us the CPU topology
>> + * established by the -smp QEMU aruments.
>> + * The core-id is used to calculate the position of the CPU inside
>> + * the topology:
>> + *  - the socket, container TLE, containing the CPU, we have one socket
>> + *    for every nr_cpus (nr_cpus = smp.cores * smp.threads)
>> + *  - the CPU TLE inside the socket, we have potentionly up to 4 CPU TLE
>> + *    in a container TLE with the assumption that all CPU are identical
>> + *    with the same polarity and entitlement because we have maximum 256
>> + *    CPUs and each TLE can hold up to 64 identical CPUs.
>> + *  - the bit in the 64 bit CPU TLE core mask
>> + */
>> +void s390_topology_new_cpu(S390CPU *cpu)
>> +{
>> +    S390Topology *topo = (S390Topology *)cpu->topology;
> 
> where is cpu->topology set ?

In the caller but this is reworked anyway due to a rearangement of the 
function.

> 
>> +    int core_id = cpu->env.core_id;
>> +    int bit, origin;
>> +    int socket_id;
>> +
>> +    socket_id = core_id / topo->nr_cpus;
>> +
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * uint64_t which represent the presence of a CPU.
>> +     * The firmware assume that all CPU in a CPU TLE have the same
>> +     * type, polarization and are all dedicated or shared.
>> +     * In that case the origin variable represents the offset of the 
>> first
>> +     * CPU in the CPU container.
>> +     * More than 64 CPUs per socket are represented in several CPU 
>> containers
>> +     * inside the socket container.
>> +     * The only reason to have several S390TopologyCores inside a 
>> socket is
>> +     * to have more than 64 CPUs.
>> +     * In that case the origin variable represents the offset of the 
>> first CPU
>> +     * in the CPU container. More than 64 CPUs per socket are 
>> represented in
>> +     * several CPU containers inside the socket container.
>> +     */
>> +    bit = core_id;
>> +    origin = bit / 64;
>> +    bit %= 64;
>> +    bit = 63 - bit;
>> +
>> +    topo->socket[socket_id].active_count++;
>> +    set_bit(bit, &topo->socket[socket_id].mask[origin]);
>> +}
>> +
>> +/**
>> + * s390_topology_realize:
>> + * @dev: the device state
>> + * @errp: the error pointer (not used)
>> + *
>> + * During realize the machine CPU topology is initialized with the
>> + * QEMU -smp parameters.
>> + * The maximum count of CPU TLE in the all Topology can not be greater
>> + * than the maximum CPUs.
>> + */
>> +static void s390_topology_realize(DeviceState *dev, Error **errp)
>> +{
>> +    MachineState *ms = MACHINE(qdev_get_machine());
> 
> hmm,

will disappear

> 
>> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
>> +
>> +    topo->nr_cpus = ms->smp.cores * ms->smp.threads;
>> +    topo->nr_sockets = ms->smp.sockets;
> 
> These properties should be set in s390_init_topology() with :
> 
>    object_property_set_int(OBJECT(dev), "num-cpus",
>                            ms->smp.cores * ms->smp.threads, errp);
> 
>    object_property_set_int(OBJECT(dev), "num-sockets",
>                            ms->smp.sockets, errp);
> 
> before calling sysbus_realize_and_unref()

OK, done

> 
> 
>> +    topo->socket = g_new0(S390TopoSocket, topo->nr_sockets);
> 
> For consistency, you could add an unrealize handler to free the array.

yes

> 
>> +}
>> +
>> +static Property s390_topology_properties[] = {
>> +    DEFINE_PROP_UINT32("nr_cpus", S390Topology, nr_cpus, 1),
>> +    DEFINE_PROP_UINT32("nr_sockets", S390Topology, nr_sockets, 1),
> 
> A quick audit of the property names in QEMU code shows that a "num-" prefix
> is usually preferred.

OK

> 
>> +    DEFINE_PROP_END_OF_LIST(),
>> +};
>> +
>> +/**
>> + * topology_class_init:
>> + * @oc: Object class
>> + * @data: (not used)
>> + *
>> + * A very simple object we will need for reset and migration.
>> + */
>> +static void topology_class_init(ObjectClass *oc, void *data)
>> +{
>> +    DeviceClass *dc = DEVICE_CLASS(oc);
>> +
>> +    dc->realize = s390_topology_realize;
>> +    device_class_set_props(dc, s390_topology_properties);
>> +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>> +}
>> +
>> +static const TypeInfo cpu_topology_info = {
>> +    .name          = TYPE_S390_CPU_TOPOLOGY,
>> +    .parent        = TYPE_SYS_BUS_DEVICE,
>> +    .instance_size = sizeof(S390Topology),
>> +    .class_init    = topology_class_init,
>> +};
>> +
>> +static void topology_register(void)
>> +{
>> +    type_register_static(&cpu_topology_info);
>> +}
>> +type_init(topology_register);
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 9ab91df5b1..5776d3e58f 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -44,6 +44,7 @@
>>   #include "hw/s390x/pv.h"
>>   #include "migration/blocker.h"
>>   #include "qapi/visitor.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   static Error *pv_mig_blocker;
>> @@ -102,6 +103,19 @@ static void s390_init_cpus(MachineState *machine)
>>       }
>>   }
>> +static void s390_init_topology(MachineState *machine)
>> +{
>> +    DeviceState *dev;
>> +
>> +    if (s390_has_topology()) {
> 
> I would move the s390_has_topology() check in the caller.

yes

> 
>> +        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> +        object_property_add_child(&machine->parent_obj,
>> +                                  TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
>> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>> +        S390_CCW_MACHINE(machine)->topology = dev;
> 
> and I would move the assignment in the caller also.
> 
>> +    }
>> +}
>> +
>>   static const char *const reset_dev_types[] = {
>>       TYPE_VIRTUAL_CSS_BRIDGE,
>>       "s390-sclp-event-facility",
>> @@ -252,6 +266,9 @@ static void ccw_init(MachineState *machine)
>>       /* init memory + setup max page size. Required for the CPU model */
>>       s390_memory_init(machine->ram);
>> +    /* Adding the topology must be done before CPU initialization */
>> +    s390_init_topology(machine);
>> +
>>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>>       s390_init_cpus(machine);
>> @@ -314,6 +331,12 @@ static void s390_cpu_plug(HotplugHandler 
>> *hotplug_dev,
>>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>> +    /* Inserting the CPU in the Topology can not fail */
>> +    if (S390_CCW_MACHINE(ms)->topology) {
>> +        cpu->topology = S390_CCW_MACHINE(ms)->topology;
> 
> Two QOM cast. One should be enough. Please introduce a local variable.
> 
>> +        s390_topology_new_cpu(cpu);
> 
> I would pass the 'topology' object as a parameter of 
> s390_topology_new_cpu()
> and do the cpu->topology assignment in the same routine.
> 
> May be rename it also to :
> 
>    void s390_topology_add_cpu(S390Topology *topo, S390CPU *cpu)

OK, better.

> 
> 
> Thanks,
> 
> C.


Thanks a lot for your reviewing.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
