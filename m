Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4786D59C8
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjDDHih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjDDHif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:38:35 -0400
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659CFE4B
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:38:33 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.141])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 2E6BD2BCC0;
        Tue,  4 Apr 2023 07:31:52 +0000 (UTC)
Received: from kaod.org (37.59.142.96) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 09:31:51 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-96R0016e6a9c0a-1d67-44af-9ac9-84c7460ad41d,
                    85507D0075A56E5AD4EA03BF56E5282CC2D8C3A6) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <7affffef-8d04-ac9f-0920-f765d362d60d@kaod.org>
Date:   Tue, 4 Apr 2023 09:31:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on CPU
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
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-3-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230403162905.17703-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: fd46a094-09c5-4438-b517-083e2eacd891
X-Ovh-Tracer-Id: 15161086671096679379
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeikedguddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeliedpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvgh
 gvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 18:28, Pierre Morel wrote:
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
>   MAINTAINERS                        |   1 +
>   include/hw/s390x/cpu-topology.h    |  44 +++++
>   include/hw/s390x/s390-virtio-ccw.h |   1 +
>   hw/s390x/cpu-topology.c            | 282 +++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c         |  22 ++-
>   hw/s390x/meson.build               |   1 +
>   6 files changed, 349 insertions(+), 2 deletions(-)
>   create mode 100644 hw/s390x/cpu-topology.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9b1f80739e..bb7b34d0d8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1658,6 +1658,7 @@ S390 CPU topology
>   M: Pierre Morel <pmorel@linux.ibm.com>
>   S: Supported
>   F: include/hw/s390x/cpu-topology.h
> +F: hw/s390x/cpu-topology.c
>   
>   X86 Machines
>   ------------
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 83f31604cc..6326cfeff8 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -10,6 +10,50 @@
>   #ifndef HW_S390X_CPU_TOPOLOGY_H
>   #define HW_S390X_CPU_TOPOLOGY_H
>   
> +#ifndef CONFIG_USER_ONLY
> +
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +#include "qapi/qapi-types-machine-target.h"
> +
>   #define S390_TOPOLOGY_CPU_IFL   0x03
>   
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
> +int s390_socket_nb(S390CPU *cpu);
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
>   #endif
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 9bba21a916..ea10a6c6e1 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>       bool dea_key_wrap;
>       bool pv;
>       uint8_t loadparm[8];
> +    bool vertical_polarization;
>   };
>   
>   struct S390CcwMachineClass {
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..96da67bd7e
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,282 @@
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
> + * for a cpu.
> + */
> +int s390_socket_nb(S390CPU *cpu)

s390_socket_nb() doesn't seem to be used anywhere else than in
hw/s390x/cpu-topology.c. It should be static.


> +{
> +    return (cpu->env.drawer_id * s390_topology.smp->books + cpu->env.book_id) *
> +           s390_topology.smp->sockets + cpu->env.socket_id;
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
> + */
> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp = s390_topology.smp;
> +    CPUS390XState *env = &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry attributes");
> +        return;
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
> +     * Even the user can specify the entitlement as horizontal on the
> +     * command line, qemu will only use env->entitlement during vertical
> +     * polarization.
> +     * Medium entitlement is chosen as the default entitlement when the CPU
> +     * is not dedicated.
> +     * A dedicated CPU always receives a high entitlement.
> +     */
> +    if (env->entitlement >= S390_CPU_ENTITLEMENT__MAX ||
> +        env->entitlement == S390_CPU_ENTITLEMENT_HORIZONTAL) {
> +        if (env->dedicated) {
> +            env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            env->entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
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
> + */
> +static void s390_topology_check(uint16_t socket_id, uint16_t book_id,
> +                                uint16_t drawer_id, uint16_t entitlement,
> +                                bool dedicated, Error **errp)
> +{
> +    CpuTopology *smp = s390_topology.smp;
> +    ERRP_GUARD();
> +
> +    if (socket_id >= smp->sockets) {
> +        error_setg(errp, "Unavailable socket: %d", socket_id);
> +        return;
> +    }
> +    if (book_id >= smp->books) {
> +        error_setg(errp, "Unavailable book: %d", book_id);
> +        return;
> +    }
> +    if (drawer_id >= smp->drawers) {
> +        error_setg(errp, "Unavailable drawer: %d", drawer_id);
> +        return;
> +    }
> +    if (entitlement >= S390_CPU_ENTITLEMENT__MAX) {
> +        error_setg(errp, "Unknown entitlement: %d", entitlement);
> +        return;
> +    }
> +    if (dedicated && (entitlement == S390_CPU_ENTITLEMENT_LOW ||
> +                      entitlement == S390_CPU_ENTITLEMENT_MEDIUM)) {
> +        error_setg(errp, "A dedicated cpu implies high entitlement");
> +        return;
> +    }
> +}
> +
> +/**
> + * s390_topology_add_core_to_socket:
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @drawer_id: new drawer_id
> + * @book_id: new book_id
> + * @socket_id: new socket_id
> + * @creation: if is true the CPU is a new CPU and there is no old socket
> + *            to handle.
> + *            if is false, this is a moving the CPU and old socket count
> + *            must be decremented.
> + * @errp: the error pointer
> + *
> + */
> +static void s390_topology_add_core_to_socket(S390CPU *cpu, int drawer_id,
> +                                             int book_id, int socket_id,
> +                                             bool creation, Error **errp)
> +{

Since this routine is called twice, in s390_topology_setup_cpu() for
creation, and in s390_change_topology() for socket migration, we could
duplicate the code in two distinct routines.

I think this would simplify a bit each code path and avoid the 'creation'
parameter which is confusing.


> +    int old_socket_entry = s390_socket_nb(cpu);
> +    int new_socket_entry;
> +
> +    if (creation) {
> +        new_socket_entry = old_socket_entry;
> +    } else {
> +        new_socket_entry = (drawer_id * s390_topology.smp->books + book_id) *
> +                            s390_topology.smp->sockets + socket_id;

A helper common routine that s390_socket_nb() could use also would be a plus.

> +    }
> +
> +    /* Check for space on new socket */
> +    if ((new_socket_entry != old_socket_entry) &&
> +        (s390_topology.cores_per_socket[new_socket_entry] >=
> +         s390_topology.smp->cores)) {
> +        error_setg(errp, "No more space on this socket");
> +        return;
> +    }
> +
> +    /* Update the count of cores in sockets */
> +    s390_topology.cores_per_socket[new_socket_entry] += 1;
> +    if (!creation) {
> +        s390_topology.cores_per_socket[old_socket_entry] -= 1;
> +    }
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
> + * before to insert the CPU in the topology.

... before the CPU is inserted in the topology.

> + * There is no use to update the MTCR explicitely here because it

... is no need ... sounds better.

> + * will be updated by KVM on creation of the new vCPU.

"CPU" is used everywhere else.

> + */
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
> +{
> +    ERRP_GUARD();
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
> +    s390_topology_cpu_default(cpu, errp);
> +    if (*errp) {

May be having s390_topology_cpu_default() return a bool would be cleaner.
Same comment for the routines below. This is minor.

> +        return;
> +    }
> +
> +    s390_topology_check(cpu->env.socket_id, cpu->env.book_id,
> +                        cpu->env.drawer_id, cpu->env.entitlement,
> +                        cpu->env.dedicated, errp);
> +    if (*errp) {
> +        return;
> +    }
> +
> +    /* Set the CPU inside the socket */
> +    s390_topology_add_core_to_socket(cpu, 0, 0, 0, true, errp);
> +    if (*errp) {
> +        return;
> +    }
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

