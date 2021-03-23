Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA46C3468CD
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhCWTRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:17:35 -0400
Received: from verein.lst.de ([213.95.11.211]:33892 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233375AbhCWTR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:17:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A86D68C4E; Tue, 23 Mar 2021 20:17:26 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:17:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 07/18] vfio/mdev: Add missing reference counting to
 mdev_type
Message-ID: <20210323191726.GE17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:55:24PM -0300, Jason Gunthorpe wrote:
> struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
> but doesn't hold the kref. The lifetime of the parent becomes implicit
> because parent_remove_sysfs_files() is supposed to remove all the access
> before the parent can be freed, but this is very hard to reason about.
> 
> Make it obviously correct by adding the missing get.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
