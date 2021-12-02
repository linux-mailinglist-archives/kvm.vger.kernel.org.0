Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685B8466E09
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377638AbhLBX4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 18:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377620AbhLBX4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 18:56:43 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652C3C061757
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 15:53:20 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id f186so4221959ybg.2
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 15:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GjnhpoOnL0nkUK8e5tH0LkfP8VbI2oHbCLG5idnU41o=;
        b=R9wYIUGoiyqMk8vE5PZPKlctyumb/X9DjtLfnAeJish6hTZtgeAleRmwUfy/GoqYCc
         VmHGLofVfG8x1QjRAV3pq/7MwjfGlGfRomZ8Y9pgekAwhFa5nLAropltKTefhqPiYmFo
         lVe9u5VIh64uMq7ZrWR4tmlEhC77opQARLvok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GjnhpoOnL0nkUK8e5tH0LkfP8VbI2oHbCLG5idnU41o=;
        b=Fuwk6Slx91GqnvuYFqax/1EoIRnQ6ExG2MZArLdQ5p2WSeR9MtIioCQ8uX9PchgOa0
         F5NMMF/GCQJjasJRgGOKAt9GTSOoB40yy5L21KnI6j7egUCq18MZ3E6Mi3RAAWiSrQ9p
         2Pu56rkjbH/S6/lFHnYCldgaFVt7LFeTVmJMiuAIummDqP2251H+4ZiQyxUMR25FmUUO
         VnqHtWZfLwazrxVamZpxgJ3aJt1YUT3PmqzX/58ycy/l/vXKKPIUAUHFybRYHo0MDaiW
         SUM7w744MvJh0rUuJ4rzndqEHL84+188lBwfQBoefvWN3YAeXJjTW7IfomI9s4bXG7BD
         6e/Q==
X-Gm-Message-State: AOAM532Z2JtcuQ0h/6wFiofmxHn5AkxhUTBEGgocwM+prGHiu2PB/VNL
        Te5qXX7pbkrAq8GZcdf3b+qyGxcF+DaL9oKju9Um
X-Google-Smtp-Source: ABdhPJxGOTvuNsg6p3sZclfRacsRfmO5tG8iNLa4qQJz2JVMpMi1C+9HpXvOg5o0qHggToRlwtgmNxUkEQUdBKhDLTg=
X-Received: by 2002:a25:bbc4:: with SMTP id c4mr17772662ybk.309.1638489199611;
 Thu, 02 Dec 2021 15:53:19 -0800 (PST)
MIME-Version: 1.0
References: <20211126193111.559874-1-atishp@atishpatra.org> <CAAhSdy0bKWCBT+b1w1Z5YO+Vq8xYgyYQoR8yvPK2SuK=VXwWXw@mail.gmail.com>
In-Reply-To: <CAAhSdy0bKWCBT+b1w1Z5YO+Vq8xYgyYQoR8yvPK2SuK=VXwWXw@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 2 Dec 2021 15:53:08 -0800
Message-ID: <CAOnJCU+K=nWQu=6NFAJzjPFE=UYCsr=KWzXZxBXYYji3vSSPVA@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update Atish's email address
To:     Anup Patel <anup@brainfault.org>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 2, 2021 at 12:50 AM Anup Patel <anup@brainfault.org> wrote:
>
> On Sat, Nov 27, 2021 at 1:01 AM Atish Patra <atishp@atishpatra.org> wrote:
> >
> > I am no longer employed by western digital. Update my email address to
> > personal one and add entries to .mailmap as well.
> >
> > Signed-off-by: Atish Patra <atishp@atishpatra.org>
> > ---
> >  .mailmap    | 3 +++
> >  MAINTAINERS | 2 +-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/.mailmap b/.mailmap
> > index 14314e3c5d5e..5878de9783e4 100644
> > --- a/.mailmap
> > +++ b/.mailmap
> > @@ -50,6 +50,9 @@ Archit Taneja <archit@ti.com>
> >  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
> >  Arnaud Patard <arnaud.patard@rtp-net.org>
> >  Arnd Bergmann <arnd@arndb.de>
> > +Atish Patra <atish.patra@wdc.com>
> > +Atish Patra <atishp@atishpatra.org>
> > +Atish Patra <atishp@rivosinc.com>
>
> I think you just need one-line entry to map WDC email (OLD) to
> Personal/Rivos email (NEW)
>
> Something like:
> Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com>
>

Well, I saw both kinds of entries (multiline & single line) entries
throughout the .mailmap.
Thus, I assumed both would work fine.

I will send v3 with a single line entry right away.

> Regards,
> Anup
>
> >  Axel Dyks <xl@xlsigned.net>
> >  Axel Lin <axel.lin@gmail.com>
> >  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 7a2345ce8521..b22af4edcd08 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10434,7 +10434,7 @@ F:      arch/powerpc/kvm/
> >
> >  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> >  M:     Anup Patel <anup.patel@wdc.com>
> > -R:     Atish Patra <atish.patra@wdc.com>
> > +R:     Atish Patra <atishp@atishpatra.org>
> >  L:     kvm@vger.kernel.org
> >  L:     kvm-riscv@lists.infradead.org
> >  L:     linux-riscv@lists.infradead.org
> > --
> > 2.33.1
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv



-- 
Regards,
Atish
