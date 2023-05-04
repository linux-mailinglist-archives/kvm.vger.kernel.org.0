Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD946F6309
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 04:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjEDCyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEDCym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 22:54:42 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA98BE68
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 19:54:40 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxNPBvHlNk3GEEAA--.7134S3;
        Thu, 04 May 2023 10:54:39 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx4zhsHlNkoSZJAA--.4479S3;
        Thu, 04 May 2023 10:54:37 +0800 (CST)
Subject: Re: [PATCH RFC v2 3/9] target/loongarch: Supplement vcpu env initial
 when vcpu reset
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-4-zhaotianrui@loongson.cn>
 <cccd2658-26fa-ca9f-68f7-9704eb095c99@linaro.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <839d9f65-721c-0ca1-a458-0d84d9198533@loongson.cn>
Date:   Thu, 4 May 2023 10:54:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <cccd2658-26fa-ca9f-68f7-9704eb095c99@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx4zhsHlNkoSZJAA--.4479S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvdXoW7XrWrGr45JryxKw1DZF48Crg_yoWfArb_Ga
        1fZrn7Gw47W3ZFkw12qrWrt3WYgF1kAFyF9F47tF4fCryqqan7Gwn0gwn7Zw129FW8GF1v
        yr1vyrnIkr1qyjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY
        x7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7
        xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS
        0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0V
        AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42
        xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
        GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
        8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4U
        MIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
        8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年05月02日 19:04, Richard Henderson 写道:
> On 4/27/23 08:26, Tianrui Zhao wrote:
>> Supplement vcpu env initial when vcpu reset, including
>> init vcpu mp_state value to KVM_MP_STATE_RUNNABLE and
>> init vcpu CSR_CPUID,CSR_TID to cpu->cpu_index.
>>
>> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
>> ---
>>   target/loongarch/cpu.c | 3 +++
>>   target/loongarch/cpu.h | 2 ++
>>   2 files changed, 5 insertions(+)
>
> Why do you need KVM_MP_STATE_RUNNABLE in loongarch/cpu.c, outside of 
> kvm.c?
> For Arm, we test the architectural power state of the cpu.
>
>
> r~
Thanks for your reviewing, we want to set mp_state to default value when 
vcpu reset, so we add it in cpu.c. When I reference other archs, I think 
I should add a new function named kvm_arch_reset_vcpu in kvm.c which 
will be called by vcpu_reset and move the reset mp_state into it.

Thanks
Tianrui Zhao

