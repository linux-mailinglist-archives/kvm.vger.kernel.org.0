Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6A5EC714
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiI0PAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiI0O7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:59:55 -0400
X-Greylist: delayed 1123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Sep 2022 07:59:52 PDT
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6060613D71
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:59:51 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.51])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id E5AB025AA6;
        Tue, 27 Sep 2022 14:41:05 +0000 (UTC)
Received: from kaod.org (37.59.142.109) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 27 Sep
 2022 16:41:04 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-109S0031f5a7e25-70df-4a79-9fd9-0f1166658844,
                    12A65CACE92C1DACCE6E97948814F03D28E096F2) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <b54249b3-3639-80e9-3c5c-f556e605e6e6@kaod.org>
Date:   Tue, 27 Sep 2022 16:41:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v9 09/10] s390x/cpu_topology: activating CPU topology
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
 <20220902075531.188916-10-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220902075531.188916-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.109]
X-ClientProxiedBy: DAG3EX2.mxp5.local (172.16.2.22) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 3adfd510-bbc5-4028-9d5d-0e3fd204df60
X-Ovh-Tracer-Id: 828943807772134157
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegiedgheehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopehfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdfovfetjfhoshhtpehmohehhedv
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/22 09:55, Pierre Morel wrote:
> Starting with a new machine, s390-virtio-ccw-7.2, the machine
> property topology-disable is set to false while it is kept to
> true for older machine.

We probably need a machine class option also because we don't want
this to be possible :

    -M s390-ccw-virtio-7.1,topology-disable=false


> This allows migrating older machine without disabling the ctop
> CPU feature for older machine, thus keeping existing start scripts.
> 
> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility for the guest in the case the topology
> is not disabled.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/core/machine.c                  |  5 +++
>   hw/s390x/s390-virtio-ccw.c         | 55 ++++++++++++++++++++++++++----
>   include/hw/boards.h                |  3 ++
>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>   target/s390x/kvm/kvm.c             | 14 ++++++++
>   5 files changed, 72 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 4c5c8d1655..cbcdd40763 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -40,6 +40,11 @@
>   #include "hw/virtio/virtio-pci.h"
>   #include "qom/object_interfaces.h"
>   
> +GlobalProperty hw_compat_7_1[] = {
> +    { "s390x-cpu", "ctop", "off"},
> +};
> +const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
> +
>   GlobalProperty hw_compat_7_0[] = {
>       { "arm-gicv3-common", "force-8-bit-prio", "on" },
>       { "nvme-ns", "eui64-default", "on"},
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 1fa98740de..3078e68df7 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -249,11 +249,16 @@ static void ccw_init(MachineState *machine)
>       /* init memory + setup max page size. Required for the CPU model */
>       s390_memory_init(machine->ram);
>   
> -    /* Adding the topology must be done before CPU intialization*/
> -    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> -    object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,
> -                              OBJECT(dev));
> -    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> +    /*
> +     * Adding the topology must be done before CPU intialization but
> +     * only in the case it is not disabled for migration purpose.
> +     */
> +    if (!S390_CCW_MACHINE(machine)->topology_disable) {
> +        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
> +        object_property_add_child(qdev_get_machine(), TYPE_S390_CPU_TOPOLOGY,
> +                                  OBJECT(dev));
> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
> +    }
>   
>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>       s390_init_cpus(machine);
> @@ -676,6 +681,21 @@ static inline void machine_set_zpcii_disable(Object *obj, bool value,
>       ms->zpcii_disable = value;
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
> +    ms->topology_disable = value;
> +}
> +
>   static S390CcwMachineClass *current_mc;
>   
>   /*
> @@ -778,6 +798,13 @@ static inline void s390_machine_initfn(Object *obj)
>       object_property_set_description(obj, "zpcii-disable",
>               "disable zPCI interpretation facilties");
>       object_property_set_bool(obj, "zpcii-disable", false, NULL);
> +
> +    object_property_add_bool(obj, "topology-disable",
> +                             machine_get_topology_disable,
> +                             machine_set_topology_disable);
> +    object_property_set_description(obj, "topology-disable",
> +            "disable zPCI interpretation facilties");
> +    object_property_set_bool(obj, "topology-disable", false, NULL);
>   }
>   
>   static const TypeInfo ccw_machine_info = {
> @@ -830,14 +857,29 @@ bool css_migration_enabled(void)
>       }                                                                         \
>       type_init(ccw_machine_register_##suffix)
>   
> +static void ccw_machine_7_2_instance_options(MachineState *machine)
> +{
> +}
> +
> +static void ccw_machine_7_2_class_options(MachineClass *mc)
> +{
> +}
> +DEFINE_CCW_MACHINE(7_2, "7.2", true);
> +
>   static void ccw_machine_7_1_instance_options(MachineState *machine)
>   {
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
> +
> +    ccw_machine_7_2_instance_options(machine);
> +    ms->topology_disable = true;
>   }
>   
>   static void ccw_machine_7_1_class_options(MachineClass *mc)
>   {
> +    ccw_machine_7_2_class_options(mc);
> +    compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
>   }
> -DEFINE_CCW_MACHINE(7_1, "7.1", true);
> +DEFINE_CCW_MACHINE(7_1, "7.1", false);
>   
>   static void ccw_machine_7_0_instance_options(MachineState *machine)
>   {
> @@ -847,6 +889,7 @@ static void ccw_machine_7_0_instance_options(MachineState *machine)
>       ccw_machine_7_1_instance_options(machine);
>       s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>       ms->zpcii_disable = true;
> +
>   }
>   
>   static void ccw_machine_7_0_class_options(MachineClass *mc)
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 69e20c1252..6e9803aa2d 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -387,6 +387,9 @@ struct MachineState {
>       } \
>       type_init(machine_initfn##_register_types)
>   
> +extern GlobalProperty hw_compat_7_1[];
> +extern const size_t hw_compat_7_1_len;
> +
>   extern GlobalProperty hw_compat_7_0[];
>   extern const size_t hw_compat_7_0_len;
>   
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 9e7a0d75bc..b14660eecb 100644
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
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index cb14bcc012..6b7efee511 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2385,6 +2385,7 @@ bool kvm_s390_cpu_models_supported(void)
>   
>   void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>   {
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(qdev_get_machine());
>       struct kvm_s390_vm_cpu_machine prop = {};
>       struct kvm_device_attr attr = {
>           .group = KVM_S390_VM_CPU_MODEL,
> @@ -2466,6 +2467,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>           set_bit(S390_FEAT_UNPACK, model->features);
>       }
>   
> +    /*
> +     * If we have the CPU Topology implemented in KVM activate
> +     * the CPU TOPOLOGY feature.
> +     */
> +    if ((!ms->topology_disable) &&

'topology_disable' is a platform level configuration. May be instead,
the feature could be cleared at the machine level ?

Thanks,

C.

> +        kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 0) < 0) {
> +            error_setg(errp, "KVM: Error enabling KVM_CAP_S390_CPU_TOPOLOGY");
> +            return;
> +        }
> +        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
> +    }
> +
>       /* We emulate a zPCI bus and AEN, therefore we don't need HW support */
>       set_bit(S390_FEAT_ZPCI, model->features);
>       set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);

