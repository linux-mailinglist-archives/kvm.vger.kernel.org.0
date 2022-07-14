Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6403575765
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbiGNWKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 18:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiGNWKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 18:10:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42DF564FB
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:10:47 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o15so4058049pjh.1
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gqge0mk3/xGYFTh18E2jnpKtnW4CjHppw+t99itaHzo=;
        b=IMntXprRgReVScC//+y80pFgCc5MMVibbsZtQEZJg6HqR11EtdVB+kbCApjzGcSgUI
         KpYSs7FXzbPfmEhNZ5PeUE3imhuNiSuRZptjybJjAaeiA5sKXlPON6l7jkzFo8zE6kGJ
         l7Ko1DscobPRMkGhwCC++PlH3qeF7iZdJC3aQpEeiMsmp3x4YoGORLSdF7Jk32IA82Ke
         l7PfQkyKwplVjKTIm//Po39RsVp0i5ParOzep+s1WTx5cjZLDDNwqnRkO7DdPU3J+2TO
         VRuFj9N6aX544MBVjDRWKy6pHYMS12d/PzosZ/fE/B5Mfdzuzn9RJde4GO9wS7eLHm0v
         dd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gqge0mk3/xGYFTh18E2jnpKtnW4CjHppw+t99itaHzo=;
        b=TfTfeuYkmQVyOT8gznnZiYJC92DcbcH3d6cJqMDY0Atwu+ZkpOXd8pylQXBu3YNv2A
         3ZqFrs4TQG5NKQLDJw+hiHNEP7cNXvzVP0Kl+T4ZXnUDhxUe4/jBtJ1plr8e740qyOSJ
         YeoJxWTjOrjb1Ncdf1AOOXf5JamfwI3pvWvFSQKb3pfETcEP0XgF2ybIQJvv+wYEUd/O
         LMwv6KerL+HVEN+Y0IAMN2FmBrpcKPd04NF4tLVndr9krviUYByIA9PGvoJpwetyB5ai
         y1eV3+6UWv1PWYVOOkyJew8xMnRJzDylsZlBPcYZz5oDQ1AdSEuGK7z3UzS3POlO5utU
         g3gw==
X-Gm-Message-State: AJIora93hoxeoXNKcd5M7na3B5RNTAsMhw8uByYX/jc11l9fjFzBHHcX
        fY9/8kKajPcuOC2xuN0+aOIU+Q==
X-Google-Smtp-Source: AGRyM1sQy7g6Lx004XY5UaDJCUONgmwruUHtPt4GmtXlfbyyR8TE6dVpRZU8BBQe3uhJvhN6CjCOoA==
X-Received: by 2002:a17:902:c10a:b0:16c:5b27:9d30 with SMTP id 10-20020a170902c10a00b0016c5b279d30mr10007801pli.32.1657836647059;
        Thu, 14 Jul 2022 15:10:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bebb0cb96sm1971563plx.266.2022.07.14.15.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 15:10:46 -0700 (PDT)
Date:   Thu, 14 Jul 2022 22:10:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 02/12] KVM: X86/MMU: Rename kvm_unlink_unsync_page() to
 kvm_mmu_page_clear_unsync()
Message-ID: <YtCUYzTerwfjWo4V@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-3-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> "Unlink" is ambiguous, the function does not disconnect any link.
> 
> Use "clear" instead which is an antonym of "mark" in the name of the
> function mark_unsync() or kvm_mmu_mark_parents_unsync().

Hmm, but "clearing a page" is a common operation.  Might not be proper English,
but my vote is to use "unmark".  KVM already uses link+unlink, account+unaccount,
etc..., so mark+unmark should be intuitive for readers.

> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f61416818116..c20981dfc4fd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1825,7 +1825,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
>  	return __mmu_unsync_walk(sp, pvec);
>  }
>  
> -static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +static void kvm_mmu_page_clear_unsync(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	WARN_ON(!sp->unsync);
>  	trace_kvm_mmu_sync_page(sp);
> @@ -1987,7 +1987,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
>  		}
>  
>  		for_each_sp(pages, sp, parents, i) {
> -			kvm_unlink_unsync_page(vcpu->kvm, sp);
> +			kvm_mmu_page_clear_unsync(vcpu->kvm, sp);
>  			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
>  			mmu_pages_clear_parents(&parents);
>  		}
> @@ -2326,7 +2326,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>  		unaccount_shadowed(kvm, sp);
>  
>  	if (sp->unsync)
> -		kvm_unlink_unsync_page(kvm, sp);
> +		kvm_mmu_page_clear_unsync(kvm, sp);
>  	if (!sp->root_count) {
>  		/* Count self */
>  		(*nr_zapped)++;
> -- 
> 2.19.1.6.gb485710b
> 
