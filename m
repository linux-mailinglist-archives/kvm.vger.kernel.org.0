Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD1400F10
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 12:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbhIEKVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 06:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237602AbhIEKVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 06:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F78260F6D;
        Sun,  5 Sep 2021 10:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630837228;
        bh=SUnFrhVsbSr7xhXMvn+ilFPAkoBHg1wZQuj1B8J6If4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uz14KLZnk+VNxm5+LffpjNsTNJLqQuHIbmmkU7oEGWYQFakUovEGcl3LXC69ySUrY
         GhsEketgZV0J4CO+T2UnSHBu/AJMiwNidAw/oRRc5cEUZu0/5Evlir1G3Z1uLMC2xQ
         zGzH/z+AFo1OhEkoN/MSa64wdl6VesgSAKGSSC5f3NtEqFG1ijnteDnPecgReXpZjh
         8I8fkSCPrpqssRx7VL2dR4uWRHE2h+XUu2lbJtN5rwlfzVWei/w7scDeAhiNs56wQc
         UYiwxgVzVaoSPVkkzKf0LZRGLQTY3lCDaX9HpRlzQeqTEoG2wSKZvjend41tVARWGk
         wPq5mTk59aa2Q==
Date:   Sun, 5 Sep 2021 13:20:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, hch@infradead.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, stefanha@redhat.com, israelr@nvidia.com,
        nitzanc@nvidia.com, oren@nvidia.com, linux-block@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <YTSZ6CYM6BCsbVmk@unreal>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
 <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 01:49:46AM -0700, Chaitanya Kulkarni wrote:
> 
> On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
> > > +static unsigned int num_request_queues;
> > > +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> > > +		0644);
> > > +MODULE_PARM_DESC(num_request_queues,
> > > +		 "Number of request queues to use for blk device. Should > 0");
> > > +
> > Won't it limit all virtio block devices to the same limit?
> > 
> > It is very common to see multiple virtio-blk devices on the same system
> > and they probably need different limits.
> > 
> > Thanks
> 
> 
> Without looking into the code, that can be done adding a configfs
> 
> interface and overriding a global value (module param) when it is set from
> 
> configfs.

So why should we do double work instead of providing one working
interface from the beginning?

Thanks

> 
> 
