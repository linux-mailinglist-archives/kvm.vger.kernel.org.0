Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F490498
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfHPPWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 11:22:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727371AbfHPPWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 11:22:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82E67300CB28;
        Fri, 16 Aug 2019 15:22:42 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB64744F8C;
        Fri, 16 Aug 2019 15:22:36 +0000 (UTC)
Date:   Fri, 16 Aug 2019 17:22:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        cjia@nvidia.com
Subject: Re: [PATCH v2 2/2] vfio/mdev: Removed unused and redundant API for
 mdev UUID
Message-ID: <20190816172234.260e9ade.cohuck@redhat.com>
In-Reply-To: <20190808141255.45236-3-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808141255.45236-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 16 Aug 2019 15:22:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Aug 2019 09:12:55 -0500
Parav Pandit <parav@mellanox.com> wrote:

> There is no single production driver who is interested in mdev device
> uuid. Currently UUID is mainly used to derive a device name.
> Additionally mdev device name is already available using core kernel
> API dev_name().
> 
> Hence removed unused exported symbol.

FWIW, I just sent
https://lore.kernel.org/kvm/20190816151505.9853-1-cohuck@redhat.com/,
for which dev_name() is not an option.

> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
> Changelog:
> v0->v1:
>  - Updated commit log to address comments from Cornelia
> ---
>  drivers/vfio/mdev/mdev_core.c | 6 ------
>  include/linux/mdev.h          | 1 -
>  2 files changed, 7 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..c2b809cbe59f 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -57,12 +57,6 @@ struct mdev_device *mdev_from_dev(struct device *dev)
>  }
>  EXPORT_SYMBOL(mdev_from_dev);
>  
> -const guid_t *mdev_uuid(struct mdev_device *mdev)
> -{
> -	return &mdev->uuid;
> -}
> -EXPORT_SYMBOL(mdev_uuid);
> -
>  /* Should be called holding parent_list_lock */
>  static struct mdev_parent *__find_parent_device(struct device *dev)
>  {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..375a5830c3d8 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -131,7 +131,6 @@ struct mdev_driver {
>  
>  void *mdev_get_drvdata(struct mdev_device *mdev);
>  void mdev_set_drvdata(struct mdev_device *mdev, void *data);
> -const guid_t *mdev_uuid(struct mdev_device *mdev);
>  
>  extern struct bus_type mdev_bus_type;
>  

