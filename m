Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BF43D7D13
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhG0SHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhG0SHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:07:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC2DC061757
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:07:40 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a20so16930852plm.0
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xO85mbXVAkhuIlD0BTn3vGMGrQMSJ8y4AWBkpip4TFw=;
        b=sDSsJ/QBszBHjIiwQfYm1NN8H5ZuOTlhZpQbyPh7Tc5xj33V6bZkDSRJfAK1wB/W7Z
         5Hp9VIrxOvjD8IzTEMM0woeqldSQidxAflw065LU1IKYvDe6HQVUEy3Chyj8nrWHognN
         +tqH8QqXXRq0g3ewtAfQGlRQ0LrshoPtkHtDjTowDZoR0f6qqkbkmUHN3ZOTqYc0VwC4
         nvUdL6gywmTKZ5DiSm201PBdG77Eqowroq1UWBohcZ7kiHgctL0rZz26Udmxgl1wh/0f
         cnEgiBrRF3eG0n9Pbv7kaiS4hxWHw7gQx99EVAdtj/f/Z8iseNMNZFIOI1sNaSHarsPQ
         5MOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xO85mbXVAkhuIlD0BTn3vGMGrQMSJ8y4AWBkpip4TFw=;
        b=aWERJt9Noc2+NzowunrJ9XJsC2lQTvD34r6PachlI/J2jLzvzkDaOL3RFccC6s2jAS
         0FLuiiKKL7/rx8fZc7fUDPobFe8HClim3NCsPsaZHe5a0bCgY863MDnredVQUZ9slHRY
         csKTu8DQdPVamwxII1aJnoz0aCaoqyt24MplMdRRyA/8etIFxwqmxREuvUKU/zaBrfqW
         AiTQgf+QYxwUSBoYqnDQGAGXkveOsj/dRwfSY0Kghr2BSNVOkdMKNzjzX49JQC0rSPlv
         SLsz8EhvSkOjVeMfz56yiZqe/XnzGtKPIfcJuLzZap9rjYTHEEDt4GDPD4uKeHXE+R2F
         xJBw==
X-Gm-Message-State: AOAM532w7LSusjJ4ycKhQvUHk6SREEGhkbSGZMlvz4VKi3BOvkEwwXZl
        /hY6K6SUwFEZkLUrBaBNKmQDBvk9ty47qg==
X-Google-Smtp-Source: ABdhPJxhFnrMamQY2miP/gYiHfv36lw9+DCW390HFFDpu0hSMP3EqrFk1pk+1xSM+KdkzLoYql4Opw==
X-Received: by 2002:a62:7c52:0:b029:329:d4c2:8820 with SMTP id x79-20020a627c520000b0290329d4c28820mr24450670pfc.59.1627409260076;
        Tue, 27 Jul 2021 11:07:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x10sm4734381pgj.73.2021.07.27.11.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:07:39 -0700 (PDT)
Date:   Tue, 27 Jul 2021 18:07:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <YQBLZ/RrBFxE4G4w@google.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021, Yu Zhang wrote:
> Hi all,
> 
>   I'd like to ask a question about kvm_reset_context(): is there any
>   reason that we must alway unload TDP root in kvm_mmu_reset_context()?

The short answer is that mmu_role is changing, thus a new root shadow page is
needed.

>   As you know, KVM MMU needs to track guest paging mode changes, to
>   recalculate the mmu roles and reset callback routines(e.g., guest
>   page table walker). These are done in kvm_mmu_reset_context(). Also,
>   entering SMM, cpuid updates, and restoring L1 VMM's host state will
>   trigger kvm_mmu_reset_context() too.
>   
>   Meanwhile, another job done by kvm_mmu_reset_context() is to unload
>   the KVM MMU:
>   
>   - For shadow & legacy TDP, it means to unload the root shadow/TDP
>     page and reconstruct another one in kvm_mmu_reload(), before
>     entering guest. Old shadow/TDP pages will probably be reused later,
>     after future guest paging mode switches.
>   
>   - For TDP MMU, it is even more aggressive, all TDP pages will be
>     zapped, meaning a whole new TDP page table will be recontrustred,
>     with each paging mode change in the guest. I witnessed dozens of
>     rebuildings of TDP when booting a Linux guest(besides the ones
>     caused by memslots rearrangement).
>   
>   However, I am wondering, why do we need the unloading, if GPA->HPA
>   relationship is not changed? And if this is not a must, could we
>   find a way to refactor kvm_mmu_reset_context(), so that unloading
>   of TDP root is only performed when necessary(e.g, SMM switches and
>   maybe after cpuid updates which may change the level of TDP)? 
>   
>   I tried to add a parameter in kvm_mmu_reset_context(), to make the
>   unloading optional:  
> 
> +void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool force_tdp_unload)
>  {
> -       kvm_mmu_unload(vcpu);
> +       if (!tdp_enabled || force_tdp_unload)
> +               kvm_mmu_unload(vcpu);
> +
>         kvm_init_mmu(vcpu);
>  }
> 
>   But this change brings another problem - if we keep the TDP root, the
>   role of existing SPs will be obsolete after guest paging mode changes.
>   Altough I guess most role flags are irrelevant in TDP, I am not sure
>   if this could cause any trouble.
>   
>   Is there anyone looking at this issue? Or do you have any suggestion?

What's the problem you're trying to solve?  kvm_mmu_reset_context() is most
definitely a big hammer, e.g. kvm_post_set_cr0() and kvm_post_set_cr4() in
particular could be reworked to do something like kvm_mmu_new_pgd() + kvm_init_mmu(),
but modifying mmu_role bits in CR0/CR4 should be a rare event, i.e. there hasn't
sufficient motivation to optimize CR0/CR4 changes.

Note, most CR4 bits and CR0.PG are tracked in kvm_mmu_extended_role, not
kvm_mmu_page_role, which adds a minor wrinkle to the logic.
