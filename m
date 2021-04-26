Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A1036B493
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhDZOPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:15:13 -0400
Received: from verein.lst.de ([213.95.11.211]:41447 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhDZOPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:15:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BD8EF68C4E; Mon, 26 Apr 2021 16:14:29 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:14:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/12] vfio/mdev: Remove mdev_parent_ops dev_attr_groups
Message-ID: <20210426141429.GG15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <9-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 08:03:06PM -0300, Jason Gunthorpe wrote:
> This is only used by one sample to print a fixed string that is pointless.
> 
> In general, having a device driver attach sysfs attributes to the parent
> is horrific. This should never happen, and always leads to some kind of
> liftime bug as it become very difficult for the sysfs attribute to go back
> to any data owned by the device driver.
> 
> Remove the general mechanism to create this abuse.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
