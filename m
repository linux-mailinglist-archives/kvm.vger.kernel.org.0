Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7E2403D8
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 11:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHJJJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 05:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgHJJJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 05:09:26 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A6FC061756;
        Mon, 10 Aug 2020 02:09:26 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k4so8277384oik.2;
        Mon, 10 Aug 2020 02:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ZxKqwz9lSZTNdM2JRyLmnn11T86+ZQVjo9KIOGVrW4=;
        b=eGgTbNUubrz/u1OgSKbdEfsjnghjDcxJZk0fj4J3j12p6Zx9zpUoyQKXdeAWpAZDEc
         cBDLcDjgyf4U1xRh2+1Bwqv8PWULp8GObJ6AMcCbZbXf0cM83BtqPnMbg17YRq3lGo0S
         w2Ak9UqbwCoQwVUsSzUlWaNcScDVbAwRgY9YbswxyOLqvIBTl0Vo6EJgcRO3KbX0xLgI
         ROCYhUiDMmw3AL6a6gu2BtqpudvPdFTKcZdDCcVd2gIhCZfoRMxwO8suEcACaMyaHFW6
         kJZ2+5XuFBSM3E+iu48kiaO1S9fsswNJJSC4M9K7nw/rHabYR2eqgBNdJodnc7BZCITM
         10yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ZxKqwz9lSZTNdM2JRyLmnn11T86+ZQVjo9KIOGVrW4=;
        b=Xxg6hpPOOr0PIQawBBAmVfu50jDMIXvGYoiRiSH9bSygOLsa0OP6L12RJp6mRxQk7K
         Lkbsfgb8vvlASIHldNQX7tUXZKQuC7vsceKFJA2Uft4qgGtEWPWVZKpHQiQxaNb0a/8c
         OyWseqfwap6LuYER9hzmzt9jzBnbaxrSbKqPyhUI5AQL2claa1A3VI8raU0lVq8ZHCgr
         XuZLXSUvyAVF/X+IYGS5+z20yJvJSa6sCiCJF/y3KsAzZy0+PHItCR3+IXL90blAXO5B
         /ra3TwycR2Nk1yWfxikiZ0O7IV7h4OH7kgdOIt/wcwaEu0OLj97uJAxYLfChMT9sfbxa
         w1Bw==
X-Gm-Message-State: AOAM530KdheUXm7rPvy60epJnIjjxWqhFJz6o7vFlagVYscbIYAvWrTx
        qbl62VQnplhYD4yL///XePFPbHl7fpWF5IqZ0ZE=
X-Google-Smtp-Source: ABdhPJwfhjPB+jeMEcc887Gg1iNHtrWt6npYussAD28jb9UDfIo8XUrJcs4DK8UKQPtVyMqBL+ASS7uym4zCva59C24=
X-Received: by 2002:aca:4f52:: with SMTP id d79mr25847oib.141.1597050565914;
 Mon, 10 Aug 2020 02:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <1596521448-4010-1-git-send-email-wanpengli@tencent.com> <20200804211914.GB31916@linux.intel.com>
In-Reply-To: <20200804211914.GB31916@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 Aug 2020 17:09:15 +0800
Message-ID: <CANRm+CzfLYKUkdWOsFdXL+M1ZFcn_pGPzKuOXAEabEySatcFkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Return 0 when getting the tscdeadline
 timer if the lapic is hw disabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Aug 2020 at 05:19, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Aug 04, 2020 at 02:10:47PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Return 0 when getting the tscdeadline timer if the lapic is hw disabled
> >
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index cfb8504..d89ab48 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2182,7 +2182,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_lapic *apic = vcpu->arch.apic;
> >
> > -     if (!lapic_in_kernel(vcpu) ||
> > +     if (!kvm_apic_present(vcpu) ||
> >               !apic_lvtt_tscdeadline(apic))
>
> Paolo, want want to fix up the indentation when applying?
>
>         if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic)

Agreed, Paolo do you need I send another version or you can fix up
when applying?

    Wanpeng
