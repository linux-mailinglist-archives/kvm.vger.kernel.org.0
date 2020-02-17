Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDBB160775
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgBQAOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 19:14:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40818 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgBQAOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 19:14:36 -0500
Received: by mail-lf1-f68.google.com with SMTP id c23so10536070lfi.7
        for <kvm@vger.kernel.org>; Sun, 16 Feb 2020 16:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+IGQ44b8ehFgo9r1oz6MUXO7lMciX3lsO+/mrOD8lKs=;
        b=wNohhz24KyweaPRjF/ZHHazpqKxyZNG6eY/v2jPjEqflMXmdDA87blQaYxRrP52OhY
         oJTM4/wtKG7H+a1O638elj6pNxgX47boYHKawJBnthqWtfiyVZ4wjeYuZUgaNoFf6tmj
         OHix6PBfxoL2v75rtEk7TggEjhdRlnRIJocJs3QyjXC4ZKEUJVV6f2w4afRH/JV620mr
         SiiSqZLcMoPYdi4oHPFYWVKg60WUqtCqSmOsPwK6qz2JQgU5S1H0YqmPMkMU76jDZTYn
         lkP33PSLavtDBMXgIIfm9y3nM9p61Zer7u46FZWlhNRGCPbRQQdDAH4XsABPtGnW60B8
         BE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+IGQ44b8ehFgo9r1oz6MUXO7lMciX3lsO+/mrOD8lKs=;
        b=AzMY3GEe8SkBW6/jZ6U+4Rer9tkwufTKsAy8+yMndIk8kLM/YVfDi9eQV3NHxyrzSH
         8mjTbwp30iK5o1xbqVA9P5v1n+3lwik0UHxb2E/ObUhZx610GFOoEeKsjeiLLT0uroP6
         3wHK+6gEq0lm6GJ7BmKntz9pDzvdgWqygwFavOD/tU0lIYISecoA/XFum0QiD/Q5U2D+
         UdWUo3P94srClVpBoX8ViGVq76/9lC0nPq3+C8cJr354YRMb8mr9Bjxfy57wXqeMjVx2
         FkeNmq5WrwcdLu4ETGZhmmnjdfF8bB9kNKo3OO9iwhO/1WNIUvkxJmoNImHstmnHc8Wu
         Nm1w==
X-Gm-Message-State: APjAAAXb0Ac2HeXn8RVBETVAQOKGxtJsd1s6H3hU0Fce14CQ1kNpzwvN
        t+I172vz4y2Wg9AS4uwxmakyu0C6fcg4RKsm50RIkQ==
X-Google-Smtp-Source: APXvYqzsIMSQIv73Gzmo6PpatlAiH1YXLjMsm2KELMYVI69mtO6l3/cej9L7YkzaEFTovPCBl/VZ0ymnuMu8PEaKD0Y=
X-Received: by 2002:ac2:5dc8:: with SMTP id x8mr6411681lfq.217.1581898475042;
 Sun, 16 Feb 2020 16:14:35 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 17 Feb 2020 01:14:24 +0100
Message-ID: <CACRpkdYTpuONqYvhe2k7vpbBFRBbG6PVihzj8mKctpQiK4vXTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Anders Berg <anders.berg@lsi.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:

> it has been a good prototype for the arm64 version,
> but it suffers a few problems:

Wittgenstein wrote that sometimes an intellectual exercise work like such
that you have to throw away the ladder after you climbed it. It often
happens in engineering.

It also echoes Fred Brooks Mythical Man-Month:
"In most projects, the first system built is barely usable....Hence plan to
throw one away; you will, anyhow."

> To reiterate: 32bit guest support for arm64 stays, of course. Only
> 32bit host goes.

That sounds more useful.

I won't miss it.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
