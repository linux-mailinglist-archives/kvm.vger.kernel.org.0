Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D063676DECE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjHCDP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjHCDPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:15:54 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23D562719;
        Wed,  2 Aug 2023 20:15:47 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8BxXeviG8tkGG8PAA--.30739S3;
        Thu, 03 Aug 2023 11:15:46 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxLCPgG8tkAZNGAA--.32394S3;
        Thu, 03 Aug 2023 11:15:44 +0800 (CST)
Subject: Re: [PATCH v1 0/4] selftests: kvm: Add LoongArch support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
 <ZMqLKAWRapQjGgWR@google.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <66eb2e6c-7d16-6fbf-7deb-f6d821b1cd8c@loongson.cn>
Date:   Thu, 3 Aug 2023 11:14:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ZMqLKAWRapQjGgWR@google.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8CxLCPgG8tkAZNGAA--.32394S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7WF1kuw4fGF1Dtw4xCw48AFc_yoW8uw1rpa
        9akF4FkFs7KF1IyF93J397Xr1Fya1kGr42v3WSqryUZw47try8Jr1xKFZ2kFy3u34kWr1F
        vas7KwnxW3WUXagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
        02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
        wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
        CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
        67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
        IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
        14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
        W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1YL9U
        UUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2023/8/3 ÉÏÎç12:58, Sean Christopherson Ð´µÀ:
> Please use "KVM: selftests:" for the scope.  There's no "official" requirement,
> but I've been heavily pushing "KVM: selftests:" and no one has objected or
> suggested an alternative, and I'd really like all of KVM selftests to use a
> consistent scope.
Thanks for your reviewing.
I will replace all the "selftests: kvm:" with "KVM: selftests:".
>
> On Tue, Aug 01, 2023, Tianrui Zhao wrote:
>> This patch series base on the Linux LoongArch KVM patch:
>> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
> Is there an actual dependency?  I ask because I'm shepherding along a series[*]
> that will silently conflict with the ucall support, and in a way with the Makefile
> changes.
Yes, this KVM selftests patch series actually depend on the previous 
LoongArch KVM patches.

Thanks
Tianrui Zhao
>
> If there's no hard dependency, one option would be take this series through
> kvm-x86/selftests (my topic branch for KVM selftests changes) along with the
> guest printf series, e.g. so that we don't end up with a mess in linux-next and/or
> come the 6.6 merge window.
>
> https://lore.kernel.org/all/20230731203026.1192091-1-seanjc@google.com
>
>>   tools/testing/selftests/kvm/Makefile          |  11 +
>>   .../selftests/kvm/include/kvm_util_base.h     |   5 +
>>   .../kvm/include/loongarch/processor.h         |  28 ++
>>   .../selftests/kvm/include/loongarch/sysreg.h  |  89 +++++
>>   .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
>>   .../selftests/kvm/lib/loongarch/processor.c   | 367 ++++++++++++++++++
>>   .../selftests/kvm/lib/loongarch/ucall.c       |  44 +++
>>   7 files changed, 571 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
>>   create mode 100644 tools/testing/selftests/kvm/include/loongarch/sysreg.h
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c
>>
>> -- 
>> 2.39.1
>>

