Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD27A6F43BA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjEBMXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjEBMXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:23:42 -0400
Received: from 3.mo548.mail-out.ovh.net (3.mo548.mail-out.ovh.net [188.165.32.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754421992
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 05:23:37 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.108])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id BD3F3216A4;
        Tue,  2 May 2023 12:05:04 +0000 (UTC)
Received: from kaod.org (37.59.142.101) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 2 May
 2023 14:05:03 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G004b2203f63-873e-4689-8c2e-25fe424d644d,
                    E090D36E4DC625C434D5D892E9869795142AB5A1) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <0e575143-573f-9363-d8dc-103bb819d15b@kaod.org>
Date:   Tue, 2 May 2023 14:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v20 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
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
 <20230425161456.21031-2-pmorel@linux.ibm.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230425161456.21031-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG2EX1.mxp5.local (172.16.2.11) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 55cdda68-7b3a-499e-8654-3ea4d17452fa
X-Ovh-Tracer-Id: 18190038896215690195
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrfedviedggeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeuuddtteelgeejhfeikeegffekhfelvefgfeejveffjeeiveegfeehgfdtgfeitdenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtuddpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvgh
 gvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/23 18:14, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific topology features like dedication
> and entitlement to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
> 
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and entitlement,

I think CpuS390Entitlement should be introduced in a separate patch and
only under target/s390x/cpu.c. It is machine specific and doesn't belong
to the machine common definitions.

'books' and 'drawers' could also be considered z-specific but High End
POWER systems (16s) have similar topology concepts, at least for drawers :
a group of 4 sockets. So let's keep it that way.


This problably means you will have to rework the get/set property handlers
with strcmp() or simply copy the generated lookup struct :

const QEnumLookup CpuS390Entitlement_lookup = {
     .array = (const char *const[]) {
         [S390_CPU_ENTITLEMENT_AUTO] = "auto",
         [S390_CPU_ENTITLEMENT_LOW] = "low",
         [S390_CPU_ENTITLEMENT_MEDIUM] = "medium",
         [S390_CPU_ENTITLEMENT_HIGH] = "high",
     },
     .size = S390_CPU_ENTITLEMENT__MAX
};

It should be fine.

Thanks,

C.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine-common.json            | 22 ++++++++++++
>   qapi/machine-target.json            | 12 +++++++
>   qapi/machine.json                   | 17 +++++++--
>   include/hw/boards.h                 | 10 +++++-
>   include/hw/qdev-properties-system.h |  4 +++
>   target/s390x/cpu.h                  |  6 ++++
>   hw/core/machine-smp.c               | 53 ++++++++++++++++++++++++-----
>   hw/core/machine.c                   |  4 +++
>   hw/core/qdev-properties-system.c    | 13 +++++++
>   hw/s390x/s390-virtio-ccw.c          |  2 ++
>   softmmu/vl.c                        |  6 ++++
>   target/s390x/cpu.c                  |  7 ++++
>   qapi/meson.build                    |  1 +
>   qemu-options.hx                     |  7 ++--
>   14 files changed, 150 insertions(+), 14 deletions(-)
>   create mode 100644 qapi/machine-common.json
> 
> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> new file mode 100644
> index 0000000000..bc0d76829c
> --- /dev/null
> +++ b/qapi/machine-common.json
> @@ -0,0 +1,22 @@
> +# -*- Mode: Python -*-
> +# vim: filetype=python
> +#
> +# This work is licensed under the terms of the GNU GPL, version 2 or later.
> +# See the COPYING file in the top-level directory.
> +
> +##
> +# = Machines S390 data types
> +##
> +
> +##
> +# @CpuS390Entitlement:
> +#
> +# An enumeration of cpu entitlements that can be assumed by a virtual
> +# S390 CPU
> +#
> +# Since: 8.1
> +##
> +{ 'enum': 'CpuS390Entitlement',
> +  'prefix': 'S390_CPU_ENTITLEMENT',
> +  'data': [ 'auto', 'low', 'medium', 'high' ] }
> +
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..42a6a40333 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,15 @@
>                      'TARGET_S390X',
>                      'TARGET_MIPS',
>                      'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @CpuS390Polarization:
> +#
> +# An enumeration of cpu polarization that can be assumed by a virtual
> +# S390 CPU
> +#
> +# Since: 8.1
> +##
> +{ 'enum': 'CpuS390Polarization',
> +  'prefix': 'S390_CPU_POLARIZATION',
> +  'data': [ 'horizontal', 'vertical' ] }
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 604b686e59..1cdd83f3fd 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -9,6 +9,7 @@
>   ##
>   
>   { 'include': 'common.json' }
> +{ 'include': 'machine-common.json' }
>   
>   ##
>   # @SysEmuTarget:
> @@ -70,7 +71,7 @@
>   #
>   # @thread-id: ID of the underlying host thread
>   #
> -# @props: properties describing to which node/socket/core/thread
> +# @props: properties describing to which node/drawer/book/socket/core/thread
>   #         virtual CPU belongs to, provided if supported by board
>   #
>   # @target: the QEMU system emulation target, which determines which
> @@ -902,13 +903,15 @@
>   # a CPU is being hotplugged.
>   #
>   # @node-id: NUMA node ID the CPU belongs to
> -# @socket-id: socket number within node/board the CPU belongs to
> +# @drawer-id: drawer number within node/board the CPU belongs to (since 8.1)
> +# @book-id: book number within drawer/node/board the CPU belongs to (since 8.1)
> +# @socket-id: socket number within book/node/board the CPU belongs to
>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>   # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
>   # @core-id: core number within cluster the CPU belongs to
>   # @thread-id: thread number within core the CPU belongs to
>   #
> -# Note: currently there are 6 properties that could be present
> +# Note: currently there are 8 properties that could be present
>   #       but management should be prepared to pass through other
>   #       properties with device_add command to allow for future
>   #       interface extension. This also requires the filed names to be kept in
> @@ -918,6 +921,8 @@
>   ##
>   { 'struct': 'CpuInstanceProperties',
>     'data': { '*node-id': 'int',
> +            '*drawer-id': 'int',
> +            '*book-id': 'int',
>               '*socket-id': 'int',
>               '*die-id': 'int',
>               '*cluster-id': 'int',
> @@ -1467,6 +1472,10 @@
>   #
>   # @cpus: number of virtual CPUs in the virtual machine
>   #
> +# @drawers: number of drawers in the CPU topology (since 8.1)
> +#
> +# @books: number of books in the CPU topology (since 8.1)
> +#
>   # @sockets: number of sockets in the CPU topology
>   #
>   # @dies: number of dies per socket in the CPU topology
> @@ -1483,6 +1492,8 @@
>   ##
>   { 'struct': 'SMPConfiguration', 'data': {
>        '*cpus': 'int',
> +     '*drawers': 'int',
> +     '*books': 'int',
>        '*sockets': 'int',
>        '*dies': 'int',
>        '*clusters': 'int',
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 6fbbfd56c8..9ef0bb76cf 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -131,12 +131,16 @@ typedef struct {
>    * @clusters_supported - whether clusters are supported by the machine
>    * @has_clusters - whether clusters are explicitly specified in the user
>    *                 provided SMP configuration
> + * @books_supported - whether books are supported by the machine
> + * @drawers_supported - whether drawers are supported by the machine
>    */
>   typedef struct {
>       bool prefer_sockets;
>       bool dies_supported;
>       bool clusters_supported;
>       bool has_clusters;
> +    bool books_supported;
> +    bool drawers_supported;
>   } SMPCompatProps;
>   
>   /**
> @@ -301,7 +305,9 @@ typedef struct DeviceMemoryState {
>   /**
>    * CpuTopology:
>    * @cpus: the number of present logical processors on the machine
> - * @sockets: the number of sockets on the machine
> + * @drawers: the number of drawers on the machine
> + * @books: the number of books in one drawer
> + * @sockets: the number of sockets in one book
>    * @dies: the number of dies in one socket
>    * @clusters: the number of clusters in one die
>    * @cores: the number of cores in one cluster
> @@ -310,6 +316,8 @@ typedef struct DeviceMemoryState {
>    */
>   typedef struct CpuTopology {
>       unsigned int cpus;
> +    unsigned int drawers;
> +    unsigned int books;
>       unsigned int sockets;
>       unsigned int dies;
>       unsigned int clusters;
> diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properties-system.h
> index 0ac327ae60..e4f8a13afc 100644
> --- a/include/hw/qdev-properties-system.h
> +++ b/include/hw/qdev-properties-system.h
> @@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
>   extern const PropertyInfo qdev_prop_off_auto_pcibar;
>   extern const PropertyInfo qdev_prop_pcie_link_speed;
>   extern const PropertyInfo qdev_prop_pcie_link_width;
> +extern const PropertyInfo qdev_prop_cpus390entitlement;
>   
>   #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
>       DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
> @@ -73,5 +74,8 @@ extern const PropertyInfo qdev_prop_pcie_link_width;
>   #define DEFINE_PROP_UUID_NODEFAULT(_name, _state, _field) \
>       DEFINE_PROP(_name, _state, _field, qdev_prop_uuid, QemuUUID)
>   
> +#define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f, _d) \
> +    DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_cpus390entitlement, \
> +                       CpuS390Entitlement)
>   
>   #endif
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7d6d01325b..bb7cfb0cab 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -29,6 +29,7 @@
>   #include "cpu_models.h"
>   #include "exec/cpu-defs.h"
>   #include "qemu/cpu-float.h"
> +#include "qapi/qapi-types-machine-common.h"
>   
>   #define ELF_MACHINE_UNAME "S390X"
>   
> @@ -131,6 +132,11 @@ struct CPUArchState {
>   
>   #if !defined(CONFIG_USER_ONLY)
>       uint32_t core_id; /* PoP "CPU address", same as cpu_index */
> +    int32_t socket_id;
> +    int32_t book_id;
> +    int32_t drawer_id;
> +    bool dedicated;
> +    CpuS390Entitlement entitlement; /* Used only for vertical polarization */
>       uint64_t cpuid;
>   #endif
>   
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index c3dab007da..77bee06304 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -30,8 +30,19 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>   {
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       GString *s = g_string_new(NULL);
> +    const char *multiply = " * ", *prefix = "";
>   
> -    g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
> +    if (mc->smp_props.drawers_supported) {
> +        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
> +        prefix = multiply;
> +    }
> +
> +    if (mc->smp_props.books_supported) {
> +        g_string_append_printf(s, "%sbooks (%u)", prefix, ms->smp.books);
> +        prefix = multiply;
> +    }
> +
> +    g_string_append_printf(s, "%ssockets (%u)", prefix, ms->smp.sockets);
>   
>       if (mc->smp_props.dies_supported) {
>           g_string_append_printf(s, " * dies (%u)", ms->smp.dies);
> @@ -73,6 +84,8 @@ void machine_parse_smp_config(MachineState *ms,
>   {
>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>       unsigned cpus    = config->has_cpus ? config->cpus : 0;
> +    unsigned drawers = config->has_drawers ? config->drawers : 0;
> +    unsigned books   = config->has_books ? config->books : 0;
>       unsigned sockets = config->has_sockets ? config->sockets : 0;
>       unsigned dies    = config->has_dies ? config->dies : 0;
>       unsigned clusters = config->has_clusters ? config->clusters : 0;
> @@ -85,6 +98,8 @@ void machine_parse_smp_config(MachineState *ms,
>        * explicit configuration like "cpus=0" is not allowed.
>        */
>       if ((config->has_cpus && config->cpus == 0) ||
> +        (config->has_drawers && config->drawers == 0) ||
> +        (config->has_books && config->books == 0) ||
>           (config->has_sockets && config->sockets == 0) ||
>           (config->has_dies && config->dies == 0) ||
>           (config->has_clusters && config->clusters == 0) ||
> @@ -111,6 +126,19 @@ void machine_parse_smp_config(MachineState *ms,
>       dies = dies > 0 ? dies : 1;
>       clusters = clusters > 0 ? clusters : 1;
>   
> +    if (!mc->smp_props.books_supported && books > 1) {
> +        error_setg(errp, "books not supported by this machine's CPU topology");
> +        return;
> +    }
> +    books = books > 0 ? books : 1;
> +
> +    if (!mc->smp_props.drawers_supported && drawers > 1) {
> +        error_setg(errp,
> +                   "drawers not supported by this machine's CPU topology");
> +        return;
> +    }
> +    drawers = drawers > 0 ? drawers : 1;
> +
>       /* compute missing values based on the provided ones */
>       if (cpus == 0 && maxcpus == 0) {
>           sockets = sockets > 0 ? sockets : 1;
> @@ -124,33 +152,41 @@ void machine_parse_smp_config(MachineState *ms,
>               if (sockets == 0) {
>                   cores = cores > 0 ? cores : 1;
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                          (drawers * books * dies * clusters * cores * threads);
>               } else if (cores == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>               }
>           } else {
>               /* prefer cores over sockets since 6.2 */
>               if (cores == 0) {
>                   sockets = sockets > 0 ? sockets : 1;
>                   threads = threads > 0 ? threads : 1;
> -                cores = maxcpus / (sockets * dies * clusters * threads);
> +                cores = maxcpus /
> +                        (drawers * books * sockets * dies * clusters * threads);
>               } else if (sockets == 0) {
>                   threads = threads > 0 ? threads : 1;
> -                sockets = maxcpus / (dies * clusters * cores * threads);
> +                sockets = maxcpus /
> +                          (drawers * books * dies * clusters * cores * threads);
>               }
>           }
>   
>           /* try to calculate omitted threads at last */
>           if (threads == 0) {
> -            threads = maxcpus / (sockets * dies * clusters * cores);
> +            threads = maxcpus /
> +                      (drawers * books * sockets * dies * clusters * cores);
>           }
>       }
>   
> -    maxcpus = maxcpus > 0 ? maxcpus : sockets * dies * clusters * cores * threads;
> +    maxcpus = maxcpus > 0 ? maxcpus : drawers * books * sockets * dies *
> +                                      clusters * cores * threads;
>       cpus = cpus > 0 ? cpus : maxcpus;
>   
>       ms->smp.cpus = cpus;
> +    ms->smp.drawers = drawers;
> +    ms->smp.books = books;
>       ms->smp.sockets = sockets;
>       ms->smp.dies = dies;
>       ms->smp.clusters = clusters;
> @@ -161,7 +197,8 @@ void machine_parse_smp_config(MachineState *ms,
>       mc->smp_props.has_clusters = config->has_clusters;
>   
>       /* sanity-check of the computed topology */
> -    if (sockets * dies * clusters * cores * threads != maxcpus) {
> +    if (drawers * books * sockets * dies * clusters * cores * threads !=
> +        maxcpus) {
>           g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
>           error_setg(errp, "Invalid CPU topology: "
>                      "product of the hierarchy must match maxcpus: "
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 1cf6822e06..41c7ba7027 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -831,6 +831,8 @@ static void machine_get_smp(Object *obj, Visitor *v, const char *name,
>       MachineState *ms = MACHINE(obj);
>       SMPConfiguration *config = &(SMPConfiguration){
>           .has_cpus = true, .cpus = ms->smp.cpus,
> +        .has_drawers = true, .drawers = ms->smp.drawers,
> +        .has_books = true, .books = ms->smp.books,
>           .has_sockets = true, .sockets = ms->smp.sockets,
>           .has_dies = true, .dies = ms->smp.dies,
>           .has_clusters = true, .clusters = ms->smp.clusters,
> @@ -1096,6 +1098,8 @@ static void machine_initfn(Object *obj)
>       /* default to mc->default_cpus */
>       ms->smp.cpus = mc->default_cpus;
>       ms->smp.max_cpus = mc->default_cpus;
> +    ms->smp.drawers = 1;
> +    ms->smp.books = 1;
>       ms->smp.sockets = 1;
>       ms->smp.dies = 1;
>       ms->smp.clusters = 1;
> diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-system.c
> index d42493f630..873fc62f50 100644
> --- a/hw/core/qdev-properties-system.c
> +++ b/hw/core/qdev-properties-system.c
> @@ -1143,3 +1143,16 @@ const PropertyInfo qdev_prop_uuid = {
>       .set   = set_uuid,
>       .set_default_value = set_default_uuid_auto,
>   };
> +
> +/* --- s390 cpu entitlement policy --- */
> +
> +QEMU_BUILD_BUG_ON(sizeof(CpuS390Entitlement) != sizeof(int));
> +
> +const PropertyInfo qdev_prop_cpus390entitlement = {
> +    .name  = "CpuS390Entitlement",
> +    .description = "low/medium (default)/high",
> +    .enum_table  = &CpuS390Entitlement_lookup,
> +    .get   = qdev_propinfo_get_enum,
> +    .set   = qdev_propinfo_set_enum,
> +    .set_default_value = qdev_propinfo_set_default_value_enum,
> +};
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 503f212a31..1a9bcda8b6 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -736,6 +736,8 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>       mc->no_sdcard = 1;
>       mc->max_cpus = S390_MAX_CPUS;
>       mc->has_hotpluggable_cpus = true;
> +    mc->smp_props.books_supported = true;
> +    mc->smp_props.drawers_supported = true;
>       assert(!mc->get_hotplug_handler);
>       mc->get_hotplug_handler = s390_get_hotplug_handler;
>       mc->cpu_index_to_instance_props = s390_cpu_index_to_props;
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 3340f63c37..bc293f8100 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -724,6 +724,12 @@ static QemuOptsList qemu_smp_opts = {
>           {
>               .name = "cpus",
>               .type = QEMU_OPT_NUMBER,
> +        }, {
> +            .name = "drawers",
> +            .type = QEMU_OPT_NUMBER,
> +        }, {
> +            .name = "books",
> +            .type = QEMU_OPT_NUMBER,
>           }, {
>               .name = "sockets",
>               .type = QEMU_OPT_NUMBER,
> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> index b10a8541ff..33afa1074a 100644
> --- a/target/s390x/cpu.c
> +++ b/target/s390x/cpu.c
> @@ -31,6 +31,7 @@
>   #include "qapi/qapi-types-machine.h"
>   #include "sysemu/hw_accel.h"
>   #include "hw/qdev-properties.h"
> +#include "hw/qdev-properties-system.h"
>   #include "fpu/softfloat-helpers.h"
>   #include "disas/capstone.h"
>   #include "sysemu/tcg.h"
> @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
>   static Property s390x_cpu_properties[] = {
>   #if !defined(CONFIG_USER_ONLY)
>       DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
> +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
> +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
> +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
> +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
> +    DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU, env.entitlement,
> +                                   S390_CPU_ENTITLEMENT_AUTO),
>   #endif
>       DEFINE_PROP_END_OF_LIST()
>   };
> diff --git a/qapi/meson.build b/qapi/meson.build
> index fbdb442fdf..b5b01fb7b5 100644
> --- a/qapi/meson.build
> +++ b/qapi/meson.build
> @@ -35,6 +35,7 @@ qapi_all_modules = [
>     'error',
>     'introspect',
>     'job',
> +  'machine-common',
>     'machine',
>     'machine-target',
>     'migration',
> diff --git a/qemu-options.hx b/qemu-options.hx
> index d42f60fb91..4c79e153fb 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -250,11 +250,14 @@ SRST
>   ERST
>   
>   DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> -    "-smp [[cpus=]n][,maxcpus=maxcpus][,sockets=sockets][,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
> +    "-smp [[cpus=]n][,maxcpus=maxcpus][,drawers=drawers][,books=books][,sockets=sockets]\n"
> +    "               [,dies=dies][,clusters=clusters][,cores=cores][,threads=threads]\n"
>       "                set the number of initial CPUs to 'n' [default=1]\n"
>       "                maxcpus= maximum number of total CPUs, including\n"
>       "                offline CPUs for hotplug, etc\n"
> -    "                sockets= number of sockets on the machine board\n"
> +    "                drawers= number of drawers on the machine board\n"
> +    "                books= number of books in one drawer\n"
> +    "                sockets= number of sockets in one book\n"
>       "                dies= number of dies in one socket\n"
>       "                clusters= number of clusters in one die\n"
>       "                cores= number of cores in one cluster\n"

