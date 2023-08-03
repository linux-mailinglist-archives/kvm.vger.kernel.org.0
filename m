Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6921876DF07
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjHCDam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjHCDaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:30:39 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 387FEC3;
        Wed,  2 Aug 2023 20:30:37 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8CxyOhbH8tkH3EPAA--.87S3;
        Thu, 03 Aug 2023 11:30:35 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfSNaH8tkaZdGAA--.3392S3;
        Thu, 03 Aug 2023 11:30:35 +0800 (CST)
Subject: Re: [PATCH v1 1/4] selftests: kvm: Add kvm selftests header files for
 LoongArch
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
 <20230801020206.1957986-2-zhaotianrui@loongson.cn>
 <ZMqL7qPyngxOH4Y0@google.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <06a4e9f0-483c-e79c-fc64-7e9e0ce7348d@loongson.cn>
Date:   Thu, 3 Aug 2023 11:30:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ZMqL7qPyngxOH4Y0@google.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8DxfSNaH8tkaZdGAA--.3392S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr47uw1UZryfXryfXrykXrc_yoWrWw4xp3
        WkA3WFkF48GF17C34S9an3XryfGws7KF48KrySqryUCwnIq3s7Jr1xKF45ZFy3X395t345
        Z3Z2g34Y9Fy3XagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
        02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
        wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
        CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
        67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
        IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
        14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
        W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7XTm
        DUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2023/8/3 ÉÏÎç1:01, Sean Christopherson Ð´µÀ:
> On Tue, Aug 01, 2023, Tianrui Zhao wrote:
>> Add kvm selftests header files for LoongArch, including processor.h,
>> sysreg.h, and kvm_util_base.h. Those mainly contain LoongArch CSR
>> register defines and page table information.
>>
>> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   .../selftests/kvm/include/kvm_util_base.h     |  5 ++
>>   .../kvm/include/loongarch/processor.h         | 28 ++++++
>>   .../selftests/kvm/include/loongarch/sysreg.h  | 89 +++++++++++++++++++
>>   3 files changed, 122 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h
>>   create mode 100644 tools/testing/selftests/kvm/include/loongarch/sysreg.h
>>
>> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
>> index 07732a157ccd..8747127e0bab 100644
>> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
>> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
>> @@ -197,6 +197,11 @@ extern enum vm_guest_mode vm_mode_default;
>>   #define MIN_PAGE_SHIFT			12U
>>   #define ptes_per_page(page_size)	((page_size) / 8)
>>   
>> +#elif defined(__loongarch__)
>> +#define VM_MODE_DEFAULT			VM_MODE_P36V47_16K
>> +#define MIN_PAGE_SHIFT			14U
>> +#define ptes_per_page(page_size)	((page_size) / 8)
>> +
>>   #endif
>>   
>>   #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
>> diff --git a/tools/testing/selftests/kvm/include/loongarch/processor.h b/tools/testing/selftests/kvm/include/loongarch/processor.h
>> new file mode 100644
>> index 000000000000..d67796af51a0
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/loongarch/processor.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * LoongArch processor specific defines
> Nit, my preference is to not bother with these types of comments, it should be
> quite obvious from the file name that that everything in here is LoongArch
> specific.
Thanks, I will simplify this comment.
>
>> + */
>> +#ifndef SELFTEST_KVM_PROCESSOR_H
>> +#define SELFTEST_KVM_PROCESSOR_H
>> +
>> +#include <linux/compiler.h>
>> +#define _PAGE_VALID_SHIFT	0
>> +#define _PAGE_DIRTY_SHIFT	1
>> +#define _PAGE_PLV_SHIFT		2  /* 2~3, two bits */
>> +#define _CACHE_SHIFT		4  /* 4~5, two bits */
>> +#define _PAGE_PRESENT_SHIFT	7
>> +#define _PAGE_WRITE_SHIFT	8
>> +
>> +#define PLV_KERN		0
>> +#define PLV_USER		3
>> +#define PLV_MASK		0x3
>> +
>> +#define _PAGE_VALID		(0x1UL << _PAGE_VALID_SHIFT)
>> +#define _PAGE_PRESENT		(0x1UL << _PAGE_PRESENT_SHIFT)
>> +#define _PAGE_WRITE		(0x1UL << _PAGE_WRITE_SHIFT)
>> +#define _PAGE_DIRTY		(0x1UL << _PAGE_DIRTY_SHIFT)
>> +#define _PAGE_USER		(PLV_USER << _PAGE_PLV_SHIFT)
>> +#define __READABLE		(_PAGE_VALID)
>> +#define __WRITEABLE		(_PAGE_DIRTY | _PAGE_WRITE)
>> +#define _CACHE_CC		(0x1UL << _CACHE_SHIFT) /* Coherent Cached */
>> +#endif
>> diff --git a/tools/testing/selftests/kvm/include/loongarch/sysreg.h b/tools/testing/selftests/kvm/include/loongarch/sysreg.h
>> new file mode 100644
>> index 000000000000..04f53674c9d8
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/include/loongarch/sysreg.h
> Any reason these can't simply go in processor.h?  Neither file is particular large,
> especially for CPU definition files.
Thanks, I will move the contents of sysreg.h into processor.h to make 
the file easier.
>
>> @@ -0,0 +1,89 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef SELFTEST_KVM_SYSREG_H
>> +#define SELFTEST_KVM_SYSREG_H
>> +
>> +/*
>> + * note that this declaration raises a checkpatch warning, but
>> + * no good way to avoid it.
>> + */
> Definitely drop this comment, once the patch is applied the fact that checkpatch
> complains is irrelevant.
Ok, I will drop this comment.

Thanks
Tianrui Zhao
>
>> +#define zero	$r0

