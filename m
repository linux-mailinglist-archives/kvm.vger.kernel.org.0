Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D032609DE5
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJXJWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJXJWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:22:35 -0400
Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC0CB55
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:22:33 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.16.210])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 625D8135A8AF0;
        Mon, 24 Oct 2022 11:22:31 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Mon, 24 Oct
 2022 11:22:30 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G001ecf31bd4-2aa5-49d2-8f04-f3d7e1676005,
                    6590F3F04E20B41924A4A18FF3E3B83F50E47F7B) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <1d99c9e3-bbd7-299a-3d68-dc498745115d@kaod.org>
Date:   Mon, 24 Oct 2022 11:22:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
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
 <20221012162107.91734-2-pmorel@linux.ibm.com>
 <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
 <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG6EX2.mxp5.local (172.16.2.52) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 45379858-eace-497f-959d-441f6896aa54
X-Ovh-Tracer-Id: 6437614193720920848
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtgedguddtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeekteejtdelkeejvdevffduhfetteelieefgeefffeugffhfeekheffueefledujeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpphgsohhniihinhhisehrvgguhhgrthdrtghomh
 dpmhhsthesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 17:39, Pierre Morel wrote:
> 
> 
> On 10/18/22 18:43, Cédric Le Goater wrote:
>> Hello Pierre,
>>
>> On 10/12/22 18:20, Pierre Morel wrote:
>>> In the S390x CPU topology the core_id specifies the CPU address
>>> and the position of the core withing the topology.
>>>
>>> Let's build the topology based on the core_id.
>>> s390x/cpu topology: core_id sets s390x CPU topology
>>>
>>> In the S390x CPU topology the core_id specifies the CPU address
>>> and the position of the cpu withing the topology.
>>>
>>> Let's build the topology based on the core_id.
>>
>> The commit log is doubled.
> 
> Yes, thanks.
> 
>>
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   include/hw/s390x/cpu-topology.h |  45 +++++++++++
>>>   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
>>>   hw/s390x/s390-virtio-ccw.c      |  21 +++++
>>>   hw/s390x/meson.build            |   1 +
>>>   4 files changed, 199 insertions(+)
>>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>>   create mode 100644 hw/s390x/cpu-topology.c
>>>
>>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>>> new file mode 100644
>>> index 0000000000..66c171d0bc
>>> --- /dev/null
>>> +++ b/include/hw/s390x/cpu-topology.h
>>> @@ -0,0 +1,45 @@
>>> +/*
>>> + * CPU Topology
>>> + *
>>> + * Copyright 2022 IBM Corp.
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>>> + * your option) any later version. See the COPYING file in the top-level
>>> + * directory.
>>> + */
>>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>>> +#define HW_S390X_CPU_TOPOLOGY_H
>>> +
>>> +#include "hw/qdev-core.h"
>>> +#include "qom/object.h"
>>> +
>>> +typedef struct S390TopoContainer {
>>> +    int active_count;
>>> +} S390TopoContainer;
>>
>> This structure does not seem very useful.
>>
>>> +
>>> +#define S390_TOPOLOGY_CPU_IFL 0x03
>>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>>> +typedef struct S390TopoTLE { 
>>
>> The 'Topo' is redundant as TLE stands for 'topology-list entry'. This is minor.
>>
>>> +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
>>> +} S390TopoTLE;
>>> +
>>> +struct S390Topology {
>>> +    SysBusDevice parent_obj;
>>> +    int cpus;
>>> +    S390TopoContainer *socket;
>>> +    S390TopoTLE *tle;
>>> +    MachineState *ms;
>>
>> hmm, it would be cleaner to introduce the fields and properties needed
>> by the S390Topology model and avoid dragging the machine object pointer.
>> AFAICT, these properties would be :
>>
>>    "nr-cpus"
>>    "max-cpus"
>>    "nr-sockets"
>>
> 
> OK
> 
>>
>>
>>> +};
>>> +
>>> +#define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>>> +OBJECT_DECLARE_SIMPLE_TYPE(S390Topology, S390_CPU_TOPOLOGY)
>>> +
>>> +S390Topology *s390_get_topology(void);
>>> +void s390_topology_new_cpu(int core_id);
>>> +
>>> +static inline bool s390_has_topology(void)
>>> +{
>>> +    return false;
>>> +}
>>> +
>>> +#endif
>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>> new file mode 100644
>>> index 0000000000..42b22a1831
>>> --- /dev/null
>>> +++ b/hw/s390x/cpu-topology.c
>>> @@ -0,0 +1,132 @@
>>> +/*
>>> + * CPU Topology
>>> + *
>>> + * Copyright IBM Corp. 2022
>>
>> The Copyright tag is different in the .h file.
> 
> OK, I change this to be like in the header file it seems to be the most used format.
> 
>>
>>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>>> +
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>>> + * your option) any later version. See the COPYING file in the top-level
>>> + * directory.
>>> + */
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qapi/error.h"
>>> +#include "qemu/error-report.h"
>>> +#include "hw/sysbus.h"
>>> +#include "hw/qdev-properties.h"
>>> +#include "hw/boards.h"
>>> +#include "qemu/typedefs.h"
>>> +#include "target/s390x/cpu.h"
>>> +#include "hw/s390x/s390-virtio-ccw.h"
>>> +#include "hw/s390x/cpu-topology.h"
>>> +
>>> +S390Topology *s390_get_topology(void)
>>> +{
>>> +    static S390Topology *s390Topology;
>>> +
>>> +    if (!s390Topology) {
>>> +        s390Topology = S390_CPU_TOPOLOGY(
>>> +            object_resolve_path(TYPE_S390_CPU_TOPOLOGY, NULL));
>>> +    }
>>> +
>>> +    return s390Topology;
>>
>> I am not convinced this routine is useful. The s390Topology pointer
>> could be stored under the machine state I think. It wouldn't be a
>> problem when CPUs are hot plugged since we have access to the machine
>> in the hot plug handler.
> 
> OK, I add a pointer to the machine state that will be initialised during s390_init_topology()

LGTM.

> 
>>
>> For the stsi call, 'struct ArchCPU' probably lacks a back pointer to
>> the machine objects with which CPU interact. These are typically
>> interrupt controllers or this new s390Topology model. You could add
>> the pointer there or, better, under a generic 'void *opaque' attribute.
>>
>> That said, what you did works fine. The modeling could be cleaner.
> 
> Yes. I think you are right and I add a opaque pointer to the topology.

As an example, you could look at PPC where the PowerPCCPU CPU model is
shared between two differents machine, a baremetal one PowerNV and the
para-virtual one pSeries/sPAPR. Look for :

    pnv_cpu_state(PowerPCCPU *cpu)
    spapr_cpu_state(PowerPCCPU *cpu)

the machine CPU state is stored under an opaque cpu->machine_data which is
specific to each machine. It doesn't have to be as complex on s390 since
we only have one type of z-machine. An opaque is a good idea still.

Thanks,

C.
