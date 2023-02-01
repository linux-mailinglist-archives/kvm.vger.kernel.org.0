Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1B0686C63
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjBARE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBAREt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:04:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF5813D77
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 09:04:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso4022503pju.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 09:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=792s+znQHM2oG4qpFrjQTGcnLGLqWihN5oBXvyffoK4=;
        b=DY78J8RZJLcNWlktNuiYiNnJwXbCzltKAXPGRNR21N9g6+BZ31GUH8YTPWTrH5pvex
         cCdwH9jbh40dy77HJAuhhaPYjC1cNyYYqmctwfCD1PeoYyPhy3lrqoSo1qVMM/sus1i8
         9jbV/AAMO84BJV1fi7L5NVbJ9Rqp9mAp3nOxmUEUJW3w6vZP/zA7dTLWkVtNr8Mxhuie
         JTALGl/bR0FmX+sp3RGn1wMXCOJTEJBSC+I2rhcnFgF6FT85MRE3lUv1WPZOt7np9hpq
         P+cNso/Q1nnNr9VzH6pokEI5EB1MW0p5G6Ripm+SoE33ch1H4F67VeHHDfjT+eaG3X2X
         mOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=792s+znQHM2oG4qpFrjQTGcnLGLqWihN5oBXvyffoK4=;
        b=IUw6HsGUN/yRwnU7+NcDDZP+ffRZ2FjfmIS1yGDG1CSrJHtM0DdRUGEg0zceDA1XID
         W5/iT5T56na8jzNGMRLmgtfLKUKP4ms4AdiT9nTuEGLRJC7iGtlm7UGj7ZBsgUO9NU9W
         fEElR10uRXDoXzXAa8aJrS/gNnDnYyKwEpADN3E5rcD6VuEJj0qmNizlkXjt8WbXmvam
         2LcgsE+MCTRxaQWCr45Z35YF6yixrkglYRufjyXlS8WkkgeGN/u11SlDvKXvQUsDR5cI
         VpFaXw1ZhN4vOyqtF1Dt/9AJVznc4rt30opmcgK8VuXEz7EaR6PtT4TiD1qBV1mETxhB
         U+hg==
X-Gm-Message-State: AO0yUKW5r+qkSPTSfLviY+fBDpl9Q0p5F+BbMBM8zhige8hFbsQQ48eJ
        JuZpVPPFTL6tM9XIg9+o1oLhgLgP+0BrOg0Iuv92o+N/DWvzXg==
X-Google-Smtp-Source: AK7set+7Dgk7WLDE5ihiSjFDeKB3B5nUdTjqkHxnm7WrM9H5BgNEP4ANZ1Hb+3mB8FS9z60pCKRzqDpKnGeUZ28W8Jk=
X-Received: by 2002:a17:90a:1c4:b0:229:f43b:507c with SMTP id
 4-20020a17090a01c400b00229f43b507cmr561778pjd.127.1675271087532; Wed, 01 Feb
 2023 09:04:47 -0800 (PST)
MIME-Version: 1.0
References: <20230201160137.486622-1-rkanwal@rivosinc.com> <20230201163509.7fb82d7e@donnerap.cambridge.arm.com>
In-Reply-To: <20230201163509.7fb82d7e@donnerap.cambridge.arm.com>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Wed, 1 Feb 2023 17:04:36 +0000
Message-ID: <CAECbVCvkKBbeKUNCvjZ4hhQb5njAgSKaY6nSPxu0N993qAaQ+A@mail.gmail.com>
Subject: Re: [PATCH v2 kvmtool] riscv: Move serial and rtc from IO port space
 to MMIO area.
To:     Andre Przywara <andre.przywara@foss.arm.com>
Cc:     apatel@ventanamicro.com, atishp@rivosinc.com,
        alexandru.elisei@arm.com, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 1, 2023 at 4:35 PM
Andre Przywara <andre.przywara@foss.arm.com> wrote:
>
> On Wed,  1 Feb 2023 16:01:37 +0000
> Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
>
> Hi,
>
> > The default serial and rtc IO region overlaps with PCI IO bar
> > region leading bar 0 activation to fail. Moving these devices
> > to MMIO region similar to ARM.
> >
> > Given serial has been moved from 0x3f8 to 0x10000000, this
> > requires us to now pass earlycon=uart8250,mmio,0x10000000
> > from cmdline rather than earlycon=uart8250,mmio,0x3f8.
>
> Doesn't it work either way with just "earlycon"? At least on the ARM side
> it then finds the UART type and base address by following the DT's
> stdout-path property. This would not only make this more robust, but also
> more VMM agnostic.
>

Sorry I didn't know that. Thanks for pointing this out. Just tested this and it
 works fine with just "earlycon".

$ ./lkvm-static run -c1 --console virtio -p "console=hvc1 earlycon
root=/dev/vda " -k ./Image -d rootfs.ext4
[    0.000000] earlycon: ns16550a0 at MMIO 0x0000000010000000 (options '')
[    0.000000] printk: bootconsole [ns16550a0] enabled

I will update the commit message in the next version.

Thanks,
Rajnesh

> Also, Atish, Anup: can one of you please provide a Reviewed-by: or
> Tested-by: for this patch?
>
> Cheers,
> Andre
>
> >
> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > ---
> > v2: Added further details in the commit message regarding the
> >     UART address change required in kernel cmdline parameter.
> >
> > v1: https://www.spinics.net/lists/kvm/msg301835.html
> >
> >  hw/rtc.c                     |  3 +++
> >  hw/serial.c                  |  4 ++++
> >  riscv/include/kvm/kvm-arch.h | 10 ++++++++--
> >  3 files changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/hw/rtc.c b/hw/rtc.c
> > index 9b8785a..da696e1 100644
> > --- a/hw/rtc.c
> > +++ b/hw/rtc.c
> > @@ -9,6 +9,9 @@
> >  #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> >  #define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> >  #define RTC_BASE_ADDRESS     ARM_RTC_MMIO_BASE
> > +#elif defined(CONFIG_RISCV)
> > +#define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> > +#define RTC_BASE_ADDRESS     RISCV_RTC_MMIO_BASE
> >  #else
> >  /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> >  #define RTC_BUS_TYPE         DEVICE_BUS_IOPORT
> > diff --git a/hw/serial.c b/hw/serial.c
> > index 3d53362..b6263a0 100644
> > --- a/hw/serial.c
> > +++ b/hw/serial.c
> > @@ -17,6 +17,10 @@
> >  #define serial_iobase(nr)    (ARM_UART_MMIO_BASE + (nr) * 0x1000)
> >  #define serial_irq(nr)               (32 + (nr))
> >  #define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> > +#elif defined(CONFIG_RISCV)
> > +#define serial_iobase(nr)    (RISCV_UART_MMIO_BASE + (nr) * 0x1000)
> > +#define serial_irq(nr)               (1 + (nr))
> > +#define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> >  #else
> >  #define serial_iobase_0              (KVM_IOPORT_AREA + 0x3f8)
> >  #define serial_iobase_1              (KVM_IOPORT_AREA + 0x2f8)
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> > index 3f96d00..620c796 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -11,7 +11,7 @@
> >  #define RISCV_IOPORT         0x00000000ULL
> >  #define RISCV_IOPORT_SIZE    SZ_64K
> >  #define RISCV_IRQCHIP                0x08000000ULL
> > -#define RISCV_IRQCHIP_SIZE           SZ_128M
> > +#define RISCV_IRQCHIP_SIZE   SZ_128M
> >  #define RISCV_MMIO           0x10000000ULL
> >  #define RISCV_MMIO_SIZE              SZ_512M
> >  #define RISCV_PCI            0x30000000ULL
> > @@ -35,10 +35,16 @@
> >  #define RISCV_MAX_MEMORY(kvm)        RISCV_LOMAP_MAX_MEMORY
> >  #endif
> >
> > +#define RISCV_UART_MMIO_BASE RISCV_MMIO
> > +#define RISCV_UART_MMIO_SIZE 0x10000
> > +
> > +#define RISCV_RTC_MMIO_BASE  (RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> > +#define RISCV_RTC_MMIO_SIZE  0x10000
> > +
> >  #define KVM_IOPORT_AREA              RISCV_IOPORT
> >  #define KVM_PCI_CFG_AREA     RISCV_PCI
> >  #define KVM_PCI_MMIO_AREA    (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> > -#define KVM_VIRTIO_MMIO_AREA RISCV_MMIO
> > +#define KVM_VIRTIO_MMIO_AREA (RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> >
> >  #define KVM_IOEVENTFD_HAS_PIO        0
> >
>
