Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B570E37EFF1
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 01:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhELXhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 19:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377593AbhELXUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 19:20:13 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47423C061357
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:17:12 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id p12so31715192ljg.1
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQiB9sLTWHFoFy/ehq3hN41VSXihaIbpt0N1jzuH/T0=;
        b=JJ8L4UmwPRLSAvUK0Jk3HoTz8jlwZU469A6CXfMaO8vN2VpbVHnHSgXJHPin4O6iB/
         UqEvalRAabU4gspJHdxn7OyGKm0NQPjEP6+QvWNYHwK4FWBUwEir5B33r/f+MpgADhIs
         HJuiwv7iaqWkTVeny3xl362Afqd0hMi03wiA2QVLI9cfPcUC0v+tbbziccm8k+KZdqq/
         +XXY9AUt3S1q2ZU7gXjl6nj9fW2xGlZOhZ2MFnwL6akjlSdrkxLX+3S4IdArOm7uTglX
         IJMIStDYDSnRS2t0zvD/dxhSubfNiDHqfC2qWGAKDt4bOYFuKthdt8Qa2LAisnylYuzr
         BhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQiB9sLTWHFoFy/ehq3hN41VSXihaIbpt0N1jzuH/T0=;
        b=dmjJtw5/xz70EwrszAMWeTiLJq/6gsSk0d7j7pBu0d08MHVxMhUaRYE+qLEsGTn02w
         N6Ho2fodh3xC6XJs6qcaYHQYJ7ge96b9O3YI3U7rJSlTqPinpWvb737cge4BJGWVfN5w
         Y5AiXqxRg90iwNSgXWwxcbUGRXwOX7CFTblnwHQZbwW2tXKR/FPiVa94Ov3TwMLa+5+p
         qu7uZglNalyvMG4rO7tifMtg8/V9N6Fu15PhLSdHtz5rz+xZIox9AXId3aC+4lotzMWJ
         SGJIVkXNfEYwKIbvdce+2yb0SqHoNX/ijN+rLrYXZ+b8qxH1H2kZsOKtCGawqCjfhiXE
         OscA==
X-Gm-Message-State: AOAM531uwvCoC6le/iMwLLFcac2nwms8M4G63+G2YDDxlnXvpMZNkaJL
        8C6g6rh8/AsTub0Rklax2mENoNXscbhh82Vwd0w2xQ==
X-Google-Smtp-Source: ABdhPJz4nT2NqJcZFz2UrKAvtEwW9ZMtr8A1+fD5q6gQPHshVzbD+pDD8IetiOzNniyNhQfeyg7UuJws3Xt2YIDPXyc=
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr32885298ljg.74.1620861430582;
 Wed, 12 May 2021 16:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210511202120.1371800-1-dmatlack@google.com> <20210512064052.jgmyknopi3xcmwrl@gator>
In-Reply-To: <20210512064052.jgmyknopi3xcmwrl@gator>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 12 May 2021 16:16:43 -0700
Message-ID: <CALzav=eGJxpWu0xO4G-Z4dAkxc_bOthyKfAZi0LF+=8XRduW7A@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: selftests: Print a message if /dev/kvm is missing
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 11:41 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, May 11, 2021 at 08:21:20PM +0000, David Matlack wrote:
> > If a KVM selftest is run on a machine without /dev/kvm, it will exit
> > silently. Make it easy to tell what's happening by printing an error
> > message.
> >
> > Opportunistically consolidate all codepaths that open /dev/kvm into a
> > single function so they all print the same message.
> >
> > This slightly changes the semantics of vm_is_unrestricted_guest() by
> > changing a TEST_ASSERT() to exit(KSFT_SKIP). However
> > vm_is_unrestricted_guest() is only called in one place
> > (x86_64/mmio_warning_test.c) and that is to determine if the test should
> > be skipped or not.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
> >  .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
> >  .../kvm/x86_64/get_msr_index_features.c       |  8 +---
> >  4 files changed, 38 insertions(+), 32 deletions(-)
> >
>
> Hi David,
>
> You could have grabbed my r-b from v3, but anyway here it is again

Gotcha, I will keep that in mind in the future. Thanks for your
patience and reviews on this patch!

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
