Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B655057A15C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiGSOZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiGSOZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:25:33 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E9C422CB
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:10:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id tk8so16049366ejc.7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSlBICGVylQNfGLNPy9PcFvdIoXz1R8fiwEJrPtfAT8=;
        b=XI6uSXUUjHP4PxFP5xtI0lE1OxcEFTh9vaN9aWV9RZ51ng7YLS5mO9TfIiszL4L5Qf
         AseH24Z1sqYGSshg4DJd/XzBR8Ehvo2fV0qc4MtFJ5zWYaHnAXTshxaV3VL0YikisBhF
         821e9V1aqdKAVukcv4xQC5hepaYsb/akXGKKC5bU2dWao6u7Sp/DHVODcRtZGgU2K/BI
         SdGfvVDDyMhavlds0k1Y/OHnrm/9Kh+kF+/mfkYdUcdBXKdwSzKhMr9lzpP4ih3fEXwv
         +0qP99nG85AZX2XooIANOJFWtIwud4s60gcgn3sjt+fONIqQs7DVSDk5LtVQHAMSt2gn
         izUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSlBICGVylQNfGLNPy9PcFvdIoXz1R8fiwEJrPtfAT8=;
        b=d3B2FGCUxpWxvO5KkRdCAK+tytgk8vwOW/cQ/afuXUMcqVx9MHlYLC/rYHq0s7e8ZR
         Obag8xIXXRT/UgCEE28Nh0vWJLx/JFtzhUSJ25fNrrvJQuORqfrLPneAk/WE2TwGZSRv
         sWKOpYED2u9u+ZsqKOaaOD+2yRcaE78PVgO9Pi9V9UghNGWsi9TxuB+C0eDEVXj/mMZf
         pI00gGUNRV5MhJNppPF5u0TNNAdQmuSyn8Ug4u2poUIHeSTv08EJe6/jq21c48XxF/5n
         84dVE4myqAb4ePeDJvA4sMAr64Dn9H+3a5v8x9v1vdt+vfgSFEstv7rvQkxtwlc00wTq
         NXUQ==
X-Gm-Message-State: AJIora+J4WbkapWYYVA7N+X8vOXGa53vA4ItS1HbigERbzRwiyfNgrzD
        eSXWfpdOQ3ifo0/umJIanYGgoH5SvUS1V0bCvwsREA==
X-Google-Smtp-Source: AGRyM1uhnS6OmS6G6f2PH0IaO4r/qi0XSl/Nk0fx26ErgePmSPQkUlX7XZWXly4+HDqhv3dWwKf2eceBB6JNbEF2i5g=
X-Received: by 2002:a17:907:2bf4:b0:72b:3336:ca9e with SMTP id
 gv52-20020a1709072bf400b0072b3336ca9emr30580182ejc.341.1658239813388; Tue, 19
 Jul 2022 07:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220630135747.26983-1-will@kernel.org> <20220630135747.26983-15-will@kernel.org>
 <Ytax6L2BUt5ON1Dp@google.com> <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
In-Reply-To: <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
From:   Quentin Perret <qperret@google.com>
Date:   Tue, 19 Jul 2022 16:10:02 +0200
Message-ID: <CAPwzONkiZ92JKicg6rh+bBQdRG=LKvVET83o8PLKTJbbfLsjUg@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] KVM: arm64: Add pcpu fixmap infrastructure at EL2
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jul 19, 2022 at 4:09 PM Quentin Perret <qperret@google.com> wrote:
>
> On Tue, Jul 19, 2022 at 3:30 PM Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > >  static struct hyp_pool host_s2_pool;
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > index d3a3b47181de..17d689483ec4 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > @@ -14,6 +14,7 @@
> > >  #include <nvhe/early_alloc.h>
> > >  #include <nvhe/gfp.h>
> > >  #include <nvhe/memory.h>
> > > +#include <nvhe/mem_protect.h>
> > >  #include <nvhe/mm.h>
> > >  #include <nvhe/spinlock.h>
> > >
> > > @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
> > >  unsigned int hyp_memblock_nr;
> > >
> > >  static u64 __io_map_base;
> > > +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
> > >
> > >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> > >                                 unsigned long phys, enum kvm_pgtable_prot prot)
> > > @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
> > >       return 0;
> > >  }
> > >
> > > +void *hyp_fixmap_map(phys_addr_t phys)
> > > +{
> > > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > > +     int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> > > +                                   phys, PAGE_HYP);
> > > +     return ret ? NULL : addr;
> > > +}
> > > +
> > > +int hyp_fixmap_unmap(void)
> > > +{
> > > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > > +     int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> > > +
> > > +     return (ret != PAGE_SIZE) ? -EINVAL : 0;
> > > +}
> > > +
> >
> > I probably missed something but as the pagetable pages for this mapping are
> > pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
> > would be more appropriate, especially the callers in the subsequent patches do
> > not seem to check for this function return value?
>
> Right, I think that wouldn't hurt. And while looking at this, I
> actually think we could get rid of these calls to the map/unmap
> functions entirely by keeping the pointers to the reserved PTEs
> directly in addition to the VA to which they correspond in the percpu
> table. That way we could manipulate the PTEs directly and avoid
> unnecessary pgtable walks. Bits [63:1] can probably remain untouched,

 Well, the address bits need to change too obviously, but rest can stay.

> and {un}mapping is then only a matter of flipping bit 0 in the PTE
> (and TLBI on the unmap path). I'll have a go at it.
>
> Cheers,
> Quentin
