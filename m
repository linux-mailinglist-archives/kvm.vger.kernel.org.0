Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D426ABF3A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 13:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCFMNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 07:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCFMNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 07:13:24 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1941EBF7
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 04:13:22 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id bd34so5605406pfb.3
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 04:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1678104802;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMOfPPr+yXxwzJNBiyndfAV3hoyGYmXTnsu1MtSkFWo=;
        b=zrrnHi5rpfzU5B+/vMAI8StZ7y4N/FpC5ylxDXINdVyF2M/mmwgByv3LTGY98j0S1B
         d/AqMssyVfevsfc0kL91eTp4kyQeAvRsCHy2CpO83DxrlAVNOLx1L0BOBEmy3iarX/e3
         QZMuryW7326azBqhj55QmmLmt7q1abF1FNrOQvHv3tY7Wd8r6HbrTqvDYyHmGHSvcj9t
         g+l0jDJYKyxeDMRMLmMPGQMh39bQDSFn8jQNd9ay3rBxrPg30BfFDpUtgjisJQnUBLqb
         X2BdYpOEIsNGiN/Rnv7VnYcZCN8z2+SXDinjw6ZY8DwTeAAc+cZqiFu9wZ4ztzcuShOz
         ya1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104802;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMOfPPr+yXxwzJNBiyndfAV3hoyGYmXTnsu1MtSkFWo=;
        b=yP41LjXg30dpi7BW61CdNssO6kKHToaB05l30A245iszf2QtfY8tJJfe6yae+mgIly
         Sfgeto7RM3bZ1bAva+DXerZ32/fcfaPRun2g8rWe+5/U5Th6rrVHy4F4AHXWE0U873xj
         3Tv1z43h5g+7JlmS7X6Pg+/5/V5yffk3nYsTAE8UmCdo96BNjfItj85rFJo2JyDpATWT
         yyPtAvXz8IacwAkYfk9V2cTnmBr0W7yGJ/KS2TArJEDR6sunDMo7EZ62wzL0B4EvmsBC
         zS07355OBxNTPCM3JQB7cwspXnDAbzh3i7VOzcR87ixdH0wThdrNV9KX/npYltMiHaOo
         BnWA==
X-Gm-Message-State: AO0yUKV7Ae5eQvNhVZwW99ltKPFgqHcXGIut+lN/G4gz5lIOOCCRsc3E
        EJybkwV4RjEo0CucKCYuEV4POTxd1AXB+MJ33bH6Fw==
X-Google-Smtp-Source: AK7set/wWsYXCmOWpo/vkHHgEF/EmFVbtfZV30UWob1mIcHwXG4CUHt73KTj6rzPZcUDqX5udYQmR6HAJ3j9xfW+VAk=
X-Received: by 2002:a63:9c0a:0:b0:502:e4df:5f3f with SMTP id
 f10-20020a639c0a000000b00502e4df5f3fmr3457520pge.6.1678104802351; Mon, 06 Mar
 2023 04:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20230203122934.18714-1-rkanwal@rivosinc.com>
In-Reply-To: <20230203122934.18714-1-rkanwal@rivosinc.com>
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
Date:   Mon, 6 Mar 2023 12:13:11 +0000
Message-ID: <CAECbVCsfYQLJ2zKRadNXagQjCt-T75CYANtV3_kzO762i-AFAg@mail.gmail.com>
Subject: Re: [PATCH v4 kvmtool 1/1] riscv: Move serial and rtc from IO port
 space to MMIO area.
To:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        julien.thierry.kdev@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding will and Julien.

Thanks.

On Fri, Feb 3, 2023 at 12:30=E2=80=AFPM Rajnesh Kanwal <rkanwal@rivosinc.co=
m> wrote:
>
> The default serial and rtc IO region overlaps with PCI IO bar
> region leading bar 0 activation to fail. Moving these devices
> to MMIO region similar to ARM.
>
> Given serial has been moved from 0x3f8 to 0x10000000, this
> requires us to now pass earlycon=3Duart8250,mmio,0x10000000
> from cmdline rather than earlycon=3Duart8250,mmio,0x3f8.
>
> To avoid the need to change the address every time the tool
> is updated, we can also just pass "earlycon" from cmdline
> and guest then finds the type and base address by following
> the Device Tree's stdout-path property.
>
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> Tested-by: Atish Patra <atishp@rivosinc.com>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> ---
> v4: Incorporated feedback from Alexandru Elisei. Mainly rebased the
>     change on main with the IRQ changes which haven't landed yet. Also
>     a fix in KVM_VIRTIO_MMIO_AREA macro.
>
> v3: https://lore.kernel.org/all/20230202191301.588804-1-rkanwal@rivosinc.=
com/
>     Incorporated feedback from Andre Przywara and Alexandru Elisei.
>       Mainly updated the commit message to specify that we can simply pas=
s
>       just "earlycon" from cmdline and avoid the need to specify uart add=
ress.
>     Also added Tested-by and Reviewed-by tags by Atish Patra.
>
> v2: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.=
com/
>     Added further details in the commit message regarding the
>     UART address change required in kernel cmdline parameter.
>
> v1: https://lore.kernel.org/all/20230124155251.1417682-1-rkanwal@rivosinc=
.com/
>
>  hw/rtc.c                     | 3 +++
>  hw/serial.c                  | 4 ++++
>  riscv/include/kvm/kvm-arch.h | 8 +++++++-
>  3 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/hw/rtc.c b/hw/rtc.c
> index 9b8785a..da696e1 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -9,6 +9,9 @@
>  #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
>  #define RTC_BUS_TYPE           DEVICE_BUS_MMIO
>  #define RTC_BASE_ADDRESS       ARM_RTC_MMIO_BASE
> +#elif defined(CONFIG_RISCV)
> +#define RTC_BUS_TYPE           DEVICE_BUS_MMIO
> +#define RTC_BASE_ADDRESS       RISCV_RTC_MMIO_BASE
>  #else
>  /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
>  #define RTC_BUS_TYPE           DEVICE_BUS_IOPORT
> diff --git a/hw/serial.c b/hw/serial.c
> index 3d53362..b6263a0 100644
> --- a/hw/serial.c
> +++ b/hw/serial.c
> @@ -17,6 +17,10 @@
>  #define serial_iobase(nr)      (ARM_UART_MMIO_BASE + (nr) * 0x1000)
>  #define serial_irq(nr)         (32 + (nr))
>  #define SERIAL8250_BUS_TYPE    DEVICE_BUS_MMIO
> +#elif defined(CONFIG_RISCV)
> +#define serial_iobase(nr)      (RISCV_UART_MMIO_BASE + (nr) * 0x1000)
> +#define serial_irq(nr)         (1 + (nr))
> +#define SERIAL8250_BUS_TYPE    DEVICE_BUS_MMIO
>  #else
>  #define serial_iobase_0                (KVM_IOPORT_AREA + 0x3f8)
>  #define serial_iobase_1                (KVM_IOPORT_AREA + 0x2f8)
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index 2cf41c5..3e7dd3e 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -35,10 +35,16 @@
>  #define RISCV_MAX_MEMORY(kvm)  RISCV_LOMAP_MAX_MEMORY
>  #endif
>
> +#define RISCV_UART_MMIO_BASE   RISCV_MMIO
> +#define RISCV_UART_MMIO_SIZE   0x10000
> +
> +#define RISCV_RTC_MMIO_BASE    (RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_S=
IZE)
> +#define RISCV_RTC_MMIO_SIZE    0x10000
> +
>  #define KVM_IOPORT_AREA                RISCV_IOPORT
>  #define KVM_PCI_CFG_AREA       RISCV_PCI
>  #define KVM_PCI_MMIO_AREA      (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> -#define KVM_VIRTIO_MMIO_AREA   RISCV_MMIO
> +#define KVM_VIRTIO_MMIO_AREA   (RISCV_RTC_MMIO_BASE + RISCV_RTC_MMIO_SIZ=
E)
>
>  #define KVM_IOEVENTFD_HAS_PIO  0
>
> --
> 2.25.1
>
