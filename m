Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD6697E8B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjBOOkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBOOjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:39:51 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8732F38EA3
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:39:48 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-52f0001ff8eso175213647b3.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWoLS1pI97YxZKfXgrwt/VC4vanGmb3d/NBmdfDh1ow=;
        b=VC6zCtyX8kxZEEUTT16T9v99GNa+CfGmhXQjrezGx6UTiHwTZQnGYmPlasZgrW6oRG
         2nSvbwo5kW3+iXP8HeFUwBXcBjKeArOdJsIhDW5UUIpk6h6cpkPKbAGvRPpKKq8QAQZr
         EaXt1jW1O+yABnFlL1MHKGZAeKNczhMxkDaaGIaAYQsAdmE2Xl/riBgb82L5HGz5Clfa
         6KtbmAHyhPrvZyXlD+BhAjNWlk+dChIfpMx+41VeDFsWLoQPb2KZ6q2cnu/E8eIQn3cQ
         SoBiEvdxXz2E2eoqSwCpkc4cG2Ff6hSflif0rBKr9QuRg8gmWHCCV7m7H/EC61nxJSz4
         Ah8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWoLS1pI97YxZKfXgrwt/VC4vanGmb3d/NBmdfDh1ow=;
        b=LhBQ+s8QZu7D2yDnAsLdw3MFOdNbADsW46quTF1xEqedXarJpbMt69z+vpYNkOdcZM
         dujmLEeiusPu69PaZDZMv7Fmjw2+82OEWI6utiyGmIhUDbYbKroMijVHCs5rnQtYpus4
         m7pEc2Qrsar0HEpvbrNlCm9J5v5diKW/Alo7Hc9PXio4UbKOQaq+b3aLUuHSGXzAfvBq
         xfEhG6O/2RRwnQm9K6XUxRegUBse1N+HU6oJIe1NZfKcVqazFs2oj4mYsOrI2VI7LocM
         XQHL2Zcd2ff/ZCqS2KNo8vHjEIhmnZCJPTQ0KTpWrehsovGxCMG8erff4XVWSO6kgu4G
         ibcA==
X-Gm-Message-State: AO0yUKWnBs1c+EEWZtvWxQ0PHfr2lnJ+bHURAxnpZ+/zjb21yE2aSStK
        9+dwRkhoQYxUs1yB5QQk+cktqEag71Op0jdmdTSXFw==
X-Google-Smtp-Source: AK7set+JXbsP1u5cYEi/qjZNhwhCQctaYSX2quajc43/BMVwFTwmT2/68eZ1p6XW8PNm0zfgKPfEOayUfS9yaFYFcEo=
X-Received: by 2002:a25:9983:0:b0:88f:946:bd98 with SMTP id
 p3-20020a259983000000b0088f0946bd98mr231855ybo.24.1676471987585; Wed, 15 Feb
 2023 06:39:47 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-11-andy.chiu@sifive.com>
 <875ycdy22c.fsf@all.your.base.are.belong.to.us> <82551518-7b7e-8ac9-7325-5d99d3be0406@rivosinc.com>
 <87sff8ags6.fsf@all.your.base.are.belong.to.us> <CABgGipXSsqgtTx9bCy-gt7CTBkXN--t1wHgLfCxA3=vs6y+qUw@mail.gmail.com>
 <873578faxg.fsf@all.your.base.are.belong.to.us> <5e440cfa-27c5-f216-5529-350ac19c07ff@rivosinc.com>
 <87wn4jjt8f.fsf@all.your.base.are.belong.to.us>
In-Reply-To: <87wn4jjt8f.fsf@all.your.base.are.belong.to.us>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 15 Feb 2023 22:39:36 +0800
Message-ID: <CABgGipVvDXdeEfaUivevQJ+dphayPbFh0X3TNCKhHCyFZakZ1Q@mail.gmail.com>
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
        Richard Henderson <richard.henderson@linaro.org>,
        linux-kernel@vger.kernel.org
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

On Wed, Feb 15, 2023 at 3:14 PM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wr=
ote:
>
> Vineet Gupta <vineetg@rivosinc.com> writes:
>
> > On 2/14/23 08:50, Bj=C3=B6rn T=C3=B6pel wrote:
> >> Andy Chiu <andy.chiu@sifive.com> writes:
> >>
> >>> Hey Bj=C3=B6rn,
> >>>
> >>> On Tue, Feb 14, 2023 at 2:43 PM Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.o=
rg> wrote:
> >>>> So, two changes:
> >>>>
> >>>> 1. Disallow V-enablement if the existing altstack does not fit a V-s=
ized
> >>>>     frame.
> >>> This could potentially break old programs (non-V) that load new syste=
m
> >>> libraries (with V), If the program sets a small alt stack and takes
> >>> the fault in some libraries that use V. However, existing
> >>> implementation will also kill the process when the signal arrives,
> >>> finding insufficient stack frame in such cases. I'd choose the second
> >>> one if we only have these two options, because there is a chance that
> >>> the signal handler may not even run.
> >> I think we might have different views here. A process has a pre-V, a a=
nd
> >> post-V state. Is allowing a process to enter V without the correct
> >> preconditions a good idea? Allow to run with V turned on, but not able
> >> to correctly handle a signal (the stack is too small)?
> >
> > The requirement is sane, but the issue is user experience: User trying
> > to bring up some V code has no clue that deep in some startup code some
> > alt stack had been setup and causing his process to be terminated on
> > first V code.
> >
> >>
> >> This was the same argument that the Intel folks had when enabling
> >> AMX. Sure, AMX requires *explicit* enablement, but same rules should
> >> apply, no?
> >>
> >>>> 2. Sanitize altstack changes when V is enabled.
> >>> Yes, I'd like to have this. But it may be tricky when it comes to
> >>> deciding whether V is enabled, due to the first-use trap. If V is
> >>> commonly used in system libraries then it is likely that V will be
> >>> enabled before an user set an altstack. Sanitizing this case would be
> >>> easy and straightforward.
> >
> > Good. Lets have this in v14 as it seems reasonably easy to implement.
> >
> >>> But what if the user sets an altstack before
> >>> enabling V in the first-use trap? This could happen on a statically
> >>> program that has hand-written V routines. This takes us to the 1st
> >>> question above, should we fail the user program immediately if the
> >>> altstack is set too small?
> >
> > Please lets not cross threads. We discussed this already at top. While
> > ideally required, seems tricky so lets start with post-V alt stack chec=
k.
> >
> >> For me it's obvious to fail (always) "if the altstack is too small to
> >> enable V", because it allows to execute V without proper preconditions=
.
> >>
> >> Personally, I prefer a stricter model. Only enter V if you can, and
> >> after entering it disallow changing the altstack.
> >>
> >> Then again, this is *my* opinion and concern. What do other people
> >> think? I don't want to stall the series.
> >
> > I concur that the alt stack checking requirements are sensible in the
> > long run. We can add the obvious check for post-V case and see if there
> > is a sane way to flag pre-V case to.
>
> Reasonable. @Andy does this resonate with you as well?
Yes, it makes sense to me. I am making this happen on v14 :)

Thanks,
Andy
