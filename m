Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4187D5F5D29
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJEXRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJEXRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:17:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E45857F4
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:17:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so2722718pjs.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P75Ww099jv9Om8MvN0r9mkkJ/YLMTXxMDNssXHfPeTs=;
        b=Ybuf2pqfOwKO8dsPs7+4fy9VtKnrA5sy7q6SMqwQY7JSoYV3nH38VyFBbXxzP1lIjZ
         N1Ug5aKLpaeYKGNe/ccQ/LiJL22vvFff83/VnHK7lREOW7WodXTSjEIiE4FWjwsBSjf5
         LiCAhVGnPvxey8DWHe9voGZ2E0bBxmqHASAafOgURFunJlOxtKERdBzVIbDVEVhYXRLi
         sFpnsVaFOqP5FiD9ki8kjBhaxGah1iCz87cjzfaMeHDBYlFIaK/GD9HtvFVlDgRygkUj
         h19gRSXN2KX4veb+lB4qS3H4eMd65GwaQtDWH5dTcdUsO3kBEt/Q5GWZaO2oUFFqh+bL
         n81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P75Ww099jv9Om8MvN0r9mkkJ/YLMTXxMDNssXHfPeTs=;
        b=5hC/TfBxah37XE8xpOkOUjnRvi4PzEm1P1efLhvusDDefIfAnQ7hd22S82ZjscOKms
         eWXionGEOzhc+acMwKw6zxpmFJ/gx7QQkhRlDccLQkadoJA/y2t0m/CKQIfCi2ORgnhq
         is2/CCwijb9aGUhZ45QOZYMLzMyyNraSxjyUIM2dE6U8yFceUWUAg5Enrt5QohfUIY/W
         w1kX/CyebL8UmRqVPSyWF2jRptgvobF7F1wJjzcapz7kLhTIhjCaBhrY6lCbF5MI6iML
         CtoxwMk+wSvVsj+f/HFl02PzdLFlzqmt4/T5cJCwLofSp9MbSGuBVG26DdHJXdqMOKwe
         gC7g==
X-Gm-Message-State: ACrzQf0uPo0mniCpMOlX3RuYFtLVPlLtvLiZQ/ZAWBT7NRHmQftth3od
        MioW/NQ73byoBnbsxjEBjmlQ8A==
X-Google-Smtp-Source: AMsMyM5nR/ndnwW6VOCqawZxdmxfVnDGGFFfLAOceafLdHT1ZLCZNC3bCof7tEuiKgWHNYFSvr68wg==
X-Received: by 2002:a17:902:834a:b0:17f:8514:ceec with SMTP id z10-20020a170902834a00b0017f8514ceecmr1590640pln.81.1665011856070;
        Wed, 05 Oct 2022 16:17:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090302ce00b0017a09ebd1e2sm10926068plk.237.2022.10.05.16.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 16:17:35 -0700 (PDT)
Date:   Wed, 5 Oct 2022 23:17:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: use helper macro SPTE_ENT_PER_PAGE
Message-ID: <Yz4Qi7cn7TWTWQjj@google.com>
References: <20220913085452.25561-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913085452.25561-1-linmiaohe@huawei.com>
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

On Tue, Sep 13, 2022, Miaohe Lin wrote:
> Use helper macro SPTE_ENT_PER_PAGE to get the number of spte entries
> per page. Minor readability improvement.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 858bc53cfab4..45c532d00f78 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1645,7 +1645,7 @@ static int is_empty_shadow_page(u64 *spt)
>  	u64 *pos;
>  	u64 *end;
>  
> -	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
> +	for (pos = spt, end = pos + SPTE_ENT_PER_PAGE; pos != end; pos++)

This is buried under MMU_DEBUG, and turning that on to compile test, which requires
manually changing kernel code to enable, results in some minor warnings.  Given the
existence of CONFIG_KVM_WERROR=y, I think it's safe to say this code hasn't been
exercised in a very long time.  E.g. this is literally the first time I've actually
enabled MMU_DEBUG.

This particular check seems like it would be quite useful, but the pgprintk() and
rmap_printk() hooks, not so much.  E.g. the knob is too coarse grained, and many
of the prints now have tracepoints.

So, unless someone actually actively uses MMU_DEBUG+dbg, I'm inclined to just delete
pgprintk() and rmap_printk(), and then rename MMU_WARN_ON => KVM_MMU_WARN_ON and
add a Kconfig for that, e.g. CONFIG_KVM_PROVE_MMU.

Hmm, and maybe clean up this helper too, e.g. get rid of the pointer arithmetic,
and take the full kvm_mmu_page so that the error message can print out things like
the gfn (a host kernel pointer is going to be useless for debug).

Thoughts?  Objections?
