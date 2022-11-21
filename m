Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4504E6325E6
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiKUOcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 09:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiKUOca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 09:32:30 -0500
X-Greylist: delayed 1115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 06:32:28 PST
Received: from 3.mo552.mail-out.ovh.net (3.mo552.mail-out.ovh.net [178.33.254.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ABADA3
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 06:32:28 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.51])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 9328E2B3DC;
        Mon, 21 Nov 2022 14:13:51 +0000 (UTC)
Received: from kaod.org (37.59.142.110) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Mon, 21 Nov
 2022 15:13:50 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-110S0047048c205-014e-480d-8c4c-d8474797b26e,
                    3566E06BB212195A431F287D26CC7E6D91335DD7) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <8b29a416-8190-243f-c414-e9e77efae918@kaod.org>
Date:   Mon, 21 Nov 2022 15:13:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v11 04/11] s390x/cpu topology: reporting the CPU topology
 to the guest
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
 <20221103170150.20789-5-pmorel@linux.ibm.com>
 <1888d31f-227f-7edf-4cc8-dd88a9b19435@kaod.org>
 <34caa4c4-0b94-1729-fe88-77d9b4240f04@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <34caa4c4-0b94-1729-fe88-77d9b4240f04@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.110]
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 945a0af3-0f06-440a-a8f0-a7cc7268119f
X-Ovh-Tracer-Id: 9772529718409071571
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdeivdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdduuddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> +static char *s390_top_set_level2(S390Topology *topo, char *p)
>>> +{
>>> +    int i, origin;
>>> +
>>> +    for (i = 0; i < topo->nr_sockets; i++) {
>>> +        if (!topo->socket[i].active_count) {
>>> +            continue;
>>> +        }
>>> +        p = fill_container(p, 1, i);
>>> +        for (origin = 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
>>> +            uint64_t mask = 0L;
>>> +
>>> +            mask = topo->socket[i].mask[origin];
>>> +            if (mask) {
>>> +                p = fill_tle_cpu(p, mask, origin);
>>> +            }
>>> +        }
>>> +    }
>>> +    return p;
>>> +}
>>
>> Why is it not possible to compute this topo information at "runtime",
>> when stsi is called, without maintaining state in an extra S390Topology
>> object ? Couldn't we loop on the CPU list to gather the topology bits
>> for the same result ?
>>
>> It would greatly simplify the feature.
>>
>> C.
>>
> 
> The vCPU are not stored in order of creation in the CPU list and not in a topology order.
> To be able to build the SYSIB we need an intermediate structure to reorder the CPUs per container.
> 
> We can do this re-ordering during the STSI interception but the idea was to keep this instruction as fast as possible.> 
> The second reason is to have a structure ready for the QEMU migration when we introduce vCPU migration from a socket to another socket, having then a different internal representation of the topology.
> 
> 
> However, if as discussed yesterday we use a new cpu flag we would not need any special migration structure in the current series.
> 
> So it only stays the first reason to do the re-ordering preparation during the plugging of a vCPU, to optimize the STSI instruction.
> 
> If we think the optimization is not worth it or do not bring enough to be consider, we can do everything during the STSI interception.

Is it called on a hot code path ? AFAICT, it is only called once
per cpu when started. insert_stsi_3_2_2 is also a guest exit andit queries the machine definition in a very similar way.

Thanks,

C.

