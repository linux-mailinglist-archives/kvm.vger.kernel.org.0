Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E001733260
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 15:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343832AbjFPNlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbjFPNlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 09:41:20 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5232D7F;
        Fri, 16 Jun 2023 06:41:19 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1a9d57f8f9fso494024fac.3;
        Fri, 16 Jun 2023 06:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686922879; x=1689514879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tntugFqU/8S6D8QnfnZKCyxcavv0/StvRTc0doVwTug=;
        b=Hq9/lbXSB2l5TeApTnHoiauPYE3//779ma15+Cxmn8L3T34gMGZWhlKVlT3W7xr8WQ
         KquU4OujSYGtCkP3iZXQXG3Xyvj0NOht7ph8hBsVZ/hmmUBQ3/vaPNPEFOkZUpqeTlCQ
         6VYbS3K/B4Nbgkd6E4aBFeztPoaY/gr7fsX5Gp6QIVxwpUu+3JRIs0cy/I6gTgf+OJXz
         j6kHCfrcHX++zLnKYt3ECf69LCZCIHeddRS81VJTgQ99J4ZOh1E60VJwNYTDPalONOtL
         69u3yUmftpqms9OZBC/FmX1HYvw22rkPIM3B9ztiUK88ui8GfDZBF2LEAYwzJ5swcIY7
         OjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686922879; x=1689514879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tntugFqU/8S6D8QnfnZKCyxcavv0/StvRTc0doVwTug=;
        b=RKkLV3OspBioVu8kEGeysJVIAqMw+mAZxX8OPLrYbR0rVtH5Qa3iBqrJZ+HJ9L7boQ
         uo+3MyDsYoSn0Ap/+jQD81Y3If03SBlwaPdj+h+f0wuWStYx4z1skhVH255xKRiW2QWA
         LINgATITrejUpEGRPGIt5pu2PbMaRkZgXZDvw+LuCKcjFUAsETr2WL7PH9hgglursNP7
         kjyVdlh+FEZRHF+oBX9EIzcHlhAkvfG3/TA5n4nehS5TqD6uyLxL7qBmgh7+7KQ1Kx+j
         Se4w8paAm9dhoZWhFpi85cEZWLx6hERsD1n2E6Zg9v21baPhw9G1zHCZpvS+/8HyhP6q
         mplA==
X-Gm-Message-State: AC+VfDy3s01vdke8PA4Azs4wE6p+XG82o42L7EXCmpYBQq0l2PWsTs/U
        m3GotTIRUbLRQxyOhrUy6VwAu2Apu0VYC63NG18=
X-Google-Smtp-Source: ACHHUZ5DUTS2+G6vWyka9hNK/jQ6zUkQOgAWXaZ33xSXADCJfdHjNufahkasrMK6Qa6EriSSkLq2Z+fUNgoHOthdzLA=
X-Received: by 2002:a54:4802:0:b0:39a:664c:9761 with SMTP id
 j2-20020a544802000000b0039a664c9761mr2082977oij.29.1686922878844; Fri, 16 Jun
 2023 06:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230613030151.216625-1-15330273260@189.cn> <20230613030151.216625-3-15330273260@189.cn>
 <dbf0d89f-717a-1f78-aef2-f30506751d4d@loongson.cn> <CADnq5_N6vVtzH6tzguZdHnP_TdRoG1G-Cr94O+X03jvtk=vhag@mail.gmail.com>
 <3c1c86ab-96ea-aa1c-c9c5-9a4012644fd6@loongson.cn>
In-Reply-To: <3c1c86ab-96ea-aa1c-c9c5-9a4012644fd6@loongson.cn>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 16 Jun 2023 09:41:07 -0400
Message-ID: <CADnq5_Px-HWfwetv8LZsCnCeV7SMt_uqtLwMVK7648ZQiP2RCQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] PCI/VGA: Deal only with VGA class devices
To:     Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Sui Jingfeng <15330273260@189.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 3:11=E2=80=AFAM Sui Jingfeng <suijingfeng@loongson.=
cn> wrote:
>
> Hi,
>
> On 2023/6/16 05:11, Alex Deucher wrote:
> > On Wed, Jun 14, 2023 at 6:50=E2=80=AFAM Sui Jingfeng <suijingfeng@loong=
son.cn> wrote:
> >> Hi,
> >>
> >> On 2023/6/13 11:01, Sui Jingfeng wrote:
> >>> From: Sui Jingfeng <suijingfeng@loongson.cn>
> >>>
> >>> Deal only with the VGA devcie(pdev->class =3D=3D 0x0300), so replace =
the
> >>> pci_get_subsys() function with pci_get_class(). Filter the non-PCI di=
splay
> >>> device(pdev->class !=3D 0x0300) out. There no need to process the non=
-display
> >>> PCI device.
> >>>
> >>> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >>> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
> >>> ---
> >>>    drivers/pci/vgaarb.c | 22 ++++++++++++----------
> >>>    1 file changed, 12 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> >>> index c1bc6c983932..22a505e877dc 100644
> >>> --- a/drivers/pci/vgaarb.c
> >>> +++ b/drivers/pci/vgaarb.c
> >>> @@ -754,10 +754,6 @@ static bool vga_arbiter_add_pci_device(struct pc=
i_dev *pdev)
> >>>        struct pci_dev *bridge;
> >>>        u16 cmd;
> >>>
> >>> -     /* Only deal with VGA class devices */
> >>> -     if ((pdev->class >> 8) !=3D PCI_CLASS_DISPLAY_VGA)
> >>> -             return false;
> >>> -
> >> Hi, here is probably a bug fixing.
> >>
> >> For an example, nvidia render only GPU typically has 0x0380.
> >>
> >> as its PCI class number, but render only GPU should not participate in
> >> the arbitration.
> >>
> >> As it shouldn't snoop the legacy fixed VGA address.
> >>
> >> It(render only GPU) can not display anything.
> >>
> >>
> >> But 0x0380 >> 8 =3D 0x03, the filter  failed.
> >>
> >>
> >>>        /* Allocate structure */
> >>>        vgadev =3D kzalloc(sizeof(struct vga_device), GFP_KERNEL);
> >>>        if (vgadev =3D=3D NULL) {
> >>> @@ -1500,7 +1496,9 @@ static int pci_notify(struct notifier_block *nb=
, unsigned long action,
> >>>        struct pci_dev *pdev =3D to_pci_dev(dev);
> >>>        bool notify =3D false;
> >>>
> >>> -     vgaarb_dbg(dev, "%s\n", __func__);
> >>> +     /* Only deal with VGA class devices */
> >>> +     if (pdev->class !=3D PCI_CLASS_DISPLAY_VGA << 8)
> >>> +             return 0;
> >> So here we only care 0x0300, my initial intent is to make an optimizat=
ion,
> >>
> >> nowadays sane display graphic card should all has 0x0300 as its PCI
> >> class number, is this complete right?
> >>
> >> ```
> >>
> >> #define PCI_BASE_CLASS_DISPLAY        0x03
> >> #define PCI_CLASS_DISPLAY_VGA        0x0300
> >> #define PCI_CLASS_DISPLAY_XGA        0x0301
> >> #define PCI_CLASS_DISPLAY_3D        0x0302
> >> #define PCI_CLASS_DISPLAY_OTHER        0x0380
> >>
> >> ```
> >>
> >> Any ideas ?
> > I'm not quite sure what you are asking about here.
>
> To be honest, I'm worried about the PCI devices which has a
>
> PCI_CLASS_DISPLAY_XGA as its PCI class number.
>
> As those devices are very uncommon in the real world.
>
>
> $ find . -name "*.c" -type f | xargs grep "PCI_CLASS_DISPLAY_XGA"
>
>
> Grep the "PCI_CLASS_DISPLAY_XGA" in the linux kernel tree got ZERO,
>
> there no code reference this macro. So I think it seems safe to ignore
> the XGA ?
>
>
> PCI_CLASS_DISPLAY_3D and PCI_CLASS_DISPLAY_OTHER are used to annotate
> the render-only GPU.
>
> And render-only GPU can't decode the fixed VGA address space, it is safe
> to ignore them.
>
>
> >   For vga_arb, we
> > only care about VGA class devices since those should be on the only
> > ones that might have VGA routed to them.
>
> >   However, as VGA gets deprecated,
>
> We need the vgaarb for a system with multiple video card.
>
> Not only because some Legacy VGA devices implemented
>
> on PCI will typically have the same "hard-decoded" addresses;
>
> But also these video card need to participate in the arbitration,
>
> determine the default boot device.

But couldn't the boot device be determined via what whatever resources
were used by the pre-OS console?  I feel like that should be separate
from vgaarb.  vgaarb should handle PCI VGA routing and some other
mechanism should be used to determine what device provided the pre-OS
console.

Alex


>
>
> Nowadays, the 'VGA devices' here is stand for the Graphics card
>
> which is capable of display something on the screen.
>
> We still need vgaarb to select the default boot device.
>
>
> > you'll have more non VGA PCI classes for devices which
> > could be the pre-OS console device.
>
> Ah, we still want  do this(by applying this patch) first,
>
> and then we will have the opportunity to see who will crying if
> something is broken. Will know more then.
>
> But drop this patch or revise it with more consideration is also
> acceptable.
>
>
> I asking about suggestion and/or review.
>
> > Alex
> >
> >>>        /* For now we're only intereted in devices added and removed. =
I didn't
> >>>         * test this thing here, so someone needs to double check for =
the
> >>> @@ -1510,6 +1508,8 @@ static int pci_notify(struct notifier_block *nb=
, unsigned long action,
> >>>        else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE)
> >>>                notify =3D vga_arbiter_del_pci_device(pdev);
> >>>
> >>> +     vgaarb_dbg(dev, "%s: action =3D %lu\n", __func__, action);
> >>> +
> >>>        if (notify)
> >>>                vga_arbiter_notify_clients();
> >>>        return 0;
> >>> @@ -1534,8 +1534,8 @@ static struct miscdevice vga_arb_device =3D {
> >>>
> >>>    static int __init vga_arb_device_init(void)
> >>>    {
> >>> +     struct pci_dev *pdev =3D NULL;
> >>>        int rc;
> >>> -     struct pci_dev *pdev;
> >>>
> >>>        rc =3D misc_register(&vga_arb_device);
> >>>        if (rc < 0)
> >>> @@ -1545,11 +1545,13 @@ static int __init vga_arb_device_init(void)
> >>>
> >>>        /* We add all PCI devices satisfying VGA class in the arbiter =
by
> >>>         * default */
> >>> -     pdev =3D NULL;
> >>> -     while ((pdev =3D
> >>> -             pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> >>> -                            PCI_ANY_ID, pdev)) !=3D NULL)
> >>> +     while (1) {
> >>> +             pdev =3D pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev=
);
> >>> +             if (!pdev)
> >>> +                     break;
> >>> +
> >>>                vga_arbiter_add_pci_device(pdev);
> >>> +     }
> >>>
> >>>        pr_info("loaded\n");
> >>>        return rc;
> >> --
> >> Jingfeng
> >>
> --
> Jingfeng
>
