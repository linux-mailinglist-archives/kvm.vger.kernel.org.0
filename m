Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0193543A04
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiFHROY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiFHRN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:13:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9BE409690
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 09:59:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id o17so18160534pla.6
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 09:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LbXNGVnOGcI6pNV/PZPgBa9EbqYKOR4Vcohf+fzYq6o=;
        b=PM5jtZTIX2D1KVZwWkB1YlxM1zgKIAqdPSIGrJuaaY4iIh+4njJIFhdKAfWXekY1oK
         6vlpLiTUGgDpQtG0gVpWWsoPke2BdvhdXdM1j5PlMufucTKdSt4grH/6OLEjU5O+b9ZR
         gtAUNbj9S2ffHy19XGi5rP+qE0K/1Tlpvy1rjgCSSutDozg16xNda6il4e8qXNj7EEs5
         b4MWPiDy3bRZzvxN4CC1sQQtTsJ3sq2YgRn6mI/aoCNtSUu9NpCNqecgsT7f7m60hm1d
         l+0UihAYH3GVwSZVT2Hngp6K9VuYDqNWTLm3pDpzs75BJvHFXIBohxHaprxc0Y++WB7B
         xs/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LbXNGVnOGcI6pNV/PZPgBa9EbqYKOR4Vcohf+fzYq6o=;
        b=OdO/KgvhVQNF66cLuUpHjzJRYOS1JDGFukS3Dn0NxbJz6Ah8FMrwMr02vpBEAP1N2J
         8dZZuTdWm3yKCeSCZrezHZ9pPTMuVEkWwsT5jQPXEhQ3W9u6wFJtyHKkUxUkREKysnMR
         th37DGfPQWbQ3Qgd3B1lSKSmNJEnwDreZ+J7gLivNnGhxRZsCazvBGnUN9/FQbBVxAkg
         HBvlpxEekj2iqYEeph0W/uUwddfmhjEQ76Uj+f55VznEQw7uFPKngsd8dmbWHfP+CAXD
         MlcRoeTn2ek560o4MiL2eF+bcXQjaBtQNwG8zBgGn5I9p4yShPiBixfaPD0lJdUlj+Ix
         hplA==
X-Gm-Message-State: AOAM533FmtN4A2qutknA3E9hm+sXqwYBSOcZbtIWPkmUrAkc4FjJkVwg
        YxCURJipQzL8nPY4iqWyhyC+Yg==
X-Google-Smtp-Source: ABdhPJzkQT3XPFSX17TAbUOhNnNHrxgrfxZ7l70ef1pM8bmDY1LAcQhbqRRYnIHklFMwxCrBLupp4g==
X-Received: by 2002:a17:90a:e58a:b0:1e2:fe75:dd5f with SMTP id g10-20020a17090ae58a00b001e2fe75dd5fmr161306pjz.138.1654707552006;
        Wed, 08 Jun 2022 09:59:12 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id h21-20020a170902f7d500b001637997d0d4sm14913744plw.206.2022.06.08.09.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:59:11 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:59:07 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 0/6] KVM: Trivial cleanups
Message-ID: <YqDVW81B1q0EXkfh@google.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022 at 02:34:11PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> A small collection of trivial cleanups.

Nice cleanups. My only feedback is on the commit messages, which are a
bit terse. Here's what I would recommend:

 - Explain what the commit does in the first sentence/paragraph of the
   commit message and then explain why/background info.

 - Include "No functional change intended." for commits that are
   expected to be no-ops. It's pretty obvious for most of these changes
   but it's still nice that have to convey your intent.

Commit messages aside:

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> Lai Jiangshan (6):
>   KVM: X86/MMU: Remove unused macros from paging_tmpl.h
>   KVM: X86/MMU: Remove unused PT32_DIR_BASE_ADDR_MASK from mmu.c
>   KVM: X86/MMU: Update comments in paging_tmpl.h for the kinds of guest
>     PTEs
>   KVM: Rename ack_flush() to ack_kick()
>   KVM: X86/MMU: Remove useless mmu_topup_memory_caches() in
>     kvm_mmu_pte_write()
>   KVM: X86/SVM: Use root_level in svm_load_mmu_pgd()
> 
>  arch/x86/kvm/mmu/mmu.c         |  9 ---------
>  arch/x86/kvm/mmu/paging_tmpl.h | 16 ++--------------
>  arch/x86/kvm/svm/svm.c         |  2 +-
>  virt/kvm/kvm_main.c            |  4 ++--
>  4 files changed, 5 insertions(+), 26 deletions(-)
> 
> -- 
> 2.19.1.6.gb485710b
> 
