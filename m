Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B1A36E532
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhD2G5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 02:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhD2G5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 02:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C30F61449;
        Thu, 29 Apr 2021 06:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619679394;
        bh=nVx9mbNtcIxz+6mSyJ5bHl5bB0+psoXrXdhLRNO5wh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BkVwU10m1FF7Foz5ANuGYc4a3NcxqfuxKTMHup/cCM7KHw9CefHsQqHj3TgYyWkhR
         01Cd+hPSoE0nM2v6AHBgGvYRrmwotHJxFWnLlPbnrXoqmzDR9JqKXSDWSsnsywX5vG
         uPa7Su6c5Z1B7OhwFxe9e9XRE4yBhK3tTuBpV3rg=
Date:   Thu, 29 Apr 2021 08:56:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <YIpYnz/isPaXsTYs@kroah.com>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060703.GA4973@lst.de>
 <YIkCVnTFmTHiX3xn@kroah.com>
 <20210428125321.GP1370958@nvidia.com>
 <20210429065315.GC2882@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429065315.GC2882@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 08:53:15AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 28, 2021 at 09:53:21AM -0300, Jason Gunthorpe wrote:
> > The Linux standard is one patch one change. It is inapporiate for me
> > to backdoor sneak revert the VFIO communities past decisions on
> > licensing inside some unrelated cleanup patch.
> 
> That's not what you are doing.  You are removing weird condom code
> that could never work, and remove the sneak attempt of an nvidia employee
> to create a derived work that has no legal standing.
> 
> > Otherwise this patch changes nothing - what existed today continues to
> > exist, and nothing new is being allowed.
> 
> No, it changes the existing exports, which is a complete no-go.

Agreed, Jason, please do not change the existing exports.

thanks,

greg k-h
