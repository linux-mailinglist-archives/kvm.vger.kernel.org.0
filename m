Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C862392202
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 23:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhEZV0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 17:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhEZV0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 17:26:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E77AC061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:25:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z4so1266550plg.8
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WVc6rrn4ix7kzoqkUAe/JbStIipNPKiFqHZ5BsMtVeo=;
        b=ZoRVc9oN4oNPKm6vjIAUPW0PzVTj4Nvxi4/+CjDSVOTPFV9F+9Nb8cusOtcjxx/UME
         yABMRA4bu2vX6q0/SBRHFLozQESmq6u8WhynmHwImFViPpw/4LrFLvuzNZIuC+Ov75bw
         sDxtW2JvlTwGtcraiLi408RVMttNHqf5tlVMG7S9zRRYQxNCWoh7KGsHZT2t+qSpgPv3
         LpMv1bp1WrtJKPRasXxJ04gcA3bF0pp46KYjAlq+c8B8W3oNL36kIn0MUDDQBhqVLZ0q
         Q3GfEZgPCOtVrAPid5irXC13Y09I1ZxFD6xOavl5xzxx/SwAJpcez6P5bvBSLOv1QAZa
         WbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WVc6rrn4ix7kzoqkUAe/JbStIipNPKiFqHZ5BsMtVeo=;
        b=qZG4UBEDG4MQXdFO9SPtTAw9MidBweYRgDz18Ib5BRSEWjAD92MkAuUMOvr349jkTH
         r8HCcehH9CDjSXZGAyhT6vlx0m9cfhBsSKfmpZG3ixKrcpdlQ5xsq7pJD8aFRBJdMq9b
         ddcPkyK14uR3TjDbfDbIz39CK/I2I5zwQ6ZltAEDCD/tHOPLZEbbJBaxr9MjNUaXYnvc
         IdGzJrf5n1mk3TIInNXhCWCln40dzmR5vxPNPKZEtXM0vm8upbba4evRUazwGjd3ZGuJ
         SwXGFDamqzmY2aiqBMQpsaTXFriGv7rijkDfpT9SQr49wb46X9pNXUujZFmVhmiHvgxp
         l0Rw==
X-Gm-Message-State: AOAM533rOfrYXmpcsSfp+ir22uzrvgD9774oMjh7wORH4eFnX85IHBPr
        oKb3Ksprsqeq9CNK8ADZd+q3Hw==
X-Google-Smtp-Source: ABdhPJzE1Bi0PAdIhkNUKqEOZDKNbG0v5wgFpWssPQYy0i0Y03qVcKMKLtsZ9Q848HNHzI9YNwhX7Q==
X-Received: by 2002:a17:90b:f95:: with SMTP id ft21mr147436pjb.215.1622064308427;
        Wed, 26 May 2021 14:25:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m5sm16586pgl.75.2021.05.26.14.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 14:25:07 -0700 (PDT)
Date:   Wed, 26 May 2021 21:25:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: x86/mmu: Re-add const qualifier in
 kvm_tdp_mmu_zap_collapsible_sptes
Message-ID: <YK68sDu3nBfYi10W@google.com>
References: <20210401233736.638171-1-bgardon@google.com>
 <20210401233736.638171-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401233736.638171-2-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Ben Gardon wrote:
> kvm_tdp_mmu_zap_collapsible_sptes unnecessarily removes the const
> qualifier from its memlsot argument, leading to a compiler warning. Add
> the const annotation and pass it to subsequent functions.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 10 +++++-----
>  arch/x86/kvm/mmu/mmu_internal.h |  5 +++--
>  arch/x86/kvm/mmu/tdp_mmu.c      |  5 +++--
>  arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++-
>  include/linux/kvm_host.h        |  2 +-
>  5 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efb41f31e80a..617809529987 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -715,8 +715,7 @@ static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
>   * handling slots that are not large page aligned.
>   */
>  static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
> -					      struct kvm_memory_slot *slot,
> -					      int level)
> +		const struct kvm_memory_slot *slot, int level)

I'd prefer to let this poke out (it's only 2 chars) instead of having an unaligned
param list.  And if we want to make it pretty, we could always do:

static struct kvm_lpage_info *lpage_info_slot(const struct kvm_memory_slot *slot,
					      gfn_t gfn, int level)

