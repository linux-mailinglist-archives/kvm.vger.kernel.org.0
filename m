Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B287603FB
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 02:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjGYA3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 20:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjGYA27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 20:28:59 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97ABC10EF;
        Mon, 24 Jul 2023 17:28:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxPOtEF79kynoJAA--.18562S3;
        Tue, 25 Jul 2023 08:28:52 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjiM_F79kAfE5AA--.50597S3;
        Tue, 25 Jul 2023 08:28:48 +0800 (CST)
Message-ID: <2fa14ef5-b2f7-459d-8b84-114d36ba3cf7@loongson.cn>
Date:   Tue, 25 Jul 2023 08:28:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Salil Mehta <salil.mehta@opnsrc.net>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        "james.morse@arm.com" <james.morse@arm.com>,
        "steven.price@arm.com" <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
Content-Language: en-US
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxjiM_F79kAfE5AA--.50597S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGrWDCF1DWw4rur18tF1UArc_yoW5Grykpr
        W5GFyF9rZ8KrW0vws2vF15ury3ZrW8Cayaqwn7t34xZan8XF9F9r4aya1YyFyfXF1fW3W2
        qF4avryfCFs8XFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUd529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
        kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
        XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
        k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l
        4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
        42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is vcpu hotplug supported in arm virt-machine now?

There is arm64 vcpu hotplug patch in qemu mailing list, however it is not merged.
I do not know why it is not merged. I ask this question because we propose
similar patch about LoongArch system in qemu mailing list, and kernel need not be
modified for vcpu hotplug.

Regards
Bibo, mao

在 2023/7/19 10:35, Salil Mehta 写道:
> [Reposting it here from Linaro Open Discussion List for more eyes to look at]
> 
> Hello,
> I have recently started to dabble with ARM CCA stuff and check if our
> recent changes to support vCPU Hotplug in ARM64 can work in the realm
> world. I have realized that in the RMM specification[1] PSCI_CPU_ON
> command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
> from the host. This might be required to support vCPU Hotplug feature
> in the realm world in future. vCPU Hotplug is an important feature to
> support kata-containers in realm world as it reduces the VM boot time
> and facilitates dynamic adjustment of vCPUs (which I think should be
> true even with Realm world as current implementation only makes use
> of the PSCI_ON/OFF to realize the Hotplug look-like effect?)
> 
> 
> As per our recent changes [2], [3] related to support vCPU Hotplug on
> ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
> user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
> PSCI_CPU_ON should undergo similar policy checks and I think,
> 
> 1. Host should *deny* to online the target vCPUs which are NOT plugged
> 2. This means target REC should be denied by host. Can host call
>    RMI_PSCI_COMPETE in such s case? 
> 3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
> 4. Failure condition (B5.3.3.2) should be amended with
>    runnable pre: target_rec.flags.runnable == NOT_RUNNABLE (?)
>             post: result == PSCI_DENIED (?)
> 5. Change would also be required in the flow (D1.4 PSCI flows) depicting 
>    PSCI_CPU_ON flow (D1.4.1)
>   
> 
> I do understand that ARM CCA support is in its infancy stage and
> discussing about vCPU Hotplug in realm world seem to be a far-fetched
> idea right now. But specification changes require lot of time and if
> this change is really required then it should be further discussed
> within ARM. 
> 
> Many thanks!
> 
> 
> Bes regards
> Salil
> 
> 
> References:
> 
> [1] https://developer.arm.com/documentation/den0137/latest/
> [2] https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
> [3] https://git.gitlab.arm.com/linux-arm/linux-jm.git virtual_cpu_hotplug/rfc/v2

