Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022401046E4
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 00:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKTXSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 18:18:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33928 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTXSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 18:18:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so574547plr.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 15:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wmtUR/eihp0PUvrLKsh7wVU4zqxo6xGU5zxiqoarIqE=;
        b=p2G0T3jgz6bXlwZjpvll8ad4xuXJX1PCwdWxV8mTLvBJNPr+A4y10oHp5zDr6t54Gf
         OfkS1NHrAugnkuzwclxNLuUBWLWtzXNz8Wc3MIeSzZnkIq5iaOtYYyUgbVgQD+FuTE3n
         vAb8kgLCoKm88R10sL9ltWOieO97SxL3GSvsUulumE7DsE3/qlgX2r42bt/j++O0CMZI
         bsHmNccOcon35TsSaHwNyZqRaB9sJz0mQ/8GERZLG/AXV0DHuNK629sQI5t9pDTiMolD
         q+y18tonjpHPNI6wvnGPATDieKBUb9XPD946HsDG+h8w8xcSRjjCoiuNnfKMwS0X1xMk
         ItCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wmtUR/eihp0PUvrLKsh7wVU4zqxo6xGU5zxiqoarIqE=;
        b=ccx2Ja2CuY8Wlwhj3ZzvcNIu/KH4Ej58ldknoqhHOYQhZYpom35nze6+9uPya5lGpv
         jf67lvZWFy3eR396iLZsI/XPuO4YoLGYb5q5+qqdG5bGAKj46wj7fQ95g7mOIoCgZaR2
         aRBD7VLfJDpwAuKWnQylM23aINTQY+/osErx4JBbqWRiz2MQo0BPkJff15NUCPFyztOO
         KQo4EK8dvuZpx1VgvW+Fyq6Cve74aS9dijNzbpm3gAA1EOwJDGGZ8NPFEBOq0C0F7nG6
         0vUN1F83rZpWwr3Sdfejfv5Syft/CfqGi5K3G1B2rdA7afiWMOM1RwiKLvq6q2AKb1rG
         iLZg==
X-Gm-Message-State: APjAAAVc/gRrgQxujRsX1ufrzCkl1sxjw7nP+hAHKxW0DO7CKKoeXfLH
        26pY4BKgitAUBZBB5/e2K7TdZg==
X-Google-Smtp-Source: APXvYqw0TaIkfAiYDhUvl10ZLxlCJpmLGUmkEzRbDKn+3bQbVgvytLloXmk3XGGDCqVdvnqHnR4G1A==
X-Received: by 2002:a17:90a:9286:: with SMTP id n6mr6979262pjo.84.1574291917274;
        Wed, 20 Nov 2019 15:18:37 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j21sm485855pfa.58.2019.11.20.15.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 15:18:37 -0800 (PST)
Date:   Wed, 20 Nov 2019 15:18:28 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     <lantianyu1986@gmail.com>, <cohuck@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>, <sashal@kernel.org>,
        <mchehab+samsung@kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <robh@kernel.org>,
        <Jonathan.Cameron@huawei.com>, <paulmck@linux.ibm.com>,
        "Michael Kelley" <mikelley@microsoft.com>,
        "Tianyu Lan" <Tianyu.Lan@microsoft.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, "vkuznets" <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191120151828.2d593b81@hermes.lan>
In-Reply-To: <20191120133147.1d627348@x1.home>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191119165620.0f42e5ba@x1.home>
        <20191120103503.5f7bd7c4@hermes.lan>
        <20191120120715.0cecf5ea@x1.home>
        <20191120114611.4721a7e9@hermes.lan>
        <20191120133147.1d627348@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 13:31:47 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 20 Nov 2019 11:46:11 -0800
> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> > On Wed, 20 Nov 2019 12:07:15 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Wed, 20 Nov 2019 10:35:03 -0800
> > > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > >     
> > > > On Tue, 19 Nov 2019 15:56:20 -0800
> > > > "Alex Williamson" <alex.williamson@redhat.com> wrote:
> > > >       
> > > > > On Mon, 11 Nov 2019 16:45:07 +0800
> > > > > lantianyu1986@gmail.com wrote:
> > > > >         
> > > > > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > > > > > 
> > > > > > This patch is to add VFIO VMBUS driver support in order to expose
> > > > > > VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> > > > > > DPDK now has netvsc PMD driver support and it may get VMBUS resources
> > > > > > via VFIO interface with new driver support.
> > > > > > 
> > > > > > So far, Hyper-V doesn't provide virtual IOMMU support and so this
> > > > > > driver needs to be used with VFIO noiommu mode.          
> > > > > 
> > > > > Let's be clear here, vfio no-iommu mode taints the kernel and was a
> > > > > compromise that we can re-use vfio-pci in its entirety, so it had a
> > > > > high code reuse value for minimal code and maintenance investment.  It
> > > > > was certainly not intended to provoke new drivers that rely on this mode
> > > > > of operation.  In fact, no-iommu should be discouraged as it provides
> > > > > absolutely no isolation.  I'd therefore ask, why should this be in the
> > > > > kernel versus any other unsupportable out of tree driver?  It appears
> > > > > almost entirely self contained.  Thanks,
> > > > > 
> > > > > Alex        
> > > > 
> > > > The current VMBUS access from userspace is from uio_hv_generic
> > > > there is (and will not be) any out of tree driver for this.      
> > > 
> > > I'm talking about the driver proposed here.  It can only be used in a
> > > mode that taints the kernel that its running on, so why would we sign
> > > up to support 400 lines of code that has no safe way to use it?
> > >      
> > > > The new driver from Tianyu is to make VMBUS behave like PCI.
> > > > This simplifies the code for DPDK and other usermode device drivers
> > > > because it can use the same API's for VMBus as is done for PCI.      
> > > 
> > > But this doesn't re-use the vfio-pci API at all, it explicitly defines
> > > a new vfio-vmbus API over the vfio interfaces.  So a user mode driver
> > > might be able to reuse some vfio support, but I don't see how this has
> > > anything to do with PCI.
> > >     
> > > > Unfortunately, since Hyper-V does not support virtual IOMMU yet,
> > > > the only usage modle is with no-iommu taint.      
> > > 
> > > Which is what makes it unsupportable and prompts the question why it
> > > should be included in the mainline kernel as it introduces a
> > > maintenance burden and normalizes a usage model that's unsafe.  Thanks,    
> > 
> > Many existing userspace drivers are unsafe:
> >   - out of tree DPDK igb_uio is unsafe.

> Why is it out of tree?

Agree, it really shouldn't be. The original developers hoped that
VFIO and VFIO-noiommu would replace it. But since DPDK has to run
on ancient distro's and other non VFIO hardware it still lives.

Because it is not suitable for merging for many reasons.
Mostly because it allows MSI and other don't want that.
 
> 
> 
> >   - VFIO with noiommu is unsafe.  
> 
> Which taints the kernel and requires raw I/O user privs.
> 
> >   - hv_uio_generic is unsafe.  
> 
> Gosh, it's pretty coy about this, no kernel tainting, no user
> capability tests, no scary dmesg or Kconfig warnings.  Do users know
> it's unsafe?

It should taint in same way as VFIO with noiommu.
Yes it is documented as unsafe (but not in kernel source).
It really has same unsafeness as uio_pci_generic, and there is not warnings
around that.

> 
> > This new driver is not any better or worse. This sounds like a complete
> > repeat of the discussion that occurred before introducing VFIO noiommu mode.
> > 
> > Shouldn't vmbus vfio taint the kernel in the same way as vfio noiommu does?  
> 
> Yes, the no-iommu interaction happens at the vfio-core level.  I can't
> speak for any of the uio interfaces you mention, but I know that
> uio_pci_generic is explicitly intended for non-DMA use cases and in
> fact the efforts to enable MSI/X support in that driver and the
> objections raised for breaking that usage model by the maintainer, is
> what triggered no-iommu support for vfio.  IIRC, the rationale was
> largely for code reuse both at the kernel and userspace driver level,
> while imposing a minimal burden in vfio-core for this dummy iommu
> driver.  vfio explicitly does not provide a DMA mapping solution for
> no-iommu use cases because I'm not willing to maintain any more lines
> of code to support this usage model.  The tainting imposed by this model
> and incomplete API was intended to be a big warning to discourage its
> use and as features like vIOMMU become more prevalent and bare metal
> platforms without physical IOMMUs hopefully become less prevalent,
> maybe no-iommu could be phased out or removed.

Doing vIOMMU at scale with a non-Linux host, take a a long time.
Tainting doesn't make it happen any sooner. It just makes users
live harder. Sorry blaming the user and giving a bad experience doesn't help anyone.

> You might consider this a re-hashing of those previous discussions, but
> to me it seems like taking advantage of and promoting an interface that
> should have plenty of warning signs that this is not a safe way to use
> the device from userspace.  Without some way to take advantage of the
> code in a safe way, this just seems to be normalizing an unsupportable
> usage model.  Thanks,


The use case for all this stuff has been dedicated infrastructure.
It would be good if security was more baked in but it isn't.
Most users cover it over by either being dedicated applicances
or use LSM to protect UIO.
