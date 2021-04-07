Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD443562E0
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhDGFKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 01:10:05 -0400
Received: from verein.lst.de ([213.95.11.211]:57376 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhDGFKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 01:10:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CBF2A68B02; Wed,  7 Apr 2021 07:09:52 +0200 (CEST)
Date:   Wed, 7 Apr 2021 07:09:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 01/18] vfio/mdev: Fix missing static's on
 MDEV_TYPE_ATTR's
Message-ID: <20210407050952.GA18085@lst.de>
References: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com> <1-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 04:40:24PM -0300, Jason Gunthorpe wrote:
> These should always be prefixed with static, otherwise compilation
> will fail on non-modular builds with
> 
> ld: samples/vfio-mdev/mbochs.o:(.data+0x2e0): multiple definition of `mdev_type_attr_name'; samples/vfio-mdev/mdpy.o:(.data+0x240): first defined here
> 
> Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
> Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
