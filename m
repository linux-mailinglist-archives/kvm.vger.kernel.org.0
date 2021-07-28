Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF73D873A
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 07:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhG1FnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 01:43:12 -0400
Received: from verein.lst.de ([213.95.11.211]:52388 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhG1FnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 01:43:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D0E1267357; Wed, 28 Jul 2021 07:43:06 +0200 (CEST)
Date:   Wed, 28 Jul 2021 07:43:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728054306.GA3421@lst.de>
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com> <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727230941.GL1721383@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 08:09:41PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 27, 2021 at 03:54:40PM -0600, Alex Williamson wrote:
> 
> > I'm still not happy with how this is likely to break users and even
> > downstreams when upgrading to a Kconfig with this change.
> 
> I've never heard of Kconfig as stable ABI. Christoph/Arnd, have you
> heard of any cases where we want to keep it stable?

It isn't an ABI, but we really do try to avoid breaking if we can and
I rember Linus shouting at people if they did that for common options.

However lately for example the completely silly s/THUNDERBOLT/USB4/
change did slip through and did break my test setup with a vfio passed
through external nvme drive :(

> Which might reasonably be from an old kernel. 'make oldconfig' prompts:
> 
> VFIO Non-Privileged userspace driver framework (VFIO) [Y/n/m/?] y
>   VFIO No-IOMMU support (VFIO_NOIOMMU) [Y/n/?] y
>   VFIO support for PCI devices (VFIO_PCI_CORE) [N/m/y/?] (NEW) 
> 
> Which is completely fine, IMHO.

Why do we need to have VFIO_PCI_CORE as a user visible option?
I'd just select it.
