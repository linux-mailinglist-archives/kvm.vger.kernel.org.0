Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF59358E617
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 06:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiHJEP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 00:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiHJEO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 00:14:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C6F74DF8
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 21:14:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so952471pjl.0
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 21:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=joIHlmtU9aNzTyrRih0VFEwqdUcFvKemePsuzu7P53I=;
        b=LUWA3l+KMkY7UC78lzTyO5g6ONgEBn//seGt/ChCe2Bra+j4DYB3DAcyv/EC+eqOvJ
         5bDlnc5JsI5Yu/OE40CZItO+ZGHKUUIbofMj352I/CO4CoaUuMdolMA1opVyMphVnOg1
         xzefAbSpx/hVIENWCcXyaWeBzNNQg2IaYJE38L4wjfQEvA8M7tNcsR36iKD4ymbbUsS3
         DeeIES3ia0uP6AjPPah+eZJVvzx3vQR1DYDWuZCkF1+dcq4FTcVh+u4wj9VEC+vxHl71
         6GUZdMf24QMLO5W96vcj9p+a7b3EJUBfrdVo3XjAPkcJMndIIf64SN230KzAn6iDRpN4
         O1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=joIHlmtU9aNzTyrRih0VFEwqdUcFvKemePsuzu7P53I=;
        b=3Fsrwiun6TNhQ3r1rdjgYvbTLEmZ4CnnXWe5/6+lGgvlZO3RusweSxF5PAfLdZus/h
         QjsH8fh7dCKByPhrsGP7/0dlFTEetT57sAJ2Dy5V13rNJP99IAq3fosNfx4wrqKh71f0
         8PlpcCG50KWMVKAFWrRmTr78S7Flp4DgRmMg4W4n3P7YybLOUyjSN2LIuAbpPbCNDd+Y
         IzfBQuj2zAI9vfW3hVbz4joni36GjGA+FDvmV9mPSDga7X/DmzSMtL+DoiZ3RxMt8LJz
         TuXfFNOzMRKiZtAiIWrrbHj0zxktb7KOWY6JCezSOD1dnMISz2g7jD6wm/+T2HzroDCY
         6+OA==
X-Gm-Message-State: ACgBeo3jsTX2RrXC5xgSFvKA44BaTtiA9HvbN9CAP9zfGgVxB7Kw6KL0
        IdbySmtePvw5byo8Pz2TyZUDkg==
X-Google-Smtp-Source: AA6agR5jm5dPBybBKAx+4wHE/Z7SAt0NR32mnW+HwMvL5wtxmNb4JTbErp9uKZtmhD3IavG1OpVj3g==
X-Received: by 2002:a17:902:f54a:b0:16f:16bb:778e with SMTP id h10-20020a170902f54a00b0016f16bb778emr25421177plf.37.1660104894282;
        Tue, 09 Aug 2022 21:14:54 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:46ae:d2a2:e3d1:af67? ([2600:1700:38d4:55df:46ae:d2a2:e3d1:af67])
        by smtp.gmail.com with ESMTPSA id l37-20020a635b65000000b0041bcd8f3958sm8796291pgm.44.2022.08.09.21.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 21:14:53 -0700 (PDT)
Message-ID: <ec0a2c7c-66f3-c9f4-5807-49fa001474fe@google.com>
Date:   Tue, 9 Aug 2022 21:14:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] kvm: x86: mmu: Always flush TLBs when enabling dirty
 logging
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dmatlack@google.com
References: <20220728222833.3850065-1-junaids@google.com>
 <Yu1hOJSucP3NNYM1@google.com>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <Yu1hOJSucP3NNYM1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 11:28, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Junaid Shahid wrote:
>>   	/*
>> +	 * The caller will flush the TLBs after this function returns.
>> +	 *
> 
> This comment is still stale, e.g. it contains a blurb that talks about skipping
> the flush based on MMU-writable.
> 
> 	 * So to determine if a TLB flush is truly required, KVM
> 	 * will clear a separate software-only bit (MMU-writable) and skip the
> 	 * flush if-and-only-if this bit was already clear.
> 
> My preference is to drop this comment entirely and fold it into a single mega
> comment in kvm_mmu_slot_apply_flags().  More below.
> 
>>   	 * It's also safe to flush TLBs out of mmu lock here as currently this
>>   	 * function is only used for dirty logging, in which case flushing TLB
>>   	 * out of mmu lock also guarantees no dirty pages will be lost in
>>   	 * dirty_bitmap.
>>   	 */
>> -	if (flush)
>> -		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>>   }
> 
> ...
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f389691d8c04..f8b215405fe3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12448,6 +12448,25 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>>   		} else {
>>   			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
>>   		}
>> +
>> +		/*
>> +		 * We need to flush the TLBs in either of the following cases:
> 
> Please avoid "we" and pronouns in general.  It's fairly obvious that "we" refers
> to KVM in this case, but oftentimes pronouns can be ambiguous, e.g. "we" can refer
> to the developer, userspace, KVM, etc...
> 
> Smushing the two comments together, how about this as fixup?

Looks good. I'll incorporate this in the patch.

Thanks,
Junaid

> 
> ---
>   arch/x86/kvm/mmu/mmu.c | 23 ------------------
>   arch/x86/kvm/x86.c     | 55 ++++++++++++++++++++++++++++++------------
>   2 files changed, 40 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 14d543f8373c..749c2d39c7bc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6097,29 +6097,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>   		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
>   		read_unlock(&kvm->mmu_lock);
>   	}
> -
> -	/*
> -	 * The caller will flush TLBs to ensure that guest writes are reflected
> -	 * in the dirty bitmap before the memslot update completes, i.e. before
> -	 * enabling dirty logging is visible to userspace.
> -	 *
> -	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
> -	 * time the lock is held. However, this does mean that another CPU can
> -	 * now grab mmu_lock and encounter a write-protected SPTE while CPUs
> -	 * still have a writable mapping for the associated GFN in their TLB.
> -	 *
> -	 * This is safe but requires KVM to be careful when making decisions
> -	 * based on the write-protection status of an SPTE. Specifically, KVM
> -	 * also write-protects SPTEs to monitor changes to guest page tables
> -	 * during shadow paging, and must guarantee no CPUs can write to those
> -	 * page before the lock is dropped. As mentioned in the previous
> -	 * paragraph, a write-protected SPTE is no guarantee that CPU cannot
> -	 * perform writes. So to determine if a TLB flush is truly required, KVM
> -	 * will clear a separate software-only bit (MMU-writable) and skip the
> -	 * flush if-and-only-if this bit was already clear.
> -	 *
> -	 * See is_writable_pte() for more details.
> -	 */
>   }
> 
>   static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7a5e0be2c8ef..430ca4d304a7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12474,21 +12474,46 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>   		}
> 
>   		/*
> -		 * We need to flush the TLBs in either of the following cases:
> -		 *
> -		 * 1. We had to clear the Dirty bits for some SPTEs
> -		 * 2. We had to write-protect some SPTEs and any of those SPTEs
> -		 *    had the MMU-Writable bit set, regardless of whether the
> -		 *    actual hardware Writable bit was set. This is because as
> -		 *    long as the SPTE is MMU-Writable, some CPU may still have
> -		 *    writable TLB entries for it, even after the Writable bit
> -		 *    has been cleared. For more details, see the comments for
> -		 *    is_writable_pte() [specifically the case involving
> -		 *    access-tracking SPTEs].
> -		 *
> -		 * In almost all cases, one of the above conditions will be true.
> -		 * So it is simpler (and probably slightly more efficient) to
> -		 * just flush the TLBs unconditionally.
> +		 * Unconditionally flush the TLBs after enabling dirty logging.
> +		 * A flush is almost always going to be necessary (see below),
> +		 * and unconditionally flushing allows the helpers to omit
> +		 * the subtly complex checks when removing write access.
> +		 *
> +		 * Do the flush outside of mmu_lock to reduce the amount of
> +		 * time mmu_lock is held.  Flushing after dropping mmu_lock is
> +		 * safe as KVM only needs to guarantee the slot is fully
> +		 * write-protected before returning to userspace, i.e. before
> +		 * userspace can consume the dirty status.
> +		 *
> +		 * Flushing outside of mmu_lock requires KVM to be careful when
> +		 * making decisions based on writable status of an SPTE, e.g. a
> +		 * !writable SPTE doesn't guarantee a CPU can't perform writes.
> +		 *
> +		 * Specifically, KVM also write-protects guest page tables to
> +		 * monitor changes when using shadow paging, and must guarantee
> +		 * no CPUs can write to those page before mmu_lock is dropped.
> +		 * Because CPUs may have stale TLB entries at this point, a
> +		 * !writable SPTE doesn't guarantee CPUs can't perform writes.
> +		 *
> +		 * KVM also allows making SPTES writable outside of mmu_lock,
> +		 * e.g. to allow dirty logging without taking mmu_lock.
> +		 *
> +		 * To handle these scenarios, KVM uses a separate software-only
> +		 * bit (MMU-writable) to track if a SPTE is !writable due to
> +		 * a guest page table being write-protected (KVM clears the
> +		 * MMU-writable flag when write-protecting for shadow paging).
> +		 *
> +		 * The use of MMU-writable is also the primary motivation for
> +		 * the unconditional flush.  Because KVM must guarantee that a
> +		 * CPU doesn't contain stale, writable TLB entries for a
> +		 * !MMU-writable SPTE, KVM must flush if it encounters any
> +		 * MMU-writable SPTE regardless of whether the actual hardware
> +		 * writable bit was set.  I.e. KVM is almost guaranteed to need
> +		 * to flush, while unconditionally flushing allows the "remove
> +		 * write access" helpers to ignore MMU-writable entirely.
> +		 *
> +		 * See is_writable_pte() for more details (the case involving
> +		 * access-tracked SPTEs is particularly relevant).
>   		 */
>   		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
>   	}
> 
> base-commit: c00bb4ce5a8aa2156b31ac6b18285e52e1762d21
> --
> 

