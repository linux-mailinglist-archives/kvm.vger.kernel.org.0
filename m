Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D1B40315C
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 01:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346385AbhIGXFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 19:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240690AbhIGXFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 19:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365DD61102;
        Tue,  7 Sep 2021 23:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631055873;
        bh=U4r90XGeMFMBTYQzJqJqJ72n/aEzus0q4Z98AOX2grc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sKXNN3dc3jccHx69/sKD47gbQLIRPr5FvdMGBsnJ/eUfbMNTLqUqNfWSvns+I69ck
         U25GKT7tGRJbAWVj0zvnCcxOB6w4HzBT1Fe6R/PlLWnsRJcpQuvxrlr71Ab0Gl0r/g
         yCUbkzUr9DQXvBlG7STLjsnFeql70rUCYRhVNXo5P9Gd5NRMXopOXF68LZg0JtLbDj
         NWDsTld22BYYdo8O+Vk07IJEW02ZwlwcdChvtN2kzeHNXcIDL0mt9ZFToQ/iPeAFMS
         FGhfCRqW9/t3Jn7umP3x8hpJMQ+gNd+0TD6+cH0YIKQMIROMhf40SlprUdwNv8QkXz
         HpLc51HwA2u3Q==
Date:   Wed, 8 Sep 2021 02:04:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <YTfv/s8v0MsCya5r@unreal>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
 <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <YTSZ6CYM6BCsbVmk@unreal>
 <20210905111415-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905111415-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 11:15:16AM -0400, Michael S. Tsirkin wrote:
> On Sun, Sep 05, 2021 at 01:20:24PM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 05, 2021 at 01:49:46AM -0700, Chaitanya Kulkarni wrote:
> > > 
> > > On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
> > > > > +static unsigned int num_request_queues;
> > > > > +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> > > > > +		0644);
> > > > > +MODULE_PARM_DESC(num_request_queues,
> > > > > +		 "Number of request queues to use for blk device. Should > 0");
> > > > > +
> > > > Won't it limit all virtio block devices to the same limit?
> > > > 
> > > > It is very common to see multiple virtio-blk devices on the same system
> > > > and they probably need different limits.
> > > > 
> > > > Thanks
> > > 
> > > 
> > > Without looking into the code, that can be done adding a configfs
> > > 
> > > interface and overriding a global value (module param) when it is set from
> > > 
> > > configfs.
> > 
> > So why should we do double work instead of providing one working
> > interface from the beginning?
> > 
> > Thanks
> > 
> > > 
> > > 
> 
> The main way to do it is really from the hypervisor. This one
> is a pretty blunt instrument, Max here says it's useful to reduce
> memory usage of the driver. If that's the usecase then a global limit
> seems sufficient.

How memory will you reduce? It is worth to write it in the commit message.

Thanks

> 
> -- 
> MST
> 
