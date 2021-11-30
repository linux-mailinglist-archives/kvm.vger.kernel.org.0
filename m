Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E6846294D
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 01:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhK3AyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 19:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234671AbhK3AyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 19:54:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FD5C061714
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:50:58 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y7so13595339plp.0
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BvlrlpvLS+wO1SpCBrIGy3bzje0w6KEO+wvf2ZWolA4=;
        b=Tnx6q0DtDS5CfKVdoeypM51vfdyAOg4aeM+pob5O1XAp2ctU+wZDeSToTgXlkC/IAv
         3bQRDXsdxUgFI+PlxVkAizwWKFmzDFlGN+6qPEfc8umdi80odqHbNy+I/UCbzpaKKCE/
         9dSPnoLwEhKY8afPXOh99SuXxyJZEfyziQ0haZeOMOVkExNpKVbZkoc6an4ZukW0Pqsj
         Uq8hlNDC0bs5MVxhk2pzSRUZBWAp+mlrmLDzyIef88X6cZKpyXLaStJVBV9aLavULkse
         hvybF/LjpGnSOJ0TBxpktPgc2IxE0QO3FFUnNdisgFEv/wJS6kzQgE4EQ+ZcuwZIJkTH
         9cOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BvlrlpvLS+wO1SpCBrIGy3bzje0w6KEO+wvf2ZWolA4=;
        b=bSM+LzuiTBH5odZtqn8xGeq/VdLgGJzdnMOsi9oAaJq1j5E7wcZz7q3YfrAWVr66+T
         n6mFAqkX+8qCZ+BKHGP7BmB9TsqV6f70ChJv3Nfx2M4rZCxQ+jAnZj3lfbp3CJ2vGWEJ
         ZvGsSKD0HDhWUNqgGJJxYnGNZyN5Tk0P12E2GWNCkoloKzHp5CGdn6kde75kkcWINT9X
         ezHiFkX3HQxAeQNLH7yCXmc8EvqO3IDLf2vHQVfHImfhsxmEQllMJcuumzpJCcI6OUZx
         jQzRkwPW9ZHB8vIXA+XwjWFLLQZmq8WAIeymijOz7+QZ042ZQx7KlJ3NUsZufY1iVycv
         3z4g==
X-Gm-Message-State: AOAM533iDoPldEAE3UTjQ6gMyxq94lJTIcCdJZv/f7aYdbpI8IkCpUTg
        k+DjT/DzdoXW/MgSUkSaJmOcZA==
X-Google-Smtp-Source: ABdhPJxBG/77Ywj6PfZ0ky0jIXPlQXcYLGaRVVrQ+L1GfNiWZ7uf6bICgM9VHp4dxmnko94i6/DLvA==
X-Received: by 2002:a17:902:9a09:b0:142:82e1:6cff with SMTP id v9-20020a1709029a0900b0014282e16cffmr65087332plp.47.1638233457569;
        Mon, 29 Nov 2021 16:50:57 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id mg17sm459179pjb.17.2021.11.29.16.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:50:56 -0800 (PST)
Date:   Tue, 30 Nov 2021 00:50:53 +0000
From:   David Matlack <dmatlack@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] Revert "KVM: x86/mmu: Don't step down in the TDP
 iterator when zapping all SPTEs"
Message-ID: <YaV1bdqpFGGrjUYM@google.com>
References: <20211124214421.458549-1-mizhang@google.com>
 <20211124214421.458549-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124214421.458549-2-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 09:44:20PM +0000, Mingwei Zhang wrote:
> Not stepping down in TDP iterator in `zap_all` case avoids re-reading the
> non-leaf SPTEs, thus accelerates the zapping process . But when the number
> of SPTEs is too large, we may run out of CPU time and causes a RCU stall
> warnings in __handle_changed_pte() in the context of zap_gfn_range().
> 
> Revert this patch to allow eliminating RCU stall warning using a two-phase
> zapping for `zap_all` case.
> 
> This reverts commit 0103098fb4f13b447b26ed514bcd3140f6791047.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: David Matlack <dmatlack@google.com>
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..89d16bb104de 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -706,12 +706,6 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	bool zap_all = (start == 0 && end >= max_gfn_host);
>  	struct tdp_iter iter;
>  
> -	/*
> -	 * No need to try to step down in the iterator when zapping all SPTEs,
> -	 * zapping the top-level non-leaf SPTEs will recurse on their children.
> -	 */
> -	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
> -
>  	/*
>  	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
>  	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> @@ -723,8 +717,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  
>  	rcu_read_lock();
>  
> -	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -				   min_level, start, end) {
> +	tdp_root_for_each_pte(iter, root, start, end) {
>  retry:
>  		if (can_yield &&
>  		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog
> 
