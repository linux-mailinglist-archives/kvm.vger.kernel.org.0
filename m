Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28A696834
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 16:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBNPhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 10:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBNPhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 10:37:07 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD574231
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 07:37:06 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4c24993965eso211320947b3.12
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 07:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEuk2za66kOkzZCxlnBgVGetnMABoCd3uDWCBjrbGcw=;
        b=GFNAmADgTDKiWX4VP2eDzfePJv77VBs2WJ62TpuHlgj6w85SpvYvwVT87guHSXvRIS
         AOUHn1K558M0QPVik1c1qYq3x8CgP7PC35U1hmNUtbmz1KZk5x46dL3T+/rudKmu1ME7
         6kfbk+cGETsRDrU0VwdThvwRY9xqTl5y5CUYlUj5I5szAwHoCc7Pe97o5IRR/hH2ZFJe
         pl1PehY2/uII+5d0PXsA2C7/+SwBHcaQ7B0O6mt6DxsHuN0HPXamJkdl8oBXF3C6psyv
         tyMCi49+fk6rN0ngeq1R2wtmvGJvB4RhFNiUhAYDe4VnXi7reT8jdX3eJUjdKSAAuIzs
         koxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pEuk2za66kOkzZCxlnBgVGetnMABoCd3uDWCBjrbGcw=;
        b=1iPs7G66eK/9TCzakhTgTvStOXzYoxpF/Jfhmg90nUBMnO+KId/gqkG6A1IFj3yCGs
         5pT5vcmJptEHFB60juTUX5DLT7gqQe5M2aFxTnmF7QMCiFPW2WQHr+KnedjPYHbNtaYI
         y0EToBczRLyAXZxSDrlgg9xFcmJlCBmlJjRSwVelWtr4utb6KtRG8vsEQBmRA/Mnyc4x
         9Z9G6X77cEZJuCRfiR3XB0jI/+mm7uwr+Oha19PCgLAvBHJs6911Avav5EBHs0VjeTL4
         LCYpab/uuhUwyrx0CoQC16jm6VthsguUmtbvadf7dh1/lrZNbeOIVwCM4EFSzAYxV2LR
         eM/A==
X-Gm-Message-State: AO0yUKWHYV4zvxu4XAYR1/GcT7XTDqerJHOyhC0VIFEpZDtltuyk8H50
        iU87FHV4qP1F4//kBHhyqOcI28HZWjlfWYWfuZH/iQ==
X-Google-Smtp-Source: AK7set9UOGxhLQ7LTLbDJLqA5joDujWSvNR7Bwc91q06oKcAtFSH8GpNFvsMBb71n1m18g0vufqH8x9TatF3NDHac8M=
X-Received: by 2002:a0d:dd81:0:b0:509:5557:c194 with SMTP id
 g123-20020a0ddd81000000b005095557c194mr236278ywe.449.1676389026067; Tue, 14
 Feb 2023 07:37:06 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us> <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
 <87sff8ags6.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87sff8ags6.fsf@all.your.base.are.belong.to.us>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 14 Feb 2023 23:36:55 +0800
Message-ID: <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context in
 the first-use trap
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc:     Vineet Gupta <vineetg@rivosinc.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Bj=C3=B6rn,

On Tue, Feb 14, 2023 at 2:43 PM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wr=
ote:
> So, two changes:
>
> 1. Disallow V-enablement if the existing altstack does not fit a V-sized
>    frame.
This could potentially break old programs (non-V) that load new system
libraries (with V), If the program sets a small alt stack and takes
the fault in some libraries that use V. However, existing
implementation will also kill the process when the signal arrives,
finding insufficient stack frame in such cases. I'd choose the second
one if we only have these two options, because there is a chance that
the signal handler may not even run.
> 2. Sanitize altstack changes when V is enabled.
Yes, I'd like to have this. But it may be tricky when it comes to
deciding whether V is enabled, due to the first-use trap. If V is
commonly used in system libraries then it is likely that V will be
enabled before an user set an altstack. Sanitizing this case would be
easy and straightforward. But what if the user sets an altstack before
enabling V in the first-use trap? This could happen on a statically
program that has hand-written V routines. This takes us to the 1st
question above, should we fail the user program immediately if the
altstack is set too small?
>
> Other than the altstack handling, I think the series is a good state! It
> would great if we could see a v14 land in -next...
Thanks. I am reforming the v14 patch and hoping the same to happen soon too=
!

Cheers,
Andy
