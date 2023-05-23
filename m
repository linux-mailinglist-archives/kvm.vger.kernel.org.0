Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E88770D1CC
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbjEWCya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 22:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjEWCy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 22:54:28 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84B45CD;
        Mon, 22 May 2023 19:54:26 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Cx_erhKmxkAyYLAA--.18826S3;
        Tue, 23 May 2023 10:54:25 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxqrbfKmxkK9ZvAA--.56532S3;
        Tue, 23 May 2023 10:54:24 +0800 (CST)
Message-ID: <1218d3f9-4955-7176-afbd-a0dfa0bd7565@loongson.cn>
Date:   Tue, 23 May 2023 10:54:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 00/30] Add KVM LoongArch support
Content-Language: en-US
To:     WANG Xuerui <kernel@xen0n.name>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
 <02f07d8e-e1c2-2ec0-59c3-f5b4ef0463dc@loongson.cn>
 <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
 <99371487-717a-64d6-1c3d-aaeaee6f20db@loongson.cn>
 <90b2fc60-af26-4ba6-f775-7db2514a62f4@xen0n.name>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <90b2fc60-af26-4ba6-f775-7db2514a62f4@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxqrbfKmxkK9ZvAA--.56532S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoWxCw17XFWUJrWktF4xJFWrXwb_yoWrJFyDpa
        y5uF4akF4vgFnYkwnFyr48u34akrWxGrW5Zr98Kwn7u3Z8AryxKr17tFs0kas8J3Z3CF1Y
        qr4UtF1UCF4UA3DanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bq8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2
        jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
        aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/22 10:37, WANG Xuerui 写道:
> On 2023/5/22 09:39, maobibo wrote:
>>
>>
>> 在 2023/5/21 18:22, WANG Xuerui 写道:
>>> On 2023/5/18 10:56, maobibo wrote:
>>>> <snip>
>>> (BTW, how do people usually deal with pre-release hardware wit documentation not out yet? I suppose similar situations like this should turn up fairly often.)
>> Manual is actually one issue, however it does not prevent the review
>> process. There are some drivers for *fruit* devices, I can not find
>> the hw manual also.  With the manual, it helps to review and points
>> out the further and detailed issues.
> 
> There's a *slight* difference: the certain vendor you've mentioned is historically uncooperative in providing the documentation, so outside contributors had to reverse-engineer and document the HW themselves; but in Loongson's case, you *are* the vendor, so you are probably in a position that can make everyone's life easier by at least pushing for the docs release...
> 
>>>
>>> Aside from this, there's another point: use of undocumented instructions in raw form with ".word". This currently doesn't work in LLVM/Clang <snip>
>> As for one new architecture, it is normal to use .word or .insn, instruction
>> will update for the first few years and also compiler may be not supported
>> timely. The other arch has the same phenomenon if you grep "\.insn", also
>> llvm on LoongArch supports ".word" directives.
>>
>> After three or five years, we will remove these ".insn" macro when hw and
>> compiler is matured.
> 
> Sorry for the confusion at my side; `.word` certainly works, what doesn't work currently seems to be the `parse_r` helper. I know because I've tried in the last week with latest LLVM/Clang snapshot. And you can't write ergonomic inline asm with proper register allocator awareness without the helper; the LoongArch assembler isn't capable of assembling in a certain encoding format. With RISC-V `.insn` you can do things like `.insn r 0xNN, 0, 0, a0, a1, a2`, but you cannot simply e.g. express gcsrxchg with `.insn DJK 0x05000000, a0, a1, a2` because no such instruction format convention has been standardized. (The notation demonstrated here is taken from [1].)

I hate parse_r helper also, it is hard to understand, the kernel about
LoongArch has the same issue. How about using a fixed register like this?

/* GCSR */
static __always_inline u64 gcsr_read(u32 reg)
{
	u64 val = 0;

	BUILD_BUG_ON(!__builtin_constant_p(reg));
	/* Instructions will be available in binutils later */
	asm volatile (
		"parse_r __reg, %[val]\n\t"
		/*
		 * read val from guest csr register %[reg]
		 * gcsrrd %[val], %[reg]
		 */
		".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"
		: [val] "+r" (val)
		: [reg] "i" (reg)
		: "memory");

	return val;
}

/* GCSR */
static __always_inline u64 gcsr_read(u32 reg)
{
        register unsigned long val asm("t0");

        BUILD_BUG_ON(!__builtin_constant_p(reg));
        /* Instructions will be available in binutils later */
        asm volatile (
                "parse_r __reg, %[val]\n\t"
                /*
                 * read val from guest csr register %[reg]
                 * gcsrrd %[val], %[reg]
                 */
                ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | 12 \n\t"
                : : [reg] "i" (reg)
                : "memory", "t0");

        return val;
} 

Regards
Bibo, Mao
> 
> In any case, it seems best to at least wait for the documentation release a little bit, or you should state clearly that this is not going to happen soon, so people can properly manage their expectation and prioritize. (For example, if I know docs and/or assembler support for the virtualization extension won't come soon, then I'd work on supporting the .word idiom before other things. Otherwise there are more important things than that.)
> 
> [1]: https://github.com/loongson/LoongArch-Documentation/pull/56
> 

