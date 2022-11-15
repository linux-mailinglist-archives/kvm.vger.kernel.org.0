Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4E629A20
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 14:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiKON1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 08:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiKON1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 08:27:05 -0500
Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E5413E3F
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 05:27:04 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.134])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id BE24913EDC420;
        Tue, 15 Nov 2022 14:27:02 +0100 (CET)
Received: from kaod.org (37.59.142.100) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Tue, 15 Nov
 2022 14:27:00 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-100R003d6e1515c-6db8-45e1-9b2b-aa2545b6354b,
                    4108EF7A520F6C47CD43A20CA0BA38D18DA47D40) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <2dbe5902-7391-1151-dd0d-266c866cf7b9@kaod.org>
Date:   Tue, 15 Nov 2022 14:27:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v11 08/11] s390x/cpu topology: add topology_capable QEMU
 capability
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
 <20221103170150.20789-9-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221103170150.20789-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: d1aa51ff-fafb-4638-bf8d-fcb855c0b58e
X-Ovh-Tracer-Id: 10639191172735798227
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeggdehvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 18:01, Pierre Morel wrote:
> S390 CPU topology is only allowed for s390-virtio-ccw-7.2 and
> newer S390 machines.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>   include/hw/s390x/s390-virtio-ccw.h | 1 +
>   hw/s390x/s390-virtio-ccw.c         | 2 ++
>   2 files changed, 3 insertions(+)
> 
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index 6488279690..89fca3f79f 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -48,6 +48,7 @@ struct S390CcwMachineClass {
>       bool css_migration_enabled;
>       bool hpage_1m_allowed;
>       int max_threads;
> +    bool topology_capable;
>   };
>   
>   /* runtime-instrumentation allowed by the machine */
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 4de2622f99..f1a9d6e793 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -763,6 +763,7 @@ static void ccw_machine_class_init(ObjectClass *oc, void *data)
>       s390mc->css_migration_enabled = true;
>       s390mc->hpage_1m_allowed = true;
>       s390mc->max_threads = 1;
> +    s390mc->topology_capable = true;
>       mc->init = ccw_init;
>       mc->reset = s390_machine_reset;
>       mc->block_default_type = IF_VIRTIO;
> @@ -896,6 +897,7 @@ static void ccw_machine_7_1_class_options(MachineClass *mc)
>       ccw_machine_7_2_class_options(mc);
>       compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
>       s390mc->max_threads = S390_MAX_CPUS;
> +    s390mc->topology_capable = false;
>   }
>   DEFINE_CCW_MACHINE(7_1, "7.1", false);
>   

