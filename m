Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F474D4090
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 06:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbiCJFLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 00:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 00:11:12 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7B1C412D90B;
        Wed,  9 Mar 2022 21:10:08 -0800 (PST)
Received: from [10.25.175.14] (unknown [58.240.254.218])
        by app1 (Coremail) with SMTP id xjNnewB3H+_5hylidpQLAA--.1109S3;
        Thu, 10 Mar 2022 13:09:14 +0800 (CST)
Message-ID: <6c29b009-2518-411a-fde4-f89d599e522c@wangsu.com>
Date:   Thu, 10 Mar 2022 13:09:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RESEND PATCH] KVM: x86/mmu: make apf token non-zero to fix bug
To:     "zhangliang (AG)" <zhangliang5@huawei.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhigang17@huawei.com
References: <20220222031239.1076682-1-zhangliang5@huawei.com>
 <69d9a292-c140-ac6c-6afb-df4e383e2847@wangsu.com>
 <b4c9648c-1f46-6dc2-3bec-6354db7f2c76@huawei.com>
From:   Xinlong Lin <linxl3@wangsu.com>
In-Reply-To: <b4c9648c-1f46-6dc2-3bec-6354db7f2c76@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: xjNnewB3H+_5hylidpQLAA--.1109S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAr4UGF4fGF13WFWkAw48tFb_yoW5Kw4Dpr
        WvkFyYgrWrWrn5Gw1UXrn0qryUJr48A3WDXr18XFy8XF4aqrnFgF48Wr90gFnxWr48ZF1x
        tF15Xw4a9r1UJaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB2b7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
        AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
        6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
        0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE
        67vIY487MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r
        yUJr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
        kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2ID7DUUUU
X-CM-SenderInfo: holq5zmt6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you and sorry for the noise.

On 2022/3/10 11:42, zhangliang (AG) wrote:
> No. Because '(++vcpu->arch.apf.id << 12)' may also produce zero value.
> 
> On 2022/3/10 11:34, Xinlong Lin wrote:
>>
>>
>> On 2022/2/22 11:12, Liang Zhang wrote:
>>> In current async pagefault logic, when a page is ready, KVM relies on
>>> kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
>>> a READY event to the Guest. This function test token value of struct
>>> kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
>>> READY event is finished by Guest. If value is zero meaning that a READY
>>> event is done, so the KVM can deliver another.
>>> But the kvm_arch_setup_async_pf() may produce a valid token with zero
>>> value, which is confused with previous mention and may lead the loss of
>>> this READY event.
>>>
>>> This bug may cause task blocked forever in Guest:
>>>    INFO: task stress:7532 blocked for more than 1254 seconds.
>>>          Not tainted 5.10.0 #16
>>>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>    task:stress          state:D stack:    0 pid: 7532 ppid:  1409
>>>    flags:0x00000080
>>>    Call Trace:
>>>     __schedule+0x1e7/0x650
>>>     schedule+0x46/0xb0
>>>     kvm_async_pf_task_wait_schedule+0xad/0xe0
>>>     ? exit_to_user_mode_prepare+0x60/0x70
>>>     __kvm_handle_async_pf+0x4f/0xb0
>>>     ? asm_exc_page_fault+0x8/0x30
>>>     exc_page_fault+0x6f/0x110
>>>     ? asm_exc_page_fault+0x8/0x30
>>>     asm_exc_page_fault+0x1e/0x30
>>>    RIP: 0033:0x402d00
>>>    RSP: 002b:00007ffd31912500 EFLAGS: 00010206
>>>    RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
>>>    RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
>>>    RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
>>>    R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
>>>    R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000
>>>
>>> Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 593093b52395..8e24f73bf60b 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>>>        walk_shadow_page_lockless_end(vcpu);
>>>    }
>>>    +static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
>>> +{
>>> +    /* make sure the token value is not 0 */
>>> +    u32 id = vcpu->arch.apf.id;
>>> +
>>> +    if (id << 12 == 0)
>>> +        vcpu->arch.apf.id = 1;
>>> +
>>> +    return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>>> +}
>>> +
>>>    static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>>                        gfn_t gfn)
>>>    {
>>>        struct kvm_arch_async_pf arch;
>>>    -    arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>> This patch is completely OK. But I have a question, can we simplify it to
>> arch.token = (++vcpu->arch.apf.id << 12) | vcpu->vcpu_id;
>>> +    arch.token = alloc_apf_token(vcpu);
>>>        arch.gfn = gfn;
>>>        arch.direct_map = vcpu->arch.mmu->direct_map;
>>>        arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
>>
>> .
> 

