Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618C95BA812
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIPIVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 04:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiIPIVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 04:21:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EAA4B2C
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 01:21:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id az6so15621590wmb.4
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 01:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=U5I+bc12n8BGkk2E5D3c0qwHx95JDDEzRcPbk+P9bY4=;
        b=YpDAeCzTxHE6gP4ppmKgIw8Aqvv0medsJZKNSnN7ZVWkYoJWitm7t2kVSSlQ6Wrzq1
         UnRqmfqAfJ1QGuX/dIq165IAc9aZmXPel/eia+fZ1XDoXqWerWbwzeZh7nypQ1JdDHiB
         yDdIWD5c2TB0qm3q13jhZH9QBPFJn/gP4ImA0SfL7CCdu3h1E+XUfgIDy8/2J2S/1fXt
         OAdUwZVNbgNa3qz94ndBVAEsQSjgJajDl5QwLTKpevyQJ93O3jnA85mdVr1BHgB3B5ti
         shmRRizxEM4PgdWDKR3q4xwRmMTTr5kmU84hCjoBfaVcgOHw8JvoVpqEOwkIkzaYeY4I
         d1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=U5I+bc12n8BGkk2E5D3c0qwHx95JDDEzRcPbk+P9bY4=;
        b=wJCYDWKl4q07m/jKTiqSy+j6ZNj5yoWiYOQb1TUN8w1U605U00SMq5JeXHZnlyaXKg
         U3rzgDzIQw0FBJ8evBGw6pVmbC+yjj/ztOe/X0djvBiLNLmahACvTzTGWp7My2MGPPG1
         quFhhfSx/peBXbkOWQQqoVq1lmyiUqnCa8V2BG4l6DbqMV4fmBa4tsMTRpQOhW4AsmR2
         jAqhGUhCIy34U13vHzIMMjqVn4DBM3hlWXPNpZch2rMcMbjJEh0DBB+zRfv36ShL7KbW
         xkdNU5TSi7XplDsX0WlP2NHdxDPJivecYnSAQACWmQFJEfE043Oq5bJiTh9KqhzohP7L
         /YZg==
X-Gm-Message-State: ACgBeo3dx44ovr8Smz2siBPf7PSHtapKULIzSyWZgnfIoSzWMxK1wl8m
        ju7mju8QyzsI8yWhkAEE3J6NTA==
X-Google-Smtp-Source: AA6agR72Nl9/emEDqNYzCTiKeb4Wolsd3lgVkwv7Xl+/oakOkGtTLsqidNd+hGlZQI6wGFy7WR3+GA==
X-Received: by 2002:a05:600c:3d17:b0:3b4:adc7:976c with SMTP id bh23-20020a05600c3d1700b003b4adc7976cmr4498496wmb.108.1663316491187;
        Fri, 16 Sep 2022 01:21:31 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b0022abc6ded45sm4424179wrf.13.2022.09.16.01.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 01:21:30 -0700 (PDT)
Date:   Fri, 16 Sep 2022 10:21:29 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Mayuresh Chitale <mchitale@ventanamicro.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH kvmtool 1/1] riscv: Add zihintpause extension support
Message-ID: <20220916082129.rkvmldh5n5a3we3e@kamzik>
References: <20220916064324.28229-1-mchitale@ventanamicro.com>
 <20220916064324.28229-2-mchitale@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916064324.28229-2-mchitale@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 16, 2022 at 12:13:24PM +0530, Mayuresh Chitale wrote:
> The zihintpause extension allows software to use the PAUSE instruction to
> reduce energy consumption while executing spin-wait code sequences. Add the
> zihintpause extension to the device tree if it is supported by the host.
> 
> Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
> ---
>  riscv/fdt.c             | 2 ++
>  riscv/include/asm/kvm.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index e3d7717..7997edc 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -19,6 +19,8 @@ struct isa_ext_info {
>  struct isa_ext_info isa_info_arr[] = {
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
>  	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
> +	{"Zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},

We don't capitalize the first S in 'Sstc' above, so I don't think we want
to capitalize this Z either.

> +

extra blank line

>  };
>  
>  static void dump_fdt(const char *dtb_file, void *fdt)
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 7351417..f6f7963 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -98,6 +98,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_M,
>  	KVM_RISCV_ISA_EXT_SVPBMT,
>  	KVM_RISCV_ISA_EXT_SSTC,
> +	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,

This should be updated with a uapi header update using
util/update_headers.sh


>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> -- 
> 2.34.1
>

Thanks,
drew
