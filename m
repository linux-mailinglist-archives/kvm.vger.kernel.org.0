Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE0A2EC0C9
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 17:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbhAFQCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 11:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbhAFQCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 11:02:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEE4F23130;
        Wed,  6 Jan 2021 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609948922;
        bh=Bj3wP943wNO3hXxH8XiZsDzLprL5iIOMpywhWsXIvV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K0vJgR5eGuTZh7qe6YrDaTPEpiiZunQ/FLQ8x1xdI9GyWnqnRZbP4JkhY5fxhJW+t
         wbsvUXM3/MYOcy13+sl0KjV1FENQ4tuJsCfJ5JY97u3GPyOegJKyCFGx72KCrNaIan
         5+GbITivVTmMxxVMiwRa3f2MHlElL3FyPXij96T/4/OHx9Xx80odwO+bTIKHnW43sm
         0+Gq6d7p+ifeq2/6+ZP5vnRPNnRd1rOsNPUlHh4pnUkb4lMfLLnft6TQhoY/LxW1fD
         t8NqtmhV4M33/thTKNO5pEIUj6RgeAXokjg+hLrZag8qmv4TkIZtfEovzqB1ur9Jnh
         yb355h1ZTmb1g==
Date:   Wed, 6 Jan 2021 18:01:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>, tglx@linutronix.de,
        ashok.raj@intel.com, kevin.tian@intel.com, dave.jiang@intel.com,
        megha.dey@intel.com, dwmw2@infradead.org,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        eric.auger@redhat.com, jacob.jun.pan@intel.com,
        kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v2 1/1] platform-msi: Add platform check for
 subdevice irq domain
Message-ID: <20210106160158.GX31158@unreal>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal>
 <20210106152339.GA552508@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106152339.GA552508@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:
>
> > I asked what will you do when QEMU will gain needed functionality?
> > Will you remove QEMU from this list? If yes, how such "new" kernel will
> > work on old QEMU versions?
>
> The needed functionality is some VMM hypercall, so presumably new
> kernels that support calling this hypercall will be able to discover
> if the VMM hypercall exists and if so superceed this entire check.

Let's not speculate, do we have well-known path?
Will such patch be taken to stable@/distros?

Thanks

>
> Jason
