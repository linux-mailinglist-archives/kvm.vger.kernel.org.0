Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8281E36D247
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 08:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhD1GhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 02:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhD1GhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 02:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30EED606A5;
        Wed, 28 Apr 2021 06:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619591772;
        bh=8X1z1IbQclBg863IbLxz++yAw57W3T9YWjKx7U9XG+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAiewDbiElxiI1utWP2Y8VbhYXeax7U7ZmfvwD6UlMr4ojF91tBtGUQmCaj4NTOBC
         hQMAYVLOgE4u8u2kiJQqZGPJRnK+fyfZVnNjzICBgbg0fJEiUjKl73/u/dwwesKh9m
         u1QV3q8ELr0nXjEJitcTRA83b4dt5Qy/onTsojt8=
Date:   Wed, 28 Apr 2021 08:36:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <YIkCVnTFmTHiX3xn@kroah.com>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060703.GA4973@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428060703.GA4973@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 08:07:03AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 26, 2021 at 05:00:11PM -0300, Jason Gunthorpe wrote:
> > Preserve VFIO's design of allowing mdev drivers to be !GPL by allowing the
> > three functions that replace this module for !GPL usage. This goes along
> > with the other 19 symbols that are already marked !GPL in VFIO.
> 
> NAK.  This was a sneak by Nvidia to try a GPL condom, and now that we
> remove that not working condom it does not mean core symbols can be
> just changed.

Agreed, these symbols should not be changed.

thanks,

greg k-h
