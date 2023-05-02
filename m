Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E566F43F7
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjEBMkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjEBMkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:40:13 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 May 2023 05:40:10 PDT
Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E55B59CF
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 05:40:10 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.128])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 289DF204B0;
        Tue,  2 May 2023 12:30:08 +0000 (UTC)
Received: from kaod.org (37.59.142.109) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 2 May
 2023 14:30:06 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-109S00366b78b0a-27e0-4a41-96fb-e948b135a5d0,
                    E090D36E4DC625C434D5D892E9869795142AB5A1) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <7940b2d6-8b72-18e8-83a6-de3f122e416e@kaod.org>
Date:   Tue, 2 May 2023 14:30:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <nsg@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230425161456.21031-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.109]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: dea70006-99a5-4826-a619-161abf994892
X-Ovh-Tracer-Id: 166351712654887891
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrfedviedghedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeuuddtteelgeejhfeikeegffekhfelvefgfeejveffjeeiveegfeehgfdtgfeitdenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtledpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvgh
 gvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/23 18:14, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
> 
> On hot plug we:
> - calculate the default values for the topology for drawers,
>    books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
> 
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
> 
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
> 
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   MAINTAINERS                     |   6 +
>   include/hw/s390x/cpu-topology.h |  55 +++++++
>   hw/s390x/cpu-topology.c         | 259 ++++++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c      |  22 ++-
>   hw/s390x/meson.build            |   1 +
>   5 files changed, 341 insertions(+), 2 deletions(-)
>   create mode 100644 include/hw/s390x/cpu-topology.h
>   create mode 100644 hw/s390x/cpu-topology.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5340de0515..bb7b34d0d8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1654,6 +1654,12 @@ F: hw/s390x/event-facility.c
>   F: hw/s390x/sclp*.c
>   L: qemu-s390x@nongnu.org
>   
> +S390 CPU topology
> +M: Pierre Morel <pmorel@linux.ibm.com>
> +S: Supported
> +F: include/hw/s390x/cpu-topology.h
> +F: hw/s390x/cpu-topology.c
> +
>   X86 Machines
>   ------------
>   PC
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..af36f634e0
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#ifndef CONFIG_USER_ONLY
> +
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +#include "qapi/qapi-types-machine-target.h"
> +
> +typedef struct S390Topology {
> +    uint8_t *cores_per_socket;
> +    CpuTopology *smp;
> +} S390Topology;
> +
> +#ifdef CONFIG_KVM
> +bool s390_has_topology(void);
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
> +#else
> +static inline bool s390_has_topology(void)
> +{
> +       return false;
> +}
> +static inline void s390_topology_setup_cpu(MachineState *ms,
> +                                           S390CPU *cpu,
> +                                           Error **errp) {}
> +#endif
> +
> +extern S390Topology s390_topology;
> +
> +static inline int s390_std_socket(int n, CpuTopology *smp)
> +{
> +    return (n / smp->cores) % smp->sockets;
> +}
> +
> +static inline int s390_std_book(int n, CpuTopology *smp)
> +{
> +    return (n / (smp->cores * smp->sockets)) % smp->books;
> +}
> +
> +static inline int s390_std_drawer(int n, CpuTopology *smp)
> +{
> +    return (n / (smp->cores * smp->sockets * smp->books)) % smp->drawers;
> +}
> +
> +#endif /* CONFIG_USER_ONLY */
> +
> +#endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..471e0e7292
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
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
> +/*
> + * s390_topology is used to keep the topology information.
> + * .cores_per_socket: tracks information on the count of cores
> + *                    per socket.
> + * .smp: keeps track of the machine topology.
> + *
> + */
> +S390Topology s390_topology = {
> +    /* will be initialized after the cpu model is realized */
> +    .cores_per_socket = NULL,
> +    .smp = NULL,
> +};
> +
> +/**
> + * s390_socket_nb:
> + * @cpu: s390x CPU
> + *
> + * Returns the socket number used inside the cores_per_socket array
> + * for a topology tree entry
> + */
> +static int __s390_socket_nb(int drawer_id, int book_id, int socket_id)
> +{
> +    return (drawer_id * s390_topology.smp->books + book_id) *
> +           s390_topology.smp->sockets + socket_id;
> +}
> +
> +/**
> + * s390_socket_nb:
> + * @cpu: s390x CPU
> + *
> + * Returns the socket number used inside the cores_per_socket array
> + * for a cpu.
> + */
> +static int s390_socket_nb(S390CPU *cpu)
> +{
> +    return __s390_socket_nb(cpu->env.drawer_id, cpu->env.book_id,
> +                            cpu->env.socket_id);
> +}
> +
> +/**
> + * s390_has_topology:
> + *
> + * Return value: if the topology is supported by the machine.
> + */
> +bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +/**
> + * s390_topology_init:
> + * @ms: the machine state where the machine topology is defined
> + *
> + * Keep track of the machine topology.
> + *
> + * Allocate an array to keep the count of cores per socket.
> + * The index of the array starts at socket 0 from book 0 and
> + * drawer 0 up to the maximum allowed by the machine topology.
> + */
> +static void s390_topology_init(MachineState *ms)
> +{
> +    CpuTopology *smp = &ms->smp;
> +
> +    s390_topology.smp = smp;

I am not sure the 'smp' shortcut is necessary. 'MachineState *ms' is
always available where 'CpuTopology *smp' is used. so it could be
computed from a local variable AFAICT. It would reduce the risk of
'smp' being NULL in some (future) code path.

Thanks,

C.

> +    s390_topology.cores_per_socket = g_new0(uint8_t, smp->sockets *
> +                                            smp->books * smp->drawers);
> +}
> +
> +/**
> + * s390_topology_cpu_default:
> + * @cpu: pointer to a S390CPU
> + * @errp: Error pointer
> + *
> + * Setup the default topology if no attributes are already set.
> + * Passing a CPU with some, but not all, attributes set is considered
> + * an error.
> + *
> + * The function calculates the (drawer_id, book_id, socket_id)
> + * topology by filling the cores starting from the first socket
> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
> + *
> + * CPU type and dedication have defaults values set in the
> + * s390x_cpu_properties, entitlement must be adjust depending on the
> + * dedication.
> + *
> + * Returns false if it is impossible to setup a default topology
> + * true otherwise.
> + */
> +static bool s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp = s390_topology.smp;
> +    CPUS390XState *env = &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry attributes");
> +        return false;
> +    }
> +
> +    /* Check if one of the geometry topology is unset */
> +    if (env->socket_id < 0) {
> +        /* Calculate default geometry topology attributes */
> +        env->socket_id = s390_std_socket(env->core_id, smp);
> +        env->book_id = s390_std_book(env->core_id, smp);
> +        env->drawer_id = s390_std_drawer(env->core_id, smp);
> +    }
> +
> +    /*
> +     * When the user specifies the entitlement as 'auto' on the command line,
> +     * qemu will set the entitlement as:
> +     * Medium when the CPU is not dedicated.
> +     * High when dedicated is true.
> +     */
> +    if (env->entitlement == S390_CPU_ENTITLEMENT_AUTO) {
> +        if (env->dedicated) {
> +            env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            env->entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
> +    return true;
> +}
> +
> +/**
> + * s390_topology_check:
> + * @socket_id: socket to check
> + * @book_id: book to check
> + * @drawer_id: drawer to check
> + * @entitlement: entitlement to check
> + * @dedicated: dedication to check
> + * @errp: Error pointer
> + *
> + * The function checks if the topology
> + * attributes fits inside the system topology.
> + *
> + * Returns false if the specified topology does not match with
> + * the machine topology.
> + */
> +static bool s390_topology_check(uint16_t socket_id, uint16_t book_id,
> +                                uint16_t drawer_id, uint16_t entitlement,
> +                                bool dedicated, Error **errp)
> +{
> +    CpuTopology *smp = s390_topology.smp;
> +    ERRP_GUARD();
> +
> +    if (socket_id >= smp->sockets) {
> +        error_setg(errp, "Unavailable socket: %d", socket_id);
> +        return false;
> +    }
> +    if (book_id >= smp->books) {
> +        error_setg(errp, "Unavailable book: %d", book_id);
> +        return false;
> +    }
> +    if (drawer_id >= smp->drawers) {
> +        error_setg(errp, "Unavailable drawer: %d", drawer_id);
> +        return false;
> +    }
> +    if (entitlement >= S390_CPU_ENTITLEMENT__MAX) {
> +        error_setg(errp, "Unknown entitlement: %d", entitlement);
> +        return false;
> +    }
> +    if (dedicated && (entitlement == S390_CPU_ENTITLEMENT_LOW ||
> +                      entitlement == S390_CPU_ENTITLEMENT_MEDIUM)) {
> +        error_setg(errp, "A dedicated cpu implies high entitlement");
> +        return false;
> +    }
> +    return true;
> +}
> +
> +/**
> + * s390_update_cpu_props:
> + * @ms: the machine state
> + * @cpu: the CPU for which to update the properties from the environment.
> + *
> + */
> +static void s390_update_cpu_props(MachineState *ms, S390CPU *cpu)
> +{
> +    CpuInstanceProperties *props;
> +
> +    props = &ms->possible_cpus->cpus[cpu->env.core_id].props;
> +
> +    props->socket_id = cpu->env.socket_id;
> +    props->book_id = cpu->env.book_id;
> +    props->drawer_id = cpu->env.drawer_id;
> +}
> +
> +/**
> + * s390_topology_setup_cpu:
> + * @ms: MachineState used to initialize the topology structure on
> + *      first call.
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @errp: the error pointer
> + *
> + * Called from CPU Hotplug to check and setup the CPU attributes
> + * before the CPU is inserted in the topology.
> + * There is no need to update the MTCR explicitely here because it
> + * will be updated by KVM on creation of the new CPU.
> + */
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
> +{
> +    ERRP_GUARD();
> +    int entry;
> +
> +    /*
> +     * We do not want to initialize the topology if the cpu model
> +     * does not support topology, consequently, we have to wait for
> +     * the first CPU to be realized, which realizes the CPU model
> +     * to initialize the topology structures.
> +     *
> +     * s390_topology_setup_cpu() is called from the cpu hotplug.
> +     */
> +    if (!s390_topology.cores_per_socket) {
> +        s390_topology_init(ms);
> +    }
> +
> +    if (!s390_topology_cpu_default(cpu, errp)) {
> +        return;
> +    }
> +
> +    if (!s390_topology_check(cpu->env.socket_id, cpu->env.book_id,
> +                             cpu->env.drawer_id, cpu->env.entitlement,
> +                             cpu->env.dedicated, errp)) {
> +        return;
> +    }
> +
> +    /* Do we still have space in the socket */
> +    entry = s390_socket_nb(cpu);
> +    if (s390_topology.cores_per_socket[entry] >= s390_topology.smp->cores) {
> +        error_setg(errp, "No more space on this socket");
> +        return;
> +    }
> +
> +    /* Update the count of cores in sockets */
> +    s390_topology.cores_per_socket[entry] += 1;
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +}
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 1a9bcda8b6..9df60ac447 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -45,6 +45,7 @@
>   #include "hw/s390x/pv.h"
>   #include "migration/blocker.h"
>   #include "qapi/visitor.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static Error *pv_mig_blocker;
>   
> @@ -311,10 +312,18 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>   {
>       MachineState *ms = MACHINE(hotplug_dev);
>       S390CPU *cpu = S390_CPU(dev);
> +    ERRP_GUARD();
>   
>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>   
> +    if (s390_has_topology()) {
> +        s390_topology_setup_cpu(ms, cpu, errp);
> +        if (*errp) {
> +            return;
> +        }
> +    }
> +
>       if (dev->hotplugged) {
>           raise_irq_cpu_hotplug();
>       }
> @@ -554,11 +563,20 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
>                                     sizeof(CPUArchId) * max_cpus);
>       ms->possible_cpus->len = max_cpus;
>       for (i = 0; i < ms->possible_cpus->len; i++) {
> +        CpuInstanceProperties *props = &ms->possible_cpus->cpus[i].props;
> +
>           ms->possible_cpus->cpus[i].type = ms->cpu_type;
>           ms->possible_cpus->cpus[i].vcpus_count = 1;
>           ms->possible_cpus->cpus[i].arch_id = i;
> -        ms->possible_cpus->cpus[i].props.has_core_id = true;
> -        ms->possible_cpus->cpus[i].props.core_id = i;
> +
> +        props->has_core_id = true;
> +        props->core_id = i;
> +        props->has_socket_id = true;
> +        props->socket_id = s390_std_socket(i, &ms->smp);
> +        props->has_book_id = true;
> +        props->book_id = s390_std_book(i, &ms->smp);
> +        props->has_drawer_id = true;
> +        props->drawer_id = s390_std_drawer(i, &ms->smp);
>       }
>   
>       return ms->possible_cpus;
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

