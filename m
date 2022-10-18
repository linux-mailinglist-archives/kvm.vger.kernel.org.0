Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ABF6031C2
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 19:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiJRRqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 13:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJRRqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 13:46:31 -0400
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE9AD7E36
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 10:46:29 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.141])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 07EB42893A;
        Tue, 18 Oct 2022 17:36:09 +0000 (UTC)
Received: from kaod.org (37.59.142.102) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 18 Oct
 2022 19:36:07 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-102R004c8849d8d-e30b-4c6f-973b-8e88cc022c18,
                    E583C31B167A4CECD7AFA5F42DA6B4ED7D5BF57A) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <b52ea256-c6c1-51ef-6e15-78a303143701@kaod.org>
Date:   Tue, 18 Oct 2022 19:36:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
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
X-Originating-IP: [37.59.142.102]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: ada754a4-b87b-46dc-9a99-3ce9c415ed97
X-Ovh-Tracer-Id: 16431383240643545872
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelvddgkeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhpsghonhiiihhnihesrhgvughhrghtrdgtoh
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
> The S390 CPU topology accepts the smp.threads argument while
> in reality it does not effectively allow multthreading.
> 
> Let's keep this behavior for machines older than 7.3 and
> refuse to use threads in newer machines until multithreading
> is really proposed to the guest by the machine.
> 
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

I don't understand this change.


C.


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

