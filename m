Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36CA55CA6B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiF1Eje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 00:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243707AbiF1Ejc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 00:39:32 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAA01CFCC
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 21:39:31 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id l81so15706514oif.9
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 21:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDdyOHfuaSPrO+ShqzHn1BwrFSKQa05Kuj5osYJqhR4=;
        b=oMR15QwZnKWalp74iZ5PLdIXas8zLKpMFgxbBlIVLi7zOzE8lgHtQVmNhOuzf/zfID
         DAiSp0f3liE699cQpPyUrnqvY6ck5fTsLaAB3p6eMmtaYVhCCGUj90xwumCA9z+7TRh5
         GI0SBSy05AiVNj1aZg2A1M8XL5auFfxtEUGiHqgQTFUyVsTAywXRPGFnp8/8W4G4x779
         oVWCuy5QN1VqnIVnJCkHfht2NwHcVOdx3w5c1Cl2maZ06YVq/fl9dgoDoGiEX7+I34TP
         5X+OI1B7qj/7mn8Bauup0TXCPtmOFrJaAlO55nJvok+r4Now/TKqVD/mxt+whVzybZzG
         Orpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDdyOHfuaSPrO+ShqzHn1BwrFSKQa05Kuj5osYJqhR4=;
        b=H4/MxNsQfWhw8drJizJYpzYjyyo1Dd9wxfNKHiNUicxJANRPr2QaBWhgsON/r496W9
         Crzi0Rks6f72zB6gQ40Tz1C6mlcPtggZRtijSqNcWpcHiJ2cQMuSNyNVRB8UKAAcCJhJ
         9HIzfvHFDcTeOXHktQuw4FOPsMAM6lVOjnCfCXkj1IAA9im4e6JUiIDvmcv/LZau2qWN
         l6NlCD/Qx2Aq8X2es94IkVN7bbdIE4srqVdTItiNVqonpa+eGu714QJuFmw2VRPvwn4H
         +GKakepkmqqXsGouFnBMeKxC/zbqm2zTCimaW0A8pBYDLQfDXzISQi+1OkVmHsjpYk3n
         ZzNQ==
X-Gm-Message-State: AJIora9dJsiFu9Nh7GjHCZaqnwYCaMt6sFAG1sQH10hLR3hEdyg/5J8u
        BWkSnRZj+UTd0umsXnVbKqE08sA8EyGOZHRJLj0IUnFxOgiBEA==
X-Google-Smtp-Source: AGRyM1vKpR/FqImHvu5UxIIuKFGPH4rqAI8NqTL7rGgNfOiSVXqDrQU4WEWKDjSwUIZmuKiVBnEUeKl9fxRTNVQyQTU=
X-Received: by 2002:a05:6808:3089:b0:32e:f7fd:627d with SMTP id
 bl9-20020a056808308900b0032ef7fd627dmr9844533oib.181.1656391170979; Mon, 27
 Jun 2022 21:39:30 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216177-28872@https.bugzilla.kernel.org/> <bug-216177-28872-0HfdJRGX5a@https.bugzilla.kernel.org/>
 <5D5DBC33-EDD0-4FB8-A0D6-F1DE9CA56FFF@gmail.com>
In-Reply-To: <5D5DBC33-EDD0-4FB8-A0D6-F1DE9CA56FFF@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 27 Jun 2022 21:39:20 -0700
Message-ID: <CALMp9eQ9VQ+4S261KabKGPShi7WV6MrsFBtWgie4ZX-XUdsrEw@mail.gmail.com>
Subject: Re: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org
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

On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com> wrote:

> The failure on bare-metal that I experienced hints that this is either a test
> bug or (much less likely) a hardware bug. But I do not think it is likely to be
> a KVM bug.

KVM does not use the VMX-preemption timer to virtualize L1's
VMX-preemption timer (and that is why KVM is broken). The KVM bug was
introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
emulate L1's VMX-preemption timer. There are many reasons that this
cannot possibly work, not the least of which is that the
CLOCK_MONOTONIC timer is subject to time slew.

Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
APIC timer. Better would be to determine whether L1's APIC timer or
L1's VMX-preemption timer is scheduled to fire first, and use L0's
VMX-preemption timer to trigger a VM-exit on the nearest alarm.
Alternatively, as Sean noted, one could perhaps arrange for the
hrtimer to fire early enough that it won't fire late, but I don't
really think that's a viable solution.

I can't explain the bare-metal failures, but I will note that the test
assumes the default treatment of SMIs and SMM. The test will likely
fail with the dual-monitor treatment of SMIs and SMM. Aside from the
older CPUs with broken VMX-preemption timers, I don't know of any
relevant errata.

Of course, it is possible that the test itself is buggy. For the
person who reported bare-metal failures on Ice Lake and Cooper Lake,
how long was the test in VMX non-root mode past the VMX-preemption
timer deadline?
