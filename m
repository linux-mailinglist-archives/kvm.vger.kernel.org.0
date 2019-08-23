Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF49AE0E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbfHWLZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:25:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39424 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387487AbfHWLZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:25:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so8743784wmg.4
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 04:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2op3y+Z3X9zLwGWh5yuPCvqGBI0kNPuqyjux0dDAk8w=;
        b=aXeXefReU5hfFqxXgBXsV18a8odcYZXiwtAX5xokTAFEUr8r7Lhl2b/S7YxXNi6r8p
         n6FaMzY3lRdWRdBYqzfE7s4dbycNU98P8HZEgR1PHig9lMZFRcat/YCPkdx10UjouI8s
         9xp6M1+9utA+35p2ezpNZMVjSe6v/haZnkoLjx8j+l08IPugdvYR2mAQ5LUodYmA13ly
         6p7z/nFxYGz5m3gbMXZiXMrDWmsGAy9gLrkt92WWuGjsypHaUfv56sNObKze+U88M+Vw
         fHGrSDzchUBtV7QgvNBWcX+LZCJTZUUZ8nlM6BT8hSmOKA/dTouDxvJ+7Mh8/oeavyIE
         yMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2op3y+Z3X9zLwGWh5yuPCvqGBI0kNPuqyjux0dDAk8w=;
        b=fjmWPNNtS2BN3sRWUL8pHZMMoaPhIPvJn/O4pY2pp0XBoLS3esTHIpTU3/wWzlIq91
         SMBSza4LlRt+Z+msOsaAr3EEnnUy3wNatLYvIbVHhalJMbYKECDtaRspjSy9W7eWgKhD
         e8AqOtbaYHX0CTVoABikwI8Q+Gwj29r3botO6xjy/AR2oQkpP6P8ry4fz+N6soZsTIVh
         yyaBkk5jJvUm5kYSU4LkCoyl+ho6YFiT8D2SE7e2+p7vVcx0QUinjBg6xIX6ZZ88KK+f
         lmZnCKB+2lTWJNqHCKS/ZDHvSI1nk/iyN4YXZJYR/CYYBslb9PTWBweRGC+RZbCOg9es
         V36w==
X-Gm-Message-State: APjAAAXItQYE5mkCMI3lPwG6GVimU3KBFl4cdbhdbu3dP7v5gWiCIxpB
        jh3ucl9960KSw339pL2Gn483V0rDCPTqOokodJixPw==
X-Google-Smtp-Source: APXvYqycI41rK57NbAfGj4CZHgSbW6grDpjvAoH0BFDYwOsJIrsS4OcpuzhTo+8XrddhShRkR73OeGttOUX30LY+zAU=
X-Received: by 2002:a1c:9d53:: with SMTP id g80mr4648907wme.103.1566559546115;
 Fri, 23 Aug 2019 04:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
In-Reply-To: <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 16:55:34 +0530
Message-ID: <CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Aug 23, 2019 at 1:39 PM Alexander Graf <graf@amazon.com> wrote:
>
> On 22.08.19 10:42, Anup Patel wrote:
> > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > RISC-V 64bit Linux Guests with multiple VCPUs.
> >
> > Few key aspects of KVM RISC-V added by this series are:
> > 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
> > 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
> > 3. KVM ONE_REG interface for VCPU register access from user-space.
> > 4. PLIC emulation is done in user-space. In-kernel PLIC emulation, will
> >     be added in future.
> > 5. Timer and IPI emuation is done in-kernel.
> > 6. MMU notifiers supported.
> > 7. FP lazy save/restore supported.
> > 8. SBI v0.1 emulation for KVM Guest available.
> >
> > Here's a brief TODO list which we will work upon after this series:
> > 1. Handle trap from unpriv access in reading Guest instruction
> > 2. Handle trap from unpriv access in SBI v0.1 emulation
> > 3. Implement recursive stage2 page table programing
> > 4. SBI v0.2 emulation in-kernel
> > 5. SBI v0.2 hart hotplug emulation in-kernel
> > 6. In-kernel PLIC emulation
> > 7. ..... and more .....
>
> Please consider patches I did not comment on as
>
> Reviewed-by: Alexander Graf <graf@amazon.com>
>
> Overall, I'm quite happy with the code. It's a very clean implementation
> of a KVM target.

Thanks Alex.

>
> The only major nit I have is the guest address space read: I don't think
> we should pull in code that we know allows user space to DOS the kernel.
> For that, we need to find an alternative. Either you implement a
> software page table walker and resolve VAs manually or you find a way to
> ensure that *any* exception taken during the read does not affect
> general code execution.

I will send v6 next week. I will try my best to implement unpriv trap
handling in v6 itself.

Regards,
Anup

>
>
> Thanks,
>
> Alex
