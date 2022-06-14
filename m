Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4154B410
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351332AbiFNPA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245624AbiFNPAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:00:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CFB38BD4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:00:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx11so8715271pjb.1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uCN2gj0r2ydsfLcZI1sFwWz1Fp2OKP8Km+3JkrgTjRM=;
        b=Ekx5DQ+HUHoSy6kumqYNnkdP9uUsany7Jp1UDBAeYOqVfAh5D+QvFnZtUvpNNK6A1N
         SND3VfsbuAxMkLo8Hei66R2cs7TpHH74Ih2idmiqz1PxUV3KeAoc82O8bZ2cEGCKzcBy
         gZDLvH/YQISqZmOf8yt1U8xR/02ZaXtv0MFfrqoPnjMCYXSllEXEH9yhGqRyPoik8tnY
         BzEOS4b9X5X+7Sd3xGYDipCLfgciwLZZ09qbPk85kHfGRl3OViI6jgC0k1+WrzVpWZyG
         PEzzC6WH5rFW6vvAIB/h7mfsCc2Fu+1wkhILcYBAQXYsCNeYnlZMMnQvihOV9H+IU0V6
         PXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uCN2gj0r2ydsfLcZI1sFwWz1Fp2OKP8Km+3JkrgTjRM=;
        b=32j4TZ3t5yj9dDT+S5iv8FBsnbj79eHRpgR/v8f45p/F0CBkwMKe9jerMnSrIyFG/C
         Ffu1yZ0Xq7M7vyxxNW+/lB4rvYrND5bug3rfWFFZvkOM0k3IQNBqXSIoXBYQ/Xh9iwzh
         jonAzjI9IhoSs8iMdTHYkcYv71OvT9ctJfYggAKwvh3rozpL26qalLVyTAxBreOUnypS
         QmBoGsI+jl4OkiB7mFbuRswVADMukBmvOjZqAJoTQY6Ljf7pgdE/Npv56ygdlh/B80DH
         vHzpW0SoTf22PC4I1JDdFpwyjVRX8VD3x6wkEiupZMi94gTqCjiEjkpe/3Sz5GBZV6mZ
         0snQ==
X-Gm-Message-State: AJIora8fMoegmW9skubDhW4W1RJ4PngHEChtwd88Zoqw9Xd63LBktqvL
        2M1Es9qrwWiQL4iFvmQ5mI+OPLvsKm1Q5w==
X-Google-Smtp-Source: AGRyM1sg6K75KKCe2UYpLfEA2RfY+M58mNgtnd1Q7oxUIKuVCfFQYlLTL3apk/FXgEg14n5GwismSA==
X-Received: by 2002:a17:90a:e28e:b0:1ea:c3c5:bc61 with SMTP id d14-20020a17090ae28e00b001eac3c5bc61mr4679621pjz.15.1655218822247;
        Tue, 14 Jun 2022 08:00:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902684d00b0015e8d4eb26csm7343256pln.182.2022.06.14.08.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:00:21 -0700 (PDT)
Date:   Tue, 14 Jun 2022 15:00:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Use consistent type for return value of
 kvm_mmu_memory_cache_nr_free_objects()
Message-ID: <YqiigqccucuU2AQg@google.com>
References: <20220614093222.25387-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614093222.25387-1-liubo03@inspur.com>
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

On Tue, Jun 14, 2022, Bo Liu wrote:
> The return value type of the function rmap_can_add() is "bool", and it will
> returns the result of the function kvm_mmu_memory_cache_nr_free_objects().
> So we should change the return value type of
> kvm_mmu_memory_cache_nr_free_objects() to "bool".
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  virt/kvm/kvm_main.c      | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c20f2d55840c..a399a7485795 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1358,7 +1358,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
>  
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> -int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
> +bool kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
>  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a67e996cbf7f..2872569e3580 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -394,9 +394,9 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  	return 0;
>  }
>  
> -int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> +bool kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)

Absolutely not, the name of the function is "nr_free_objects".  Renaming it to
"has_free_objects" is not a net positive IMO.  If we really care about returning
a bool then we can tweak rmap_can_add().

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17252f39bd7c..047855d134da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1018,7 +1018,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
        struct kvm_mmu_memory_cache *mc;

        mc = &vcpu->arch.mmu_pte_list_desc_cache;
-       return kvm_mmu_memory_cache_nr_free_objects(mc);
+       return !!kvm_mmu_memory_cache_nr_free_objects(mc);
 }

 static void rmap_remove(struct kvm *kvm, u64 *spte)
