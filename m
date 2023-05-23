Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9107270DBD8
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbjEWL5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 07:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjEWL53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 07:57:29 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A60E11F;
        Tue, 23 May 2023 04:57:23 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8CxZ_Ehqmxk6w4AAA--.223S3;
        Tue, 23 May 2023 19:57:21 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxMuUgqmxkoFFwAA--.55963S3;
        Tue, 23 May 2023 19:57:20 +0800 (CST)
Message-ID: <94b7f3d6-e2e1-be0a-cd39-dd1b1f1f607e@loongson.cn>
Date:   Tue, 23 May 2023 19:57:20 +0800
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
 <1218d3f9-4955-7176-afbd-a0dfa0bd7565@loongson.cn>
 <29a9c6b4-96b8-3fb5-9b7a-2f9dba97e06f@xen0n.name>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <29a9c6b4-96b8-3fb5-9b7a-2f9dba97e06f@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxMuUgqmxkoFFwAA--.55963S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoWxZF15KFWxXry5Ww47Kw45ZFb_yoW5Cr1fpr
        1kGr15Ary5Wr1kJr17Xr18Xry3Jw1UK3WDJr1DGFy5tF4UJr10qr4UXr1Y9rnrJr48Jr15
        Jr1Utw13ur17Jr7anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/23 18:27, WANG Xuerui 写道:
> On 2023/5/23 10:54, maobibo wrote:
>>
>> [snip]
>>
>> I hate parse_r helper also, it is hard to understand, the kernel about
>> LoongArch has the same issue. How about using a fixed register like this?
>>
>> /* GCSR */
>> static __always_inline u64 gcsr_read(u32 reg)
>> {
>>     u64 val = 0;
>>
>>     BUILD_BUG_ON(!__builtin_constant_p(reg));
>>     /* Instructions will be available in binutils later */
>>     asm volatile (
>>         "parse_r __reg, %[val]\n\t"
> 
> Isn't this still parse_r-ing things? ;-)
> 
>>         /*
>>          * read val from guest csr register %[reg]
>>          * gcsrrd %[val], %[reg]
>>          */
>>         ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"
>>         : [val] "+r" (val)
>>         : [reg] "i" (reg)
>>         : "memory");
>>
>>     return val;
>> }
>>
>> /* GCSR */
>> static __always_inline u64 gcsr_read(u32 reg)
>> {
>>          register unsigned long val asm("t0");
> 
> I got what you're trying to accomplish here. At which point you may just refer to how glibc implements its inline syscall templates and hardcode both the input and output arguments, then simply hard-code the whole instruction word. If others don't have opinions about doing things this way, I wouldn't either.
> 
> (CSR operations are not expected to become performance-sensitive in any case, so you may freely choose registers here, and t0 for output seems okay. I'd recommend stuffing "reg" to a temporary value bound to a0 though.)
a0 is ok for me.

riscv has better method than both parse_r helper and using tmp register
as follows, maybe we can use the similiar method. 

        .macro insn_r, opcode, func3, func7, rd, rs1, rs2
        .4byte  ((\opcode << INSN_R_OPCODE_SHIFT) |             \
                 (\func3 << INSN_R_FUNC3_SHIFT) |               \
                 (\func7 << INSN_R_FUNC7_SHIFT) |               \
                 (.L__gpr_num_\rd << INSN_R_RD_SHIFT) |         \
                 (.L__gpr_num_\rs1 << INSN_R_RS1_SHIFT) |       \
                 (.L__gpr_num_\rs2 << INSN_R_RS2_SHIFT))
        .endm

#define HINVAL_VVMA(vaddr, asid)                                \
        INSN_R(OPCODE_SYSTEM, FUNC3(0), FUNC7(19),              \
               __RD(0), RS1(vaddr), RS2(asid))

asm volatile(HINVAL_VVMA(%0, %1)
                        : : "r" (pos), "r" (asid) : "memory");

Regards
Bibo, Mao
> 
>>
>>          BUILD_BUG_ON(!__builtin_constant_p(reg));
>>          /* Instructions will be available in binutils later */
>>          asm volatile (
>>                  "parse_r __reg, %[val]\n\t"
>>                  /*
>>                   * read val from guest csr register %[reg]
>>                   * gcsrrd %[val], %[reg]
>>                   */
>>                  ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | 12 \n\t"
>>                  : : [reg] "i" (reg)
>>                  : "memory", "t0");
>>
>>          return val;
>> }
> 

