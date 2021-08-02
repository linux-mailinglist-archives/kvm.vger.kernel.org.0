Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F653DE2CD
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 01:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhHBXCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 19:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhHBXCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 19:02:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03469C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 16:02:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k4-20020a17090a5144b02901731c776526so1180781pjm.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 16:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XV9UPUrTxP4Ixd39NjPRpfiBzgebHxwcML8doCOTbGA=;
        b=DoSjX0xn1IFHcljzQWXaX4qWghU8BrPIkMskbzgpEDDfl7aSK2Xh6BD7FzofqDf0Fb
         XXSB5+14WKQGLAEM9cjZw9VcBF7vdJESEy73pN5jlW81JSUpwPkBWte/xpCwy++4STGk
         raWMwUz3qqV5FXUToHzQ0IC/RN6mDrnGvRiw8MSVRcvT2YrvYrnFpLDTTN7i+Pt6+aQM
         ObmhMmbx8fAmjjgH1OuXW/LFFJ6cxp3DZO9lT5IPeHg/dne6LbpWIcetzjFYTCc5726J
         E4Rwq2Yirt+31R0k0bFKUks0Cw5gCQMY7lg1tZ9OiuPPNPJRg/CNVhTzDmlESBjXjFdE
         SAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XV9UPUrTxP4Ixd39NjPRpfiBzgebHxwcML8doCOTbGA=;
        b=tt7sbhbL8hQEoUEpfy5ELQ6BH6gm3mUIm1wpLRzncnRxBwqulL3k4L4ThtDCPkMLXk
         9SgnXUIjkrHwgvWDC8GOEBOjrEee953jgveBKOhJZOjj/4WaPn++zGMc+VumCk/XzY8R
         VJrrV1pvxCI1wYJzek51v+mfuqtDlPiTZcsGxEmvB7/K/btgscJvBgs/aajqjKRtFrC9
         9hIn9c27I6qacnGTQF8FeVsq76PdwAtJ2e4wCNu1RVrL/sGHINL6Z7tHnFzKF2kf5fuH
         tVXjOdlKsUrnNsJYVco6upq4Bc+/2XFwKsM5f4Jgo/PeCQtQG9ovecq0J01srOyDZ2fx
         2F/Q==
X-Gm-Message-State: AOAM530/SH5w3AkpwaBhwsPwgBU0nFoSIuMaPTpWebbZbtZ5aJ2mxPsa
        L2DJ+aw0Uc4IxVajyVbuOLJkRQ==
X-Google-Smtp-Source: ABdhPJysL9JBlR9jcnP1/RkK0f8gbfD62Opo7zyGuEqkVHjgKUHoriTfr/2UTgA2HdkQbsaYnZAWPA==
X-Received: by 2002:a17:90a:e289:: with SMTP id d9mr19221033pjz.186.1627945329423;
        Mon, 02 Aug 2021 16:02:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z11sm3481413pfr.201.2021.08.02.16.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 16:02:08 -0700 (PDT)
Date:   Mon, 2 Aug 2021 23:02:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86/mmu: Add detailed page size stats
Message-ID: <YQh5baC5cYAuj6y0@google.com>
References: <20210730225939.3852712-1-mizhang@google.com>
 <20210730225939.3852712-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730225939.3852712-4-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021, Mingwei Zhang wrote:
> Existing KVM code tracks the number of large pages regardless of their
> sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> information becomes less useful because lpages counts a mix of 1G and 2M
> pages.
> 
> So remove the lpages since it is easy for user space to aggregate the info.
> Instead, provide a comprehensive page stats of all sizes from 4K to 512G.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Sean Christopherson <seanjc@google.com>

Looks good, but you'll probably need/want to rebase to kvm/queue once that settles
down (I suspect a forced push is coming this week).  This has quite a few conflicts
with other stuff sitting in kvm/queue.

> ---
>  arch/x86/include/asm/kvm_host.h | 10 +++++++++-
>  arch/x86/kvm/mmu.h              |  4 ++++
>  arch/x86/kvm/mmu/mmu.c          | 26 +++++++++++++-------------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 15 ++-------------
>  arch/x86/kvm/x86.c              |  7 +++++--
>  5 files changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..eb6edc36b3ed 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1206,9 +1206,17 @@ struct kvm_vm_stat {
>  	u64 mmu_recycled;
>  	u64 mmu_cache_miss;
>  	u64 mmu_unsync;
> -	u64 lpages;
>  	u64 nx_lpage_splits;
>  	u64 max_mmu_page_hash_collisions;
> +	union {
> +		struct {
> +			atomic64_t pages_4k;
> +			atomic64_t pages_2m;
> +			atomic64_t pages_1g;
> +			atomic64_t pages_512g;
> +		};
> +		atomic64_t pages[4];
> +	};

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8166ad113fb2..e4dfcd5d83ad 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -235,9 +235,12 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	STATS_DESC_COUNTER(VM, mmu_recycled),
>  	STATS_DESC_COUNTER(VM, mmu_cache_miss),
>  	STATS_DESC_ICOUNTER(VM, mmu_unsync),
> -	STATS_DESC_ICOUNTER(VM, lpages),
>  	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
> -	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> +	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> +	STATS_DESC_ICOUNTER(VM, pages_4k),
> +	STATS_DESC_ICOUNTER(VM, pages_2m),
> +	STATS_DESC_ICOUNTER(VM, pages_1g),
> +	STATS_DESC_ICOUNTER(VM, pages_512g)

Uber nit that I wouldn't even have noticed if this didn't conflict, but there's
no need to land the union and the stats definitions at the end of the structs,
i.e. the new fields can directly replace lpages.  I don't think it will actually
avoid a conflict, but it would avoid modifying the max_mmu_page_hash_collisions
line.

>  };
>  static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
>  		sizeof(struct kvm_vm_stat) / sizeof(u64));
> -- 
> 2.32.0.554.ge1b32706d8-goog
> 
