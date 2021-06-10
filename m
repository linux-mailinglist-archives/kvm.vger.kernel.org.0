Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF193A2716
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 10:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFJIdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 04:33:54 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:36861 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFJIdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 04:33:49 -0400
Received: by mail-lf1-f42.google.com with SMTP id v22so1910909lfa.3
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 01:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GDEXAGICbV9KRmpfNUQzEOo0Ei/7B5CddLI8jL5o3cw=;
        b=RwdsOYbIQzlgMvzFpr03d4jPc6GnZKJEB5FSNxeVCi9C32f3ZoX0BAUitqNyLfcpCx
         DMmXxE9p5WbWKbxk9wQ9eFPA8b52BXjkmF3q+9wG879F0O5nfmZfXYRMHOUBET1U0+NA
         45fG/1IpIfeQ9J2zn2/X/sYZrGVFxEGfqprQCGNLiKo5kfhEXu4qzup4XhUGQes66lzz
         y18GtKmpMPxU2hh9eYCUW0quBftYbFy3HmpL0rT+ZXXY8LVD5HSJmWrNEN3cC1Y4mPPt
         CwL8Fz18Fjo6pYNfvMULUmvkdxem+MRZAHteppS2ul7d8ZjxS+Yz6WVJ9T+rWmE7qNNQ
         YqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GDEXAGICbV9KRmpfNUQzEOo0Ei/7B5CddLI8jL5o3cw=;
        b=YOd9l04x133NoxBAFB3I8f7UPHtxtBeES08B/hxI1rGbh2Cx5QPwRuwV54M5qzdiuI
         s2qCLS0DenQnU/tVpdrOK6M8zd4i7Gevur6vYdzPp7an0wnceEMyjBvemBtdam8QkYwB
         sE6RMI42F+zn9eFg4oGv9kLpPXu/Eu0bAEit+rUpviqGVOXnCtIPsLOwiCQfutYp8FTy
         2NGWUNnJUM9G//TcBwUCzBcY9ZorQPgKvsdMxqiTFME+NFPsFqJvpYo16KeqhpVh4GBB
         W0/7EnMK+Mb9PvQowX+BBteQ3UP33SqYKGl1MbieD9PH3JXtWUTevYAO/kwNbbqZ+xSq
         CyXg==
X-Gm-Message-State: AOAM5333heXeejJ4RjbWJTQbti5C9/2QcDngVMFwR+6w3c/RZSH0s8xx
        1wrFCZCb09qsA78FbYsFi8vcDp/B9RMWmRkZIvE=
X-Google-Smtp-Source: ABdhPJy73ZKdHIPGmtk5ciWLbQQPHv36YSlmGccCpREc6MyO6iHTClpmNBY/EAZL/7N1A9bmyfhGKVFdAZsO6ivrP5Q=
X-Received: by 2002:a05:6512:3fc:: with SMTP id n28mr1224723lfq.436.1623313852166;
 Thu, 10 Jun 2021 01:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210609182945.36849-1-nadav.amit@gmail.com> <20210609182945.36849-8-nadav.amit@gmail.com>
 <CAA3+yLd4AML_eEtUwzFrd1-KKiiZ4W9Uy0gTdrEMC2YXVayJRQ@mail.gmail.com> <E2E14CA1-FAD4-47B7-BCAA-3D9012FC7391@gmail.com>
In-Reply-To: <E2E14CA1-FAD4-47B7-BCAA-3D9012FC7391@gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Date:   Thu, 10 Jun 2021 16:30:31 +0800
Message-ID: <CAA3+yLcse6YDYrZSqCqnP-egGmQxTMSX=PnJxp8AtWsKfU=dTw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/8] x86/pmu: Skip the tests on PMU version 1
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 3:44 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
>
>
> > On Jun 9, 2021, at 6:22 PM, Like Xu <like.xu.linux@gmail.com> wrote:
> >
> > Hi Nadav,
> >
> > Nadav Amit <nadav.amit@gmail.com> =E4=BA=8E2021=E5=B9=B46=E6=9C=8810=E6=
=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=882:33=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> From: Nadav Amit <nadav.amit@gmail.com>
> >>
> >> x86's PMU tests are not compatible with version 1. Instead of finding
> >> how to adapt them, just skip them if the PMU version is too old.
> >
> > Instead of skipping pmu.v1, it would be better to just skip the tests
> > of fixed counters.
> > But considering this version is really too old, this change looks fine =
to me.
>
> If it were that simple, I would have done it.
>
> v1 does not support MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> MSR_CORE_PERF_GLOBAL_STATUS and MSR_CORE_PERF_GLOBAL_CTRL, which are
> being used all over the code. These MSRs were only introduced on
> version 2 (Intel SDM, section 18.2.2 "Architectural Performance
> Monitoring Version 2=E2=80=9D).
>

From the log of feature enbling code, this is true.

But accroding to Table 2-2. IA-32 Architectural MSRs,

- IA32_PERF_GLOBAL_OVF_CTRL, if CPUID.0AH: EAX[7:0] > 0 && CPUID.0AH:
EAX[7:0] <=3D 3
- IA32_PERF_GLOBAL_STATUS, if CPUID.0AH: EAX[7:0] > 0
- IA32_PERF_GLOBAL_CTRL, if CPUID.0AH: EAX[7:0] > 0
