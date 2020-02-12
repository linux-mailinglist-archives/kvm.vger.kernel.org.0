Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406EA15B138
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 20:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBLTil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 14:38:41 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46525 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLTil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 14:38:41 -0500
Received: by mail-lj1-f194.google.com with SMTP id x14so3683676ljd.13
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 11:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VIVJ6ANZNwBCwjgFThVMTCailc9/69GGrp4L4rWNwm4=;
        b=hdHh1wCknTiwBSThElO35g/BIz9H/CXTPpcMPEmkD7NNxb1ozOciv/jVLwmHAP9+xH
         SE22Kf5VT7lrVTGDE6xKzIb7CnH8V5I894iDrLLlIPUmUHSvXb1WnFbkAngWq15Gx57/
         9dgUML7Oux8tp2Z0WsoLZEhj9ZVcf6LEbzN6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VIVJ6ANZNwBCwjgFThVMTCailc9/69GGrp4L4rWNwm4=;
        b=FH1/v9iKLqsYJq2He/vljvki4AJzxE/xkYBY6zPiQsVopl0633skz6BfrkCiMpGFv7
         WrWhpu3O0OuauLnUzmVf/7ipdw63/Sqz8kwi9R1dZlUnEqcFNzXJcHMA4ejEAZcR8Nxu
         bPy9K0W2+Fdxo4Otecl/LckrLRtpcYWehlSeukAvXbQOfv9or3sxk+ZdiHw4dggW63MX
         JJXQNZWTK4Q8ucdy5BJFV22yrJE74kBKXhj7KUUBb+uiqAQlA2fervkZguNK9cwPPp3m
         evZb/xiHIVuNoafQM21e6TbkckS1uhbpdppXWUkV/aPyYXq/pvRUj8OK86E2iY7KswC9
         DehA==
X-Gm-Message-State: APjAAAXXoDaa6n3/Ws8bJb0zPt3C4N8/iJZKMydDol3Wm+roskuUZE6c
        YB8BDKkM97vAg71vhHUGs3P8vnJfprk=
X-Google-Smtp-Source: APXvYqysIMA3ktHPAwo8Fy1AdylRA7JCIgq13YaTPHlhp0t6nJjOQ+J7hS7aCnAXxBcXwL2GMppMMA==
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr8858927ljg.166.1581536317686;
        Wed, 12 Feb 2020 11:38:37 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id y2sm71949ljm.28.2020.02.12.11.38.36
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 11:38:36 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id t23so2451743lfk.6
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 11:38:36 -0800 (PST)
X-Received: by 2002:a19:4849:: with SMTP id v70mr7590327lfa.30.1581536316181;
 Wed, 12 Feb 2020 11:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20200212164714.7733-1-pbonzini@redhat.com> <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
 <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com>
In-Reply-To: <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Feb 2020 11:38:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
Message-ID: <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 11:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> > So this clearly never even got a _whiff_ of build-testing.
>
> Oh come on.

Seriously - if you don't even _look_ at the warnings the build
generates, then it hasn't been build-tested.

I don't want to hear "Oh come on". I'm 100% serious.

Build-testing is not just "building". It's the "testing" of the build
too. You clearly never did _any_ testing of the build, since the build
had huge warnings.

Without the checking of the result, "build-testing" is just
"building", and completely irrelevant.

If you have problems seeing the warnings, add a "-Werror" to your scripts.

I do not want to see a _single_ warning in the kernel build. Yes, we
have one in the samples code, and even that annoys the hell out of me.

And exactly because we don't have any warnings in the default build,
it should be really really easy to check for new ones - it's not like
you have to wade through pages of warnings to see if any of them are
your new ones.

So no "Oh come on". You did *zero* testing of this crap, and you need
to own that fact instead of making excuses about it.

                   Linus
