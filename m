Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8719A604C01
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiJSPqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJSPqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:46:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F381CA590
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:40:46 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFbbWw002310;
        Wed, 19 Oct 2022 15:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WnbJIRaZ9k3bAQBMQ8FTcZL5yv6MMVkZ6iTcyXlZKXI=;
 b=PX7GGqLIj//xyjoMWMlxDLC3XFYkp0lO/d03XqpNDll7dwzSBcgoFArsFaVIiIxbupPs
 GZPkOBv694GzhgROn0YeDv4YLzkAIPyhWnck9KjZRqHgbteDk06c1miwxMh9ghBuQRuz
 7p3FOgZfY6EPLDzAzu3JKPwa/mZXrXcVOgjR11MU8zUvxPgaC5BoKjIUL8ro313ZS+0w
 lyJOGag6eRXvYx9hQXhFot9VR0BRq0OXQmS28lmyr+Nf/mTeweldiVty7pK1EQkljTaU
 gd8hfK/kAO307dbhQ9wzyq45J4g4bX3SXZVQef8ysuMjruUzEBcBzhzv68cz24QV3krr Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmrast-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:39:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFboeq007913;
        Wed, 19 Oct 2022 15:39:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kakvmracn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:39:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JFZdb9026042;
        Wed, 19 Oct 2022 15:39:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg97eb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:39:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JFdUSt39912078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:39:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5E7842042;
        Wed, 19 Oct 2022 15:39:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 087CF4203F;
        Wed, 19 Oct 2022 15:39:30 +0000 (GMT)
Received: from [9.152.222.245] (unknown [9.152.222.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:39:29 +0000 (GMT)
Message-ID: <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
Date:   Wed, 19 Oct 2022 17:39:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-2-pmorel@linux.ibm.com>
 <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dn3w0Lg43wzNgyHTYgxGlKnHrtxVo6zH
X-Proofpoint-ORIG-GUID: XeO0wHk-QVxb8M0-1-FkPjSwE8htvtWW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/18/22 18:43, Cédric Le Goater wrote:
> Hello Pierre,
> 
> On 10/12/22 18:20, Pierre Morel wrote:
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the core withing the topology.
>>
>> Let's build the topology based on the core_id.
>> s390x/cpu topology: core_id sets s390x CPU topology
>>
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the cpu withing the topology.
>>
>> Let's build the topology based on the core_id.
> 
> The commit log is doubled.

Yes, thanks.

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  45 +++++++++++
>>   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c      |  21 +++++
>>   hw/s390x/meson.build            |   1 +
>>   4 files changed, 199 insertions(+)
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..66c171d0bc
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,45 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright 2022 IBM Corp.
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
>> +typedef struct S390TopoContainer {
>> +    int active_count;
>> +} S390TopoContainer;
> 
> This structure does not seem very useful.
> 
>> +
>> +#define S390_TOPOLOGY_CPU_IFL 0x03
>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>> +typedef struct S390TopoTLE { 
> 
> The 'Topo' is redundant as TLE stands for 'topology-list entry'. This is 
> minor.
> 
>> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>> +} S390TopoTLE;
>> +
>> +struct S390Topology {
>> +    SysBusDevice parent_obj;
>> +    int cpus;
>> +    S390TopoContainer *socket;
>> +    S390TopoTLE *tle;
>> +    MachineState *ms;
> 
> hmm, it would be cleaner to introduce the fields and properties needed
> by the S390Topology model and avoid dragging the machine object pointer.
> AFAICT, these properties would be :
> 
>    "nr-cpus"
>    "max-cpus"
>    "nr-sockets"
> 

OK

> 
> 
>> +};
>> +
>> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>> +
>> +S390Topology *s390_get_topology(void);
>> +void s390_topology_new_cpu(int core_id);
>> +
>> +static inline bool s390_has_topology(void)
>> +{
>> +    return false;
>> +}
>> +
>> +#endif
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..42b22a1831
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,132 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
> 
> The Copyright tag is different in the .h file.

OK, I change this to be like in the header file it seems to be the most 
used format.

> 
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
>> +S390Topology *s390_get_topology(void)
>> +{
>> +    static S390Topology *s390Topology;
>> +
>> +    if (!s390Topology) {
>> +        s390Topology = S390_CPU_TOPOLOGY(
>> +            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
>> +    }
>> +
>> +    return s390Topology;
> 
> I am not convinced this routine is useful. The s390Topology pointer
> could be stored under the machine state I think. It wouldn't be a
> problem when CPUs are hot plugged since we have access to the machine
> in the hot plug handler.

OK, I add a pointer to the machine state that will be initialised during 
s390_init_topology()

> 
> For the stsi call, 'struct ArchCPU' probably lacks a back pointer to
> the machine objects with which CPU interact. These are typically
> interrupt controllers or this new s390Topology model. You could add
> the pointer there or, better, under a generic 'void *opaque' attribute.
> 
> That said, what you did works fine. The modeling could be cleaner.

Yes. I think you are right and I add a opaque pointer to the topology.

> 
>> +}
>> +
>> +/*
>> + * s390_topology_new_cpu:
>> + * @core_id: the core ID is machine wide
>> + *
>> + * The topology returned by s390_get_topology(), gives us the CPU
>> + * topology established by the -smp QEMU aruments.
>> + * The core-id gives:
>> + *  - the Container TLE (Topology List Entry) containing the CPU TLE.
>> + *  - in the CPU TLE the origin, or offset of the first bit in the 
>> core mask
>> + *  - the bit in the CPU TLE core mask
>> + */
>> +void s390_topology_new_cpu(int core_id)
>> +{
>> +    S390Topology *topo = s390_get_topology();
>> +    int socket_id;
>> +    int bit, origin;
>> +
>> +    /* In the case no Topology is used nothing is to be done here */
>> +    if (!topo) {
>> +        return;
>> +    }
> 
> I would move this test in the caller.

Check will disapear with the new implementation.

> 
>> +
>> +    socket_id = core_id / topo->cpus;
>> +
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * unsigned long which represent the presence of a CPU.
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
>> +    set_bit(bit, &topo->tle[socket_id].mask[origin]);
> 
> here, the tle array is indexed with a socket id and ...

It was stupid to keep both structures.
I will keep only the socket structure and incorparate the TLE inside.

> 
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
>> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
>> +
>> +    topo->cpus = ms->smp.cores * ms->smp.threads;> +
>> +    topo->socket = g_new0(S390TopoContainer, ms->smp.sockets);
>> +    topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);
> 
> 
> ... here, the tle array is allocated with max_cpus and this looks
> weird. I will dig the specs to try to understand.

ack it looks weird. I keep only the socket structure

> 
>> +
>> +    topo->ms = ms;
> 
> See comment above regarding the properties.
> 
>> +}
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
>> index 03855c7231..aa99a62e42 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -43,6 +43,7 @@
>>   #include "sysemu/sysemu.h"
>>   #include "hw/s390x/pv.h"
>>   #include "migration/blocker.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   static Error *pv_mig_blocker;
>> @@ -94,6 +95,18 @@ static void s390_init_cpus(MachineState *machine)
>>       }
>>   }
>> +static void s390_init_topology(MachineState *machine)
>> +{
>> +    DeviceState *dev;
>> +
>> +    if (s390_has_topology()) {
>> +        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> +        object_property_add_child(&machine->parent_obj,
>> +                                  TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
>> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>> +    }
>> +}
>> +
>>   static const char *const reset_dev_types[] = {
>>       TYPE_VIRTUAL_CSS_BRIDGE,
>>       "s390-sclp-event-facility",
>> @@ -244,6 +257,9 @@ static void ccw_init(MachineState *machine)
>>       /* init memory + setup max page size. Required for the CPU model */
>>       s390_memory_init(machine->ram);
>> +    /* Adding the topology must be done before CPU intialization */
> 
> initialization

yes, thanks


Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
