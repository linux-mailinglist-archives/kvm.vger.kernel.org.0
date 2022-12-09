Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A10648B46
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 00:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLIXOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 18:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLIXOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 18:14:37 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED50852146
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 15:14:36 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r18so4505303pgr.12
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 15:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjWt06caLftDUr8Va4Y4h1LGtA5Zj5segiez9gIs88A=;
        b=bcr8Dicuab3vxBke8uhwSm18glsWJM52rBtl5b/OwBK5UhIhIVhQE7EOE5fdMUJ7qn
         VS1IiKlq3CLUle6UoWj/9xH4ktiZf1L0TscM3UC9P7bpx+96orNymQcPTReEoKBsE78e
         fZ5E1qZYzF8lxrl9eFlvkTyAZvu9c9bTGoKaypaMnO0/LwIxjoudocaHHLHmr+kh3GDc
         iwqF7ubbZUx9Ky/7ndRnsThl+mFWIKLOEPb8XpuPzKquPQ07P95bscsf8mu3DJcFepqt
         NsvUeyw1+LM5Sto3PxUUMwVMlhUx8IW2K+5cGRd+ro1bHzBCZznSDrN7sPQgCkkbdIGT
         0K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjWt06caLftDUr8Va4Y4h1LGtA5Zj5segiez9gIs88A=;
        b=uW3ErJ4lQlD4U6MG7feBIrPqee5RFq0oWWxr+ZCH5f0VoXYDx/uOf7wxXKgydOaqos
         PfDKbyYqcmH6Qj6C4R39MR3SppPhDqfLaJrbmmmbEmN4gBIKSDD2rwr8wjWUADYjJ4vy
         TGcOq3xeQ2gTuazqToVuaO+NdTQuvQxiGQhpWPSqn3K5cSx1OR/umGGQlaiSPStKQF6J
         Jlzer6vK3Nbt5bnw+RVD2f/qk8IieVofubMnHRV9dF3tjvrsyYjoeCueMNP/taD6CmU0
         la60G9Uu0wRqvX8I/WWLdjjWgrwy68ED4bHuL6dacaAY7m3nw3zCVB/97XGc2kkrcBJ/
         PVZg==
X-Gm-Message-State: ANoB5pni5RI6vMiNunAJKv+WUqTlhxzdYUs6XZ7w7DV/3A7LvxmW1CSg
        Ok324RppFLuNAbD2Kdt4lx17RA==
X-Google-Smtp-Source: AA0mqf4cAU4Kq051W70vDTA8y5JZAh5cKZn3X8Qf77p+gIcGqCOA43zYNY39mMeJxo8y9WtqjJ+vpA==
X-Received: by 2002:aa7:87ca:0:b0:56c:5e2:3064 with SMTP id i10-20020aa787ca000000b0056c05e23064mr5663001pfo.0.1670627676131;
        Fri, 09 Dec 2022 15:14:36 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id c206-20020a621cd7000000b005771d583893sm1748579pfc.96.2022.12.09.15.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 15:14:35 -0800 (PST)
Date:   Fri, 9 Dec 2022 15:14:32 -0800
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 0/7] KVM: x86/MMU: Factor rmap operations out of mmu.c
Message-ID: <Y5PBWLEXXMjcyKTS@google.com>
References: <20221206173601.549281-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 05:35:54PM +0000, Ben Gardon wrote:
> Move the basic operations for manipulating an rmap out of mmu.c, into
> their own files.

memslot_rmap_alloc() and memslot_rmap_free() from x86.c look like good
candidates to move to rmap.c as well as they are pure setup/teardown.

> 
> This is the first step in a series of series to split the Shadow MMU out of
> mmu.c. Splitting the shadow MMU out results in about a 50% reduction in line
> count of mmu.c, from ~7K to ~3.5K. The rmap operations only represent about
> 10% of the Shadow MMU but are split out first becase the are relatively
> self-contained.
> 
> This split may also help facilitate the addition of kUnit tests for rmap
> manipulation, especially the fiddly bit flag which diferentiates a direct
> pointer from a pte_list_desc.
> 
> This effort is complimentary to David Matlack's proposal to refactor
> the TDP MMU into an arch-neutral implementation because it further
> clarifies the distinction between the Shadow MMU and TDP MMU within x86.
> 
> This series contains no functional changes. It's just a direct movement
> of code from one file to another.
> 
> Whether this rmap code should stay in its own file or get merged with
> the rest of the shadow MMU code as it is factored out is open for
> debate.
> 
> Ben Gardon (7):
>   KVM: x86/MMU: Move pte_list operations to rmap.c
>   KVM: x86/MMU: Move rmap_iterator to rmap.h
>   KVM: x86/MMU: Move gfn_to_rmap() to rmap.c
>   KVM: x86/MMU: Move rmap_can_add() and rmap_remove() to rmap.c
>   KVM: x86/MMU: Move the rmap walk iterator out of mmu.c
>   KVM: x86/MMU: Move rmap zap operations to rmap.c
>   KVM: x86/MMU: Move rmap_add() to rmap.c
> 
>  arch/x86/kvm/Makefile           |   2 +-
>  arch/x86/kvm/debugfs.c          |   1 +
>  arch/x86/kvm/mmu/mmu.c          | 438 +-------------------------------
>  arch/x86/kvm/mmu/mmu_internal.h |   9 +-
>  arch/x86/kvm/mmu/rmap.c         | 368 +++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/rmap.h         | 106 ++++++++
>  6 files changed, 492 insertions(+), 432 deletions(-)
>  create mode 100644 arch/x86/kvm/mmu/rmap.c
>  create mode 100644 arch/x86/kvm/mmu/rmap.h
> 
> -- 
> 2.39.0.rc0.267.gcb52ba06e7-goog
> 
