Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E390356ABC
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 13:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347193AbhDGLCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 07:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbhDGLCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 07:02:05 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D959C061756
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 04:01:55 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so17620384ote.6
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 04:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=za16kTG1cVGjMQbsKKT5zr6PyamPPMULoUa4ewYf/WA=;
        b=WjBDyd/4lguKJH2X+BNdfyWBLsK9hy6P4h/Tt7J0SZliOb/024sh1+ENobxY+/Odwh
         /Lk4m1xFkNfFYCTLGQURv0xuI2hjzX40yg5GrYASEvq8Uqab98l/NQaXwfLde9bD2RQT
         6iwU6MyBrikYCZjsh0jOu1nu4iWRMp68KZ2btnyvuKcHqeedo9DUxPk9B5tZlCQFaV5u
         S0Y/4gBa7NcwHP1tLQilvpa4pHXMMbC4PgP1VTjjaH8wdgUZrUKqsqbD0kiSwo1Wsi5G
         ygvM4n1gywPl5VMN4DVM6KsMwM1VUUf3DmfObkuHYrHSL5aIM03v8D2KrrIh4YmjHmUZ
         kCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=za16kTG1cVGjMQbsKKT5zr6PyamPPMULoUa4ewYf/WA=;
        b=g0ED+2/hpn20+37G8j5G0rDef8apIpfZ6KMFcEMzZliemM3jWv0giNUar2spOEabTj
         e56XowcAOptppQpMBkY/C95E/szUWSSw1dmm91yeP3E9RLxf5YMGqqJcGqvTRJzO9Nsr
         sKaY8hYT+OIlcLmP4209j7C8kcubVzwKwDmIl+t1Tiw4YykKFmvjDoibkiMAUTFnCF5a
         /XPfbRlb1iZnUekYy+D11yW14AKZMSORZLOd3yyFnJW8zF16DXKWoXbTdiij5DEXC3gn
         VQyUtuo2uOgpWnEfl5fI78NFsuG+TABhFhIxrMhC+DGax7ZIrw3l/yRcGTM5wVcGZVnB
         HcsA==
X-Gm-Message-State: AOAM5323dZ5wcUcnrOdtjHJOxwlP3/mx9ro8DHgYVX9Zd02fSGK1Iwrh
        IrS+7+PHuoR0RcTC84XHEUzoyPh00v1UoQbeHgA=
X-Google-Smtp-Source: ABdhPJx/DhF9inZq1zuvLn8Ya8I1W+rN/Gz4wclBP73yCJTIou0M8QZIK0Yw84E71ASVqXZPhPdaR0XEyN1OOmflb0c=
X-Received: by 2002:a9d:6b13:: with SMTP id g19mr2441704otp.185.1617793314695;
 Wed, 07 Apr 2021 04:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
In-Reply-To: <36088364-0b3d-d492-0aa4-59ea8f1d1632@msgid.tls.msk.ru>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 7 Apr 2021 19:01:42 +0800
Message-ID: <CANRm+CySNYUZ_8eq_6SRiUB4q4W0QU8EkW1RAM+jtMZ26-PUEw@mail.gmail.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke
 guest time accounting
To:     mjt@tls.msk.ru
Cc:     kvm <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 at 18:55, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> Hi!
>
> It looks like this commit:
>
> commit 87fa7f3e98a1310ef1ac1900e7ee7f9610a038bc
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jul 8 21:51:54 2020 +0200
>
>      x86/kvm: Move context tracking where it belongs
>
>      Context tracking for KVM happens way too early in the vcpu_run()
>      code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
>      cannot use RCU and should also be not instrumented.
>
>      The current way of doing this covers way too much code. Move it closer to
>      the actual vmenter/exit code.
>
> broke kvm guest cpu time accounting - after this commit, when running
> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
> elsewhere) is always 0.
>
> I dunno why it happened, but it happened, and all kernels after 5.9
> are affected by this.
>
> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.

Thanks for the report. I have a patch here which can fix it.
https://lore.kernel.org/kvm/1617011036-11734-1-git-send-email-wanpengli@tencent.com/

    Wanpeng
