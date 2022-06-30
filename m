Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236AC5619D0
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 14:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiF3MD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 08:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbiF3MDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 08:03:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EBE7479B
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:03:53 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id be10so25711742oib.7
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOvwIwWqR5EO2lNFoUUmwz2sETLTMOQ7ejH+OnZOrOk=;
        b=PqQLLZJ2ZKkoxPkrHyZg0oRJQxv1SwlVRLyoUwWodeUAplwjnNWtX44JGPQJq25nqg
         kgNzTI1diYu8vYNssW6Q+NKIdJ856q2SGtZxxEjA9Qvg510fdECJarMB00L4jW3D93wH
         y35e8mPJ7xBAxJFt+xnZ0h7CxMEHW3L5HhZ1BwiiFT2m6c7LSCyvAXBF4T9wmI00kyiP
         o4bUpROLYIyHMF2trI2e6+sJq6wQimYkQCAt6nFiXybJuyz9NoMCSVW1b1EKJCOECuUL
         FbQX4wAnlIqZeM5tstXJDWBCceA7Ndt80RxHipCG+bi7ArAHddo2LLva5c+XIxpEFGoY
         OBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOvwIwWqR5EO2lNFoUUmwz2sETLTMOQ7ejH+OnZOrOk=;
        b=KcnBInt5sZiEDvjEeqGSbQhjxTRmTjRsutItb2ORoYNlSe1xPjkQnWMEtUW674McGT
         B6Ui2RgqwsxbnKwJxHsrLiFNYKEscgQIdq2Ys51pQp+z8LVc4UIX6hz+N4IBD/RTgQnp
         2lqt4IxJLE6XnRx0bdeLJxXulhTCy7rPL8FuN1EuL/KXcPmoHBeDrQBRQta5Xirtx7mE
         VB7xac9uyQtNzvrou4Vy2cIaNCcG4sq1/RHmqWGfux/43il9F2FkJvUdsTlETQjky+rn
         HUy7/bVI8Z19DitrDO/n3BWYJU4PNIJxxgup3kuOo+BHDEa5DuNEqceatGQdkXwnvUST
         afbg==
X-Gm-Message-State: AJIora+NwNSE7A8X1gtzH4/Zg/sCLxyAIX3W03HMrUaYowzUMvuOqGWB
        E4GHV8ujSniZpPjxJ1bqZiiQ8IKxndQn0jZgB5mbDg==
X-Google-Smtp-Source: AGRyM1t9+3h6Mrk2A/8pgzvzC9lNsAp1cEGjS3G83IqK9iIHIM2ki9s58k4XQIujrkIi67LTOGdsX+1et3HfwtpuRfM=
X-Received: by 2002:a05:6808:2124:b0:335:7483:f62d with SMTP id
 r36-20020a056808212400b003357483f62dmr6311959oiw.112.1656590632727; Thu, 30
 Jun 2022 05:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220630085845.74566-1-jiaming@nfschina.com>
In-Reply-To: <20220630085845.74566-1-jiaming@nfschina.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 05:03:41 -0700
Message-ID: <CALMp9eSTQXHna7D9vH-nt1dXkbN3F-Bdx8pHUOQSXLcNtt=J7A@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS/MMU: Fix spelling mistake
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 1:59 AM Zhang Jiaming <jiaming@nfschina.com> wrote:
>
> Change 'writeable' to 'writable'.
>
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>

Writeable is generally accepted as an alternative spelling of
writable. You're fighting a losing battle.
