Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4512A77D25D
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbjHOStQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239467AbjHOStH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:49:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DAD2115
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:48:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c647150c254so11179410276.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692125254; x=1692730054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IjanVbrUMhrzmrO2ieGuBSxwDyIiKDAfcGb9QHiKNFU=;
        b=TsvJKXwPJdVSxmNGIdGoKnAwGhpu0zvIhXbbmcsoIYFlb/YDD+uO9TK6gk+zbSLgQF
         BVMezNTDqp1HfY8fYInHALG/tqd+0gUZ6Mtr9P1QquqGEtQ8DjHkN4do0f9Fsypt9zQ/
         Xe3F/MVyOucimzCb/4Y+f0P3pQDbU6FOYaJkttmlxE2ENNl/vs3PYXBaTPIXjOZWe2wX
         8WTRNjmIqVhVX4TzYn8o8+Q+u2dG4k9o1YaD8o/MXSyzx2F8tNcQsuzSEKOG3J0l5L2p
         78VL9PZyBUDjANXX/u/bisTDv+czme2vD4f8VdvE2Uk+ZI/pZ2gNOhNnBwZTDu1XbXDN
         I5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692125254; x=1692730054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjanVbrUMhrzmrO2ieGuBSxwDyIiKDAfcGb9QHiKNFU=;
        b=FMKiJa2UuCaIOVbLt+pqqcRlkNJrIVxQVQefGEn6NANrbpxAVuLHdn/mBKV+nkH1EY
         vfWUDrqIUXJ9qGjjGJlHzWEsrzHcCkAZjBTS/ExMjvQuJF3Iqi8ehrmgRiI26XWCUxDK
         ELtTxZeUQ/J9+P2nKKFQX2z14wtmso7jz94GpYgKeCD3aAQJiqLSZx+kYuRlzYt+OgN5
         lvfhX1IdCXWapNUmf6jKWoOP9Gf0KKyiEFg5dvryyZg3FmScb5rwN3q+/VPhoLKBBavU
         eE3yDxzGqVeJOJ0VrmyRCj/tT/C062Gfo0+Dacy+k+EiYOqY1qwsegCaXqaUuG3zVsXU
         czLw==
X-Gm-Message-State: AOJu0YwTianJVCQvGIlqsnWrpLwuYYHCfrNHljGcEIhHdSZZNu3yWwiY
        k6nxFS4jdNRiTc2S+2eLEmTeGETzTm8=
X-Google-Smtp-Source: AGHT+IF1YcH9E5OROeFV7jjvbFJ/voNIA7YXRwiO1H+WBqOi5Hv5hCum5I0e4frBfchazdIsSVhLmjTT0sY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abcd:0:b0:d1c:57aa:d267 with SMTP id
 v71-20020a25abcd000000b00d1c57aad267mr43173ybi.5.1692125254736; Tue, 15 Aug
 2023 11:47:34 -0700 (PDT)
Date:   Tue, 15 Aug 2023 11:47:33 -0700
In-Reply-To: <20230815114448.14777-1-natiqk91@gmail.com>
Mime-Version: 1.0
References: <20230815114448.14777-1-natiqk91@gmail.com>
Message-ID: <ZNvIRS/YExLtGO2B@google.com>
Subject: Re: [PATCH] kvm/mmu: fixed coding style issues
From:   Sean Christopherson <seanjc@google.com>
To:     Mohammad Natiq Khan <natiqk91@gmail.com>
Cc:     tglx@linutronix.de, bp@alien8.de, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please use get_maintainers.pl, KVM x86 has its own maintainers.

On Tue, Aug 15, 2023, Mohammad Natiq Khan wrote:
> Initializing global variable to 0 or false is not necessary and should
> be avoided. Issue reported by checkpatch script as:
> ERROR: do not initialise globals to 0 (or false).
> Along with some other warnings like:
> WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Sorry, but no.

First and foremost, don't pack a large pile of unrelated changes into one large
patch, as such a patch is annoyingly difficult to review and apply, e.g. this will
conflict with other in-flight changes.

Second, generally speaking, the value added by cleanups like this aren't worth
the churn to the code, e.g. it pollutes git blame.

Third, checkpatch is not the ultimately authority, e.g. IMO there's value in
explicitly initializing nx_huge_pages_recovery_ratio to zero because it shows
that it's *intentionally* zero for real-time kernels.

I'm all for opportunistically cleaning up existing messes when touching adjacent
code, or fixing specific issues if they're causing actual problems, e.g. actively
confusing readers.  But doing a wholesale cleanup based on what checkpatch wants
isn't going to happen.

> Signed-off-by: Mohammad Natiq Khan <natiqk91@gmail.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 105 +++++++++++++++++++++--------------------
>  1 file changed, 53 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..8d6578782652 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -64,7 +64,7 @@ int __read_mostly nx_huge_pages = -1;
>  static uint __read_mostly nx_huge_pages_recovery_period_ms;
>  #ifdef CONFIG_PREEMPT_RT
>  /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
> -static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
> +static uint __read_mostly nx_huge_pages_recovery_ratio;
>  #else
>  static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
>  #endif
> @@ -102,7 +102,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>   * 2. while doing 1. it walks guest-physical to host-physical
>   * If the hardware supports that we don't need to do shadow paging.
>   */
> -bool tdp_enabled = false;
> +bool tdp_enabled;
>  
>  static bool __ro_after_init tdp_mmu_allowed;
>  
> @@ -116,7 +116,7 @@ static int tdp_root_level __read_mostly;
>  static int max_tdp_level __read_mostly;
>  
>  #ifdef MMU_DEBUG
> -bool dbg = 0;
> +bool dbg;
>  module_param(dbg, bool, 0644);
>  #endif
>  
> @@ -161,7 +161,7 @@ struct kvm_shadow_walk_iterator {
>  	hpa_t shadow_addr;
>  	u64 *sptep;
>  	int level;
> -	unsigned index;
> +	unsigned int index;
>  };
