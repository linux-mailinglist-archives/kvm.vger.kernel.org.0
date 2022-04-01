Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE504EEE75
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346477AbiDANvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiDANvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 09:51:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A319B051
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 06:49:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z16so2727313pfh.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 06:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yfpCQzG8IOALuWadrELzzEoB5E7I4Kw3XzkxTPBGwT4=;
        b=UhCcGjfYmQd+1AK/eAnItTxOb8zeuQjU+hchOwES0sHbNOoHfsH3vhkEmgQQtJPmSo
         V5eAowyNNno3u0OEGR3a01SU51xZymZJHywwsZGAxUSqbU+uqfIIS92gsaszoXqob4Rx
         pkJ4cujldwxC2ppcXA0jJCk/2I7x/iYq/p2gPwz7zuxfnVKVRpedVmVob68H27YlbMcY
         1Z9AMDQaz/zp/lapJQvsr/x+rsi/qnvPVpGsdxUZGwcwJYpSFNmE9RXNQTfpNSRU/6Xb
         raySs0MJ0L5fAra5nCnCnOYXHrE4TpkVF/XkVwiYEKc6jvHfcoohpiJpqzgNEu9cuKxH
         TUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yfpCQzG8IOALuWadrELzzEoB5E7I4Kw3XzkxTPBGwT4=;
        b=g/MRCwR9It/XeGhdkicj2h7hNjAiLi1STz75INFrRJfaefErr3PHj5czQ9/Rz3tRmq
         fK+qZV6XwUjAoXT0t+QbcL3oWeOoQO5L72FY5SNJqcHJTUrnHnmDW+NE0zVaMSHU3kuu
         4odSyNk7hTzchXe0N4rXZyDdYSP7DEC1m2DnPm5/KtnfoatkfdP4yNaS54VivzaWb5YL
         7Kf557kAK+xQn9KkWT5PHgM2QffAN3nR0D46HWeAwC7l3sU/FsOUTxaAfiEgiIIbs1M4
         ZLcVm64lo/1bCwb2bhC/FgWydTj72ax+IxDNci4kaUQPACj/WPMnkIYPkgXNT9dZruZc
         ksZA==
X-Gm-Message-State: AOAM533yYgysTOrrmNNrCrjbu5ZB1HCQSwOHOzRPV8rMp2rNUhRG2c/3
        g49rITPDVfLKDwpiOAzHmpBHvw==
X-Google-Smtp-Source: ABdhPJw0blkC3x6KO8wO6rlKjirT4lus/Scv4HL0ZhzpHbhtq28Ag+vHJSM5w2ssFZgTLcl2s6ugvw==
X-Received: by 2002:a63:8f49:0:b0:398:7c41:89cb with SMTP id r9-20020a638f49000000b003987c4189cbmr14727145pgn.578.1648820969769;
        Fri, 01 Apr 2022 06:49:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w4-20020a056a0014c400b004fb0c7b3813sm3323947pfu.134.2022.04.01.06.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 06:49:29 -0700 (PDT)
Date:   Fri, 1 Apr 2022 13:49:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
Message-ID: <YkcC5cDUo7cQQyBf@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
 <YkT4bvK+tbsVDAvt@google.com>
 <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
 <YkXHtc2MiwUxpMFU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkXHtc2MiwUxpMFU@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022, Sean Christopherson wrote:
> Oof, loking at sync_page(), that's a bug in patch 1.  make_spte() guards the call
> to mark_page_dirty_in_slot() with kvm_slot_dirty_track_enabled(), which means it
> won't honor the dirty quota unless dirty logging is enabled.  Probably not an issue
> for the intended use case, but it'll result in wrong stats, and technically the
> dirty quota can be enabled without dirty logging being enabled.
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4739b53c9734..df0349be388b 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -182,7 +182,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                   "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>                   get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
> 
> -       if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
> +       if (spte & PT_WRITABLE_MASK) {
>                 /* Enforced by kvm_mmu_hugepage_adjust. */
>                 WARN_ON(level > PG_LEVEL_4K);
>                 mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);

This pseudopatch is buggy, the WARN_ON() will obviously fire.  Easiest thing would
be to move the condition into the WARN_ON.

		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));

That brings up another thing that's worth documenting: the dirty_count will be
skewed based on the size of the pages accessed by each vCPU.  I still think having
the stat always count will be useful though.
