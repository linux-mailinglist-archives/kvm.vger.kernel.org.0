Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F05697FBF
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjBOPlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 10:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBOPlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 10:41:46 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A6E3B0D2
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:41:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r2so19584204wrv.7
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hLvaMoa9MrI3Z7l2TQNfZp8HXv5vwrbeWjwMUNnrfB4=;
        b=heaaXyGJoKe/z2CXsf0Awel/ppDlB0AGgfmdPsTqgmB1lrLUi2i4H8qvST+LS267m4
         Tfhx/QsWcKvEC6VyTtd6+x1RvFuCZa3ALpbi9X+ey2hWWmcfHFSuyNLQ/ilnwiSmLZOG
         5WBHa4u0TRHOwH5JYQ2RMwjIVfZkfCqqdoKAPlnKpVNPt+qZ3KE3Kt2ZU+2PC/0VuC4+
         6m/wqRMs3NQ9EGscfSiRDgefDKPWwnHdRaGnow99/vEWThy0anzB9HY7N1ud3Rp/+TVv
         tsV5hR2mmCMdtHK5xqSmm2GU+XCPObAzm+/jmWobquYrwdt3+vQCMUvG2k7JXUBsI/tJ
         IeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hLvaMoa9MrI3Z7l2TQNfZp8HXv5vwrbeWjwMUNnrfB4=;
        b=FnoAnNk9o1U6QT8ZeYadYUbazdoAAcF2+i4G+A9pOLXJ7GPf1AxfwUdvvt2mONcFhq
         wS8Hs+zJB3iKRyDYcZAQomQJXYIFGfC5iauVLJ1HkZEcvatk/vVVE+XSl09sZUyO/hCw
         xqoa9hfuHPbJapRszU1kuhWYyMMm7Lm8baMnDM2OiFQTFr1F7UtPG9w/4gL5+C4C5NoN
         spHjlgUXFkBI+sGvM5IDGXD8UhMYeetL6ijsUY/EV4oN1uBsWrsosjr4NiQa7KunhTjN
         9t57ZgFI6PcimMhElRt/ezPjiKxSCre82ts+r2tkkDjcLWWksCXMspYmY5T3VT4Cecic
         OLYg==
X-Gm-Message-State: AO0yUKVjvtECqyxm6ZS/vdGUtxaexJx/ixj1e0Cl9H5aI0Peii23Mg+1
        WqgU0CxI2H0cL0PKRDs+3yEMhnnqTh84CbUuur4TCQ==
X-Google-Smtp-Source: AK7set+b9/UowKKmxsgaPubC/BZ5DrJE7eXauwJzSkgN8VPP8Hkk1DrwXc+anhjALud5xSPlL3U86yuYqSjKTtJD6bU=
X-Received: by 2002:adf:e3c7:0:b0:2c5:4dbd:e8ac with SMTP id
 k7-20020adfe3c7000000b002c54dbde8acmr59927wrm.120.1676475701345; Wed, 15 Feb
 2023 07:41:41 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-3-apatel@ventanamicro.com> <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
In-Reply-To: <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
From:   =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date:   Wed, 15 Feb 2023 16:41:29 +0100
Message-ID: <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     apatel@ventanamicro.com, pbonzini@redhat.com,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 1:25 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote:
> > We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> > and Ssaia (S-mode AIA CSRs).
>
> This has pretty much the same problem that we had with the other
> AIA-related ISA string patches, where there's that ambiguity with the
> non-ratified chapters.  IIRC when this came up in GCC the rough idea was
> to try and document that we're going to interpret the standard ISA
> strings that way, but now that we're doing custom ISA extensions it
> seems saner to just define on here that removes the ambiguity.


To avoid the impression that I did not work on that, here is the v2
from November,
that attempts to document this:
  https://gcc.gnu.org/pipermail/gcc-patches/2022-November/607326.html

My proposed text was:
+Note, that AIA support (@samp{Smaia} and @samp{Ssaia}) is based on an AIA
+specification, which is frozen but contains draft chapters ("Duo-PLIC" and
+"IOMMU Support").

Btw, I did not get any feedback on that patch.

I also tried to address this on spec level (the PR has been linked) and raised
that to tech-aia (the conversation has been linked).

Another thing that I want to highlight, since it was discussed a lot recently
(e.g. just a few minutes ago in tech-chairs).
There is a chance of a last-minute spec change of AIA:
  https://github.com/riscv/riscv-aia/pull/37

BR
Christoph



>
>
> I just sent
> <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/>
> which documents that.
>
> > We extend the ISA string parsing to detect Smaia and Ssaia extensions.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h | 2 ++
> >  arch/riscv/kernel/cpu.c        | 2 ++
> >  arch/riscv/kernel/cpufeature.c | 2 ++
> >  3 files changed, 6 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 86328e3acb02..341ef30a3718 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
> >       RISCV_ISA_EXT_ZIHINTPAUSE,
> >       RISCV_ISA_EXT_SSTC,
> >       RISCV_ISA_EXT_SVINVAL,
> > +     RISCV_ISA_EXT_SMAIA,
> > +     RISCV_ISA_EXT_SSAIA,
> >       RISCV_ISA_EXT_ID_MAX
> >  };
> >  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > index 1b9a5a66e55a..a215ec929160 100644
> > --- a/arch/riscv/kernel/cpu.c
> > +++ b/arch/riscv/kernel/cpu.c
> > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> >   *    extensions by an underscore.
> >   */
> >  static struct riscv_isa_ext_data isa_ext_arr[] = {
> > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>
> This will conflict with that ISA string refactoring I just merged.  It
> should be a pretty mechanical merge conflict, but if you want we can do
> a shared tag with the first few patches and I can handle the merge
> conflict locally.
>
> >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index 93e45560af30..3c5b51f519d5 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> >                               SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
> >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
> >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
> > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
> > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
> >                       }
> >  #undef SET_ISA_EXT_MAP
> >               }
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
