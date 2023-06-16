Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237A0732565
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjFPCup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjFPCuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:50:44 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75F1D294A;
        Thu, 15 Jun 2023 19:50:42 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8AxHusAzotkFc4FAA--.12391S3;
        Fri, 16 Jun 2023 10:50:40 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxluT+zYtkSMgcAA--.16273S3;
        Fri, 16 Jun 2023 10:50:38 +0800 (CST)
Subject: Re: [PATCH v13 30/30] LoongArch: KVM: Add maintainers for LoongArch
 KVM
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230609090518.2130926-1-zhaotianrui@loongson.cn>
 <20230609090518.2130926-31-zhaotianrui@loongson.cn>
 <CAAhV-H6ddLNgMocmE7UtpLmrqsCUYYbwxqhFJ6OOGCUCLTXAhg@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <7306f3a7-42c3-1e9b-8515-7e7613b60f4f@loongson.cn>
Date:   Fri, 16 Jun 2023 10:50:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6ddLNgMocmE7UtpLmrqsCUYYbwxqhFJ6OOGCUCLTXAhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8DxluT+zYtkSMgcAA--.16273S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7AFWrtw48CF4rJryfJw1UurX_yoW8XFW5pF
        4kAF4kCFs7Gr4xAwsrKasI9a43XrykCr12qasxK348Zr1DWw1kXrWUt3Z09FZ0qasYgF40
        vwn3Kw129F4UXrXCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4BHqDU
        UUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/6/15 下午5:27, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Fri, Jun 9, 2023 at 5:06 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Add maintainers for LoongArch KVM.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   MAINTAINERS | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 27ef11624748..c2fbfd6ad4e5 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -11357,6 +11357,18 @@ F:     include/kvm/arm_*
>>   F:     tools/testing/selftests/kvm/*/aarch64/
>>   F:     tools/testing/selftests/kvm/aarch64/
>>
>> +KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
>> +M:     Tianrui Zhao <zhaotianrui@loongson.cn>
>> +M:     Bibo Mao <maobibo@loongson.cn>
>> +M:     Huacai Chen <chenhuacai@kernel.org>
>> +L:     kvm@vger.kernel.org
>> +L:     loongarch@lists.linux.dev
>> +S:     Maintained
>> +T:     git https://github.com/loongson/linux-loongarch-kvm
> I'm not sure, but I think this should be a tree which can be used to
> send PR for upstream maintainers. If no other selection, we should use
> git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>
> Huacai

Thanks, I will use this kvm source link.

Tianrui Zhao

>> +F:     arch/loongarch/include/asm/kvm*
>> +F:     arch/loongarch/include/uapi/asm/kvm*
>> +F:     arch/loongarch/kvm/
>> +
>>   KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>>   M:     Huacai Chen <chenhuacai@kernel.org>
>>   M:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>> --
>> 2.39.1
>>
>>

