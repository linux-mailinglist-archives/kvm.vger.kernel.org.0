Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5A686CDC
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjBAR3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBAR3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:29:04 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4E8B741
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 09:29:02 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id on9-20020a17090b1d0900b002300a96b358so2707316pjb.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 09:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H6+U61QSCnOsJwf/4GY71Tp/0GqFbhJeaelYDy8eudA=;
        b=qKmCuXCAhTajqpo0MT5kj6ZT6naEUvruMetZRI40zorEjL2bN81/aSkohck2ZW7+NM
         B0iVXI4vJrF5ad8eY1C3xHyeoBpnjcp0Z0XerB38qw16G3AhY90oGV98SfjTDrV+0aOW
         CT+PQ7dtHfgJEjFQRhGEUttf9Pl+Ek+5VPHeU3R1m1L44u7x+nk/mZZG79dqCoIt3fj6
         PMG0CxX0cL17W2ZSDK9AsNdjfqcr82ZrAaUri1Jlz7yIn0DrcXOgM2bIrMMH4XfxZuIg
         8EwD8Lfdb8F3iVpELmDseTjXNUyuPQElTwno0Z9EIESrv7rz7p0PU9Cp7IibZv0TJ8jN
         +BYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H6+U61QSCnOsJwf/4GY71Tp/0GqFbhJeaelYDy8eudA=;
        b=A7UsNExCs3TaVaa7WKBl43ZEF+VQIQwMfeLICiUdwitM6nkGZRjmav5SJ6ZbOdEEu5
         dVHu5PafxS5kU4aJf8FpB+kmz0TrY8/0BazB2QFmuD947v0JreD6aXPAME5Bf5D85bdK
         xYGalxkbmgPDV9gqnyAhD8cfyyQJu4CviGNAY6Qg022iHoluNdm5hrjkaoWgiwaAYvxw
         GZyExLjyRWpdjiyenZJgf0q8UcskRVWGpYTm0x56ats/1KnRvCCMhavdt03+eyNSA0i6
         2r5GL+rcAsjPC/0gLd6bLOne2EgN5otZqEXq4waeDL43NRPLTKS6ljoHxfahhKLqa+eL
         hTnA==
X-Gm-Message-State: AO0yUKVJYYZeH7uL7bE4CWcFNTSOyPOayvXJTT6yaUwSbpa80HVdhLce
        e26W4yA7K7r+JkvYtXW1vX/wNjwAH9Ka2Rl4o8tEBQ==
X-Google-Smtp-Source: AK7set8QoqdsxgRxNBLwabK/W2AgyaMZbT1CU2KvzVo+Hs7ebDmedwXrrl4NqxsaX1AVy4O8mIul6iD+GLcqzO5cxYg=
X-Received: by 2002:a17:903:2289:b0:196:4d17:2f46 with SMTP id
 b9-20020a170903228900b001964d172f46mr881630plh.1.1675272542229; Wed, 01 Feb
 2023 09:29:02 -0800 (PST)
MIME-Version: 1.0
References: <20230201160137.486622-1-rkanwal@rivosinc.com> <20230201163509.7fb82d7e@donnerap.cambridge.arm.com>
 <CAECbVCvkKBbeKUNCvjZ4hhQb5njAgSKaY6nSPxu0N993qAaQ+A@mail.gmail.com> <Y9qezHiX9tSaWkmB@monolith.localdoman>
In-Reply-To: <Y9qezHiX9tSaWkmB@monolith.localdoman>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Wed, 1 Feb 2023 17:28:51 +0000
Message-ID: <CAECbVCs9_+4+x5HNwxdKuxNzwARww16Li7=2=60dKj0Hd8x-ag@mail.gmail.com>
Subject: Re: [PATCH v2 kvmtool] riscv: Move serial and rtc from IO port space
 to MMIO area.
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@foss.arm.com>,
        apatel@ventanamicro.com, atishp@rivosinc.com, kvm@vger.kernel.org,
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

On Wed, Feb 1, 2023 at 5:18 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Wed, Feb 01, 2023 at 05:04:36PM +0000, Rajnesh Kanwal wrote:
> > On Wed, Feb 1, 2023 at 4:35 PM
> > Andre Przywara <andre.przywara@foss.arm.com> wrote:
> > >
> > > On Wed,  1 Feb 2023 16:01:37 +0000
> > > Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
> > >
> > > Hi,
> > >
> > > > The default serial and rtc IO region overlaps with PCI IO bar
> > > > region leading bar 0 activation to fail. Moving these devices
> > > > to MMIO region similar to ARM.
> > > >
> > > > Given serial has been moved from 0x3f8 to 0x10000000, this
> > > > requires us to now pass earlycon=uart8250,mmio,0x10000000
> > > > from cmdline rather than earlycon=uart8250,mmio,0x3f8.
> > >
> > > Doesn't it work either way with just "earlycon"? At least on the ARM side
> > > it then finds the UART type and base address by following the DT's
> > > stdout-path property. This would not only make this more robust, but also
> > > more VMM agnostic.
>
> It might actually be better to have both ways of specifying the UART using
> earlycon in the commit message. Some might find it easier to do git log
> hw/serial.c to find the exact parameters than to follow the code and do the
> math.
>
> Spearking for myself, the commit message for the coresponding arm change
> contains the exact parameters (earlycon=uart,mmio,0x1000000) and that has
> been helpful when trying to figure out the address (for example, for
> kvm-unit-tests, you can configure the uart address at compile time, and
> that provides an earlycon which is usable even before the DTB is parsed).
>
> I think Andre was just trying to be helpful and point out that you don't
> need to full parameters to get earlycon working for a Linux guest.
>

Thanks Alex. I actually didn't know that we can just specify "earlycon" only.
Just in case I will mention both ways in the commit message to keep it clear.

Cheers,
Rajnesh

> Thanks,
> Alex
>
> > >
> >
> > Sorry I didn't know that. Thanks for pointing this out. Just tested this and it
> >  works fine with just "earlycon".
> >
> > $ ./lkvm-static run -c1 --console virtio -p "console=hvc1 earlycon
> > root=/dev/vda " -k ./Image -d rootfs.ext4
> > [    0.000000] earlycon: ns16550a0 at MMIO 0x0000000010000000 (options '')
> > [    0.000000] printk: bootconsole [ns16550a0] enabled
> >
> > I will update the commit message in the next version.
> >
> > Thanks,
> > Rajnesh
> >
> > > Also, Atish, Anup: can one of you please provide a Reviewed-by: or
> > > Tested-by: for this patch?
> > >
> > > Cheers,
> > > Andre
> > >
> > > >
> > > > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > > > ---
> > > > v2: Added further details in the commit message regarding the
> > > >     UART address change required in kernel cmdline parameter.
> > > >
> > > > v1: https://www.spinics.net/lists/kvm/msg301835.html
> > > >
> > > >  hw/rtc.c                     |  3 +++
> > > >  hw/serial.c                  |  4 ++++
> > > >  riscv/include/kvm/kvm-arch.h | 10 ++++++++--
> > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/hw/rtc.c b/hw/rtc.c
> > > > index 9b8785a..da696e1 100644
> > > > --- a/hw/rtc.c
> > > > +++ b/hw/rtc.c
> > > > @@ -9,6 +9,9 @@
> > > >  #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > >  #define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> > > >  #define RTC_BASE_ADDRESS     ARM_RTC_MMIO_BASE
> > > > +#elif defined(CONFIG_RISCV)
> > > > +#define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> > > > +#define RTC_BASE_ADDRESS     RISCV_RTC_MMIO_BASE
> > > >  #else
> > > >  /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > > >  #define RTC_BUS_TYPE         DEVICE_BUS_IOPORT
> > > > diff --git a/hw/serial.c b/hw/serial.c
> > > > index 3d53362..b6263a0 100644
> > > > --- a/hw/serial.c
> > > > +++ b/hw/serial.c
> > > > @@ -17,6 +17,10 @@
> > > >  #define serial_iobase(nr)    (ARM_UART_MMIO_BASE + (nr) * 0x1000)
> > > >  #define serial_irq(nr)               (32 + (nr))
> > > >  #define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> > > > +#elif defined(CONFIG_RISCV)
> > > > +#define serial_iobase(nr)    (RISCV_UART_MMIO_BASE + (nr) * 0x1000)
> > > > +#define serial_irq(nr)               (1 + (nr))
> > > > +#define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> > > >  #else
> > > >  #define serial_iobase_0              (KVM_IOPORT_AREA + 0x3f8)
> > > >  #define serial_iobase_1              (KVM_IOPORT_AREA + 0x2f8)
> > > > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> > > > index 3f96d00..620c796 100644
> > > > --- a/riscv/include/kvm/kvm-arch.h
> > > > +++ b/riscv/include/kvm/kvm-arch.h
> > > > @@ -11,7 +11,7 @@
> > > >  #define RISCV_IOPORT         0x00000000ULL
> > > >  #define RISCV_IOPORT_SIZE    SZ_64K
> > > >  #define RISCV_IRQCHIP                0x08000000ULL
> > > > -#define RISCV_IRQCHIP_SIZE           SZ_128M
> > > > +#define RISCV_IRQCHIP_SIZE   SZ_128M
> > > >  #define RISCV_MMIO           0x10000000ULL
> > > >  #define RISCV_MMIO_SIZE              SZ_512M
> > > >  #define RISCV_PCI            0x30000000ULL
> > > > @@ -35,10 +35,16 @@
> > > >  #define RISCV_MAX_MEMORY(kvm)        RISCV_LOMAP_MAX_MEMORY
> > > >  #endif
> > > >
> > > > +#define RISCV_UART_MMIO_BASE RISCV_MMIO
> > > > +#define RISCV_UART_MMIO_SIZE 0x10000
> > > > +
> > > > +#define RISCV_RTC_MMIO_BASE  (RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> > > > +#define RISCV_RTC_MMIO_SIZE  0x10000
> > > > +
> > > >  #define KVM_IOPORT_AREA              RISCV_IOPORT
> > > >  #define KVM_PCI_CFG_AREA     RISCV_PCI
> > > >  #define KVM_PCI_MMIO_AREA    (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> > > > -#define KVM_VIRTIO_MMIO_AREA RISCV_MMIO
> > > > +#define KVM_VIRTIO_MMIO_AREA (RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> > > >
> > > >  #define KVM_IOEVENTFD_HAS_PIO        0
> > > >
> > >
