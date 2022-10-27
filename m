Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7760F473
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 12:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiJ0KHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 06:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiJ0KHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 06:07:35 -0400
X-Greylist: delayed 510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 03:07:34 PDT
Received: from 7.mo548.mail-out.ovh.net (7.mo548.mail-out.ovh.net [46.105.33.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A11ABCB8D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 03:07:33 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.16.235])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 942FB223A7;
        Thu, 27 Oct 2022 09:59:00 +0000 (UTC)
Received: from kaod.org (37.59.142.103) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Thu, 27 Oct
 2022 11:58:59 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-103G0059ed3a6e5-37c6-4d5c-9c32-326fccb2748d,
                    96B5E4AD3926E0A35FCB490C91431F0B86587271) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <cca5db4f-4c05-1fda-de77-19d1cc161748@kaod.org>
Date:   Thu, 27 Oct 2022 11:58:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 3/9] s390x/cpu_topology: resetting the
 Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <cohuck@redhat.com>, <mst@redhat.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <frankja@linux.ibm.com>, <berrange@redhat.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-4-pmorel@linux.ibm.com>
 <450544bf-4ff0-9d72-f57c-4274692916a5@redhat.com>
 <77d52b82-aa44-ed79-2345-1b3c3a15fb7d@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <77d52b82-aa44-ed79-2345-1b3c3a15fb7d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 25859d7b-9a03-4c2e-a6eb-c2671e8aadda
X-Ovh-Tracer-Id: 6225100585256782608
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpphgsohhniihinhhisehrvgguhhgrthdrtghomh
 dpmhhsthesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpthhhuhhthhesrhgvughhrghtrdgtohhmpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 11:11, Pierre Morel wrote:
> 
> 
> On 10/27/22 10:14, Thomas Huth wrote:
>> On 12/10/2022 18.21, Pierre Morel wrote:
>>> During a subsystem reset the Topology-Change-Report is cleared
>>> by the machine.
>>> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>>>   bit of the SCA in the case of a subsystem reset.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>   target/s390x/cpu.h           |  1 +
>>>   target/s390x/kvm/kvm_s390x.h |  1 +
>>>   hw/s390x/cpu-topology.c      | 12 ++++++++++++
>>>   hw/s390x/s390-virtio-ccw.c   |  1 +
>>>   target/s390x/cpu-sysemu.c    |  7 +++++++
>>>   target/s390x/kvm/kvm.c       | 23 +++++++++++++++++++++++
>>>   6 files changed, 45 insertions(+)
>>>
>>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>>> index d604aa9c78..9b35795ac8 100644
>>> --- a/target/s390x/cpu.h
>>> +++ b/target/s390x/cpu.h
>>> @@ -825,6 +825,7 @@ void s390_enable_css_support(S390CPU *cpu);
>>>   void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg);
>>>   int s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch_id,
>>>                                   int vq, bool assign);
>>> +void s390_cpu_topology_reset(void);
>>>   #ifndef CONFIG_USER_ONLY
>>>   unsigned int s390_cpu_set_state(uint8_t cpu_state, S390CPU *cpu);
>>>   #else
>>> diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
>>> index aaae8570de..a13c8fb9a3 100644
>>> --- a/target/s390x/kvm/kvm_s390x.h
>>> +++ b/target/s390x/kvm/kvm_s390x.h
>>> @@ -46,5 +46,6 @@ void kvm_s390_crypto_reset(void);
>>>   void kvm_s390_restart_interrupt(S390CPU *cpu);
>>>   void kvm_s390_stop_interrupt(S390CPU *cpu);
>>>   void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info);
>>> +int kvm_s390_topology_set_mtcr(uint64_t attr);
>>>   #endif /* KVM_S390X_H */
>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>> index c73cebfe6f..9f202621d0 100644
>>> --- a/hw/s390x/cpu-topology.c
>>> +++ b/hw/s390x/cpu-topology.c
>>> @@ -107,6 +107,17 @@ static void s390_topology_realize(DeviceState *dev, Error **errp)
>>>       qemu_mutex_init(&topo->topo_mutex);
>>>   }
>>> +/**
>>> + * s390_topology_reset:
>>> + * @dev: the device
>>> + *
>>> + * Calls the sysemu topology reset
>>> + */
>>> +static void s390_topology_reset(DeviceState *dev)
>>> +{
>>> +    s390_cpu_topology_reset();
>>> +}
>>> +
>>>   /**
>>>    * topology_class_init:
>>>    * @oc: Object class
>>> @@ -120,6 +131,7 @@ static void topology_class_init(ObjectClass *oc, void *data)
>>>       dc->realize = s390_topology_realize;
>>>       set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>>> +    dc->reset = s390_topology_reset;
>>>   }
>>>   static const TypeInfo cpu_topology_info = {
>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>> index aa99a62e42..362378454a 100644
>>> --- a/hw/s390x/s390-virtio-ccw.c
>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>> @@ -113,6 +113,7 @@ static const char *const reset_dev_types[] = {
>>>       "s390-flic",
>>>       "diag288",
>>>       TYPE_S390_PCI_HOST_BRIDGE,
>>> +    TYPE_S390_CPU_TOPOLOGY,
>>>   };
>>>   static void subsystem_reset(void)
>>> diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
>>> index 948e4bd3e0..707c0b658c 100644
>>> --- a/target/s390x/cpu-sysemu.c
>>> +++ b/target/s390x/cpu-sysemu.c
>>> @@ -306,3 +306,10 @@ void s390_do_cpu_set_diag318(CPUState *cs, run_on_cpu_data arg)
>>>           kvm_s390_set_diag318(cs, arg.host_ulong);
>>>       }
>>>   }
>>> +
>>> +void s390_cpu_topology_reset(void)
>>> +{
>>> +    if (kvm_enabled()) {
>>> +        kvm_s390_topology_set_mtcr(0);
>>> +    }
>>> +}
>>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>>> index f96630440b..9c994d27d5 100644
>>> --- a/target/s390x/kvm/kvm.c
>>> +++ b/target/s390x/kvm/kvm.c
>>> @@ -2585,3 +2585,26 @@ int kvm_s390_get_zpci_op(void)
>>>   {
>>>       return cap_zpci_op;
>>>   }
>>> +
>>> +int kvm_s390_topology_set_mtcr(uint64_t attr)
>>> +{
>>> +    struct kvm_device_attr attribute = {
>>> +        .group = KVM_S390_VM_CPU_TOPOLOGY,
>>> +        .attr  = attr,
>>> +    };
>>> +    int ret;
>>> +
>>> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>>> +        return -EFAULT;
>>
>> EFAULT is something that indicates a bad address (e.g. a segmentation fault) ... so this definitely sounds like a bad choice for an error code here.
> 
> Hum, yes, ENODEV seems besser no?

-ENOTSUP would be 'meilleur' may be ?  :)

C.


> 
>>
>>   Thomas
>>
>>
> 

