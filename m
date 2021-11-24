Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5E45B0F4
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 01:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhKXA74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 19:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhKXA7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 19:59:55 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF904C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 16:56:46 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 131so2297725ybc.7
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 16:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nw38P3+CSKjqjpsaapZKe7Y+TEBwrIGgbNi3opF7gMY=;
        b=bq2L7jASgfDQRbVetDzVVKqSgd6WHK1D7UKKjcf9CJGj9QHMfdoFWD+r10dGE4BewP
         nJcxQOtzqv1Vxo3eVzmXEY8WAKjwMS+FEg7QiZJpkrxJc7YJPpWMZiixS29p0DmhgZPo
         t9DohnXg1XlD7AU3V5c+vXHKVmtvi96PaozfTb7pv2IPcyw8wjDbpQgtywK2lVXTJzpP
         sjky68srrWG5xFnU7Q2B0BCIWA3VH2Ewp6HlGnl1tFFtz6pz7ao2X8CWOlRTzzCuh618
         uNK4kVeZG8NJgcjrCGISk++Ii0l6Pxftx0eGPrqskRiqoDmph6GErme/0mRfq7AmAgmF
         /PdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nw38P3+CSKjqjpsaapZKe7Y+TEBwrIGgbNi3opF7gMY=;
        b=QEc93vAfkvFx5FWZb2qZIrBtRC7wrawiUiCeEC45ffxkzMV6xGrL1eYXk2SCvMLPnh
         H4Dk52+m6K1uImQ9qlVv2AnTeHvBX3vrBxqPEhffzkdMDvBvrY0gwefiJZgProMYm5iv
         uzgwC5lijqa33wQFdIwdOkBa3KmUiELN2u51XIauwh3n8fS+Lvx4oQO7PWI1rcry9la6
         UyefTF5+7vs+jFn2hdfL+1HWNbhmZHT78DV23fIDIFAcVfN/8uJVcAoE7iJYasKEMSvo
         XRE+pWTEo5BiSSGTQWeJLLv2D9iZmVTRKRSC/Z3PLCOMuxa+eHumHhYUAk6P/Hq954i1
         lKow==
X-Gm-Message-State: AOAM532JWfIK41ro3afoRlyP39IbFyNpA3/90L3WbMCAqbu757vLqrps
        blbQVKdqaQtt7P094/9wtM06VDfNfEgNLLOhUFA=
X-Google-Smtp-Source: ABdhPJwU1NRVTkbuqWVRrEdbGGPUV2R3/uXChO3xtgigUE5Nid5uGBHyRGjp+vfCDN5ooBFRVI9P7vSYWJfxooCTocQ=
X-Received: by 2002:a25:aae2:: with SMTP id t89mr11387371ybi.470.1637715406297;
 Tue, 23 Nov 2021 16:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20211119081435.3237699-1-zhenyuw@linux.intel.com>
In-Reply-To: <20211119081435.3237699-1-zhenyuw@linux.intel.com>
From:   Colin Xu <colin.xu@gmail.com>
Date:   Wed, 24 Nov 2021 08:56:38 +0800
Message-ID: <CAB4daBTAci-ygY0sXbK7v8x84r7Q33WGunKLYjR8jQNjt4BZNQ@mail.gmail.com>
Subject: Re: [PATCH] vfio/pci: Fix OpRegion read
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, Dmitry Torokhov <dtor@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks and appreciated for the fix.

Acked-by: Colin Xu <colin.xu@gmail.com>

On Fri, Nov 19, 2021 at 4:14 PM Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>
> This is to fix incorrect pointer arithmetic which caused wrong
> OpRegion version returned, then VM driver got error to get wanted
> VBT block. We need to be safe to return correct data, so force
> pointer type for byte access.
>
> Fixes: 49ba1a2976c8 ("vfio/pci: Add OpRegion 2.0+ Extended VBT support.")
> Cc: Colin Xu <colin.xu@gmail.com>
> Cc: Dmitry Torokhov <dtor@chromium.org>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 56cd551e0e04..dad6eeed5e80 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -98,7 +98,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>                         version = cpu_to_le16(0x0201);
>
>                 if (igd_opregion_shift_copy(buf, &off,
> -                                           &version + (pos - OPREGION_VERSION),
> +                                           (u8 *)&version + (pos - OPREGION_VERSION),
>                                             &pos, &remaining, bytes))
>                         return -EFAULT;
>         }
> @@ -121,7 +121,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
>                                           OPREGION_SIZE : 0);
>
>                 if (igd_opregion_shift_copy(buf, &off,
> -                                           &rvda + (pos - OPREGION_RVDA),
> +                                           (u8 *)&rvda + (pos - OPREGION_RVDA),
>                                             &pos, &remaining, bytes))
>                         return -EFAULT;
>         }
> --
> 2.33.1
>
