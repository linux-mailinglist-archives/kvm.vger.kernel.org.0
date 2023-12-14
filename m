Return-Path: <kvm+bounces-4412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BC981252B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F2E2B212AD
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58113ECF;
	Thu, 14 Dec 2023 02:21:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D21AE3;
	Wed, 13 Dec 2023 18:21:16 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxBOubZnpls+QAAA--.1172S3;
	Thu, 14 Dec 2023 10:21:15 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrnOUZnpl5XkDAA--.18609S3;
	Thu, 14 Dec 2023 10:21:10 +0800 (CST)
Subject: Re: [PATCH v5 1/4] KVM: selftests: Add KVM selftests header files for
 LoongArch
To: Sean Christopherson <seanjc@google.com>
Cc: zhaotianrui <zhaotianrui@loongson.cn>, Shuah Khan <shuah@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, Peter Xu <peterx@redhat.com>,
 Vipin Sharma <vipinsh@google.com>, huangpei@loongson.cn
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-2-zhaotianrui@loongson.cn>
 <e40d3884-bf39-8286-627f-e0ce7dacfcbe@loongson.cn>
 <ZXiV1rMrXY0hNgvZ@google.com>
 <023b6f8f-301b-a6d0-448b-09a602ba1141@loongson.cn>
 <06076290-4efb-5d71-74eb-396d325447e0@loongson.cn>
 <ZXpErTHBn6HeQUOp@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4b05a834-9584-0a06-c6c8-ab191eddd5f8@loongson.cn>
Date: Thu, 14 Dec 2023 10:20:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZXpErTHBn6HeQUOp@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrnOUZnpl5XkDAA--.18609S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJw1rAw1xAF45tFyfKw13KFX_yoWrtFyfpF
	W0kF45Kw4kGrsFyws2qw18WF1aga93Z3WUurn8GryDCan0qr1xZr1jkw1Y9a9aqr48AayF
	qF4IqwnrKw15Z3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcpBTUUUUU



On 2023/12/14 上午7:56, Sean Christopherson wrote:
> On Wed, Dec 13, 2023, maobibo wrote:
>>
>> On 2023/12/13 下午3:15, zhaotianrui wrote:
>>>
>>> 在 2023/12/13 上午1:18, Sean Christopherson 写道:
>>>> On Tue, Dec 12, 2023, zhaotianrui wrote:
>>>>> Hi, Sean:
>>>>>
>>>>> I want to change the definition of  DEFAULT_GUEST_TEST_MEM in the common
>>>>> file "memstress.h", like this:
>>>>>
>>>>>    /* Default guest test virtual memory offset */
>>>>> +#ifndef DEFAULT_GUEST_TEST_MEM
>>>>>    #define DEFAULT_GUEST_TEST_MEM        0xc0000000
>>>>> +#endif
>>>>>
>>>>> As this address should be re-defined in LoongArch headers.
>>>>
>>>> Why?  E.g. is 0xc0000000 unconditionally reserved, not guaranteed to
>>>> be valid,
>>>> something else?
>>>>
>>>>> So, do you have any suggesstion?
>>>>
>>>> Hmm, I think ideally kvm_util_base.h would define a range of memory that
>>>> can be used by tests for arbitrary data.  Multiple tests use 0xc0000000,
>>>> which is not entirely arbitrary, i.e. it doesn't _need_ to be 0xc0000000,
>>>> but 0xc0000000 is convenient because it's 32-bit addressable and doesn't
>>>> overlap reserved areas in other architectures.
>> In general text entry address of user application on x86/arm64 Linux
>> is 0x200000, however on LoongArch system text entry address is strange, its
>> value 0x120000000.
>>
>> When DEFAULT_GUEST_TEST_MEM is defined as 0xc0000000, there is limitation
>> for guest memory size, it cannot exceed 0x120000000 - 0xc000000 = 1.5G
>> bytes, else there will be conflict. However there is no such issue on
>> x86/arm64, since 0xc0000000 is above text entry address 0x200000.
> 
> Ugh, I spent a good 30 minutes trying to figure out how any of this works on x86
> before I realized DEFAULT_GUEST_TEST_MEM is used for the guest _virtual_ address
> space.
> 
> I was thinking we were talking about guest _physical_ address, hence my comments
> about it being 32-bit addressable and not overlappin reserved areas.  E.g. on x86,
> anything remotely resembling a real system has regular memory, a.k.a. DRAM, split
> between low memory (below the 32-bit boundary, i.e. below 4GiB) and high memory
> (from 4GiB to the max legal physical address).  Addresses above "top of lower
> usable DRAM" (TOLUD) are reserved (again, in a "real" system) for things like
> PCI, local APIC, I/O APIC, and the _architecturally_ defined RESET vector.
> 
> I couldn't figure out how x86 worked, because KVM creates an KVM-internal memslot
> at address 0xfee00000.  And then I realized the test creates memslots at completely
> different GPAs, and DEFAULT_GUEST_TEST_MEM is used only as super arbitrary
> guest virtual address.
The framework and idea of kvm selftest is very good and intrinsic, and 
it is very easy to write unit test case for kvm -:)

> 
> *sigh*
> 
> Anyways...
> 
>> The LoongArch link scripts actually is strange, it brings out some
>> compatible issues such dpdk/kvm selftest when user applications
>> want fixed virtual address space.
> 
> Can you elaborate on compatiblity issues?  I don't see the connection between
> DPDK and KVM selftests.
No, there is no the connection between DPDK and KVM selftests. I mean 
that some applications which use fixed VA address have the same issue, 
however this kind of usage is OK on X86/ARM. DPDK also uses fixed IOVA 
address(0xC0000000) when it is combined with IOMMU, there is the similar 
conflict issue on LoongArch machines.

> 
>> So here DEFAULT_GUEST_TEST_MEM is defined as 0x130000000 separately, maybe
>> 0x140000000 is better since it is 1G super-page aligned for 4K page size.
> 
> I would strongly prefer we carve out a virtual address range that *all* tests
> can safely use for test-specific code and data.  E.g. if/when we add userspace
> support to selftests, I like the idea of having dedicated address spaces for
> kernel vs. user[*].
> 
> Maybe we can march in that generally direction and define test's virtual address
> range to be in kernel space, i.e. the high half.  I assume/hope that would play
> nice with all architectures' entry points?
yeap, it will solve the issue, virtual address range in kernel space can 
be used. Also both unprivileged and  privileged instruction can be 
tested with ZengGuang's patch.

And is this patchset eligible to merge if common file 
selftests/kvm/include/memstress.h is kept unchanged? Since it is pending 
for a period of time, also LoongArch kvm selftest can pass with guest 
memory size below 1.5G . We can add kernel/user mode support if 
ZengGuang's patch is merged.

Regards
Bibo Mao
> 
> [*] https://lore.kernel.org/all/20231102155111.28821-1-guang.zeng@intel.com
> 


