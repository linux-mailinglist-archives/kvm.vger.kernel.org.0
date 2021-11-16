Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31D45337C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbhKPOFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbhKPOE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:04:59 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F79CC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 06:02:02 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so2478075wme.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 06:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJGGjf3T+PZQTjojKZjYUj8YP2BjQYLRmzoH80vh2D4=;
        b=HGu9J9unVEfaFzrS1inJxtPCHbq+4e7eG5GGS70QWjR2etpwCAYB+f+ciwX9R4GY5w
         HtPMoGdHvirMix0SV2Y5OuosDTtzuQTNm1W9qOUtM4xVGWRh1guUaf0FvxC+Cr7vZwbX
         Mwzy2bPjgIuxg+UApKvdQZ0ad3Hfrk16sXb67CKMEQxf7vKMTXK1xoPsNuRmZoRA8ni4
         U+VFSSWEfTLtUzmb6/ZyJlRefUTbOnqxUJEshlul5IMTHGa4MVQ6BkOWd4f1m1DqKo4y
         BXR4A8VDq+RkbGncMzLzTjA3LpMjBI8HFjvyvg78asjnHekNZeQpdpz6sDMw5KDt+F6N
         5Arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJGGjf3T+PZQTjojKZjYUj8YP2BjQYLRmzoH80vh2D4=;
        b=W/JY1GjALOwd4w9FYUS8ZYo/YUwRWx0n3gcSo/s4UXAKR6qlRQUhtCUTKJG9m/Bnll
         4kGFzSFR0GfyE5LXG8YRl40wlBAJkYAKelyBjoBxgJAqR3a4LUF/+2vh/VqF/t2HBvd+
         NHu79+ClHC4YRqzl9PDuDAmCeN7wqs4/OOc/im40NiT7XKrh450bVNeZeyzu/xNo8Me0
         WdQ6fz4Knwp8U9mHC0WWsoUonXDzlXezIGU6q5tInjYM7k60PIlo+bpPQN/Kl/dAMVzj
         1zsr9OY6I9sfMWcixEItn7nG5WQzWbuJd1+68b3hsGbHLTNU8SV9Y5nYTMukprMq6fnS
         rzQg==
X-Gm-Message-State: AOAM533T+yuEQFkYxVVc8SSCO8sqWz6km74wFeDVfxoRLRRwY+amDS4M
        4z7B7bB4KfshlfM06XN9yqqfeoXoHuZSJFwr05is9g==
X-Google-Smtp-Source: ABdhPJwXP7n5uxNvnq5f4cCWx2AEFTHhYlXt1jDKuL8pqxOWNU2kElA9mxGgQrMUZUrxev9XFvBmrQNsueDq+5IDYp4=
X-Received: by 2002:a1c:20cc:: with SMTP id g195mr8125788wmg.137.1637071320789;
 Tue, 16 Nov 2021 06:02:00 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637064577.git.mchehab+huawei@kernel.org>
 <32b3693314f3914f10a42dea97ad6e06292fcd4a.1637064577.git.mchehab+huawei@kernel.org>
 <34e691ec-a58d-c86b-a2ef-6fa4f0385b69@redhat.com>
In-Reply-To: <34e691ec-a58d-c86b-a2ef-6fa4f0385b69@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 16 Nov 2021 19:31:48 +0530
Message-ID: <CAAhSdy0JRTwmr+EdSEr3ng1gfDpqnF7m3ejC2AydjAgu0mEQLw@mail.gmail.com>
Subject: Re: [PATCH 3/4] Documentation: update vcpu-requests.rst reference
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 6:24 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/16/21 13:11, Mauro Carvalho Chehab wrote:
> > Changeset 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> > renamed: Documentation/virtual/kvm/vcpu-requests.rst
> > to: Documentation/virt/kvm/vcpu-requests.rst.
> >
> > Update its cross-reference accordingly.
> >
> > Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to Documentation/virt")
> > Reviewed-by: Anup Patel <anup.patel@wdc.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >
> > To mailbombing on a large number of people, only mailing lists were C/C on the cover.
> > See [PATCH 0/4] at: https://lore.kernel.org/all/cover.1637064577.git.mchehab+huawei@kernel.org/
> >
> >   arch/riscv/kvm/vcpu.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index e3d3aed46184..fb84619df012 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -740,7 +740,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                * Ensure we set mode to IN_GUEST_MODE after we disable
> >                * interrupts and before the final VCPU requests check.
> >                * See the comment in kvm_vcpu_exiting_guest_mode() and
> > -              * Documentation/virtual/kvm/vcpu-requests.rst
> > +              * Documentation/virt/kvm/vcpu-requests.rst
> >                */
> >               vcpu->mode = IN_GUEST_MODE;
> >
> >
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Paolo, let me know if you want me to include this patch
as part of the fixes I have collected.

Regards,
Anup

>
> Thanks,
>
> Paolo
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
