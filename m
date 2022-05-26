Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C528F53560B
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 00:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiEZWRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 18:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiEZWRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 18:17:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C072F003
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 15:17:45 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id i23so3166718ljb.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 15:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ve55jdLtyGMUsoE3r/N5Ru2U4Bj7D7brSSEzNzzYQCA=;
        b=DeacuQ2wYZgiAnvKnEvXxeR0ObwMZh+zs+H80DPF47YY8cgvRxbDxNkO6+Xj1rgxtp
         ineRh2uOzxvupAzjTIm1JLwd41pJsLwHpUoly2YknobCsmyEK3Kr8Ckc9Qasz2SX5fQn
         o0usoAOtpmEsc7BhDqrWrUbMMPVxKptOv6FUapAH+1Vo16OQ+bO5OmL+D8YtCn1EqvcP
         wE4MUqu7IS44ZAjaDdnVaQvTfi+q0K2F9UeuDEdPjyakLPmIIoH51AI1G7vK585D46mp
         Eo/qLtf8oXPMPharKnCpvjr/yCocq5S5ueIXHHLQZG4Deh0LY5/7rnZMM5OTPjjH316r
         pfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ve55jdLtyGMUsoE3r/N5Ru2U4Bj7D7brSSEzNzzYQCA=;
        b=2UPNxWWN9kilQj65aHkPc7nkk8psbPPamCQBm+Rk3YEFcSqrFmDEMqWppDTEeEhLwT
         Qnoh6OKdLgnXOA+sC+9DCT9IRzZOWGQCOkxi7vH1BDbaJepC23u+0yUikNgf/wOaCu8B
         v82pBuTTyL3+GkBBnpthqbcvNf26BuLgwzQs3HuTRyWz891NxsR+GMSqq1bBB6tx9746
         WpfGw1+IfEBTnuvG0IWTTbQCX/xeIrU7hffYUeqpsQ3wvtyjysffQEbEHvaKpBenPHIG
         KPaVxu69/ZAQu8u6+33R9g9BIHId7VKGSRWPl6gjKIub4i+V4iajYpGBMcbBVT8W+D9u
         deVg==
X-Gm-Message-State: AOAM531X1rHxMXfUjKrqH3eM8UQ8K0gfVUNUGcCNux8WtGpoJU6Wm7bX
        0Yn8xmeVDAeyk+K2+D43qhXwpY038P7RV6Gk1LfL+g==
X-Google-Smtp-Source: ABdhPJw53rmP6kdpSBL2DdAeqhI0MEMHncbDXuuXMnf3T5rc2NO4zUh6engJ1zqXS9vdhQEi4H4C7U0Z2wjg3B7sWtY=
X-Received: by 2002:a2e:7a0d:0:b0:253:decb:be0f with SMTP id
 v13-20020a2e7a0d000000b00253decbbe0fmr18902815ljc.525.1653603463459; Thu, 26
 May 2022 15:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220526071156.yemqpnwey42nw7ue@gator> <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-3-cross@oxidecomputer.com> <Yo/v5tN8fKCb/ufB@google.com>
In-Reply-To: <Yo/v5tN8fKCb/ufB@google.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Thu, 26 May 2022 18:17:32 -0400
Message-ID: <CAA9fzEFF=fdfV7qE-PU5fMD+XyrskQjvxPbgZ1yyS4fRTeBO2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 5:23 PM Sean Christopherson <seanjc@google.com> wrote:
> In the future, please tag each new posting with a version number, e.g. no version
> number for the first posting, than v2, v3, v4, etc... for each subsequent posting.
> It took me a while to figure what was what.

Ah, sorry about that. Sure thing.

> On Thu, May 26, 2022, Dan Cross wrote:
> > Warn, don't fail, if the check for `getopt -T` fails in the `configure`
> > script.
> >
> > Aside from this check, `configure` does not use `getopt`, so don't
> > fail to run if `getopt -T` doesn't indicate support for  the extended
> > Linux version.  Getopt is only used in `run_tests.sh`, which tests for
> > extended getopt anyway, but emit a warning here.
>
> Why not simply move the check to run_tests.sh?  I can't imaging it's performance
> sensitive, and I doubt I'm the only one that builds tests on one system and runs
> them on a completely different system.

`run_tests.sh` already has the test. Changing it to a warning here
was at the suggestion of Thomas and Drew.

        - Dan C.
