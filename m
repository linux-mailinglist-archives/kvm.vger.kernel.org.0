Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B818406A07
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhIJKWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 06:22:16 -0400
Received: from verein.lst.de ([213.95.11.211]:47751 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhIJKWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 06:22:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BAF867357; Fri, 10 Sep 2021 12:21:02 +0200 (CEST)
Date:   Fri, 10 Sep 2021 12:21:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210910102102.GA13722@lst.de>
References: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 02:24:00PM -0300, Jason Gunthorpe wrote:
> Without this call an xarray entry is leaked when the vfio_ap device is
> unprobed. It was missed when the below patch was rebased across the
> dev_set patch.
> 
> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
