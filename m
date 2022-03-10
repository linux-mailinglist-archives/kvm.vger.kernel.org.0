Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55204D3FC1
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbiCJDgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 22:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiCJDgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 22:36:32 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 5CF505EBD8;
        Wed,  9 Mar 2022 19:35:27 -0800 (PST)
Received: from [172.19.1.222] (unknown [59.61.78.132])
        by app2 (Coremail) with SMTP id 4zNnewBXXs65cSliXZEBAA--.158S3;
        Thu, 10 Mar 2022 11:34:20 +0800 (CST)
Message-ID: <69d9a292-c140-ac6c-6afb-df4e383e2847@wangsu.com>
Date:   Thu, 10 Mar 2022 11:34:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
From:   Xinlong Lin <linxl3@wangsu.com>
Subject: Re: [RESEND PATCH] KVM: x86/mmu: make apf token non-zero to fix bug
To:     Liang Zhang <zhangliang5@huawei.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhigang17@huawei.com
References: <20220222031239.1076682-1-zhangliang5@huawei.com>
In-Reply-To: <20220222031239.1076682-1-zhangliang5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: 4zNnewBXXs65cSliXZEBAA--.158S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1ruw18Jr18XFyUJF15XFb_yoW5ArW7pF
        y2kryFgw4rXr1Yg3WUXwn0vr45Cr48CF1xXr9rGrW8Z3WYqw1kCF1xKrZ8ZF93Wr48Za1f
        tFsYqw4Ykr18JaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkSb7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
        k0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxAIw28I
        cVCjz48v1sIEY20_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU8jg4DUUUU
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



On 2022/2/22 11:12, Liang Zhang wrote:
> In current async pagefault logic, when a page is ready, KVM relies on
> kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
> a READY event to the Guest. This function test token value of struct
> kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
> READY event is finished by Guest. If value is zero meaning that a READY
> event is done, so the KVM can deliver another.
> But the kvm_arch_setup_async_pf() may produce a valid token with zero
> value, which is confused with previous mention and may lead the loss of
> this READY event.
> 
> This bug may cause task blocked forever in Guest:
>   INFO: task stress:7532 blocked for more than 1254 seconds.
>         Not tainted 5.10.0 #16
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   task:stress          state:D stack:    0 pid: 7532 ppid:  1409
>   flags:0x00000080
>   Call Trace:
>    __schedule+0x1e7/0x650
>    schedule+0x46/0xb0
>    kvm_async_pf_task_wait_schedule+0xad/0xe0
>    ? exit_to_user_mode_prepare+0x60/0x70
>    __kvm_handle_async_pf+0x4f/0xb0
>    ? asm_exc_page_fault+0x8/0x30
>    exc_page_fault+0x6f/0x110
>    ? asm_exc_page_fault+0x8/0x30
>    asm_exc_page_fault+0x1e/0x30
>   RIP: 0033:0x402d00
>   RSP: 002b:00007ffd31912500 EFLAGS: 00010206
>   RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
>   RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
>   RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
>   R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
>   R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000
> 
> Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 593093b52395..8e24f73bf60b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>   	walk_shadow_page_lockless_end(vcpu);
>   }
>   
> +static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
> +{
> +	/* make sure the token value is not 0 */
> +	u32 id = vcpu->arch.apf.id;
> +
> +	if (id << 12 == 0)
> +		vcpu->arch.apf.id = 1;
> +
> +	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
> +}
> +
>   static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   				    gfn_t gfn)
>   {
>   	struct kvm_arch_async_pf arch;
>   
> -	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
This patch is completely OK. But I have a question, can we simplify it to
arch.token = (++vcpu->arch.apf.id << 12) | vcpu->vcpu_id;
> +	arch.token = alloc_apf_token(vcpu);
>   	arch.gfn = gfn;
>   	arch.direct_map = vcpu->arch.mmu->direct_map;
>   	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);

