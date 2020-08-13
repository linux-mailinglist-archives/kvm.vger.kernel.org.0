Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A650524324D
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 03:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHMBzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 21:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgHMBzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 21:55:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD97CC061383;
        Wed, 12 Aug 2020 18:55:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b17so5638480ion.7;
        Wed, 12 Aug 2020 18:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=exHjJwer/lYLKu6KbII9P2ApxJHTWZaUm55/qYp7qAM=;
        b=LC5O28vEDhGdcHrd5UQo83vsPy1RH6SWhr5Jnj7JgFTlaLANQ5JbSD+nAcY8lQlQny
         NHfwAeA2xO7iraqn1YpBCRe3KjjwXUAyg2CHT2W4ZZE66QME+nuphbLHGHaQkaeTFnke
         4ICshD8hcz14ep1Ut9rA3xcIhKA3t+qSur8Te3MwXf5dd7JUx3bQfmH2Ez/t34zZ9+2L
         xrC1y/HirpUlaCtQIhqwTsH87V3WMKyhPdTccC6rxw4AyPYfJkQwCOOmPplRNkzfkA0z
         BThLyzGoMCqOt4sxXgiogTZ5UzSUPuVXeeT45lijOxPJufZ481XyNCeBuXgXG7C/X8BS
         +HaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=exHjJwer/lYLKu6KbII9P2ApxJHTWZaUm55/qYp7qAM=;
        b=TSnElJchQxj0xfpHK1slkYypX9z5Cn4rxJwycPC9YDunSgn5kvCWMySJiI9ppEc//A
         0+Msm4i9iEnakxbuHt/Q4uewiSyBRo4pdUpZ6jyHYXHGMq8zG8H+u6BF09Oec5W94QNI
         yBZsOL+HBUTuAYPdc4kbquLPr85KwchPkBotyoByaRWZgBvlgzk/8XKpmvWIp+Pdp1Uy
         UBKkTpjkJsTfEkJtewdLgHzvNLc6dz+1WKeaEvaiesbybDftUpwojwbOR65CdumAmBEt
         den15Vk+zUwAFXhlgJ7uWr/Jfi30ymhHuuz1M8dPQw8PYaKucw/nO/BNcpvHzeEiWY+z
         prNA==
X-Gm-Message-State: AOAM530KZ0IHEhHDbXToyt8E10pYCSOAYzjorp3lrzfE8Uxbu/rX1i3a
        0zu0/3HdyJeUZ5HbqWmDj7ST8F0MtYd+Ul5yMvIlENby
X-Google-Smtp-Source: ABdhPJwgG0vwT1Nd38BsG2J0TkI0lnwa5FvHObDl/uiKVC1VVmZjq7CpDTE/AGUHSJa8AYcXtYEPgszoAHv45Phr1Dg=
X-Received: by 2002:a5d:841a:: with SMTP id i26mr2614187ion.144.1597283717246;
 Wed, 12 Aug 2020 18:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com> <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
In-Reply-To: <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Thu, 13 Aug 2020 11:55:06 +1000
Message-ID: <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>
> s390x has the notion of providing VFs to the kernel in a manner
> where the associated PF is inaccessible other than via firmware.
> These are not treated as typical VFs and access to them is emulated
> by underlying firmware which can still access the PF.  After
> abafbc55 however these detached VFs were no longer able to work
> with vfio-pci as the firmware does not provide emulation of the
> PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
> these detached VFs so that vfio-pci can allow memory access to
> them again.

Hmm, cool. I think we have a similar feature on pseries so that's
probably broken too.

> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c                |  8 ++++++++
>  drivers/vfio/pci/vfio_pci_config.c | 11 +++++++----
>  include/linux/pci.h                |  1 +
>  3 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 3902c9f..04ac76d 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>  {
>         struct zpci_dev *zdev = to_zpci(pdev);
>
> +       /*
> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
> +        * detached from its parent PF.  We rely on firmware emulation to
> +        * provide underlying PF details.
> +        */
> +       if (zdev->vfn && !zdev->zbus->multifunction)
> +               pdev->detached_vf = 1;

The enable hook seems like it's a bit too late for this sort of
screwing around with the pci_dev. Anything in the setup path that
looks at ->detached_vf would see it cleared while anything that looks
after the device is enabled will see it set. Can this go into
pcibios_add_device() or a fixup instead?
