Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44523B3923
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhFXWZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232695AbhFXWZB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 18:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624573361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g477a7vYcPKjBKrDFYuYGrViI13ze8NFDaxSg09H1cQ=;
        b=blzGO7Mc2N0KfoAe42UCZSsezRwg2hSh+emUgx9PyZEgEoRcxNJGD1YOuq06WnlUrhdhUS
        xdAlKK3gWsrtdbmEpM/nfd7X+u3MLwo4eO7FxjQITltFG7p402z1f5km0uFJOEsKa7sa5m
        NFt+N2UATNWBWDQXm0vglVJlfsxYn7c=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-J-9gaePcOie4pTSAdpC39w-1; Thu, 24 Jun 2021 18:22:37 -0400
X-MC-Unique: J-9gaePcOie4pTSAdpC39w-1
Received: by mail-oo1-f71.google.com with SMTP id q3-20020a4aa3030000b029024b18087470so4586893ool.5
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 15:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g477a7vYcPKjBKrDFYuYGrViI13ze8NFDaxSg09H1cQ=;
        b=TfZQbSsqQremv8+mBmSYG40W65nYpZv/JRfa9x4KB/cZ2HCzRuoir9YQDYhTmZYRGJ
         g0PPh6bKr2WAC99BhUD31qZwj4OWAO7IJ2s3pIwgxiqXX/ENku68JwdOnFKph6fWe+F7
         wMy42OpTrvOFhhCW3DVJgnnzWUDvu8/ai055I9cwxSzNGNRNAKzNGJNfaO+7KdEXm/xL
         uX8qN10HXosXsasIbZNzpr8iHB7qTTnhbDO2+x2EqxwjMXZNnniNnbirNE7OFK6JJKLn
         Pa4zt++V0Y1QWCWTcYS50LKtJl/pRsrciAxx/UInNjYsi0qozgBgZL6Ir5iDz7FDf+0B
         01+A==
X-Gm-Message-State: AOAM532u2zBJhvM3klz9/WdFRIb0f3C4nBTsDuIUzo9u/WyyP+qsc5kz
        E2D0wYic0n22lGcSrfBaNjrh5SysO/IOmfe9gs8Pk/gOLE9vbui2VqjVMl+CcLBG/CZZ0v5kepS
        Me3MZbZRkxsaw
X-Received: by 2002:aca:3047:: with SMTP id w68mr1880001oiw.6.1624573357104;
        Thu, 24 Jun 2021 15:22:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBPANrb92It2A02MpQuIyUGqsZj+J9hwey1ULiCLGhpflsYkKlL9h3yl020Nq3skcI4zeyXA==
X-Received: by 2002:aca:3047:: with SMTP id w68mr1879989oiw.6.1624573356916;
        Thu, 24 Jun 2021 15:22:36 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id s4sm502047oou.43.2021.06.24.15.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 15:22:36 -0700 (PDT)
Date:   Thu, 24 Jun 2021 16:22:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH] vfio/pci: Document the MSI[X] resize side effects
 properly
Message-ID: <20210624162234.6476712c.alex.williamson@redhat.com>
In-Reply-To: <87im23bh72.ffs@nanos.tec.linutronix.de>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
        <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
        <20210623091935.3ab3e378.alex.williamson@redhat.com>
        <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
        <87mtrgatqo.ffs@nanos.tec.linutronix.de>
        <20210623204828.2bc7e6dc.alex.williamson@redhat.com>
        <87im23bh72.ffs@nanos.tec.linutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Jun 2021 14:06:09 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The documentation of VFIO_IRQ_INFO_NORESIZE is inaccurate as it suggests
> that it is safe to dynamically add new MSI-X vectors even when
> previously allocated vectors are already in use and enabled.
> 
> Enabling additional vectors is possible according the MSI-X specification,
> but the kernel does not have any mechanisms today to do that safely.
> 
> The only available mechanism is to teardown the already active vectors
> and to setup the full vector set afterwards.
> 
> This requires to temporarily disable MSI-X which redirects any interrupt
> raised by the device during this time to the legacy PCI/INTX which is
> not handled and the interrupt is therefore lost.
> 
> Update the documentation of VFIO_IRQ_INFO_NORESIZE accordingly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/uapi/linux/vfio.h |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -699,10 +699,19 @@ struct vfio_region_info_cap_nvlink2_lnks
>   * disabling the entire index.  This is used for interrupts like PCI MSI
>   * and MSI-X where the driver may only use a subset of the available
>   * indexes, but VFIO needs to enable a specific number of vectors
> - * upfront.  In the case of MSI-X, where the user can enable MSI-X and
> - * then add and unmask vectors, it's up to userspace to make the decision
> - * whether to allocate the maximum supported number of vectors or tear
> - * down setup and incrementally increase the vectors as each is enabled.
> + * upfront.
> + *
> + * MSI cannot be resized safely when interrupts are in use already because
> + * resizing requires temporary disablement of MSI for updating the relevant
> + * PCI config space entries. Disabling MSI redirects an interrupt raised by
> + * the device during this time to the unhandled legacy PCI/INTX, which
> + * means the interrupt is lost.
> + *
> + * Enabling additional vectors for MSI-X is possible at least from the
> + * perspective of the MSI-X specification, but not supported by the
> + * exisiting PCI/MSI-X mechanisms in the kernel. The kernel provides
> + * currently only a full teardown/setup cycle which requires to disable
> + * MSI-X temporarily with the same side effects as for MSI.
>   */
>  struct vfio_irq_info {
>  	__u32	argsz;
> 

There's good information here, but as per my other reply I think
NORESIZE might be only a host implementation issue for both MSI and
MSI/X.

I'd also rather not focus on that existing implementation in this
header, which is essentially the uAPI spec, because that implementation
can change and we're unlikely to remember to update the description
here.  We might even be describing a device that emulates MSI/X in some
way that it's not bound by this limitation.  For example maybe Intel's
emulation of MSI-X backed by IMS wouldn't need this flag and we could
update QEMU to finally have a branch that avoids the teardown/setup.
We have a flag to indicate this behavior, consequences should be
relative to the presence of that flag.

Finally a nit, I don't really see a strong case that the existing text
is actually inaccurate or implying some safety against lost interrupts.
It's actually making note of the issue here already, though the more
explicit description is welcome.  Thanks,

Alex

