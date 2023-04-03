Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494AF6D54FA
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 00:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjDCWzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 18:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjDCWzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 18:55:04 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB0128
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 15:55:03 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p203so36663691ybb.13
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 15:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680562503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SbwrA5SkjIm3Oo/y4Q0/GoeMG9DSOwyvN3uBqID1Rs=;
        b=UwR0RvHjOy/ViMEQvtK0rC51C+A+TxIg6eq3YF899i4n4gN5hVjNdLBs1w5wjH1vpl
         xeQpCzGNMaFgwhx3piVUCQVopDlsjim40EVuE+Xm0Zi6Pxb1QFIbzaGf0eP9sWPCxox+
         Dcri/yFBMo/2CvhzbWsg4ZSIlrqFuItFPYNEOzmWHNRHle0cRvtI0NnJ/fWhS8PGo/pl
         k+F/EVc7LfeUWQ34yWv4et9vAqOXIxTYpkv2X9E9ceKz30pyYmSpy8w2nFyk4xe79lRZ
         RFs8MRG7ix6WyIsq4fbHwhTz4elLLF6rOYNiodPTDWFwF7Jue4UOn6HXv1uJA58OsmrE
         8Pnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SbwrA5SkjIm3Oo/y4Q0/GoeMG9DSOwyvN3uBqID1Rs=;
        b=leBbQ/EQ2E0ozb6Zje913u0Y1jm+S7MyS8ZeSGomPpyhvgJEZp6KJmr9XQ6+aaWhXS
         1/fzbkQX1eKOMOmLmijpMwXFSBh0yPj8ZfUerA/xr7WDa2asqAMbibhEunqUdDzQWVwi
         Mr75MHmFerplIzZgj9chCq+QA9RGC4i9uADL2rD1Qat4XIqxaClN8MN34bZEdCVY4XCU
         rRBl1WwRZTBhRKB6Pt7Ge4gigsNOHg9bOAuegyUqSp+vjrkTEbS3tsGWyx8BVfjsVz0m
         rEJYAE+FH2b9VEtzP/oa4HWILMqgQQDBph2rlVQMZtlhL8npoDpgMyY2x/g6FlOYmc1D
         h/zQ==
X-Gm-Message-State: AAQBX9cvTN8XqLlo8udFRwvDKV0DAtBNmM76C+SyBRC6mmtMnh0DLVxU
        dsF+tuqWwFjoDn4FzXzdJthfxKVFMoFE8h5nTV4RhQ==
X-Google-Smtp-Source: AKy350YzkL5IcSMHvcZCvjJizvD8MZBdvki9wiX9dERnzP1oulfk4H40UGW8jOkpkEbhYvLKLpoieRkbGzuvgEq2mFg=
X-Received: by 2002:a25:e00a:0:b0:b6c:48c3:3c1c with SMTP id
 x10-20020a25e00a000000b00b6c48c33c1cmr545625ybg.13.1680562502878; Mon, 03 Apr
 2023 15:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <20230306224127.1689967-17-vipinsh@google.com>
 <ZCOEiVT31xEPKZ3H@google.com> <ZCSLnRj2V5tOx4gU@google.com>
In-Reply-To: <ZCSLnRj2V5tOx4gU@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 3 Apr 2023 15:54:27 -0700
Message-ID: <CAHVum0fo75hZB+km5zwoBPS5B+jC7BH1Ckdqwfr4_0Vjar-A+A@mail.gmail.com>
Subject: Re: [Patch v4 16/18] KVM: x86/mmu: Allocate numa aware page tables
 during page fault
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 12:04=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Tue, Mar 28, 2023 at 05:21:29PM -0700, David Matlack wrote:
> > On Mon, Mar 06, 2023 at 02:41:25PM -0800, Vipin Sharma wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 64de083cd6b9..77d3aa368e5e 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -787,7 +787,7 @@ struct kvm_vcpu_arch {
> > >     struct kvm_mmu *walk_mmu;
> > >
> > >     struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > > -   struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > > +   struct kvm_mmu_memory_cache mmu_shadow_page_cache[MAX_NUMNODES];
> >
> > I think we need an abstraction for a NUMA-aware mmu cache, since there
> > is more than one by the end of this series.
> >
> > e.g. A wrapper struct (struct kvm_mmu_numa_memory_cache) or make
> > NUMA-awareness an optional feature within kvm_mmu_memory_cache, plus
> > common helper functions for operations like initializing, topping-up,
> > and freeing.
> >
> > I have some ideas I want to try but I ran out of time today.
>
> Something like this (compile test only, applies on top of this series):
>

It looks good to me. I was not sure in the first place if having a new
struct will be acceptable. Below abstraction looks good to me, I will
update my patches accordingly in the next version.

Thanks
