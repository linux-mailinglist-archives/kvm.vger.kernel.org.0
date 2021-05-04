Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5C637317F
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhEDUhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhEDUhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 16:37:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD02BC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 13:36:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 10so342940pfl.1
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u5wx41z50pCB3+EhCZHMkwVSScXyhuneIJqUcIw0yxo=;
        b=X50cSRFP/zhaGlqtpXk5ERLSQ3V/fLVmzPvQ0svEtG42GKZ5bZU0Otm9tX8X16D/6R
         tH7kkO25tK5gE32+2NETMJz713wkX1slowKJj5HLN5ZLm1O9SMAKKW4eGoHHjH+/Yx6n
         GPwLScjAKKkrsQhVeJWB2s84UkF4Ahqk+/v9PPWRm+X8PsRn1jedNhyfkuvGpeP/uPQU
         flxq3h+cjEgq3FuMZuBgqOIXb9UtcANXI3RaJ0XgCMBG9EqYpLyCpQ4H8+2IL0iTdlS6
         gZouv77UQEyjiRAefIG+qoJBOUhs/ULQIcQaDR0qDKfu2rDtAFnQA8OmKZcusmOD8Swh
         sYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u5wx41z50pCB3+EhCZHMkwVSScXyhuneIJqUcIw0yxo=;
        b=JQh4OSRgVH+gCA9sb2K1H8il/DI/T6AiFRenzjRxdzd4i7Q3DW3N9iqadlv76Eje/D
         i/TL1UTYCc9vCFA/+wOtpF9PmCNJO1qAxA0fmbjvWEZ5JHZIMwkVIzoeWfSJ+lAe2Hax
         1SfRkV7TIR9HnFXKOI3UYm0CKeY2Bhqs3ObwyXryZS0hKnqLfnj+8J60WoFRlYNAAeLp
         NnAsPQTTOH8ekNjPuAaDcksCH3QOi9kAuKQYFOQ1GMqdJjLeTQBNnqUSlZNUdDVoUOkk
         kNpFTFrapDpycic7BnMsMLHYVx/NpQ7aDBCByVEOUHGlxiQbsqZ5iaLAwCwL3Me/gw9F
         +RiQ==
X-Gm-Message-State: AOAM532r0SJUWnmRB7nPz2nk3VLRWPjfaLSgbXMPybBpgE3vRkvJmr+b
        HRF3Fd4Z/hvzvmCnL9QTvTAKcw==
X-Google-Smtp-Source: ABdhPJyED65rMQLUeYEl+sOxFJ98lFAokv9/xtsH+mYINfeH+YUCj0/ep3IgwticVbBLKeZPTFNnpg==
X-Received: by 2002:a63:5757:: with SMTP id h23mr7111744pgm.279.1620160574215;
        Tue, 04 May 2021 13:36:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v123sm12979793pfb.80.2021.05.04.13.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:36:13 -0700 (PDT)
Date:   Tue, 4 May 2021 20:36:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
Message-ID: <YJGwOfzTtj4kJIVp@google.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-2-bgardon@google.com>
 <YJGmpOzaFy9E0f5T@google.com>
 <edfadb98-b86e-6d03-bdfc-9025fac73dee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edfadb98-b86e-6d03-bdfc-9025fac73dee@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021, Paolo Bonzini wrote:
> On 04/05/21 21:55, Sean Christopherson wrote:
> > But, I think we we can avoid bikeshedding by simply eliminating this flag.  More
> > in later patches.
> 
> Are you thinking of checking slot->arch.rmap[0] directly?  That should work
> indeed.
> 
> > > -	kvm_mmu_init_tdp_mmu(kvm);
> > > +	if (!kvm_mmu_init_tdp_mmu(kvm))
> > > +		activate_shadow_mmu(kvm);
> > Doesn't come into play yet, but I would strongly prefer to open code setting the
> > necessary flag instead of relying on the helper to never fail.
> > 
> 
> You mean
> 
> kvm->arch.shadow_mmu_active = !kvm_mmu_init_tdp_mmu(kvm);
> 
> (which would assign to alloc_memslot_rmaps instead if shadow_mmu_active is
> removed)?  That makes sense.

Ya, that or:

	if (kvm_mmu_init_tdp_mmu(kvm))
		kvm->arch.memslots_have_rmaps = true;

I don't have a preference between the two variants.
