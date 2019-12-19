Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042F0126E51
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 21:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfLSUAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 15:00:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726907AbfLSUAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 15:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576785629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUsE74tnPQmGVXjqg5rmNTPorv1EffsQX6PZnP57DPM=;
        b=DMSAJJeIUo4fqSyYfplLoX6oTimOD14sImJSvuRcCPoRj+BORazwLzhnSRgyCWLncz62s8
        b79vqY50hrQlG5QJ3AFbyIBH+fGKST2R//QA3o1uCAUCDukomMd49EvFOjkzSqj7kyLjFB
        cR2ZhEXoSoAFSx9smCjTpx/7RR7KmC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-LRL1VKOOOQeLcWPCdB30IA-1; Thu, 19 Dec 2019 15:00:25 -0500
X-MC-Unique: LRL1VKOOOQeLcWPCdB30IA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ABFC108598C;
        Thu, 19 Dec 2019 20:00:24 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F6B526FA8;
        Thu, 19 Dec 2019 20:00:19 +0000 (UTC)
Date:   Thu, 19 Dec 2019 21:00:16 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: make create attribute static
Message-ID: <20191219210016.41240524.cohuck@redhat.com>
In-Reply-To: <20191218123119.2582802-1-ben.dooks@codethink.co.uk>
References: <20191218123119.2582802-1-ben.dooks@codethink.co.uk>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 12:31:19 +0000
"Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk> wrote:

> The create attribute is not exported, so make it
> static to avoid the following sparse warning:
> 
> drivers/vfio/mdev/mdev_sysfs.c:77:1: warning: symbol 'mdev_type_attr_create' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
> ---
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 7570c7602ab4..8ad14e5c02bf 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -74,7 +74,7 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
>  	return count;
>  }
>  
> -MDEV_TYPE_ATTR_WO(create);
> +static MDEV_TYPE_ATTR_WO(create);
>  
>  static void mdev_type_release(struct kobject *kobj)
>  {

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

