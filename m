Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2865B64DC5E
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 14:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLONkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 08:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLONkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 08:40:13 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6FBE20
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 05:40:11 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id t5so2923008vsh.8
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 05:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XF58WP4s6ZRcK8RqCaMeCaiXNfNWewGPwhlYfzf7+c0=;
        b=da2Qc4o0X9EGk/7Qiqc8qY//jxZ0wKG/mHB1BP/JltGQZNRHlPzDrY1SWULH+fTBV9
         /5igvuwjXwHoY2EZiZRpHasNbGfS4N2AX6NR7Tve52apVJ7VKmONDUNLigZcf7TzvLhf
         k9p8eg392yL/u5NGtEi0Q5+RycyIyB3j0+Awwig+Y6Ssj4IsImWzrOe+tOIlTjI2r2QC
         f0DJtUwvOT3bUgxHbbZWXv9FzeR18I2cN7bT8Hmoe/t7D5WnyetlDzocF9YvCTMFSznr
         OalDmEqGXbQLVmL0ZOP6mpXXI53WNKl/EflP0QxSIwZPoLdLmOasGv2gyJOxAE54nh3C
         tj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XF58WP4s6ZRcK8RqCaMeCaiXNfNWewGPwhlYfzf7+c0=;
        b=Yt0+V80MrROoHgL9ZeCe7ccyeXCb/BbCo8apDlmir/z2lHpgIaZIdiCqPy+z8JIxX0
         Nj1GpUtSqoDy4SZ+1cyVFWsA2U/RegG4Lcw/eQIkJINL8/BbINw/TCH9A6kvu5HVwsdy
         c34UvWOrDAVO5eRwrot6yjFDpEEr7SErqvh7aQFGU5oS6L/+cUOst+QKke4xgIn+Ujcj
         RUeijuSK5nIHOm7w4rpX+CJuYUY5ABknL+Sj2UN2Pf+xXosZpJpbK7OKp9dRXTNASUdA
         539EZ3e6EeCPnXUN1frPM+zJGF0gCLMhmv8oPT8/gn80QIUJxYWsGo0yEPB0sumy11V/
         1MSw==
X-Gm-Message-State: ANoB5plkgEEwq2WtHEWUVJbNV3tmi/4ymmlQZq12qgxNKOUJz5D/dcUe
        m2WcTjnNfU3NswWRmCAduU0HOkZ+g2DMFYalMDkc7w==
X-Google-Smtp-Source: AA0mqf5uJcdIF1XzpuJNWLRJ0aUur6p1A2ThgZCj0F5oatZXB9Rgne6AT5K0ASqFQ6H5yNimqOF7Mj9OEuqmhnZHzuo=
X-Received: by 2002:a05:6102:216:b0:3b3:560:f2ad with SMTP id
 z22-20020a056102021600b003b30560f2admr5503307vsp.17.1671111610489; Thu, 15
 Dec 2022 05:40:10 -0800 (PST)
MIME-Version: 1.0
References: <20221209194957.2774423-1-aaronlewis@google.com> <69e2a68f-32d2-0f96-9564-4382f3f74d2c@gmail.com>
In-Reply-To: <69e2a68f-32d2-0f96-9564-4382f3f74d2c@gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 15 Dec 2022 05:39:59 -0800
Message-ID: <CAAAPnDF4nagsbQbcoq7DfH+7rAaCaHYNj5xbex7ERNbd2sif2w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix "Instructions Retired" from incorrectly counting
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, jmattson@google.com,
        kvm list <kvm@vger.kernel.org>
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

On Mon, Dec 12, 2022 at 5:24 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 10/12/2022 3:49 am, Aaron Lewis wrote:
> > Aaron Lewis (2):
> >    KVM: x86/pmu: Prevent the PMU from counting disallowed events
>
> Nice and it blames to me, thanks.
>
> Would you share a detailed list of allowed and denied events (e.g. on ICX)
> so we can do more real world testing ?
>
> Ref: #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300

TBH, 300 entries is plenty for Intel.  It's AMD that has the issue,
but that's addressed with 'masked events'.

What type of testing would you like to see for filtering or the PMU in
general as a selftest?  Currently, the test uses architectural events,
but with this series we are really only testing 2 of them.  There is
plenty of room for more / better testing with just architectural
events alone.

I also add more testing and more variety of counters with masked events.

I'm curious where you would like to see additional testing and what
real world testing you'd like to see added.

>
> >    KVM: selftests: Test the PMU event "Instructions retired"
>
> And, do you have further plans to cover more pmu testcases via selftests  ?

I don't have immediate plans beyond the 2 mentioned above, but I'm
always open to more / better testing.
