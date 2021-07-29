Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF23DAB91
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhG2TCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 15:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhG2TCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 15:02:54 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA2EC0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:02:50 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g76so11914034ybf.4
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YqZsxUCzv1nae23QeEhOZX1NZ5hWxTmCpAqwWTcBvgs=;
        b=g/a5YHYCKtRO0EJwzsoCB8TFISeJeQcBFKHob0LIZOeKkVIFXHcR7jJ0xYtaq14RYT
         CRU+twyymtgjt2xdKhkI8AySQBUkukb5oMzrVNnfgPMXqbDm2ZXJVFZFqm52wn3762Qe
         3XfD2as2/lEU3ruovPckflst5UmcV/DZxHmjaRcJnhkOxQH6Xg0JlRYX/pHz0c1S2E67
         8oj1DOIUIVjFI1O03MX9qXBUPM1GtyV+sXced/UOf1Pdu5pTT1eTAsRRCrP+8iIhoEmo
         W0YExJMNzqRZ0eh3GPSTi6g3VlyV831ucFL37jWfhpQkiTywgtGDRb7w7Lg8Sn5vM2Z7
         4znw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YqZsxUCzv1nae23QeEhOZX1NZ5hWxTmCpAqwWTcBvgs=;
        b=qXwmwhCCZOcaV7Nl0mrgkts2YnSfOK7EisyKCPcMGXoGGkE8XkGFsn4QkJZCiL1sWD
         fwapNYibwohsLPypnvFRCYjOJvKibOUmzzCPJ0ji91kbfx0lbuwZ9wFqF3mF3QG6F5NB
         Uh3uXKdpqdUZmY/xBfh1p6wazXs4j3PpX4g4vbBAj/AObUwbcVgCsNshKnp7m6eheuVC
         tZZDuRil4/1Bd1Kr+rpwC3gW1mmiN2LXs6DIaHacjbb+pIjQx8HjqSuuzVJ+peO3h78j
         qMA+qAXQKLv0lNIydN8tab6xmfIA0jrPu/MYkVFEVaVFifE040Efs2zCUkMjmGisOSQp
         hFQQ==
X-Gm-Message-State: AOAM5316b0pGtNka7tf/qw0fyTxX/tjKP3bM2l8weDV2qbPj55TsVqVC
        nJbE3oG+uHNt3+zYM2purWVqgSZMeRluYnILCdAs4A==
X-Google-Smtp-Source: ABdhPJwjjVyNU+LfXMuVPt0kIZo+lRNNrJ1hsEXIpHqMj7h9FlWDDwDsr4qd7Jzn1InFYTm54LpS8hXbQFesmt8FM8M=
X-Received: by 2002:a25:f503:: with SMTP id a3mr7922680ybe.501.1627585369133;
 Thu, 29 Jul 2021 12:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210726175357.1572951-1-mizhang@google.com> <20210726175357.1572951-4-mizhang@google.com>
 <CANgfPd8iohgpauQEEAFAQjLPXqHQw1Swguc7C0exHcz985igcw@mail.gmail.com> <YQL3SlI5XGVxqlvB@google.com>
In-Reply-To: <YQL3SlI5XGVxqlvB@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 29 Jul 2021 12:02:38 -0700
Message-ID: <CAL715WJMnMaFZ8XmsXWNEEHft0JsKi+MUqLARTf+C7D5s3kEKw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 11:45 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 26, 2021, Ben Gardon wrote:
> > On Mon, Jul 26, 2021 at 10:54 AM Mingwei Zhang <mizhang@google.com> wrote:
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 83e6c6965f1e..ad5638815311 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -240,4 +240,6 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> > >         return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
> > >  }
> > >
> > > +void kvm_update_page_stats(struct kvm *kvm, int level, int count);
> > > +
> > >  #endif
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 442cc554ebd6..7e0fc760739b 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -588,16 +588,22 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> > >         return flush;
> > >  }
> > >
> > > +void kvm_update_page_stats(struct kvm *kvm, int level, int count)
> > > +{
> > > +       atomic64_add(count, &kvm->stat.page_stats.pages[level - 1]);
> > > +}
>
> This can be static inline in the header.  Ignoring prolog+RET, it's four instructions,
> and two of those are sign extending input params.

will do.It is really nice to see that this big function has been
finally shrinked to a single-line routine.
