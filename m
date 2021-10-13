Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5304242C5CD
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhJMQHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:07:17 -0400
Received: from verein.lst.de ([213.95.11.211]:46416 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhJMQHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 12:07:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D0A5E68B05; Wed, 13 Oct 2021 18:05:11 +0200 (CEST)
Date:   Wed, 13 Oct 2021 18:05:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 2/5] vfio: Do not open code the group list search in
 vfio_create_group()
Message-ID: <20211013160511.GB1327@lst.de>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com> <2-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 11:27:47AM -0300, Jason Gunthorpe wrote:
> Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu() so
> that vfio_create_group() can call it to consolidate this duplicated code.
> 
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com> (✓ DKIM/intel.onmicrosoft.com)
> Reviewed-by: Kevin Tian <kevin.tian@intel.com> (✓ DKIM/intel.onmicrosoft.com)

These Reviewed-by line look strange.

The actual code changes looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
