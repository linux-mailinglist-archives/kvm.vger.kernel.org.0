Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB4E1DDF68
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 07:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgEVFeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 01:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgEVFeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 01:34:14 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76736C061A0E;
        Thu, 21 May 2020 22:34:13 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id n11so9594080ilj.4;
        Thu, 21 May 2020 22:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVPd+V02lgzjKws7NT4xHmcTymSXtHJ7wzEyWcOO8YE=;
        b=PKaMBQNM9SpJ/HstjpcQRIL/YaYHjj6X5IeZtF4DdYph5WZPAP0CC0oXUNUGQr+svX
         JSGJS/UWUQgjQ4Khun2Nc5EaDyHTxNIcfc6+dMAlrZKXd5reVTe8AtQ9QDJeEYoeLP/N
         roI3U+RS7SsBXSm0gJI84zx0nuze4hMfl3mvAhXxLcjBZSroZS1hL4vYEovNhFyqvfhl
         Wa8v3gzl9FW4FUmGov46/cVZR1qo+qgI56Liz6rhpjWeEiGwnisL+fu862ThW6Y1EVWG
         27/vHr7ttHTDCiaBq+z1j9+zJwjaiwzb6cYUZaoNdo2XJ40j/VxGYSauXr+7j3JKccbt
         eSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVPd+V02lgzjKws7NT4xHmcTymSXtHJ7wzEyWcOO8YE=;
        b=Pym8Wtgm1k/IMPxZmVbZEU5kBPOuEyPEraJA4aRPFw1A1cQsB84CcJYeFk/Rd1ET25
         Cko4JEYbqk0QQ2i8itKfRBf9dZulBUGt0Jf+TIc8HJ4SfRykhnHQa231Fx4DZ5Bsdw0k
         xXPWmVWbDIxuVlGJCXe6C8VrnAtxNWIN0j9sbtst0Sxh5oHUZRBp23/o3rc0Du3SKdjA
         IHn/XO9waOlvrwnpB/hsMEpm0nOKREZ9k9ACAeomvvGZzf+PARE8f06fSuVRzIuy14rK
         ba8fD1Sa5bWsfjpYxer9bdHgZlxrk5EYZr0zYKv1lO85GcgFCgI7IGEM2FJz78+c+6CW
         9+ig==
X-Gm-Message-State: AOAM530Eqo4sSKr6r/Hbib51p1pw9rvBW9nLG0yphVSH//afRDdk7vVC
        u2Hl9zWefzlbJbad7JIrq2nlA7pJ+yL7escbxEA=
X-Google-Smtp-Source: ABdhPJwCegLUC/45CNBdiF9mtDb1KtgsONcIHPS4z+kPELIlNxqLzCfHHCDrZD0S1oFsV89R2S/ivLYKoZgpsZqbwfk=
X-Received: by 2002:a92:980f:: with SMTP id l15mr11614373ili.251.1590125652851;
 Thu, 21 May 2020 22:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
 <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
 <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
 <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com> <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com>
In-Reply-To: <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Fri, 22 May 2020 13:34:01 +0800
Message-ID: <CAAhV-H6aGkxV41ymu+HPxiSBq9uw-QhmaxFxnZYJTfUay946cg@mail.gmail.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Thu, May 21, 2020 at 10:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/05/20 13:04, Aleksandar Markovic wrote:
> > I agree. E-mail address can be easily changed later.
> >
> > I think it is reasonable that minor email tech problems should not stop
> > this series.
> >
> > I gather that at least approximate consensus is that v6 is "good to go".
> >
> > While I am at this series, I just want to let everybody that there is a
> > long-standing practice in QEMU for MIPS that we don't upstream
> > changes that depend on kernel support that is not yet upstreamed
> > in kernel - and I want to keep that practice in future (and not limited
> > to KVM, but for all kernel/QEMU interdependant code).
> >
> > In other words, corresponding Huacai's changes in QEMU will be
> > kept on hold as long as this series is still not upstreamed in kernel.
> > But, that was the original Huacai's plan anyway.
>
> I am going to queue them for 5.8.
Thank you for your help. But this series depends on an early patch
from Jiaxun Yang ("MIPS: Loongson64: Probe CPU features via CPUCFG")
which seems only in MIPS tree now. So, maybe this series is better be
queued in Thomas's tree?

>
> Thanks,
>
> Paolo
>
Huacai
