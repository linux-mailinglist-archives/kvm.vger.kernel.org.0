Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15B79EE41
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 18:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjIMQ3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 12:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjIMQ3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 12:29:02 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA390
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:28:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b50b45481so25297b3.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694622537; x=1695227337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTzciLAK1rHaLd0gWzMb/fWg9Lw/LcXOlDJsQ/Mdv44=;
        b=l4uOP3MY34hzAUeOFJRXJSa4hc4X+OKjFiAf3+yOoxNVo4Rw0QwAFImWyXdQmTLVfD
         XWoYg0Ld3mi2akEqFtf8B9f9Muzn526V9HZJZ7VYhQF66Sy67eFXO1Ff8KxveH79ng2v
         oMTx5HB/F9K6d0zkjZke5o0xvieu7YvP7hGXwr+xpkl9hl4VQ0y27D9G/rI6UN/9c0pq
         B4hU5ZWL/J3Ro4qEs3uUnJSPHWcdX4OlUjCE8K3o376ixNnwRmBokA2iEnUjiHYQl5mC
         LIe+nAmd76ITkUaRgptmNFBrf5vQKlUkG6FoV7btwXNaV8Z39UB3/J+O4/KZ1iQzRfIC
         cvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694622537; x=1695227337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTzciLAK1rHaLd0gWzMb/fWg9Lw/LcXOlDJsQ/Mdv44=;
        b=epAZuA66yacBh/64hac9MR7PbtgJ6J+auBAWhH+T7fVUJatv+mwOw4fUJNF2zTNtqp
         91QQ+h834hjWa6U3Xj/euKL5C20FmS3403ePicPu9j+6JtHNppstqeRX4pWPnvF749BP
         K6QqVMyGeNrbIqLOgrSPAw4XyZ91npWt2GO5GDRI+f/7E4A4FSXbvEFR66pi/nPfIciv
         tBiU8g0EriJ+KvsM8sI+/QP7vo18ngkbcmyaCXs+OJiYPOuHc6tftjpG7scyPjfvgDVL
         ki1KVKoHjRF2hI3KrCFBVQSvBP4uNurnc+mte6bXke2aSJDREIBTcJJkySn86FgONh3c
         cO8A==
X-Gm-Message-State: AOJu0YzQELiHZW0b1HMduReHnimXg8omK7RAFcaHoToTDdphC0b9YV/O
        g3VjGcWKDRWVTRnzL5Vt7poX1PfP2cY=
X-Google-Smtp-Source: AGHT+IF46GoZBpBu9T03PtWbv2UJpHn9Ww4IDx0PCBEgrZzLs7mJmzm5VD2skhuBuxBH34J0c2R8ha4gffg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8210:0:b0:d7e:8dee:7813 with SMTP id
 q16-20020a258210000000b00d7e8dee7813mr66802ybk.8.1694622537338; Wed, 13 Sep
 2023 09:28:57 -0700 (PDT)
Date:   Wed, 13 Sep 2023 09:28:55 -0700
In-Reply-To: <d6601227769ec82eed95270053ef58e13c2c0a09.1694599703.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1694599703.git.isaku.yamahata@intel.com> <d6601227769ec82eed95270053ef58e13c2c0a09.1694599703.git.isaku.yamahata@intel.com>
Message-ID: <ZQHjR8ZAwRUJGDzi@google.com>
Subject: Re: [RFC PATCH 2/6] KVM: guestmem_fd: Make error_remove_page callback
 to unmap guest memory
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, isaku.yamahata@intel.com wrote:
> @@ -316,26 +316,43 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
>  	end = start + thp_nr_pages(page);
>  
>  	list_for_each_entry(gmem, gmem_list, entry) {
> +		struct kvm *kvm = gmem->kvm;
> +
> +		KVM_MMU_LOCK(kvm);
> +		kvm_mmu_invalidate_begin(kvm);
> +		KVM_MMU_UNLOCK(kvm);
> +
> +		flush = false;
>  		xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> -			for (gfn = start; gfn < end; gfn++) {
> -				if (WARN_ON_ONCE(gfn < slot->base_gfn ||
> -						gfn >= slot->base_gfn + slot->npages))
> -					continue;
> -
> -				/*
> -				 * FIXME: Tell userspace that the *private*
> -				 * memory encountered an error.
> -				 */
> -				send_sig_mceerr(BUS_MCEERR_AR,
> -						(void __user *)gfn_to_hva_memslot(slot, gfn),
> -						PAGE_SHIFT, current);
> -			}
> +			pgoff_t pgoff;
> +
> +			if (WARN_ON_ONCE(end < slot->base_gfn ||
> +					 start >= slot->base_gfn + slot->npages))
> +				continue;
> +
> +			pgoff = slot->gmem.pgoff;
> +			struct kvm_gfn_range gfn_range = {
> +				.slot = slot,
> +				.start = slot->base_gfn + max(pgoff, start) - pgoff,
> +				.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
> +				.arg.page = page,
> +				.may_block = true,
> +				.memory_error = true,

Why pass arg.page and memory_error?  There's no usage in this mini-series, and no
explanation of what arch code would do the information.  And I can't think of why
arch would need to do anything but zap the SPTEs.  If the memory error is directly
related to the current instruction, the vCPU will fault on the zapped SPTE, see
-HWPOISON, and exit to userspace.  If the memory is unrelated, then the delayed
notification is less than ideal, but not fundamentally broken, e.g. it's no worse
than TDX's behavior of not signaling #MC until a poisoned cache line is actually
accessed.

I don't get arg.page in particular, because having the gfn should be enough for
arch code to take action beyond zapping SPTEs.

And _if_ we want to communicate the error to arch code, it would be much better
to add a dedicated arch hook instead of piggybacking kvm_mmu_unmap_gfn_range()
with a "memory_error" flag. 

If we just zap SPTEs, then can't this simply be?

  static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
  {
	struct list_head *gmem_list = &mapping->private_list;
	struct kvm_gmem *gmem;
	pgoff_t start, end;

	filemap_invalidate_lock_shared(mapping);

	start = page->index;
	end = start + thp_nr_pages(page);

	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_begin(gmem, start, end);

	/*
	 * Do not truncate the range, what action is taken in response to the
	 * error is userspace's decision (assuming the architecture supports
	 * gracefully handling memory errors).  If/when the guest attempts to
	 * access a poisoned page, kvm_gmem_get_pfn() will return -EHWPOISON,
	 * at which point KVM can either terminate the VM or propagate the
	 * error to userspace.
	 */

	list_for_each_entry(gmem, gmem_list, entry)
		kvm_gmem_invalidate_end(gmem, start, end);

	filemap_invalidate_unlock_shared(mapping);

	return MF_DELAYED;
  }
