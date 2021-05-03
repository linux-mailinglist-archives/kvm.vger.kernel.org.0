Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534103715F6
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhECNaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 09:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233773AbhECNaM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 09:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620048559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5ncV0IuRV2X8acsw7XWidCK/BBCiCt6KbPi7m/CD8g=;
        b=iQrD531wA7j91RBb9LZjgWcqgjZQJvTBbZdJD6QTpgi0kzkPYuT0QOvUZSx0A4f/hecTEf
        FDNONHnHm52Ui++UuegmTS/+5IFGAwEWW0siWLYvwPCZB8S4LJOOvsaHg6en6WsWvh5lWp
        FWCLILNEzS/qsZajNXf5w1t2kvZSaHA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-OUa119NEMbWKSpSR8x8IOw-1; Mon, 03 May 2021 09:29:17 -0400
X-MC-Unique: OUa119NEMbWKSpSR8x8IOw-1
Received: by mail-ed1-f71.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so4531176edd.2
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 06:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e5ncV0IuRV2X8acsw7XWidCK/BBCiCt6KbPi7m/CD8g=;
        b=EmkZo9BWfx+bXZgKYy9AOtZH2POd87bOG0BcIcIO4Wp1kSikBpMhTmpTsAytQRLXa3
         w9mAyeMhuhh6k3+tRnE2GqWveuKqr7F3x1ghvDC/9SrrfHjnmAdTT3VmnTbDLIu5/s1P
         LejG9mXA9crFBtYAR8E3+z5VmV5lg8Ir+WL8OLF44+LrVeq6DhXPcPaOxS3fA4wUkqkw
         WV8aJmAp0C3/yf3TnCrhb0yuuVpDm/UCh+rrKQEWYtlMVHZYEO7jhNmhhAIpLjj2G05/
         IHMTiQYgl0Bsqcth0shJUhbSJmFln8Nn1l53eRfTt6Aey9Be8NhUCs/ybjdhTbqLG7gR
         3Tqw==
X-Gm-Message-State: AOAM532ZCsQ4Y+6cxTjeOEmbOn/Ymx1QzWHldjuWphYD2vxVUzABiJ56
        9zuKkmPFMlCiqZKjFKUsZKcPn3AtrHKZ0m5qpPu6fGOTTTbU2PS1hQ7y1IJSA42cHuxjwTmWNgv
        5YJv3mZMq1C8R
X-Received: by 2002:a17:906:57c3:: with SMTP id u3mr6342362ejr.162.1620048556668;
        Mon, 03 May 2021 06:29:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/Aww29E8ytLtFzAfOWI+1a+yBoHJ2PMthWXM8sX0DLGamizPpdIKkDlRNVbitW0rwV0r7nA==
X-Received: by 2002:a17:906:57c3:: with SMTP id u3mr6342344ejr.162.1620048556461;
        Mon, 03 May 2021 06:29:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r16sm4130883edq.87.2021.05.03.06.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 06:29:15 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-7-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 6/7] KVM: mmu: Add slots_arch_lock for memslot arch
 fields
Message-ID: <1e9c77a9-adec-0a2d-5483-70cb2332d529@redhat.com>
Date:   Mon, 3 May 2021 15:29:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210429211833.3361994-7-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 23:18, Ben Gardon wrote:
> Add a new lock to protect the arch-specific fields of memslots if they
> need to be modified in a kvm->srcu read critical section. A future
> commit will use this lock to lazily allocate memslot rmaps for x86.

Here there should be a blurb about the possible races that can happen 
and why we decided for the slots_arch_lock.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   include/linux/kvm_host.h |  9 +++++++++
>   virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++-----
>   2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8895b95b6a22..2d5e797fbb08 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -472,6 +472,15 @@ struct kvm {
>   #endif /* KVM_HAVE_MMU_RWLOCK */
>   
>   	struct mutex slots_lock;
> +
> +	/*
> +	 * Protects the arch-specific fields of struct kvm_memory_slots in
> +	 * use by the VM. To be used under the slots_lock (above) or in a
> +	 * kvm->srcu read cirtical section where acquiring the slots_lock
> +	 * would lead to deadlock with the synchronize_srcu in
> +	 * install_new_memslots.
> +	 */

I think usage under slots_lock need not be mentioned here.  More like this:

	/*
	 * Protects the arch-specific fields of struct kvm_memory_slots
	 * in use by the VM.  Usually these are initialized by
	 * kvm_arch_prepare_memory_region and then protected by
	 * kvm->srcu; however, if they need to be initialized outside
	 * kvm_arch_prepare_memory_region, slots_arch_lock can
	 * be used instead as it is also held when calling
	 * kvm_arch_prepare_memory_region itself.  Note that using
	 * slots_lock would lead to deadlock with install_new_memslots,
	 * because it is held during synchronize_srcu:
	 *
	 *	idx = srcu_read_lock(&kvm->srcu);
	 *	mutex_lock(&kvm->slots_lock);
	 *				mutex_lock(&kvm->slots_lock);
	 *				synchronize_srcu(&kvm->srcu);
	 */

(Though a better place for this is in 
Documentation/virtual/kvm/locking.rst).

Paolo

> +	struct mutex slots_arch_lock;
>   	struct mm_struct *mm; /* userspace tied to this vm */
>   	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>   	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c8010f55e368..97b03fa2d0c8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -908,6 +908,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	mutex_init(&kvm->lock);
>   	mutex_init(&kvm->irq_lock);
>   	mutex_init(&kvm->slots_lock);
> +	mutex_init(&kvm->slots_arch_lock);
>   	INIT_LIST_HEAD(&kvm->devices);
>   
>   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> @@ -1280,6 +1281,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>   	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
>   
>   	rcu_assign_pointer(kvm->memslots[as_id], slots);
> +
> +	/* Acquired in kvm_set_memslot. */
> +	mutex_unlock(&kvm->slots_arch_lock);
> +
>   	synchronize_srcu_expedited(&kvm->srcu);
>   
>   	/*
> @@ -1351,6 +1356,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>   	struct kvm_memslots *slots;
>   	int r;
>   
> +	/* Released in install_new_memslots. */
> +	mutex_lock(&kvm->slots_arch_lock);
> +
>   	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>   	if (!slots)
>   		return -ENOMEM;
> @@ -1364,10 +1372,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>   		slot->flags |= KVM_MEMSLOT_INVALID;
>   
>   		/*
> -		 * We can re-use the old memslots, the only difference from the
> -		 * newly installed memslots is the invalid flag, which will get
> -		 * dropped by update_memslots anyway.  We'll also revert to the
> -		 * old memslots if preparing the new memory region fails.
> +		 * We can re-use the memory from the old memslots.
> +		 * It will be overwritten with a copy of the new memslots
> +		 * after reacquiring the slots_arch_lock below.
>   		 */
>   		slots = install_new_memslots(kvm, as_id, slots);
>   
> @@ -1379,6 +1386,17 @@ static int kvm_set_memslot(struct kvm *kvm,
>   		 *	- kvm_is_visible_gfn (mmu_check_root)
>   		 */
>   		kvm_arch_flush_shadow_memslot(kvm, slot);
> +
> +		/* Released in install_new_memslots. */
> +		mutex_lock(&kvm->slots_arch_lock);
> +
> +		/*
> +		 * The arch-specific fields of the memslots could have changed
> +		 * between releasing the slots_arch_lock in
> +		 * install_new_memslots and here, so get a fresh copy of the
> +		 * slots.
> +		 */
> +		kvm_copy_memslots(__kvm_memslots(kvm, as_id), slots);
>   	}
>   
>   	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> @@ -1394,8 +1412,11 @@ static int kvm_set_memslot(struct kvm *kvm,
>   	return 0;
>   
>   out_slots:
> -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		slot = id_to_memslot(slots, old->id);
> +		slot->flags &= ~KVM_MEMSLOT_INVALID;
>   		slots = install_new_memslots(kvm, as_id, slots);
> +	}
>   	kvfree(slots);
>   	return r;
>   }
> 

