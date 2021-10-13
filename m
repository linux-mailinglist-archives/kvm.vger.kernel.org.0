Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5BF42C5C2
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhJMQGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:06:17 -0400
Received: from verein.lst.de ([213.95.11.211]:46410 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhJMQGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 12:06:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F3EBF68B05; Wed, 13 Oct 2021 18:04:10 +0200 (CEST)
Date:   Wed, 13 Oct 2021 18:04:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Message-ID: <20211013160410.GA1327@lst.de>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com> <1-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
