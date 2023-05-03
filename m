Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9B6F5718
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 13:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjECLXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 07:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjECLXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 07:23:50 -0400
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D84224
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 04:23:48 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.216])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id DBCA92C829;
        Wed,  3 May 2023 11:23:45 +0000 (UTC)
Received: from kaod.org (37.59.142.105) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 3 May
 2023 13:23:44 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-105G006841e483d-e7b7-43d2-a540-9dab4ce0cd31,
                    0836407C87128E748F83891D9984914AEC5B674C) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <3a894d2c-2d0d-bdee-7740-945b2f5efd01@kaod.org>
Date:   Wed, 3 May 2023 13:23:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <nsg@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
 <7940b2d6-8b72-18e8-83a6-de3f122e416e@kaod.org>
 <76ae6b1c-9195-b63a-ba90-6a0ce3718990@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <76ae6b1c-9195-b63a-ba90-6a0ce3718990@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.105]
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: e54af435-b043-47b0-9f9a-d26dadc22fb6
X-Ovh-Tracer-Id: 4918212271982676947
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvkedgfeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeffudefleeiudejfeffhfejffeigffhhffhvdekieejheelvdeufffhjedtheeggeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddthedpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvgh
 gvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/23 09:21, Pierre Morel wrote:
> 
> On 5/2/23 14:30, Cédric Le Goater wrote:
>> On 4/25/23 18:14, Pierre Morel wrote:
>>> The topology information are attributes of the CPU and are
>>> specified during the CPU device creation.
>>>
>>>
> [...]
>>> +
>>> +/**
>>> + * s390_topology_init:
>>> + * @ms: the machine state where the machine topology is defined
>>> + *
>>> + * Keep track of the machine topology.
>>> + *
>>> + * Allocate an array to keep the count of cores per socket.
>>> + * The index of the array starts at socket 0 from book 0 and
>>> + * drawer 0 up to the maximum allowed by the machine topology.
>>> + */
>>> +static void s390_topology_init(MachineState *ms)
>>> +{
>>> +    CpuTopology *smp = &ms->smp;
>>> +
>>> +    s390_topology.smp = smp;
>>
>> I am not sure the 'smp' shortcut is necessary. 'MachineState *ms' is
>> always available where 'CpuTopology *smp' is used. so it could be
>> computed from a local variable AFAICT. It would reduce the risk of
>> 'smp' being NULL in some (future) code path.
>>
>> Thanks,
>>
>> C.
> 
> 
> So I will use directly current_machine->smp

There are a couple of place where 'MachineState *ms' can be used directly.
In the other places, routines will need an extra 'CpuTopology *smp'
parameter. If it gets too ugly, current_machine->smp might a better
alternative.

Thanks,

C.
