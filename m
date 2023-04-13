Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578786E0D1D
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 13:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjDMLwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 07:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDMLwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 07:52:53 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC8161B3;
        Thu, 13 Apr 2023 04:52:50 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8BxYU8R7Tdk+eIbAA--.43450S3;
        Thu, 13 Apr 2023 19:52:49 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxxrwQ7Tdkl1oiAA--.36338S3;
        Thu, 13 Apr 2023 19:52:48 +0800 (CST)
Subject: Re: [PATCH v6 29/30] LoongArch: KVM: Enable kvm config and add the
 makefile
To:     Xi Ruoyao <xry111@xry111.site>, kernel test robot <lkp@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230412083023.1693910-30-zhaotianrui@loongson.cn>
 <202304131526.iXfLaVZc-lkp@intel.com>
 <ee3b287c78d9fbbbc996a787053b4c37fe365c2c.camel@xry111.site>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <cead582c-ebc4-e8cf-2326-349933e11afd@loongson.cn>
Date:   Thu, 13 Apr 2023 19:52:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <ee3b287c78d9fbbbc996a787053b4c37fe365c2c.camel@xry111.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxxrwQ7Tdkl1oiAA--.36338S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7KF4UKF1rWw45Cw4fGFW8Xrb_yoW8uFyxpa
        srAr4UKF4vqryjkw1jyF1xt3Z5tryfGay8JF1jvwn8ZF4Ut3s7Jr4UGryrKFWaqas8GF4Y
        gaySqws0kw18JF7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bq8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280
        aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2
        xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUUUUU
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月13日 16:33, Xi Ruoyao 写道:
> On Thu, 2023-04-13 at 15:32 +0800, kernel test robot wrote:
>
>> vim +/asm +244 arch/loongarch/include/asm/loongarch.h
>>
>> f2ac457a61389b Huacai Chen  2022-05-31  238
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  239  /* GCSR */
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  240  static inline u64 gcsr_read(u32 reg)
> Try __always_inline instead of inline because this "function" will
> definitely break up if it's not inlined.
>
> And I guess we should have something like:
>
> extern u64 __compiletime_error("gcsr_read parameter is not a constant")
> __gcsr_read_non_const(void);
>
> static __always_inline u64 gcsr_read(u32 reg)
> {
> 	u64 val = 0;
>
> 	if (!__builtin_constant_p(reg))
> 		return __gcsr_read_non_const();
>
> 	asm volatile (
> ... ...
>
> Or perhaps we should just rewrite gcsr_read to a macro.
>
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  241  {
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  242     u64 val = 0;
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  243     /* Instructions will be available in binutils later */
>> 2c87b678639d25 Tianrui Zhao 2023-04-12 @244     asm volatile (
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  245             "parse_r __reg, %[val]\n\t"
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  246             /*
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  247              * read val from guest csr register %[reg]
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  248              * gcsrrd %[val], %[reg]
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  249              */
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  250             ".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  251             : [val] "+r" (val)
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  252             : [reg] "i" (reg)
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  253             : "memory");
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  254
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  255     return val;
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  256  }
>> 2c87b678639d25 Tianrui Zhao 2023-04-12  257
>>
Thanks, it really should use __always_inline there, and I will reconsider to fix this function mistakes about compiling.

Thanks
Tianrui Zhao

