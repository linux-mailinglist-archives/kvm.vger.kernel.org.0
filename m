Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC869687FF4
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjBBOZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjBBOY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:24:58 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD84E8E4A7
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:24:56 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gr7so6421813ejb.5
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gyNeh/9jkYVPY2dOsex4uScI7zBsxh0FthHS454uNKw=;
        b=pbGlRKq3/SKOW4MjtJF0+ZU2h5eUUKACQ/sat4zTpPpIssG17bCydHnm6JYuAXKZSh
         0Rcsjyp4yTwnftfpXB+BMZnFyJ0qnoDZJG+co7iL0CVYhX2O04li+q5Z+ONz4y76hcNK
         qro69yMeGEI5grVvNhGijVlTS0bHiZ9WnnEfNWJ6ksceIcS1qRD6WxyFIr8gDOadOxQw
         1mg1fTiHEvT0yX/GryH2OccPyDKM/p78oqNaVZoNP5WOvzsWKjCqEm0owkEb9/VdWW+9
         dRte4bq+BrJit0ZCHbgp8NJbZw0TF04r86pkDjjNymoKNJhDRFpuy4E8W0k6r+b6c4pd
         ZpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyNeh/9jkYVPY2dOsex4uScI7zBsxh0FthHS454uNKw=;
        b=KkhtX75FDLIOMgiy/w5CdIoqcMsHI3dp4adwpG/Cpd3WQW8bS+0cBiM05C+z80Z+iO
         8BM8A72iaU/aJkGTDyUhT2XOWZp3wV7Rimp0Te62wqB5xSQzvqzlT+rQlDKZI92zq5YP
         CNqBBqUBmnb2G6FNecHvEvn9YKecOhFEtKrcJhMWA+Zh+1OZYNf5Gw8T59OoFyDBQ1Ze
         83YjGTJAaYs2kiFAFkZPg1QuQZbU9AunEmZQPCn8DxXMlDKesc1L7s2/RlJuq4mqI+zf
         g0QOeCHu2b9haxjVV0BK8e7jIwOPU+mYFTo0dA6X7xPd4n8Cy9WtTD5kHGdGtRDckzBe
         SvIA==
X-Gm-Message-State: AO0yUKWb7xEonRcoB+toy3FtSLuAGefcQ7fAiGNflP1DITralqBkNfXs
        w0M4UQ9OX8391dxZWR4m3yv4kXKBZLpyaLFNU4zJuA==
X-Google-Smtp-Source: AK7set88XIVwLLwCSDNQQZGMnYtAU2tzBNATjP4+Lk6kUFlcufUp9XhStFVxV44y95zksieDiNUHWxLIjLy1UD77tU4=
X-Received: by 2002:a17:906:950e:b0:882:a9d3:9aa9 with SMTP id
 u14-20020a170906950e00b00882a9d39aa9mr2064753ejx.70.1675347895199; Thu, 02
 Feb 2023 06:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-11-lawrence.hunter@codethink.co.uk> <CAAeLtUC3OrdKY8FptTq5Wc32EeHwZjAdrVqaM948fwPaSCMjEA@mail.gmail.com>
In-Reply-To: <CAAeLtUC3OrdKY8FptTq5Wc32EeHwZjAdrVqaM948fwPaSCMjEA@mail.gmail.com>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:24:44 +0100
Message-ID: <CAAeLtUBBxguM3kLrB-6vAkqV9E84xXvKbsJn7A-Z4FK8RA5bZA@mail.gmail.com>
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

On Thu, 2 Feb 2023 at 15:23, Philipp Tomsich <philipp.tomsich@vrull.eu> wrote:
>
> On Thu, 2 Feb 2023 at 13:42, Lawrence Hunter
> <lawrence.hunter@codethink.co.uk> wrote:
> >
> > From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> >
> > Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
>
> You might want to squash this onto the patch that first introduces the property.
>
> Reviewed-by: Philipp Tomsich <philipp.tomsich@vrull.eu>
>
> > ---
> >  target/riscv/cpu.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> > index bd34119c75..35790befc0 100644
> > --- a/target/riscv/cpu.c
> > +++ b/target/riscv/cpu.c
> > @@ -1082,6 +1082,8 @@ static Property riscv_cpu_extensions[] = {
> >
> >      DEFINE_PROP_BOOL("zmmul", RISCVCPU, cfg.ext_zmmul, false),
> >
> > +    DEFINE_PROP_BOOL("zvkb", RISCVCPU, cfg.ext_zvkb, false),

I missed this earlier: the extension is not ratified. So please: "x-zvkb".
And it needs to go under the comment:
  /* These are experimental so mark with 'x-' */

> > +
> >      /* Vendor-specific custom extensions */
> >      DEFINE_PROP_BOOL("xventanacondops", RISCVCPU, cfg.ext_XVentanaCondOps, false),
> >
> > --
> > 2.39.1
> >
