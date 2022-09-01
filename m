Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9B5A9D34
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiIAQg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiIAQgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:36:18 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE8386FF6
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:35:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x80so13298595pgx.0
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=wZQBj7pb452dViIJDqPpFoOZzmeB5j6bGsVhaJgVlPU=;
        b=PvhnZfdzPsGxr/8jfxUdrymt7neGXR35G65E8ILeHJtdzQ/833utetC4qOCf1dTBTF
         7JsqN02IM+Bx/CFBKrmEA+6aLdfo2lQ4AXT6XEFDPulgmtWgr80B696lez/veCJZRCn9
         m+FL1pouTgNuYoXXcwjp4XoTIdDFp+ytwcGud6h3rqC+SGUvVwUo1PTKub/Jvcn+Myki
         qQLIr20J2P3+HvjF/TIwufvamX6ZieQGU2cDOUE74uDOOnHurcL+vwVHDwFgbeRNmPcX
         6IJe4O/hXLsBHZqpNHzBrpLdD9CBkuZ755DyncIYK+Pa2i0VKGhJ5n6IqT2O7bKwOQsM
         RTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wZQBj7pb452dViIJDqPpFoOZzmeB5j6bGsVhaJgVlPU=;
        b=6YCohsiciIzQiAohqC47V1DU5XjdO/h8KQnJCHP3Ys/GpU6kxk7Fgk/QBUM8IcRfp6
         R0NsHykoYOsh9iRR4yBdLnCSrsZ0+k2ywdwsh92eZkVqJo0HdH671AlgLs0wUutx2702
         CThqqxuSfqyDpajLhZb9drDK0GFana65HjdddpAnv0v27m5vHuLaks4UfBvGokplLziG
         yh4/cNwHXkVUKE95B9rTjGU4hkj2mnKiYxEZgk26fNo7QnjFKxRkO1JGKJNluOjqsheK
         OaUOLfGzXHdlThngAD6YZQk3LhEU9cwZyTu5DJIroBMI8u5GpdZnuCTSF2hyDVHxnQ9Y
         Kvlg==
X-Gm-Message-State: ACgBeo3O4MzuAMwWHbaHZfQwCJwo5xFjtzCGuLzKYC9FTTzP4PY9HOj0
        T0+ki2ixa8p4y8MSB4/Ya+L15rrxekZdTw==
X-Google-Smtp-Source: AA6agR6x+Sv5b+06QJwHvS9QxKGTTBbxzjJHaASqCpuVJhIqeYvlcAOCm6ub0tLullaHiTbaKInLrg==
X-Received: by 2002:a63:4758:0:b0:42c:667f:f88a with SMTP id w24-20020a634758000000b0042c667ff88amr14365171pgk.271.1662050156724;
        Thu, 01 Sep 2022 09:35:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001744171a60esm12407780plg.194.2022.09.01.09.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 09:35:56 -0700 (PDT)
Date:   Thu, 1 Sep 2022 16:35:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpufeatures: Add macros for Intel's new fast rep
 string features
Message-ID: <YxDfZwKAlH6KBhoH@google.com>
References: <20220831211810.2575536-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831211810.2575536-1-jmattson@google.com>
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

On Wed, Aug 31, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits

Why not provide the KVM support in the same patch/series?

> are already cached in word 12. Give the bits X86_FEATURE names, so
> that they can be easily referenced. Hide these bits from
> /proc/cpuinfo, since the host kernel makes no use of them at present.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  v1 -> v2: Hide from /proc/cpuinfo [Dave Hansen]
> 
>  arch/x86/include/asm/cpufeatures.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index ef4775c6db01..454f0faa8e90 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -308,6 +308,9 @@
>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> +#define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
> +#define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
> +#define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
>  
>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
