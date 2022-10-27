Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C17660F449
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiJ0KBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 06:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiJ0KBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 06:01:15 -0400
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9605106E0E
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 03:00:57 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.97])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 5BB8D136F9E44;
        Thu, 27 Oct 2022 12:00:55 +0200 (CEST)
Received: from kaod.org (37.59.142.106) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Thu, 27 Oct
 2022 12:00:54 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-106R0066eacc60f-efc5-466a-854d-134bb82c33fd,
                    96B5E4AD3926E0A35FCB490C91431F0B86587271) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <910308da-1cc6-03ea-c8b4-304d90271b8d@kaod.org>
Date:   Thu, 27 Oct 2022 12:00:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 7/9] s390x/cpu topology: add max_threads machine class
 attribute
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
 <20221012162107.91734-8-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221012162107.91734-8-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG1EX1.mxp5.local (172.16.2.1) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 7f87e380-8b4a-4b17-93f2-519c1eaafbc0
X-Ovh-Tracer-Id: 6257470207890459408
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpphgsohhniihinhhisehrvgguhhgrthdrtghomh
 dpmhhsthesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Pierre,

On 10/12/22 18:21, Pierre Morel wrote:
> The S390 CPU topology accepts the smp.threads argument while
> in reality it does not effectively allow multthreading.
> 
> Let's keep this behavior for machines older than 7.3 and
> refuse to use threads in newer machines until multithreading
> is really proposed to the guest by the machine.

This change is unrelated to the rest of the series and we could merge it
for 7.2. We still have time for it.

Thanks,

C.

  
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>   hw/s390x/s390-virtio-ccw.c         | 10 ++++++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 6c4b4645fc..319dfac1bb 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -48,6 +48,7 @@ struct S390CcwMachineClass {
>       bool css_migration_enabled;
>       bool hpage_1m_allowed;
>       bool topology_allowed;
> +    int max_threads;
>   };
>   
>   /* runtime-instrumentation allowed by the machine */
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 3a13fad4df..d6ce31d168 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -85,8 +85,15 @@ out:
>   static void s390_init_cpus(MachineState *machine)
>   {
>       MachineClass *mc = MACHINE_GET_CLASS(machine);
> +    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
>       int i;
>   
> +    if (machine->smp.threads > s390mc->max_threads) {
> +        error_report("S390 does not support more than %d threads.",
> +                     s390mc->max_threads);
> +        exit(1);
> +    }
> +
>       /* initialize possible_cpus */
>       mc->possible_cpu_arch_ids(machine);
>   
> @@ -617,6 +624,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>       s390mc->css_migration_enabled = true;
>       s390mc->hpage_1m_allowed = true;
>       s390mc->topology_allowed = true;
> +    s390mc->max_threads = 1;
>       mc->init = ccw_init;
>       mc->reset = s390_machine_reset;
>       mc->block_default_type = IF_VIRTIO;
> @@ -887,12 +895,14 @@ static void ccw_machine_7_2_class_options(MachineClass *mc)
>       S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
>       static GlobalProperty compat[] = {
>           { TYPE_S390_CPU_TOPOLOGY, "topology-allowed", "off", },
> +        { TYPE_S390_CPU_TOPOLOGY, "max_threads", "off", },
>       };
>   
>       ccw_machine_7_3_class_options(mc);
>       compat_props_add(mc->compat_props, hw_compat_7_2, hw_compat_7_2_len);
>       compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
>       s390mc->topology_allowed = false;
> +    s390mc->max_threads = S390_MAX_CPUS;
>   }
>   DEFINE_CCW_MACHINE(7_2, "7.2", false);
>   

