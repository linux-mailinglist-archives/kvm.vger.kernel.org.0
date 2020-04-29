Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028491BE2D0
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgD2PeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 11:34:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25518 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726519AbgD2PeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 11:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588174440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KKID24VeS04+SIozIuc8RuLZZFKJ5rduUKOoVcekO0A=;
        b=gWcyjvVjyuR4Xtsk+ejTzP+sRLkpt/IiKcNoOY7QacHpEUURVkvB/z7jE6zdN/ScV3JN4Q
        qRUqlanUmeQg1qoSbY65RJuCvAESzyTEIw0ErgdLKQxA8lAUqQ1JpXvsRBHGIRhzyugb9Q
        sddQ8H0JQGG756h7rwKheISrb8ZOY2c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-yd7fgLG-P4a5pSftzZazaQ-1; Wed, 29 Apr 2020 11:33:57 -0400
X-MC-Unique: yd7fgLG-P4a5pSftzZazaQ-1
Received: by mail-wm1-f69.google.com with SMTP id h6so1372747wmi.7
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 08:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KKID24VeS04+SIozIuc8RuLZZFKJ5rduUKOoVcekO0A=;
        b=aWg86BHcnuO670txfQtdMJayJqtD+pKF9qC49Il+sQKsY7fHul+dQOfpuLBO5Q4iIB
         H+L0tz38Upuhtcu6w1rj+qUEWdXhiWfPd/GuqrKwxHSs75ja8IJFHE2ZYbjNVK7Tg1EJ
         oD9D20LIswJEzjG5z5mjQBw9WYoJhFH/eu2ExTq1uI4DzuBNEF/wQyZZqirzLM+fU1Fm
         D6uSxLHuI1fghLjmjuFnShBzcHWE+7wQ19l5gJs2vlZg8Bo01NT4BFsVHrGeREk7oqBU
         tJi7Dqp+kOwWRn4CKWESFCYXllVolSpJT5POTSs6yJNtycDZI/oU/EqKUf3mytmXeEPV
         NT1g==
X-Gm-Message-State: AGi0PuZSW1LA3Us8KqKT9RtmNFqMVWn8kVM3nH6QpzG2O1GXw+ELv0k2
        D4D/e7biw0PibZeDyv4mNWKSWULAgFumEapGbrR4iEUgbws+Rfank0Xe8JXYP/i3zS03jlX4/fj
        9tXOmnrlrDqSK
X-Received: by 2002:adf:fecd:: with SMTP id q13mr42286155wrs.12.1588174435308;
        Wed, 29 Apr 2020 08:33:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJv7rM5XZdPpYa0XbuMbltzbpsnlCYEladdinC4riKF/z7q+xHJZ0Lq2AB1h1HtNI76PDhJ5w==
X-Received: by 2002:adf:fecd:: with SMTP id q13mr42286134wrs.12.1588174435068;
        Wed, 29 Apr 2020 08:33:55 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id u7sm8832675wmg.41.2020.04.29.08.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 08:33:54 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:33:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jason Wang <jasowang@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: fix default for vhost_iotlb
Message-ID: <20200429113232-mutt-send-email-mst@kernel.org>
References: <20200429142317.1847441-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429142317.1847441-1-arnd@arndb.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 04:23:04PM +0200, Arnd Bergmann wrote:
> During randconfig build testing, I ran into a configuration that has
> CONFIG_VHOST=m, CONFIG_VHOST_IOTLB=m and CONFIG_VHOST_RING=y, which
> makes the iotlb implementation left out from vhost_ring, and in turn
> leads to a link failure of the vdpa_sim module:
> 
> ERROR: modpost: "vringh_set_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_init_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_iov_push_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_iov_pull_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_complete_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_getdesc_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> 
> Work around it by setting the default for VHOST_IOTLB to avoid this
> configuration.
> 
> Fixes: e6faeaa12841 ("vhost: drop vring dependency on iotlb")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I fixed this a while ago locally but never got around to sending the
> fix. If the problem has been addressed differently in the meantime,
> please ignore this one.


So I ended up not sending e6faeaa12841 upstream because of this problem.
But hey, that's a nice idea!
I'll queue something like this for the next release.

> ---
>  drivers/vhost/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2c75d164b827..ee5f85761024 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VHOST_IOTLB
>  	tristate
> +	default y if VHOST=m && VHOST_RING=y
>  	help
>  	  Generic IOTLB implementation for vhost and vringh.
>  	  This option is selected by any driver which needs to support
> -- 
> 2.26.0

