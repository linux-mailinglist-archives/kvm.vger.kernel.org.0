Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41A02ECA5E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 07:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbhAGGKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 01:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbhAGGKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 01:10:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A85C122E00;
        Thu,  7 Jan 2021 06:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609999760;
        bh=azMCNDuhleHdkWuj5ghRek+hs2L4YJMzasQokmJS3f4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8XG4po+R+2ujO3Y3ib4/2LENKfD9oBEAxhEM99mJwydTyIvNu/NZVVdq5A2A+h2W
         k+pr+erNProR3XWHKdM50a26SA5otfCx2Ats+WEps8m41eqxp+rkTKbR/H7GmKR2Ko
         oGweSuLabtC9JzF6W5IRHnelrMDeM5JRZGgxKaOERTnyaQusdakAJpEkdwwVvm49JN
         6voYxPoDFOKK0XPTvN6Sha/PYhzXV/sfamKmjl6VZ+EUGbKl8YwzgRrimbq+jHdNS6
         P1PJROd9CdC5SVojxjMmosd/mMs2yGs3ac6Hr1jOVzbzN0Cy8JuSl7BG7gt/4sniq4
         0NvWPUJkOpo6A==
Date:   Thu, 7 Jan 2021 08:09:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH v2 1/1] platform-msi: Add platform check for
 subdevice irq domain
Message-ID: <20210107060916.GY31158@unreal>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal>
 <20210106152339.GA552508@nvidia.com>
 <20210106160158.GX31158@unreal>
 <MWHPR11MB18867EE2F4FA0382DCFEEE2B8CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18867EE2F4FA0382DCFEEE2B8CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 02:04:29AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, January 7, 2021 12:02 AM
> >
> > On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:
> > >
> > > > I asked what will you do when QEMU will gain needed functionality?
> > > > Will you remove QEMU from this list? If yes, how such "new" kernel will
> > > > work on old QEMU versions?
> > >
> > > The needed functionality is some VMM hypercall, so presumably new
> > > kernels that support calling this hypercall will be able to discover
> > > if the VMM hypercall exists and if so superceed this entire check.
> >
> > Let's not speculate, do we have well-known path?
> > Will such patch be taken to stable@/distros?
> >
>
> There are two functions introduced in this patch. One is to detect whether
> running on bare metal or in a virtual machine. The other is for deciding
> whether the platform supports ims. Currently the two are identical because
> ims is supported only on bare metal at current stage. In the future it will look
> like below when ims can be enabled in a VM:
>
> bool arch_support_pci_device_ims(struct pci_dev *pdev)
> {
> 	return on_bare_metal() || hypercall_irq_domain_supported();
> }
>
> The VMM vendor list is for on_bare_metal, and suppose a vendor will
> never be removed once being added to the list since the fact of running
> in a VM never changes, regardless of whether this hypervisor supports
> extra VMM hypercalls.

This is what I imagined, this list will be forever, and this worries me.

I don't know if it is true or not, but guess that at least Oracle and
Microsoft bare metal devices and VMs will have same DMI_SYS_VENDOR.

It means that this on_bare_metal() function won't work reliably in many
cases. Also being part of include/linux/msi.h, at some point of time,
this function will be picked by the users outside for the non-IMS cases.

I didn't even mention custom forks of QEMU which are prohibited to change
DMI_SYS_VENDOR and private clouds with custom solutions.

The current array makes DMI_SYS_VENDOR interface as some sort of ABI. If in the future,
the QEMU will decide to use more hipster name, for example "qEmU", this function
won't work.

I'm aware that DMI_SYS_VENDOR is used heavily in the kernel code and
various names for the same company are good example how not reliable it.

The most hilarious example is "Dell/Dell Inc./Dell Inc/Dell Computer Corporation/Dell Computer",
but other companies are not far from them.

Luckily enough, this identification is used for hardware product that
was released to the market and their name will be stable for that
specific model. It is not the case here where we need to ensure future
compatibility too (old kernel on new VM emulator).

I'm not in position to say yes or no to this patch and don't have plans to do it.
Just expressing my feeling that this solution is too hacky for my taste.

Thanks
