Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E1534A434
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhCZJVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:21:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhCZJUm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616750441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdhTk6wzAnjUFDmSctBcFuCS/lpBkxpexyEOMArdKoQ=;
        b=SzpGRXMYG6s6Vfajchht3MyJPjcS9nFwpZGLduZ8U7jVwgD2gAXe3e1ZesDrgQVa1umHbq
        L9Dfmjv7b29qnDiAqWQaQJaLAL8iv9ufYh+j0XAdj7E+OpcLsEpXd6ZHtj4hz/cv3n6VBi
        nTGRGrM3NVN5L47LCRB2UCgYJErNHf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-r5yGTcGKPcSlIiXY76Rzvg-1; Fri, 26 Mar 2021 05:20:39 -0400
X-MC-Unique: r5yGTcGKPcSlIiXY76Rzvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD337100E351;
        Fri, 26 Mar 2021 09:20:37 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 136CF712B8;
        Fri, 26 Mar 2021 09:20:10 +0000 (UTC)
Subject: Re: [PATCH 1/4] vfio/type1: fix a couple of spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
 <20210326083528.1329-2-thunder.leizhen@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <458e56e7-9e38-e88b-50e3-9487635827c7@redhat.com>
Date:   Fri, 26 Mar 2021 10:20:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326083528.1329-2-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/26/21 9:35 AM, Zhen Lei wrote:
> There are several spelling mistakes, as follows:
> userpsace ==> userspace
> Accouting ==> Accounting
> exlude ==> exclude
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index be444407664af74..21cf1d123036c82 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -16,7 +16,7 @@
>   * IOMMU to support the IOMMU API and have few to no restrictions around
>   * the IOVA range that can be mapped.  The Type1 IOMMU is currently
>   * optimized for relatively static mappings of a userspace process with
> - * userpsace pages pinned into memory.  We also assume devices and IOMMU
> + * userspace pages pinned into memory.  We also assume devices and IOMMU
>   * domains are PCI based as the IOMMU API is still centered around a
>   * device/bus interface rather than a group interface.
>   */
> @@ -871,7 +871,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  	/*
>  	 * If iommu capable domain exist in the container then all pages are
> -	 * already pinned and accounted. Accouting should be done if there is no
> +	 * already pinned and accounted. Accounting should be done if there is no
>  	 * iommu capable domain in the container.
>  	 */
>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> @@ -2171,7 +2171,7 @@ static int vfio_iommu_resv_exclude(struct list_head *iova,
>  				continue;
>  			/*
>  			 * Insert a new node if current node overlaps with the
> -			 * reserve region to exlude that from valid iova range.
> +			 * reserve region to exclude that from valid iova range.
>  			 * Note that, new node is inserted before the current
>  			 * node and finally the current node is deleted keeping
>  			 * the list updated and sorted.
> 

