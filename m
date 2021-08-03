Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3433DE7DC
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhHCIFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234284AbhHCIFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627977932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxnQE2WVmECrhGq13KVpNmk6/7w29QFo2jlDs2AIzIg=;
        b=UGJllsq0hvqduSjD3vAHem1Ynf48t+Mmz2yHHJ/8FYO2gcRU8y/pwsaAuZLLBiKAk4MqOJ
        WPxXuEYB6F2TSDqw3RJIeqYOc8DUTb9DjyKo4/Yv1e3BkIVWOdMobLTdUCf2oq2u3/aiKz
        vvQKyiwAjSXmfZH+V/Be+F53ApbkcQ0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-x_c30zerOci0prEjfzBqMA-1; Tue, 03 Aug 2021 04:05:30 -0400
X-MC-Unique: x_c30zerOci0prEjfzBqMA-1
Received: by mail-wr1-f69.google.com with SMTP id l7-20020a5d48070000b0290153b1557952so7301514wrq.16
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 01:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxnQE2WVmECrhGq13KVpNmk6/7w29QFo2jlDs2AIzIg=;
        b=Rmh6rCRQFPlStshbSjtsPKnRq137Wzz+Ok9B4M1ZPGbRvHca6INDUtve8NELra02QX
         UT7LmhS6BYFBxFtfYC2/Us2mgNLdA1HnjtaSpNv3mMuwRHCjb519X2fhU/Lc31ftmQYT
         7nFmXt70ItpffWTTcnhTE2BZQ0osFZQb3uAPKnFvjawqImz1vjwjByM727lVlnpsu/Md
         QvGZkdxgZz87ivl88sXy897rHsmIoRcXJXyjjooLZ1S81bh15XlUL2wdtqPPl8RZj15C
         CCIpLbH0pEv+UrVjNW42lFdDcmiXoABmJSISx4v2ngDobGPkL/BOk1kcc5grKzo58z2f
         t6UA==
X-Gm-Message-State: AOAM532duB+O9qkoIfGL2xoOp8NjkXfJMnCDBn8xAqHMdXRXyRONeoHd
        FvPn7kqSiHFpxeTLm4n2zKhJ7yTeBSiambWRYTrjQm41WVQIvJtA7oJ7GHf23wg+F/asgkqFbBj
        0zA/TBwtra30t
X-Received: by 2002:a05:600c:1c11:: with SMTP id j17mr11601414wms.35.1627977929619;
        Tue, 03 Aug 2021 01:05:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqmpznTYdkL70mz0iYCwLD0K/J85zW6a/vQKFKRpN9Gaae5SNV/Z2XDyKV2HqTuL/aGGHBkA==
X-Received: by 2002:a05:600c:1c11:: with SMTP id j17mr11601390wms.35.1627977929414;
        Tue, 03 Aug 2021 01:05:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q63sm2172093wme.36.2021.08.03.01.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:05:28 -0700 (PDT)
Subject: Re: [PATCH v3 01/12] Revert "KVM: x86/mmu: Allow zap gfn range to
 operate under the mmu read lock"
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <14a0d715-d059-3a85-a803-63d9b0fb790f@redhat.com>
Date:   Tue, 3 Aug 2021 10:05:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> This together with the next patch will fix a future race between
> kvm_zap_gfn_range and the page fault handler, which will happen
> when AVIC memslot is going to be only partially disabled.
> 
> This is based on a patch suggested by Sean Christopherson:
> https://lkml.org/lkml/2021/7/22/1025

I'll also add a small note from the original message:

     The performance impact is minimal since kvm_zap_gfn_range is only called by
     users, update_mtrr() and kvm_post_set_cr0().  Both only use it if the guest
     has non-coherent DMA, in order to honor the guest's UC memtype.  MTRR and CD
     setup only happens at boot, and generally in an area where the page tables
     should be small (for CD) or should not include the affected GFNs at all
     (for MTRRs).

On top of this, I think the CD case (kvm_post_set_cr0) can be changed to use
kvm_mmu_zap_all_fast.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 19 ++++++++-----------
>   arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++-----------
>   arch/x86/kvm/mmu/tdp_mmu.h | 11 ++++-------
>   3 files changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8cdfd8d45c4..9d78cb1c0f35 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5638,8 +5638,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   	int i;
>   	bool flush = false;
>   
> +	write_lock(&kvm->mmu_lock);
> +
>   	if (kvm_memslots_have_rmaps(kvm)) {
> -		write_lock(&kvm->mmu_lock);
>   		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>   			slots = __kvm_memslots(kvm, i);
>   			kvm_for_each_memslot(memslot, slots) {
> @@ -5659,22 +5660,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   		}
>   		if (flush)
>   			kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> -		write_unlock(&kvm->mmu_lock);
>   	}
>   
>   	if (is_tdp_mmu_enabled(kvm)) {
> -		flush = false;
> -
> -		read_lock(&kvm->mmu_lock);
>   		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>   			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
> -							  gfn_end, flush, true);
> -		if (flush)
> -			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> -							   gfn_end);
> -
> -		read_unlock(&kvm->mmu_lock);
> +							  gfn_end, flush);
>   	}
> +
> +	if (flush)
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> +
> +	write_unlock(&kvm->mmu_lock);
>   }
>   
>   static bool slot_rmap_write_protect(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 43f12f5d12c0..3e0222ce3f4e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -777,21 +777,15 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>    * non-root pages mapping GFNs strictly within that range. Returns true if
>    * SPTEs have been cleared and a TLB flush is needed before releasing the
>    * MMU lock.
> - *
> - * If shared is true, this thread holds the MMU lock in read mode and must
> - * account for the possibility that other threads are modifying the paging
> - * structures concurrently. If shared is false, this thread should hold the
> - * MMU in write mode.
>    */
>   bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> -				 gfn_t end, bool can_yield, bool flush,
> -				 bool shared)
> +				 gfn_t end, bool can_yield, bool flush)
>   {
>   	struct kvm_mmu_page *root;
>   
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, shared)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
>   		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
> -				      shared);
> +				      false);
>   
>   	return flush;
>   }
> @@ -803,8 +797,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   	int i;
>   
>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn,
> -						  flush, false);
> +		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
>   
>   	if (flush)
>   		kvm_flush_remote_tlbs(kvm);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index b224d126adf9..358f447d4012 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -20,14 +20,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   			  bool shared);
>   
>   bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> -				 gfn_t end, bool can_yield, bool flush,
> -				 bool shared);
> +				 gfn_t end, bool can_yield, bool flush);
>   static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
> -					     gfn_t start, gfn_t end, bool flush,
> -					     bool shared)
> +					     gfn_t start, gfn_t end, bool flush)
>   {
> -	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
> -					   shared);
> +	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
>   }
>   static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
> @@ -44,7 +41,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   	 */
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
> -					   sp->gfn, end, false, false, false);
> +					   sp->gfn, end, false, false);
>   }
>   
>   void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> 

