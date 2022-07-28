Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84B584407
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiG1QRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiG1QRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:17:07 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1254D6FA08
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 09:16:57 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p8so2176273plq.13
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xiDt4CGEXpnM9NEKFnyFksPM4nq3Hw4T4BwblzVCemU=;
        b=X97n+o25JJrFRC+7mp6nbPalLntb26lF+F1u76My851tXXdyLSrXix8ClnPPqAmkIP
         1Dngq1o3RaMnZ1DQaTAr3ToE4HxWHBdSvwzHBLJw2F096KBUayVv2rht83z7nhMyRVSb
         uxXT0HnvCoGbjLLHUPJAPA/zY4NTiNcSoqi+ypvJSr/Z68fct7x8PuB/HFvYMP8IASqB
         dqsGYgAyV3Sfv8/rlg3Njiz5okhbh0R2TFbDkrk157hzE4DDqQG51JIm6c4FTNOL8Arl
         c9gurwZTikOoxhwja8stlU0eDBhCnAORf81/8oaclQR29P9K7By3D9RQmDQ+FKPQDZhS
         zpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xiDt4CGEXpnM9NEKFnyFksPM4nq3Hw4T4BwblzVCemU=;
        b=kBem3BxaAIAjZhZ9IRPiEQ3LpFSUfLIHYkHXTk2BHSzccpVPwJTYVlZrL9QOs4oG8W
         uvfSqI0E0myLAw6/pCWUQ2qfoa3TeUg+9HjhR7sciiVMVj4BxJg3xFYho3eMbGRkOsjL
         0o4Z7oTX0Y70w8lNC99F+b4xqQTEcFsEr8aSnDRtXSEVcqvxHNiyey4bG3GW17Pu6iQC
         9XPG7yKw35+Urs7LEFJB0udfcb9A0ITSyLOBsrc/8oZFIOGHwIEjbna+nHcb0GfP1ztl
         n466sz2Dq4505Qi3C8i3/k8RTx5rwD2/ULQNxp4Vq2LiO3npEOmkbDRO/2IPiN6PhN5O
         OXVg==
X-Gm-Message-State: AJIora87QT1Vsw6KBs7AJk8TeknWAbexC9xW5hM5dmHyjdcv/vfQH5SE
        w6I1CRkwb1Hf6snJDhsqgh2IrQ==
X-Google-Smtp-Source: AGRyM1sSpeCG4DMEEgM3SoS0VC4vfaNtldweOzDSBor2LcOuF5RCyUwA60TIyqdBnVtD68Bh6Oy+mg==
X-Received: by 2002:a17:902:ebc2:b0:16c:da9d:96dd with SMTP id p2-20020a170902ebc200b0016cda9d96ddmr27225620plg.34.1659025016313;
        Thu, 28 Jul 2022 09:16:56 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b0016dc808f29bsm1333551plg.13.2022.07.28.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:16:54 -0700 (PDT)
Date:   Thu, 28 Jul 2022 09:16:50 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] kvm: mmu: fix typos in struct kvm_arch
Message-ID: <YuK2ci/LJ2BTHqah@google.com>
References: <CAPm50aLBuq+zH9VHNDGLiB6Kqwwapus+dFwNqiOm8kruzPnouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50aLBuq+zH9VHNDGLiB6Kqwwapus+dFwNqiOm8kruzPnouQ@mail.gmail.com>
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

On Thu, Jul 28, 2022 at 06:37:24PM +0800, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> No 'kvmp_mmu_pages', it should be 'kvm_mmu_page'. And
> struct kvm_mmu_pages and struct kvm_mmu_page are different structures,
> here should be kvm_mmu_page.
> kvm_mmu_pages is defined in arch/x86/kvm/mmu/mmu.c.
> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8281d64a431..e67b2f602fb2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1272,8 +1272,8 @@ struct kvm_arch {
>         bool tdp_mmu_enabled;
> 
>         /*
> -        * List of struct kvm_mmu_pages being used as roots.
> -        * All struct kvm_mmu_pages in the list should have
> +        * List of kvm_mmu_page structs being used as roots.
> +        * All kvm_mmu_page structs in the list should have
>          * tdp_mmu_page set.
>          *
>          * For reads, this list is protected by:
> @@ -1292,8 +1292,8 @@ struct kvm_arch {
>         struct list_head tdp_mmu_roots;
> 
>         /*
> -        * List of struct kvmp_mmu_pages not being used as roots.
> -        * All struct kvm_mmu_pages in the list should have
> +        * List of kvm_mmu_page structs not being used as roots.
> +        * All kvm_mmu_page structs in the list should have
>          * tdp_mmu_page set and a tdp_mmu_root_count of 0.
>          */
>         struct list_head tdp_mmu_pages;
> @@ -1303,9 +1303,9 @@ struct kvm_arch {
>          * is held in read mode:
>          *  - tdp_mmu_roots (above)
>          *  - tdp_mmu_pages (above)
> -        *  - the link field of struct kvm_mmu_pages used by the TDP MMU
> +        *  - the link field of kvm_mmu_page structs used by the TDP MMU
>          *  - lpage_disallowed_mmu_pages
> -        *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
> +        *  - the lpage_disallowed_link field of kvm_mmu_page structs used
>          *    by the TDP MMU
>          * It is acceptable, but not necessary, to acquire this lock when
>          * the thread holds the MMU lock in write mode.
> --
> 2.27.0
