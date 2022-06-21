Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3755381C
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351776AbiFUQm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352061AbiFUQm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:42:57 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81981C79
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:42:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d129so13609948pgc.9
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WroRQ/xKuUcsGUJ8eN811jjWPDOjWRPpxjSV2Kig+TE=;
        b=Aptz6tWgn1honGtJe0y1ZXA5t0y6VX2wYjl/87HeGBV2sAss7SwnnBTZaA4bYJgg9M
         SHEQCZNHd92Ctf/qL+Lv3UKLOHZc2dHTGll1pQzhomWm3LC+8ELuaquhQm5szkj8hKrP
         SoUSLnlpoRPvfMNwq3Zn0uMVhvQVynESKS6AjwvDWouHzkLPFV1hhMdhz2JFKaEZQ8HH
         LZ7r+r0OhwD3uynBInAnA4YUO+mhw4KtwfhYkgT4/PHoHzK3zkby3jMMzPNfUEiKtybz
         e8OGtnDqCt6mJspWE8x4DCfEQbKZ4UlLo8h0xPropknFPoWcqvAa4EN06mzL69T9h28k
         4WpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WroRQ/xKuUcsGUJ8eN811jjWPDOjWRPpxjSV2Kig+TE=;
        b=gb+bzcv0y0SRKBN8s+I1RsEim5Yitgxt+2Te4yLwDBfHazm6RAoTWQVaC+bXa33GH4
         3amClgKliD8gy3uFrPuReKHlHYRELo56A7HtgqJwu4B0vMjZqFjtt+A5JPDXNkusn0QU
         nuZtn5Ifvesg833X9jnnBqYPreQtTb+e+dh0BM0lHyx34ARKXgAzL3HBumQiYt6Mi8fR
         9cM4bvsAMetsNkpHSAgAXv5lxXNlMe6KqMGl+I45lox0meCT9FPGG3wmPAwDRANcqDi1
         jDe+aXAFiRxN4JTTmLpOuhucwlZP9ICBlEprqQORm5V4ZtWBS9/4g8bcIxfWPa1sIVxl
         qjtQ==
X-Gm-Message-State: AJIora+gsyIalaBMbkOS98CZ62VJiR9uJQAVKc8jp6qWrgDtBbR2E1Ej
        AT5gZaKFNgRLKILN0fb6mSjufw==
X-Google-Smtp-Source: AGRyM1skLiH7ZHHojlIeNMlxRYBNDLnmk7dyEuoCoYAYVIMiITsQtG6GU+AnHOTBNgaGA2css5mdhw==
X-Received: by 2002:a63:69c3:0:b0:40c:5e67:ffc0 with SMTP id e186-20020a6369c3000000b0040c5e67ffc0mr19042391pgc.383.1655829774830;
        Tue, 21 Jun 2022 09:42:54 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090a428700b001e2f383110bsm12528016pjg.11.2022.06.21.09.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:42:54 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:42:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 13/23] arm/arm64: Rename etext to _etext
Message-ID: <YrH1C/YOHgPPXQrZ@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-14-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-14-nikos.nikoleris@arm.com>
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

On Fri, May 06, 2022 at 09:55:55PM +0100, Nikos Nikoleris wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> Rename etext to the more popular _etext allowing different linker
> scripts to more easily be used.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm/setup.c | 4 ++--
>  arm/flat.lds    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 3c24c75..2d67292 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -34,7 +34,7 @@
>  #define NR_EXTRA_MEM_REGIONS	16
>  #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>  
> -extern unsigned long etext;
> +extern unsigned long _etext;
>  
>  char *initrd;
>  u32 initrd_size;
> @@ -140,7 +140,7 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
>  
>  static void mem_regions_add_assumed(void)
>  {
> -	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
> +	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
>  	struct mem_region *r;
>  
>  	r = mem_region_find(code_end - 1);
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 47fcb64..9016ac9 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -27,7 +27,7 @@ SECTIONS
>      PROVIDE(_text = .);
>      .text : { *(.init) *(.text) *(.text.*) }
>      . = ALIGN(64K);
> -    PROVIDE(etext = .);
> +    PROVIDE(_etext = .);
>  
>      PROVIDE(reloc_start = .);
>      .rela.dyn : { *(.rela.dyn) }
> -- 
> 2.25.1
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>

