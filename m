Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6260318C
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJRR0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 13:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJRR0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 13:26:43 -0400
X-Greylist: delayed 605 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Oct 2022 10:26:41 PDT
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E63AAB80A
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 10:26:41 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.25])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id F2F2B28C0C;
        Tue, 18 Oct 2022 17:10:40 +0000 (UTC)
Received: from kaod.org (37.59.142.101) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 18 Oct
 2022 19:10:39 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G004f30ae13c-3bf7-4124-87f4-6cc321acd836,
                    E583C31B167A4CECD7AFA5F42DA6B4ED7D5BF57A) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <597cc0d2-c8dd-b5f7-bd7f-22061f9f8569@kaod.org>
Date:   Tue, 18 Oct 2022 19:10:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 2/9] s390x/cpu topology: reporting the CPU topology to
 the guest
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
 <20221012162107.91734-3-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221012162107.91734-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 41895306-ddee-4305-b3f8-1f2ff9954afc
X-Ovh-Tracer-Id: 16001289478594726672
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgjeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhpsghonhiiihhnihesrhgvughhrghtrdgtoh
 hmpdhmshhtsehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/22 18:21, Pierre Morel wrote:
> The guest can use the STSI instruction to get a buffer filled
> with the CPU topology description.
> 
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/cpu-topology.h |   3 +
>   target/s390x/cpu.h              |  48 ++++++++++++++
>   hw/s390x/cpu-topology.c         |   8 ++-
>   target/s390x/cpu_topology.c     | 109 ++++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c          |   6 +-
>   target/s390x/meson.build        |   1 +
>   6 files changed, 172 insertions(+), 3 deletions(-)
>   create mode 100644 target/s390x/cpu_topology.c
> 
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 66c171d0bc..61c11db017 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -13,6 +13,8 @@
>   #include "hw/qdev-core.h"
>   #include "qom/object.h"
>   
> +#define S390_TOPOLOGY_POLARITY_H  0x00

The defing looks like a header file guard. I would use

   S390_TOPOLOGY_HORIZONTAL_POLARITY

May be add the 3 vertical ones also, for completeness.

> +
>   typedef struct S390TopoContainer {
>       int active_count;
>   } S390TopoContainer;
> @@ -29,6 +31,7 @@ struct S390Topology {
>       S390TopoContainer *socket;
>       S390TopoTLE *tle;
>       MachineState *ms;
> +    QemuMutex topo_mutex;
>   };
>   
>   #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..d604aa9c78 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -565,6 +565,52 @@ typedef union SysIB {
>   } SysIB;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>   
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
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
> +
> +#define TOPOLOGY_NR_MAG  6
> +#define TOPOLOGY_NR_MAG6 0
> +#define TOPOLOGY_NR_MAG5 1
> +#define TOPOLOGY_NR_MAG4 2
> +#define TOPOLOGY_NR_MAG3 3
> +#define TOPOLOGY_NR_MAG2 4
> +#define TOPOLOGY_NR_MAG1 5

May be add a S390_ prefix. I don't think _NR is important for the
magnitude fields. And these are byte offsets.


> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[TOPOLOGY_NR_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[0];
> +} QEMU_PACKED QEMU_ALIGNED(8) SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
> +/* Maxi size of a SYSIB structure is when all CPU are alone in a container */
> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
> +                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
> +                                                   sizeof(SysIBTl_cpu)))
> +
> +
>   /* MMU defines */
>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>   #define ASCE_SUBSPACE         0x200       /* subspace group control           */
> @@ -843,4 +889,6 @@ S390CPU *s390_cpu_addr2state(uint16_t cpu_addr);
>   
>   #include "exec/cpu-all.h"
>   
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar);
> +
>   #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 42b22a1831..c73cebfe6f 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -54,8 +54,6 @@ void s390_topology_new_cpu(int core_id)
>           return;
>       }
>   
> -    socket_id = core_id / topo->cpus;
> -
>       /*
>        * At the core level, each CPU is represented by a bit in a 64bit
>        * unsigned long which represent the presence of a CPU.
> @@ -76,8 +74,13 @@ void s390_topology_new_cpu(int core_id)
>       bit %= 64;
>       bit = 63 - bit;
>   
> +    qemu_mutex_lock(&topo->topo_mutex);
> +
> +    socket_id = core_id / topo->cpus;
>       topo->socket[socket_id].active_count++;
>       set_bit(bit, &topo->tle[socket_id].mask[origin]);
> +
> +    qemu_mutex_unlock(&topo->topo_mutex);
>   }
>   
>   /**
> @@ -101,6 +104,7 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
>       topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);
>   
>       topo->ms = ms;
> +    qemu_mutex_init(&topo->topo_mutex);
>   }
>   
>   /**
> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> new file mode 100644
> index 0000000000..df86a98f23
> --- /dev/null
> +++ b/target/s390x/cpu_topology.c
> @@ -0,0 +1,109 @@
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022

Copyright tag

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
> +#define S390_TOPOLOGY_MAX_STSI_SIZE (S390_MAX_CPUS *              \
> +                                     (sizeof(SysIB_151x) +        \
> +                                      sizeof(SysIBTl_container) + \
> +                                      sizeof(SysIBTl_cpu)))

This is unused ?

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
> +    tle->polarity = S390_TOPOLOGY_POLARITY_H;
> +    tle->type = S390_TOPOLOGY_CPU_IFL;
> +    tle->origin = cpu_to_be64(origin * 64);
> +    tle->mask = cpu_to_be64(mask);
> +    return p + sizeof(*tle);
> +}

It would be nive to have some diagram on the field layout of a CPU tle
and container tle. It can be done as a follow up.

> +static char *s390_top_set_level2(S390Topology *topo, char *p)
> +{
> +    MachineState *ms = topo->ms;
> +    int i, origin;
> +
> +    for (i = 0; i < ms->smp.sockets; i++) {

a topo "nr-sockets" property would be better.
  
> +        if (!topo->socket[i].active_count) {

is 'active_count' only used to filter emtpy tles ? If so, I think this can
be done differently, without a state I mean.

> +            continue;
> +        }
> +        p = fill_container(p, 1, i);
> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {

(I need to understand what 'origin' means. this is not obvious)

> +            uint64_t mask = 0L;
> +
> +            mask = topo->tle[i].mask[origin];
> +            if (mask) {
> +                p = fill_tle_cpu(p, mask, origin);
> +            }
> +        }
> +    }
> +    return p;
> +}
> +
> +static int setup_stsi(SysIB_151x *sysib, int level)
> +{
> +    S390Topology *topo = s390_get_topology();
> +    MachineState *ms = topo->ms;
> +    char *p = sysib->tle;
> +
> +    qemu_mutex_lock(&topo->topo_mutex);
> +
> +    sysib->mnest = level;
> +    switch (level) {
> +    case 2:
> +        sysib->mag[TOPOLOGY_NR_MAG2] = ms->smp.sockets;

a topo "nr-sockets" property would be better.

> +        sysib->mag[TOPOLOGY_NR_MAG1] = topo->cpus;

a topo "nr-cpus" property would be better.

> +        p = s390_top_set_level2(topo, p);
> +        break;
> +    }
> +
> +    qemu_mutex_unlock(&topo->topo_mutex);
> +
> +    return p - (char *) sysib;
> +}
> +
> +#define S390_TOPOLOGY_MAX_MNEST 2
> +
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> +{
> +    uint64_t page[S390_TOPOLOGY_SYSIB_SIZE / sizeof(uint64_t)] = {};
> +    SysIB_151x *sysib = (SysIB_151x *) page;
> +    int len;
> +
> +    if (s390_is_pv() || !s390_has_topology() ||
> +        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    len = setup_stsi(sysib, sel2);
> +
> +    sysib->length = cpu_to_be16(len);
> +    s390_cpu_virt_mem_write(cpu, addr, ar, sysib, len);
> +    setcc(cpu, 0);
> +}
> +
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 6a8dbadf7e..f96630440b 100644
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
> @@ -1917,9 +1918,12 @@ static int handle_stsi(S390CPU *cpu)
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

Do we really need a new file for the CPU topology ? I am asking because
insert_stsi_3_2_2() is in kvm.c and may be, instead, we should gather
all the stsi routines.

C.


>   ))
>   
>   s390x_user_ss = ss.source_set()

