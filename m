Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A9F6E405A
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDQHGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjDQHF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B3BB7
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715109;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZEkcAbwZBFt6Vk4rvpPu2R+rXf5tjBzverFgxc+9iU=;
        b=WGbxOcUVOg0W3b7+N0ACIF9O32w3T2+3qjymWnoQcsK6qaOw+LNqLfnwV+RYADV0YWW2oT
        GfxnTkbVGUormON03pROhbyv+kda1lmHCqRemWnTCNtFraNH79Z8lH+vnWswG97ua5eG/l
        N7bc4XFFjFLYDZj+QOdvnDGn+F3M3AY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-GNLtMMJ-MOyeH3MAq4je6Q-1; Mon, 17 Apr 2023 03:05:04 -0400
X-MC-Unique: GNLtMMJ-MOyeH3MAq4je6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2E10185A791;
        Mon, 17 Apr 2023 07:05:02 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8558D2166B26;
        Mon, 17 Apr 2023 07:04:50 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-10-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <58664917-edfa-8c7a-2833-0664d83277d6@redhat.com>
Date:   Mon, 17 Apr 2023 15:04:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-10-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Add a capability for userspace to specify the eager split chunk size.
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   Documentation/virt/kvm/api.rst       | 28 ++++++++++++++++++++++++++
>   arch/arm64/include/asm/kvm_host.h    | 15 ++++++++++++++
>   arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++
>   arch/arm64/kvm/arm.c                 | 30 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/mmu.c                 |  3 +++
>   include/uapi/linux/kvm.h             |  2 ++
>   6 files changed, 96 insertions(+)
> 

With the following comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa5..f8faa80d87057 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8380,6 +8380,34 @@ structure.
>   When getting the Modified Change Topology Report value, the attr->addr
>   must point to a byte where the value will be stored or retrieved from.
>   
> +8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +---------------------------------------
> +
> +:Capability: KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
> +:Architectures: arm64
> +:Type: vm
> +:Parameters: arg[0] is the new split chunk size.
> +:Returns: 0 on success, -EINVAL if any memslot was already created.
                                                   ^^^^^^^^^^^^^^^^^^^

Maybe s/was already created/has been created

> +
> +This capability sets the chunk size used in Eager Page Splitting.
> +
> +Eager Page Splitting improves the performance of dirty-logging (used
> +in live migrations) when guest memory is backed by huge-pages.  It
> +avoids splitting huge-pages (into PAGE_SIZE pages) on fault, by doing
> +it eagerly when enabling dirty logging (with the
> +KVM_MEM_LOG_DIRTY_PAGES flag for a memory region), or when using
> +KVM_CLEAR_DIRTY_LOG.
> +
> +The chunk size specifies how many pages to break at a time, using a
> +single allocation for each chunk. Bigger the chunk size, more pages
> +need to be allocated ahead of time.
> +
> +The chunk size needs to be a valid block size. The list of acceptable
> +block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a 64bit
> +bitmap (each bit describing a block size). Setting
> +KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE to 0 disables Eager Page Splitting;
> +this is the default value.
> +

s/a 64bit bitmap/a 64-bit bitmap

For the last sentence, maybe:

The default value is 0, to disable the eager page splitting.

>   9. Known KVM API problems
>   =========================
>   
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1892a8f60323..b87da1ebc3454 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -158,6 +158,21 @@ struct kvm_s2_mmu {
>   	/* The last vcpu id that ran on each physical CPU */
>   	int __percpu *last_vcpu_ran;
>   
> +#define KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT 0
> +	/*
> +	 * Memory cache used to split
> +	 * KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE worth of huge pages. It
> +	 * is used to allocate stage2 page tables while splitting huge
> +	 * pages. Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE
> +	 * influences both the capacity of the split page cache, and
> +	 * how often KVM reschedules. Be wary of raising CHUNK_SIZE
> +	 * too high.
> +	 *
> +	 * Protected by kvm->slots_lock.
> +	 */
> +	struct kvm_mmu_memory_cache split_page_cache;
> +	uint64_t split_page_chunk_size;
> +
>   	struct kvm_arch *arch;
>   };
>   
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 32e5d42bf020f..889bd7afeb355 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -92,6 +92,24 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
>   }
>   
> +static inline u64 kvm_supported_block_sizes(void)
> +{
> +	u32 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
> +	u64 res = 0;
> +
> +	for (; level < KVM_PGTABLE_MAX_LEVELS; level++)
> +		res |= BIT(kvm_granule_shift(level));
> +
> +	return res;
> +}
> +

maybe s/@res/@r

> +static inline bool kvm_is_block_size_supported(u64 size)
> +{
> +	bool is_power_of_two = !((size) & ((size)-1));
> +
> +	return is_power_of_two && (size & kvm_supported_block_sizes());
> +}
> +

IS_ALIGNED() maybe used here.

>   /**
>    * struct kvm_pgtable_mm_ops - Memory management callbacks.
>    * @zalloc_page:		Allocate a single zeroed memory page.
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf0872..34fd3c59a9b82 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -67,6 +67,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			    struct kvm_enable_cap *cap)
>   {
>   	int r;
> +	u64 new_cap;
>   
>   	if (cap->flags)
>   		return -EINVAL;
> @@ -91,6 +92,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		r = 0;
>   		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>   		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		new_cap = cap->args[0];
> +
> +		mutex_lock(&kvm->lock);
> +		mutex_lock(&kvm->slots_lock);
> +		/*
> +		 * To keep things simple, allow changing the chunk
> +		 * size only if there are no memslots already created.
> +		 */

		/*
		 * To keep things simple, allow changing the chunk size
		 * only when no memory slots have been created.
		 */

> +		if (!kvm_are_all_memslots_empty(kvm)) {
> +			r = -EINVAL;
> +		} else if (new_cap && !kvm_is_block_size_supported(new_cap)) {
> +			r = -EINVAL;
> +		} else {
> +			r = 0;
> +			kvm->arch.mmu.split_page_chunk_size = new_cap;
> +		}
> +		mutex_unlock(&kvm->slots_lock);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -288,6 +309,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>   		r = system_has_full_ptr_auth();
>   		break;
> +	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> +		if (kvm)
> +			r = kvm->arch.mmu.split_page_chunk_size;
> +		else
> +			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +		break;
> +	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
> +		r = kvm_supported_block_sizes();
> +		break;

kvm_supported_block_sizes() returns u64, but @r is 32-bits in width. It may be
worthy to make the return value from kvm_supported_block_sizes() as u32.

>   	default:
>   		r = 0;
>   	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a2800e5c42712..898985b09321a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -756,6 +756,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	for_each_possible_cpu(cpu)
>   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>  

It may be worthy to have comments like below:

	/* The eager page splitting is disabled by default */
  
> +	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> +	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>   	mmu->pgt = pgt;
>   	mmu->pgd_phys = __pa(pgt->pgd);
>   	return 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d77aef872a0a0..f18b48fcd25ba 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1184,6 +1184,8 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>   #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
> +#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 227
> +#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 228
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> 

Thanks,
Gavin

