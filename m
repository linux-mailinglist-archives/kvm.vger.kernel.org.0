Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18942C5E7
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhJMQMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:12:32 -0400
Received: from verein.lst.de ([213.95.11.211]:46452 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234988AbhJMQMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 12:12:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BB1A68B05; Wed, 13 Oct 2021 18:10:26 +0200 (CEST)
Date:   Wed, 13 Oct 2021 18:10:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Message-ID: <20211013161026.GD1327@lst.de>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com> <4-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 11:27:49AM -0300, Jason Gunthorpe wrote:
> The next patch adds a struct device to the struct vfio_group, and it is
> confusing/bad practice to have two krefs in the same struct. This kref is
> controlling the period when the vfio_group is registered in sysfs, and
> visible in the internal lookup. Switch it to a refcount_t instead.
> 
> The refcount_dec_and_mutex_lock() is still required because we need
> atomicity of the list searches and sysfs presence.
> 
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
