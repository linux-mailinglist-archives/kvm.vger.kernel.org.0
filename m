Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6E7346F43
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 03:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhCXCND convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 23 Mar 2021 22:13:03 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:34705 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhCXCMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 22:12:30 -0400
Received: by mail-qt1-f180.google.com with SMTP id c6so16550905qtc.1
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 19:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r1ikSccTD60sRnV/AdmISo/VbNun/QvCsZUFGJ30T+8=;
        b=G8ml1//jhEmKSUXYe5CrGW5N8C2BR4V28IHaqHItPH8nxqwQWWrWxN+rLArEpGcLjR
         WpeCVQxhKn07+vLCl9bN4MDxssYZmJwVa5AXsVOrrG9RiEGTKJeqf5W6r4xHcPe8FYK9
         y25+sSnydnO6/fFh34syoVBe5Z8iQNobztc0Uadt1+mWlP30MUmwm+Dd4118mapnUNPB
         vJxkrfTUgtiLqc1Hr9D8T4sKQKGhDftxjJPWuJvSG9eTzDp9hr2CDgszNKhHtRICQ+17
         DlMaHihs0NAzWHqqVlrrd3HgclG79OM9X8Ywo0kW7Pe92W1D3+qqCLGoDTkFBdIHSAN4
         kwhg==
X-Gm-Message-State: AOAM531MFeYSt5j+q6JAlyqm8pkEwjtDLXMsW1v/WnJgAJEkETLzoBHK
        pBIvCVvYhCvQJzKX2OpoXHOmA1NRyvb4TtT6Eiyc0w19M+A=
X-Google-Smtp-Source: ABdhPJyfNZoJirHCeiSeW1gza0K4WFBfeqBuHYbFKHg4bkV+6D6eCveEue+bk3WFQ0YcwbWZIPWaYZMpIKB8MnzGTDs=
X-Received: by 2002:ac8:4510:: with SMTP id q16mr1097215qtn.241.1616551938316;
 Tue, 23 Mar 2021 19:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <1602059975-10115-1-git-send-email-chenhc@lemote.com>
 <1602059975-10115-3-git-send-email-chenhc@lemote.com> <0dfbe14a-9ddb-0069-9d86-62861c059d12@amsat.org>
 <CAAhV-H63zhXyUizwOxUtXdQQOR=r82493tgH8NfLmgXF0g8row@mail.gmail.com>
 <9fc6161e-cf27-b636-97c0-9aca77d0f9cd@amsat.org> <CAAhV-H5wPZQ+TGdZL=mPV4YQcjHarJFoEH-nobr10PdesR-ySg@mail.gmail.com>
 <62b12fe2-01db-76c0-b2fd-f730b4157285@amsat.org> <16018289-0b28-4412-854b-0d30519588ca@www.fastmail.com>
In-Reply-To: <16018289-0b28-4412-854b-0d30519588ca@www.fastmail.com>
From:   YunQiang Su <syq@debian.org>
Date:   Wed, 24 Mar 2021 10:12:08 +0800
Message-ID: <CAKcpw6Ud2chjGLGmhr03pLd276d9A3eu-2pC0FLLfYcmg3UNqA@mail.gmail.com>
Subject: Re: [PATCH V13 2/9] meson.build: Re-enable KVM support for MIPS
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@gmail.com>,
        Huacai Chen <zltjiangshi@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        BALATON Zoltan via <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiaxun Yang <jiaxun.yang@flygoat.com> 于2021年3月24日周三 上午9:29写道：
>
>
>
> On Tue, Mar 23, 2021, at 9:56 PM, Philippe Mathieu-Daudé wrote:
> > Hi Huacai,
> >
> > We are going to tag QEMU v6.0-rc0 today.
> >
> > I only have access to a 64-bit MIPS in little-endian to
> > test KVM.
> >
> > Can you test the other configurations please?
> > - 32-bit BE
> > - 32-bit LE
> > - 64-bit BE
>

How to run the test? just run a VM with KVM support on these kernel?

> +syq
> As Loongson doesn't have Big-Endian processor and Loongson 3A won't run 32bit kernel.
>
> Probably wecan test on boston or malta board?
>
> Thanks.
>
>
> >
> > Thanks!
> >
> > Phil.
> >
> >
> [...]
>
> --
> - Jiaxun
