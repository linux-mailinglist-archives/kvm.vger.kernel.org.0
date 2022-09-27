Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0EF5EC363
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 14:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiI0M5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 08:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiI0M5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 08:57:51 -0400
X-Greylist: delayed 3281 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Sep 2022 05:57:48 PDT
Received: from 2.mo548.mail-out.ovh.net (2.mo548.mail-out.ovh.net [178.33.255.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C351E7E15
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:57:47 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.31])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id E8C3522D38;
        Tue, 27 Sep 2022 12:03:02 +0000 (UTC)
Received: from kaod.org (37.59.142.98) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 27 Sep
 2022 14:03:01 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-98R0022bac10f8-9f44-458b-ab87-31a5d5458b65,
                    12A65CACE92C1DACCE6E97948814F03D28E096F2) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <89d6f37e-c521-4dd6-fd13-c7394bd0ab94@kaod.org>
Date:   Tue, 27 Sep 2022 14:03:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU
 topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <frankja@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-3-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220902075531.188916-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.98]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 77af8a79-423d-41d0-8244-c2433466d59b
X-Ovh-Tracer-Id: 16606460677994875661
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegiedgvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpoffvtefjohhsthepmhhoheegke
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/22 09:55, Pierre Morel wrote:
> In the S390x CPU topology the core_id specifies the CPU address
> and the position of the core withing the topology.
> 
> Let's build the topology based on the core_id.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/cpu-topology.c         | 135 ++++++++++++++++++++++++++++++++
>   hw/s390x/meson.build            |   1 +
>   hw/s390x/s390-virtio-ccw.c      |  10 +++
>   include/hw/s390x/cpu-topology.h |  42 ++++++++++
>   4 files changed, 188 insertions(+)
>   create mode 100644 hw/s390x/cpu-topology.c
>   create mode 100644 include/hw/s390x/cpu-topology.h
> 
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..a6ca006ec5
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,135 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
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
> +
> +    socket_id = core_id / topo->cores;
> +
> +    bit = core_id;
> +    origin = bit / 64;
> +    bit %= 64;
> +    bit = 63 - bit;
> +
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * unsigned long. Set on plug and clear on unplug of a CPU.

Do we have CPU unplug on s390x ?

> +     * The firmware assume that all CPU in a CPU TLE have the same
> +     * type, polarization and are all dedicated or shared.
> +     * In the case a socket contains CPU with different type, polarization
> +     * or entitlement then they will be defined in different CPU containers.
> +     * Currently we assume all CPU are identical IFL CPUs and that they are
> +     * all dedicated CPUs.
> +     * The only reason to have several S390TopologyCores inside a socket is
> +     * to have more than 64 CPUs.
> +     * In that case the origin field, representing the offset of the first CPU
> +     * in the CPU container allows to represent up to the maximal number of
> +     * CPU inside several CPU containers inside the socket container.
> +     */
> +    topo->socket[socket_id].active_count++;
> +    topo->tle[socket_id].active_count++;
> +    set_bit(bit, &topo->tle[socket_id].mask[origin]);
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

Using qdev_get_machine() is suspicious :)

> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> +    int n;
> +
> +    topo->sockets = ms->smp.sockets;
> +    topo->cores = ms->smp.cores;
> +    topo->tles = ms->smp.max_cpus;

These look like object properties to me.

> +
> +    n = topo->sockets;
> +    topo->socket = g_malloc0(n * sizeof(S390TopoContainer));
> +    topo->tle = g_malloc0(topo->tles * sizeof(S390TopoTLE));
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

no vmstate ?

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
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index de28a90a57..96d7d7d231 100644
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
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index b5ca154e2f..15cefd104b 100644
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
> @@ -247,6 +248,12 @@ static void ccw_init(MachineState *machine)
>       /* init memory + setup max page size. Required for the CPU model */
>       s390_memory_init(machine->ram);
>   
> +    /* Adding the topology must be done before CPU intialization*/
> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +    object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,

No need to use qdev_get_machine(), you have 'machine' above.

> +                              OBJECT(dev));
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);


why not store a TYPE_S390_CPU_TOPOLOGY object pointer under the machine
state for later use ?

> +
>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>       s390_init_cpus(machine);
>   
> @@ -309,6 +316,9 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>   
> +    /* Inserting the CPU in the Topology can not fail */
> +    s390_topology_new_cpu(cpu->env.core_id);
> +

in which case, we could use the topo object pointer to insert a new CPU
id and drop s390_get_topology() which looks overkill.

I would add the test :

    if (!S390_CCW_MACHINE(machine)->topology_disable) {

before inserting to be consistent. But I am anticipating some other
patch.

C.


>       if (dev->hotplugged) {
>           raise_irq_cpu_hotplug();
>       }
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..6911f975f4
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,42 @@
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
> +typedef struct S390TopoContainer {
> +    int active_count;
> +} S390TopoContainer;
> +
> +#define S390_TOPOLOGY_MAX_ORIGIN (1 + S390_MAX_CPUS / 64)
> +typedef struct S390TopoTLE {
> +    int active_count;
> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
> +} S390TopoTLE;
> +
> +#include "hw/qdev-core.h"
> +#include "qom/object.h"
> +
> +struct S390Topology {
> +    SysBusDevice parent_obj;
> +    int sockets;
> +    int cores;
> +    int tles;
> +    S390TopoContainer *socket;
> +    S390TopoTLE *tle;
> +};
> +typedef struct S390Topology S390Topology;
> +
> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
> +
> +S390Topology *s390_get_topology(void);
> +void s390_topology_new_cpu(int core_id);
> +
> +#endif

