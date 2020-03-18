Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC03189441
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCRDDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:03:30 -0400
Received: from mail.loongson.cn ([114.242.206.163]:49908 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRDDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:03:30 -0400
Received: from [10.20.42.124] (unknown [10.20.42.124])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axf+hxj3Fe9tAbAA--.0S3;
        Wed, 18 Mar 2020 11:03:14 +0800 (CST)
Subject: Re: [PATCH RFC 4/4] KVM: MIPS: Define arch-specific
 kvm_flush_remote_tlbs()
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200207223520.735523-1-peterx@redhat.com>
 <20200207223520.735523-5-peterx@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
From:   maobibo <maobibo@loongson.cn>
Message-ID: <e434cbe0-8d1c-c7fe-e169-01268bd4541c@loongson.cn>
Date:   Wed, 18 Mar 2020 11:03:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200207223520.735523-5-peterx@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Axf+hxj3Fe9tAbAA--.0S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWxWrWkXw4UWFWDWr18AFb_yoW5Zw45pF
        42y3WDWFW7JrnrWF4xJwnrGrnIqws3WFWUA3Wfta45Xr90qF1DKFZ3Gw4IyrW5JrySq3yS
        9F15JF15WFZrC37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkmb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG
        8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2rcTDUUUU
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/08/2020 06:35 AM, Peter Xu wrote:
> Select HAVE_KVM_ARCH_TLB_FLUSH_ALL for MIPS to define its own
> kvm_flush_remote_tlbs().  It's as simple as calling the
> flush_shadow_all(kvm) hook.  Then replace all the flush_shadow_all()
> calls to use this KVM generic API to do TLB flush.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/mips/kvm/Kconfig |  1 +
>  arch/mips/kvm/mips.c  | 22 ++++++++++------------
>  2 files changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
> index eac25aef21e0..8a06f660d39e 100644
> --- a/arch/mips/kvm/Kconfig
> +++ b/arch/mips/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>  	select KVM_MMIO
>  	select MMU_NOTIFIER
>  	select SRCU
> +	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>  	---help---
>  	  Support for hosting Guest kernels.
>
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 1d5e7ffda746..518020b466bf 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -194,13 +194,16 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return 0;
>  }
>
> +void kvm_flush_remote_tlbs(struct kvm *kvm)
> +{
> +	kvm_mips_callbacks->flush_shadow_all(kvm);
> +}
> +
Hi Peter,

Although I do not understand mip VZ fully, however it changes behavior 
of MIPS VZ, since kvm_flush_remote_tlbs is also called in function 
kvm_mmu_notifier_change_pte/kvm_mmu_notifier_invalidate_range_start

regards
bibo, mao

>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
>  	/* Flush whole GPA */
>  	kvm_mips_flush_gpa_pt(kvm, 0, ~0);
> -
> -	/* Let implementation do the rest */
> -	kvm_mips_callbacks->flush_shadow_all(kvm);
> +	kvm_flush_remote_tlbs(kvm);
>  }
>
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> @@ -215,8 +218,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  	/* Flush slot from GPA */
>  	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>  			      slot->base_gfn + slot->npages - 1);
> -	/* Let implementation do the rest */
> -	kvm_mips_callbacks->flush_shadow_all(kvm);
> +	kvm_flush_remote_tlbs(kvm);
>  	spin_unlock(&kvm->mmu_lock);
>  }
>
> @@ -258,7 +260,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  					new->base_gfn + new->npages - 1);
>  		/* Let implementation do the rest */
>  		if (needs_flush)
> -			kvm_mips_callbacks->flush_shadow_all(kvm);
> +			kvm_flush_remote_tlbs(kvm);
>  		spin_unlock(&kvm->mmu_lock);
>  	}
>  }
> @@ -1001,9 +1003,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  	if (flush) {
>  		slots = kvm_memslots(kvm);
>  		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_all(kvm);
> +		kvm_flush_remote_tlbs(kvm);
>  	}
>
>  	mutex_unlock(&kvm->slots_lock);
> @@ -1024,9 +1024,7 @@ int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *lo
>  	if (flush) {
>  		slots = kvm_memslots(kvm);
>  		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_all(kvm);
> +		kvm_flush_remote_tlbs(kvm);
>  	}
>
>  	mutex_unlock(&kvm->slots_lock);
>

