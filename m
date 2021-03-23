Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8276C3468C8
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhCWTRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:17:01 -0400
Received: from verein.lst.de ([213.95.11.211]:33886 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233331AbhCWTQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:16:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E082568BFE; Tue, 23 Mar 2021 20:16:33 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:16:33 +0100
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
Subject: Re: [PATCH 06/18] vfio/mdev: Expose mdev_get/put_parent to
 mdev_private.h
Message-ID: <20210323191633.GD17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:55:23PM -0300, Jason Gunthorpe wrote:
> The next patch will use these in mdev_sysfs.c
> 
> While here remove the now dead code checks for NULL, a mdev_type can never
> have a NULL parent.

I'd normally just move that into the patch that uses it, but the
mechanical change looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
