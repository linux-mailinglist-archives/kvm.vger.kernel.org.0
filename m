Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18BC42DA9B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhJNNkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJNNkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 09:40:00 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F66C061570;
        Thu, 14 Oct 2021 06:37:55 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id g6so14784402ybb.3;
        Thu, 14 Oct 2021 06:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mbgbRDUeTUyS3975uv27h+b+4eQcagHBtAm3RK4mRio=;
        b=qmgCJ42kSkaSCiL62fmwk8FsRJIapU+OyGgWdYII3UdkitX2WzArrncotTqg2AMWP0
         tJn0um3amoXF4I8vJD1Gm0tC7yXR4EngdB5ocSqgTPTbXIaB+fnG58LSf7RLMnQBzf1o
         z5yvWN45Q6V9P/BvsOFitjrxatZlY+KCTvobsEjqcSxLccUMujwMzKD7GZ3/jAyjD0rA
         IcNDxlgHXfWjYBOvCk8+FzhR7oYgbLyYir1Z7NnkAZgcOL+TZNEkXO591wErvff824dT
         6nYXeuCj1OoZt5KJnveH/c20k6SoYi9KwO427Jk5jAa7RO6MEk9ZzrGA88gMzFkMBuSt
         UZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mbgbRDUeTUyS3975uv27h+b+4eQcagHBtAm3RK4mRio=;
        b=h0NfnWwRwNJKRO56vm4NmoblAyhy65vzCL7jHUYgWmmmjcPJT+d+v0VOqdfPTlZx1W
         KLNm2K+3oOUAJenh8dErWka805TJKNfkT4nY+9Rb0vM7lWEEKJqb3oG+j/Px9WbzfxK6
         5tAWnxth/mYAqD7a2eDxtE1X6PJr8nQwVMbtQagmTTwMgy9xbrlPhEs9gR20Iohzsm9O
         52Y7+qX806svSWPWXQe2W6tNaMCmeXPc59XFaMUI17ykgHjKGDTOusnmPdasEX0r0ftB
         8heapT/6rmaeAaUKFbezK8C6TfnriCyjmAj3oDkaqlVeCwRBjKBHSKw3l9jBO0dTokNR
         axng==
X-Gm-Message-State: AOAM532eJaHkjvEEe8h1j+XMIIs4y+yZO2pNW24PFArq+X9aDXZgiBBB
        V/aOTKAJb1DvQCbZi2I7k0diJ0Sz9fI5/1Tm8rKZavNvIs4=
X-Google-Smtp-Source: ABdhPJy6Sv53mPNnZ5/+mRm4KMI0WKd6yX7MOv3xDgif+E5itNFVclj9SpKfoLun8XE+5eCELmXumiZ5Rw/DTmXETFY=
X-Received: by 2002:a25:ace0:: with SMTP id x32mr6550218ybd.142.1634218675130;
 Thu, 14 Oct 2021 06:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211014095748.84604-1-yaozhenguo1@gmail.com> <20211014064824.66c90ee5.alex.williamson@redhat.com>
In-Reply-To: <20211014064824.66c90ee5.alex.williamson@redhat.com>
From:   Zhenguo Yao <yaozhenguo1@gmail.com>
Date:   Thu, 14 Oct 2021 21:37:44 +0800
Message-ID: <CA+WzARn6r3qduRpyjaPGkrt7EeUwDPSCJiCQ62t4MtPg=DMRqw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Add ablility of VFIO driver to ignore reset when
 device don't need it
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, cohuck@redhat.com,
        jgg@ziepe.ca, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?5aea5oyv5Zu9?= <yaozhenguo@jd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OK.  Thank you.  Let's waitting for NVIDIA's solution.

Alex Williamson <alex.williamson@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=
=8814=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=888:48=E5=86=99=E9=81=93=
=EF=BC=9A
>
> On Thu, 14 Oct 2021 17:57:46 +0800
> Zhenguo Yao <yaozhenguo1@gmail.com> wrote:
>
> > In some scenarios, vfio device can't do any reset in initialization
> > process. For example: Nvswitch and GPU A100 working in Shared NVSwitch
> > Virtualization Model. In such mode, there are two type VMs: service
> > VM and Guest VM. The GPU devices are initialized in the following steps=
:
> >
> > 1. Service VM boot up. GPUs and Nvswitchs are passthrough to service VM=
.
> > Nvidia driver and manager software will do some settings in service VM.
> >
> > 2. The selected GPUs are unpluged from service VM.
> >
> > 3. Guest VM boots up with the selected GPUs passthrough.
> >
> > The selected GPUs can't do any reset in step3, or they will be initiali=
zed
> > failed in Guest VM.
> >
> > This patchset add a PCI sysfs interface:ignore_reset which drivers can
> > use it to control whether to do PCI reset or not. For example: In Share=
d
> > NVSwitch Virtualization Model. Hypervisor can disable PCI reset by sett=
ing
> > ignore_reset to 1 before Gust VM booting up.
> >
> > Zhenguo Yao (2):
> >   PCI: Add ignore_reset sysfs interface to control whether do device
> >     reset in PCI drivers
> >   vfio-pci: Don't do device reset when ignore_reset is setting
> >
> >  drivers/pci/pci-sysfs.c          | 25 +++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++------------
> >  include/linux/pci.h              |  1 +
> >  3 files changed, 56 insertions(+), 18 deletions(-)
> >
>
> This all seems like code to mask that these NVSwitch configurations are
> probably insecure because we can't factor and manage NVSwitch isolation
> into IOMMU grouping.  I'm guessing this "service VM" pokes proprietary
> registers to manage that isolation and perhaps later resetting devices
> negates that programming.  A more proper solution is probably to do our
> best to guess the span of an NVSwitch configuration and make the IOMMU
> group include all the devices, until NVIDIA provides proper code for
> the kernel to understand this interconnect and how it affects DMA
> isolation.  Nak on disabling resets for the purpose of preventing a
> user from undoing proprietary device programming.  Thanks,
>
> Alex
>
