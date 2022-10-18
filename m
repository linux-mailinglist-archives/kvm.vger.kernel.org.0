Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21836032D3
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJRSvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 14:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJRSvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 14:51:19 -0400
X-Greylist: delayed 3593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Oct 2022 11:51:16 PDT
Received: from 6.mo548.mail-out.ovh.net (6.mo548.mail-out.ovh.net [188.165.58.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30CE63B6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 11:51:16 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.141])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 3A0962272B;
        Tue, 18 Oct 2022 17:34:54 +0000 (UTC)
Received: from kaod.org (37.59.142.104) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 18 Oct
 2022 19:34:54 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-104R0059f61b7cb-bda1-4116-8703-25f36a2f64d9,
                    E583C31B167A4CECD7AFA5F42DA6B4ED7D5BF57A) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <08bbd6f8-6ae3-4a28-66ed-d5a290c1a30d@kaod.org>
Date:   Tue, 18 Oct 2022 19:34:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 6/9] s390x/cpu topology: add topology-disable machine
 property
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
 <20221012162107.91734-7-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221012162107.91734-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG5EX1.mxp5.local (172.16.2.41) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 2d99707d-972a-4c4d-a87c-4330bdcbad69
X-Ovh-Tracer-Id: 16410554092817713936
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgkeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhpsghonhiiihhnihesrhgvughhrghtrdgtoh
 hmpdhmshhtsehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/22 18:21, Pierre Morel wrote:
> S390 CPU topology is only allowed for s390-virtio-ccw-7.3 and
> newer S390 machines.
> We keep the possibility to disable the topology on these newer
> machines with the property topology-disable.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/boards.h                |  3 ++
>   include/hw/s390x/cpu-topology.h    | 18 +++++++++-
>   include/hw/s390x/s390-virtio-ccw.h |  2 ++
>   hw/core/machine.c                  |  5 +++
>   hw/s390x/s390-virtio-ccw.c         | 53 +++++++++++++++++++++++++++++-
>   util/qemu-config.c                 |  4 +++
>   qemu-options.hx                    |  6 +++-
>   7 files changed, 88 insertions(+), 3 deletions(-)
> 
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 311ed17e18..67147c47bf 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -379,6 +379,9 @@ struct MachineState {
>       } \
>       type_init(machine_initfn##_register_types)
>   
> +extern GlobalProperty hw_compat_7_2[];
> +extern const size_t hw_compat_7_2_len;

QEMU 7.2 is not out yet.

> +
>   extern GlobalProperty hw_compat_7_1[];
>   extern const size_t hw_compat_7_1_len;
>   
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 35a8a981ec..747c9ab4c6 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -12,6 +12,8 @@
>   
>   #include "hw/qdev-core.h"
>   #include "qom/object.h"
> +#include "cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
>   
>   #define S390_TOPOLOGY_POLARITY_H  0x00
>   
> @@ -43,7 +45,21 @@ void s390_topology_new_cpu(int core_id);
>   
>   static inline bool s390_has_topology(void)
>   {
> -    return false;
> +    static S390CcwMachineState *ccw;

hmm, s390_has_topology is a static inline. It would be preferable to
change its definition to extern.

> +    Object *obj;
> +
> +    if (ccw) {
> +        return !ccw->topology_disable;
> +    }
> +
> +    /* we have to bail out for the "none" machine */
> +    obj = object_dynamic_cast(qdev_get_machine(),
> +                              TYPE_S390_CCW_MACHINE);
> +    if (!obj) {
> +        return false;
> +    }
> +    ccw = S390_CCW_MACHINE(obj);
> +    return !ccw->topology_disable;
>   }
>   
>   #endif
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 9e7a0d75bc..6c4b4645fc 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>       bool dea_key_wrap;
>       bool pv;
>       bool zpcii_disable;
> +    bool topology_disable;
>       uint8_t loadparm[8];
>   };
>   
> @@ -46,6 +47,7 @@ struct S390CcwMachineClass {
>       bool cpu_model_allowed;
>       bool css_migration_enabled;
>       bool hpage_1m_allowed;
> +    bool topology_allowed;

'topology_disable' in the state and 'topology_allowed' in the class.
This is confusing :/

you should add 'topology_allowed' in its own patch and maybe call
it 'topology_capable' ? it is a QEMU capability AIUI

>   };
>   
>   /* runtime-instrumentation allowed by the machine */
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index aa520e74a8..93c497655e 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -40,6 +40,11 @@
>   #include "hw/virtio/virtio-pci.h"
>   #include "qom/object_interfaces.h"
>   
> +GlobalProperty hw_compat_7_2[] = {
> +    { "s390-topology", "topology-disable", "true" },

May be use TYPE_S390_CPU_TOPOLOGY instead.

But again, this should only apply to 7.1 machines and below. 7.2 is
not out yet.


> +};
> +const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
> +
>   GlobalProperty hw_compat_7_1[] = {};
>   const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
>   
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 362378454a..3a13fad4df 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -616,6 +616,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>       s390mc->cpu_model_allowed = true;
>       s390mc->css_migration_enabled = true;
>       s390mc->hpage_1m_allowed = true;
> +    s390mc->topology_allowed = true;
>       mc->init = ccw_init;
>       mc->reset = s390_machine_reset;
>       mc->block_default_type = IF_VIRTIO;
> @@ -726,6 +727,27 @@ bool hpage_1m_allowed(void)
>       return get_machine_class()->hpage_1m_allowed;
>   }
>   
> +static inline bool machine_get_topology_disable(Object *obj, Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    return ms->topology_disable;
> +}
> +
> +static inline void machine_set_topology_disable(Object *obj, bool value,
> +                                                Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    if (!get_machine_class()->topology_allowed) {
> +        error_setg(errp, "Property topology-disable not available on machine %s",
> +                   get_machine_class()->parent_class.name);

OK. I get it now. May be we should consider adding the capability concept
David introduced in the pseries machine. Please take a look. That's not
for this patchset though. It would be too much work.

> +        return;
> +    }
> +
> +    ms->topology_disable = value;
> +}
> +
>   static char *machine_get_loadparm(Object *obj, Error **errp)
>   {
>       S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> @@ -784,6 +806,13 @@ static inline void s390_machine_initfn(Object *obj)
>       object_property_set_description(obj, "zpcii-disable",
>               "disable zPCI interpretation facilties");
>       object_property_set_bool(obj, "zpcii-disable", false, NULL);
> +
> +    object_property_add_bool(obj, "topology-disable",
> +                             machine_get_topology_disable,
> +                             machine_set_topology_disable);
> +    object_property_set_description(obj, "topology-disable",
> +            "disable CPU topology");
> +    object_property_set_bool(obj, "topology-disable", false, NULL);

All the properties should be added in the machine class_init routine.
There is a preliminary cleanup patch required to move them all :/
   
>   }
>   
>   static const TypeInfo ccw_machine_info = {
> @@ -836,14 +865,36 @@ bool css_migration_enabled(void)
>       }                                                                         \
>       type_init(ccw_machine_register_##suffix)
>   
> +static void ccw_machine_7_3_instance_options(MachineState *machine)
> +{
> +}
> +
> +static void ccw_machine_7_3_class_options(MachineClass *mc)
> +{
> +}
> +DEFINE_CCW_MACHINE(7_3, "7.3", true);

That's too early.

> +
>   static void ccw_machine_7_2_instance_options(MachineState *machine)
>   {
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
> +
> +    ccw_machine_7_3_instance_options(machine);
> +    ms->topology_disable = true;
>   }
>   
>   static void ccw_machine_7_2_class_options(MachineClass *mc)
>   {
> +    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
> +    static GlobalProperty compat[] = {
> +        { TYPE_S390_CPU_TOPOLOGY, "topology-allowed", "off", },

hmm, "topology-allowed" is not a TYPE_S390_CPU_TOPOLOGY property.


> +    };
> +
> +    ccw_machine_7_3_class_options(mc);
> +    compat_props_add(mc->compat_props, hw_compat_7_2, hw_compat_7_2_len);
> +    compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
> +    s390mc->topology_allowed = false;
>   }
> -DEFINE_CCW_MACHINE(7_2, "7.2", true);
> +DEFINE_CCW_MACHINE(7_2, "7.2", false);
>   
>   static void ccw_machine_7_1_instance_options(MachineState *machine)
>   {
> diff --git a/util/qemu-config.c b/util/qemu-config.c
> index 5325f6bf80..c19e8bc8f3 100644
> --- a/util/qemu-config.c
> +++ b/util/qemu-config.c
> @@ -240,6 +240,10 @@ static QemuOptsList machine_opts = {
>               .name = "zpcii-disable",
>               .type = QEMU_OPT_BOOL,
>               .help = "disable zPCI interpretation facilities",
> +        },{
> +            .name = "topology-disable",
> +            .type = QEMU_OPT_BOOL,
> +            .help = "disable CPU topology",
>           },
>           { /* End of list */ }
>       }
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 95b998a13b..c804b0f899 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -38,7 +38,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>       "                hmat=on|off controls ACPI HMAT support (default=off)\n"
>       "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
>       "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> -    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
> +    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n"
> +    "                topology-disable=on|off disables CPU topology (default=off)\n",
>       QEMU_ARCH_ALL)
>   SRST
>   ``-machine [type=]name[,prop=value[,...]]``
> @@ -163,6 +164,9 @@ SRST
>           Disables zPCI interpretation facilties on s390-ccw hosts.
>           This feature can be used to disable hardware virtual assists
>           related to zPCI devices. The default is off.
> +
> +    ``topology-disable=on|off``
> +        Disables CPU topology on for S390 machines starting with s390-ccw-virtio-7.3.
>   ERST
>   
>   DEF("M", HAS_ARG, QEMU_OPTION_M,

