Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38233D8E5D
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhG1MzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:55:16 -0400
Received: from verein.lst.de ([213.95.11.211]:53593 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235098AbhG1MzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:55:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2C6AD68AFE; Wed, 28 Jul 2021 14:55:07 +0200 (CEST)
Date:   Wed, 28 Jul 2021 14:55:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728125505.GA29082@lst.de>
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com> <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com> <20210728054306.GA3421@lst.de> <20210728120326.GQ1721383@nvidia.com> <20210728122956.GA27111@lst.de> <20210728124755.GR1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728124755.GR1721383@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:47:55AM -0300, Jason Gunthorpe wrote:
> So then we can write it like below?

> +if PCI || MMU

The || here should be &&.  But otherwise, yes.

> Unfortunately it deletes the nice
> menu structure that groups all the PCI drivers together like platform
> (and mdev in future). Not sure this loss is worth the backwards compat

All the ther visible options should depend on VFIO_PCI not VFIO_PCI_CORE.
So we can still keep the same menu struture.

