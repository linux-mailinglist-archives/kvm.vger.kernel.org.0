Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD23421FD
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCSQfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:35:16 -0400
Received: from verein.lst.de ([213.95.11.211]:46929 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCSQey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:34:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3ED7B68C65; Fri, 19 Mar 2021 17:34:50 +0100 (CET)
Date:   Fri, 19 Mar 2021 17:34:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319163449.GA19186@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com> <20210309083357.65467-9-mgurtovoy@nvidia.com> <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru> <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com> <20210319092341.14bb179a@omen.home.shazbot.org> <20210319161722.GY2356281@nvidia.com> <20210319162033.GA18218@lst.de> <20210319162848.GZ2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319162848.GZ2356281@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:
> The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> as a universal "default" within the driver core lazy bind scheme and
> still have working module autoloading... I'm hoping to get some
> research into this..

Should we even load it by default?  One answer would be that the sysfs
file to switch to vfio mode goes into the core PCI layer, and that core
PCI code would contain a hack^H^H^H^Hhook to first load and bind vfio_pci
for that device.
