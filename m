Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241FF6920D9
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbjBJObe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBJObd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:31:33 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F6F19685
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:31:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d8so5425852plr.10
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1676039492;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l+Fl/ea9k4MWezTUZ0x9WnUvEIS2Kl3SMNRJmE8axVU=;
        b=PAdZ9YqKptzI8J2c/ZeiNQnUObZz0ALIlrYoAcMCDQBUNrPjvyE8gx+PowaunyE+1h
         IhN97L6BEDaJSNNucpgO/d/wawN9iCl9qbmgq2bZsCAyL8xbf6F0wC4MxAcsDgcJdOlb
         pgA1pHEjHqiHHcTEOGAm/PDpeXZCykdfzIczmfxQbClyhkxX/cRDCmsPUtHGSv0d/tGp
         yz4+bKOIwb+UqxUbu+VJHBQkxyzRCXUEiz96+56zuDr35CqFkp/8t+XMB05Z3tTy33ri
         ZF3orLqWH09NwujoYVDJDa301ZWHzDwhjAE1PimwHEKmODPOrZz3St8xG5lNv3pCVkbi
         Ddgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676039492;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+Fl/ea9k4MWezTUZ0x9WnUvEIS2Kl3SMNRJmE8axVU=;
        b=XauvY8jn+KC8ky0+hqTru1Hvd6Apd+t/G3FJnWlVrfMhgjj3ShYPllVpx/fZWoCYEI
         ygzFDr4F1Q/BAl8fD/Y50M25+WDAq3SRqbMdXJ7FoISfko4qABWFogFIWO8sW9/YF7mH
         XDdrMHQFhQ/3CxU3JOGKKSucL1MY5PHY90KEINJLB7G0GWxg1yOYi9i6o9NJIcm5S5yZ
         CsXp58rJnK1XBOFsRxgtK4Db+jHX2wszQE21ksbWLhdudOyxoIiyWGq/jH9i4px2rcFY
         NmIoAec6cRY/5rXxuK8OsCE4CnFr+WIhChILDeEaD1P5YoeDqK/MqMGi7fpm4QGfJLkc
         62Zw==
X-Gm-Message-State: AO0yUKVsoLeKaiUoKpYnXNNEhP2tlNoFsUawODr4bIooBNVfWtaf3S26
        646TpFosfMJ6FK+UVIWd3b9FYk1pAgh9DnyphkIGmw==
X-Google-Smtp-Source: AK7set9xWHNc5kH6eusn88GsCvBUTVNlmU8X2oBVvokr6b8aMES545MC5WwCpRyUQES38Cx/tATSpTnjI3OYuKITVy4=
X-Received: by 2002:a17:902:ea0e:b0:196:64bf:ed7a with SMTP id
 s14-20020a170902ea0e00b0019664bfed7amr3669726plg.29.1676039492491; Fri, 10
 Feb 2023 06:31:32 -0800 (PST)
MIME-Version: 1.0
References: <20230210135136.1115213-1-rkanwal@rivosinc.com> <CAK9=C2VzZZLqOd_4gok5QMwmwz9NKYyVmDCzmCA7spohbq_zXg@mail.gmail.com>
In-Reply-To: <CAK9=C2VzZZLqOd_4gok5QMwmwz9NKYyVmDCzmCA7spohbq_zXg@mail.gmail.com>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Fri, 10 Feb 2023 14:31:21 +0000
Message-ID: <CAECbVCts9EH2jBi0Mj2d+yucSSZ+ipB6ozbPkr-M2svNpRcCHA@mail.gmail.com>
Subject: Re: [PATCH 1/1] riscv/kvm: Fix VM hang in case of timer delta being zero.
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 2:07 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> On Fri, Feb 10, 2023 at 7:21 PM Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
> >
> > In case when VCPU is blocked due to WFI, we schedule the timer
> > from `kvm_riscv_vcpu_timer_blocking()` to keep timer interrupt
> > ticking.
> >
> > But in case when delta_ns comes to be zero, we never schedule
> > the timer and VCPU keeps sleeping indefinitely until any activity
> > is done with VM console.
> >
> > This is easily reproduce-able using kvmtool.
> > ./lkvm-static run -c1 --console virtio -p "earlycon root=/dev/vda" \
> >          -k ./Image -d rootfs.ext4
> >
> > Also, just add a print in kvm_riscv_vcpu_vstimer_expired() to
> > check the interrupt delivery and run `top` or similar auto-upating
> > cmd from guest. Within sometime one can notice that print from
> > timer expiry routine stops and the `top` cmd output will stop
> > updating.
> >
> > This change fixes this by making sure we schedule the timer even
> > with delta_ns being zero to bring the VCPU out of sleep immediately.
> >
>
> Please add the Fixes tag here.

Fixed in v2.
https://lore.kernel.org/all/20230210142711.1177212-1-rkanwal@rivosinc.com/T/#t

Thanks
Rajnesh
>
> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > ---
> >  arch/riscv/kvm/vcpu_timer.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> > index ad34519c8a13..3ac2ff6a65da 100644
> > --- a/arch/riscv/kvm/vcpu_timer.c
> > +++ b/arch/riscv/kvm/vcpu_timer.c
> > @@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
> >                 return;
> >
> >         delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> > -       if (delta_ns) {
> > -               hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> > -               t->next_set = true;
> > -       }
> > +       hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> > +       t->next_set = true;
> >  }
> >
> >  static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> > --
> > 2.25.1
> >
