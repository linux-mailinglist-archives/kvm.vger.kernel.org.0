Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C26F449E59
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 22:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbhKHVmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 16:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbhKHVma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 16:42:30 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1467C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 13:39:45 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u11so39480500lfs.1
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 13:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WLI0g2MRiwX1g7+YXeGwvKwz55SbnSQmLLbUZVaWW3g=;
        b=qV4Ux2fsw9yDjlcovQgaFn+u427LTPAD127YfeaWLPulYNnnGX2phv6+uC93b3hcZd
         jAGPR3kaPn2AhxYe2A9kKt6zBPH2EcRQ49hq+Xy6OC5rlbdniZtSunDkkAZaw7WZoR3Z
         KKQtVdfEgXNvO+V/rfw4S5l2fpVUT7b+wDL2RaE1y7HG84h0x4SWPLe20YusFT1Tk/dU
         UWXN/HeAoexZgj7GVskZAFtusuHPQTU6VX2bZq6rsOJdzwy2egANYhni2MH5/I7TEzfP
         PzmmuBd0NpsUtjRJv0OozHRwJF4FhkAqRJWbXCeNmyu7ezbCd55jdESuL1U7IS8pMOyz
         kF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLI0g2MRiwX1g7+YXeGwvKwz55SbnSQmLLbUZVaWW3g=;
        b=oejjNOoAelpO20WHBaWUhufTERjidZj8Cu0CxX6NiZpE4wWcmp7t1A2bxzVd6ruPGE
         XLabeeRsZ8KbCrecI7bhxRe5LFl6DuaXnvgy62DdUqFCihaXTdTtBayHMAMjb7fLjzMe
         1L+mtP2yzH7NP3tj9zjPL1nNZmPlrOiSYRIlNx0akvMjye+F5IzazTZb9G4sI5LKQ6wl
         nsPL17NTP5FiqLxIGaY+7uQyMi8SZd1sHc2S0PGwBjpMbw4O7td5zg9ygw9kPYple6by
         ua7pEbNCl6rqVzcc+LLl2dRe30vm3GmmiW7/4/jcbI2/lNSdwQGNqoHuj4vwJD78EZlp
         JmVw==
X-Gm-Message-State: AOAM532asE35rtc9NPmQwUcSj8GFV+pWPcG7hS0RXS1ZbOcNsGn//45M
        KolDxqGsVMxf66wJ9CzEPcK1M4ae50wmhmlpDG6NrQ==
X-Google-Smtp-Source: ABdhPJw7pUv23ArHu6huP0ZPfERzOR0M2tkG8plls3ljRTRvz0Vw+b9poVWyZzuv8EIr1yUvvYNDg6ngJTrGVJOOp7c=
X-Received: by 2002:ac2:54bc:: with SMTP id w28mr2206965lfk.190.1636407582880;
 Mon, 08 Nov 2021 13:39:42 -0800 (PST)
MIME-Version: 1.0
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
 <c9bd3bca-f901-d8db-c23d-5292ab7bd247@redhat.com> <YYmBMGvU/kthFiM9@google.com>
 <ba65851f-4f03-e5e2-ac88-139d9b48d44c@redhat.com>
In-Reply-To: <ba65851f-4f03-e5e2-ac88-139d9b48d44c@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 8 Nov 2021 13:39:16 -0800
Message-ID: <CALzav=dyfX+zz2yrpPAAEaDwMCDOaXePTU791aLcsAU0wopBzw@mail.gmail.com>
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 8, 2021 at 1:37 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/8/21 20:57, David Matlack wrote:
> >> I'm not super
> >> interested in adding eager page splitting for the older methods (clear
> >> on KVM_GET_DIRTY_LOG, and manual-clear without initially-all-set), but
> >> it should be useful for the ring buffer method and that *should* share
> >> most of the code with the older methods.
> >
> > Using Eager Page Splitting with the ring buffer method would require
> > splitting the entire memslot when dirty logging is enabled for that
> > memslot right? Are you saying we should do that?
>
> Yeah, that's why I said it should share code with clear-on-get-dirty.
>
> For initially-all-set, where it's possible to do it and even easy-ish, I
> would like to avoid paying the cost of splitting entirely upfront, when
> enabling dirty page tracking.  But you can already post an RFC that just
> splits always when dirty page tracking is enabled, so that I have a bit
> more of an idea of the new code, and of what it would entail to smear
> the cost over the calls to KVM_CLEAR_DIRTY_LOG.

Ok makes sense. Thanks for the feedback!

>
> Thanks,
>
> Paolo
>
