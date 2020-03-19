Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9018AA9F
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 03:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCSCVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 22:21:15 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45810 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgCSCVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 22:21:15 -0400
Received: from [10.20.42.25] (unknown [10.20.42.25])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH2kV13Je8mMcAA--.28S3;
        Thu, 19 Mar 2020 10:21:09 +0800 (CST)
Subject: Re: [PATCH RFC 4/4] KVM: MIPS: Define arch-specific
 kvm_flush_remote_tlbs()
To:     Peter Xu <peterx@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
 <20200207223520.735523-5-peterx@redhat.com>
 <e434cbe0-8d1c-c7fe-e169-01268bd4541c@loongson.cn>
 <20200318152837.GB26585@xz-x1>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
From:   maobibo <maobibo@loongson.cn>
Message-ID: <a78041a0-a987-5456-ed3f-44eb1a6022a7@loongson.cn>
Date:   Thu, 19 Mar 2020 10:21:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200318152837.GB26585@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxH2kV13Je8mMcAA--.28S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4UAFykAw1kXF15Gw43Awb_yoW8uFy8pF
        W7C3ZrCF4UWrWkWa4SvwnxWr1aqws3JFWUW3WUK345Xr90qr1kJFWfGr4F9ryUWrySqw1S
        9F1rX3W3W3y7Aa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvFb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487
        MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_
        Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvj
        xU2xR6UUUUU
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/18/2020 11:28 PM, Peter Xu wrote:
> On Wed, Mar 18, 2020 at 11:03:13AM +0800, maobibo wrote:
>>
>>
>> On 02/08/2020 06:35 AM, Peter Xu wrote:
>>> Select HAVE_KVM_ARCH_TLB_FLUSH_ALL for MIPS to define its own
>>> kvm_flush_remote_tlbs().  It's as simple as calling the
>>> flush_shadow_all(kvm) hook.  Then replace all the flush_shadow_all()
>>> calls to use this KVM generic API to do TLB flush.
>>>
>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>> ---
>>>  arch/mips/kvm/Kconfig |  1 +
>>>  arch/mips/kvm/mips.c  | 22 ++++++++++------------
>>>  2 files changed, 11 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
>>> index eac25aef21e0..8a06f660d39e 100644
>>> --- a/arch/mips/kvm/Kconfig
>>> +++ b/arch/mips/kvm/Kconfig
>>> @@ -26,6 +26,7 @@ config KVM
>>>  	select KVM_MMIO
>>>  	select MMU_NOTIFIER
>>>  	select SRCU
>>> +	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>>>  	---help---
>>>  	  Support for hosting Guest kernels.
>>>
>>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>>> index 1d5e7ffda746..518020b466bf 100644
>>> --- a/arch/mips/kvm/mips.c
>>> +++ b/arch/mips/kvm/mips.c
>>> @@ -194,13 +194,16 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>  	return 0;
>>>  }
>>>
>>> +void kvm_flush_remote_tlbs(struct kvm *kvm)
>>> +{
>>> +	kvm_mips_callbacks->flush_shadow_all(kvm);
>>> +}
>>> +
>> Hi Peter,
>
> Hi, Bibo,
>
>>
>> Although I do not understand mip VZ fully, however it changes behavior of
>> MIPS VZ, since kvm_flush_remote_tlbs is also called in function
>> kvm_mmu_notifier_change_pte/kvm_mmu_notifier_invalidate_range_start
>
> I'm not familiar with MIPS either, however... I would start to suspect
> MIPS could be problematic with MMU notifiers when cpu_has_guestid is
> not set.  If that's the case, then this series might instead fix it.

yeap, from my viewpoint this series actually fix it when cpu_has_guestid 
is not set, previous kvm_flush_remote_tlbs function do nothing actually 
for MIPS VZ machine without cpu_has_guestid flag.

>
> Thanks,
>

