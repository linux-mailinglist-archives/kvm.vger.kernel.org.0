Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E02159966
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 20:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgBKTIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 14:08:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728295AbgBKTIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 14:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581448090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeZKa3K6OW2+02/7q9K48BzrFmMElUkLMajzZiIzT6w=;
        b=hYA0ZRoq6XQT7+iM9/baiWyiCr6TDsuX3I2dVGGYXyAc77CD9eYYEypra0oWo3QckqKrq8
        tcZZF0t25Dx41L8ruVb1BWKfv3S6DEbxrTFIAFduWeGWtR4U4MNxLaLW+NpDfpz6waoi4U
        9de3pouNrNwz47rq3OUocFbseSEpnPQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-VXdUtviyM3Gr-YKYeAxteQ-1; Tue, 11 Feb 2020 14:08:06 -0500
X-MC-Unique: VXdUtviyM3Gr-YKYeAxteQ-1
Received: by mail-qk1-f200.google.com with SMTP id v2so7818071qkf.4
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 11:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QeZKa3K6OW2+02/7q9K48BzrFmMElUkLMajzZiIzT6w=;
        b=TrWO90QyxREN8whAr1uabRcD8ExP3uuBF3yIXQIXUbYeH97Dnkj2WwIQKbyBuNyzn/
         6CG/TCEDuvrr7DgU34lEgTUck/kRV3vLZF52fBuIck8llMW84OGWKzVe1qnJwOixe7qD
         kKWRhGjaunWWm1JrDQfe8IzMhHzJzm6bmlRwVT5YqbncIErLvtZQBMgChumX1N6M8yOV
         1CS0HDZ4px1Z1oblgUlWZTmWbSsamKm5Zwm7+roDhHpmzbea4avJI6VqPO+l8yE3HQUT
         mPdnXudMt2sQaE4mXqxsH4NRCU0rRWXhIlblsAbCyktcrYa43+ukP7oEfV2Fux4tRyHp
         UGdw==
X-Gm-Message-State: APjAAAXK91qqggGTex5IpZcMYQJDLK/xWQXsmP4XjT/DhaRZz8AtAkA3
        6Xve38Kj8/9PQRtBnrzTXmRKSiyU7c091yz+kpM3NK4EkTYMNwS+m7NsqFyFuvmod2Xn4PHWvS7
        OEC6wNIRBKM7M
X-Received: by 2002:a05:6214:923:: with SMTP id dk3mr4111432qvb.96.1581448086556;
        Tue, 11 Feb 2020 11:08:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqwZN0k9FUgTBnug2e1nb2U+7Hah/t3y++SpkSCUaYmPBw52LRTVszhDsMvutT8soVeGnIjo+w==
X-Received: by 2002:a05:6214:923:: with SMTP id dk3mr4111399qvb.96.1581448086193;
        Tue, 11 Feb 2020 11:08:06 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id x41sm2739974qtj.52.2020.02.11.11.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:08:05 -0800 (PST)
Date:   Tue, 11 Feb 2020 14:08:02 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 09/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Message-ID: <20200211190802.GH984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-10-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-10-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:40AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> VFIO needs to check VFIO_TYPE1_NESTING_IOMMU
> support with Kernel before further using it.
> e.g. requires to check IOMMU UAPI version.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/vfio/common.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 0cc7ff5..a5e70b1 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1157,12 +1157,21 @@ static void vfio_put_address_space(VFIOAddressSpace *space)
>  static int vfio_get_iommu_type(VFIOContainer *container,
>                                 Error **errp)
>  {
> -    int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
> +    int iommu_types[] = { VFIO_TYPE1_NESTING_IOMMU,
> +                          VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
>                            VFIO_SPAPR_TCE_v2_IOMMU, VFIO_SPAPR_TCE_IOMMU };
> -    int i;
> +    int i, version;
>  
>      for (i = 0; i < ARRAY_SIZE(iommu_types); i++) {
>          if (ioctl(container->fd, VFIO_CHECK_EXTENSION, iommu_types[i])) {
> +            if (iommu_types[i] == VFIO_TYPE1_NESTING_IOMMU) {
> +                version = ioctl(container->fd,
> +                                VFIO_NESTING_GET_IOMMU_UAPI_VERSION);
> +                if (version < IOMMU_UAPI_VERSION) {
> +                    printf("IOMMU UAPI incompatible for nesting\n");

There should have better alternatives than printf()... Maybe
warn_report()?

> +                    continue;
> +                }
> +            }
>              return iommu_types[i];
>          }
>      }
> @@ -1278,6 +1287,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>      }
>  
>      switch (container->iommu_type) {
> +    case VFIO_TYPE1_NESTING_IOMMU:
>      case VFIO_TYPE1v2_IOMMU:
>      case VFIO_TYPE1_IOMMU:
>      {
> -- 
> 2.7.4
> 

-- 
Peter Xu

