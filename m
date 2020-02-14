Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8021A15F69C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 20:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgBNTOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 14:14:09 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43887 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387718AbgBNTOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 14:14:09 -0500
Received: by mail-qt1-f195.google.com with SMTP id d18so7693295qtj.10
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 11:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scnEoR+rGyXwnk7+XhNjguBgKH2xz3AYHqxz930H50g=;
        b=RzdXkWTLw9HZo7wGGYxbe32zLEXoVEUum/GroJFlvy/OqFanHtxrUUSTvsI9E8M27N
         TByGA/BF7OrGpT/4xfadH6mDsaBVOqQJnWMvdlfwtqI3bwaehXqHQihHrKxfmB4wW1SV
         Vj4545QIFYgl3393+10HVm88sNn+2DwlX6jRxw6SdyXvqGCe6VuMf+qunmPmOlemlX1j
         VETn72COVYnOpbGYfD4q5n/vcnCdvep7XtH3bNaaqvX6AtNn8rZM+3YMMHqnzD/gwUXm
         tisJGXe0T/pAVQ/Qb0EK2mRmiocplXXt+SBTsZReo94obPoke06rofB4BUi702zvNQYJ
         dsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scnEoR+rGyXwnk7+XhNjguBgKH2xz3AYHqxz930H50g=;
        b=f7kkP6mtEH4/amZhr8/4sy1L4sZAUhRXAbYOTKp8dfTUU3ylAt9C4EhceGG4L/+6vR
         9z9hoS44lROr1S2l26d+yoFJOyQMQOXUTDaaSfIf/Imjv/Hmdqp64YAGj5PAUxYO30Mk
         JHFztEjoJVYNy7YFxm5Pa/QC6EZ9X2agvvXd+87w19oNTgF+von3LbsqytTHOYyNOMPY
         PG3jR3TRvz63k5Nc7LA0K0BUxab6qoXpHohFp+K+BGuCToAl9wU5akzS7+EGtf0Ez30D
         TNXRpNfWZOOgGQQFphJxHJrOVt5Nu5lnb/SKdt1HTdIAm3d1GeOUNwOHSVIaNpIBhyuk
         On/w==
X-Gm-Message-State: APjAAAUwAYHKC6uKVINzaLV1njDSDyuwYXPx94WZu04s1PZa4QdmO5Ok
        pRIEf3A2nl6iEzigROdNy+ie4A==
X-Google-Smtp-Source: APXvYqywuXE1sPf3ZVbmi/yqbjXdbPGAskWSsolHbLxZksHzi47OXzqWC5sMv7lEn+r7hypEB6sacw==
X-Received: by 2002:ac8:145:: with SMTP id f5mr3793275qtg.194.1581707648516;
        Fri, 14 Feb 2020 11:14:08 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u4sm3816823qkh.59.2020.02.14.11.14.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 11:14:07 -0800 (PST)
Message-ID: <1581707646.7365.72.camel@lca.pw>
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
From:   Qian Cai <cai@lca.pw>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 14 Feb 2020 14:14:06 -0500
In-Reply-To: <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
         <20200214165923.GA20690@linux.intel.com> <1581700124.7365.70.camel@lca.pw>
         <CALMp9eTRn-46oKg5a9h79EZOvHGwT=8ZZN15Zmy5NUYsd+r8wQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-02-14 at 09:40 -0800, Jim Mattson wrote:
> On Fri, Feb 14, 2020 at 9:08 AM Qian Cai <cai@lca.pw> wrote:
> > 
> > On Fri, 2020-02-14 at 08:59 -0800, Sean Christopherson wrote:
> > > On Fri, Feb 14, 2020 at 10:56:08AM -0500, Qian Cai wrote:
> > > > arch/x86/kvm/emulate.c: In function 'x86_emulate_insn':
> > > > arch/x86/kvm/emulate.c:5686:22: error: cast between incompatible
> > > > function types from 'int (*)(struct x86_emulate_ctxt *)' to 'void
> > > > (*)(struct fastop *)' [-Werror=cast-function-type]
> > > >     rc = fastop(ctxt, (fastop_t)ctxt->execute);
> > > > 
> > > > Fixes: 3009afc6e39e ("KVM: x86: Use a typedef for fastop functions")
> > > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > > ---
> > > >  arch/x86/kvm/emulate.c | 8 +++++---
> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > > index ddbc61984227..17ae820cf59d 100644
> > > > --- a/arch/x86/kvm/emulate.c
> > > > +++ b/arch/x86/kvm/emulate.c
> > > > @@ -5682,10 +5682,12 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
> > > >             ctxt->eflags &= ~X86_EFLAGS_RF;
> > > > 
> > > >     if (ctxt->execute) {
> > > > -           if (ctxt->d & Fastop)
> > > > -                   rc = fastop(ctxt, (fastop_t)ctxt->execute);
> > > 
> > > Alternatively, can we do -Wno-cast-function-type?  That's a silly warning
> > > IMO.
> > 
> > I am doing W=1 on linux-next where some of the warnings might be silly but the
> > recent commit changes all warnings to errors forces me having to silence those
> > somehow.
> > 
> > > 
> > > If not, will either of these work?
> > > 
> > >                       rc = fastop(ctxt, (void *)ctxt->execute);
> > > 
> > > or
> > >                       rc = fastop(ctxt, (fastop_t)(void *)ctxt->execute);
> > 
> > I have no strong preference. I originally thought just to go back the previous
> > code style where might be more acceptable, but it is up to maintainers.
> 
> It seems misguided to define a local variable just to get an implicit
> cast from (void *) to (fastop_t). Sean's first suggestion gives you
> the same implicit cast without the local variable. The second
> suggestion makes both casts explicit.

OK, I'll do a v2 using the first suggestion which looks simpler once it passed
compilations.
