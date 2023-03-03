Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778D16AA464
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 23:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjCCWcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 17:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjCCWbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 17:31:48 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B314867826
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 14:27:00 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536af432ee5so69472927b3.0
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 14:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677882344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dprC7qZO1cHGwsr1IUv4PtLB24sqSz5Qq9Dm2gbp4vM=;
        b=lBk86GfMSCejZ8rhduAUzvM1otTN/iByzyT/2A3yTVYMWGvBh93OeKvwp/MbFFYdAa
         p009+QQn+zjuSS2Q5TyBzVJRb1lFMhWDLBIm1oD3WVlwily2kQ7k0OxaNE54mxQh3719
         /0cJTld9OHC+wtFAlGdO3sdk26/nfO0Or44SJQ5lKbBtuQfse03xPyp7o8/dhCpO0IfR
         iF+PK3xPBcOMKr6X2cyPg7uq2eDb+MUYN7IKzLxMM3t8do7REWxQNYTrrmx4/DrdfMmK
         IaEwQuc3nKS709frupYUK06i+XV8pOEYU38f/V/QXDxH/cniJR/TmOkw8ueS/hJqgHlD
         022w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677882344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dprC7qZO1cHGwsr1IUv4PtLB24sqSz5Qq9Dm2gbp4vM=;
        b=SVLD9+RrQZu7AopvtFA0NNR2xawvye3RTRlnau4w4i/IhFN+ngVrBcsv7J/dLrzi7s
         Qbs7eBWPN7ozReVi7H06WBFulo1/EQTnTokqR1csOe/js41XtY7DKdZOzYsJuQjlRnnr
         utn6G7BedulzjIi++TPUvb/isFL4VEZKD3dtkpBOBb0iX5gnTUbbw81Dy2SbKbNeSovL
         2uILHAh0wjpaH6wnqX/0cEH7t5AvXsAU5db+0Ob67/hdd3BKzjGgxeiDbWrPNv7tQISy
         zw3lDlrhT694+KeYR88WzGTN0zYPiljyrrbkv0w3nOY87WY+wtUAnmHqyJ4Dd2Qkz4eC
         xOtQ==
X-Gm-Message-State: AO0yUKWsDiIZHlnFRs0aN8DrLvpfmhot3UnzpuuEoaTTmE14Tq/BMAP0
        AHtu/nN53WojTF4sMsuMefc0wxKONtoETHWP3/XBZA==
X-Google-Smtp-Source: AK7set+k0SpkmGco6KXM5//WS9+cr1il4OEosQaWhtMZvAdCGVzRSAxILRytDLDTNpT7jOOsSGbAGYSKI/Azwg9cQf4=
X-Received: by 2002:a81:b717:0:b0:52f:45a:5b00 with SMTP id
 v23-20020a81b717000000b0052f045a5b00mr2028530ywh.2.1677882344492; Fri, 03 Mar
 2023 14:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-8-aaronlewis@google.com> <ZAJjoiZopqIXDoDc@google.com>
In-Reply-To: <ZAJjoiZopqIXDoDc@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 3 Mar 2023 22:25:33 +0000
Message-ID: <CAAAPnDGjNjWczonLU1NNv4zk8865bpGB=Df-W-r4Wy=qi1--CA@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: selftests: Add XFEATURE masks to common code
To:     Mingwei Zhang <mizhang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 3, 2023 at 9:16=E2=80=AFPM Mingwei Zhang <mizhang@google.com> w=
rote:
>
> On Fri, Feb 24, 2023, Aaron Lewis wrote:
> > Add XFEATURE masks to processor.h to make them more broadly available
> > in KVM selftests.
> >
> > Use the names from the kernel's fpu/types.h for consistency, i.e.
> > rename XTILECFG and XTILEDATA to XTILE_CFG and XTILE_DATA respectively.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  .../selftests/kvm/include/x86_64/processor.h  | 17 ++++++++++++++
> >  tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
> >  2 files changed, 25 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/t=
ools/testing/selftests/kvm/include/x86_64/processor.h
> > index 62dc54c8e0c4..ebe83cfe521c 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -48,6 +48,23 @@ extern bool host_cpu_is_amd;
> >  #define X86_CR4_SMAP         (1ul << 21)
> >  #define X86_CR4_PKE          (1ul << 22)
> >
> > +#define XFEATURE_MASK_FP             BIT_ULL(0)
> > +#define XFEATURE_MASK_SSE            BIT_ULL(1)
> > +#define XFEATURE_MASK_YMM            BIT_ULL(2)
> > +#define XFEATURE_MASK_BNDREGS                BIT_ULL(3)
> > +#define XFEATURE_MASK_BNDCSR         BIT_ULL(4)
> > +#define XFEATURE_MASK_OPMASK         BIT_ULL(5)
> > +#define XFEATURE_MASK_ZMM_Hi256              BIT_ULL(6)
> > +#define XFEATURE_MASK_Hi16_ZMM               BIT_ULL(7)
> > +#define XFEATURE_MASK_XTILE_CFG              BIT_ULL(17)
> > +#define XFEATURE_MASK_XTILE_DATA     BIT_ULL(18)
> > +
> > +#define XFEATURE_MASK_AVX512         (XFEATURE_MASK_OPMASK | \
> > +                                      XFEATURE_MASK_ZMM_Hi256 | \
> > +                                      XFEATURE_MASK_Hi16_ZMM)
> > +#define XFEATURE_MASK_XTILE          (XFEATURE_MASK_XTILE_DATA | \
> > +                                      XFEATURE_MASK_XTILE_CFG)
> > +
> >  /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  =
Eww. */
> >  enum cpuid_output_regs {
> >       KVM_CPUID_EAX,
> > diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/test=
ing/selftests/kvm/x86_64/amx_test.c
> > index 4b733ad21831..14a7656620d5 100644
> > --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> > @@ -33,12 +33,6 @@
> >  #define MAX_TILES                    16
> >  #define RESERVED_BYTES                       14
> >
> > -#define XFEATURE_XTILECFG            17
> > -#define XFEATURE_XTILEDATA           18
> > -#define XFEATURE_MASK_XTILECFG               (1 << XFEATURE_XTILECFG)
> > -#define XFEATURE_MASK_XTILEDATA              (1 << XFEATURE_XTILEDATA)
> > -#define XFEATURE_MASK_XTILE          (XFEATURE_MASK_XTILECFG | XFEATUR=
E_MASK_XTILEDATA)
> > -
> >  #define XSAVE_HDR_OFFSET             512
> >
> >  struct xsave_data {
> > @@ -187,14 +181,14 @@ static void __attribute__((__flatten__)) guest_co=
de(struct tile_config *amx_cfg,
> >       __tilerelease();
> >       GUEST_SYNC(5);
> >       /* bit 18 not in the XCOMP_BV after xsavec() */
> > -     set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
> > -     __xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
> > -     GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA)=
 =3D=3D 0);
> > +     set_xstatebv(xsave_data, XFEATURE_MASK_XTILE_DATA);
> > +     __xsavec(xsave_data, XFEATURE_MASK_XTILE_DATA);
> > +     GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILE_DATA=
) =3D=3D 0);
> >
> >       /* xfd=3D0x40000, disable amx tiledata */
> > -     wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
> > +     wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
> >       GUEST_SYNC(6);
> > -     GUEST_ASSERT(rdmsr(MSR_IA32_XFD) =3D=3D XFEATURE_MASK_XTILEDATA);
> > +     GUEST_ASSERT(rdmsr(MSR_IA32_XFD) =3D=3D XFEATURE_MASK_XTILE_DATA)=
;
> >       set_tilecfg(amx_cfg);
> >       __ldtilecfg(amx_cfg);
> >       /* Trigger #NM exception */
> > @@ -206,11 +200,11 @@ static void __attribute__((__flatten__)) guest_co=
de(struct tile_config *amx_cfg,
> >
> >  void guest_nm_handler(struct ex_regs *regs)
> >  {
> > -     /* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
> > +     /* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
> >       GUEST_SYNC(7);
> > -     GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) =3D=3D XFEATURE_MASK_XTILEDA=
TA);
> > +     GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) =3D=3D XFEATURE_MASK_XTILE_D=
ATA);
> >       GUEST_SYNC(8);
> > -     GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) =3D=3D XFEATURE_MASK_XTILEDA=
TA);
> > +     GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) =3D=3D XFEATURE_MASK_XTILE_D=
ATA);
> >       /* Clear xfd_err */
> >       wrmsr(MSR_IA32_XFD_ERR, 0);
> >       /* xfd=3D0, enable amx */
> > --
> > 2.39.2.637.g21b0678d19-goog
> >
> Can I take your commit into my series? This seems to be closely related
> with amx_test itself without much relationship with the xcr0 test.
> Thoughts?

Yes, please do.  I still need to have it here to have access to the
common xfeatures.
