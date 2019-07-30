Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBFE7A7E5
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 14:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfG3MOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 08:14:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33264 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfG3MOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 08:14:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so45183196wme.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 05:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nif3qHLVmcvrPjGpxqbZt9/vydbdek0IMR2qJ1UdOfY=;
        b=rYNoj1tSzf0sttrAZdSs0XsVpgLJYwh2JBmIkgCKdff9t45iEMVp+2cHfJrM/VHequ
         RbRBhTt/0cXeZKmlYao/z751WpX18xessLddOkzDYTEFnAWXW6Yxse55jAyRcZnxY/tt
         rJ5tpyDfKCTA8aqaFnZfcwrpxIrSm+Ws2Mu80jZqcAg2UyfC++kD+iiZAtQYDHUbB3uQ
         Gxn2RTDO3tb9g6OZrrmou3hHxY7gQYhQgSlZViGnC0PN2i7eyno/QKb0uL0z0R5MwRAy
         2bfe9WjPvpOblgbSgsYrp++rsj4vBiJAyu8Xblwumon2NV+xuhsRExoLICKISZhnynUl
         uy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nif3qHLVmcvrPjGpxqbZt9/vydbdek0IMR2qJ1UdOfY=;
        b=ZBNLp66JNd7CDvIqcH8zdT/IBsSrU0vmuB3MkmNy+uxUHuDF13NUuut5DAB82/3Rjh
         YnLyhmOr0X7qxlY6eWSiAJpRiBB1bpMStozEdnhtL7knYpjWCtv2zeMvy3bOU33k8Ki5
         +UQsmZrPeYwYNerczLcIM6Cu35x10BDhuZfmY5gCfqXCUhhcGWKDAxQFlqvUcwkFlyKE
         /R7U6nzr3V8iGeBLP/be0VjfJa2YlEuAIRntKUVcsGqPD+HuyN+jZP5uDpJcb4376HXh
         XiL/v4xSi2UDIOSQRSCl/lMRcIosplw/4Wpqi78Wo1tkpA6zXn1/Qz6bh+zygCyFigGY
         6p/A==
X-Gm-Message-State: APjAAAU+9WbcmQOzwoYRTtlq4WTy7ky7I9Sgc5FZZ5+tYtzh2HHUZ5eh
        +EaPEXFxAk5M5JpJZo1jm7QJoRd8/dKxPUclXkY=
X-Google-Smtp-Source: APXvYqxBKE8FkPVrEqaGT/BokRytjmgYIEjMXXYbPz3pe96ONQT3DpM8Y+BsFeCrC+LD4o8MLveCcLyT0fkIChqWiqA=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr97987106wma.171.1564488855824;
 Tue, 30 Jul 2019 05:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-12-anup.patel@wdc.com>
 <6ebde80e-e8a9-6b7b-52ea-656b9a9e5e5b@redhat.com>
In-Reply-To: <6ebde80e-e8a9-6b7b-52ea-656b9a9e5e5b@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 30 Jul 2019 17:44:03 +0530
Message-ID: <CAAhSdy09Uhkg=-m213SeR92M1PRx1ZtE-fTLT=nNvg_0HY2YnA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/16] RISC-V: KVM: Implement stage2 page table programming
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 2:30 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/07/19 13:57, Anup Patel wrote:
> > This patch implements all required functions for programming
> > the stage2 page table for each Guest/VM.
> >
> > At high-level, the flow of stage2 related functions is similar
> > from KVM ARM/ARM64 implementation but the stage2 page table
> > format is quite different for KVM RISC-V.
>
> FWIW I very much prefer KVM x86's recursive implementation of the MMU to
> the hardcoding of pgd/pmd/pte.  I am not asking you to rewrite it, but
> I'll mention it because I noticed that you do not support 48-bit guest
> physical addresses.

Yes, I also prefer recursive page table programming. In fact, the first
hypervisor we ported for RISC-V was Xvisor and over there have
recursive page table programming for both stage1 and stage2.

BTW, 48bit VA and guest physical address is already defined in
latest RISC-V spec. It's just that there is not HW (or QEMU) implementation
as of now for 4-level page table.

I will certainly add this to our TODO list.

Regards,
Anup
