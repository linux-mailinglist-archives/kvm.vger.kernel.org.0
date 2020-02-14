Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2703015EE80
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389932AbgBNRky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 12:40:54 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33310 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389809AbgBNRkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 12:40:53 -0500
Received: by mail-io1-f68.google.com with SMTP id z8so11452665ioh.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 09:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1CClW4tYZ79EFJV8GTAjHe6cQOLCCNvZ/tb7p+kbKo=;
        b=jwXJ9r3dQp/+12/mbTFMCINEUOtuUUs4zVoRGjZh0Jq9CkblELQN4A56KA8aiGl1rN
         nkE2kqBst9wANEpXI7757f5nrnoVW7516f/SpwI3dLJ97L/AeQAZnOzEQXZKSXd+5gwT
         zXrtjMkFKNqanCANOJcqvHaBMZZ/f2kdcSA+0Yyyz2/9lqpeOuT5Py6uxuFb4UCyEojZ
         zH0eaKYFXQtq2uQLLrJXsDRxB2rs84YUiUsmPhvNxMRxhclsTmehsmNqbuAh7eBjzguq
         aX47um+kgMO9UePZ8xabTT5VazkH6rv1QT2FYdEMjAqq4KBnJc6LCerOXaqJFddBQD1A
         AZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1CClW4tYZ79EFJV8GTAjHe6cQOLCCNvZ/tb7p+kbKo=;
        b=COtdcY7kOqsgM/rKKUo4xV5zrfiryvG5vTj8EvzaRgwKBrfn3q+eZlQMkSSARNnuOd
         rDrtpPhZctKtyuGpRoxKGHRmbj3R0Pj70XxFq8KSCg154PI3Q1wFik4NcvHutSko1DJP
         hPrBX4hoa3Yei2P2tb1AaBvS2nbYPckAfcbfYzCURp1gMpcRe024Lno5qCiCrK9ZAyzq
         +2oSHmpDxkG8/MIFDJeHQUhpbjNGkRG/k5Z0Lgm47BFdWhl/pzDj6Zpd1c7NmaRKGgoX
         BPg/ORIrxkYSZ+6XzTH02h8fUxewyDUbhSDJYOu26jhXhPX/f5zrGdf/n+7Hy3MyQCHa
         UF7g==
X-Gm-Message-State: APjAAAVD4vj+oMZQcxhEMeUYeWAa+Pnvic2U/TWVw+5vlspzUt2hFMAk
        gQ2YRz7FFC/WMuo8fmyh80x8rQsKITXQQ4jI1yJBlw==
X-Google-Smtp-Source: APXvYqwbi/0s5UxMmiRUbEbHBhFsoQqrHDUU8ZNMeLvDBxbO0J9/qf0mX18DlDrmzayB1IZ16Glzb1cOG7SLbG+NeJI=
X-Received: by 2002:a02:3312:: with SMTP id c18mr3493979jae.24.1581702052559;
 Fri, 14 Feb 2020 09:40:52 -0800 (PST)
MIME-Version: 1.0
References: <1581695768-6123-1-git-send-email-cai@lca.pw> <20200214165923.GA20690@linux.intel.com>
 <1581700124.7365.70.camel@lca.pw>
In-Reply-To: <1581700124.7365.70.camel@lca.pw>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 14 Feb 2020 09:40:41 -0800
Message-ID: <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
To:     Qian Cai <cai@lca.pw>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 9:08 AM Qian Cai <cai@lca.pw> wrote:
>
> On Fri, 2020-02-14 at 08:59 -0800, Sean Christopherson wrote:
> > On Fri, Feb 14, 2020 at 10:56:08AM -0500, Qian Cai wrote:
> > > arch/x86/kvm/emulate.c: In function 'x86_emulate_insn':
> > > arch/x86/kvm/emulate.c:5686:22: error: cast between incompatible
> > > function types from 'int (*)(struct x86_emulate_ctxt *)' to 'void
> > > (*)(struct fastop *)' [-Werror=cast-function-type]
> > >     rc = fastop(ctxt, (fastop_t)ctxt->execute);
> > >
> > > Fixes: 3009afc6e39e ("KVM: x86: Use a typedef for fastop functions")
> > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > ---
> > >  arch/x86/kvm/emulate.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index ddbc61984227..17ae820cf59d 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -5682,10 +5682,12 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
> > >             ctxt->eflags &= ~X86_EFLAGS_RF;
> > >
> > >     if (ctxt->execute) {
> > > -           if (ctxt->d & Fastop)
> > > -                   rc = fastop(ctxt, (fastop_t)ctxt->execute);
> >
> > Alternatively, can we do -Wno-cast-function-type?  That's a silly warning
> > IMO.
>
> I am doing W=1 on linux-next where some of the warnings might be silly but the
> recent commit changes all warnings to errors forces me having to silence those
> somehow.
>
> >
> > If not, will either of these work?
> >
> >                       rc = fastop(ctxt, (void *)ctxt->execute);
> >
> > or
> >                       rc = fastop(ctxt, (fastop_t)(void *)ctxt->execute);
>
> I have no strong preference. I originally thought just to go back the previous
> code style where might be more acceptable, but it is up to maintainers.

It seems misguided to define a local variable just to get an implicit
cast from (void *) to (fastop_t). Sean's first suggestion gives you
the same implicit cast without the local variable. The second
suggestion makes both casts explicit.
