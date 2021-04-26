Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B795436B47F
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhDZOHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:07:14 -0400
Received: from verein.lst.de ([213.95.11.211]:41403 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhDZOHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:07:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9D08568C4E; Mon, 26 Apr 2021 16:06:29 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:06:29 +0200
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
Subject: Re: [PATCH 04/12] vfio/mdpy: Convert to use
 vfio_register_group_dev()
Message-ID: <20210426140629.GC15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <4-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 08:03:01PM -0300, Jason Gunthorpe wrote:
> This is straightforward conversion, the mdev_state is actually serving as
> the vfio_device and we can replace all the mdev_get_drvdata()'s and the
> wonky dead code with a simple container_of().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
