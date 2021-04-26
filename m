Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE4136B4C3
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhDZOVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:21:40 -0400
Received: from verein.lst.de ([213.95.11.211]:41479 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZOVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:21:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 26D8D68C4E; Mon, 26 Apr 2021 16:20:57 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:20:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 12/12] vfio/mdev: Remove mdev drvdata
Message-ID: <20210426142056.GJ15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <12-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 08:03:09PM -0300, Jason Gunthorpe wrote:
> This is no longer used, remove it.
> 
> All usages were moved over to either use container_of() from a vfio_device
> or to use dev_drvdata() directly on the mdev.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
