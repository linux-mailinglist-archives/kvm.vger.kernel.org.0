Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D16E70B2D9
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjEVBja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 21:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEVBj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 21:39:29 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA2B7CE;
        Sun, 21 May 2023 18:39:27 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxI_DOx2pkxsYKAA--.18463S3;
        Mon, 22 May 2023 09:39:26 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxqrbNx2pkpV9uAA--.54486S3;
        Mon, 22 May 2023 09:39:25 +0800 (CST)
Message-ID: <99371487-717a-64d6-1c3d-aaeaee6f20db@loongson.cn>
Date:   Mon, 22 May 2023 09:39:25 +0800
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
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <4529ee5b-364a-7819-c727-71cf94057b8b@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxqrbNx2pkpV9uAA--.54486S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoWxWrWfAr1rAFWrJFyktr43Wrg_yoW5WF15pr
        4a9F47tFn5Ar4UZ34q9a18ZFy5Kwn7W3y5XrsxK343u3yUAr18tF1ftFZ0ya4UZan3Jr4j
        qr17Kr18A3Z8Za7anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
        ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Dl1DUUUUU==
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/21 18:22, WANG Xuerui 写道:
> On 2023/5/18 10:56, maobibo wrote:
>> Hi Paolo & Huacai,
>>
>> Sorry to bother you, I do not know flow of kernel code reviewing and merging.
>>
>> I want to know who should give a reviewed-by comments for these piece of code
>> about loongarch kvm patch. It should be kvm maintainer or LoongArch maintianer?
>> And any suggestion is welcome.
> 
> IMO the series should get its R-b from kvm maintainers (because it's kvm after all), and ideally also Acked-by from arch/loongarch maintainers (because it contains arch-specific code), according to common sense.
> 
> But in order for the various maintainers/reviewers to effectively review, maybe the LoongArch ISA manual Volume 3 (containing details about the virtualization extension) should be put out soon. AFAIK Huacai has access to it, by being a Loongson employee, but I don't know if he can review this series in the public without violating NDAs; Loongson outsiders like me and the kvm reviewers can only trust the commit messages and comments for the time being.
Yes, it will be best if kvm maintainers can give reviewed-by comments,
since they understand kvm component at best and know the future
evolution directions.

> 
> (BTW, how do people usually deal with pre-release hardware wit documentation not out yet? I suppose similar situations like this should turn up fairly often.)
Manual is actually one issue, however it does not prevent the review
process. There are some drivers for *fruit* devices, I can not find
the hw manual also.  With the manual, it helps to review and points
out the further and detailed issues.
> 
> Aside from this, there's another point: use of undocumented instructions in raw form with ".word". This currently doesn't work in LLVM/Clang, thus will slightly set back the ongoing ClangBuiltLinux enablement effort (currently all such usages in arch/loongarch are related to "invtlb" which has perfect support, and can be removed). AFAIK, such practice dates back to the LoongISA times, when the Loongson extended opcodes weren't supported by the upstream MIPS toolchains for some reason; but LoongArch is independent and not bounded by anyone else now, so it's better in terms of maintainability to just add the instructions to the toolchains. People will not be inconvenienced by having to use bleeding-edge LoongArch toolchains because upstream LoongArch devs have always been doing this.
As for one new architecture, it is normal to use .word or .insn, instruction
will update for the first few years and also compiler may be not supported
timely. The other arch has the same phenomenon if you grep "\.insn", also
llvm on LoongArch supports ".word" directives.

After three or five years, we will remove these ".insn" macro when hw and
compiler is matured.

Regards
Bibo, Mao
> 

