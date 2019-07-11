Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1796571B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 14:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfGKMkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 08:40:02 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40208 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfGKMkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 08:40:02 -0400
Received: by mail-oi1-f196.google.com with SMTP id w196so4342046oie.7
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Yt4EscGigEBnlnjY7wWgkB/ov60rXHSlmHTWLza6n4=;
        b=uPjeCcZyt2xFKg2rAD3fkzlSCJR/DUfzg8UN7frwQfq/6628hhyOdtkgFGlnrlPdrt
         ERiC/eSwlKnAuUDJp5O4YN5EXSBnqtEahX141CDob0ECQ3QRSaWjy4u1PZVICqjSCque
         byOjTttw4zsDSxomIowXeUSOtA7fpRjD8etTHX670QMsP3pLR7J20R8Cilw6xHY+HyzT
         EY3lv53l62ZtI4eHQhLmUGxZrh3W4Mo5V9Pf7Wi5kjjaSqFmsfKixxhX2sEFlJ0zk+mR
         T9A6gX0B4mFmFe6CFf7GG5mscP5WS0kk3CJwtnJIDWUjpt7Bxm6Pzz6+CfPXQBnhQkX+
         DfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Yt4EscGigEBnlnjY7wWgkB/ov60rXHSlmHTWLza6n4=;
        b=E9vFx4CYkKamyFSf+YaBEQwtgnmdgpVp2dNgTZxXmJzAA3ZXOyNrsjRz2bt5CGHndY
         eNejwToyXKzl/w1Ytp8VFGbY6U+ninM9hk+pe0EStnFZXqr1vBK7Y+SKcvQcKCJvRhG6
         MJswUUxlUFrj5vSvvvvE3o0J393gDy8WD2mnhYW5/m+hcqwi4SEkZl0Jr4GayOpYP1Vp
         1kwiLCjl4yE50BJi2pgecUpPnRDwfaKp6TEdlxkACme09U1Q8Y6YmcKA2uouSzr0ah4F
         DLrirI1BWwgkqHV6VFvXsuX7Bu5CS8OUDehn9tXfdgMSx/SKCHjUpzVfo1D5q9XeZfXY
         +6Zg==
X-Gm-Message-State: APjAAAUEntrVDvAbHiwqSDiDn6pQ/8zo+eqDBjpAHlOK0gRfnNuAuh9m
        bVTtx66cOiGv4Z+Z2xJnLHbicNWYXsWY8x7/nDhsIw==
X-Google-Smtp-Source: APXvYqx88tSye8THszfgMMvEEcruY6rukK6VV++UTAkaz8tl3XLtSypsMIu65tZSvL5XnyBEfwT4Uo2D1KRoMzGoS+o=
X-Received: by 2002:a05:6808:8c2:: with SMTP id k2mr2178732oij.98.1562848801716;
 Thu, 11 Jul 2019 05:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190711104412.31233-1-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 11 Jul 2019 13:39:50 +0100
Message-ID: <CAFEAcA8uwgmV47Dt8e=ZRLzssXKWn+1DivDFEuN5s2+N1FJX3w@mail.gmail.com>
Subject: Re: [Qemu-devel] [PULL 00/19] Migration patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 at 11:56, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
>
>   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
>
> are available in the Git repository at:
>
>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>
> for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
>
>   migration: allow private destination ram with x-ignore-shared (2019-07-11 12:30:40 +0200)
>
> ----------------------------------------------------------------
> Migration pull request
>
> ----------------------------------------------------------------

Hi; this fails "make check" on aarch32 host (possibly a general
32-bit host issue, as this is the only 32-bit host I test on):

MALLOC_PERTURB_=${MALLOC_PERTURB_:-$(( ${RANDOM:-0} % 255 + 1))}
tests/test-bitmap -m=quick -k --tap < /dev/null |
./scripts/tap-driver.pl --test-name="test-bitmap"
**
ERROR:/home/peter.maydell/qemu/tests/test-bitmap.c:39:check_bitmap_copy_with_offset:
assertion failed (bmap1 == bmap2)
Aborted
ERROR - Bail out!
ERROR:/home/peter.maydell/qemu/tests/test-bitmap.c:39:check_bitmap_copy_with_offset:
assertion failed (bmap1 == bmap2)
/home/peter.maydell/qemu/tests/Makefile.include:904: recipe for target
'check-unit' failed

thanks
-- PMM
