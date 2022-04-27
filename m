Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813FB510F0C
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 04:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357309AbiD0DAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 23:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357302AbiD0DAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 23:00:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F7416E698
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 19:56:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a15so436520pfv.11
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 19:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yvjyzv+d2RYx84AGU+f8Qgb5Z5AEIzJBRa0zZaQL6P8=;
        b=jCPnHtoKm8g7mbup94ckl16T0R2qbP3Lzt1JMIL7mLKALfxpCjk691OoBHp90yEkdG
         uyNAhHWeqGd1M4GjcWCFjSg71B6RFukRLbJNYmGtWDhWXOM8ihs8n1dj4b2LY5U0xrnS
         o6ZUV+Ig063VrlpUNkybJl8mAyWIN8HnIeLTpYhozWJpDDgd2lfqDovBkGvm/LUSivcL
         opirRHygw9hYsMirg3JAMIWRikwU5TZ308ZptchlsaLSeYISk1gU4m8YFZTkPHBknQiT
         gGg8me8PQIzO/+sCEyzNZPeNDF31/s28sZK6b5ee9LLPMs7TNVj8ekdNGGvctvcQD+3W
         xUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yvjyzv+d2RYx84AGU+f8Qgb5Z5AEIzJBRa0zZaQL6P8=;
        b=5lif06VPSVA9Br8IdIVPqSphsFFW+OCt0E/zpDKwBXi7QpKWoN3kdnNNoNCI0MCI7Z
         mXqbbZntq61O3iDfc6rb+VABmAB0UZp5Ci7bpK95IEE3mHOnqTfc6xITcoIyuzLHB4ZI
         eeq/jrhzQTm07NdwjNtbCTe/ElyD2ABzNQ0QQ6BgAsKznMvjgMkmkp5CHc3adkAiFfk+
         OHaQhjunuL7ad9k9kV8YLwdfXQBUxMHMx9msMgSuypSmY05C6lp9duGxoqxod/4tCMxw
         xUubVaoXRYxpA1CCKIWwMTgIO81cR2RYXgx7CNrz1WMlqyInAisK8IvUEMjplQXW9u6E
         jRJw==
X-Gm-Message-State: AOAM531idpeNbvbZ7Nt8pLvmK9q7c27t8DSqqXOKtA73N8/PSJ8QHyEs
        Zht+tc2EfBsTrT6IbjIks+FQf69O+Tdx5lUD8uRQww==
X-Google-Smtp-Source: ABdhPJxjMQtgaZowpVzhPTfplAUMsciMKvA2x/OchoocOj74xMII/JAAJWINHNcc3E1AjGbVUHyB30xLa/zPu6vL0zk=
X-Received: by 2002:a63:6809:0:b0:3aa:93f5:c6f3 with SMTP id
 d9-20020a636809000000b003aa93f5c6f3mr22309806pgc.342.1651028210725; Tue, 26
 Apr 2022 19:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220327205803.739336-1-mizhang@google.com> <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com> <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
 <Ymg1lzsYAd6v/vGw@google.com> <CAL715WK8-cOJWK+iai=ygdOTzPb-QUvEwa607tVEkmGOu3gyQA@mail.gmail.com>
 <YmiZcZf9YXxMVcfx@google.com> <CAL715W+nMyF_f762Qif8ZsiOT8vgxXJ3Rm8EjgG8A=b7iM-cbg@mail.gmail.com>
 <YmiczBawg5s1z2DN@google.com>
In-Reply-To: <YmiczBawg5s1z2DN@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 26 Apr 2022 19:56:39 -0700
Message-ID: <CAL715W+iZ+uwctT80pcsBrHsF96zWZMAfeVgvWcvvboLz0MkaQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 6:30 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > On Tue, Apr 26, 2022 at 6:16 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Apr 26, 2022, Mingwei Zhang wrote:
> > > > > I completely agree that lookup_address() and friends are unnecessarily fragile,
> > > > > but I think that attempting to harden them to fix this KVM bug will open a can
> > > > > of worms and end up delaying getting KVM fixed.
> > > >
> > > > So basically, we need to:
> > > >  - choose perf_get_page_size() instead of using any of the
> > > > lookup_address*() in mm.
> > > >  - add a wrapper layer to adapt: 1) irq disabling/enabling and 2) size
> > > > -> level translation.
> > > >
> > > > Agree?
> > >
> > > Drat, I didn't see that it returns the page size, not the level.  That's a bit
> > > unfortunate.  It definitely makes me less averse to fixing lookup_address_in_pgd()
> > >
> > > Hrm.  I guess since we know there's at least one broken user, and in theory
> > > fixing lookup_address_in_pgd() should do no harm to users that don't need protection,
> > > it makes sense to just fix lookup_address_in_pgd() and see if the x86 maintainers
> > > push back.
> >
> > Yeah, fixing lookup_address_in_pgd() should be cleaner(), since the
> > page fault usage case does not need irq save/restore. But the other
> > one needs it. So, we can easily fix the function with READ_ONCE and
> > lockless staff. But wrapping the function with irq save/restore from
> > the KVM side.
>
> I think it makes sense to do the save/restore in lookup_address_in_pgd().  The
> Those helpers are exported, so odds are good there are broken users that will
> benefit from fixing all paths.

no, lookup_address_in_pgd() is probably just broken for KVM. In other
call sites, some may already disable IRQ, so doing that again inside
lookup_address_in_pgd() will be bad.

I am looking at here:
https://elixir.bootlin.com/linux/latest/source/arch/arm/kernel/traps.c#L304

so, the save/restore are done in oops_begin() and oops_end(), which is
wrapping show_fault_oops() that calls lookup_address_in_pgd().

So, I think we need to ensure the READ_ONCE.

hmm, regarding the lockless macros, Paolo is right, for x86 it makes
no difference. s390 seems to have a different implementation, but
kvm_mmu_max_mapping_level() as well as host_pfn_mapping_level are both
functions in x86 mmu.

Thanks.
-Mingwei
