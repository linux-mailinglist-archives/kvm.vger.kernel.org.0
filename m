Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C59D3A8215
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhFOOOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhFOOOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:14:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F258C613DA;
        Tue, 15 Jun 2021 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623766318;
        bh=jWHpYkMJZInCcjmmHShqhfjCLeTpOdYGCxPkgJO/tEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=raYtjj7GpKZDjIpd+qVmxE8N9NStup2uhnBaVAK+0t4aVIugFqjNKp1Jq+1u16eFn
         KE+STiDwmWf84kr/y7NL7ogNp//9LtscQm9xHoBe8gi1LtjNEeOpRGeKw8cso7xjTK
         Zo0zaOjET7V6Wx7rNC+vmpAU0r9ULN0RRYU2dxw8=
Date:   Tue, 15 Jun 2021 16:11:56 +0200
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
Subject: Re: [PATCH 08/10] vfio/mtty: Convert to use vfio_register_group_dev()
Message-ID: <YMi1LP1itYhFYg9O@kroah.com>
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133519.754763-9-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 03:35:17PM +0200, Christoph Hellwig wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> This is straightforward conversion, the mdev_state is actually serving as
> the vfio_device and we can replace all the mdev_get_drvdata()'s and the
> wonky dead code with a simple container_of()
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  samples/vfio-mdev/mtty.c | 185 ++++++++++++++++++---------------------
>  1 file changed, 83 insertions(+), 102 deletions(-)


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
