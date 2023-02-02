Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA38687FDF
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBBOYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjBBOXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:23:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA21C161
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:23:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mc11so6343966ejb.10
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=95bby94AAssQhd1vnsOSOZ0gdUvKeiRIAMcf3sYDskU=;
        b=KTIKsqb/sccIYhJ4mdiTX7dXmI8ExTM9r0EGIVH5VkDv0T6h6tQzLymZfxO1sdNwLg
         tK/y2pZFaC1zmqtfnd9Bu2sQcNZ0zBht28vQ8xqYRdN+S6TtbDQPTK1NOJvePyxXiFrl
         zgsrdhTlGqatys8Ya/B5o+m1kzfoO8o8MmZUYeq1IgcwNDCh02Q+o16mySppqJjGxtJu
         frvE17NvareH9RXOweGt5aYNuH8tkzJsnclgtSLGT8zmJV3bS6NvytsRkK5EJheAV6jp
         wTGXqKsrIplo95KWB75wq29Kmur5XndAYUDTioZoC9VPf19zGUEKbc2n8RLc2fekC8kg
         3qOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=95bby94AAssQhd1vnsOSOZ0gdUvKeiRIAMcf3sYDskU=;
        b=AVdpOImseTNkM06ieMydhvC/0w3/qXs+gSu5hz72ElhlJcDIMCerurcgsd9r8bALTI
         EhXMPlify3RYbvqteTZUNRTJOWR6ktfpKUIYM2GjLKsBjL9QKN8ZjhZU1jyFwQudHX9V
         bY8ZiJjcDWBbjbrxtCre4eIIQ8ZzpTNHoyZcWacNZB5vo9GltzAKAhG18GW5PUol/HZN
         G/hciADarQTkpZRy8gKGCnj2Vq2sBVXdOlx8zUkEPrL91keFz7Qto4DoMs/thTnKkuW3
         GJkpxdC2DUz16qWzwtFABpb5z64b6rMOpwzOvwH1/9+4ScEZWt8R0QLniELVn3UMtUYE
         22bg==
X-Gm-Message-State: AO0yUKVXZhSuPUGC0w1cj7Skb/TAfpsiU/1A+FloUJt7e1UmqCgUbyj+
        H+NsPEtAQHuFmPDKOjYeleD16aQ7ks6MLy3wd0Iprg==
X-Google-Smtp-Source: AK7set9zmsyEs8oLKZd8/A5vYqXgeS+QNlSzxBTdvsg2bhw3K+qlqYFHlCB9eejYCUiQaFrRvY9yE6LTJb+OBpuEk4s=
X-Received: by 2002:a17:906:b001:b0:878:4cc7:ed23 with SMTP id
 v1-20020a170906b00100b008784cc7ed23mr2089501ejy.14.1675347828096; Thu, 02 Feb
 2023 06:23:48 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-11-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-11-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:23:37 +0100
Message-ID: <CAAeLtUC3OrdKY8FptTq5Wc32EeHwZjAdrVqaM948fwPaSCMjEA@mail.gmail.com>
Subject: Re: [PATCH 10/39] target/riscv: expose zvkb cpu property
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Feb 2023 at 13:42, Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>
> From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
>
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>

You might want to squash this onto the patch that first introduces the property.

Reviewed-by: Philipp Tomsich <philipp.tomsich@vrull.eu>

> ---
>  target/riscv/cpu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index bd34119c75..35790befc0 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -1082,6 +1082,8 @@ static Property riscv_cpu_extensions[] = {
>
>      DEFINE_PROP_BOOL("zmmul", RISCVCPU, cfg.ext_zmmul, false),
>
> +    DEFINE_PROP_BOOL("zvkb", RISCVCPU, cfg.ext_zvkb, false),
> +
>      /* Vendor-specific custom extensions */
>      DEFINE_PROP_BOOL("xventanacondops", RISCVCPU, cfg.ext_XVentanaCondOps, false),
>
> --
> 2.39.1
>
