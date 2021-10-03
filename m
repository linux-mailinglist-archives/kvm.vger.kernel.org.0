Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0689420374
	for <lists+kvm@lfdr.de>; Sun,  3 Oct 2021 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhJCSkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Oct 2021 14:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhJCSkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Oct 2021 14:40:08 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8319EC061780
        for <kvm@vger.kernel.org>; Sun,  3 Oct 2021 11:38:20 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m3so61607249lfu.2
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 11:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VR5QfWPFpdGmXNFJjgSMUkUyN7BZEoQ4vmt9rMlh7cc=;
        b=M6BsPTcN+WAxDbETnbCiRpHBxt5WDjH5LqnA2td5leg0ichX7EfewvgwiziQg/HqoD
         oKuTom0cfCOWKCiLXmwXOaQ3jZRCMvAGP3ag9q4FQYbhnyOP8IcqQwNyTjqLVLfmWepu
         ZwAhQuwu6UvFkcAFn2iFZqjKjK+Nyj8tzm2Gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VR5QfWPFpdGmXNFJjgSMUkUyN7BZEoQ4vmt9rMlh7cc=;
        b=FMB+fAOiYnry4ELBx6i9zBuKpXQ5GZ8T9Yf4nz78v91+WLq4haAfsnKL2hteFeR9h6
         7xjKi3uwG0a2BvDmJS+6797OVyYil1RtmR2bLhzmWzqNJxOEbhG7Ez3iLjlncZ5MjCNf
         IyFuE0qZrUjjkATZGMLtGntDLFnsRtmNGeciNmCZol0YK+hgjKYQzEmdxPeCOwcBl27f
         jX0sduOtUUEoHyHtssDKzWY3YDjzqED0wghO0I9bhFsW/1pYl7gIoD0MCwYybRcPXHdj
         6jeraRNxMHXTUcVEHUegNjDRoek6ABxhkq+psKL4LLmryJflkYaOXu17IGtXO5W2R6nF
         YVlA==
X-Gm-Message-State: AOAM532a0hwcGxHH0IN3NqCQldWKbhoOUeOY3HpYo2RAPPdxlBKLf55n
        nDq1+b86uHCOhi2PjeUDcWfTA79KPwTzytzf
X-Google-Smtp-Source: ABdhPJxGHOQh/tBX3RxPrY2L5f09rjKYL2n9CUWNHVN/DUWy0XAJ4QsoPKCqEt1F2ThKQIGBXoRySg==
X-Received: by 2002:a2e:b608:: with SMTP id r8mr10801749ljn.248.1633286298143;
        Sun, 03 Oct 2021 11:38:18 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id n19sm1341978ljc.11.2021.10.03.11.38.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 11:38:17 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id y23so22799527lfb.0
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 11:38:16 -0700 (PDT)
X-Received: by 2002:a05:6512:b9f:: with SMTP id b31mr10471352lfv.655.1633286296561;
 Sun, 03 Oct 2021 11:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <YVl7RR5NcbPyiXgO@zn.tnic>
In-Reply-To: <YVl7RR5NcbPyiXgO@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 3 Oct 2021 11:38:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
Message-ID: <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
Subject: Re: [GIT PULL] objtool/urgent for v5.15-rc4
To:     Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 3, 2021 at 2:43 AM Borislav Petkov <bp@suse.de> wrote:
>
> - Handle symbol relocations properly due to changes in the toolchains
> which remove section symbols now

Ugh.

This actually causes a new warning for me:

    arch/x86/kvm/emulate.o: warning: objtool: __ex_table+0x4: don't
know how to handle reloc symbol type: kvm_fastop_exception

on an x86-64 allmodconfig build (and my normal clang build for my
actual default config too).

Looking at the kvm code, that kvm_fastop_exception thing is some funky sh*t.

I _think_ the problem is that 'kvm_fastop_exception' is done with bare
asm at the top-level and that triggers some odd interaction with other
section data, but I really don't know.

Anyway, that thing is in my public tree now, because it's better to
get it out and fixed and have the kvm people look at it.

         Linus
