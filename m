Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2001599CC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 20:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbgBKTcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 14:32:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728202AbgBKTcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 14:32:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581449525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xIa0c6b5VKhEq1vbnW1agX1g7hVxdrY8O/5iEHdfqqs=;
        b=C8SqNA8gcv8S2i5uG993ZP7yxtnfmWTQXHdxCt2HPPFWw2roLxF5fGb3lN9lUap4YQFpRv
        Eu4mWhaSCtyobLQXvRvvhJDF844ekj6hqa2EQ1zp/S179D3qEUr6s79qIo5GlQxzxxzLFZ
        X410RbZkPtLXeYXMTcyMQBPW34fKCEw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-nwN9uRHMONKl_ZPMeSOPPw-1; Tue, 11 Feb 2020 14:32:03 -0500
X-MC-Unique: nwN9uRHMONKl_ZPMeSOPPw-1
Received: by mail-qv1-f70.google.com with SMTP id g6so7925135qvp.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 11:32:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xIa0c6b5VKhEq1vbnW1agX1g7hVxdrY8O/5iEHdfqqs=;
        b=fLXOXzenpCfsDvuj2TJ9dmt3oepmATkj1xOQ5kF49jSE9LDt0FZY57yKLRtikXB/r4
         kmaNOsqTOMre/pzcZbF0lQsYppzk1UtV/MifPlSISQ1UOOJzndJbZZ9ppgYwOoCX3boT
         Hrf4hYEMCUIf6lbNPAB9fl5nlsVW4OQHeDdaIPgix84Zxo7WT19/Jhej1gdc4j79+Kky
         Nh9gmbpXn5K3K1CsZdJOC+ZpeHlEMwlIIBcYVRbpncLNyZVQMSkBtLqTiexpaOBSTw2o
         nVEqcHeSFq6IhiQ+ZvXySUwsR6C6G175I2mTDc76zIcQmidWJMYZ99g9IZthPixB78uQ
         aw1w==
X-Gm-Message-State: APjAAAWvC5wSm8l5hKbWrUOifA5gg+3q3x603DesAwAAjEA3WMuIo+sf
        1MvrGRtqFrkyJu+VoaHLajIHOW+DN+OyBmhUeYEGmneeqy+g4nuXz031YXAg9rC/a1Txduz2V5n
        jeW/BnIW9PepM
X-Received: by 2002:ae9:f714:: with SMTP id s20mr7602625qkg.236.1581449522538;
        Tue, 11 Feb 2020 11:32:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQk3R2onk6mtzijhC++V2RPaLKgwEcFXbTvq/y0AOteeR8FWx7SBKNMK17v6GLLiGEaKSQNQ==
X-Received: by 2002:ae9:f714:: with SMTP id s20mr7602599qkg.236.1581449522334;
        Tue, 11 Feb 2020 11:32:02 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id m16sm2479945qka.8.2020.02.11.11.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:32:01 -0800 (PST)
Date:   Tue, 11 Feb 2020 14:31:59 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 12/25] vfio/common: add pasid_alloc/free support
Message-ID: <20200211193159.GJ984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-13-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-13-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:43AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> This patch adds VFIO pasid alloc/free support to allow host intercept
> in PASID allocation for VM by adding VFIO implementation of
> DualStageIOMMUOps.pasid_alloc/free callbacks.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/vfio/common.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index a07824b..014f4e7 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1179,7 +1179,49 @@ static int vfio_get_iommu_type(VFIOContainer *container,
>      return -EINVAL;
>  }
>  
> +static int vfio_ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj,
> +                         uint32_t min, uint32_t max, uint32_t *pasid)
> +{
> +    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +
> +    argsz = sizeof(req);
> +    req.argsz = argsz;
> +    req.flags = VFIO_IOMMU_PASID_ALLOC;
> +    req.alloc_pasid.min = min;
> +    req.alloc_pasid.max = max;
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
> +        error_report("%s: %d, alloc failed", __func__, -errno);
> +        return -errno;

Note that errno is prone to change by other syscalls.  Better cache it
right after the ioctl.

> +    }
> +    *pasid = req.alloc_pasid.result;
> +    return 0;
> +}
> +
> +static int vfio_ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj,
> +                                     uint32_t pasid)
> +{
> +    VFIOContainer *container = container_of(dsi_obj, VFIOContainer, dsi_obj);
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +
> +    argsz = sizeof(req);
> +    req.argsz = argsz;
> +    req.flags = VFIO_IOMMU_PASID_FREE;
> +    req.free_pasid = pasid;
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
> +        error_report("%s: %d, free failed", __func__, -errno);
> +        return -errno;

Same here.

> +    }
> +    return 0;
> +}
> +
>  static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
> +    .pasid_alloc = vfio_ds_iommu_pasid_alloc,
> +    .pasid_free = vfio_ds_iommu_pasid_free,
>  };
>  
>  static int vfio_get_iommu_info(VFIOContainer *container,
> -- 
> 2.7.4
> 

-- 
Peter Xu

