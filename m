Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA835EE1CF
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiI1Q2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiI1Q23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:28:29 -0400
X-Greylist: delayed 110609 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 09:28:27 PDT
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92C9B14FF
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:28:27 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.235])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 9C2B412CD28E9;
        Wed, 28 Sep 2022 18:28:24 +0200 (CEST)
Received: from kaod.org (37.59.142.99) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Wed, 28 Sep
 2022 18:28:23 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-99G00349c75544-118b-41af-a7ed-004146c99ceb,
                    C75DA7A61898C88B8DB19AE4E08673D8991D436D) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <3becce0a-1b7a-385a-4180-f68cf192595a@kaod.org>
Date:   Wed, 28 Sep 2022 18:28:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <frankja@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
 <166237756810.5995.16085197397341513582@t14-nrb>
 <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
 <0d3fd34e-d060-c72e-ee19-e9054e06832a@kaod.org>
 <724d962a-c11b-c18d-f67f-9010eb2f32e2@linux.ibm.com>
 <dff1744f-3242-af11-6b4b-02037a7e2af5@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <dff1744f-3242-af11-6b4b-02037a7e2af5@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: d302ef6c-085e-4171-ba0f-e0dae8a43de5
X-Ovh-Tracer-Id: 8514055098936494861
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegkedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepkeetjedtleekjedvveffudfhteetleeifeegfeffuefghfefkeehffeufeeludejnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopehfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdfovfetjfhoshhtpehmohehvdel
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/22 18:16, Pierre Morel wrote:
> More thinking about this I will drop this patch for backward compatibility and in topology masks treat CPUs as being cores*threads

yes. You never know, people might have set threads=2 in their
domain file (like me). You could give the user a warning though,
with warn_report().

Thanks,

C.

  
> 
> 
> 
> On 9/28/22 15:21, Pierre Morel wrote:
>>
>>
>> On 9/27/22 11:44, Cédric Le Goater wrote:
>>> On 9/5/22 17:10, Pierre Morel wrote:
>>>>
>>>>
>>>> On 9/5/22 13:32, Nico Boehr wrote:
>>>>> Quoting Pierre Morel (2022-09-02 09:55:22)
>>>>>> S390x do not support multithreading in the guest.
>>>>>> Do not let admin falsely specify multithreading on QEMU
>>>>>> smp commandline.
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>   hw/s390x/s390-virtio-ccw.c | 3 +++
>>>>>>   1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>>>>> index 70229b102b..b5ca154e2f 100644
>>>>>> --- a/hw/s390x/s390-virtio-ccw.c
>>>>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>>>>> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>>>>>>       MachineClass *mc = MACHINE_GET_CLASS(machine);
>>>>>>       int i;
>>>>>> +    /* Explicitely do not support threads */
>>>>>            ^
>>>>>            Explicitly
>>>>>
>>>>>> +    assert(machine->smp.threads == 1);
>>>>>
>>>>> It might be nicer to give a better error message to the user.
>>>>> What do you think about something like (broken whitespace ahead):
>>>>>
>>>>>      if (machine->smp.threads != 1) {if (machine->smp.threads != 1) {
>>>>>          error_setg(&error_fatal, "More than one thread specified, but multithreading unsupported");
>>>>>          return;
>>>>>      }
>>>>>
>>>>
>>>>
>>>> OK, I think I wanted to do this and I changed my mind, obviously, I do not recall why.
>>>> I will do almost the same but after a look at error.h I will use error_report()/exit() instead of error_setg()/return as in:
>>>>
>>>>
>>>> +    /* Explicitly do not support threads */
>>>> +    if (machine->smp.threads != 1) {
>>>> +        error_report("More than one thread specified, but multithreading unsupported");
>>>> +        exit(1);
>>>> +    }
>>>
>>>
>>> or add an 'Error **errp' parameter to s390_init_cpus() and use error_setg()
>>> as initially proposed. s390x_new_cpu() would benefit from it also.
>>>
>> OK, Thanks,
>>
>> Pierre
>>
> 

