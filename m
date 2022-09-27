Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A82E5EBF32
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 12:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiI0KEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 06:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiI0KEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 06:04:09 -0400
X-Greylist: delayed 583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Sep 2022 03:04:08 PDT
Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B729751C
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 03:04:08 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.214])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 4E01912C5AA11;
        Tue, 27 Sep 2022 11:44:56 +0200 (CEST)
Received: from kaod.org (37.59.142.105) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 27 Sep
 2022 11:44:54 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-105G00683c076b6-2ca7-40aa-a930-f03bf132be68,
                    12A65CACE92C1DACCE6E97948814F03D28E096F2) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <0d3fd34e-d060-c72e-ee19-e9054e06832a@kaod.org>
Date:   Tue, 27 Sep 2022 11:44:54 +0200
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
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.105]
X-ClientProxiedBy: DAG1EX1.mxp5.local (172.16.2.1) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: c412c6eb-ac12-4b22-a287-0a08348e524f
X-Ovh-Tracer-Id: 14274159021011471117
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeggedgudelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeekteejtdelkeejvdevffduhfetteelieefgeefffeugffhfeekheffueefledujeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopehfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdfovfetjfhoshhtpehmohehvdel
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/5/22 17:10, Pierre Morel wrote:
> 
> 
> On 9/5/22 13:32, Nico Boehr wrote:
>> Quoting Pierre Morel (2022-09-02 09:55:22)
>>> S390x do not support multithreading in the guest.
>>> Do not let admin falsely specify multithreading on QEMU
>>> smp commandline.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   hw/s390x/s390-virtio-ccw.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>> index 70229b102b..b5ca154e2f 100644
>>> --- a/hw/s390x/s390-virtio-ccw.c
>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>>>       MachineClass *mc = MACHINE_GET_CLASS(machine);
>>>       int i;
>>> +    /* Explicitely do not support threads */
>>            ^
>>            Explicitly
>>
>>> +    assert(machine->smp.threads == 1);
>>
>> It might be nicer to give a better error message to the user.
>> What do you think about something like (broken whitespace ahead):
>>
>>      if (machine->smp.threads != 1) {if (machine->smp.threads != 1) {
>>          error_setg(&error_fatal, "More than one thread specified, but multithreading unsupported");
>>          return;
>>      }
>>
> 
> 
> OK, I think I wanted to do this and I changed my mind, obviously, I do not recall why.
> I will do almost the same but after a look at error.h I will use error_report()/exit() instead of error_setg()/return as in:
> 
> 
> +    /* Explicitly do not support threads */
> +    if (machine->smp.threads != 1) {
> +        error_report("More than one thread specified, but multithreading unsupported");
> +        exit(1);
> +    }


or add an 'Error **errp' parameter to s390_init_cpus() and use error_setg()
as initially proposed. s390x_new_cpu() would benefit from it also.

Thanks,

C.


> 
> 
> Thanks,
> 
> Regards,
> Pierre
> 

