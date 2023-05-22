Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88AE70B61A
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjEVHPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjEVHOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:14:34 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CB74121;
        Mon, 22 May 2023 00:14:28 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.111])
        by gateway (Coremail) with SMTP id _____8DxyOlTFmtkuNgKAA--.18829S3;
        Mon, 22 May 2023 15:14:27 +0800 (CST)
Received: from [192.168.124.115] (unknown [10.20.42.111])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx4zhQFmtkksVuAA--.54591S3;
        Mon, 22 May 2023 15:14:24 +0800 (CST)
Subject: Re: [PATCH v11 31/31] LoongArch: KVM: Add maintainers for LoongArch
 KVM
To:     WANG Xuerui <kernel@xen0n.name>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230522031217.956464-1-zhaotianrui@loongson.cn>
 <20230522031217.956464-32-zhaotianrui@loongson.cn>
 <fb7f0c26-b609-c225-f8db-de32e72cd97b@xen0n.name>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <f6b4bd12-ac04-bb1a-f3ce-657fc8802f8f@loongson.cn>
Date:   Mon, 22 May 2023 15:14:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fb7f0c26-b609-c225-f8db-de32e72cd97b@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Cx4zhQFmtkksVuAA--.54591S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tF1xJF15ZF4DZF47Wr1xXwb_yoW8Xry8pF
        s7AF4DKrWxWr1xArn5tF9xZa45XrykCr12qay3X3WqvFnxJw10qryqg3Z0gFn8Xan5Wr4F
        vrn3tw13uF1UJrJanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280
        aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2
        xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/5/22 上午11:42, WANG Xuerui wrote:
> On 2023/5/22 11:12, Tianrui Zhao wrote:
>> Add maintainers for LoongArch KVM.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   MAINTAINERS | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 27ef11624748..0b6fe590f275 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -11357,6 +11357,18 @@ F:    include/kvm/arm_*
>>   F:    tools/testing/selftests/kvm/*/aarch64/
>>   F:    tools/testing/selftests/kvm/aarch64/
>>   +KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
>> +M:    Tianrui Zhao <zhaotianrui@loongson.com>
>> +M:    Bibo Mao <maobibo@loongson.com>
>
> Your company email addresses end with loongson.cn, aren't they? ;-)

Thanks for your reviewing carefully, I will fix this e-mail address.

Tianrui Zhao

>
>> +M:    Huacai Chen <chenhuacai@kernel.org>
>> +L:    kvm@vger.kernel.org
>> +L:    loongarch@lists.linux.dev
>> +S:    Maintained
>> +T:    git https://github.com/loongson/linux-loongarch-kvm
>> +F:    arch/loongarch/include/asm/kvm*
>> +F:    arch/loongarch/include/uapi/asm/kvm*
>> +F:    arch/loongarch/kvm/
>> +
>>   KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>>   M:    Huacai Chen <chenhuacai@kernel.org>
>>   M:    Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>

