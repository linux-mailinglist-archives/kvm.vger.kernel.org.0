Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3564562C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 10:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLGJNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 04:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiLGJM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 04:12:29 -0500
Received: from 3.mo552.mail-out.ovh.net (3.mo552.mail-out.ovh.net [178.33.254.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239212CE2E
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 01:12:20 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.3])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 66E2C2FF3B;
        Wed,  7 Dec 2022 09:12:17 +0000 (UTC)
Received: from kaod.org (37.59.142.107) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Wed, 7 Dec
 2022 10:12:16 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-107S00171c8e3f1-1155-4d14-825e-f4609ca453e5,
                    61A31601304416A3AEEA4E3C31839A11CB8BFEB3) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <697092bd-9920-a73e-7652-07b8ecc8daff@kaod.org>
Date:   Wed, 7 Dec 2022 10:12:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v12 2/7] s390x/cpu topology: reporting the CPU topology to
 the guest
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
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-3-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221129174206.84882-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.107]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: f922e4c7-f09e-4bd1-a91e-aaa35bef4b1d
X-Ovh-Tracer-Id: 6408903747072986067
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrudejgddufedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeuuddtteelgeejhfeikeegffekhfelvefgfeejveffjeeiveegfeehgfdtgfeitdenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhstghglheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
 dpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/22 18:42, Pierre Morel wrote:
> The guest uses the STSI instruction to get information on the
> CPU topology.
> 
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   target/s390x/cpu.h          |  77 +++++++++++++++
>   hw/s390x/s390-virtio-ccw.c  |  12 +--
>   target/s390x/cpu_topology.c | 186 ++++++++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c      |   6 +-
>   target/s390x/meson.build    |   1 +
>   5 files changed, 274 insertions(+), 8 deletions(-)
>   create mode 100644 target/s390x/cpu_topology.c
> 
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..dd878ac916 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -175,6 +175,7 @@ struct ArchCPU {
>       /* needed for live migration */
>       void *irqstate;
>       uint32_t irqstate_saved_size;
> +    void *machine_data;
>   };
>   
>   
> @@ -565,6 +566,80 @@ typedef union SysIB {
>   } SysIB;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>   
> +/*
> + * CPU Topology List provided by STSI with fc=15 provides a list
> + * of two different Topology List Entries (TLE) types to specify
> + * the topology hierarchy.
> + *
> + * - Container Topology List Entry
> + *   Defines a container to contain other Topology List Entries
> + *   of any type, nested containers or CPU.
> + * - CPU Topology List Entry
> + *   Specifies the CPUs position, type, entitlement and polarization
> + *   of the CPUs contained in the last Container TLE.
> + *
> + * There can be theoretically up to five levels of containers, QEMU
> + * uses only one level, the socket level.
> + *
> + * A container of with a nesting level (NL) greater than 1 can only
> + * contain another container of nesting level NL-1.
> + *
> + * A container of nesting level 1 (socket), contains as many CPU TLE
> + * as needed to describe the position and qualities of all CPUs inside
> + * the container.
> + * The qualities of a CPU are polarization, entitlement and type.
> + *
> + * The CPU TLE defines the position of the CPUs of identical qualities
> + * using a 64bits mask which first bit has its offset defined by
> + * the CPU address orgin field of the CPU TLE like in:
> + * CPU address = origin * 64 + bit position within the mask
> + *
> + */
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
> +
> +/* CPU type Topology List Entry */
> +typedef struct SysIBTl_cpu {
> +        uint8_t nl;
> +        uint8_t reserved0[3];
> +        uint8_t reserved1:5;
> +        uint8_t dedicated:1;
> +        uint8_t polarity:2;
> +        uint8_t type;
> +        uint16_t origin;
> +        uint64_t mask;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_cpu;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
> +
> +#define S390_TOPOLOGY_MAG  6
> +#define S390_TOPOLOGY_MAG6 0
> +#define S390_TOPOLOGY_MAG5 1
> +#define S390_TOPOLOGY_MAG4 2
> +#define S390_TOPOLOGY_MAG3 3
> +#define S390_TOPOLOGY_MAG2 4
> +#define S390_TOPOLOGY_MAG1 5
> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[S390_TOPOLOGY_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[0];
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
> +/* Max size of a SYSIB structure is when all CPU are alone in a container */
> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
> +                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
> +                                                   sizeof(SysIBTl_cpu)))
> +
>   /* MMU defines */
>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>   #define ASCE_SUBSPACE         0x200       /* subspace group control           */
> @@ -843,4 +918,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>   
>   #include "exec/cpu-all.h"
>   
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> +
>   #endif
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 973bbdd36e..4be07959fd 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -64,11 +64,10 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr)
>       return S390_CPU(ms->possible_cpus->cpus[cpu_addr].cpu);
>   }
>   
> -static S390CPU *s390x_new_cpu(const char *typename, uint32_t core_id,
> -                              Error **errp)
> +static void s390x_new_cpu(MachineState *ms, uint32_t core_id, Error **errp)
>   {
> -    S390CPU *cpu = S390_CPU(object_new(typename));
> -    S390CPU *ret = NULL;
> +    S390CcwMachineState *s390ms = S390_CCW_MACHINE(ms);
> +    S390CPU *cpu = S390_CPU(object_new(ms->cpu_type));
>   
>       if (!object_property_set_int(OBJECT(cpu), "core-id", core_id, errp)) {
>           goto out;
> @@ -76,11 +75,10 @@ static S390CPU *s390x_new_cpu(const char *typename, uint32_t core_id,
>       if (!qdev_realize(DEVICE(cpu), NULL, errp)) {
>           goto out;
>       }
> -    ret = cpu;
> +    cpu->machine_data = s390ms;
>   
>   out:
>       object_unref(OBJECT(cpu));
> -    return ret;
>   }
>   
>   static void s390_init_cpus(MachineState *machine)
> @@ -99,7 +97,7 @@ static void s390_init_cpus(MachineState *machine)
>       mc->possible_cpu_arch_ids(machine);
>   
>       for (i = 0; i < machine->smp.cpus; i++) {
> -        s390x_new_cpu(machine->cpu_type, i, &error_fatal);
> +        s390x_new_cpu(machine, i, &error_fatal);
>       }
>   }
>   
> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> new file mode 100644
> index 0000000000..b81f016ba1
> --- /dev/null
> +++ b/target/s390x/cpu_topology.c
> @@ -0,0 +1,186 @@
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/cpu-topology.h"
> +#include "hw/s390x/sclp.h"
> +
> +/*
> + * s390_topology_add_cpu:
> + * @topo: pointer to the topology
> + * @cpu : pointer to the new CPU
> + *
> + * The topology pointed by S390CPU, gives us the CPU topology
> + * established by the -smp QEMU aruments.
> + * The core-id is used to calculate the position of the CPU inside
> + * the topology:
> + *  - the socket, container TLE, containing the CPU, we have one socket
> + *    for every num_cores cores.
> + *  - the CPU TLE inside the socket, we have potentionly up to 4 CPU TLE
> + *    in a container TLE with the assumption that all CPU are identical
> + *    with the same polarity and entitlement because we have maximum 256
> + *    CPUs and each TLE can hold up to 64 identical CPUs.
> + *  - the bit in the 64 bit CPU TLE core mask
> + */
> +static void s390_topology_add_cpu(S390Topology *topo, S390CPU *cpu)
> +{
> +    int core_id = cpu->env.core_id;
> +    int bit, origin;
> +    int socket_id;
> +
> +    cpu->machine_data = topo;
> +    socket_id = core_id / topo->num_cores;
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * uint64_t which represent the presence of a CPU.
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
> +    set_bit(bit, &topo->socket[socket_id].mask[origin]);
> +}
> +
> +/*
> + * s390_prepare_topology:
> + * @s390ms : pointer to the S390CcwMachite State
> + *
> + * Calls s390_topology_add_cpu to organize the topology
> + * inside the topology device before writing the SYSIB.
> + *
> + * The topology is currently fixed on boot and do not change
> + * even on migration.
> + */
> +static void s390_prepare_topology(S390CcwMachineState *s390ms)
> +{
> +    const MachineState *ms = MACHINE(s390ms);
> +    static bool done;
> +    int i;
> +
> +    if (done) {
> +        return;
> +    }
> +
> +    for (i = 0; i < ms->possible_cpus->len; i++) {
> +        if (ms->possible_cpus->cpus[i].cpu) {
> +            s390_topology_add_cpu(S390_CPU_TOPOLOGY(s390ms->topology),
> +                                  S390_CPU(ms->possible_cpus->cpus[i].cpu));
> +        }
> +    }
> +
> +    done = true;
> +}
> +
> +static char *fill_container(char *p, int level, int id)
> +{
> +    SysIBTl_container *tle = (SysIBTl_container *)p;
> +
> +    tle->nl = level;
> +    tle->id = id;
> +    return p + sizeof(*tle);
> +}
> +
> +static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
> +{
> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
> +
> +    tle->nl = 0;
> +    tle->dedicated = 1;
> +    tle->polarity = S390_TOPOLOGY_POLARITY_HORIZONTAL;
> +    tle->type = S390_TOPOLOGY_CPU_IFL;
> +    tle->origin = cpu_to_be64(origin * 64);
> +    tle->mask = cpu_to_be64(mask);
> +    return p + sizeof(*tle);
> +}
> +
> +static char *s390_top_set_level2(S390Topology *topo, char *p)
> +{
> +    int i, origin;
> +
> +    for (i = 0; i < topo->num_sockets; i++) {
> +        if (!topo->socket[i].active_count) {
> +            continue;
> +        }
> +        p = fill_container(p, 1, i);
> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
> +            uint64_t mask = 0L;
> +
> +            mask = topo->socket[i].mask[origin];
> +            if (mask) {
> +                p = fill_tle_cpu(p, mask, origin);
> +            }
> +        }
> +    }
> +    return p;
> +}
> +
> +static int setup_stsi(S390CPU *cpu, SysIB_151x *sysib, int level)
> +{
> +    S390Topology *topo = (S390Topology *)cpu->machine_data;
> +    char *p = sysib->tle;
> +
> +    sysib->mnest = level;
> +    switch (level) {
> +    case 2:
> +        sysib->mag[S390_TOPOLOGY_MAG2] = topo->num_sockets;
> +        sysib->mag[S390_TOPOLOGY_MAG1] = topo->num_cores;
> +        p = s390_top_set_level2(topo, p);
> +        break;
> +    }
> +
> +    return p - (char *)sysib;
> +}
> +
> +#define S390_TOPOLOGY_MAX_MNEST 2
> +
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> +{
> +    union {
> +        char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
> +        SysIB_151x sysib;
> +    } buffer QEMU_ALIGNED(8);
> +    int len;
> +
> +    if (s390_is_pv() || !s390_has_topology() ||
> +        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
> +        setcc(cpu, 3);
> +        return;
> +    }
>
> +    s390_prepare_topology(S390_CCW_MACHINE(cpu->machine_data));
> +
> +    len = setup_stsi(cpu, &buffer.sysib, sel2);


The S390_CPU_TOPOLOGY object is created by the machine at init time
and the two above routines are the only users of this object.

The first loops on all possible CPUs to populate the bitmask array
'socket' under S390_CPU_TOPOLOGY and the second uses the result to
populate the buffer returned to the guest OS.

I don't understand why the S390_CPU_TOPOLOGY object is needed at all.
AFAICT, this is just adding extra complexity. Is the pachset preparing
ground for some more features ? If so, it should be explained in the
commit log.

As for now, I see no good justification for S390_CPU_TOPOLOGY and we
could add support with a simple routine called from insert_stsi_15_1_x().

Thanks,

C.

> +
> +    if (len > 4096) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    buffer.sysib.length = cpu_to_be16(len);
> +    s390_cpu_virt_mem_write(cpu, addr, ar, &buffer.sysib, len);
> +    setcc(cpu, 0);
> +}
> +
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 3ac7ec9acf..7dc96f3663 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -51,6 +51,7 @@
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/s390-virtio-hcall.h"
>   #include "hw/s390x/pv.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   #ifndef DEBUG_KVM
>   #define DEBUG_KVM  0
> @@ -1919,9 +1920,12 @@ static int handle_stsi(S390CPU *cpu)
>           if (run->s390_stsi.sel1 != 2 || run->s390_stsi.sel2 != 2) {
>               return 0;
>           }
> -        /* Only sysib 3.2.2 needs post-handling for now. */
>           insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar);
>           return 0;
> +    case 15:
> +        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, run->s390_stsi.addr,
> +                           run->s390_stsi.ar);
> +        return 0;
>       default:
>           return 0;
>       }
> diff --git a/target/s390x/meson.build b/target/s390x/meson.build
> index 84c1402a6a..890ccfa789 100644
> --- a/target/s390x/meson.build
> +++ b/target/s390x/meson.build
> @@ -29,6 +29,7 @@ s390x_softmmu_ss.add(files(
>     'sigp.c',
>     'cpu-sysemu.c',
>     'cpu_models_sysemu.c',
> +  'cpu_topology.c',
>   ))
>   
>   s390x_user_ss = ss.source_set()

