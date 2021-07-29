Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07813D9CBE
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 06:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhG2E0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 00:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhG2E0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 00:26:48 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD99C061757;
        Wed, 28 Jul 2021 21:26:45 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id x7so1102525ilh.10;
        Wed, 28 Jul 2021 21:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6qZSdBV70oLjzXY9J+kcpHCTOof0JnPkRHvC46/0enE=;
        b=NLXb0OLnoHRE2t16wv2trQILVqh7yOu+pBFyho/tFMH3mB8KTdKPP+H6KcBlI0kgUJ
         sO59ROgNvyvOSUyqhO24IwPJl5zEBMVGy8Ralbh5R7QIKgKvuflsVkG++8/RYh9DYh0V
         JixA3XSUtQKND+hXCXZWljh1ktgpjJTrYR1mcRdVLcx4pRlPXZHUMzubyawn+8fCz0GX
         qZNdcUJMM9qbE5vCxk7iTtr3xJuxdeN/qeRgAtQLeTJhZqFdYXY+1UEE+FNqnfhWp3R0
         OJwlANBseQhp0rKw1p2Oef7mMEWNW1Gvt8aFtvXkYOi4OhJ7mpgU6fK7TbPaYDDZZYpE
         p5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6qZSdBV70oLjzXY9J+kcpHCTOof0JnPkRHvC46/0enE=;
        b=Y9r+8dkhGvWO9LcQJjQ90RTNL9zMkVF7L0KKUw3v5ldJBQGqUrhJOhadgIcvE3JpxA
         DZGwq/QpzQ3T97Vxt1TdnGG43tLVsqAfsQC+AvgIsec5t6oCkhi4j4lZ+gwkdBpbLpdy
         KrOJLXQEvu7AVlFwulV8QmFnhPyHTGlVc1SHouYKyRS531dJOtsGLC9Rig6dLEbi7+Ap
         Lfu7RV/xiIWYijHwic1oMmRd3gPzq67usbIMgA/82BVQ0771G3j1X0vflu8vWTuAuE1H
         7f4S9l4sEK+Q1+xeo6ixmETgUnN3C1BosIVwhEbt9NGDyKxB5a5HwA8iPebwy9qq6TdY
         v9JQ==
X-Gm-Message-State: AOAM5309C30OZVjcNZqjYZ1vq8CQAhvKy3gGfDXeaMR0Zdy3x2bsPUA+
        iUhflKcxrMzc5CFIUjzF57VF3kHfBf+JQrWunYk=
X-Google-Smtp-Source: ABdhPJzpXQeDsRaaXvVfSvElKNAYZqDm1v7RAdis7kDfYXUnO38CrA7TED+wbGjakqPi3hd+HBlLZAW6DwHPkz8noQQ=
X-Received: by 2002:a92:a005:: with SMTP id e5mr2242648ili.22.1627532805050;
 Wed, 28 Jul 2021 21:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210722063946.28951-1-mika.penttila@gmail.com> <YQE0P9PLd3Uib7eu@hirez.programming.kicks-ass.net>
In-Reply-To: <YQE0P9PLd3Uib7eu@hirez.programming.kicks-ass.net>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 29 Jul 2021 06:26:34 +0200
Message-ID: <CAM9Jb+j5KbuuMD9mRNbBD9wn5ga8+GBcjPTVgiesfVQKctP0pQ@mail.gmail.com>
Subject: Re: [PATCH] is_core_idle() is using a wrong variable
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mika.penttila@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 at 12:46, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Jul 22, 2021 at 09:39:46AM +0300, mika.penttila@gmail.com wrote:
> > From: Mika Penttil=C3=A4 <mika.penttila@gmail.com>
> >
> > is_core_idle() was using a wrong variable in the loop test. Fix it.
> >
> > Signed-off-by: Mika Penttil=C3=A4 <mika.penttila@gmail.com>
>
> Thanks!
>
> ---
> Subject: sched/numa: Fix is_core_idle()
> From: Mika Penttil=C3=A4 <mika.penttila@gmail.com>
> Date: Thu, 22 Jul 2021 09:39:46 +0300
>
> From: Mika Penttil=C3=A4 <mika.penttila@gmail.com>
>
> Use the loop variable instead of the function argument to test the
> other SMT siblings for idle.
>
> Fixes: ff7db0bf24db ("sched/numa: Prefer using an idle CPU as a migration=
 target instead of comparing tasks")
> Signed-off-by: Mika Penttil=C3=A4 <mika.penttila@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20210722063946.28951-1-mika.penttila@gmai=
l.com
> ---
>  kernel/sched/fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1486,7 +1486,7 @@ static inline bool is_core_idle(int cpu)
>                 if (cpu =3D=3D sibling)
>                         continue;
>
> -               if (!idle_cpu(cpu))
> +               if (!idle_cpu(sibling))
>                         return false;
>         }
>  #endif

Acked-by: Pankaj Gupta <pankaj.gupta@ionos.com>
