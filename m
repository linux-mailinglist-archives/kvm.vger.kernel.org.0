Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC937CF385
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 11:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345017AbjJSJG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 05:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344977AbjJSJG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 05:06:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71EEFA
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:06:54 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40838915cecso16449865e9.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1697706413; x=1698311213; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTzH6q/KHuyR0ZINbw+hcjZ5+0x6X/p2cjmFJ06sw1g=;
        b=d65+L4mh9pZwErGX3oVoWaQdFL63XZeAQHi/pUp2L5XSdRkkVTY4uxHcNTUC8Xac5T
         aSH+MCjYoqmwWxBAD2ohaPKxBCc5CiEVIvm5zPPKdF6yV0zhpa2B50MkAmia7l08xkZq
         76Z3WkoZiEi+uDpCJVKypBuQ/hdc9f9gze1TTwdociCtzuHtSDTF+fi9M+ZlgfkbXncs
         q27xu3r2nMymlSkVXE6U/RxJAyi00GhN2ni9mI5+6IdAy1loyIQ2tCk/BNwPSPUPw1py
         AwGresZqeYx+qOnVoRtNj5GLVBVDEWJSpLS/GyMKO7w6wW8N7ewxebVtePrWFHYYSM7d
         Ww0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697706413; x=1698311213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTzH6q/KHuyR0ZINbw+hcjZ5+0x6X/p2cjmFJ06sw1g=;
        b=ugkpM6Njkak2NsLvpeJQPij1kGlT5er3Oy5bbIBP2gxUKEVUnKHzxRr5rRENGXM9ti
         5bP4BGyyHHqR812KQ7R5gfitYFlanIW14rG0bx4C9VgOKKrClLnaEBbpxJgSkBNkp3Vc
         jvRHiYjp2CROC5uN9SpYcxQOiAiMGDhRlMd9KbPFbqRqJ/2SQRuZubgoJiyBPGQX6nxo
         aDHOn4psj1QqiNhwiNbcw1J+edJVO6/o+GdB4JZaVs/hE3iCsh+Wz4IytCy7dst5uBXI
         zeJBFqiczdo+OV9cLNLoeZ49EHOTfthJFZSQ4Zee/Ld7OEPafP+jFocRwfEAgbgHj8HU
         0RQQ==
X-Gm-Message-State: AOJu0Yz+hkDMOI6fAy1Q3nefGZZCw5enauTEBd8HtIeHjAvLLbM3mawn
        hmPJgB5O/FsAg+v1BtpqYIgjTN/YsndyZaHQv6mIxw==
X-Google-Smtp-Source: AGHT+IHSkQS9qNtpAIEMi6sxLaFTkgi+j6Rf7WXRtDe59N4GEvIdt/PZ1MtRQGPplsiQPNtP0AvAANDdTsTJLGZENEE=
X-Received: by 2002:adf:db4b:0:b0:32d:b06c:80b5 with SMTP id
 f11-20020adfdb4b000000b0032db06c80b5mr1127928wrj.2.1697706413344; Thu, 19 Oct
 2023 02:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20231002151031.110551-1-alexghiti@rivosinc.com>
 <20231002151031.110551-5-alexghiti@rivosinc.com> <20231012-envision-grooving-e6e0461099f1@spud>
 <20231012-exclusion-moaner-d26780f9eb00@spud> <20231013-19d487ddc6b6efd6d6f62f88@orel>
In-Reply-To: <20231013-19d487ddc6b6efd6d6f62f88@orel>
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
Date:   Thu, 19 Oct 2023 11:06:42 +0200
Message-ID: <CAHVXubgZ12x5O4Uo404u8uL2qhrtdN5w-DQFvnBib3XhhtrK1Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] riscv: Suffix all page table entry pointers with 'p'
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Conor Dooley <conor@kernel.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conor, Marco, Andrew,

On Fri, Oct 13, 2023 at 11:58=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>
> On Thu, Oct 12, 2023 at 12:35:00PM +0100, Conor Dooley wrote:
> > On Thu, Oct 12, 2023 at 12:33:15PM +0100, Conor Dooley wrote:
> > > Hey Alex,
> > >
> > > On Mon, Oct 02, 2023 at 05:10:30PM +0200, Alexandre Ghiti wrote:
> > > > That makes it more clear what the underlying type is, no functional
> > > > changes intended.
> > >
> > > Scanning through stuff on patchwork, this really doesn't seem worth t=
he
> > > churn. I thought this sort of Hungarian notation-esque stuff was a
> > > relic of a time before I could read & our docs even go as far as to
> >
> > s/go/went/, I see the language got changed in more recent releases of
> > the kernel!
>
> The documentation seems to still be against it, but, despite that and
> the two very valid points raised by Marco (backporting and git-blame),
> I think ptep is special and I'm mostly in favor of this change. We may
> not need to s/r every instance, but certainly functions which need to
> refer to both the pte and the ptep representations of entries becomes
> more clear when using the 'p' convention (and then it's nice to have
> ptep used everywhere else too for consistency...)
>
> Anyway, just my 2 cents.

I started changing that in one function and another one, and another
one...etc up to every instance. I still think that it makes things
clearer, but that's subjective, you raised valid points and I'd really
like to see this land in 6.7 so I'll revert this patch and send a v2.

Thanks for your feedbacks,

Alex

>
> Thanks,
> drew
