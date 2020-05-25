Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1950B1E071F
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 08:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbgEYGhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 02:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgEYGhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 02:37:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3669DC061A0E;
        Sun, 24 May 2020 23:37:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q11so3868575wrp.3;
        Sun, 24 May 2020 23:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tN7L4x9NdCc3VlnaCxMN2sDPYAVx+Gt9VEFulGrwwt8=;
        b=goF2tvGX1ugX80VobzSI4g9KPGLk+dKmegtwEQ7SfragTt8l9gpvWZjLjulGoCCCwZ
         7Yp1ZndP67gHDaanqPGt9tliJst02NfsigND7z691hOk34toCHIORadaFnY1aZ2vh1Cn
         J7NV+HA2WP2HazU/Zt6jpYEi82ZakdkwU3pbZH8vENn5dsNJhei4McPIJIFzLGTYrvC5
         cjP3iDjZ7sRSrBW9UWWsKJKz9O1q3FDcdRRYaqBgf8M8No+OhQYgXPcFegbVi65z6drq
         nVDJsJE4gZoqb7LvITSPEmlITBWByLKyMi4TCLjWmRI1JooYq22r1t+n5bSDWMvK5gQD
         CMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tN7L4x9NdCc3VlnaCxMN2sDPYAVx+Gt9VEFulGrwwt8=;
        b=tPlFDXkTiqODc/Zi8zsz1eElnG3u3Ygvc4q0q1a385VegSvpH2vjLdufVNjxMlFKTN
         F4frICA8bP5COrwXFc8KHR0LsRqttIElyO8C1b7Y6ncEIRbj8BcCUedW0mo3vYbLb4aZ
         0ebdEgMMko6dCmknYHQBx4dEO7wun2F+2HRF5mzXrT6LEAQlPyzOjttatnHO8foQp3nE
         +RO1ah3PBldcHBoCvh7RGptrIXK5zbtvg00JFMLNww492DKr3yClcv5WvlKCDxQHo9yi
         pp95mA20M7nNoXyPMVrR9O8qSLX3mR97x5hjoJbLIW7W4qR4SbgsFEcECfF9kmHxqy4t
         +Bpw==
X-Gm-Message-State: AOAM533nRdv/CfUjpTUfattdELd5c4yUvxOe2pH9TtGZekka87sfAtVl
        aZ9KWlrw8Dj6IPqwEBC1sAX9FrseAQxyVbri+x4=
X-Google-Smtp-Source: ABdhPJwKGRIymwcsF2V1eRxJ6VNCk8Zvtmp4E4R61B4L8iVjh9OWecLwGgkvkOLA6dA6agLqnlTzi5pBVHDuWUrVEOc=
X-Received: by 2002:a5d:4385:: with SMTP id i5mr7184752wrq.420.1590388635862;
 Sun, 24 May 2020 23:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
 <CAHiYmc7sBuG8p2cZ_28UH8kSPpBLe5dj9fDWo45NZWLGcBvhpg@mail.gmail.com> <CAAhV-H56E2LLHM-0UPLeR0vKDw=qJaRU9QYbxzNc=St_QK9oOA@mail.gmail.com>
In-Reply-To: <CAAhV-H56E2LLHM-0UPLeR0vKDw=qJaRU9QYbxzNc=St_QK9oOA@mail.gmail.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Mon, 25 May 2020 08:37:03 +0200
Message-ID: <CAHiYmc5m9if5fraMumTTikdO=xLit1w-_FK6pR9ejpYYrimvyQ@mail.gmail.com>
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

=D0=BF=D0=BE=D0=BD, 25. =D0=BC=D0=B0=D1=98 2020. =D1=83 03:23 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Hi, Aleksandar,
>
> On Mon, May 25, 2020 at 8:26 AM Aleksandar Markovic
> <aleksandar.qemu.devel@gmail.com> wrote:
> >
> > > V7 -> V8:
> > > 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
> > >    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/MIP=
S
> > >    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regardle=
ss
> > >    of page table folding"), which has already been in mips tree but n=
ot
> > >    in kvm tree.
> > >
> >
> > Huacai,
> >
> > I do support and salute the series (as I always did), as I see it as a
> > giant step forward for KVM for MIPS.
> >
> > However, in general, I think any series should not depend on "pick
> > that patch from another tree", and should be a stand-alone unit that
> > yields to successful build and desired functionality. If there is a
> > dependency like you described, the patch in question, in my opinion,
> > should be integrated into the series in question. Git is even smart
> > enough that it recognizes the same patch has been applied before, so
> > integration of another tree would not be exposed to problems.
> >
> > From the point of view of synchronizing with QEMU part, and the timing
> > issues wrt kernel and QEMU releases, I want to stress that it is
> > better that this series is integrated sooner rather than later. In
> > other words, I think that potential Paolo's KVM pull request should
> > happen before Thomas' mips-next pull request (Paolo could include
> > "mips: define pud_index() regardless of page table folding", and
> > Thomas could simply omit it).
> >
> > But, that said, I don't feel I should impose my opinion to others
> > here. Take my statements just as advises. I defer the decision on how
> > to proceed with the integration of this series entirely to Paolo and
> > Thomas.
> I think I lack some experience of cross-subsystem development, so in
> V8 I only adjust the context of my own patches to let the series be
> applied on kvm tree, but didn't consider patches already in other
> trees (Moreover, that patch is not mine). So, should I send a V9 that
> take commit 3fbfb4585bfd4ff3 together?
>

No, I think we should wait for Paolo's feedback.

> Thanks,
> Huacai
> >
> > Yours,
> > Aleksandar
