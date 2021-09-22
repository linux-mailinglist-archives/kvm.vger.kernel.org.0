Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D572414C75
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbhIVOxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhIVOxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:53:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51614C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:51:50 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id t10so12932697lfd.8
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TDrEpOj5z77SP2jdIw8cDIbvUad+t7NAXsCzDrXUEuo=;
        b=Ew0C8IKjSewOIfs1ywupioINHT/n6wPGtq2fNW0XmEFgFckhAnNx18kVuxyeob5MSb
         cG6vPdVQgy2y/2wCxrRgFAVzYfZgiGTRAFY3tcx6CIPvOZav9+pzr2A0g2V9jt2k0cSq
         9HHpBz6+Sfe0bQsurN4lUeiDAbqyklaJsw449YG114/qp9WKYRH5zxvga2tXVvb3mBga
         Cp+1KKZGvZQEC1wAnFvKoWVHGqnD2mGmydz+QUuPFHn2wQYUaZSi2A1opiUYI1VjnPGd
         EZHj0i05y8g9gyXadz3X1/RTTTyBrx7N4tTAhBK9sP7DGVVpXSKcFO8kZKq7qkBWjYyo
         S4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TDrEpOj5z77SP2jdIw8cDIbvUad+t7NAXsCzDrXUEuo=;
        b=heiVg95fG8xtHQgSt2hW2sxSunbwNviceoIozj0VwIpBL0pi26qwQmLHdZmB7Xrmwa
         Hr55Q0QWJijuZzA0UTEIHNp2RIOI2RByjawhMFs2msbq0pOKNW7b/K6g8ocqPAlhGO/Q
         zH45JYVevvmuRp56GWPknyqo9T8ishq3ZANUt94VJwXTGd1SPVwAUzeCXOqUY7VbR/Mp
         SySCvWi0chueqJWjPT4C23V5jCKHDHWulZqe9n7CbBAABLVPk7dWIEDJmuHFO3cNvAjm
         Fm4PbScwo9NSnLywHFeCXphk/6S+BQK9BEFQJBGKDJQB6dndQWKImgPtJFincTnQD/th
         GCpQ==
X-Gm-Message-State: AOAM53013UKfQfk+xEEBXEBZ7hStRJEbfEVJju2RxRYc4Bszs4hxd43D
        RRTlXMYF5z9scvTK6ElXjqQbpZWWo2GlsA==
X-Google-Smtp-Source: ABdhPJxMpjDOCwgilrcdezM3QInKUMDiNn1/siG8KtEO0JxOOJ9kWoOrqZ1UQupWEHroXThfagdnpQ==
X-Received: by 2002:a5d:66c6:: with SMTP id k6mr11823034wrw.382.1632322167122;
        Wed, 22 Sep 2021 07:49:27 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id z17sm2151265wml.24.2021.09.22.07.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:49:26 -0700 (PDT)
Date:   Wed, 22 Sep 2021 15:49:05 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 17/20] iommu/iommufd: Report iova range to userspace
Message-ID: <YUtCYZI3oQcwKrUh@myrica>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-18-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-18-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:45PM +0800, Liu Yi L wrote:
> [HACK. will fix in v2]
> 
> IOVA range is critical info for userspace to manage DMA for an I/O address
> space. This patch reports the valid iova range info of a given device.
> 
> Due to aforementioned hack, this info comes from the hacked vfio type1
> driver. To follow the same format in vfio, we also introduce a cap chain
> format in IOMMU_DEVICE_GET_INFO to carry the iova range info.
[...]
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 49731be71213..f408ad3c8ade 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -68,6 +68,7 @@
>   *		   +---------------+------------+
>   *		   ...
>   * @addr_width:    the address width of supported I/O address spaces.
> + * @cap_offset:	   Offset within info struct of first cap
>   *
>   * Availability: after device is bound to iommufd
>   */
> @@ -77,9 +78,11 @@ struct iommu_device_info {
>  #define IOMMU_DEVICE_INFO_ENFORCE_SNOOP	(1 << 0) /* IOMMU enforced snoop */
>  #define IOMMU_DEVICE_INFO_PGSIZES	(1 << 1) /* supported page sizes */
>  #define IOMMU_DEVICE_INFO_ADDR_WIDTH	(1 << 2) /* addr_wdith field valid */
> +#define IOMMU_DEVICE_INFO_CAPS		(1 << 3) /* info supports cap chain */
>  	__u64	dev_cookie;
>  	__u64   pgsize_bitmap;
>  	__u32	addr_width;
> +	__u32   cap_offset;

We can also add vendor-specific page table and PASID table properties as
capabilities, otherwise we'll need giant unions in the iommu_device_info
struct. That made me wonder whether pgsize and addr_width should also be
separate capabilities for consistency, but this way might be good enough.
There won't be many more generic capabilities. I have "output address
width" and "PASID width", the rest is specific to Arm and SMMU table
formats.

Thanks,
Jean

>  };
>  
>  #define IOMMU_DEVICE_GET_INFO	_IO(IOMMU_TYPE, IOMMU_BASE + 1)
> -- 
> 2.25.1
> 
