Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CC94538CF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhKPRxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 12:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhKPRxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 12:53:02 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41024C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:50:05 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id n66so158875oia.9
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qWZ0A57noz7jZT+MU2iLOJI+3i1wAxru93hWvuMXPWU=;
        b=EHYBQEnU02+ZEletqEhaLyP20h0DVqt+p5BuTFqmWkY3V26dmaCwqg+hp0r5xodwKe
         fQaMaFfKMmEs+jQPz5bsTqD7fnxRnhXvlaSCk8lrKnzEnazOEFSlqE1jFp8DebD1MeRk
         p9N1nvrsxxeQQep72GEWsX7HLkzUIx6PEUD8noqp0HqsCyaU7Z05ghtIX95VPegeqUwf
         OAWXjp6lDIQo23tTwSAibnxx9ILF7we+QNCO1H/Aq/o12+FaZlH4O0dzz1ppG92+gn4A
         lZj1beYJ2tT2Lg70MMLR4dCyL+OWWgMMg/FmB4nUwY3FA/Oc8ZzLzHx1L5Kug4KbEeG5
         HjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWZ0A57noz7jZT+MU2iLOJI+3i1wAxru93hWvuMXPWU=;
        b=TUrIGg0BF+MKtVxVXpSzZ/ZyNULHitJBQL2p+HLqINUPd3eLmecWV6knHUZ2ljtWOB
         XGoGhtHYRhuV9+ACVWtn0AGqVw6ONaS3E/fcAtvYV5RQ+Rmm8m4116Avf+BvHSkZcK1F
         v4eEgg1jfjVv3Nj7VWMKq1iCvARPaSfMo1l31HgYTFDkSxx9iBN3HSF7k9N0ttkXg+AH
         qi9WsJrQo/Tm09AA6oiNWHmyGVf+Qwt+MHRixJvcPy1fY7orAgGr3NC/hh8ekVYU7kI7
         BbakIF4IbNVL+KpVjZVZQ/Kx2u0eUOLIvYW/pk7ntCzdKQzx4myRqQvhk8WMfE9CyBTy
         hSOA==
X-Gm-Message-State: AOAM533NIwPeZ+RbY9YMc8kimLuJLhXzZvQGyE2F3kxfjDE+b2vgjJy9
        iA7lGLm3cz/fUJclDGYtkcKInhGRyM7WQNWZ0z74ug==
X-Google-Smtp-Source: ABdhPJwnMzKVR2uE26JhYz4hfRuSmlxyijPh8zh6MEINZD8syf8PcKA1OeakAoRZYHvfp5yV2KzX/c1354TDZiCooIw=
X-Received: by 2002:aca:3055:: with SMTP id w82mr51740540oiw.2.1637085004338;
 Tue, 16 Nov 2021 09:50:04 -0800 (PST)
MIME-Version: 1.0
References: <20211116105038.683627-1-pbonzini@redhat.com>
In-Reply-To: <20211116105038.683627-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 Nov 2021 09:49:53 -0800
Message-ID: <CALMp9eSy7-ziFeOrz+zsdBPOC7AqULYRSrP1kKSMWkFwrmzy8w@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 2:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Right now, unittests.cfg only supports a single check line.  Multiple
> checks must be space separated.
>
> However, the pmu_emulation test does not really need nmi_watchdog=0;
> it is only needed by the PMU counters test because Linux reserves one
> counter if nmi_watchdog=1, but the pmu_emulation test does not
> allocate all counters in the same way.  By removing the counters
> tests from pmu_emulation, the check on nmi_watchdog=0 can be
> removed.

Thanks for fixing this. By the way, one of the reasons that we don't
expose a virtual PMU to more customers is the conflict with the NMI
watchdog. We aren't willing to give up the NMI watchdog on the host,
and we don't really want to report a reduced number of general purpose
counters to the guest. (On AMD, we *can't* report a reduced number of
counters to the guest; the architectural specification doesn't allow
it.)

We can't be the only ones running with the NMI watchdog enabled. How
do others deal with this? Is there any hope of suspending the NMI
watchdog while in VMX non-root mode (or guest mode on AMD)?

> This also hid a typo for the force_emulation_prefix module parameter,
> which is part of the kvm module rather than the kvm_intel module,
> so fix that.
>
> Reported-by: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
