Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C7E69DAD8
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjBUG77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 01:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbjBUG76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 01:59:58 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03C891EBD0;
        Mon, 20 Feb 2023 22:59:55 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Bx783qa_RjxxEDAA--.750S3;
        Tue, 21 Feb 2023 14:59:54 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxC77oa_RjDJM3AA--.35779S3;
        Tue, 21 Feb 2023 14:59:52 +0800 (CST)
Message-ID: <0fa9c062-d3fc-61e5-4d54-6bc29f7c64cf@loongson.cn>
Date:   Tue, 21 Feb 2023 14:59:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 02/29] LoongArch: KVM: Implement kvm module related
 interface
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-3-zhaotianrui@loongson.cn>
 <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxC77oa_RjDJM3AA--.35779S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoWxJrWDGr1kCw4DKryDKF17ZFb_yoW8KryDpF
        1kJrWkJrWkJrn5Xwn0yw1DXFy5ZrykJ3WUKw18ZF1YkFZrAry2gr4kXr1q9FyxZrs3Jr1j
        yw4jgrsrZwnrXrJanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E
        87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/21 01:46, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> +    order = get_order(kvm_vector_size + kvm_enter_guest_size);
>> +    addr = (void *)__get_free_pages(GFP_KERNEL, order);
>> +    if (!addr) {
>> +        free_percpu(vmcs);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    memcpy(addr, kvm_vector_entry, kvm_vector_size);
>> +    memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_guest_size);
>> +    flush_icache_range((unsigned long)addr, (unsigned long)addr +
>> +                kvm_vector_size + kvm_enter_guest_size);
>> +
>> +    vpid_mask = read_csr_gstat();
>> +    vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
>> +    if (vpid_mask)
>> +        vpid_mask = GENMASK(vpid_mask - 1, 0);
>> +
>> +    for_each_possible_cpu(cpu) {
>> +        context = per_cpu_ptr(vmcs, cpu);
>> +        context->vpid_mask = vpid_mask;
>> +        context->vpid_cache = context->vpid_mask + 1;
>> +        context->last_vcpu = NULL;
>> +        context->kvm_eentry = addr;
>> +        context->kvm_enter_guest = addr + kvm_vector_size;
>> +        context->page_order = order;
>> +    }
> 
> A lot of these variables are constant across all pCPUs, any reason to have them in a per-CPU variable?  Likewise, since they are all the same as the constant global vmcs variable, why make them part of struct kvm_context instead of just making them globals?
> 
Paolo,

Thanks for reviewing these patches.

Originally we think that global variables make c files depending with
each other, and global variables is not faster than percpu, so that
we removes global variables. we are ok to make them globals.

> Also, why does the world switch code need a copy?
There will be problem in world switch code if there is page fault reenter,
since pgd register is shared between root kernel and kvm hypervisor. 
World switch entry need be unmapped area, cannot be tlb mapped area.

In future if hw pagetable walking is supported, or there is separate pgd
registers between root kernel and kvm hypervisor, copying about world switch
code will not be used.

Regards
Bibo, Mao
> 
> Paolo

