Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1791E2122
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbgEZLoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388510AbgEZLoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 07:44:37 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD4EC03E97E;
        Tue, 26 May 2020 04:44:37 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u13so2824343wml.1;
        Tue, 26 May 2020 04:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tuci6Ki33qECsPRDTgQQcFkNzETOo6zqEjq9SgRJP20=;
        b=jkoXQdoHdiuYV8cl7WE30oReSifwn9FQIyL7+JcLlJV/YBEyZrxS2TSHXtzq0Nifou
         hqJy4r1LyRYWkFMqG0X5dtKA3xNU8ncoPiziNyS2KEgQXjNZFu759qg0nDNVqYaPblXb
         8CYtPtmwfDUVOMS++bwfqFV1IkL5G4/Tl7aEdegP3gpYFn6RpgecG5f/Qb5OD/FP8Q+L
         gYrNC8XbtDg5gFknnftU+tc5Lll2XKqvs29CE2ckppfy7phURSShsq6NlXVXB2q8R1CT
         TzifCVof9EQh3xdyvDcHIFYgUkMwpuFRJFFoXwRjkEHsyMyCm/h9Oz9dGJFrFfc81Vhl
         LLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tuci6Ki33qECsPRDTgQQcFkNzETOo6zqEjq9SgRJP20=;
        b=qUEaLqYR29uGSZqFqoY9SVBWwxol86w9nmwS0vaahNd5IzYoUT5tldf5cL/SqsMttP
         I0A+hQ/TXbp3UzUQTdR8Ktv10ZaBN/AEb/JStDQ6eDZvs0xqhiH83gdPHKbAV9/R13DO
         +KIEthFkwXTnornb8/Q7AHIzNyviWdx0nc3oKmdiumG0BNtGRV9Jhas6+kfkqYhoHWId
         u+FfgvJlPmS1Crl7/RYMVvIPQo2cUTtoqoS1uaFUhukLQ4agkjQ1cIAA2W6xm561+Emb
         5gWulG+hK1uHt2Z3ch1wuZAVzyQmhVpUO2VUO8j2l4vYERCOO1U8p5vBljsrtgWHBAu7
         GFUQ==
X-Gm-Message-State: AOAM531+PBB4HIuL04ek90IpIe96Ac1QVFKHh61qbMubZnDDOEWrEZmq
        Ea2T/xyGaZiCoWgh2YjbqPD2+3CT6v5rweaZyWE=
X-Google-Smtp-Source: ABdhPJx5iKrhCguzpaHI4W8nHmnCBx58prhKRACDP+KrIpJI1NZrfLV/wozE1qdTpd41iUI+vjvCJSpnLW+4kCaWU44=
X-Received: by 2002:a1c:46c3:: with SMTP id t186mr1025743wma.36.1590493475727;
 Tue, 26 May 2020 04:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
 <CAHiYmc7sBuG8p2cZ_28UH8kSPpBLe5dj9fDWo45NZWLGcBvhpg@mail.gmail.com>
 <CAAhV-H56E2LLHM-0UPLeR0vKDw=qJaRU9QYbxzNc=St_QK9oOA@mail.gmail.com> <CAHiYmc5m9if5fraMumTTikdO=xLit1w-_FK6pR9ejpYYrimvyQ@mail.gmail.com>
In-Reply-To: <CAHiYmc5m9if5fraMumTTikdO=xLit1w-_FK6pR9ejpYYrimvyQ@mail.gmail.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Tue, 26 May 2020 13:44:22 +0200
Message-ID: <CAHiYmc7FzEQ-8L0W696AMThecB2UijLbfNbMi=DbYNp3Wt847g@mail.gmail.com>
Subject: Re: [PATCH V8 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BF=D0=BE=D0=BD, 25. =D0=BC=D0=B0=D1=98 2020. =D1=83 08:37 Aleksandar Ma=
rkovic
<aleksandar.qemu.devel@gmail.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=
=81=D0=B0=D0=BE/=D0=BB=D0=B0:
>
> =D0=BF=D0=BE=D0=BD, 25. =D0=BC=D0=B0=D1=98 2020. =D1=83 03:23 Huacai Chen=
 <chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BE/=D0=BB=D0=B0:
> >
> > Hi, Aleksandar,
> >
> > On Mon, May 25, 2020 at 8:26 AM Aleksandar Markovic
> > <aleksandar.qemu.devel@gmail.com> wrote:
> > >
> > > > V7 -> V8:
> > > > 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
> > > >    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/M=
IPS
> > > >    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regard=
less
> > > >    of page table folding"), which has already been in mips tree but=
 not
> > > >    in kvm tree.
> > > >
> > >
> > > Huacai,
> > >
> > > I do support and salute the series (as I always did), as I see it as =
a
> > > giant step forward for KVM for MIPS.
> > >
> > > However, in general, I think any series should not depend on "pick
> > > that patch from another tree", and should be a stand-alone unit that
> > > yields to successful build and desired functionality. If there is a
> > > dependency like you described, the patch in question, in my opinion,
> > > should be integrated into the series in question. Git is even smart
> > > enough that it recognizes the same patch has been applied before, so
> > > integration of another tree would not be exposed to problems.
> > >
> > > From the point of view of synchronizing with QEMU part, and the timin=
g
> > > issues wrt kernel and QEMU releases, I want to stress that it is
> > > better that this series is integrated sooner rather than later. In
> > > other words, I think that potential Paolo's KVM pull request should
> > > happen before Thomas' mips-next pull request (Paolo could include
> > > "mips: define pud_index() regardless of page table folding", and
> > > Thomas could simply omit it).
> > >
> > > But, that said, I don't feel I should impose my opinion to others
> > > here. Take my statements just as advises. I defer the decision on how
> > > to proceed with the integration of this series entirely to Paolo and
> > > Thomas.
> > I think I lack some experience of cross-subsystem development, so in
> > V8 I only adjust the context of my own patches to let the series be
> > applied on kvm tree, but didn't consider patches already in other
> > trees (Moreover, that patch is not mine). So, should I send a V9 that
> > take commit 3fbfb4585bfd4ff3 together?
> >
>
> No, I think we should wait for Paolo's feedback.
>

Paolo, can you please give us some guidance on integration of this
series, and on future workflow?

Since, the reality is, you are the most experienced between us on
these topics, so you know what is the optimal organization. I gather,
it is very important for us in KVM/MIPS to adopt the efficient and
no-nonsens practices, that you know how to choose the best.

I truly appreciate any future response of yours!

Aleksandar



> > Thanks,
> > Huacai
> > >
> > > Yours,
> > > Aleksandar
