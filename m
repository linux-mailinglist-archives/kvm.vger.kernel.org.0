Return-Path: <kvm+bounces-4300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E4B810BB2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE0FE2815D3
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0AC1A584;
	Wed, 13 Dec 2023 07:42:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A25E69B;
	Tue, 12 Dec 2023 23:42:42 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxbOlwYHllCpoAAA--.3578S3;
	Wed, 13 Dec 2023 15:42:40 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axv+FtYHll3QYCAA--.13949S3;
	Wed, 13 Dec 2023 15:42:39 +0800 (CST)
Subject: Re: [PATCH v5 1/4] KVM: selftests: Add KVM selftests header files for
 LoongArch
To: zhaotianrui <zhaotianrui@loongson.cn>,
 Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Vishal Annapurve <vannapurve@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, Peter Xu <peterx@redhat.com>,
 Vipin Sharma <vipinsh@google.com>, huangpei@loongson.cn
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-2-zhaotianrui@loongson.cn>
 <e40d3884-bf39-8286-627f-e0ce7dacfcbe@loongson.cn>
 <ZXiV1rMrXY0hNgvZ@google.com>
 <023b6f8f-301b-a6d0-448b-09a602ba1141@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <06076290-4efb-5d71-74eb-396d325447e0@loongson.cn>
Date: Wed, 13 Dec 2023 15:42:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <023b6f8f-301b-a6d0-448b-09a602ba1141@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axv+FtYHll3QYCAA--.13949S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7WF13GFWUCFy7Cw4ftF4rXrc_yoW8tF43pr
	yIkF1Yka1kGrZ7tw4kt3W5XF4agFs3u3W8ArykWr4Uuan8Xw17Ar1jkw4rKas2krW8J3Wj
	qF4jq3yjv3Z8C3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUc9a9UU
	UUU



On 2023/12/13 下午3:15, zhaotianrui wrote:
> 
> 
> 在 2023/12/13 上午1:18, Sean Christopherson 写道:
>> On Tue, Dec 12, 2023, zhaotianrui wrote:
>>> Hi, Sean:
>>>
>>> I want to change the definition of  DEFAULT_GUEST_TEST_MEM in the common
>>> file "memstress.h", like this:
>>>
>>>   /* Default guest test virtual memory offset */
>>> +#ifndef DEFAULT_GUEST_TEST_MEM
>>>   #define DEFAULT_GUEST_TEST_MEM        0xc0000000
>>> +#endif
>>>
>>> As this address should be re-defined in LoongArch headers.
>>
>> Why?  E.g. is 0xc0000000 unconditionally reserved, not guaranteed to 
>> be valid,
>> something else?
>>
>>> So, do you have any suggesstion?
>>
>> Hmm, I think ideally kvm_util_base.h would define a range of memory 
>> that can be
>> used by tests for arbitrary data.  Multiple tests use 0xc0000000, 
>> which is not
>> entirely arbitrary, i.e. it doesn't _need_ to be 0xc0000000, but 
>> 0xc0000000 is
>> convenient because it's 32-bit addressable and doesn't overlap 
>> reserved areas in
>> other architectures.
In general text entry address of user application on x86/arm64 Linux
is 0x200000, however on LoongArch system text entry address is strange, 
its value 0x120000000.

When DEFAULT_GUEST_TEST_MEM is defined as 0xc0000000, there is 
limitation for guest memory size, it cannot exceed 0x120000000 - 
0xc000000 = 1.5G bytes, else there will be conflict. However
there is no such issue on x86/arm64, since 0xc0000000 is above text 
entry address 0x200000.

The LoongArch link scripts actually is strange, it brings out some 
compatible issues such dpdk/kvm selftest when user applications
want fixed virtual address space.

So here DEFAULT_GUEST_TEST_MEM is defined as 0x130000000 separately, 
maybe 0x140000000 is better since it is 1G super-page aligned for 4K 
page size.

Regards
Bibo Mao

>>
> Thanks for your explanation, and LoongArch want to define 
> DEFAULT_GUEST_TEST_MEM to 0x130000000. As default base address for 
> application loading is 0x120000000, DEFAULT_GUEST_TEST_MEM should be 
> larger than app loading address, so that PER_VCPU_MEM_SIZE can be large 
> enough, and kvm selftests app size is smaller than 256M in generic.
> 
> Thanks
> Tianrui Zhao


