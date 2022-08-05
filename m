Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287F058AE54
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240654AbiHEQqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiHEQqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:46:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A1D22515
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:46:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f20so4152803lfc.10
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 09:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=v4S4GpdOqCe9ywueQ5iRWEaheO0mHSYsO11UhtnP4Kw=;
        b=eiMdbmKw/RMPYU34GsfGF9tqVlLo0yhNy07CN3kvU9+gvJKdS6LGyZajM6t6MC++b+
         EaarukS4tP9X663Y3KYt/fmJ3MIexUsBcUrsJmphJ89P10rYnNY/4IJa0yemwbNv+QyT
         4aSNtPSvgbaUpfxRgBXeP/sCkwBFjTC3BW0oA2FrnPmcbDbShytiKU7e1tSFLK0lrP/F
         LOekxXj0Ew1YLwuoqh6PBtBwlPFqxtOSu9sG2R2GR3wizZvXcSMqZ2ynziODrpMiZBKJ
         xH9hnywLvKq5boHLg0HlblFIqSx72j4//oOEs4H9SCU/LjaxGg18LA00agBBPKsvkXeR
         VQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=v4S4GpdOqCe9ywueQ5iRWEaheO0mHSYsO11UhtnP4Kw=;
        b=nV0xoYL9DiAdwCcjizIWlvF7dEPoUCR3pUyx2arn6svomi5MOSWUq5qBNFMK8br7qj
         IavvXTb6SBc/i2ousFZF80wSwukRuhDWZm9++kYOqqh+tYg1k9MusgA/S5dhJmRjs9UZ
         w9yygoavGxmbjtKshGkUC11t2XXOK9kvrE1StDdbxcnfA7Id8ksJ7Uw1dTiIuZZDeIWe
         iSNAam/Zd8K7BXslPJlnjx4ZqYNWNwUc5YUsRfo+iwczTu/U/MkD/W2lTfgRVwTlZsT2
         74GbDzMKNWoF5KqW9II2bZSYWthQx5QA3/TD2Wp4EJ6YX85HdUQIHu9mVExATrduL0zs
         nm4Q==
X-Gm-Message-State: ACgBeo3yo+HSilJk7kltElkC0DPJRs6WCTILDEIvt3SPeZqgRO/9iAwO
        KzA2gqX6T3nw5KXzBVOS06V/07Xo4j6gpqXzMCeXmw==
X-Google-Smtp-Source: AA6agR7ErOMbgNtM3KHMVUr3afCrBmKArRGWmslrkB2fIIxGYS2UF8B+73dnoapsgas/bKbCfxwS4kEHT4YRzYKJJVw=
X-Received: by 2002:a19:ab02:0:b0:48b:3f9:add1 with SMTP id
 u2-20020a19ab02000000b0048b03f9add1mr2724754lfe.329.1659717993081; Fri, 05
 Aug 2022 09:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
 <YuxOHPpkhKnnstqw@google.com> <CALzav=cf_2dz8vMD+D_Xo1zBJZndJmtMBxbnYpQKP_mci1np=A@mail.gmail.com>
 <BL1PR11MB5978DB988E482B8329339881F79E9@BL1PR11MB5978.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5978DB988E482B8329339881F79E9@BL1PR11MB5978.namprd11.prod.outlook.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 5 Aug 2022 09:46:06 -0700
Message-ID: <CALzav=cJ_Bp2Vg1n=aHv4ewH0U-rDGG5Nni=0CdizG-64GtpLA@mail.gmail.com>
Subject: Re: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 5:04 PM Huang, Kai <kai.huang@intel.com> wrote:
>
> > > In addition to the suggestions above, I'd suggest breaking this patch
> > > up, since it is doing multiple things:
> > >
> > > 1. Patch initialize shadow page tables to EMPTY_SPTE (0) and
> > >    replace TDP MMU hard-coded 0 with EMPTY_SPTE.
> > > 2. Patch to change FNAME(sync_page) to not assume EMPTY_SPTE is 0.
> > > 3. Patch to set bit 63 in EMPTY_SPTE.
> > > 4. Patch to set bit 63 in REMOVED_SPTE.
>
> I think 1/2 can be separate patches, but 3/4 should be done together.
>
> Patch 3 alone is broken as when TDP MMU zaps SPTE and replaces it with REMOVED_SPTE, it loses bit 63.  This is not what we want.  We always want bit 63 set if it is supposed to be  set to a non-present SPTE.

How is patch 3 alone be broken? The TDX support that depends on bit 63
does not exist at this point in the series, i.e. setting bit 63 is
entirely optional and only done in preparation for future patches.

>
> But I also don't see splitting to 3  patches is absolutely worth to do as doing above in one patch is also fine to me.

Splitting patches up into logically independent changes makes it a lot
easier to review, and therefore reduces the chances of bugs.

Smaller changes also makes it easier for patches to get through the
review process, because reviewers can sign-off on specific patches
with Reviewed-by tags while discussion continues on patches that still
need more work. If the patches are too large, it makes it more
difficult to collect Reviewed-by tags because the entire patch has to
be correct.

Case in point, the above patch description has 9 paragraphs because
the patch is doing so many different things. It's difficult to keep
track of all of the different changes this patch aims to accomplish
when reviewing the code.
