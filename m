Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFED6F5641
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 12:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjECKdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 06:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjECKdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 06:33:33 -0400
X-Greylist: delayed 80903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 May 2023 03:33:31 PDT
Received: from 7.mo548.mail-out.ovh.net (7.mo548.mail-out.ovh.net [46.105.33.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB3110C
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 03:33:30 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.16.19])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id D18592156B;
        Wed,  3 May 2023 10:23:54 +0000 (UTC)
Received: from kaod.org (37.59.142.108) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 3 May
 2023 12:23:53 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-108S00299b17b22-988a-48e8-936a-f17b3ed79f73,
                    0836407C87128E748F83891D9984914AEC5B674C) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <83be3f5a-0df4-0b7d-9be3-5bf9a30ab709@kaod.org>
Date:   Wed, 3 May 2023 12:23:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <cohuck@redhat.com>, <mst@redhat.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <nsg@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
 <1a919123-f07b-572e-8a33-0e5f9a6ed75c@redhat.com>
 <e233756c-52f6-547c-4c06-708459a98075@linux.ibm.com>
 <0d983d5f-f511-8e8f-0762-99f83e41171f@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <0d983d5f-f511-8e8f-0762-99f83e41171f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.108]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: bd760851-df37-49df-bdde-73f4de88e862
X-Ovh-Tracer-Id: 3907435629678070739
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvkedgvdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpedtjedvkeetffeiteelhfefvdegudfghfeuffekjeefgfefgfeuueejueevjeehkeenucffohhmrghinhepthhoohdrnhhonecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdekpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehthhhuthhhsehrvgguhhgrthdrtghomhdpnhhsgheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrth
 drtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 5/3/23 11:12, Thomas Huth wrote:
> On 28/04/2023 14.35, Pierre Morel wrote:
>>
>> On 4/27/23 15:38, Thomas Huth wrote:
>>> On 25/04/2023 18.14, Pierre Morel wrote:
>>>> The topology information are attributes of the CPU and are
>>>> specified during the CPU device creation.
>>>>
>>>> On hot plug we:
>>>> - calculate the default values for the topology for drawers,
>>>>    books and sockets in the case they are not specified.
>>>> - verify the CPU attributes
>>>> - check that we have still room on the desired socket
>>>>
>>>> The possibility to insert a CPU in a mask is dependent on the
>>>> number of cores allowed in a socket, a book or a drawer, the
>>>> checking is done during the hot plug of the CPU to have an
>>>> immediate answer.
>>>>
>>>> If the complete topology is not specified, the core is added
>>>> in the physical topology based on its core ID and it gets
>>>> defaults values for the modifier attributes.
>>>>
>>>> This way, starting QEMU without specifying the topology can
>>>> still get some advantage of the CPU topology.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>> ...
>>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>>> new file mode 100644
>>>> index 0000000000..471e0e7292
>>>> --- /dev/null
>>>> +++ b/hw/s390x/cpu-topology.c
>>>> @@ -0,0 +1,259 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>>> +/*
>>>> + * CPU Topology
>>>
>>> Since you later introduce a file with almost the same name in the target/s390x/ folder, it would be fine to have some more explanation here what this file is all about (especially with regards to the other file in target/s390x/).
>>
>>
>> I first did put the interceptions in target/s390/ then moved them in target/s390x/kvm because it is KVM related then again only let STSI interception.
>>
>> But to be honest I do not see any reason why not put everything in hw/s390x/ if CPU topology is implemented for TCG I think the code will call insert_stsi_15_1_x() too.
>>
>> no?
> 
> Oh well, it's all so borderline ... whether you rather think of this as part of the CPU (like the STSI instruction) or rather part of the machine (drawers, books, ...).
> I don't mind too much, as long as we don't have two files around with almost the same name (apart from "_" vs. "-"). So either keep the stsi part in target/s390x and use a better file name for that, or put everything together in one "cpu-topology.c" file.
> Or what do others think about it?

Would it make sense to have a target/s390x/stsi.c file with the stsi
routines to be called from TCG insn helpers and from the KVM backend ?
This suggestion is based on the services found in the ioinst.c file.

So, target/s390x/kvm/cpu_topology.c would become target/s390x/stsi.c
and stsi services would be moved there, if that makes sense.

Or target/s390x/kvm/stsi.c to start with because services are only
active for KVM targets.


Looking at hw/s390x/meson.build :

   s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
     'tod-kvm.c',
     's390-skeys-kvm.c',
     's390-stattrib-kvm.c',
     'pv.c',
     's390-pci-kvm.c',
     'cpu-topology.c',
   ))

It seems cpu-topology.c should be named cpu-topology-kvm.c to follow
the same convention.

However, I don't see much reason for the KVM condition, apart from
the new polarization definitions in machine-target.json which depend
on KVM. cpu-topology.c could well be compiled without the KVM #ifdef,
all seems in place to detect support at runtime.

In this file, we find a s390_handle_ptf() which is called from
kvm_handle_ptf() in target/s390x/kvm/kvm.c. Is it the right place for
it ? Shouldn't we move the service under target/s390x/kvm/kvm.c ?

Thanks,

C.



