Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8F2648481
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 16:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiLIPCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 10:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiLIPCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 10:02:21 -0500
Received: from 5.mo548.mail-out.ovh.net (5.mo548.mail-out.ovh.net [188.165.49.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF2178B1
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 07:02:19 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.210])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 3D64921BA7;
        Fri,  9 Dec 2022 14:56:49 +0000 (UTC)
Received: from kaod.org (37.59.142.99) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 9 Dec
 2022 15:56:48 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G00345b35db4-6999-463f-8c72-f4693cd35f2e,
                    703C8C4CBBC51929D19CEDB14A3E71E172461769) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <69575e36-224a-c611-d446-fc7133586505@kaod.org>
Date:   Fri, 9 Dec 2022 15:56:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v13 4/7] s390x/cpu_topology: CPU topology migration
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
 <20221208094432.9732-5-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221208094432.9732-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG8EX1.mxp5.local (172.16.2.71) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 6ba7bfcb-4647-4c66-8c00-c49c44c87041
X-Ovh-Tracer-Id: 5526198219551116243
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgdeikecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhstghglheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpfh
 hrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 10:44, Pierre Morel wrote:
> The migration can only take place if both source and destination
> of the migration both use or both do not use the CPU topology
> facility.
> 
> We indicate a change in topology during migration postload for the
> case the topology changed between source and destination.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   target/s390x/cpu.h        |  1 +
>   hw/s390x/cpu-topology.c   | 49 +++++++++++++++++++++++++++++++++++++++
>   target/s390x/cpu-sysemu.c |  8 +++++++
>   3 files changed, 58 insertions(+)
> 
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index bc1a7de932..284c708a6c 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -854,6 +854,7 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
>   int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
>                                   int vq, bool assign);
>   void s390_cpu_topology_reset(void);
> +int s390_cpu_topology_mtcr_set(void);
>   #ifndef CONFIG_USER_ONLY
>   unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
>   #else
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index f54afcf550..8a2fe041d4 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -18,6 +18,7 @@
>   #include "target/s390x/cpu.h"
>   #include "hw/s390x/s390-virtio-ccw.h"
>   #include "hw/s390x/cpu-topology.h"
> +#include "migration/vmstate.h"
>   
>   /**
>    * s390_has_topology
> @@ -129,6 +130,53 @@ static void s390_topology_reset(DeviceState *dev)
>       s390_cpu_topology_reset();
>   }
>   
> +/**
> + * cpu_topology_postload
> + * @opaque: a pointer to the S390Topology
> + * @version_id: version identifier
> + *
> + * We check that the topology is used or is not used
> + * on both side identically.
> + *
> + * If the topology is in use we set the Modified Topology Change Report
> + * on the destination host.
> + */
> +static int cpu_topology_postload(void *opaque, int version_id)
> +{
> +    int ret;
> +
> +    /* We do not support CPU Topology, all is good */
> +    if (!s390_has_topology()) {
> +        return 0;
> +    }
> +
> +    /* We support CPU Topology, set the MTCR unconditionally */
> +    ret = s390_cpu_topology_mtcr_set();
> +    if (ret) {
> +        error_report("Failed to set MTCR: %s", strerror(-ret));
> +    }
> +    return ret;
> +}
> +
> +/**
> + * cpu_topology_needed:
> + * @opaque: The pointer to the S390Topology
> + *
> + * We always need to know if source and destination use the topology.
> + */
> +static bool cpu_topology_needed(void *opaque)
> +{
> +    return s390_has_topology();
> +}
> +
> +const VMStateDescription vmstate_cpu_topology = {
> +    .name = "cpu_topology",
> +    .version_id = 1,
> +    .post_load = cpu_topology_postload,

Please use 'cpu_topology_post_load', it is easier to catch with a grep.

Thanks,

C.

> +    .minimum_version_id = 1,
> +    .needed = cpu_topology_needed,
> +};
> +
>   /**
>    * topology_class_init:
>    * @oc: Object class
> @@ -145,6 +193,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
>       device_class_set_props(dc, s390_topology_properties);
>       set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>       dc->reset = s390_topology_reset;
> +    dc->vmsd = &vmstate_cpu_topology;
>   }
>   
>   static const TypeInfo cpu_topology_info = {
> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
> index e27864c5f5..a8e3e6219d 100644
> --- a/target/s390x/cpu-sysemu.c
> +++ b/target/s390x/cpu-sysemu.c
> @@ -319,3 +319,11 @@ void s390_cpu_topology_reset(void)
>           }
>       }
>   }
> +
> +int s390_cpu_topology_mtcr_set(void)
> +{
> +    if (kvm_enabled()) {
> +        return kvm_s390_topology_set_mtcr(1);
> +    }
> +    return -ENOENT;
> +}

