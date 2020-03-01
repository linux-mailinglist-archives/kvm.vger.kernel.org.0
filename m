Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973E4174FED
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 22:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCAVeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 16:34:08 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42044 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCAVeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 16:34:08 -0500
Received: by mail-lf1-f65.google.com with SMTP id 83so6313464lfh.9
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2020 13:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MG3T/bBKuDUDeti/Rm+y4RgArjtBEYGQp1e9CzWemF0=;
        b=apcGvjA2u0cCo4C+VwBU1Sw2XH7N23BHVkkkrwPxPkkLpwgWEXMy8mpoRYhJoe/OwW
         RBhZVTwyblCqHaOrJTdKlZx65NbvjknGHtyp34sPZrAw2qZMOvsnJkebTADHFDIkes4L
         iqhdCg9qQtF1WKTcpzzg+2KH8XViHFCpx2BGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MG3T/bBKuDUDeti/Rm+y4RgArjtBEYGQp1e9CzWemF0=;
        b=mhklIY3FYApY8yhmDHewZjEGtRSYbNpG7SPZ3qeR1sgc91qje0OgAZvUmxe0FW79kd
         1nMLFG7gCldz0cu6OIJKN5ERz9qJKRnhx+EN9Fxm7Xy+IAc87qVEEDWRsTMdOBnX81WM
         AIVrxXWnbkl7uO8cJRtvoaAVA9Usll6IwW2OIfOfL38xddJX2ZC7H2hg4nri0BXEUOGV
         bRWzJ28huojey5rwAqHoYwuQdusDPNNuXm7uzplG2m3ESDtfPpgPpwLjR0+ewnahsIP3
         f6rDHb81is96JmsmiqKJO41EG0WKSRmnXz3YjyCF3DsvQoVU+VUlgX4csB2pcEoIrvRg
         RVfw==
X-Gm-Message-State: ANhLgQ1Uytl9OAqRqXvtFjiQXwA0JCU1bwRRL5BdKsdJ2Xw+9RaPp66v
        2yi8VCJknKZGRitPinhRqBxQCK9U4h9ElA==
X-Google-Smtp-Source: ADFU+vv2WZ4BZzRK8wE7DUr8yTgw6Pib1r4t/8a17SYUlmhb+VlUB8f78SE59vSp1EODzRXTGysgqw==
X-Received: by 2002:ac2:4948:: with SMTP id o8mr8685693lfi.201.1583098445990;
        Sun, 01 Mar 2020 13:34:05 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id u6sm58971lff.35.2020.03.01.13.34.04
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 13:34:05 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id v6so6301074lfo.13
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2020 13:34:04 -0800 (PST)
X-Received: by 2002:a05:6512:10cf:: with SMTP id k15mr1918456lfg.142.1583098444431;
 Sun, 01 Mar 2020 13:34:04 -0800 (PST)
MIME-Version: 1.0
References: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1583089390-36084-1-git-send-email-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 1 Mar 2020 15:33:48 -0600
X-Gmail-Original-Message-ID: <CAHk-=wiin_LkqP2Cm5iPc5snUXYqZVoMFawZ-rjhZnawven8SA@mail.gmail.com>
Message-ID: <CAHk-=wiin_LkqP2Cm5iPc5snUXYqZVoMFawZ-rjhZnawven8SA@mail.gmail.com>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.6-rc4 (or rc5)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 1, 2020 at 1:03 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Paolo Bonzini (4):
>       KVM: allow disabling -Werror

Honestly, this is just badly done.

You've basically made it enable -Werror only for very random
configurations - and apparently the one you test.

Doing things like COMPILE_TEST disables it, but so does not having
EXPERT enabled.

So it looks entirely ad-hoc and makes very little sense. At least the
"with KASAN, disable this" part makes sense, since that's a known
source or warnings. But everything else looks very random.

I've merged this, but I wonder why you couldn't just do what I
suggested originally?

Seriously, if you script your build tests, and don't even look at the
results, then you might as well use

   make KCFLAGS=-Werror

instead of having this kind of completely random option that has
almost no logic to it at all.

And if you depend entirely on random build infrastructure like the
0day bot etc, this likely _is_ going to break when it starts using a
new gcc version, or when it starts testing using clang, or whatever.
So then we end up with another odd random situation where now kvm (and
only kvm) will fail those builds just because they are automated.

Yes, as I said in that original thread, I'd love to do -Werror in
general, at which point it wouldn't be some random ad-hoc kvm special
case for some random option. But the "now it causes problems for
random compiler versions" is a real issue again - but at least it
wouldn't be a random kernel subsystem that happens to trigger it, it
would be a _generic_ issue, and we'd have everybody involved when a
compiler change introduces a new warning.

I've pulled this for now, but I really think it's a horrible hack, and
it's just done entirely wrong.

Adding the powerpc people, since they have more history with their
somewhat less hacky one. Except that one automatically gets disabled
by "make allmodconfig" and friends, which is also kind of pointless.

Michael, what tends to be the triggers for people using
PPC_DISABLE_WERROR? Do you have reports for it? Could we have a
_generic_ option that just gets enabled by default, except it gets
disabled by _known_ issues (like KASAN).

Being disabled for "make allmodconfig" is kind of against one of the
_points_ of "the build should be warning-free".

               Linus
