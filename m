Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0636E629B07
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiKONsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 08:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiKONs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 08:48:28 -0500
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9A729A
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 05:48:24 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.108.16.128])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 9007223D65;
        Tue, 15 Nov 2022 13:48:22 +0000 (UTC)
Received: from kaod.org (37.59.142.103) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Tue, 15 Nov
 2022 14:48:21 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-103G005bb55cdf2-9856-4aa8-a050-ccf5654acd50,
                    4108EF7A520F6C47CD43A20CA0BA38D18DA47D40) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <b5540c7e-3c06-565a-6571-55c167ec347b@kaod.org>
Date:   Tue, 15 Nov 2022 14:48:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v11 09/11] s390x/cpu topology: add topology machine
 property
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
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-10-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221103170150.20789-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 757e0c7c-2a11-4284-8ce8-938ac63e83e2
X-Ovh-Tracer-Id: 10999479142332009427
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeggdehiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepkefhvefhheeiffduvefhfeeitefhleevudfgkedujeduieetfeffgfffvdelueelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhstghglheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkh
 hvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 18:01, Pierre Morel wrote:
> We keep the possibility to switch on/off the topology on newer
> machines with the property topology=[on|off].

The code has changed. You will need to rebase. May be after the
8.0 machine is introduced, or include Cornelia's patch in the
respin.

https://lore.kernel.org/qemu-devel/20221111124534.129111-1-cohuck@redhat.com/

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/boards.h                |  3 +++
>   include/hw/s390x/cpu-topology.h    |  8 +++-----
>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>   hw/core/machine.c                  |  3 +++
>   hw/s390x/cpu-topology.c            | 19 +++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c         | 28 ++++++++++++++++++++++++++++
>   util/qemu-config.c                 |  4 ++++
>   qemu-options.hx                    |  6 +++++-
>   8 files changed, 66 insertions(+), 6 deletions(-)
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
> +
>   extern GlobalProperty hw_compat_7_1[];
>   extern const size_t hw_compat_7_1_len;
>   
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 6fec10e032..f566394302 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -12,6 +12,8 @@
>   
>   #include "hw/qdev-core.h"
>   #include "qom/object.h"
> +#include "cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
>   
>   #define S390_TOPOLOGY_CPU_IFL 0x03
>   #define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
> @@ -38,10 +40,6 @@ struct S390Topology {
>   OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>   
>   void s390_topology_new_cpu(S390CPU *cpu);
> -
> -static inline bool s390_has_topology(void)
> -{
> -    return false;
> -}
> +bool s390_has_topology(void);
>   
>   #endif
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 89fca3f79f..d7602aedda 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>       bool dea_key_wrap;
>       bool pv;
>       bool zpcii_disable;
> +    bool cpu_topology;
>       uint8_t loadparm[8];
>       void *topology;
>   };
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index aa520e74a8..4f46d4ef23 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -40,6 +40,9 @@
>   #include "hw/virtio/virtio-pci.h"
>   #include "qom/object_interfaces.h"
>   
> +GlobalProperty hw_compat_7_2[] = {};
> +const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
> +
>   GlobalProperty hw_compat_7_1[] = {};
>   const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
>   
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index fc220bd8ac..c1550cc1e8 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -73,6 +73,25 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
>       }
>   }
>   
> +bool s390_has_topology(void)
> +{
> +    static S390CcwMachineState *ccw;
> +    Object *obj;
> +
> +    if (ccw) {
> +        return ccw->cpu_topology;

Shouldn't we test the capability also ?

	return s390mc->topology_capable && ccw->cpu_topology;

> +    }
> +
> +    /* we have to bail out for the "none" machine */
> +    obj = object_dynamic_cast(qdev_get_machine(),
> +                              TYPE_S390_CCW_MACHINE);
> +    if (!obj) {
> +        return false;
> +    }

Should be an assert I think.

> +    ccw = S390_CCW_MACHINE(obj);
> +    return ccw->cpu_topology;
> +}
> +
>   /*
>    * s390_topology_new_cpu:
>    * @cpu: a pointer to the new CPU
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index f1a9d6e793..ebb5615337 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -710,6 +710,26 @@ bool hpage_1m_allowed(void)
>       return get_machine_class()->hpage_1m_allowed;
>   }
>   
> +static inline bool machine_get_topology(Object *obj, Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    return ms->cpu_topology;
> +}
> +
> +static inline void machine_set_topology(Object *obj, bool value, Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);

You could introduce :

        S390CcwMachineClass *s390mc = S390_CCW_MACHINE_GET_CLASS(ms);


> +
> +    if (!get_machine_class()->topology_capable) {

and
             !s390mc->topology_capable

> +        error_setg(errp, "Property cpu-topology not available on machine %s",
> +                   get_machine_class()->parent_class.name);
> +        return;
> +    }
> +
> +    ms->cpu_topology = value;
> +}
> +
>   static void machine_get_loadparm(Object *obj, Visitor *v,
>                                    const char *name, void *opaque,
>                                    Error **errp)
> @@ -809,6 +829,12 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>                                      machine_set_zpcii_disable);
>       object_class_property_set_description(oc, "zpcii-disable",
>               "disable zPCI interpretation facilties");
> +
> +    object_class_property_add_bool(oc, "topology",
> +                                   machine_get_topology,
> +                                   machine_set_topology);
> +    object_class_property_set_description(oc, "topology",
> +            "enable CPU topology");
>   }
>   
>   static inline void s390_machine_initfn(Object *obj)
> @@ -818,6 +844,7 @@ static inline void s390_machine_initfn(Object *obj)
>       ms->aes_key_wrap = true;
>       ms->dea_key_wrap = true;
>       ms->zpcii_disable = false;
> +    ms->cpu_topology = true;
>   }
>   
>   static const TypeInfo ccw_machine_info = {
> @@ -888,6 +915,7 @@ static void ccw_machine_7_1_instance_options(MachineState *machine)
>       s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
>       s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>       ms->zpcii_disable = true;
> +    ms->cpu_topology = true;

shouldn't this be false ?


Thanks,

C.

>   }
>   
>   static void ccw_machine_7_1_class_options(MachineClass *mc)
> diff --git a/util/qemu-config.c b/util/qemu-config.c
> index 5325f6bf80..0a040552bd 100644
> --- a/util/qemu-config.c
> +++ b/util/qemu-config.c
> @@ -240,6 +240,10 @@ static QemuOptsList machine_opts = {
>               .name = "zpcii-disable",
>               .type = QEMU_OPT_BOOL,
>               .help = "disable zPCI interpretation facilities",
> +        },{
> +            .name = "topology",
> +            .type = QEMU_OPT_BOOL,
> +            .help = "disable CPU topology",
>           },
>           { /* End of list */ }
>       }
> diff --git a/qemu-options.hx b/qemu-options.hx
> index eb38e5dc40..ef59b28a03 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -38,7 +38,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>       "                hmat=on|off controls ACPI HMAT support (default=off)\n"
>       "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
>       "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> -    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
> +    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n"
> +    "                topology=on|off disables CPU topology (default=off)\n",
>       QEMU_ARCH_ALL)
>   SRST
>   ``-machine [type=]name[,prop=value[,...]]``
> @@ -163,6 +164,9 @@ SRST
>           Disables zPCI interpretation facilties on s390-ccw hosts.
>           This feature can be used to disable hardware virtual assists
>           related to zPCI devices. The default is off.
> +
> +    ``topology=on|off``
> +        Disables CPU topology on for S390 machines starting with s390-ccw-virtio-7.3.
>   ERST
>   
>   DEF("M", HAS_ARG, QEMU_OPTION_M,

