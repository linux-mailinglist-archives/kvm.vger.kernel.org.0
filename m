Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E709C416544
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbhIWSg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242735AbhIWSg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 14:36:57 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB1CC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 11:35:25 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b15so28869841lfe.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pdd55j9u/Yqx6exf774nKDPI2J7iNDoOI/ZBgE89+d4=;
        b=aB8EhPiz0p8Y3HMuTIMDIzi9lDV2CEcqWINVml+AXz4tT4ALc4xMzjtfq1zJ1bixIc
         s+ICiNJW45pBzDC4eVSsiI1QFaJFcMKczcQn+LvzF8IdIpBErABudOAh4ea5qYvRxxjO
         u2xLlbIXJbTZ5V9jSzS2C5h7GfFl71mp6H0vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pdd55j9u/Yqx6exf774nKDPI2J7iNDoOI/ZBgE89+d4=;
        b=MfBen3s/Bc6GNXt5UcJ9/fX606qW49htAzbZVL8hlkismJOJ9PQwRrcx3snDJwsDeU
         k/Ip5fEqniYOp+Ahd2TCjc6O8LJO8hu6wpy+EJsbp0QppOw4aJUQc8Wob7FOXxWNczJJ
         9GKgUGBG6RxlEWR4mQoz924zw5QpSBoLZqRRV0ne+PKlBC175qfF1LIYzSx8RfiLnNfo
         C0DN0jQRKH3Y/n7DHOMJQ2xLmjOdxV0Jj5jfoZtV3FC+5N6+3Eii2zLCAJYEvN2olWGr
         TsA/CZWOktEIgyBzdBaKIPzxaCN8MPdkw/3YCZEBFrsq0irQjRpXDeN8jlb8g3Xz2irG
         dUsw==
X-Gm-Message-State: AOAM532ea0CxlvdLz9QklnRnipKRMm3scbtFuWJNYFQHNHg8Ztnk2CrJ
        DQOq203vkk4CkudkFmBwN6PzWPPWJQjvsQCX218=
X-Google-Smtp-Source: ABdhPJxjHCMzlvla3JV6R4wOMVFWdRtf7AIyKD8QnXVU6EyYkMb0awBgjazVSJeGNAyMoBLemRTKXA==
X-Received: by 2002:a2e:a446:: with SMTP id v6mr2963591ljn.143.1632422123542;
        Thu, 23 Sep 2021 11:35:23 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id l13sm313134lfk.211.2021.09.23.11.35.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 11:35:23 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id b15so28869529lfe.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 11:35:23 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr5825247lfg.280.1632422122098;
 Thu, 23 Sep 2021 11:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210923181252.44385-1-pbonzini@redhat.com>
In-Reply-To: <20210923181252.44385-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Sep 2021 11:35:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
Message-ID: <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 11:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> A fix for a bug with restartable sequences and KVM.  KVM's handling
> of TIF_NOTIFY_RESUME, e.g. for task migration, clears the flag without
> informing rseq and leads to stale data in userspace's rseq struct.

Ok, patches look reasonable.

> I'm sending this as a separate pull request since it's not code
> that I usually touch.  In particular, patch 2 ("entry: rseq: Call
> rseq_handle_notify_resume() in tracehook_notify_resume()") is just a
> cleanup to try and make future bugs less likely.  If you prefer this to
> be sent via Thomas and only in 5.16, please speak up.

So I took the pull request this way, thanks for separating it like this.

But I'm adding a few people to the cc for a completely different
reason: the cleanup to move all the notify_resume stuff to
tracehook_notify_resume() is good, but it does make me go - once again
- "Hmm, that naming is really really bad".

The <linux/tracehook.h> code was literally meant for tracing. It's
where the name comes from, and it's the original intent: having a
place that you can hook into for tracing that doesn't depend on how
the core kernel code ends up changing.

But that's not how it actually acts right now. That header file is now
some very core functionality, and little of it is actually related to
tracing any more. It's more core process state handling for the user
space return path.

So I don't object to the patches, and they are merged, but I'm cc'ing people to

 (a) let them know about this (see commit a68de80f61f6: "entry: rseq:
Call rseq_handle_notify_resume() in tracehook_notify_resume()" in the
current -git tree)

 (b) possibly prod some people into perhaps moving/renaming some of
that code to actual core kernel C files, instead of a misnamed header
file..

Hmm?

         Linus
