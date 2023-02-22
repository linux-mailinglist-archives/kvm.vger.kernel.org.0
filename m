Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCE269FC4E
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 20:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBVTg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 14:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjBVTgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 14:36:25 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1F33E62A
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 11:36:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id bh1so10078516plb.11
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 11:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V4qhU8th+ijJydPdX8ro9lr6wTWHGe9n7bn1DSzNfVk=;
        b=dxz+JqKkkAN6G/9tqstRE1iv3BVsoHfm+MxEVJFvq9UILCPEbA2NMUtbAeVSYwdkdM
         76gAvXpKK3OOeoR+rU5C4AkeRRZueWgoeWI9kYxJPxcWvJXDyt8QSC2gBgKt8v55E9FC
         Caz+SSl3JHFbT4MWXeCcqqP/Hv39nd4WSUMkKUbtvfgg7GaMWSNJ1OSsY4tMKhhYtJO0
         tovoUpnBKTJCEnrQcIT6nnbc5bWaKFzpYzASEj6JMDmOLGgRKgJNRC9DHUqyVdhpSwUi
         Ggf55+uI2gDago4qagK83b9MjaO/FF9JMcoHwPIRkF/oV9grQzoYuk6GQyEV4eDuSPVa
         2/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4qhU8th+ijJydPdX8ro9lr6wTWHGe9n7bn1DSzNfVk=;
        b=bdn1d0umSLuHvdkd5/zSaOfGZWtgMN7j/1Hgk6bHjqT+Q/b6ByFaP8gAf2ba4bWIGr
         GiLVCqF7xOxY7ahZ0t9sIsxriHcckAGxgTrtzKUdB38MiOEOihsdc7lsos99A9bntP8N
         rCeyL/1OGtxzafGGWhF7FKDpiiQNBS4G5uiuXvRsutybPKPTsm/+h6OuuDHtqPlDALnZ
         xNHF7JWXdICiv6OikQIWoo8NTPvPcSOwXJFbJltmRT6bMnJYElC7tgaatLF2l2lyMMTM
         5KHV7eweJoeLgbdrw+5tclCaVc6kuiKCIbFZerQnpMqOezLPe6jYGl4Zsuuf6HDbWpfm
         JMLQ==
X-Gm-Message-State: AO0yUKVlMeqPggkkZs5miubyARluGKdE7YRzMOcRk05Eh1rRj8duhzJs
        3qiGJ6q6er+oM24ryDPDwoa4iPzKOX1ColkWIYk=
X-Google-Smtp-Source: AK7set9nkgUE93VyUAB8t6zwFeNCmJH5TKlmL95GtcPUrGP6rO4cOxZxwvs3s2iROQdhb15Slc4MYA==
X-Received: by 2002:a17:90b:38ce:b0:234:ba6f:c980 with SMTP id nn14-20020a17090b38ce00b00234ba6fc980mr11235075pjb.17.1677094581451;
        Wed, 22 Feb 2023 11:36:21 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id bk3-20020a17090b080300b00230b572e90csm3869794pjb.35.2023.02.22.11.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 11:36:20 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:36:16 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 6/7] KVM: x86/mmu: Remove
 handle_changed_spte_dirty_log()
Message-ID: <Y/ZusFTMlUUWsWLF@google.com>
References: <20230211014626.3659152-1-vipinsh@google.com>
 <20230211014626.3659152-7-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211014626.3659152-7-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 05:46:25PM -0800, Vipin Sharma wrote:
> Remove handle_changed_spte_dirty_log() as there is no code flow which
> sets 4KiB SPTE writable and hit this path. This function marks the page
> dirty in a memslot only if new SPTE is 4KiB in size and writable.
> 
> Current users of handle_changed_spte_dirty_log() are:
> 1. set_spte_gfn() - Create only non writable SPTEs.
> 2. write_protect_gfn() - Change an SPTE to non writable.
> 3. zap leaf and roots APIs - Everything is 0.
> 4. handle_removed_pt() - Sets SPTEs to REMOVED_SPTE
> 5. tdp_mmu_link_sp() - Makes non leaf SPTEs.
> 
> There is also no path which creates a writable 4KiB without going
> through make_spte() and this functions takes care of marking SPTE dirty
> in the memslot if it is PT_WRITABLE.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

Aside from the comment suggestion,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e50e869bf879..0c031319e901 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -345,24 +345,6 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
>  		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
>  }
>  
> -static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
> -					  u64 old_spte, u64 new_spte, int level)
> -{
> -	bool pfn_changed;
> -	struct kvm_memory_slot *slot;
> -
> -	if (level > PG_LEVEL_4K)
> -		return;
> -
> -	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> -
> -	if ((!is_writable_pte(old_spte) || pfn_changed) &&
> -	    is_writable_pte(new_spte)) {
> -		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
> -		mark_page_dirty_in_slot(kvm, slot, gfn);
> -	}
> -}
> -
>  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	kvm_account_pgtable_pages((void *)sp->spt, +1);
> @@ -614,8 +596,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
>  			      shared);
>  	handle_changed_spte_acc_track(old_spte, new_spte, level);
> -	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> -				      new_spte, level);

Please leave a comment somewhere in handle_changed_spte() to document
why mark_page_dirty_in_slot() is not needed to help future readers and
in case something changes in the future.
