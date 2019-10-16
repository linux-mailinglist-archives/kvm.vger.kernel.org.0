Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F9CD8F53
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 13:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403861AbfJPLY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 07:24:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46958 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403826AbfJPLY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 07:24:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so14505238pfg.13
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 04:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LOhxSmhltHVmCHIgrxp16EKj8XAolAsY7/5MxXVPJeg=;
        b=qv0RwlQfuyAV06Rt87qK/UWtE06kLYJBl1B7flH3oYBYMZ3WBvvlBjWzQIAO17RosM
         pWkGzHPPdw+nL4xc2/rX4dsVOjYbVG3eZ2AiWCwNH/M7Eyka4Fa12UVP9hZsbCSHZjKe
         4aoy2dhnK4C5KifXK6Qvf/gd5EszL0madtYJd3fsd1wHPpgLEbgsXkMcr0a8l6a312Yc
         FJPEYir3JsQ3j/xOB3WAySj5fuJowgpL8vNDsSiIDoKRZZNwBDm+k2mdAVG2uk8CgCt1
         4arQqvc4oo5+56fvSgC+2XsAndZRThn3zBTxGN6W7zxoQDzdvXkpJz43BTbw4h4/HgPa
         HnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LOhxSmhltHVmCHIgrxp16EKj8XAolAsY7/5MxXVPJeg=;
        b=dBpCgt4hqHy9JRl+ZBzBPJ0B17gQoWDl+nHzMCnmOS9SL1vXS7QzGnizdwgppESmlU
         BBiN4aC+nrd6ISHq4giUqckV37duYXUhtCKydbwEu2hgxzzddHTVZ5QAGLGE7Anslaqy
         A5+PWmPtJInsTvxujGZB+5JEg5R5eM18DxH/kxiNqAzWmRymSVPVBU/tt6MVdwujgLa3
         r9FMhRiZf4Fxom0wPhzmyMilpkFr2xNnpqmDGFe4vXOly0qGcKw8+/k4Mx/tcg5WACEn
         dMGBiGv1AvOzZyU8IrmuwigvQ8axO60a+4fs9KeJOoH3nXNf9Lm7FwqE6HWWFLbd0OhC
         f3rA==
X-Gm-Message-State: APjAAAVllpTiugElN0iHhVEBA1Aoe3nDBbG66Q6acRuhLwsB8BXw3wm0
        BGCc1X2tHpRfVIByb/KaJdg9kLRp7fJsjYHONSY=
X-Google-Smtp-Source: APXvYqx/K3HVs2y8kHeKYg41IQD9q1KLMW4BxhnkYePE6OPi6UiZwMnm8IQr0qxQpi9GF6ZNT6tQ0S1OQNNMywxKpWQ=
X-Received: by 2002:a17:90a:e001:: with SMTP id u1mr4460927pjy.102.1571225066213;
 Wed, 16 Oct 2019 04:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191015162705.28087-1-philmd@redhat.com> <20191015162705.28087-28-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-28-philmd@redhat.com>
From:   Paul Durrant <pdurrant@gmail.com>
Date:   Wed, 16 Oct 2019 12:24:15 +0100
Message-ID: <CACCGGhDsJ==Z_rVRNJ28N_p3Ar=dtbPZcgMaXiw=cLEvAiYSKQ@mail.gmail.com>
Subject: Re: [PATCH 27/32] hw/pci-host/piix: Define and use the PIIX IRQ Route
 Control Registers
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Oct 2019 at 17:34, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> The IRQ Route Control registers definitions belong to the PIIX
> chipset. We were only defining the 'A' register. Define the other
> B, C and D registers, and use them.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Xen change...

Acked-by: Paul Durrant <paul@xen.org>

> ---
>  hw/i386/xen/xen-hvm.c         | 5 +++--
>  hw/mips/gt64xxx_pci.c         | 4 ++--
>  hw/pci-host/piix.c            | 9 ++++-----
>  include/hw/southbridge/piix.h | 6 ++++++
>  4 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
> index 6b5e5bb7f5..4ce2fb9c89 100644
> --- a/hw/i386/xen/xen-hvm.c
> +++ b/hw/i386/xen/xen-hvm.c
> @@ -14,6 +14,7 @@
>  #include "hw/pci/pci.h"
>  #include "hw/pci/pci_host.h"
>  #include "hw/i386/pc.h"
> +#include "hw/southbridge/piix.h"
>  #include "hw/irq.h"
>  #include "hw/hw.h"
>  #include "hw/i386/apic-msidef.h"
> @@ -156,8 +157,8 @@ void xen_piix_pci_write_config_client(uint32_t addres=
s, uint32_t val, int len)
>              v =3D 0;
>          }
>          v &=3D 0xf;
> -        if (((address + i) >=3D 0x60) && ((address + i) <=3D 0x63)) {
> -            xen_set_pci_link_route(xen_domid, address + i - 0x60, v);
> +        if (((address + i) >=3D PIIX_PIRQCA) && ((address + i) <=3D PIIX=
_PIRQCD)) {
> +            xen_set_pci_link_route(xen_domid, address + i - PIIX_PIRQCA,=
 v);
>          }
>      }
>  }
> diff --git a/hw/mips/gt64xxx_pci.c b/hw/mips/gt64xxx_pci.c
> index c277398c0d..5cab9c1ee1 100644
> --- a/hw/mips/gt64xxx_pci.c
> +++ b/hw/mips/gt64xxx_pci.c
> @@ -1013,12 +1013,12 @@ static void gt64120_pci_set_irq(void *opaque, int=
 irq_num, int level)
>
>      /* now we change the pic irq level according to the piix irq mapping=
s */
>      /* XXX: optimize */
> -    pic_irq =3D piix4_dev->config[0x60 + irq_num];
> +    pic_irq =3D piix4_dev->config[PIIX_PIRQCA + irq_num];
>      if (pic_irq < 16) {
>          /* The pic level is the logical OR of all the PCI irqs mapped to=
 it. */
>          pic_level =3D 0;
>          for (i =3D 0; i < 4; i++) {
> -            if (pic_irq =3D=3D piix4_dev->config[0x60 + i]) {
> +            if (pic_irq =3D=3D piix4_dev->config[PIIX_PIRQCA + i]) {
>                  pic_level |=3D pci_irq_levels[i];
>              }
>          }
> diff --git a/hw/pci-host/piix.c b/hw/pci-host/piix.c
> index 3770575c1a..a450fc726e 100644
> --- a/hw/pci-host/piix.c
> +++ b/hw/pci-host/piix.c
> @@ -61,7 +61,6 @@ typedef struct I440FXState {
>  #define PIIX_NUM_PIC_IRQS       16      /* i8259 * 2 */
>  #define PIIX_NUM_PIRQS          4ULL    /* PIRQ[A-D] */
>  #define XEN_PIIX_NUM_PIRQS      128ULL
> -#define PIIX_PIRQC              0x60
>
>  typedef struct PIIX3State {
>      PCIDevice dev;
> @@ -468,7 +467,7 @@ static void piix3_set_irq_level_internal(PIIX3State *=
piix3, int pirq, int level)
>      int pic_irq;
>      uint64_t mask;
>
> -    pic_irq =3D piix3->dev.config[PIIX_PIRQC + pirq];
> +    pic_irq =3D piix3->dev.config[PIIX_PIRQCA + pirq];
>      if (pic_irq >=3D PIIX_NUM_PIC_IRQS) {
>          return;
>      }
> @@ -482,7 +481,7 @@ static void piix3_set_irq_level(PIIX3State *piix3, in=
t pirq, int level)
>  {
>      int pic_irq;
>
> -    pic_irq =3D piix3->dev.config[PIIX_PIRQC + pirq];
> +    pic_irq =3D piix3->dev.config[PIIX_PIRQCA + pirq];
>      if (pic_irq >=3D PIIX_NUM_PIC_IRQS) {
>          return;
>      }
> @@ -501,7 +500,7 @@ static void piix3_set_irq(void *opaque, int pirq, int=
 level)
>  static PCIINTxRoute piix3_route_intx_pin_to_irq(void *opaque, int pin)
>  {
>      PIIX3State *piix3 =3D opaque;
> -    int irq =3D piix3->dev.config[PIIX_PIRQC + pin];
> +    int irq =3D piix3->dev.config[PIIX_PIRQCA + pin];
>      PCIINTxRoute route;
>
>      if (irq < PIIX_NUM_PIC_IRQS) {
> @@ -530,7 +529,7 @@ static void piix3_write_config(PCIDevice *dev,
>                                 uint32_t address, uint32_t val, int len)
>  {
>      pci_default_write_config(dev, address, val, len);
> -    if (ranges_overlap(address, len, PIIX_PIRQC, 4)) {
> +    if (ranges_overlap(address, len, PIIX_PIRQCA, 4)) {
>          PIIX3State *piix3 =3D PIIX3_PCI_DEVICE(dev);
>          int pic_irq;
>
> diff --git a/include/hw/southbridge/piix.h b/include/hw/southbridge/piix.=
h
> index 79ebe0089b..9c92c37a4d 100644
> --- a/include/hw/southbridge/piix.h
> +++ b/include/hw/southbridge/piix.h
> @@ -18,6 +18,12 @@ I2CBus *piix4_pm_init(PCIBus *bus, int devfn, uint32_t=
 smb_io_base,
>                        qemu_irq sci_irq, qemu_irq smi_irq,
>                        int smm_enabled, DeviceState **piix4_pm);
>
> +/* PIRQRC[A:D]: PIRQx Route Control Registers */
> +#define PIIX_PIRQCA 0x60
> +#define PIIX_PIRQCB 0x61
> +#define PIIX_PIRQCC 0x62
> +#define PIIX_PIRQCD 0x63
> +
>  /*
>   * Reset Control Register: PCI-accessible ISA-Compatible Register at add=
ress
>   * 0xcf9, provided by the PCI/ISA bridge (PIIX3 PCI function 0, 8086:700=
0).
> --
> 2.21.0
>
