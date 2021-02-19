Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A63931F95C
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhBSMXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 07:23:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhBSMXJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 07:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613737303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Tg+vSjGJcVmeddEziwuXmeKFVeBsoRCqWhBDUVvD+U=;
        b=Pw/9HkAUGfvk3qnspmqHWQiq7fwCT6O0llWr/nDElkVBSEz7zcSAl7PzXB4//6z048/3XN
        gcDZkyh2snoOySjVBRNaih8Vo7Y7toz3s1+uaICTeXnB88b4RN5UAi8xr4JMI8BdcAAFoE
        3y/q3eyoKUfmfgxb8b9yTDWM1evauTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-zGtX_md1PLO-mW0aPqUi2Q-1; Fri, 19 Feb 2021 07:21:39 -0500
X-MC-Unique: zGtX_md1PLO-mW0aPqUi2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95067801985;
        Fri, 19 Feb 2021 12:21:38 +0000 (UTC)
Received: from gondolin (ovpn-113-92.ams2.redhat.com [10.36.113.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18ECB5D723;
        Fri, 19 Feb 2021 12:21:33 +0000 (UTC)
Date:   Fri, 19 Feb 2021 13:21:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/iommu_type1: Fix duplicate included kthread.h
Message-ID: <20210219132131.0414e977.cohuck@redhat.com>
In-Reply-To: <1613614649-59501-1-git-send-email-tiantao6@hisilicon.com>
References: <1613614649-59501-1-git-send-email-tiantao6@hisilicon.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 10:17:29 +0800
Tian Tao <tiantao6@hisilicon.com> wrote:

> linux/kthread.h is included more than once, remove the one that isn't
> necessary.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ec9fd95..b3df383 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -31,7 +31,6 @@
>  #include <linux/rbtree.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/mm.h>
> -#include <linux/kthread.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>

This is not in Linus' tree yet, only on Alex' next branch, would be
good to mention that.

Fixes: 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

