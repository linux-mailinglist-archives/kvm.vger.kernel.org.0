Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB13A7666
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 07:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFOFW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 01:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhFOFWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 01:22:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFAD613F5;
        Tue, 15 Jun 2021 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623734421;
        bh=s6xYPmSy+OD/HC3bvosyPFKtWJM7qQtPwUKU0uQGXWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k/KzRFX98rFyAH32IPZQiP3hWvx62edvCWGk4Fvk3561qwAL6DGXroBsfc+6DOWb9
         UkeIASamFm6Ptq87jRBsD6/xlyJdMNZDTku67SBvaFNfSXviqyyK0FbFV5PnXrIwwZ
         TSk35PubERUvp9O6SHTqLEB9SaND/X/4r0b3bYVc=
Date:   Tue, 15 Jun 2021 07:20:17 +0200
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
Subject: Re: [PATCH 05/10] driver core: Export device_driver_attach()
Message-ID: <YMg4kWmfahnzjWsP@kroah.com>
References: <20210614150846.4111871-1-hch@lst.de>
 <20210614150846.4111871-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614150846.4111871-6-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 05:08:41PM +0200, Christoph Hellwig wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> This is intended as a replacement API for device_bind_driver(). It has at
> least the following benefits:
> 
> - Internal locking. Few of the users of device_bind_driver() follow the
>   locking rules
> 
> - Calls device driver probe() internally. Notably this means that devm
>   support for probe works correctly as probe() error will call
>   devres_release_all()
> 
> - struct device_driver -> dev_groups is supported
> 
> - Simplified calling convention, no need to manually call probe().
> 
> The general usage is for situations that already know what driver to bind
> and need to ensure the bind is synchronized with other logic. Call
> device_driver_attach() after device_add().
> 
> If probe() returns a failure then this will be preserved up through to the
> error return of device_driver_attach().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
