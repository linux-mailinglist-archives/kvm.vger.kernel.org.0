Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB356898FA
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 13:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjBCMlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 07:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjBCMlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 07:41:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBA69AFF1
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 04:41:48 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e6so5057943plg.12
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 04:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PmhZbfaBCYnUBaqFFWgt+daRvNTSOHEWpNLsE9kD9iA=;
        b=w7nGNOg/j9vd2+0iAaSM73Ri37dDGhv3cg4WN0kL6gIIhiw9/vLn6AlXh75w6Rudhw
         wDm6ACQ+gHJTtUWtdy25Z3YeknRf8HIrvzW9p2w9oYsMnPkAp9xDh5FbPJtz7BH5kB/E
         vDR5GbUWjDdNNv3hzj+3Qot73ZJOLfjOE7QnzGBe+H60hSk3/W1JthvvGfJn4uc1T5AK
         8SE3sANXXZ+z4raBzV9HgzkdwBfPWexgVGvoSXdL5CcGb1ptqLT1LreMwKSShk9g0OQa
         NPfwIXD/HAtZ7BPWvzl9YCooE2zOCYO/BpirH5jXpFebBIVr9HMVLPxUu8tRKKHIvDQj
         CgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmhZbfaBCYnUBaqFFWgt+daRvNTSOHEWpNLsE9kD9iA=;
        b=CUXvTOYpPltMjsep25EQhfDFYAVElAcQYYS8O8Jdn2+sqq+q5Ri+8JpvDlTq7eiAxZ
         oQqhKwcBBhG2+wmI+06eaTqtQu+I2eHq1MIfi852/hfnnRKK8i9LS3p7dl9biTP25ItZ
         efxNaWpPGQrTg7cagKVTvYS/IDiEp0sUA3AqKHE6crjZkg1cY2iXFSEvLl/5Kwa8rlRr
         D/wVbjVPHM7qnHzaI3SOu0ExeJgqmFVpFZ0NDwk5itnKZCynufj10ZMQ2cj1AlzXC4q4
         QdTz486LpikWwHhKAxFFSLyD5qUDwKoOvkrpk8e6MphqBJq4r0QYfb8Sb67NIAxpjBA/
         3FUg==
X-Gm-Message-State: AO0yUKV6QzrH6PRlPWd4eCIFnKWhbESwYgInAtuNN6dLvUmONuE4gjUB
        DpwU5dvFpQ4UQG6N1m304nGpwKnPcE3B/Slyc3fyRg==
X-Google-Smtp-Source: AK7set9f/cw42j8DC442Jabj0KWetMACXxAmE9465IfbCbTwwODGWEEiv7lKI2+RtivOtbldE4RyiO1NwZXnDBHejmk=
X-Received: by 2002:a17:90a:2d0:b0:22c:19cb:948a with SMTP id
 d16-20020a17090a02d000b0022c19cb948amr1308497pjd.98.1675428108313; Fri, 03
 Feb 2023 04:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20230202191301.588804-1-rkanwal@rivosinc.com> <Y9za1tUnQR8jpZoA@monolith.localdoman>
In-Reply-To: <Y9za1tUnQR8jpZoA@monolith.localdoman>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Fri, 3 Feb 2023 12:41:37 +0000
Message-ID: <CAECbVCvSQh_rsWdLNNYSp1emJTLYeQ4vKYvnEjDromCD-AKx=g@mail.gmail.com>
Subject: Re: [PATCH v3 kvmtool 1/1] riscv: Move serial and rtc from IO port
 space to MMIO area.
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 9:58 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Thu, Feb 02, 2023 at 07:13:01PM +0000, Rajnesh Kanwal wrote:
> > The default serial and rtc IO region overlaps with PCI IO bar
> > region leading bar 0 activation to fail. Moving these devices
> > to MMIO region similar to ARM.
> >
> > Given serial has been moved from 0x3f8 to 0x10000000, this
> > requires us to now pass earlycon=uart8250,mmio,0x10000000
> > from cmdline rather than earlycon=uart8250,mmio,0x3f8.
> >
> > To avoid the need to change the address every time the tool
> > is updated, we can also just pass "earlycon" from cmdline
> > and guest then finds the type and base address by following
> > the Device Tree's stdout-path property.
> >
> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > Tested-by: Atish Patra <atishp@rivosinc.com>
> > Reviewed-by: Atish Patra <atishp@rivosinc.com>
> > ---
> > v3: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
> >     Incorporated feedback from Andre Przywara and Alexandru Elisei.
> >       Mainly updated the commit message to specify that we can simply pass
> >       just "earlycon" from cmdline and avoid the need to specify uart address.
> >     Also added Tested-by and Reviewed-by tags by Atish Patra.
> >
> > v2: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
> >     Added further details in the commit message regarding the
> >     UART address change required in kernel cmdline parameter.
> >
> > v1: https://lore.kernel.org/all/20230124155251.1417682-1-rkanwal@rivosinc.com/
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
>
> That's strange, for me the latest upstream commit is e17d182ad3f7 ("riscv: Add
> --disable-<xyz> options to allow user disable extensions"), and I can't seem to
> find those defines in the file. In fact, grep -r IRQCHIP riscv doesn't find
> anything. Does this patch depend on another patch which hasn't been merged yet?

Extremely sorry. My bad. The change was based on AIA IRQCHIP changes but those
haven't merged yet and this fix doesn't depend on it. I have rebased
the changes and
sent another patch. I have also fixed the problem you have mentioned below.
Thanks for the review.
https://lore.kernel.org/all/20230203122934.18714-1-rkanwal@rivosinc.com/

I also retested everything on a pristine setup using instruction in
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU.

Thanks
Rajnesh

>
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
>
> That should be RISCV_RTC_MMIO_SIZE, not RISCV_**UART**_MMIO_SIZE.
>
> Thanks,
> Alex
>
> >
> >  #define KVM_IOEVENTFD_HAS_PIO        0
> >
> > --
> > 2.25.1
> >
