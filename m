Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4277C48CFCD
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 01:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiAMAq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 19:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiAMAqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 19:46:13 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A9BC061759
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 16:46:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i6so7209816pla.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 16:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8mOixvTaKF2UFRB/W4XFJCCUrtdFyXW6KVrqOBNB+WA=;
        b=Qyd1hC8ZMDmKAA0JyfVgo40h9UkTcKo/ZPTF/tHqFQO/gqongWpeqmjNk6cNPNYEip
         ix3KaJr67em5KhOp02wEJEu79XAY8F4zzBki8LoLe5/wOzh25hrDYsh6Wqh7xOLB+adk
         y5kMOxkrwjcCWw7269B8SR8Wre9utwSawwcI9mljVNQPH4axptbWYuSIW6fBf333CO+I
         T0QVj+QSMZ5ZCp4O7eAQ+2vArjxV4PVq/nJTEm7+nZ6LLz8T7fiKxfKveZAIdyhHAoKD
         XJWFEIooxSpjI0lLMu9S+Tn5P9t30GrmzRCbtbNsVi45DL1nz1PbRCXmeEb+g0OX25+a
         3giA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8mOixvTaKF2UFRB/W4XFJCCUrtdFyXW6KVrqOBNB+WA=;
        b=WMtxCpUmKI0PB0YF5tAyL0Zs5QBrZr8Ivang40Nx4XVqasxZoxkrdaNKRQPsh87D5y
         siBTst/AOfl9EKLH8ysoCP94MGAsn+JZyPD8/T9ZKrcgCu7+C1nOb0DM7O2ae67KNokh
         bWDsM2u+naX5YpfQwdHrBGUSOekgZWrkmVD4FYEVfYxTmZmXfAhOkbpjm6XV2cwzBaou
         Q0xV7tWzxcS5GNU4Dg4iWOA9QH867UW5FxKayVgA1p0doPuXZbkbfrJgXsS1ifu95t2M
         sRvYjYfE3ZYMjFcETvuSkVLRFEHxcO+YMplhQeE05tPoySIXgkUDPK9Xne7haZgsckWM
         DekQ==
X-Gm-Message-State: AOAM5314OxVRyrMTSwWZsX26oThHvhNDADHp0k41pUzV7g2bswK0bncT
        lB/J4GKtaNq0v4CafWbHzSFvV8g0zDPvoA==
X-Google-Smtp-Source: ABdhPJx1mGmIEYnTEd2zzZ8i92GrS82/ldWZ1PQ7RUbEevI+oTPH8lomOK4bUCqHEiaqoE81aGUaIg==
X-Received: by 2002:a17:90b:180e:: with SMTP id lw14mr2413813pjb.179.1642034772233;
        Wed, 12 Jan 2022 16:46:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c20sm665863pgk.75.2022.01.12.16.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 16:46:11 -0800 (PST)
Date:   Thu, 13 Jan 2022 00:46:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Improve comment about TLB flush
 semantics for write-protection
Message-ID: <Yd92T8RoZZi6usxH@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112215801.3502286-3-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, David Matlack wrote:
> Rewrite the comment in kvm_mmu_slot_remove_write_access() that explains
> why it is safe to flush TLBs outside of the MMU lock after
> write-protecting SPTEs for dirty logging. The current comment is a long
> run-on sentance that was difficult to undertsand. In addition it was
> specific to the shadow MMU (mentioning mmu_spte_update()) when the TDP
> MMU has to handle this as well.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1d275e9d76b5..33f550b3be8f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5825,15 +5825,26 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  	}
>  
>  	/*
> -	 * We can flush all the TLBs out of the mmu lock without TLB
> -	 * corruption since we just change the spte from writable to
> -	 * readonly so that we only need to care the case of changing
> -	 * spte from present to present (changing the spte from present
> -	 * to nonpresent will flush all the TLBs immediately), in other
> -	 * words, the only case we care is mmu_spte_update() where we
> -	 * have checked Host-writable | MMU-writable instead of
> -	 * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
> -	 * anymore.
> +	 * It is safe to flush TLBs outside of the MMU lock since SPTEs are only
> +	 * being changed from writable to read-only (i.e. the mapping to host
> +	 * PFNs is not changing). 

Hmm, you mostly address things in the next sentence/paragraph, but it's more than
the SPTE being downgraded from writable => read-only, e.g. if the SPTE were being
made read-only due to userspace removing permissions, then KVM would need to flush
before dropping mmu_lock.  The qualifier about the PFN not changing actually does
more harm than good because it further suggests that writable => read-only is
somehow inherently safe.  

> +      * All we care about is that CPUs start using the
> +	 * read-only mappings from this point forward to ensure the dirty bitmap
> +	 * gets updated, but that does not need to run under the MMU lock.

"this point forward" isn't technically true, the requirement is that the flush
occurs before the memslot update completes.  Definitely splitting hairs, I mean,
this basically is the end of the memslot update, but it's an opportunity to
clarify _why_ the flush needs to happen at this point.

> +	 *
> +	 * Note that there are other reasons why SPTEs can be write-protected
> +	 * besides dirty logging: (1) to intercept guest page table
> +	 * modifications when doing shadow paging and (2) to protecting guest
> +	 * memory that is not host-writable.

So, technically, #2 is not possible.  KVM doesn't allow a memslot to be converted
from writable => read-only, userspace must first delete the entire memslot.  That
means the relevant SPTEs never transition directly from writable to !writable,
they are instead zapped entirely and "new" SPTEs are created that are read-only
from their genesis.

Making a VMA read-only also results in SPTEs being zapped and recreated, though
this is an area for improvement.  We could cover future changes in this area by
being a bit fuzzy in the wording, but I think it would be better to talk only
about the shadow paging case and thus only about MMU-writable, because Host-writable
is (currently) immutable and making it mutable (in the mmu_notifier path) will
have additional "rule" changes.

> + 	 * Both of these usecases require
> +	 * flushing the TLB under the MMU lock to ensure CPUs are not running
> +	 * with writable SPTEs in their TLB. The tricky part is knowing when it
> +	 * is safe to skip a TLB flush if an SPTE is already write-protected,
> +	 * since it could have been write-protected for dirty-logging which does
> +	 * not flush under the lock.

It's a bit unclear that the last "skip a TLB flush" snippet is referring to a
future TLB flush, not this TLB flush.

> +	 *
> +	 * To handle this each SPTE has an MMU-writable bit and a Host-writable
> +	 * bit (KVM-specific bits that are not used by hardware). These bits
> +	 * allow KVM to deduce *why* a given SPTE is currently write-protected,
> +	 * so that it knows when it needs to flush TLBs under the MMU lock.

I much rather we add this type of comment over the definitions for
DEFAULT_SPTE_{HOST,MMU}_WRITEABLE and then provide a reference to those definitions
after a very brief "KVM uses the MMU-writable bit".

So something like this?  Plus more commentry in spte.h.

	/*
	 * It's safe to flush TLBs after dropping mmu_lock as making a writable
	 * SPTE read-only for dirty logging only needs to ensure KVM starts
	 * logging writes to the memslot before the memslot update completes,
	 * i.e. before the enabling of dirty logging is visible to userspace.
	 *
	 * Note, KVM also write-protects SPTEs when shadowing guest page tables,
	 * in which case a TLB flush is needed before dropping mmu_lock().  To
	 * ensure a future TLB flush isn't missed, KVM uses a software-available
	 * bit to track if a SPTE is MMU-Writable, i.e. is considered writable
	 * for shadow paging purposes.  When write-protecting for shadow paging,
	 * KVM clears both WRITABLE and MMU-Writable, and performs a TLB flush
	 * while holding mmu_lock if either bit is cleared.
	 *
	 * See DEFAULT_SPTE_{HOST,MMU}_WRITEABLE for more details.
	 */

>  	 */
>  	if (flush)
>  		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> -- 
> 2.34.1.703.g22d0c6ccf7-goog
> 
