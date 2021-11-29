Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893CC4624DD
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhK2WcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhK2WcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:32:01 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C65CC0613F2
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:20:05 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id t11so37268848ljh.6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gjDXjTb2S4YdT6O3f7qNTTb1NJzMdjs/cBxmgHAdDVY=;
        b=UpAucgfoCVQYq+csJVFaM89/8myyHMKIJT1Vpy6+DXjtcLYb5geF4KKW4d4aR/XfOV
         3suwyWdPFQMKRslkyk2YJZv+qFYehshNU6c/fXkqwdv2W0ATJstjbUgvtIFAuJEqFncb
         6D/nHv8ar6h8nJ/LAnxPBlU0JdwfPj8hGwpE7ktdPO5lmoChBoPsHYZjlkSeHUUUiJSk
         +XQhpekheKSqaVELaRukMyV2OTTlFhXM7anRYsqxpF+vxSoIA7XqaK+sXe6vZ8fy43Kd
         TV+Lbg7f7nEl1NkHmInYFZtVbXm6qVTMXOwy9F+cf8gvNQcrUuYonpY87QKT4mK7ANt5
         mJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gjDXjTb2S4YdT6O3f7qNTTb1NJzMdjs/cBxmgHAdDVY=;
        b=KPe5bMwE9rOUr2DmETEwOiiFNixARB3xocpiFF6T4dmJeRjvwnCqkXkyibiu3Z5cqx
         Z2yJFufUrn0bDcRv9z5c1zoz9sl4h5lEw1mpUhsY1xfYp8+AKGJsuRU6qcVUA/srQWK7
         ucLpzqr0ABSqgS8WpArH0YIsvADkoDfKa3scaI+QMcFjuuGqGmka6zAn4ZWkkeiWOsqX
         Q72/qWCb5SY/1O25Zg6IRbljVgG64D7PsaInc0GN8Bo9UHsa7BOTEiBSE5HryOIqGbf7
         UvE7s+7YFAYFoOoMf8i0easNkiSWi1371VlcmBD15E7EaKCWTun9Ooobtk6YvZZJzFeU
         67ww==
X-Gm-Message-State: AOAM530V+L8NSZbc0LE2UARE1Y6K8PCR/7mQaaVz+eQE8qpmNmQ96oW1
        N2WnzZQxyuGfiFeJ86Tq8lyCVQmJEb+5m63EkcpkCvsZMJnNsQ==
X-Google-Smtp-Source: ABdhPJwRyODR1G2Qd+Gm1zGVtDC6Ox5M8wlESUlXUBwwqPioTQfRFnUGrTpxp7oxqhtuFPjM8F2yowDIj906OEA6Zsg=
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr35377513ljj.49.1638224403135;
 Mon, 29 Nov 2021 14:20:03 -0800 (PST)
MIME-Version: 1.0
References: <20211015195530.301237-1-jmattson@google.com> <ec57f5d2-f3bb-1fa6-bcdf-9217608756f5@redhat.com>
In-Reply-To: <ec57f5d2-f3bb-1fa6-bcdf-9217608756f5@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 29 Nov 2021 14:19:36 -0800
Message-ID: <CALzav=c63DpoBYzhkWeU20tiiH7uv1HfsUaM=RFTuAWOZSybMg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR
 persistence bug
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 1:45 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/15/21 21:55, Jim Mattson wrote:
> > This issue is significant enough that it warrants a regression
> > test. Unfortunately, at the moment, the best we can do is check for
> > the LDTR persistence bug. I'd like to be able to trigger a
> > save/restore from within the L2 guest, but AFAICT, there's no way to
> > do that under qemu. Does anyone want to implement a qemu ISA test
> > device that triggers a save/restore when its configured I/O port is
> > written to?
>
> The selftests infrastructure already has save/restore tests at
> instruction granularity (state_test.c) so you should have more luck that
> way; these tests are worthwhile anyway.

There is also (I just discovered) support for guest-triggerable
migration in the kvm-unit-tests [1]. You could use that to trigger a
save/restore.

[1] Example: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/arm/gic.c#L798

>
> Paolo
>
