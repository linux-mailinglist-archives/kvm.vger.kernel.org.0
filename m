Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B8C7C1C7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfGaMl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 08:41:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34926 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfGaMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 08:41:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so66375882qto.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 05:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ssT+JujOxDwS6NEpfq2Ge7MRteKET9yZx/jW5aTaxrI=;
        b=CV7jH3veMykUxgu+H5gGaJEiM7dHfRA3AWXtjSYfzu48EjQ0oDP+S8cs1UxQbidp/W
         MqKLYekmIDfV2RBQHTtrwRlnUCc5krtCPt3AASFeznsZkr+ipQT/XuC+Xn6vABBkKIFP
         enujxa2gQmDcqqBPQMXqNzw5a+lpfG5eB2A37iznAHNxxA9jQHhaTnP+cwJR1UO9lidY
         SP65bUUa5WqhqoZCyAGPCKh7SUkgLjT8qHxGXbgc7GA59ln/8F06imsHF08LgdqgZvE2
         /+AQjQMxZnEgE6iMjDFEfdphXGCtwyg1L1ebJpvApgpgereLtbGxAEtwqnD5666T6XAv
         R7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ssT+JujOxDwS6NEpfq2Ge7MRteKET9yZx/jW5aTaxrI=;
        b=lYAZ3GlDT/IIpfhAskS0MDtP0LR7/F8yheqW3xRsfcZ+DEcUxiHZm0is/78sDvGiqz
         Q5wFRE3ZV89N7LYlfa2lDTg/RKgOYX1js3wyjz7+F5jWFsp3aHVb4KHO63NhBEz//eie
         ut4FOYdKXz/Hod19SVcur+UdkJwuSn6JACxKiCVUSlzL4yCYyZ7lAYX4VsbFMq0bMTsw
         1gmKdOZNnf6elyLUZ0zk196KWwPWBmuHpI2Q3MIYMR8VOZWs0Rcq9suAHFpOKBx5Tgic
         8sLtV3jgSVQnb6xyFKosByaev3kxlElcfhWqGlAc/WvQKwdAJkxXOQrn/mlZyH7SeHpT
         Uqng==
X-Gm-Message-State: APjAAAU9GTIUElVbpE1ffdYIKAf1MeYoFX6uKl3jY34STvv5EA7lyif6
        QEhBn/HaDWoDkYiP07VSxhgedg==
X-Google-Smtp-Source: APXvYqwbN0Zcgw/rqJW/uUJyj5pJV/gEvjkDyEf6dYni+Q8BnL4R5HKzXod/DVe6ENOwDm8+CZT9Rw==
X-Received: by 2002:a0c:acab:: with SMTP id m40mr88924921qvc.52.1564576884920;
        Wed, 31 Jul 2019 05:41:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id u4sm29623865qkb.16.2019.07.31.05.41.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Jul 2019 05:41:24 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hsnv2-0006PN-6Q; Wed, 31 Jul 2019 09:41:24 -0300
Date:   Wed, 31 Jul 2019 09:41:24 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 4/9] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
Message-ID: <20190731124124.GD3946@ziepe.ca>
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-5-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731084655.7024-5-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 04:46:50AM -0400, Jason Wang wrote:
> The vhost_set_vring_num_addr() could be called in the middle of
> invalidate_range_start() and invalidate_range_end(). If we don't reset
> invalidate_count after the un-registering of MMU notifier, the
> invalidate_cont will run out of sync (e.g never reach zero). This will
> in fact disable the fast accessor path. Fixing by reset the count to
> zero.
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>

Did Michael report this as well?

> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
>  drivers/vhost/vhost.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 2a3154976277..2a7217c33668 100644
> +++ b/drivers/vhost/vhost.c
> @@ -2073,6 +2073,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>  		d->has_notifier = false;
>  	}
>  
> +	/* reset invalidate_count in case we are in the middle of
> +	 * invalidate_start() and invalidate_end().
> +	 */
> +	vq->invalidate_count = 0;
>  	vhost_uninit_vq_maps(vq);
>  #endif
>  
