Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBC69D91F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjBUDCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjBUDCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:02:46 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9A3F1A49C;
        Mon, 20 Feb 2023 19:02:44 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8DxEzRMNPRjjAYDAA--.753S3;
        Tue, 21 Feb 2023 11:02:36 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxsOQwNPRjrH83AA--.783S3;
        Tue, 21 Feb 2023 11:02:09 +0800 (CST)
Subject: Re: [PATCH v2 02/29] LoongArch: KVM: Implement kvm module related
 interface
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-3-zhaotianrui@loongson.cn>
 <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <708f97e8-0501-a4d4-2c33-7f4c41339d6b@loongson.cn>
Date:   Tue, 21 Feb 2023 11:02:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxsOQwNPRjrH83AA--.783S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tw1UuF45KFWfCrykXw4xWFg_yoW8XF4Upa
        4DCFn5Ar4UJFyfXwn0ya1vq3WFq3ykK3W2k3W0k3WYk3srurna9rs7Jr4j9F97Zrn3AF4v
        va1YgrsxXrn0qFJanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
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



在 2023年02月21日 01:46, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> +    order = get_order(kvm_vector_size + kvm_enter_guest_size);
>> +    addr = (void *)__get_free_pages(GFP_KERNEL, order);
>> +    if (!addr) {
>> +        free_percpu(vmcs);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    memcpy(addr, kvm_vector_entry, kvm_vector_size);
>> +    memcpy(addr + kvm_vector_size, kvm_enter_guest, 
>> kvm_enter_guest_size);
>> +    flush_icache_range((unsigned long)addr, (unsigned long)addr +
>> +                kvm_vector_size + kvm_enter_guest_size);
>> +
>> +    vpid_mask = read_csr_gstat();
>> +    vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> 
>> CSR_GSTAT_GIDBIT_SHIFT;
>> +    if (vpid_mask)
>> +        vpid_mask = GENMASK(vpid_mask - 1, 0);
>> +
>> +    for_each_possible_cpu(cpu) {
>> +        context = per_cpu_ptr(vmcs, cpu);
>> +        context->vpid_mask = vpid_mask;
>> +        context->vpid_cache = context->vpid_mask + 1;
>> +        context->last_vcpu = NULL;
>> +        context->kvm_eentry = addr;
>> +        context->kvm_enter_guest = addr + kvm_vector_size;
>> +        context->page_order = order;
>> +    }
>
> A lot of these variables are constant across all pCPUs, any reason to 
> have them in a per-CPU variable?  Likewise, since they are all the 
> same as the constant global vmcs variable, why make them part of 
> struct kvm_context instead of just making them globals?

Ok thanks, it is more appropriate to use global variables to save those 
information.

Thanks
Tianrui Zhao

>
> Also, why does the world switch code need a copy?
>
> Paolo

