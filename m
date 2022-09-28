Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1485EDD8B
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 15:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiI1NQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 09:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiI1NQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 09:16:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1277333F
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 06:16:18 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SC4sOp030403;
        Wed, 28 Sep 2022 13:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ea9Y434e/0ULf0ZJKXyjsPi39rSoWhtnLXf1HQCIXck=;
 b=QhPbU6Q7nIZCLVsJBzcUWgk8CxgF8wbxcf0UcAQBFT1TS+nR8CEiVeZReLF3QNU0DPek
 9i1hqFDU4bscBN7LJptkVcJk6dOSqIY8c9lsekXmEurvDFyISh5YIICmleOT+8ymD5Wf
 hg+o0iNnSKpG8aFTZZs7qpRO3Cz+IK1H8q3xaYtQR53VYI+aNA6OFnCi+bGlAQrLXeCU
 OJA445zLTlchwINTtjs2sfXseid25LGBUhtPSCT6Vx9JSHpeiexYRuOCYrz/yW2gYsbT
 WRA0NePotLaLoufEKdZEVIQ6eMkTqq7N6u9Npz0P4w8/XdePNFSuHRHR8Ey0w6HWPkQA Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjn70u88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 13:15:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28SBQBct023858;
        Wed, 28 Sep 2022 13:15:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjn70u7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 13:15:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28SD5lZu001869;
        Wed, 28 Sep 2022 13:15:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jssh9d96p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 13:15:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28SDFr8160752320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 13:15:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 958324C050;
        Wed, 28 Sep 2022 13:15:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B2D54C046;
        Wed, 28 Sep 2022 13:15:52 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 13:15:52 +0000 (GMT)
Message-ID: <43d0b978-8b38-97c0-213f-107eb76ae309@linux.ibm.com>
Date:   Wed, 28 Sep 2022 15:15:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-3-pmorel@linux.ibm.com>
 <89d6f37e-c521-4dd6-fd13-c7394bd0ab94@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <89d6f37e-c521-4dd6-fd13-c7394bd0ab94@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GOo3_rfCf7VyehALJk-HZ3SsTwczBI0W
X-Proofpoint-GUID: 3RQ9TehLSJwCE_c_F2R6N2V8vFJFird1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_04,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280081
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/22 14:03, Cédric Le Goater wrote:
> On 9/2/22 09:55, Pierre Morel wrote:
>> In the S390x CPU topology the core_id specifies the CPU address
>> and the position of the core withing the topology.
>>
>> Let's build the topology based on the core_id.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c         | 135 ++++++++++++++++++++++++++++++++
>>   hw/s390x/meson.build            |   1 +
>>   hw/s390x/s390-virtio-ccw.c      |  10 +++
>>   include/hw/s390x/cpu-topology.h |  42 ++++++++++
>>   4 files changed, 188 insertions(+)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..a6ca006ec5
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,135 @@
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
>> +
>> +    socket_id = core_id / topo->cores;
>> +
>> +    bit = core_id;
>> +    origin = bit / 64;
>> +    bit %= 64;
>> +    bit = 63 - bit;
>> +
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
> 
> Do we have CPU unplug on s390x ?

not in QEMU.

I will change this sentence.

> 
>> +     * The firmware assume that all CPU in a CPU TLE have the same
>> +     * type, polarization and are all dedicated or shared.
>> +     * In the case a socket contains CPU with different type, 
>> polarization
>> +     * or entitlement then they will be defined in different CPU 
>> containers.
>> +     * Currently we assume all CPU are identical IFL CPUs and that 
>> they are
>> +     * all dedicated CPUs.
>> +     * The only reason to have several S390TopologyCores inside a 
>> socket is
>> +     * to have more than 64 CPUs.
>> +     * In that case the origin field, representing the offset of the 
>> first CPU
>> +     * in the CPU container allows to represent up to the maximal 
>> number of
>> +     * CPU inside several CPU containers inside the socket container.
>> +     */
>> +    topo->socket[socket_id].active_count++;
>> +    topo->tle[socket_id].active_count++;
>> +    set_bit(bit, &topo->tle[socket_id].mask[origin]);
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
> Using qdev_get_machine() is suspicious :)

OK

> 
>> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
>> +    int n;
>> +
>> +    topo->sockets = ms->smp.sockets;
>> +    topo->cores = ms->smp.cores;
>> +    topo->tles = ms->smp.max_cpus;
> 
> These look like object properties to me.

It is a temporary store to keep them at hand.
I will see if I keep them afterall.
If I keep them I will make them property.

> 
>> +
>> +    n = topo->sockets;
>> +    topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
>> +    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
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
> 
> no vmstate ?

it is added in a later patch

> 
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
>> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
>> index de28a90a57..96d7d7d231 100644
>> --- a/hw/s390x/meson.build
>> +++ b/hw/s390x/meson.build
>> @@ -2,6 +2,7 @@ s390x_ss = ss.source_set()
>>   s390x_ss.add(files(
>>     'ap-bridge.c',
>>     'ap-device.c',
>> +  'cpu-topology.c',
>>     'ccw-device.c',
>>     'css-bridge.c',
>>     'css.c',
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index b5ca154e2f..15cefd104b 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -43,6 +43,7 @@
>>   #include "sysemu/sysemu.h"
>>   #include "hw/s390x/pv.h"
>>   #include "migration/blocker.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   static Error *pv_mig_blocker;
>> @@ -247,6 +248,12 @@ static void ccw_init(MachineState *machine)
>>       /* init memory + setup max page size. Required for the CPU model */
>>       s390_memory_init(machine->ram);
>> +    /* Adding the topology must be done before CPU intialization*/
>> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> +    object_property_add_child(qdev_get_machine(), 
>> TYPE_S390_CPU_TOPOLOGY,
> 
> No need to use qdev_get_machine(), you have 'machine' above.

OK

> 
>> +                              OBJECT(dev));
>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> 
> 
> why not store a TYPE_S390_CPU_TOPOLOGY object pointer under the machine
> state for later use ?

May be, I will think about it.

> 
>> +
>>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>>       s390_init_cpus(machine);
>> @@ -309,6 +316,9 @@ static void s390_cpu_plug(HotplugHandler 
>> *hotplug_dev,
>>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>> +    /* Inserting the CPU in the Topology can not fail */
>> +    s390_topology_new_cpu(cpu->env.core_id);
>> +
> 
> in which case, we could use the topo object pointer to insert a new CPU
> id and drop s390_get_topology() which looks overkill.
> 
> I would add the test :
> 
>     if (!S390_CCW_MACHINE(machine)->topology_disable) {
> 
> before inserting to be consistent. But I am anticipating some other
> patch.

It belongs here for bisect so I will add it here.
Thanks.

> 
> C.
> 
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
