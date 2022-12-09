Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14981648425
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 15:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLIOvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIOvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 09:51:21 -0500
Received: from 5.mo548.mail-out.ovh.net (5.mo548.mail-out.ovh.net [188.165.49.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108F14841D
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 06:51:20 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.217])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 3A0652529E;
        Fri,  9 Dec 2022 14:51:18 +0000 (UTC)
Received: from kaod.org (37.59.142.106) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 9 Dec
 2022 15:51:17 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-106R00639c547f1-f3ae-4a59-a42f-169ebb34a5db,
                    703C8C4CBBC51929D19CEDB14A3E71E172461769) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <1cb348f3-f2a6-c7dd-dec6-69d22fc9ce72@kaod.org>
Date:   Fri, 9 Dec 2022 15:51:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v13 1/7] s390x/cpu topology: Creating CPU topology device
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <scgl@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-2-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221208094432.9732-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 60bc8770-f506-4e6d-b02d-7d5e06c59db2
X-Ovh-Tracer-Id: 5433030002128620499
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgdeikecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 10:44, Pierre Morel wrote:
> We will need a Topology device to transfer the topology
> during migration and to implement machine reset.
> 
> The device creation is fenced by s390_has_topology().

Some of the info you gave in the cover letter would help the reader
of this commit log.


> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/cpu-topology.h |  44 ++++++++++
>   hw/s390x/cpu-topology.c         | 149 ++++++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c      |   6 ++
>   hw/s390x/meson.build            |   1 +
>   4 files changed, 200 insertions(+)
>   create mode 100644 include/hw/s390x/cpu-topology.h
>   create mode 100644 hw/s390x/cpu-topology.c
> 
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..6c3d2d080f
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,44 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#include "hw/sysbus.h"
> +#include "hw/qdev-core.h"
> +#include "qom/object.h"
> +
> +#define S390_TOPOLOGY_CPU_IFL 0x03
> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
> +
> +#define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
> +#define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
> +#define S390_TOPOLOGY_POLARITY_VERTICAL_MEDIUM 0x02
> +#define S390_TOPOLOGY_POLARITY_VERTICAL_HIGH   0x03
> +
> +typedef struct S390TopoSocket {
> +    int active_count;
> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
> +} S390TopoSocket;
> +
> +struct S390Topology {
> +    SysBusDevice parent_obj;

hmm, I think a Device should be enough. There are no interrupts or memory
regions associated to it and the reset is handled independently of any bus.
This object is simply a place older for computed state.

> +    uint32_t num_cores;
> +    uint32_t num_sockets;
> +    S390TopoSocket *socket;
> +};
> +
> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
> +
> +void s390_init_topology(MachineState *machine, Error **errp);
> +bool s390_has_topology(void);
> +S390Topology *s390_get_topology(void);
> +
> +#endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..b3e59873f6
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,149 @@
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
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/**
> + * s390_has_topology
> + *
> + * Return false until the commit activating the topology is
> + * commited.
> + */
> +bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +/**
> + * s390_get_topology
> + *
> + * Returns a pointer to the topology.
> + *
> + * This function is called when we know the topology exist.
> + * Testing if the topology exist is done with s390_has_topology()
> + */
> +S390Topology *s390_get_topology(void)
> +{
> +    static S390Topology *s390Topology;
> +
> +    if (!s390Topology) {
> +        s390Topology = S390_CPU_TOPOLOGY(
> +            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
> +    }

This is back. Too bad. I guess the compilation issues on all platforms
made it difficult to avoid.

> +    assert(s390Topology);
> +
> +    return s390Topology;
> +}
> +
> +/**
> + * s390_init_topology
> + * @machine: The Machine state, used to retrieve the SMP parameters
> + * @errp: the error pointer in case of problem
> + *
> + * This function creates and initialize the S390Topology with
> + * the QEMU -smp parameters we will use during adding cores to the
> + * topology.
> + */
> +void s390_init_topology(MachineState *machine, Error **errp)
> +{
> +    DeviceState *dev;
> +
> +    if (machine->smp.threads > 1) {
> +        error_setg(errp, "CPU Topology do not support multithreading");
> +        return;
> +    }

Isn't SMT already tested at the machine level ?

> +
> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +
> +    object_property_add_child(&machine->parent_obj,
> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> +    object_property_set_int(OBJECT(dev), "num-cores",
> +                            machine->smp.cores, errp);
> +    object_property_set_int(OBJECT(dev), "num-sockets",
> +                            machine->smp.sockets, errp);
> +
> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> +}
> +
> +/**
> + * s390_topology_realize:
> + * @dev: the device state
> + *
> + * We free the socket array allocated in realize.
> + */
> +static void s390_topology_unrealize(DeviceState *dev)
> +{
> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> +
> +    g_free(topo->socket);
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
> +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> +
> +    topo->socket = g_new0(S390TopoSocket, topo->num_sockets);
> +}
> +
> +static Property s390_topology_properties[] = {
> +    DEFINE_PROP_UINT32("num-cores", S390Topology, num_cores, 1),
> +    DEFINE_PROP_UINT32("num-sockets", S390Topology, num_sockets, 1),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
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
> +    dc->unrealize = s390_topology_unrealize;
> +    device_class_set_props(dc, s390_topology_properties);
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
> index 2e64ffab45..8971ffb871 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -44,6 +44,7 @@
>   #include "hw/s390x/pv.h"
>   #include "migration/blocker.h"
>   #include "qapi/visitor.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static Error *pv_mig_blocker;
>   
> @@ -255,6 +256,11 @@ static void ccw_init(MachineState *machine)
>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>       s390_init_cpus(machine);
>   
> +    /* Need CPU model to be determined before we can set up topology */
> +    if (s390_has_topology()) {
> +        s390_init_topology(machine, &error_fatal);
> +    }
> +
>       /* Need CPU model to be determined before we can set up PV */
>       s390_pv_init(machine->cgs, &error_fatal);
>   
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index f291016fee..58dfbdff4f 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -24,6 +24,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>     's390-stattrib-kvm.c',
>     'pv.c',
>     's390-pci-kvm.c',
> +  'cpu-topology.c',
>   ))
>   s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
>     'tod-tcg.c',

