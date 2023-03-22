Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC076C4AFE
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCVMrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCVMrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:47:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73625B42F
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:46:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x3so72358950edb.10
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1679489193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5zKbHjfhgxF54RZN2uMVwaO/XV5lTFGogMg3VcS9Gw=;
        b=AeU+V10ihje21KzHVT78gOrQJ9YQxfOvj599aKQERL00BRKdGiTV8EFqv73faU5f45
         Fykh774S7V9G71lAC4TEFQ3HxDIx1EQ0Bqm7flYXZj5iFo/nVULYw3meaxbOoELkiojq
         x6V2dlejM6itF7F200uRTOvDwFd2eADEDVVJQOGEDaaATvRx85pcmbviAKnRrBPTx/uB
         AOeK7cGNMBKW8ICWJsqaSKxaLc9PvuyaYQwOUVTTIsqorPS2qGnQzXmY9wNn92vowMA3
         VTqRv2AOet1xNuUY4essauv5cZLbIYJmk2Tv9HaJt7ImatZVWYQ3DaircOALrij8nlol
         2Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679489193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5zKbHjfhgxF54RZN2uMVwaO/XV5lTFGogMg3VcS9Gw=;
        b=fCnaX2cKAA1bkeaSr5P0NlsZ5BfF2Z9rNLEwp8bLDIa98G0WCzOJkQXOoyzH/yGwkd
         KSCnaDA+8s0RL25FoyBtaJyq3FhqxFuX9Fqexwh5AgcHddbsVecvFfA7ciR17J/w10CS
         LyTTPPtHD8kEnztrHstQqMlrtF10V/xznYxrFhYi51fxVa+/ww/IwvJc/yv5WCoHckoc
         Fo83pdBsEFVlJcbFV/HC/ldGQ2KT/f9GlACBjOm/SX6niAuJRfOtul4adMa+gN2LlH1v
         bCTma56QZOp/BYedbbn3Up/AJXK3qkGiceL6HOQgjKbaiwjRBJKUqB6JzxelFEZA700/
         RvGw==
X-Gm-Message-State: AO0yUKWnBwBUJehXaeQezoBHy7QLxcyMfSFhUlu2Ukm9ULxpXM0Rq3Ft
        cMVNi8sfwSvo5tIQD1WB5Afb1A==
X-Google-Smtp-Source: AK7set+gJyx2poiD3sfTmwA9axJroFF1RhsQFBXaCqd0DtnPZi3yDlC8QBiTKtp9e6oeJC2EllLOww==
X-Received: by 2002:a05:6402:48c:b0:4fa:ad62:b1a0 with SMTP id k12-20020a056402048c00b004faad62b1a0mr5882545edv.41.1679489193201;
        Wed, 22 Mar 2023 05:46:33 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id c25-20020a50f619000000b004bd6e3ed196sm7761962edn.86.2023.03.22.05.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 05:46:32 -0700 (PDT)
Date:   Wed, 22 Mar 2023 13:46:31 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        regressions@leemhuis.info, regressions@lists.linux.dev
Subject: Re: [PATCH] riscv: require alternatives framework when selecting FPU
 support
Message-ID: <20230322124631.7p67thzeblrawsqj@orel>
References: <ZBruFRwt3rUVngPu@zx2c4.com>
 <20230322120907.2968494-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322120907.2968494-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 01:09:07PM +0100, Jason A. Donenfeld wrote:
> When moving switch_to's has_fpu() over to using riscv_has_extension_
> likely() rather than static branchs, the FPU code gained a dependency on
> the alternatives framework. If CONFIG_RISCV_ALTERNATIVE isn't selected
> when CONFIG_FPU is, then has_fpu() returns false, and switch_to does not
> work as intended. So select CONFIG_RISCV_ALTERNATIVE when CONFIG_FPU is
> selected.
> 
> Fixes: 702e64550b12 ("riscv: fpu: switch has_fpu() to riscv_has_extension_likely()")
> Link: https://lore.kernel.org/all/ZBruFRwt3rUVngPu@zx2c4.com/
> Cc: Jisheng Zhang <jszhang@kernel.org>
> Cc: Andrew Jones <ajones@ventanamicro.com>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/riscv/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index c5e42cc37604..0f59350c699d 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -467,6 +467,7 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
>  config FPU
>  	bool "FPU support"
>  	default y
> +	select RISCV_ALTERNATIVE
>  	help
>  	  Say N here if you want to disable all floating-point related procedure
>  	  in the kernel.
> -- 
> 2.40.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

I took a look to see if we missed anything else and see that we should
do the same patch for KVM. I'll send one.

(It's tempting to just select RISCV_ALTERNATIVE from RISCV, but maybe we
 can defer that wedding a bit longer.)

Thanks,
drew
