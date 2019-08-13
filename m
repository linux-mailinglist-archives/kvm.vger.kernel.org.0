Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DA18BFB9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfHMRkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 13:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMRkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 13:40:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E16A2067D;
        Tue, 13 Aug 2019 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565718023;
        bh=Zk2IO5dXX5Mv50sC16q2ZMnbxFjn3peaoGLBUXfuGcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F9cSmalpVAHPvhcPEXJlu3Z6T659ePZ2N1uRORNIoX7zwobKZ43Jd6zM3tPh5/N38
         NvNlmPoPSR8cZbKD+VZ7IQEVBQ7+vIqPE/VLEnv6cDcKlEne6+/s/AUZ9Y69WWwyEt
         4es9ZuvdPX1hgdXT1epKU561781/gs0Ym31TlmEE=
Date:   Tue, 13 Aug 2019 19:40:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>,
        Parav Pandit <parav@mellanox.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190813174020.GC470@kroah.com>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com>
 <20190808170247.1fc2c4c4@x1.home>
 <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
 <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813163721.GA22640@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813163721.GA22640@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 09:37:21AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 13, 2019 at 02:40:02PM +0000, Parav Pandit wrote:
> > We need to ask Greg or Linus on the kernel policy on whether an API should exist without in-kernel driver.

I "love" it when people try to ask a question of me and they don't
actually cc: me.  That means they really do not want the answer (or they
already know it...)  Thanks Christoph for adding me here.

The policy is that the api should not exist at all, everyone knows this,
why is this even a question?

> > We don't add such API in netdev, rdma and possibly other subsystem.
> > Where can we find this mdev driver in-tree?
> 
> The clear policy is that we don't keep such symbols around.  Been
> there done that only recently again.

Agreed.  If anyone knows of anything else that isn't being used, we will
be glad to free up the space by cleaning it up.

> The other interesting thing is the amount of code nvidia and partner 
> developers have pushed into the kernel tree for exclusive use of their
> driver it should be clearly established by now that it is a derived
> work, but that is for a different discussion.

That's a discussion the lawyers on their side keep wanting us to ignore,
it's as if they think we are stupid and they are "pulling one over on
us."  ugh...

thanks,

greg "not a lawyer, but spends lots of time with them" k-h
