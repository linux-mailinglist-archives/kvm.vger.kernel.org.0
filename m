Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CDC67D432
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjAZSat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 13:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAZSar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 13:30:47 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5283D3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:30:45 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id v19so2002502qtq.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 10:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DY0wGNQ4xmO2Sv+oOAiE+cyxqnCNWdUeoGppdemz7Ds=;
        b=XPiwuZrO7ge91UWeJBeKearz4H6rgD33C3fb+pPprscYKkCnlWhd/DaTm9/JTgfBil
         jDV1vmKappQi+SiKgOI5HC/syQtQDlsTpcnwLxZ3sX7LtbOss7TCxZr94+u/2Jpd8KD9
         YuZqVr/2osyTDsNkwnXb/Y42hsvC60nIYZIbFYcUif/u66e2D8KU2TvWVoJi2pIVozBq
         uh7/UUlwQqp6bj4YXmHE++epiCJhr2/c8X9Bfs3PJXFNRKbckOUAx4A76OT0JNoeUq8z
         f9MubAIUTtKXUDmk6Ns1K9GYq3DphFpePAgpdXmdGabC8xYyAFBOOXtcTPyjRmzd2QBF
         6kXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DY0wGNQ4xmO2Sv+oOAiE+cyxqnCNWdUeoGppdemz7Ds=;
        b=lyEv7qLw8R5qOTGnRGc2N66hU21y5B5igpPGZnQs63YQeyoevyUxxj1zgORuVzEE9k
         AybQBsCIvuzxDQJa7fy8qB0+LzfsgKUbzMJ0wxuUwq2HVzeiZioK2pyagPab/+CR6sOu
         j2qhPSMmB9VIR4d1wDkCkLgdoHTdVcMSeAkJJeiRZedd8k7mpMW2k+XbndrwuEXpZTo2
         2uRr/lkg0lSp4hebFYCniX3fQm0AZgZZ8rs4+QMb1hMEfEWedqbJy6UC6/IHkZTi3BD3
         o12pJytFLgX0SP/IRymWGGdfggzphoAfTCVvQq5a/FoVDhkpfRLmUaYzHW5KxPtMtA/u
         +7ag==
X-Gm-Message-State: AFqh2krFQE2C0NOMNjnoueN9XxVrzVzBRfYJvJDp89kE85y4hUWwDxHJ
        gB1qnTKd6iLDGLJ69J2+wAL/09ksJqSGToVOxgradeKrBZ4sa3XK
X-Google-Smtp-Source: AMrXdXupFQr1HLMRQMMg/CqgJ5w1ftdaOy6EDoYXy3zVNfTH5Lwf/sxMDPUXqbpB6GBkfjvyE3+cB7wKyxeVbWK+zgI=
X-Received: by 2002:a05:622a:5c1b:b0:3a7:e026:8f6f with SMTP id
 gd27-20020a05622a5c1b00b003a7e0268f6fmr1940956qtb.389.1674757844021; Thu, 26
 Jan 2023 10:30:44 -0800 (PST)
MIME-Version: 1.0
References: <Y8cIdxp5k8HivVAe@google.com> <gsntfsbxqiso.fsf@coltonlewis-kvm.c.googlers.com>
In-Reply-To: <gsntfsbxqiso.fsf@coltonlewis-kvm.c.googlers.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 26 Jan 2023 10:30:32 -0800
Message-ID: <CAOHnOrz93k99o5wvB9-TKDX6F=OqYmxeWKeeMGeiFfRYZ7AE+Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
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

On Thu, Jan 26, 2023 at 9:58 AM Colton Lewis <coltonlewis@google.com> wrote:
>
> Ricardo Koller <ricarkol@google.com> writes:
>
>
> > nit: reservoir
>
>
> Will fix
>
>
> > Didn't see this before my previous comment. But, I guess it still
> > applies: isn't it possible to know the number of events to store?  to
> > avoid the "100" obtained via trial and error.
>
>
> That's what I thought I was calculating with sample_pages =
> sizeof(latency_samples) / pta->guest_page_size. Both values are in bytes
> so that should give the number of guest pages I need to allocate to hold
> latency_samples. The 100 is a fudge factor added to the calculation
> after encountering crashes. Any idea why the math above is incorrect?
>

Mm, I don't know to be honest. But I do think it's required to calculate
the exact number of bytes needed. Otherwise, 100 might not be enough for
a bigger VM with more samples.

>
> > reservoir
>
>
> Will fix.
