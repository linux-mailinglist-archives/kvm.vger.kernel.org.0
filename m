Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BEE68868D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjBBScX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjBBScI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:32:08 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5417B7AE
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:30:41 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o13so2723975pjg.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QQJBjgddIJHSAMzF+NVGcc1TrnM9MSl9YEbpob5JvQg=;
        b=E/6pe0lWyYyrgso15HzRBmaHQLVr2vHBUxD9nhorDb6Ya0oU1vYprXUKtdasWEzWwF
         60Qarfa+SwAwJpbjwbaatEhNAjQ/1/LoH3yxmDp5zKfgUZ33mmE8sZTAflirlDm1D2RS
         E+QzGMHGJNmnZ6d5F94vVCO+xSRrGSOqD54nfBrAYVyeEuz51CINSnKkVKPPXeCxN0EG
         f5do9ojgyCbXBq2ozsFHrlbaAwXaoJV/afhiPidQ3gKUGrJ0/rQP6e5S4dvVmxd9NTTY
         Yj8vPv7RSJFYXUC8DD22SLiR+DXqq7vhOaF0bqRo8fSkZAzuKovkNUxZYn/W3BKiSso6
         dPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQJBjgddIJHSAMzF+NVGcc1TrnM9MSl9YEbpob5JvQg=;
        b=6Aypyr8GiIm2h1cf3gUCXKfVGkaLyJQEyNDgCTDAyqJLEEW7vQNbc5WImo9u9X1jnp
         v8V+Du37J3gJYJMiwUlUoSo8QPmP0/ho1Li78x9+0fW0j67IdJP09h7KOnW/THabZjH3
         0qZ4lxuO0/ppqL/PFjYjf2rrtL9MIY7+xpG3uAvUUjHPR9mfHW2rBZdiKqP+Xn6ETJFo
         kJWqZ/IvuOsfyBoeJ9VJoguuUi1Uv+Hchod+Y+SHEb6KwakT7xYc5KWJX/qdCMU9zoa4
         Phspfhc5a5rq7KR2ylV/VHR5E4gAfdTAq/6S7hhroKpuArsfwnndG5J1Wob9xbOZD3ov
         LIoQ==
X-Gm-Message-State: AO0yUKXLAlEyKNKZYjQpwpHS/qjJ56pJL8BgOAjyfLUiRmdwvPsKX0F3
        123sD4ok6cFQdLAFeeOT700ybJXivBRxQxMibCRO5w==
X-Google-Smtp-Source: AK7set8I1rjcyJXKCb+cKdWlZzbUQaAP7e5n1kx49qfAKpGWuFzK9lpJ0U1YqeCKniQpJjjxXFCtnKH7xs5u+dqeaYw=
X-Received: by 2002:a17:90a:8ca:b0:22c:2c4b:bc29 with SMTP id
 10-20020a17090a08ca00b0022c2c4bbc29mr737258pjn.33.1675362578740; Thu, 02 Feb
 2023 10:29:38 -0800 (PST)
MIME-Version: 1.0
References: <20230201160137.486622-1-rkanwal@rivosinc.com> <20230201163509.7fb82d7e@donnerap.cambridge.arm.com>
 <CAECbVCvkKBbeKUNCvjZ4hhQb5njAgSKaY6nSPxu0N993qAaQ+A@mail.gmail.com>
 <Y9qezHiX9tSaWkmB@monolith.localdoman> <CAECbVCs9_+4+x5HNwxdKuxNzwARww16Li7=2=60dKj0Hd8x-ag@mail.gmail.com>
In-Reply-To: <CAECbVCs9_+4+x5HNwxdKuxNzwARww16Li7=2=60dKj0Hd8x-ag@mail.gmail.com>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 2 Feb 2023 10:29:27 -0800
Message-ID: <CAHBxVyF1_aWHd1bmymSatgCnWo=OExM=X3bWYfURjWKpTsq_cA@mail.gmail.com>
Subject: Re: [PATCH v2 kvmtool] riscv: Move serial and rtc from IO port space
 to MMIO area.
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@foss.arm.com>,
        apatel@ventanamicro.com, kvm@vger.kernel.org,
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

On Wed, Feb 1, 2023 at 9:29 AM Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
>
> On Wed, Feb 1, 2023 at 5:18 PM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > On Wed, Feb 01, 2023 at 05:04:36PM +0000, Rajnesh Kanwal wrote:
> > > On Wed, Feb 1, 2023 at 4:35 PM
> > > Andre Przywara <andre.przywara@foss.arm.com> wrote:
> > > >
> > > > On Wed,  1 Feb 2023 16:01:37 +0000
> > > > Rajnesh Kanwal <rkanwal@rivosinc.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > > The default serial and rtc IO region overlaps with PCI IO bar
> > > > > region leading bar 0 activation to fail. Moving these devices
> > > > > to MMIO region similar to ARM.
> > > > >
> > > > > Given serial has been moved from 0x3f8 to 0x10000000, this
> > > > > requires us to now pass earlycon=uart8250,mmio,0x10000000
> > > > > from cmdline rather than earlycon=uart8250,mmio,0x3f8.
> > > >
> > > > Doesn't it work either way with just "earlycon"? At least on the ARM side
> > > > it then finds the UART type and base address by following the DT's
> > > > stdout-path property. This would not only make this more robust, but also
> > > > more VMM agnostic.
> >
> > It might actually be better to have both ways of specifying the UART using
> > earlycon in the commit message. Some might find it easier to do git log
> > hw/serial.c to find the exact parameters than to follow the code and do the
> > math.
> >
> > Spearking for myself, the commit message for the coresponding arm change
> > contains the exact parameters (earlycon=uart,mmio,0x1000000) and that has
> > been helpful when trying to figure out the address (for example, for
> > kvm-unit-tests, you can configure the uart address at compile time, and
> > that provides an earlycon which is usable even before the DTB is parsed).
> >

I agree. The kvm-riscv repo documentation[1] also mentions x3f8. I am
assuming some folks may have this in their script
which will fail once this is merged. Thus, it would be good to find a
clear descriptive commit message.

Additionally, we should update the documentation once this patch is
merged upstream.

https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU#7-run-risc-v-kvm-on-qemu

> > I think Andre was just trying to be helpful and point out that you don't
> > need to full parameters to get earlycon working for a Linux guest.
> >
>
> Thanks Alex. I actually didn't know that we can just specify "earlycon" only.
> Just in case I will mention both ways in the commit message to keep it clear.
>
> Cheers,
> Rajnesh
>
> > Thanks,
> > Alex
> >
> > > >
> > >
> > > Sorry I didn't know that. Thanks for pointing this out. Just tested this and it
> > >  works fine with just "earlycon".
> > >
> > > $ ./lkvm-static run -c1 --console virtio -p "console=hvc1 earlycon
> > > root=/dev/vda " -k ./Image -d rootfs.ext4
> > > [    0.000000] earlycon: ns16550a0 at MMIO 0x0000000010000000 (options '')
> > > [    0.000000] printk: bootconsole [ns16550a0] enabled
> > >
> > > I will update the commit message in the next version.
> > >
> > > Thanks,
> > > Rajnesh
> > >
> > > > Also, Atish, Anup: can one of you please provide a Reviewed-by: or
> > > > Tested-by: for this patch?
> > > >
> > > > Cheers,
> > > > Andre
> > > >
> > > > >
> > > > > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > > > > ---
> > > > > v2: Added further details in the commit message regarding the
> > > > >     UART address change required in kernel cmdline parameter.
> > > > >
> > > > > v1: https://www.spinics.net/lists/kvm/msg301835.html
> > > > >
> > > > >  hw/rtc.c                     |  3 +++
> > > > >  hw/serial.c                  |  4 ++++
> > > > >  riscv/include/kvm/kvm-arch.h | 10 ++++++++--
> > > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/hw/rtc.c b/hw/rtc.c
> > > > > index 9b8785a..da696e1 100644
> > > > > --- a/hw/rtc.c
> > > > > +++ b/hw/rtc.c
> > > > > @@ -9,6 +9,9 @@
> > > > >  #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > > >  #define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> > > > >  #define RTC_BASE_ADDRESS     ARM_RTC_MMIO_BASE
> > > > > +#elif defined(CONFIG_RISCV)
> > > > > +#define RTC_BUS_TYPE         DEVICE_BUS_MMIO
> > > > > +#define RTC_BASE_ADDRESS     RISCV_RTC_MMIO_BASE
> > > > >  #else
> > > > >  /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> > > > >  #define RTC_BUS_TYPE         DEVICE_BUS_IOPORT
> > > > > diff --git a/hw/serial.c b/hw/serial.c
> > > > > index 3d53362..b6263a0 100644
> > > > > --- a/hw/serial.c
> > > > > +++ b/hw/serial.c
> > > > > @@ -17,6 +17,10 @@
> > > > >  #define serial_iobase(nr)    (ARM_UART_MMIO_BASE + (nr) * 0x1000)
> > > > >  #define serial_irq(nr)               (32 + (nr))
> > > > >  #define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> > > > > +#elif defined(CONFIG_RISCV)
> > > > > +#define serial_iobase(nr)    (RISCV_UART_MMIO_BASE + (nr) * 0x1000)
> > > > > +#define serial_irq(nr)               (1 + (nr))
> > > > > +#define SERIAL8250_BUS_TYPE  DEVICE_BUS_MMIO
> > > > >  #else
> > > > >  #define serial_iobase_0              (KVM_IOPORT_AREA + 0x3f8)
> > > > >  #define serial_iobase_1              (KVM_IOPORT_AREA + 0x2f8)
> > > > > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> > > > > index 3f96d00..620c796 100644
> > > > > --- a/riscv/include/kvm/kvm-arch.h
> > > > > +++ b/riscv/include/kvm/kvm-arch.h
> > > > > @@ -11,7 +11,7 @@
> > > > >  #define RISCV_IOPORT         0x00000000ULL
> > > > >  #define RISCV_IOPORT_SIZE    SZ_64K
> > > > >  #define RISCV_IRQCHIP                0x08000000ULL
> > > > > -#define RISCV_IRQCHIP_SIZE           SZ_128M
> > > > > +#define RISCV_IRQCHIP_SIZE   SZ_128M
> > > > >  #define RISCV_MMIO           0x10000000ULL
> > > > >  #define RISCV_MMIO_SIZE              SZ_512M
> > > > >  #define RISCV_PCI            0x30000000ULL
> > > > > @@ -35,10 +35,16 @@
> > > > >  #define RISCV_MAX_MEMORY(kvm)        RISCV_LOMAP_MAX_MEMORY
> > > > >  #endif
> > > > >
> > > > > +#define RISCV_UART_MMIO_BASE RISCV_MMIO
> > > > > +#define RISCV_UART_MMIO_SIZE 0x10000
> > > > > +
> > > > > +#define RISCV_RTC_MMIO_BASE  (RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> > > > > +#define RISCV_RTC_MMIO_SIZE  0x10000
> > > > > +
> > > > >  #define KVM_IOPORT_AREA              RISCV_IOPORT
> > > > >  #define KVM_PCI_CFG_AREA     RISCV_PCI
> > > > >  #define KVM_PCI_MMIO_AREA    (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> > > > > -#define KVM_VIRTIO_MMIO_AREA RISCV_MMIO
> > > > > +#define KVM_VIRTIO_MMIO_AREA (RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
> > > > >
> > > > >  #define KVM_IOEVENTFD_HAS_PIO        0
> > > > >
> > > >

FWIW,
Tested-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
