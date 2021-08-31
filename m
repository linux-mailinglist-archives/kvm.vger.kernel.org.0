Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6223FCBE1
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbhHaQz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbhHaQz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 12:55:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE989C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:55:01 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m4so11044892pll.0
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g3zlz27sKyteucB/528BvAcUO9chmggOOVd4nnMmiuM=;
        b=VwF493GaV/2+LVt8bUzv00P/21O9czn9j7u6ubk557QqAlKf6OY5YETtlz3m1Fob/n
         cG7zL12Mt7KhH6lZnA5bvD8SWim6s8L4i3K44xK6kYbEBmuBISXNkDQXs/RfZbRDKHBY
         0Tx6fyjm4yEZ+J2D86N+Be+5aBmd2p50svktx9ubzj1gGXFRG63aR+pGCIYm70nSspWo
         pz4X+K5n0sSUTlKxs3f3CpOCMXjNY2s9jB87cvnlGYPbQtpWbHQIdXFgRfUNjbHB3aEq
         H7/3j6dhWAFPUySYKIZsCCMu0IdfXMKtf0RYN4Us57mhwE7443B4H+WweSJY9jbd3KTR
         /I6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g3zlz27sKyteucB/528BvAcUO9chmggOOVd4nnMmiuM=;
        b=TdBhNtvx8EhFdL5hXkq3hQ3Z06FsjFXs+9+fyqQVoxlMV1tuBxDzAfOsa6V5kgsKlg
         dniGAR7Mm0y+XHiYcbA0FOzZSs8atMEspRj4ZCLEOqSfs+C2n74YpseAQVloY9f5DsPP
         d08PVdxAz+9CXrjEYaN/uccjlUj9CWrG2ITWIoAdnbEBxIzq3148u5UqVG392qCXe70S
         zbsyl0YIZlQO+G5VENtH898u8qN1SqENob3BH5FH/PUOdiwtY9TTQUR6npDoPYnRQ3Mt
         ZrfpfBHephqFTbyWBJE+uLvQVZBJzT8zTih35AQRaTjev3tWvex1xDjwEqoobjdNchKI
         SpLw==
X-Gm-Message-State: AOAM530ypSVH+IrPEwM/OsYyfi+6d0KZY578U2uSH+vq+UylvGfZ6EjK
        bwdBYl3nlSVtmLuJlvGqCLQpJCNAabT9yg==
X-Google-Smtp-Source: ABdhPJy1dzoqJusSjqhmNr3NDqIkYalbdAJM8U7/pkcC2vYo+ENrn4DAPwpFwAT0b8gspniyYQ5pMA==
X-Received: by 2002:a17:90a:460e:: with SMTP id w14mr6534702pjg.143.1630428901039;
        Tue, 31 Aug 2021 09:55:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w3sm3373457pjv.0.2021.08.31.09.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:55:00 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:54:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 1/2] selftests: KVM: align guest physical memory base
 address to 1GB
Message-ID: <YS5e4PGxu7tjiEBI@google.com>
References: <20210829182641.2505220-1-mizhang@google.com>
 <20210829182641.2505220-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829182641.2505220-2-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 29, 2021, Mingwei Zhang wrote:
> Existing selftest library function always allocates GPA range that aligns
> to the end of GPA address space, ie., the allocated GPA range guarantees to
> end at the last available GPA. This ends up with the fact that selftest
> programs cannot control the alignment of the base GPA. Depending on the
> size of the allocation, the base GPA may align only on a 4K based
> bounday.
> 
> The alignment of base GPA sometimes creates problems for dirty logging
> selftest where a 2MB-aligned or 1GB-aligned base GPA is needed to
> create NPT/EPT mappings for hugepages.
> 
> So, fix this issue and ensure all GPA allocation starts from a 1GB bounary
> in all architectures.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 0ef80dbdc116..96c30b8d6593 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -93,10 +93,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>  			      perf_test_args.guest_page_size;
>  	guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> -#ifdef __s390x__
> -	/* Align to 1M (segment size) */
> -	guest_test_phys_mem &= ~((1 << 20) - 1);
> -#endif
> +
> +	/* Align to 1G for all architectures */
> +	guest_test_phys_mem &= ~((1 << 30) - 1);

1gb may not be appropriate for all architectures and we don't want to _just_
test 1gb aligned memslots.  The alignment should be tied to the backing store,
even if the test is hardcoded to use THP, that way the alignment logic works
without modification if the backing store is changed.

I had a patch[1] that did this, let me go resurrect that series.  My series got
put on the backburner in favor of Yanan's series[2] which did a much better
job of identifying/handling the host virtual address alignment, but IIRC my
approach for handling GPA was correct.

[1] https://lore.kernel.org/kvm/20210210230625.550939-6-seanjc@google.com/
[2] https://lkml.kernel.org/r/20210330080856.14940-1-wangyanan55@huawei.com

> +
>  	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>  
>  	/* Add extra memory slots for testing */
> -- 
> 2.33.0.259.gc128427fd7-goog
> 
