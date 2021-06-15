Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5718F3A81F8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhFOOMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFOOMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976D06140B;
        Tue, 15 Jun 2021 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623766192;
        bh=bvj81Bgsko3aki1RHrDsNK91qLZ/GZamekNSHfl2XIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDHkZeNwAKdMR7sK0vdZLfep7VHmvY21n7IUJ9zZ7rapcn9ECK4Ntgm8P4AqCGMS0
         BNTFpLHqqQ+tIXfFmuWIC7s1hCGXnyfkj7WfuTi37mfXGhly5iWPYZs36/YKDSj9/J
         Jhw3MQjOOIkQuJhRYoW9CQmzyAhJkWqOhM1Bk/uM=
Date:   Tue, 15 Jun 2021 16:09:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 02/10] driver core: Better distinguish probe errors in
 really_probe
Message-ID: <YMi0rue4XjEQmgnL@kroah.com>
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133519.754763-3-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 03:35:11PM +0200, Christoph Hellwig wrote:
> really_probe tries to special case errors from ->probe, but due to all
> other initialization added to the function over time now a lot of
> internal errors hit that code path as well.  Untangle that by adding
> a new probe_err local variable and apply the special casing only to
> that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
