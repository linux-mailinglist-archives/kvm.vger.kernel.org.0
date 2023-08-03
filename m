Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FFE76E06A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 08:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjHCGmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 02:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjHCGmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 02:42:31 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C76DCC;
        Wed,  2 Aug 2023 23:42:28 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8DxRvFSTMtkf4YPAA--.36154S3;
        Thu, 03 Aug 2023 14:42:26 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c5QTMtkr8dGAA--.51824S3;
        Thu, 03 Aug 2023 14:42:26 +0800 (CST)
Subject: Re: [PATCH v1 3/4] selftests: kvm: Add ucall tests for LoongArch KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
 <20230801020206.1957986-4-zhaotianrui@loongson.cn>
 <ZMqbqwuCdI2XpJ9q@google.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <a3800117-ff95-141c-fe94-9d910f4710dc@loongson.cn>
Date:   Thu, 3 Aug 2023 14:42:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ZMqbqwuCdI2XpJ9q@google.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8Cx_c5QTMtkr8dGAA--.51824S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7AF13KFy7Cr4rCryrJry7Arc_yoW8tw15pa
        s5Ca1UKF4Sgw17AwnxXr1jq3Wftr93tF1UZFyaq3yS9wsIvF1fJr1fKFy29FyavF1Ygr4r
        ZFn2gFnxCF1Yk3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
        67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
        F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
        ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
        4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jO
        db8UUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2023/8/3 ÉÏÎç2:08, Sean Christopherson Ð´µÀ:
> On Tue, Aug 01, 2023, Tianrui Zhao wrote:
>> Add ucall tests for LoongArch KVM, it means that VM use hypercall
> s/tests/support
Thanks, I will fix this comment.
>
>> to return to userspace and handle the mmio exception.
>>
>> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   .../selftests/kvm/lib/loongarch/ucall.c       | 44 +++++++++++++++++++
>>   1 file changed, 44 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c
>>
>> diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
>> new file mode 100644
>> index 000000000000..b32f7c7f6548
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * ucall support. A ucall is a "hypercall to userspace".
>> + *
>> + */
>> +#include "kvm_util.h"
>> +
>> +/*
>> + * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
>> + * VM), it must not be accessed from host code.
>> + */
>> +static vm_vaddr_t *ucall_exit_mmio_addr;
>> +
>> +void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
>> +{
>> +	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
>> +
>> +	virt_map(vm, mmio_gva, mmio_gpa, 1);
>> +
>> +	vm->ucall_mmio_addr = mmio_gpa;
>> +
>> +	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
>> +}
>> +
>> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>> +{
>> +
> Extra newline.
Thanks, I will remove this line.

Thanks
Tianrui Zhao
>
>> +	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
>> +}
>> +
>> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_run *run = vcpu->run;
>> +
>> +	if (run->exit_reason == KVM_EXIT_MMIO &&
>> +	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
>> +		TEST_ASSERT(run->mmio.is_write && run->mmio.len == sizeof(uint64_t),
>> +			    "Unexpected ucall exit mmio address access");
>> +
>> +		return (void *)(*((uint64_t *)run->mmio.data));
>> +	}
>> +
>> +	return NULL;
>> +}
>> -- 
>> 2.39.1
>>

