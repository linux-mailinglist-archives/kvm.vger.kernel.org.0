Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110226E842
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 00:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIQWWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 18:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbgIQWWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 18:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600381364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvuHxNz2BrTQXlkevMjnE9MIJbFFs00AlTuCp/QbcwE=;
        b=J9OPVFgAzBKhfDUlhbjG708VRRMU37stSXTP7H9x10FMTNoY/eOxQMSXtjkoswTXxTR/pH
        xgqXRaPBZcJR69160TYh/criquX5p1mRiXEzPn4zmSr3vNRhi2aqHITQV3VQT80DHrAvoX
        oAj5qbKxHtOHyI49CUSEs+JUIEv0jxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-wqYEx6UVO3mq9sKVmfKh2w-1; Thu, 17 Sep 2020 18:22:43 -0400
X-MC-Unique: wqYEx6UVO3mq9sKVmfKh2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6EC681F009;
        Thu, 17 Sep 2020 22:22:41 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A5B7880B;
        Thu, 17 Sep 2020 22:22:41 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:22:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 1/2] vfio/pci: Remove redundant declaration of
 vfio_pci_driver
Message-ID: <20200917162240.037a1913@x1.home>
In-Reply-To: <20200917033128.872-1-yuzenghui@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 11:31:27 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> It was added by commit 137e5531351d ("vfio/pci: Add sriov_configure
> support") and actually unnecessary. Remove it.

Looks correct, but I might clarify as:

s/unnecessary/duplicates a forward declaration earlier in the file/

I can change on commit if you approve.  Thanks,

Alex

 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 1ab1f5cda4ac..da68e2f86622 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1862,7 +1862,6 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  
>  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
>  static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
> -static struct pci_driver vfio_pci_driver;
>  
>  static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  				 unsigned long action, void *data)

