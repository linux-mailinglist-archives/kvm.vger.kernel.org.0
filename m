Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF458471FD1
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 05:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhLMEMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 23:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhLMEMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 23:12:32 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B9C06173F
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:12:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d9so24889708wrw.4
        for <kvm@vger.kernel.org>; Sun, 12 Dec 2021 20:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fP9dnLtCeBgzLlR/Lw9mBCQ4DyaLsnx9vXvgOb0yNOk=;
        b=LJPnA3Nj10kzmHbWiltzioBJ8miNw97Tt+5j1x6H5YJqi6hbXqgTiB/yY5n+t5oGdC
         Nc8usqLj6jGn7ik+rnSox0WsmNrAzhoGEhxBxTUIG0BoT+fLkob7J6oor/VQbMQlPvBJ
         5qyUBM8jHaxy1GIib2gb2vM2yOwh2m3C13nxNLjDa15Hn+AA8+bLqWqW21voEMtp3Mui
         C0I1ydEyj/pFmg/yth2dm3sB5qQdwXmW7d8YV6cGSkY6AbPGlSsSkWVQbEcNiOWsya6l
         T3BgqowUDa8OARsKHh1wgktzd4y39ROY+snlM1ofp3cNpPZ2Fbqn2MJR5SYvo4trr4sw
         +f2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fP9dnLtCeBgzLlR/Lw9mBCQ4DyaLsnx9vXvgOb0yNOk=;
        b=f2W932pOyHSFkMaw+Gd3vLmQuW8WuotdF6HZQ8UIyM//ddRs5lK5PnCWQGMzsc4p6/
         tqDMhkKpaY0sCs7MtkioEdyEl59SgRaN3CPnaJ8wgBzb+yBQtOn/sNwkGcikE1WC2pqM
         cdRAa71DFZtRNw732odqrRIJ7ehYSYCPpY82XgPrcAzMcLVqJJPyyUaE0SYpcfMYHVmd
         hze4Km15qV9Hu3cBfuC96pU3Cg+XutNNIvkgl6euZwoeZVE5xays9a9SLZvLzng4uBa4
         2awHLkP7sMNswjIg13QOQxD1Jr/jcEcoIwbX5YJl1t7HVEq7lVQtVDCpJtI+XFpCaQAv
         fVkA==
X-Gm-Message-State: AOAM532PIF27RXW5OUR7//DXBQX7+SbICuRmK1yT1558xlOm98+X9FDO
        AAGfjDm5jI5y4FarrLOyViscfIVPfCpWRXo/ZnMhcji+cl8=
X-Google-Smtp-Source: ABdhPJxysva3nO33JUSd0bnK/tZzNMemtYt0k+xWYPhfLAhRCBvrcCRGdk7+Txt972NJLGqI3Qtn/bgrd64KzAao10s=
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr13042553wrn.690.1639368749832;
 Sun, 12 Dec 2021 20:12:29 -0800 (PST)
MIME-Version: 1.0
References: <20211119124515.89439-1-anup.patel@wdc.com> <CAAhSdy1pqS5PYdxuxx5RD8baeqfd07Vm1DM7_Eq9Mby37mS_ig@mail.gmail.com>
 <87sfuz9q8p.wl-maz@kernel.org>
In-Reply-To: <87sfuz9q8p.wl-maz@kernel.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Dec 2021 09:42:18 +0530
Message-ID: <CAAhSdy1Lnbe8VhnFW2nhnCzs_74PzuAeyaADvnMfo7iY0qhxsQ@mail.gmail.com>
Subject: Re: [PATCH v11 kvmtool 0/8] KVMTOOL RISC-V Support
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021 at 7:51 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 11 Dec 2021 07:28:49 +0000,
> Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Marc, Hi Will,
> >
> > On Fri, Nov 19, 2021 at 6:15 PM Anup Patel <anup.patel@wdc.com> wrote:
> > >
> > > This series adds RISC-V support for KVMTOOL and it is based on the
> > > Linux-5.16-rc1. The KVM RISC-V patches have been merged in the Linux
> > > kernel since 5.16-rc1.
> > >
> > > The KVMTOOL RISC-V patches can be found in riscv_master branch at:
> > > https//github.com/kvm-riscv/kvmtool.git
> >
> > Ping ?
> > Do you have further comments on this series ?
>
> Not much on my side, apart that it is a bit annoying that some of the
> support is actually an almost exact copy of the arm code (PCI being a
> striking example). It would have been nice to see some effort to make
> the code common, although it isn't a blocker on my side.

Thanks Marc.

I agree with you. The code sharing between ARM and RISC-V support
needs to be improved. We have more stuff to be added after this series
so I will prioritize code sharing.

Regards,
Anup


>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
