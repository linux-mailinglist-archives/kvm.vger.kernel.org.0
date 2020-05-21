Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E429D1DCB9C
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEULFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 07:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgEULFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 07:05:11 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34019C061A0E;
        Thu, 21 May 2020 04:05:10 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so6247294wrn.6;
        Thu, 21 May 2020 04:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0kOWfagYaxm33AGZcA1CpvfNn7HWE5+JvpuvxfP/z54=;
        b=eoqCHD/0uMiOw3qgaN7N4QZPdhvb/P2BiPUskhLmWsGZK66FilVFjjUhf0q3VF0dY8
         aS+Xg9hy81A6LfdW207F3V9eDhFWayFXbWSLKyEk1B+5mzPDMUe0RverKiLSTvsvUPKy
         hECRT0UhKwWWATTnX26xGHqY/k+iO0Jn8wnfgqDTzMlxN23FHuJQzJ48dp8zh1mkXEmy
         oekBNs5wSPrtaQBQiaNwjE66lRczYOzGNqrtN8dhfoXhOVqRjJmhREd7reCw/o5HLU7l
         a2ypqQuGrwZAN3RIg9oOyiW4cUurSxmg/+FX4JPEWc7VY0L1fxRlISQu16UREduYbu96
         /r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0kOWfagYaxm33AGZcA1CpvfNn7HWE5+JvpuvxfP/z54=;
        b=bQFAQjKOhfJcaWJPBIyXCjjI0Bu98Doqp0MNaKMrXliC5SfjdT6jsNpoE6nF5BMwrA
         /UY5BDzGICyb348h4b4whbw/rTQOfFIK2hXSaCzRBknll+LcoL064vzlnTXpLNB5Qd1Y
         DoEPo8/EqiJv5wWJInWrva3KFtlJDorLhc5XbSgvKuOagy2lW7dQhWdhP8HsHYQAT9ex
         0y8SPUzpFSK4AsDo478YQ4BWkk0u8hNgG3Drt/eQH1ettdxyZ6hhysrSRCXQadPgMi9u
         hqEiNFB6APXSttj1KDWIa3UQPrPFRaG+5KoyIIim+1V0Sys+3JzkFeNRg5ebKgB1knfI
         h7mQ==
X-Gm-Message-State: AOAM5321dOunzO/c9Rjyfjp1DRrYX3LIAXLCUy5Nns7sR8P4m+gxpwlz
        Xnfs24Yy296/wCdfHuZ3VNJEmpRWU84HvuI8Wck=
X-Google-Smtp-Source: ABdhPJxmDJFt2wt5d0VyfLFJJKwwRxN/ZxsaG5OeRNUHphLk+LjBf5oyUeS2ljeHjl50kWsRDkXvvFetScmDdEqT+J0=
X-Received: by 2002:adf:dc50:: with SMTP id m16mr8092867wrj.329.1590059108830;
 Thu, 21 May 2020 04:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
 <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com> <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
In-Reply-To: <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 21 May 2020 13:04:54 +0200
Message-ID: <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I'm sorry for the late response. These days I'm attempting to collect
> some maintainers' PGP signatures, in order to get a kernel.org
> account. So, I think we can keep the lemote.com address in MAINTAINERS
> now, and update to the kernel.org address when I succeed.
>

I agree. E-mail address can be easily changed later.

I think it is reasonable that minor email tech problems should not stop
this series.

I gather that at least approximate consensus is that v6 is "good to go".

While I am at this series, I just want to let everybody that there is a
long-standing practice in QEMU for MIPS that we don't upstream
changes that depend on kernel support that is not yet upstreamed
in kernel - and I want to keep that practice in future (and not limited
to KVM, but for all kernel/QEMU interdependant code).

In other words, corresponding Huacai's changes in QEMU will be
kept on hold as long as this series is still not upstreamed in kernel.
But, that was the original Huacai's plan anyway.

Many thanks to everyone involved!

Aleksandar



> Regards,
> Huacai
