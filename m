Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B23263EF67
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLALYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiLALYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:24:09 -0500
X-Greylist: delayed 8303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Dec 2022 03:24:02 PST
Received: from 7.mo552.mail-out.ovh.net (7.mo552.mail-out.ovh.net [188.165.59.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62624C25A
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:24:02 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.54])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 8185A2AB7E;
        Thu,  1 Dec 2022 08:45:36 +0000 (UTC)
Received: from kaod.org (37.59.142.99) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Thu, 1 Dec
 2022 09:45:35 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G003ae4f326e-cf09-4a7e-bd34-11742f0112e6,
                    86CABC68C878FB51CEC5412B97BD86A53B3625A5) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <68e075ec-2698-3591-b808-9cb0f4b2c4f1@kaod.org>
Date:   Thu, 1 Dec 2022 09:45:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 0/7] s390x: CPU Topology
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
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221129174206.84882-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG6EX2.mxp5.local (172.16.2.52) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 69468969-3d29-4e97-ba6c-334b1b17d1a6
X-Ovh-Tracer-Id: 7615586972420180947
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrtdeggdduvdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeuuddtteelgeejhfeikeegffekhfelvefgfeejveffjeeiveegfeehgfdtgfeitdenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Pierre

On 11/29/22 18:41, Pierre Morel wrote:
> Hi,
> 
> The implementation of the CPU Topology in QEMU has been modified
> since the last patch series.
> 
> - The two preliminary patches have been accepted and are no longer
>    part of this series.
> 
> - The topology machine property has been abandoned
> 
> - the topology_capable QEMU capability has been abandoned
> 
> - both where replaced with a new CPU feature, topology-disable
>    to fence per default the ctop topology information feature.
> 
> To use the QEMU patches, you will need Linux V6-rc1 or newer,
> or use the following Linux mainline patches:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> To have a better understanding of the S390x CPU Topology and its
> implementation in QEMU you can have a look at the documentation in the
> last patch of this series.
> 
> The admin will want to match the host and the guest topology, taking
> into account that the guest does not recognize multithreading.
> Consequently, two vCPU assigned to threads of the same real CPU should
> preferably be assigned to the same socket of the guest machine.
Please make sure the patchset compiles on non-s390x platforms and check
that the documentation generates correctly. You will need to install :

   python3-sphinx python3-sphinx_rtd_theme

'configure' should then enable doc generation.

Thanks,

C.

