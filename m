Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0822433ADD5
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 09:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhCOIo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 04:44:59 -0400
Received: from verein.lst.de ([213.95.11.211]:52900 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCOIo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 04:44:29 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 165CA68C4E; Mon, 15 Mar 2021 09:44:28 +0100 (CET)
Date:   Mon, 15 Mar 2021 09:44:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 06/14] vfio/fsl-mc: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210315084427.GB29269@lst.de>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com> <6-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 08:55:58PM -0400, Jason Gunthorpe wrote:
> fsl-mc already allocates a struct vfio_fsl_mc_device with exactly the same
> lifetime as vfio_device, switch to the new API and embed vfio_device in
> vfio_fsl_mc_device. While here remove the devm usage for the vdev, this
> code is clean and doesn't need devm.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
