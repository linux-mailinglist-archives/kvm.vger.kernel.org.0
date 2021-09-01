Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB93FD590
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbhIAIdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 04:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243305AbhIAId3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 04:33:29 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B72C0617A8;
        Wed,  1 Sep 2021 01:32:33 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id f6so1775902vsr.3;
        Wed, 01 Sep 2021 01:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFaRP1UuxDW13517plUbe9/HTiYDgl1rSw/uI2xnuSQ=;
        b=Ho0h4aSHFPPphMmh/O792jT0UZ8NNZWT06AwaQtrFbAmnbiANe+HfXvnI/lWBttOE/
         TcOJ9KwITAHc72l5fdYl6Vy+aaOubNtRrdpVlURKl+y/f3LgCRMyHeCJa6aPewcGREnn
         Ek32T6laGDEIZynkwBpj/TFzZhI6lRM4mmm5H4DU63L8SOBHIOcX5brGP3DWW1MhDSv2
         D0T3hVmh5yexkr5CjTeFCscQ8xqkEz7j5jftir2cggWKRtDYhjo9UogQFC38hPgmInwo
         rr3npkGB3GBnc00gXZE5/B4/xM6xQ+qufmihUCGuqA9s66p9AvYfliFvcklB7+BT1WQJ
         AKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFaRP1UuxDW13517plUbe9/HTiYDgl1rSw/uI2xnuSQ=;
        b=SpFxSPm3JGNQznrU01B+Kcimzf5X1eWS4nGOdt6Ycp7YmXjHdafWV51TlOv1U4AcDI
         ZL+XIeFOfbXfrwFL/qVS2k+dsfRSnIGSPT5qOTWk7+8GSX/FeorS8g0hXUkvyYWAv19+
         fTWHbwoswYnk0DPwvvmsWGfSnXp0yoZgOp1341wI0dvJcOCYV1ZNc10lR3NMp9GyNlNb
         F27ChEfGwudvY2RmRVYeoNzm/8O47MlXjVCVMMNmZJxcExP5V9CyJNHY6/RNU5Y6ni/l
         bNtHwSWUiExe5JS23CUIR21BdK25sWaFaPAOAt75SGbV9SPfUQNVW+c05Y7ITp47orky
         Vutw==
X-Gm-Message-State: AOAM532Us3aqB8eq4usytHomV0+qorCWNa9deIh29ROB8djr3NYYK4SK
        nqjpR74iV/ePSyq2fEpcvgUlRVMZUeY3QFZDhpuN93jB
X-Google-Smtp-Source: ABdhPJyDxdr+N40boXPr0S5B9FteKVAqABWhVzBiTLCaQwkAAxJbRuxq87t/RCNfPEoZKY/UPSCPmWFYSmqu9MjRcLg=
X-Received: by 2002:a67:8c07:: with SMTP id o7mr20790890vsd.31.1630485152463;
 Wed, 01 Sep 2021 01:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210406024911.2008046-1-chenhuacai@loongson.cn> <e55e632d-a138-a6ec-d545-299ab858a163@redhat.com>
In-Reply-To: <e55e632d-a138-a6ec-d545-299ab858a163@redhat.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Wed, 1 Sep 2021 16:32:20 +0800
Message-ID: <CAAhV-H6Bff1063FsoWOPCf-EGeiTPK1QL9NwYraA0=39z1uKrQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS: Remove a "set but not used" variable
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Fri, May 14, 2021 at 5:58 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/04/21 04:49, Huacai Chen wrote:
> > This fix a build warning:
> >
> >     arch/mips/kvm/vz.c: In function '_kvm_vz_restore_htimer':
> >>> arch/mips/kvm/vz.c:392:10: warning: variable 'freeze_time' set but not used [-Wunused-but-set-variable]
> >       392 |  ktime_t freeze_time;
> >           |          ^~~~~~~~~~~
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >   arch/mips/kvm/vz.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > index d0d03bddbbba..e81dfdf7309e 100644
> > --- a/arch/mips/kvm/vz.c
> > +++ b/arch/mips/kvm/vz.c
> > @@ -388,7 +388,6 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
> >                                  u32 compare, u32 cause)
> >   {
> >       u32 start_count, after_count;
> > -     ktime_t freeze_time;
> >       unsigned long flags;
> >
> >       /*
> > @@ -396,7 +395,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
> >        * this with interrupts disabled to avoid latency.
> >        */
> >       local_irq_save(flags);
> > -     freeze_time = kvm_mips_freeze_hrtimer(vcpu, &start_count);
> > +     kvm_mips_freeze_hrtimer(vcpu, &start_count);
> >       write_c0_gtoffset(start_count - read_c0_count());
> >       local_irq_restore(flags);
> >
> >
>
> Queued, thanks.
LKP reminds me again and again :)

Huacai
>
> Paolo
>
