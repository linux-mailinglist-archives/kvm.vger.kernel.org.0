Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A2357A6E3
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiGSTC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbiGSTCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:02:49 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B72652452
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:02:49 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y15so8079147plp.10
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVA5gUANeExRtfWgruw+SSMiGOjtzaE4JWH38ETmTtc=;
        b=XxxmhXmiQkjOfDaSmUl3ZWlP7pbxXInlxLBvKIqqlAzKzJv07eWDcIGLEPeNZ43QCr
         8NAaNx11YxZjvhR1ZKWX0z4RP1SFzyt6xzcyOtnKPP6gi3XjTR/6oqEBTrwyhDFJjTOf
         DDLSgg5+outYOc2XR0QfLZFpb1vlKXAfU2Mwn7MPGKLYUQjFdvwDeJBozue0blCBvooI
         PuobENjdQ5DLvAUixY8yuFK9MEer+BgCx21YvTwdwNuAv+dCJNZEbn+d+/7iMV/+FgUu
         OhMYXFP5itLhjbflhCA+OENzZp/RTPRJQCK0cbIesOBphmfS+YtSs7RqTYroaK2nxpp2
         et/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVA5gUANeExRtfWgruw+SSMiGOjtzaE4JWH38ETmTtc=;
        b=OkKSzwPn29mD4WqgkRzc2a+OpVQCiCx3e8OYFx4PnY/LFYfg2gKyX/s3ZTuSbCBo1c
         iAYm3jj4CGIOBF2aa61Gujh6l0UVPtjwZqauEl//YbRWiFA6MN444OZkxX0oOqrmZ6l7
         c3MJjIAB607imD6XGIjEwO1HP+Jjct4gskZG/cLguDUgX4QO9Bv7uOYS2sbMRPLEMNF2
         f/QpFGOjuaho+GmxAIIISUpCwPh6RZX/d4Am9TVoJV7HB3y2sPWiOW3h4/LfuS5mNT9g
         /tmfsLEL9be42AaWNC6+P9D2j0v4UIG71dEw80FwnXHMu8qRnqTo8jF3oXxhRove0bNs
         0QYg==
X-Gm-Message-State: AJIora+R1z9NX5TOv87j6UkGiNBtma7a9/B1nvRyXKyCMIT8qn3JvNIO
        6+rh45HDcZsGddKsy1FxNz7qiQ==
X-Google-Smtp-Source: AGRyM1st/ZiEAkVbpQECakMKaduItwt8UMg/vzemg1458REr08NW0U/4M1s1bQ+6VVjddLIFv7a+Cg==
X-Received: by 2002:a17:903:120c:b0:167:8847:21f2 with SMTP id l12-20020a170903120c00b00167884721f2mr34068330plh.11.1658257368493;
        Tue, 19 Jul 2022 12:02:48 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z1-20020aa79581000000b0052895642037sm11885077pfj.139.2022.07.19.12.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:02:48 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:02:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com
Subject: Re: [PATCH v2] KVM, x86/mmu: Fix the comment around
 kvm_tdp_mmu_zap_leafs()
Message-ID: <Ytb/1PuHVGczAujs@google.com>
References: <20220713004452.7631-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713004452.7631-1-kai.huang@intel.com>
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

On Wed, Jul 13, 2022, Kai Huang wrote:
> Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
> pages within that GFN range anymore, so the comment around it isn't
> right.
> 
> Fix it by shifting the comment from tdp_mmu_zap_leafs() instead of
> duplicating it, as tdp_mmu_zap_leafs() is static and is only called by
> kvm_tdp_mmu_zap_leafs().
> 
> Opportunistically tweak the blurb about SPTEs being cleared to (a) say
> "zapped" instead of "cleared" because "cleared" will be wrong if/when
> KVM allows a non-zero value for non-present SPTE (i.e. for Intel TDX),
> and (b) to clarify that a flush is needed if and only if a SPTE has been
> zapped since MMU lock was last acquired.
> 
> Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f3a430d64975..58b34f7cd0f5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -924,9 +924,6 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  }
>  
>  /*
> - * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> - * have been cleared and a TLB flush is needed before releasing the MMU lock.
> - *
>   * If can_yield is true, will release the MMU lock and reschedule if the
>   * scheduler needs the CPU or there is contention on the MMU lock. If this
>   * function cannot yield, it will not release the MMU lock or reschedule and
> @@ -969,10 +966,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  }
>  
>  /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leafs SPTEs for the range of gfns, [start, end), for all roots. Returns

s/leafs/leaf (my fault, sorry)

With that tweak,

Reviewed-by: Sean Christopherson <seanjc@google.com>
