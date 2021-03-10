Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85633336F8
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCJIJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:09:01 -0500
Received: from verein.lst.de ([213.95.11.211]:35036 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231378AbhCJIIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:08:45 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 92AAC68B05; Wed, 10 Mar 2021 09:08:42 +0100 (CET)
Date:   Wed, 10 Mar 2021 09:08:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     jgg@nvidia.com, alex.williamson@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com, aik@ozlabs.ru, hch@lst.de
Subject: Re: [PATCH 7/9] vfio/pci_core: split nvlink2 to nvlink2gpu and npu2
Message-ID: <20210310080842.GA4364@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com> <20210309083357.65467-8-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309083357.65467-8-mgurtovoy@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 08:33:55AM +0000, Max Gurtovoy wrote:
> This is a preparation for moving vendor specific code from
> vfio_pci_core to vendor specific vfio_pci drivers. The next step will be
> creating a dedicated module to NVIDIA NVLINK2 devices with P9 extensions
> and a dedicated module for Power9 NPU NVLink2 HBAs.

As said before - this driver always failed the "has open source user space"
(which in this kind could also kernelspace in a VM) support and should
just be removed entirely, including all the cruft for it in arch/powerpc.
