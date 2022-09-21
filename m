Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848D55BF517
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiIUDxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiIUDxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:35 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C847E811
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:28 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r3-20020a05600c35c300b003b4b5f6c6bdso2982880wmq.2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YjNJwrSGGsmqwkos7/v8yu+we95EXK5+N0CYYMWfM9Q=;
        b=VN/89PxJc45yG4lc8yqdX46Pa4D79Mh+lXq0MdwtCoqk6H+vPb0LYEGHxXxS0OAM1+
         7RmnF/LUaYOBG1W3DFvw8Lkn5MpRYPZwJLvhEs7ruA2GSOv3b2YvH7hUZOHrdR2zbEiA
         yTfU1+O3beASWzV4c0GeNLj05YiKbgIKYNkV+PJcuPE4wxVo2TXv9YZLiaatDHLgtpmQ
         GON/Vu3+5/D77WWTrzPWPFcpgy4Ornyxr7/HX/qmrufG41d4inNUeDdtVhrlLoQr110w
         hcvpstlAuApR4OeGLmxuVIaGhkDR6bTDnFFtUPIHaLmqLZtxkutVbKpmn2u0NjMB7wPB
         vOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YjNJwrSGGsmqwkos7/v8yu+we95EXK5+N0CYYMWfM9Q=;
        b=pOzacA6OOA5NG8UOVTZf+vC36mZcu+WHwuL6rOxat+fwTFEbJw+6TyV9p9ipvN3IjR
         tEByjIKMrQl9JDqLTw0c1wFEkn7pDubUhkJ9g8Ed0ujSl75FnQoRU2q0tqfyZhj9L4yk
         aCx99Y/2Zc08FkLj9ESRbisdUfV2Wl/JyMb1/44VH0k5iemKGJhdJZ0bmueR2NSxbIE2
         DyB29P7ELzZatvQclpx2BYUdF8X+7AD8ZSU6HGX36NooyJIZLCKFin+Bj0WtmqX302p7
         pcgospWnIRqII5G+SnhkRAYV/MDZ08RFSRy7kpDMOW3RHLDK3HNiuYTekgWEZpd63Yok
         ZycQ==
X-Gm-Message-State: ACrzQf1Y+/tEX07FnCLkJPWvhtqd7qil9d3b3ZJUOk9mZSoCyWjm/n3z
        QzAnZPIrC6/lRMHPlJKyC/Gy0dLipcWGYFtCbg9byA==
X-Google-Smtp-Source: AMsMyM4SOMzNPoEP4Br6h1r2CJRQYNKipv9r9MWilIR/DuJ8W+mBmmO97KOemPkCF+KRZPoaDKwtz/8KvAWwatKO7qo=
X-Received: by 2002:a05:600c:2202:b0:3b4:6189:fc6a with SMTP id
 z2-20020a05600c220200b003b46189fc6amr4451007wml.171.1663732406891; Tue, 20
 Sep 2022 20:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220810193033.1090251-4-pcc@google.com> <202208111500.62e0Bl2l-lkp@intel.com>
 <YxDy+zFasbAP7Yrq@arm.com> <YxYrgyybBMUqFswq@arm.com> <878rmfkzbu.wl-maz@kernel.org>
 <Yynewxzc6Zy8ls0N@arm.com> <871qs6kntl.wl-maz@kernel.org> <YynxJYrd15aUJsmp@arm.com>
In-Reply-To: <YynxJYrd15aUJsmp@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 20 Sep 2022 20:53:15 -0700
Message-ID: <CAMn1gO6vhf=xaHreysfwrunAAmV8OwxxtA9qOP0Bq+TkjrJQJg@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kernel test robot <lkp@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kbuild-all@lists.01.org,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
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

On Tue, Sep 20, 2022 at 9:58 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Sep 20, 2022 at 05:33:42PM +0100, Marc Zyngier wrote:
> > On Tue, 20 Sep 2022 16:39:47 +0100,
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Mon, Sep 19, 2022 at 07:12:53PM +0100, Marc Zyngier wrote:
> > > > On Mon, 05 Sep 2022 18:01:55 +0100,
> > > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > > Peter, please let me know if you want to pick this series up together
> > > > > with your other KVM patches. Otherwise I can post it separately, it's
> > > > > worth merging it on its own as it clarifies the page flag vs tag setting
> > > > > ordering.
> > > >
> > > > I'm looking at queuing this, but I'm confused by this comment. Do I
> > > > need to pick this as part of the series? Or is this an independent
> > > > thing (my hunch is that it is actually required not to break other
> > > > architectures...).
> > >
> > > This series series (at least the first patches) won't apply cleanly on
> > > top of 6.0-rc1 and, of course, we shouldn't break other architectures. I
> > > can repost the whole series but I don't have the setup to test the
> > > MAP_SHARED KVM option (unless Peter plans to post it soon).
> >
> > I don't feel brave enough to take a series affecting all architectures
>
> It shouldn't affect the others, the only change is that PG_arch_2 is now
> only defined for arm64 but no other architecture is using it. The
> problem with loongarch is that it doesn't have enough spare bits in
> page->flags and even without any patches I think it's broken with the
> right value for NR_CPUS.
>
> > so late in the game, and the whole thing had very little arm64
> > exposure. The latest QEMU doesn't seem to work anymore, so I don't
> > have any MTE-capable emulation (and using the FVP remotely is a pain
> > in the proverbial neck).
> >
> > I'll come back to this after the merge window, should Peter decide to
> > respin the series.
>
> It makes sense.

Apologies for the delay, I've now sent out v4 of this series which
includes the patches on your branch.

Peter
