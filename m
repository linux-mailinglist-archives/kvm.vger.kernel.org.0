Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0636B4325BD
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhJRSAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhJRSAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:00:08 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5448C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:57:56 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l5so1189280lja.13
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enwUwHCvAXH97heRPPUL44a0hk47wLy74P2gCbKr6NU=;
        b=Bmhkl7KfEzX5Uq7jl7xfID7BkPuhl5sDEzqgBuDyAA02Gi/wM31V/IBFmwWEhFVK00
         68fN8uBsbkAmuwdDzeJIHGrtcQU5Nczhzxw6O9q3mu+Ng5DdUUy45mnW2E4EbGSm/8r+
         yeCCr++Yidmwd9CEfrt+AyM0xc4yHQvyDl6dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enwUwHCvAXH97heRPPUL44a0hk47wLy74P2gCbKr6NU=;
        b=wiSlK+3naByYiQa3DHKF+dcCzrZN4ANFGfRQd9dm0ywzKN5NrRvMQGA1RsCVKTc+qz
         Sg3bfKLvGGPdLLOEIoxWjRRtU6afAIIGJDq+x+pgDVHfRIRwNqWlQB6UAacj73ul5Y6m
         cwSbvXbbHOlq+tURxiroMojoXH0y1RwiCIMA/DyHYmAKkK4eXm5vqWKslQYDrx6VZaMs
         VZEgzBo2+5IV1PvT6JS/YYK9iZd84TXt0KA/qUNrk/A04ucaJm7mHWN+DcOppUBFZZcv
         RFi9uIJqE1j2DnZF9CdiNE8esZ3Osq3Oq/+961/5O168Py2YKiIVhH9F+FiZU50IincS
         GMmg==
X-Gm-Message-State: AOAM533+A5ReA/vzwBubCW60D41aJslomGa/3ist8Sn5zScxhlND0z2b
        D77TLPB55OuPxo2b2h7CbvCDWhEilnS1dxwM
X-Google-Smtp-Source: ABdhPJyzHyO7KkQ4FFDG9Wz1A4oZZoE2ccxV0/1cNI1IMjDsQeyKhEiR1ktLTR8jdI9MAm3vmKDqZQ==
X-Received: by 2002:a2e:9dc2:: with SMTP id x2mr1231475ljj.253.1634579874846;
        Mon, 18 Oct 2021 10:57:54 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id o15sm213229ljm.139.2021.10.18.10.57.52
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:57:52 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id p16so1535555lfa.2
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:57:52 -0700 (PDT)
X-Received: by 2002:a05:6512:2248:: with SMTP id i8mr1099221lfu.655.1634579872363;
 Mon, 18 Oct 2021 10:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211018174137.579907-1-pbonzini@redhat.com>
In-Reply-To: <20211018174137.579907-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Oct 2021 07:57:36 -1000
X-Gmail-Original-Message-ID: <CAHk-=wg0+bWDKfApDHVR70hsaRA_7bEZfG1XtN2DxZGo+np9Ug@mail.gmail.com>
Message-ID: <CAHk-=wg0+bWDKfApDHVR70hsaRA_7bEZfG1XtN2DxZGo+np9Ug@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fixes for Linux 5.15-rc7
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 7:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> * avoid warning with -Wbitwise-instead-of-logical

Christ. Please no.

Guys, you can't just mindlessly shut off warnings without even
thinking about the code.

Apparently the compiler gives completely insane warning "fixes"
suggestions, and somebody just completely mindlessly followed that
compiler badness.

The way to do a logical "or" (instead of a bitwise one on two boolean
expressions) is to use "||".

Instead, the code was changed to completely insane

   (int) boolexpr1 | (int) boolexpr2

thing, which is entirely illegible and pointless, and no sane person
should ever write code like that.

In other words, the *proper* fix to a warning is to look at the code,
and *unsderstand* the code and the warning, instead of some mindless
conversion to just avoid a warning.

NEVER EVER do mindless changes to source code because the compiler
tells you to. Apparently the clang people wrote a particularly bad
warning "explanation", and that's on clang.

I'm not going to pull this. The clang warning fix is wrong, and then
another commit literally disables accounting for another non-fatal
run-time warning.

Again - warnings are not an excuse to just "mindlessly shut up the warning".

They need some thought.

None of this kind of "I'll do wrong things just to make the warning go
away" garbage that this pull request has two very different examples
of.

I'm adding some clang people, because apparently that

    note: cast one or both operands to int to silence this warning

thing came from clang. Somebody in the clang community really needs to
re-think their "informational" messages.

Giving people those kinds of insane suggestions is a disservice to
everybody. Clang should fix their stupid "note" before release.
Please, guys.

            Linus
