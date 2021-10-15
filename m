Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8561742F205
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbhJONXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 09:23:02 -0400
Received: from verein.lst.de ([213.95.11.211]:54487 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJONXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 09:23:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CAF168BFE; Fri, 15 Oct 2021 15:20:52 +0200 (CEST)
Date:   Fri, 15 Oct 2021 15:20:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/5] Update vfio_group to use the modern cdev
 lifecycle
Message-ID: <20211015132052.GA29841@lst.de>
References: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 08:40:49AM -0300, Jason Gunthorpe wrote:
> This builds on Christoph's work to revise how the vfio_group works and is
> against the latest VFIO tree.

Which already is in vfio/next now, btw.
