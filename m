Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A365A71CC
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiH3X2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiH3X17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:27:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9EC13F29
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:27:45 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id b196so2320808pga.7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OgMEtC3BIEhGuzLT89trpn774Gl6AQ2Yz7jzglKk9OU=;
        b=XRmaD3neru0kfGdy6xzPASy23Ata8OellGS9anuEjuxbCz1oh6XWmrLtvZJQ6foSrs
         q9da/BL6jYV6gnrSty0XnL6wu5vrwD43KY7V0NHm5VtlZIb4W9/SlMfFRR+MZLLwkqPm
         sHsleKkV/5NhNbs0FJ5czr8YozD0mrAchIidpA7NoVsMpb+pR9Jjv1975G3K+7rhDH/9
         SH2R/nkgzKFgfWB2cplyQwRrkIYjO1+3OGyJ/b0QdaLrIjqrYuBRvynX+y6uhievpxw8
         wGImg7NvVfYP/0zpbfsvJvxoIoRCZjBfMWTY6Bl1RFmoIJBm+bGOIJwySeLmfMzb61Oj
         /txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OgMEtC3BIEhGuzLT89trpn774Gl6AQ2Yz7jzglKk9OU=;
        b=YiEW96TahdgpoxKcFER24Mqcqjm9s1hS75enObKqlo7ox/0aHZcoWhom0m9dL6sW07
         oyH5vFKFXCXng92gdLllCUNAqtjZWCXLkHeVYuTot9bI+94GwtmSD1TBDr9dzmHYSuw/
         cQ7FdQRVtJMYqblttjFIV8giy+pGsG6yTQNFw2NFHZ1JH2wBizs8kCaJfieElw4dh96D
         oCdfagN3bT1Uezvx6fim7lcmkRw/Nyh4fIVmQVuXwneBb8MIEm/ENfy4/5q9LloK8H4W
         WxOXzgdSVE+8kvq/NCCdr8eONRE24LEwi8XN8cMhkc1Cnpl6PYzqb8OmWfrApMrR6xau
         zMoA==
X-Gm-Message-State: ACgBeo2RRltRnQZJrxNhSMUBg1LbmdacGc7JNNyAbESJH24suENjehIV
        My5MsCL0/0u9ZHkXT/AUFrL2eeOOqHHtFA==
X-Google-Smtp-Source: AA6agR5FJjIacYhBiNRtI08CrZ7VOUqfL2PlruxsIGLsv+kT/+NgFvxDnl2HfcLzeH6BSbT1heT96A==
X-Received: by 2002:aa7:8653:0:b0:52d:6fc3:1e41 with SMTP id a19-20020aa78653000000b0052d6fc31e41mr23654152pfo.13.1661902065117;
        Tue, 30 Aug 2022 16:27:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f5-20020a170902684500b001635b86a790sm10170093pln.44.2022.08.30.16.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 16:27:44 -0700 (PDT)
Date:   Tue, 30 Aug 2022 23:27:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Babu Moger <Babu.Moger@amd.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
Message-ID: <Yw6c7X1ymnrAEIVu@google.com>
References: <20220830225210.2381310-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830225210.2381310-1-jmattson@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Jim Mattson wrote:
> Intel and AMD have separate CPUID bits for each SPEC_CTRL bit. In the
> case of every bit other than PFSD, the Intel CPUID bit has no vendor
> name qualifier, but the AMD CPUID bit does. For consistency, rename
> KVM_X86_FEATURE_PSFD to KVM_X86_FEATURE_AMD_PSFD.
> 
> No functional change intended.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Babu Moger <Babu.Moger@amd.com>
> ---
>  v1 -> v2: Dropped patch 2/3.
> 
>  arch/x86/kvm/cpuid.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..07be45c5bb93 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -62,7 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   * This one is tied to SSB in the user API, and not
>   * visible in /proc/cpuinfo.
>   */
> -#define KVM_X86_FEATURE_PSFD		(13*32+28) /* Predictive Store Forwarding Disable */
> +#define KVM_X86_FEATURE_AMD_PSFD	(13*32+28) /* Predictive Store Forwarding Disable */

This is asinine.  If KVM is forced to carry the feature bit then IMO we have every
right to the "real" name.  If we can't convince others that this belongs in
cpufeatures.h, then I vote to rename this to X86_FEATURE_AMD_PSFD so that we don't
have to special case this thing.

>  #define F feature_bit
>  #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
> @@ -673,7 +673,7 @@ void kvm_set_cpu_caps(void)
>  		F(CLZERO) | F(XSAVEERPTR) |
>  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>  		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> -		__feature_bit(KVM_X86_FEATURE_PSFD)
> +		__feature_bit(KVM_X86_FEATURE_AMD_PSFD)
>  	);
>  
>  	/*
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
