Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334F169DF09
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjBULkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbjBULkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:40:21 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CB131E9C0;
        Tue, 21 Feb 2023 03:39:55 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8CxhdiIrfRj5yIDAA--.874S3;
        Tue, 21 Feb 2023 19:39:52 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx2r2HrfRjo7c3AA--.36404S3;
        Tue, 21 Feb 2023 19:39:52 +0800 (CST)
Message-ID: <6eb868bb-2179-2cd7-7632-55e5244afb41@loongson.cn>
Date:   Tue, 21 Feb 2023 19:39:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 02/29] LoongArch: KVM: Implement kvm module related
 interface
Content-Language: en-US
To:     WANG Xuerui <kernel@xen0n.name>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-3-zhaotianrui@loongson.cn>
 <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
 <0fa9c062-d3fc-61e5-4d54-6bc29f7c64cf@loongson.cn>
 <3f16a8e1-21d9-808e-aa1a-4f1d6f6f291b@redhat.com>
 <2875aa3f-0dc4-4e48-17ad-42c703e12063@loongson.cn>
 <35d54051-3876-4fb7-d1c8-d1c605420962@xen0n.name>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <35d54051-3876-4fb7-d1c8-d1c605420962@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx2r2HrfRjo7c3AA--.36404S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Zw1UCFWfAr15JFyrKFW7Arb_yoW8Kr4rpF
        WFyFyUGrykCFyvyw4kuw1v934UtF4fta1UJr1xJFWFywn0gryav3Wj9r1Y9Fy3Cr4fXr1U
        Zr4Yya18uwnxZ37anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1q6r43MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uc_3UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/21 18:37, WANG Xuerui 写道:
> On 2023/2/21 18:18, maobibo wrote:
>>
>>
>> 在 2023/2/21 16:14, Paolo Bonzini 写道:
>>> On 2/21/23 07:59, maobibo wrote:
>>>>> Also, why does the world switch code need a copy?
>>>> There will be problem in world switch code if there is page fault reenter,
>>>> since pgd register is shared between root kernel and kvm hypervisor.
>>>> World switch entry need be unmapped area, cannot be tlb mapped area.
>>>
>>> So if I understand correctly the processor is in direct address translation mode until the "csrwr t0, LOONGARCH_CSR_CRMD" instruction. Where does it leave paged mode?
>> The processor still in paged mode during world switch context. For example
>> when vm exits from guest mode to root mode, it executes world switch code
>> from kvm_vector_entry, PC register points to HVA address, however vmid from
>> LOONGARCH_CSR_GTLBC is not clear to root mode. If there is page fault
>> exception, hardware treats it exception from GPA-->HPA rather than that
>> from HVA --> HPA, since vmid info in CSR_GTLBC is not zero.
>>
>> In page mode, there are two kinds of address: unmapped address and
>> tlb mapped address. For unmapped address there is only cachable/uncachable
>> attribution, but not RWX attr; and there is no tlb handling for it.
>> For simplicity,  unmapped address can be treated as window filtered address.
>>
>> It will be fully root mode only after this piece of code is executed
>> during world switch context; vmid is zero and PC points to HVA.
>>          ori     t0, zero, CSR_GSTAT_PVM
>>          csrxchg zero, t0, LOONGARCH_CSR_GSTAT
>>          /* Clear GTLBC.TGID field */
>>          csrrd   t0, LOONGARCH_CSR_GTLBC
>>          bstrins.w       t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>>          csrwr   t0, LOONGARCH_CSR_GTLBC
> 
> AFAIK all of these is probably coming from Volume 3 of LoongArch ISA Manual, which is unfortunately not publicly available at the moment. For sake of meaningful reviews, when can we expect to get our hands on the manuals?
We are pushing to public the virtualization manual inside, it is convenient
to sw developer to review the code. However I am not sure about the date :(

Regards
Bibo, Mao
> 

