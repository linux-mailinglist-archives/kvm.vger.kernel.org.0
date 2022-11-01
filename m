Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70DE615212
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKATQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKATQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:16:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE5167F6
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 12:16:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f5so18005085ejc.5
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 12:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g5/LgLbZ1+XJUR8pr8kDqLm4g3OoAOHNvM1EDHfhj/E=;
        b=qmDyXefdFd0B9PiOX394PPZCPG0eYmzc2ngxVdIa5d+I/5y3NlcjGzgMAGM+jh2lBk
         xyugONQmoktILeQIGeSnS0XHPydvs4JeuG+TrnSQ10ZTDBA6k8uTQf2Gi4g8K97IfKf/
         K79QocofkFXfWNLqMHwlamJSs+jcfk/M8XppgdqEKxcaF8pdLEgYv8Ok48487YQX3aq9
         8vXV8Bg2Qh8utCjWHcLxLpC5uIbQBdbCXl5NSSp42RSuhqwG49O9QyIVBJAjNrEjnVq2
         f31106LTdej7nVJz/lVSGBFHNsOawFMix/z8LitJvMM8zUUs2hGCDDAzpqBfG92OryNl
         H4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g5/LgLbZ1+XJUR8pr8kDqLm4g3OoAOHNvM1EDHfhj/E=;
        b=pv9AfXgnTQODVjXB8OsMlSgQSIQBUJ7roEsBRNneAHky9XuvH7KYnYDSbYXPF8MQPa
         nQlh6KsJCcR2GSKxottthmcWPczdt7i/cw2Bb4qipDTjZVb9e3ksFQaHWI+IXA6kTzIS
         So2NP3uy3Dju9vEeRcEQ4WpJgtRmwRRauKSiPDDfGul/sA7xRwzUzHShKGemgjPTWjHL
         GIXn0lVf39gcSN9WAzDWtLwQNdCwGTtXEm8Acetwb01llbLvZ/9IM/mAkMk5EUUgxZA3
         FlieeeqPtGyz+bFDh9NYfYB2r25DBbNrmXCO3eM9pLlPFJTWjgF66k8++JUnQbYh4dJF
         RQKQ==
X-Gm-Message-State: ACrzQf3pVawNQiiqZ43kD73RJmpiQ1AsIYm6qHCIzWJqvrbmEgaNFD8x
        MrkzLZSXHpxwegTcM0IoCwDwQlckz47WEBRRd4u0
X-Google-Smtp-Source: AMsMyM7id7IuuA/wO2u5ya0vqDKyLhsT0qV/v8DNJ2zC8eu6anrQAfTPggMk/ga0B4Kb7NrJqDaDAsctb60CAIS68qs=
X-Received: by 2002:a17:906:14d2:b0:7ad:be76:956f with SMTP id
 y18-20020a17090614d200b007adbe76956fmr15851276ejc.197.1667330181794; Tue, 01
 Nov 2022 12:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220601163012.3404212-1-morbo@google.com> <CALMp9eRgbc624bWe6wcTqpSsdEdnj+Q_xE8L21EdCZmQXBQPsw@mail.gmail.com>
 <CAGG=3QX218AyDM6LS8oe2-PH=eq=hBf5JrGedzb48DavE-5PPA@mail.gmail.com>
 <Y1htZKmRt/+WXhIo@google.com> <CAEzuVAetwLSaP2gt00Y0i0xdrj59TVT9ngB1iHXOa-mZ1fOqAA@mail.gmail.com>
 <Y2FrIAPxaEfYISg3@google.com>
In-Reply-To: <Y2FrIAPxaEfYISg3@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 1 Nov 2022 12:16:04 -0700
Message-ID: <CAGG=3QUxTZN+B3tvCwtk452mFNax-AJ-++rC=shZjbVzQ5qgEQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Disable inlining of measure()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bill Wendling <isanbard@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        TVD_PH_BODY_ACCOUNTS_PRE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 1, 2022 at 11:53 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Oct 26, 2022, Bill Wendling wrote:
> > On Tue, Oct 25, 2022 at 4:12 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Oct 25, 2022, Bill Wendling wrote:
> > > > On Wed, Jun 1, 2022 at 10:22 AM Jim Mattson <jmattson@google.com> wrote:
> > > > >
> > > > > On Wed, Jun 1, 2022 at 9:30 AM Bill Wendling <morbo@google.com> wrote:
> > > > > >
> > > > > > From: Bill Wendling <isanbard@gmail.com>
>
> This "From:" should not exist.  It causes your @gmail.com account be to credited
> as the author, whereas your SOB suggests you intended this to be credited to your
> @google.com address.
>
> Let me know if this should indeed list morbo@google.com as the author, I can fix
> it up when applying.
>
Please use morbo@google.com. Sorry about this mixup.

-bw

> > > > > > Signed-off-by: Bill Wendling <morbo@google.com>
> > > > > Reviewed-by: Jim Mattson <jmattson@google.com>
