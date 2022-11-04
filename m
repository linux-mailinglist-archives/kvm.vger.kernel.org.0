Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA416197AE
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKDNXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiKDNXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 09:23:12 -0400
Received: from 7.mo548.mail-out.ovh.net (7.mo548.mail-out.ovh.net [46.105.33.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF22E6BB
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 06:23:08 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.12])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 60F1721910;
        Fri,  4 Nov 2022 10:53:58 +0000 (UTC)
Received: from kaod.org (37.59.142.103) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Fri, 4 Nov
 2022 11:53:57 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-103G00512294ff4-1459-41c2-a197-7e13145b7ce3,
                    945B05C848FD95514DBD7F319F49D9B690A786E9) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
Date:   Fri, 4 Nov 2022 11:53:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <cohuck@redhat.com>, <mst@redhat.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <scgl@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
 <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 4b21e2f1-dfaf-4c4a-bdf3-2f6ddd0be394
X-Ovh-Tracer-Id: 17241468226470382547
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpthhhuhhthhesrhgvughhrghtrdgtohhmpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 11:16, Pierre Morel wrote:
> 
> 
> On 11/4/22 07:32, Thomas Huth wrote:
>> On 03/11/2022 18.01, Pierre Morel wrote:
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
>>>   1 file changed, 72 insertions(+), 55 deletions(-)
>>
>> -EMISSINGPATCHDESCRIPTION
>>
>> ... please add some words *why* this is a good idea / necessary.
> 
> I saw that the i386 patch had no description for the same patch so...
> 
> To be honest I do not know why it is necessary.
> The only reason I see is to be in sync with the PC implementation.
> 
> So what about:
> "
> Register TYPE_S390_CCW_MACHINE properties as class properties
> to be conform with the X architectures
> "
> ?
> 
> @Cédric , any official recommendation for doing that?

There was a bunch of commits related to QOM in this series :

   91def7b83 arm/virt: Register most properties as class properties
   f5730c69f0 i386: Register feature bit properties as class properties

which moved property definitions at the class level.

Then,

   commit d8fb7d0969 ("vl: switch -M parsing to keyval")

changed machine_help_func() to use a machine class and not machine
instance anymore.

I would use the same kind of commit log and add a Fixes tag to get it
merged in 7.2

With that,

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.
	

