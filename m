Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF207603114
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJRQy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJRQy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:54:28 -0400
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFB510F8
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:54:20 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.35])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 45AA8133709FD;
        Tue, 18 Oct 2022 18:43:56 +0200 (CEST)
Received: from kaod.org (37.59.142.98) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 18 Oct
 2022 18:43:55 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-98R0029b463f56-5752-4d47-81b3-790995a7cd13,
                    E583C31B167A4CECD7AFA5F42DA6B4ED7D5BF57A) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
Date:   Tue, 18 Oct 2022 18:43:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <frankja@linux.ibm.com>, <berrange@redhat.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-2-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221012162107.91734-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.98]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 4fe99c34-a3cd-4925-aa8c-80d03575d220
X-Ovh-Tracer-Id: 15549522140074969872
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgjeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpphgsohhniihinhhisehrvgguhhgrthdrtghomh
 dpmhhsthesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Pierre,

On 10/12/22 18:20, Pierre Morel wrote:
> In the S390x CPU topology the core_id specifies the CPU address
> and the position of the core withing the topology.
> 
> Let's build the topology based on the core_id.
> s390x/cpu topology: core_id sets s390x CPU topology
> 
> In the S390x CPU topology the core_id specifies the CPU address
> and the position of the cpu withing the topology.
> 
> Let's build the topology based on the core_id.

The commit log is doubled.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/cpu-topology.h |  45 +++++++++++
>   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c      |  21 +++++
>   hw/s390x/meson.build            |   1 +
>   4 files changed, 199 insertions(+)
>   create mode 100644 include/hw/s390x/cpu-topology.h
>   create mode 100644 hw/s390x/cpu-topology.c
> 
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..66c171d0bc
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,45 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright 2022 IBM Corp.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#include "hw/qdev-core.h"
> +#include "qom/object.h"
> +
> +typedef struct S390TopoContainer {
> +    int active_count;
> +} S390TopoContainer;

This structure does not seem very useful.

> +
> +#define S390_TOPOLOGY_CPU_IFL 0x03
> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
> +typedef struct S390TopoTLE { 

The 'Topo' is redundant as TLE stands for 'topology-list entry'. This is minor.

> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
> +} S390TopoTLE;
> +
> +struct S390Topology {
> +    SysBusDevice parent_obj;
> +    int cpus;
> +    S390TopoContainer *socket;
> +    S390TopoTLE *tle;
> +    MachineState *ms;

hmm, it would be cleaner to introduce the fields and properties needed
by the S390Topology model and avoid dragging the machine object pointer.
AFAICT, these properties would be :

   "nr-cpus"
   "max-cpus"
   "nr-sockets"



> +};
> +
> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
> +
> +S390Topology *s390_get_topology(void);
> +void s390_topology_new_cpu(int core_id);
> +
> +static inline bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +#endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..42b22a1831
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,132 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022

The Copyright tag is different in the .h file.
  
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/sysbus.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +S390Topology *s390_get_topology(void)
> +{
> +    static S390Topology *s390Topology;
> +
> +    if (!s390Topology) {
> +        s390Topology = S390_CPU_TOPOLOGY(
> +            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
> +    }
> +
> +    return s390Topology;

I am not convinced this routine is useful. The s390Topology pointer
could be stored under the machine state I think. It wouldn't be a
problem when CPUs are hot plugged since we have access to the machine
in the hot plug handler.

For the stsi call, 'struct ArchCPU' probably lacks a back pointer to
the machine objects with which CPU interact. These are typically
interrupt controllers or this new s390Topology model. You could add
the pointer there or, better, under a generic 'void *opaque' attribute.

That said, what you did works fine. The modeling could be cleaner.

> +}
> +
> +/*
> + * s390_topology_new_cpu:
> + * @core_id: the core ID is machine wide
> + *
> + * The topology returned by s390_get_topology(), gives us the CPU
> + * topology established by the -smp QEMU aruments.
> + * The core-id gives:
> + *  - the Container TLE (Topology List Entry) containing the CPU TLE.
> + *  - in the CPU TLE the origin, or offset of the first bit in the core mask
> + *  - the bit in the CPU TLE core mask
> + */
> +void s390_topology_new_cpu(int core_id)
> +{
> +    S390Topology *topo = s390_get_topology();
> +    int socket_id;
> +    int bit, origin;
> +
> +    /* In the case no Topology is used nothing is to be done here */
> +    if (!topo) {
> +        return;
> +    }

I would move this test in the caller.

> +
> +    socket_id = core_id / topo->cpus;
> +
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * unsigned long which represent the presence of a CPU.
> +     * The firmware assume that all CPU in a CPU TLE have the same
> +     * type, polarization and are all dedicated or shared.
> +     * In that case the origin variable represents the offset of the first
> +     * CPU in the CPU container.
> +     * More than 64 CPUs per socket are represented in several CPU containers
> +     * inside the socket container.
> +     * The only reason to have several S390TopologyCores inside a socket is
> +     * to have more than 64 CPUs.
> +     * In that case the origin variable represents the offset of the first CPU
> +     * in the CPU container. More than 64 CPUs per socket are represented in
> +     * several CPU containers inside the socket container.
> +     */
> +    bit = core_id;
> +    origin = bit / 64;
> +    bit %= 64;
> +    bit = 63 - bit;
> +
> +    topo->socket[socket_id].active_count++;
> +    set_bit(bit, &topo->tle[socket_id].mask[origin]);

here, the tle array is indexed with a socket id and ...

> +}
> +
> +/**
> + * s390_topology_realize:
> + * @dev: the device state
> + * @errp: the error pointer (not used)
> + *
> + * During realize the machine CPU topology is initialized with the
> + * QEMU -smp parameters.
> + * The maximum count of CPU TLE in the all Topology can not be greater
> + * than the maximum CPUs.
> + */
> +static void s390_topology_realize(DeviceState *dev, Error **errp)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> +
> +    topo->cpus = ms->smp.cores * ms->smp.threads;> +
> +    topo->socket = g_new0(S390TopoContainer, ms->smp.sockets);
> +    topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);


... here, the tle array is allocated with max_cpus and this looks
weird. I will dig the specs to try to understand.

> +
> +    topo->ms = ms;

See comment above regarding the properties.

> +}
> +
> +/**
> + * topology_class_init:
> + * @oc: Object class
> + * @data: (not used)
> + *
> + * A very simple object we will need for reset and migration.
> + */
> +static void topology_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +
> +    dc->realize = s390_topology_realize;
> +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
> +}
> +
> +static const TypeInfo cpu_topology_info = {
> +    .name          = TYPE_S390_CPU_TOPOLOGY,
> +    .parent        = TYPE_SYS_BUS_DEVICE,
> +    .instance_size = sizeof(S390Topology),
> +    .class_init    = topology_class_init,
> +};
> +
> +static void topology_register(void)
> +{
> +    type_register_static(&cpu_topology_info);
> +}
> +type_init(topology_register);
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 03855c7231..aa99a62e42 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -43,6 +43,7 @@
>   #include "sysemu/sysemu.h"
>   #include "hw/s390x/pv.h"
>   #include "migration/blocker.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static Error *pv_mig_blocker;
>   
> @@ -94,6 +95,18 @@ static void s390_init_cpus(MachineState *machine)
>       }
>   }
>   
> +static void s390_init_topology(MachineState *machine)
> +{
> +    DeviceState *dev;
> +
> +    if (s390_has_topology()) {
> +        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +        object_property_add_child(&machine->parent_obj,
> +                                  TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> +    }
> +}
> +
>   static const char *const reset_dev_types[] = {
>       TYPE_VIRTUAL_CSS_BRIDGE,
>       "s390-sclp-event-facility",
> @@ -244,6 +257,9 @@ static void ccw_init(MachineState *machine)
>       /* init memory + setup max page size. Required for the CPU model */
>       s390_memory_init(machine->ram);
>   
> +    /* Adding the topology must be done before CPU intialization */

initialization

> +    s390_init_topology(machine);
> +
>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>       s390_init_cpus(machine);
>   
> @@ -306,6 +322,11 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>   
> +    /* Inserting the CPU in the Topology can not fail */
> +    if (s390_has_topology()) {
> +        s390_topology_new_cpu(cpu->env.core_id);
> +    }
> +
>       if (dev->hotplugged) {
>           raise_irq_cpu_hotplug();
>       }
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index f291016fee..653f6ab488 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -2,6 +2,7 @@ s390x_ss = ss.source_set()
>   s390x_ss.add(files(
>     'ap-bridge.c',
>     'ap-device.c',
> +  'cpu-topology.c',
>     'ccw-device.c',
>     'css-bridge.c',
>     'css.c',

