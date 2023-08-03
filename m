Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8AD76E044
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 08:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbjHCGcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 02:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjHCGcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 02:32:13 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFBE610FB;
        Wed,  2 Aug 2023 23:32:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8AxjuvoSctkMYUPAA--.33761S3;
        Thu, 03 Aug 2023 14:32:08 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxPCPjSctk0MRGAA--.33140S3;
        Thu, 03 Aug 2023 14:32:05 +0800 (CST)
Subject: Re: [PATCH v1 2/4] selftests: kvm: Add processor tests for LoongArch
 KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn>
 <20230801020206.1957986-3-zhaotianrui@loongson.cn>
 <ZMqba0j82Di+P+LI@google.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <d9939cb6-c193-26e3-4717-17e9f6640e24@loongson.cn>
Date:   Thu, 3 Aug 2023 14:32:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ZMqba0j82Di+P+LI@google.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8DxPCPjSctk0MRGAA--.33140S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gr1UWr48Ar1Uuw13Jw17twc_yoWxKw45pF
        yxCFn3WF4xJr1xJ3srXwn8ZF1ftrsakryjyry3KFyjvrsFv34fJ348KFZxWFy3uwsY9w4F
        v3WYqa13ZF45t3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
        67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
        AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
        F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
        ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
        xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
        4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5
        WrAUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2023/8/3 ÉÏÎç2:07, Sean Christopherson Ð´µÀ:
> On Tue, Aug 01, 2023, Tianrui Zhao wrote:
>> Add processor tests for LoongArch KVM, including vcpu initialize
> Nit, AFAICT these aren't tests, this is simply the core KVM selftests support
> for LoongArch.
Thanks, I will fix this comment.
>
>> and tlb refill exception handler.
>>
>> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
>>   .../selftests/kvm/lib/loongarch/processor.c   | 367 ++++++++++++++++++
>>   2 files changed, 394 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
>>
>> diff --git a/tools/testing/selftests/kvm/lib/loongarch/exception.S b/tools/testing/selftests/kvm/lib/loongarch/exception.S
>> new file mode 100644
>> index 000000000000..19dc50993da4
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/loongarch/exception.S
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#include "sysreg.h"
>> +
>> +/* address of refill exception should be 4K aligned */
>> +.align  12
> .align works on bytes, not on shifts.  I.e. this will make handle_tlb_refill
> 12-byte aligned, not 4096-byte aligned.
Thanks, I will fix it to .balign 4096.
>
>> +.global handle_tlb_refill
>> +handle_tlb_refill:
>> +	csrwr	t0, LOONGARCH_CSR_TLBRSAVE
>> +	csrrd	t0, LOONGARCH_CSR_PGD
>> +	lddir	t0, t0, 3
>> +	lddir	t0, t0, 1
>> +	ldpte	t0, 0
>> +	ldpte	t0, 1
>> +	tlbfill
>> +	csrrd	t0, LOONGARCH_CSR_TLBRSAVE
>> +	ertn
>> +
>> +/* address of general exception should be 4K aligned */
>> +.align  12
> Same thing here.
I will fix it too.
>
>> +.global handle_exception
>> +handle_exception:
>> +1:
>> +	nop
>> +	b	1b
>> +	nop
>> +	ertn
>> diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
>> new file mode 100644
>> index 000000000000..2e50b6e2c556
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
>> @@ -0,0 +1,367 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * KVM selftest LoongArch library code, including CPU-related functions.
>> + *
> Again, unnecessary IMO.  If you do keep the comment, the extra line with a bare
> asterisk should be dropped.
Thanks, I will remove this comment.
>
>> + */
>> +
>> +#include <assert.h>
>> +#include <linux/bitfield.h>
>> +#include <linux/compiler.h>
>> +
>> +#include "kvm_util.h"
>> +#include "processor.h"
>> +#include "sysreg.h"
>> +
>> +#define DEFAULT_LOONGARCH_GUEST_STACK_VADDR_MIN		0xac0000
> Why diverge from the common?
>
> 	#define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
>
> AFAIK, the common value is also mostly arbitrary, but that just makes it even
> more confusing as to why LoongArch needs to bump the min by 0x4000.
This is reference from ARM, and I will fix it to use the the common value.
>
>> +uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
>> +{
>> +	uint64_t *ptep;
>> +
>> +	if (!vm->pgd_created)
>> +		goto unmapped_gva;
>> +
>> +	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
>> +	if (!ptep)
>> +		goto unmapped_gva;
>> +
>> +	switch (vm->pgtable_levels) {
>> +	case 4:
>> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
>> +		if (!ptep)
>> +			goto unmapped_gva;
> This wants a "fallthrough" annotation.
Thanks, I will add the "fallthrough" annotation.
>
>> +	case 3:
>> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
>> +		if (!ptep)
>> +			goto unmapped_gva;
>> +	case 2:
>> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
>> +		if (!ptep)
>> +			goto unmapped_gva;
>> +		break;
>> +	default:
>> +		TEST_FAIL("Page table levels must be 2, 3, or 4");
> Obviously it shouldn't come up, but print the actual pgtable_levels to make debug
> a wee bit easier e.g.
> 		TEST_FAIL("Got %u page table levels, expected 2, 3, or 4",
> 			  vm->pgtable_levels);
Thanks, I will also print the actual pgtable_levels in this debug function.
>
> Mostly out of curiosity, but also because it looks like this was heavily copy+pasted
> from ARM: does LoongArch actually support 2-level page tables?
Yes, this codes are mostly copy pasted from ARM, but LoongArch does not 
support 2-levels page tables, it only support 3-level and 4-level page 
tables, and I will fix it.
>> +static void loongarch_set_csr(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
>> +{
>> +	uint64_t csrid;
>> +
>> +	csrid = KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | 8 * id;
>> +	vcpu_set_reg(vcpu, csrid, val);
>> +}
>> +
>> +static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long val;
>> +	int width;
>> +	struct kvm_vm *vm = vcpu->vm;
>> +
>> +	switch (vm->mode) {
>> +	case VM_MODE_P48V48_16K:
>> +	case VM_MODE_P40V48_16K:
>> +	case VM_MODE_P36V48_16K:
>> +	case VM_MODE_P36V47_16K:
>> +		break;
>> +
>> +	default:
>> +		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
>> +	}
>> +
>> +	/* user mode and page enable mode */
>> +	val = PLV_USER | CSR_CRMD_PG;
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_CRMD, val);
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PRMD, val);
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_EUEN, 1);
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_ECFG, 0);
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TCFG, 0);
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_ASID, 1);
>> +
>> +	width = vm->page_shift - 3;
>> +	val = 0;
>> +	switch (vm->pgtable_levels) {
>> +	case 4:
>> +		/* pud page shift and width */
>> +		val = (vm->page_shift + width * 2) << 20 | (width << 25);
>> +	case 3:
>> +		/* pmd page shift and width */
>> +		val |= (vm->page_shift + width) << 10 | (width << 15);
>> +	case 2:
>> +		/* pte page shift and width */
>> +		val |= vm->page_shift | width << 5;
>> +		break;
>> +	default:
>> +		TEST_FAIL("Page table levels must be 2, 3, or 4");
>> +	}
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
>> +
>> +	/* pgd page shift and width */
>> +	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
>> +
>> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
>> +
>> +	extern void handle_tlb_refill(void);
>> +	extern void handle_exception(void);
> Eww.  I get that it's probably undesirable to expose these via processor.h, but
> at least declare them outside of the function.
Thanks, I will declare them outside of the function.
>
>> +struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
>> +				  void *guest_code)
>> +{
>> +	return loongarch_vcpu_add(vm, vcpu_id, guest_code);
> Please drop the single-line passthrough, i.e. drop loongarch_vcpu_add().  I'm
> guessing you copy+pasted much of this from ARM.  ARM's passthrough isn't a pure
> passthrough, which is directly related to why the "passthrough" is ok: there are
> other callers to aarch64_vcpu_add() that pass a non-NULL @source.
Yes, this is also copy pasted from ARM, and I will drop the 
loongarch_vcpu_add() function and move the content of it to here.

