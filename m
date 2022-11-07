Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92261EFA1
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiKGJxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiKGJxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:53:21 -0500
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B2B6578
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:53:20 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.250])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 510F322563;
        Mon,  7 Nov 2022 09:53:17 +0000 (UTC)
Received: from kaod.org (37.59.142.96) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Mon, 7 Nov
 2022 10:53:15 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-96R001f6666bc1-8a3f-4c45-a3cd-2c0f0d866bba,
                    6C43477976431A91849322C1890FE44AF44C4A7B) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <1ffbe6ea-e42a-f84f-c499-0444ffca24ac@kaod.org>
Date:   Mon, 7 Nov 2022 10:53:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v8 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine
 property
To:     Matthew Rosato <mjrosato@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <alex.williamson@redhat.com>, <schnelle@linux.ibm.com>,
        <cohuck@redhat.com>, <thuth@redhat.com>, <farman@linux.ibm.com>,
        <pmorel@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <pasic@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <mst@redhat.com>,
        <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-9-mjrosato@linux.ibm.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20220902172737.170349-9-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG5EX1.mxp5.local (172.16.2.41) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: bfa59ba9-ef7c-4ce4-9680-bf9fd394f4ee
X-Ovh-Tracer-Id: 15387955503059340164
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdelieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepmhhjrhhoshgrthhosehlihhnuhigrdhisghmrdgtohhmpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdgrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtghomhdpshgthhhnvghllhgvsehlihhnuhigrdhisghmrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpfhgrrhhmrghnsehlihhnuhigrdhisghmrdgtohhmpdhpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdprhhitghhrghrugdrhhgvnh
 guvghrshhonheslhhinhgrrhhordhorhhgpdgurghvihgusehrvgguhhgrthdrtghomhdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrheslhhinhhugidrihgsmhdrtghomhdpmhhsthesrhgvughhrghtrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 9/2/22 19:27, Matthew Rosato wrote:
> The zpcii-disable machine property can be used to force-disable the use
> of zPCI interpretation facilities for a VM.  By default, this setting
> will be off for machine 7.2 and newer.

KVM will tell if the zPCI interpretation feature is available for
the VM depending on the host capabilities and activation can be
handled with the "interpret" property at the device level.

For migration compatibility, zPCI interpretation can be globally
deactivated with a compat property. So, I don't understand how the
"zpcii-disable" machine option is useful.

The patch could possibly be reverted for 7.2 and replaced with :

   @@ -921,9 +921,13 @@ static void ccw_machine_7_1_instance_opt
    static void ccw_machine_7_1_class_options(MachineClass *mc)
    {
        S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
   +    static GlobalProperty compat[] = {
   +        { TYPE_S390_PCI_DEVICE, "interpret", "off", },
   +    };
    
        ccw_machine_7_2_class_options(mc);
        compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
   +    compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
        s390mc->max_threads = S390_MAX_CPUS;
        s390mc->topology_capable = false;

    }

Thanks,

C.

> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-kvm.c            |  4 +++-
>   hw/s390x/s390-virtio-ccw.c         | 25 +++++++++++++++++++++++++
>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>   qemu-options.hx                    |  8 +++++++-
>   util/qemu-config.c                 |  4 ++++
>   5 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
> index 9134fe185f..5eb7fd12e2 100644
> --- a/hw/s390x/s390-pci-kvm.c
> +++ b/hw/s390x/s390-pci-kvm.c
> @@ -22,7 +22,9 @@
>   
>   bool s390_pci_kvm_interp_allowed(void)
>   {
> -    return kvm_s390_get_zpci_op() && !s390_is_pv();
> +    return (kvm_s390_get_zpci_op() && !s390_is_pv() &&
> +            !object_property_get_bool(OBJECT(qdev_get_machine()),
> +                                      "zpcii-disable", NULL));
>   }
>   
>   int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 9a2467c889..f8ecb6172c 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -645,6 +645,21 @@ static inline void machine_set_dea_key_wrap(Object *obj, bool value,
>       ms->dea_key_wrap = value;
>   }
>   
> +static inline bool machine_get_zpcii_disable(Object *obj, Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    return ms->zpcii_disable;
> +}
> +
> +static inline void machine_set_zpcii_disable(Object *obj, bool value,
> +                                             Error **errp)
> +{
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
> +
> +    ms->zpcii_disable = value;
> +}
> +
>   static S390CcwMachineClass *current_mc;
>   
>   /*
> @@ -740,6 +755,13 @@ static inline void s390_machine_initfn(Object *obj)
>               "Up to 8 chars in set of [A-Za-z0-9. ] (lower case chars converted"
>               " to upper case) to pass to machine loader, boot manager,"
>               " and guest kernel");
> +
> +    object_property_add_bool(obj, "zpcii-disable",
> +                             machine_get_zpcii_disable,
> +                             machine_set_zpcii_disable);
> +    object_property_set_description(obj, "zpcii-disable",
> +            "disable zPCI interpretation facilties");
> +    object_property_set_bool(obj, "zpcii-disable", false, NULL);
>   }
>   
>   static const TypeInfo ccw_machine_info = {
> @@ -803,8 +825,11 @@ DEFINE_CCW_MACHINE(7_2, "7.2", true);
>   
>   static void ccw_machine_7_1_instance_options(MachineState *machine)
>   {
> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
> +
>       ccw_machine_7_2_instance_options(machine);
>       s390_cpudef_featoff_greater(16, 1, S390_FEAT_PAIE);
> +    ms->zpcii_disable = true;
>   }
>   
>   static void ccw_machine_7_1_class_options(MachineClass *mc)
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 3331990e02..8a0090a071 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -27,6 +27,7 @@ struct S390CcwMachineState {
>       bool aes_key_wrap;
>       bool dea_key_wrap;
>       bool pv;
> +    bool zpcii_disable;
>       uint8_t loadparm[8];
>   };
>   
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 31c04f7eea..7427dd1ed5 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -37,7 +37,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>       "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
>       "                hmat=on|off controls ACPI HMAT support (default=off)\n"
>       "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
> -    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
> +    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> +    "                zpcii-disable=on|off disables zPCI interpretation facilities (default=off)\n",
>       QEMU_ARCH_ALL)
>   SRST
>   ``-machine [type=]name[,prop=value[,...]]``
> @@ -157,6 +158,11 @@ SRST
>           ::
>   
>               -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512k
> +
> +    ``zpcii-disable=on|off``
> +        Disables zPCI interpretation facilties on s390-ccw hosts.
> +        This feature can be used to disable hardware virtual assists
> +        related to zPCI devices. The default is off.
>   ERST
>   
>   DEF("M", HAS_ARG, QEMU_OPTION_M,
> diff --git a/util/qemu-config.c b/util/qemu-config.c
> index 433488aa56..5325f6bf80 100644
> --- a/util/qemu-config.c
> +++ b/util/qemu-config.c
> @@ -236,6 +236,10 @@ static QemuOptsList machine_opts = {
>               .help = "Up to 8 chars in set of [A-Za-z0-9. ](lower case chars"
>                       " converted to upper case) to pass to machine"
>                       " loader, boot manager, and guest kernel",
> +        },{
> +            .name = "zpcii-disable",
> +            .type = QEMU_OPT_BOOL,
> +            .help = "disable zPCI interpretation facilities",
>           },
>           { /* End of list */ }
>       }

