Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF206E9244
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 13:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbjDTLTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 07:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbjDTLSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 07:18:55 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CFE1BBB2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 04:15:40 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxJFw+HkFkuXsfAA--.49016S3;
        Thu, 20 Apr 2023 19:13:02 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfbM9HkFkXQ0xAA--.909S3;
        Thu, 20 Apr 2023 19:13:01 +0800 (CST)
Subject: Re: [PATCH RFC v1 09/10] target/loongarch: Add kvm-stub.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-10-zhaotianrui@loongson.cn>
 <a315b56d-a331-5e85-ff55-4dca96088bb9@linaro.org>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <e1869f8c-0aaa-1125-31b3-21fe43009fb3@loongson.cn>
Date:   Thu, 20 Apr 2023 19:13:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <a315b56d-a331-5e85-ff55-4dca96088bb9@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxfbM9HkFkXQ0xAA--.909S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7urWxKF4kCw47XFyrJw48Xrb_yoW8ur45pF
        Z7uFs8Kr4xJrZrJ3WrZ3y5XF1DZrWSgr12va4aq34xCr4UXr18Xryvg39xWFW5C348Gr10
        vryFkw1YqF18J37anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E
        0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82
        IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
        0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
        IF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF
        0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z2
        80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8vD73UUUUU==
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月20日 18:04, Philippe Mathieu-Daudé 写道:
> On 20/4/23 11:36, Tianrui Zhao wrote:
>> Add kvm-stub.c for loongarch, there are two stub functions:
>> kvm_loongarch_reset_vcpu and kvm_loongarch_set_interrupt.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   target/loongarch/kvm-stub.c      | 17 +++++++++++++++++
>>   target/loongarch/kvm_loongarch.h |  1 +
>>   2 files changed, 18 insertions(+)
>>   create mode 100644 target/loongarch/kvm-stub.c
>>
>> diff --git a/target/loongarch/kvm-stub.c b/target/loongarch/kvm-stub.c
>> new file mode 100644
>> index 0000000000..e28827ee07
>> --- /dev/null
>> +++ b/target/loongarch/kvm-stub.c
>> @@ -0,0 +1,17 @@
>> +/*
>> + * QEMU KVM LoongArch specific function stubs
>> + *
>> + * Copyright (c) 2023 Loongson Technology Corporation Limited
>> + */
>> +#include "qemu/osdep.h"
>> +#include "cpu.h"
>> +
>> +void kvm_loongarch_reset_vcpu(LoongArchCPU *cpu)
>
> Where is kvm_loongarch_reset_vcpu() called?
Thanks and nowhere called this function, I will remove it.

Thanks
Tianrui Zhao
>
>> +{
>> +    abort();
>> +}
>> +
>> +void kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level)
>> +{
>> +    abort();
>
> Please use g_assert_not_reached() which display more useful informations.
Thanks, I will use the g_assert_not_reached() to replace it.

Thanks
Tianrui Zhao
>
>> +}
>
> Add this stub in the previous patch "Implement set vcpu intr for kvm".
Thanks, I will move this stub function into previous patch "Implement 
set vcpu intr for kvm".

Thanks
Tianrui Zhao
>
>> diff --git a/target/loongarch/kvm_loongarch.h 
>> b/target/loongarch/kvm_loongarch.h
>> index cdef980eec..c03f4bef0f 100644
>> --- a/target/loongarch/kvm_loongarch.h
>> +++ b/target/loongarch/kvm_loongarch.h
>> @@ -8,6 +8,7 @@
>>   #ifndef QEMU_KVM_LOONGARCH_H
>>   #define QEMU_KVM_LOONGARCH_H
>>   +void kvm_loongarch_reset_vcpu(LoongArchCPU *cpu);
>>   int  kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int 
>> level);
>>     #endif

