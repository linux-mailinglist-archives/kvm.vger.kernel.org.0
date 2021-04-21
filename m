Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE221367273
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 20:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245180AbhDUSYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 14:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbhDUSYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 14:24:03 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C935CC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 11:23:29 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id x27so20807974qvd.2
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pEe5PZRzotHXF6wvwpO5vYTFWnCReMX6MPr0QZ7yo2Y=;
        b=PxvdwZasfsEE7Ys0Fr9ySM8GWmuUf2u+2EyoJ6NAv5FaU2hoGu0bM8Nj6+n4uc1naD
         7XibpmiOJrLxC34f9eoERq737OUpXbwZ4FHodlyJcOJ6nhzTAuIOA5zFWYfYn6sibrkz
         jvf2/3gx3WYa3215trShhZsNHe7l/EB6ymSrdEukHu83D5Ge/BSc6GM7DSqFfLmzw2m3
         /PCEwmDm6j0kHaZiRTKAS1brgWZcKeZ7TtMXKzfR1F956IG01WQc8CxYtuTGz/j0dREc
         S6l8RMHLefAjkUBTKqNCzTD+K1vfyt8u++9iHPU7/QU9RX+2p3QoR1H7rJ+yTjYex4cC
         IJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pEe5PZRzotHXF6wvwpO5vYTFWnCReMX6MPr0QZ7yo2Y=;
        b=W6kPwDSDeAL7eXjgccuQ6iwx2hoS7AnR7PQIbKs7VS/kBhmEd/VYRdoZkuZmxEe2Ps
         tVulJU1COqd8Zx5eJENHOt8uDJzxrIJAXOp3Y65FRVpKxPjjjMfBB7YTrm5XlqcpUSSn
         ALi+aLBq0ObcnV+wh7PIZcpsCHXkWwwQf8dxjyiScQvJwptHIJ6pYWzfbdZbK9/2nhYk
         Wlbc3/axlOtY5gyjr4zIBMHOwRvckHV8lm1ARnqLnCmrx9YFv6me7SsH2vHqLNviJC1+
         +tjzcHVVtegWiu99gEwRPT7isk0tTdGbInGbV92xyXVEIN7D6HHyuCqdEIRIoBj+UDUy
         MHUg==
X-Gm-Message-State: AOAM533v98e80fQWTECXErnY0273b4qncY5h++XuLpxyQ+8M5InsnXnp
        SZ8xE/hpnW3e94arp8JQ9ok9BXfrKDm/Wg==
X-Google-Smtp-Source: ABdhPJyvgzHXAL+BJgPHqwuJ96KHMgfl6lKvi2GyMh+7Nct0M1SLmRqnQK0pMm6W+xYvE0uczx9r7Q==
X-Received: by 2002:a05:6214:725:: with SMTP id c5mr17652898qvz.54.1619029409070;
        Wed, 21 Apr 2021 11:23:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id x204sm109847qkb.97.2021.04.21.11.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 11:23:28 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lZHVX-009bey-Ix; Wed, 21 Apr 2021 15:23:27 -0300
Date:   Wed, 21 Apr 2021 15:23:27 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: remove unnecessary NULL check in
 mbochs_create()
Message-ID: <20210421182327.GD2047089@ziepe.ca>
References: <YIAowNYCOCNu+xhm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIAowNYCOCNu+xhm@mwanda>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 04:29:36PM +0300, Dan Carpenter wrote:
> This NULL check is no longer required because "type" now points to
> an element in a non-NULL array.
> 
> Fixes: 3d3a360e570616 ("vfio/mbochs: Use mdev_get_type_group_id()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  samples/vfio-mdev/mbochs.c | 2 --
>  samples/vfio-mdev/mdpy.c | 3 +--
>  2 files changed, 1 insertion(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
