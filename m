Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FEF5740BB
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 03:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiGNBDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 21:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiGNBDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 21:03:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692981209A
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 18:03:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q82so145544pgq.6
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 18:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iYjvT9/K+PJOYO+PKYqApFIeqrzKMwdmFTyx44M/bUw=;
        b=s9pNVCwJpiRtqZOHmC9JoqSbIHVFh0WcP6GlOiQEvWpNg9ctAYIL9TC74ZHJwDmQbr
         ujX1YfT+IVTqR8HVG+hTZliHN024gh9S9Pg203g/w/Bao0+j+IoHioLNgvk11I+ChPBk
         HBHnskhUnzqC/Gn8ign5LtntTGXrnDE107IPN5/vDkLHTKg5XJ/pfYVAF5ISWRKbRMkD
         b4xbcglZ2QBxniVLRlcKW864QEwH+3hXRWfFtaWOj9jOLSfGgLSTEhToYfsI6cPh/sfk
         HO7/3PgNobJRxm1haK+WNfLJm+yjw8/yi9baTclGMlllGg2hKHJB+0zk4WjqcoAqIKYT
         UlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iYjvT9/K+PJOYO+PKYqApFIeqrzKMwdmFTyx44M/bUw=;
        b=dY8g8yvvWq7hrKtyFTkvNgFRmFzB3gOeyK94utZitPtRTHLFCvcW9cUeEi4xfIjQ6h
         QtUVeuitAvZ2a8Z/XTsWxpP99cEjTkKIhcCB6W3gj1OiFAMAZQdXSWCvan0YBF+COZta
         w1Dwi86RkL0aAXRScx9rcaxRAtzDzETSU8tPZKeECkLdTzPQMFvI+cG9gGkz3Airhi4t
         kOA8B0OFVUn7UrdnY67qkk8KiGnAgFxCapeqt8PUZxgrYHnJkItFmUz/G7WMbwWs0sJA
         Dz2G8jVUHJf9xDdpPIhhwiMml5CKaFsvZ0s0E8KF3YrvfpUcWgNo/YCmfL6VAC3hvuy1
         U58g==
X-Gm-Message-State: AJIora/uThPQAuY7ZFxzEQRpySqWr2s7Gi8WmBLSXjooNWWfBdLcKege
        /xqZM1iJIcq/EVv78Wmpb+2Yf8GKtlWR/A==
X-Google-Smtp-Source: AGRyM1uX6QB+BfDKrubdH5R5fP1CmDIQfDrAae3pIvHrIcWjLL7rkJKM2XvtWMxxzpr6bK6W8KlqTA==
X-Received: by 2002:a62:e10d:0:b0:52a:b77e:8bd3 with SMTP id q13-20020a62e10d000000b0052ab77e8bd3mr5810419pfh.66.1657760630794;
        Wed, 13 Jul 2022 18:03:50 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g21-20020aa796b5000000b005289cade5b0sm170538pfk.124.2022.07.13.18.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 18:03:49 -0700 (PDT)
Date:   Thu, 14 Jul 2022 01:03:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <Ys9rcnyIZlUc76iG@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> KVM TDX basic feature support
> 
> Hello.  This is v7 the patch series vof KVM TDX support.
> This is based on v5.19-rc1 + kvm/queue branch + TDX HOST patch series.
> The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-KVM
> 
> Major changes from v6:
> - rebased to v5.19 base
> 
> TODO:
> - integrate fd-based guest memory. As the discussion is still on-going, I
>   intentionally dropped fd-based guest memory support yet.  The integration can
>   be found at https://github.com/intel/tdx/tree/kvm-upstream-workaround.
> - 2M large page support. It's work-in-progress.
> For large page support, there are several design choices. Here is the design options.
> Any thoughts/feedback?

Apologies, I didn't read beyond the intro paragraph.  In case something like this
comes up again, it's probably best to send a standalone email tagged RFC, I doubt
I'm the only one that missed this embedded RFC.

> KVM MMU Large page support for TDX
 
...

> * options to track private or shared
> At each page size (4KB, 2MB, and 1GB), track private, shared, or mixed (2MB and
> 1GB case). For 4KB each page, 1 bit per page is needed. private or shared.  For
> large pages (2MB and 1GB), 2 bits per large page is needed. (private, shared, or
> mixed).  When resolving KVM page fault, we don't want to check the lower-size
> pages to check if the given GPA can be a large for performance.  On MapGPA check
> it instead.
> 
> Option A). enhance kvm_arch_memory_slot
>   enum kvm_page_type {
>        KVM_PAGE_TYPE_INVALID,
>        KVM_PAGE_TYPE_SHARED,
>        KVM_PAGE_TYPE_PRIVATE,
>        KVM_PAGE_TYPE_MIXED,
>   };
> 
>   struct kvm_page_attr {
>        enum kvm_page_type type;
>   };
> 
>  struct kvm_arch_memory_slot {
>  +      struct kvm_page_attr *page_attr[KVM_NR_PAGE_SIZES];
> 
> Option B). steal one more bit SPTE_MIXED_MASK in addition to SPTE_SHARED_MASK
> If !SPTE_MIXED_MASK, it can be large page.
> 
> Option C). use SPTE_SHARED_MASK and kvm_mmu_page::mixed bitmap
> kvm_mmu_page::mixed bitmap of 1GB, root indicates mixed for 2MB, 1GB.
> 
> 
> * comparison
> A).
> + straightforward to implement
> + SPTE_SHARED_MASK isn't needed
> - memory overhead compared to B). or C).
> - more memory reference on KVM page fault
> 
> B).
> + simpler than C) (complex than A)?)
> + efficient on KVM page fault. (only SPTE reference)
> + low memory overhead
> - Waste precious SPTE bits.
> 
> C).
> + efficient on KVM page fault. (only SPTE reference)
> + low memory overhead
> - complicates MapGPA
> - scattered data structure

Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
on insertion/removal to (dis)allow hugepages as needed.

  + efficient on KVM page fault (no new lookups)
  + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
  + straightforward to implement
  + can (and should) be merged as part of the UPM series

I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
completely covered (fully shared) or not covered at all (fully private), but I'm
not 100% certain that xa_for_each_range() works the way I think it does.
