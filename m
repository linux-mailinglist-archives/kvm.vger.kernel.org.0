Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645061A27A0
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbgDHQ7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:59:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37498 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgDHQ7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 12:59:49 -0400
Received: by mail-pg1-f195.google.com with SMTP id r4so3583863pgg.4
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 09:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iazuwtOmYpAvBrdVj8TEytSBmpAo+XIqBVbhsQf9qWM=;
        b=GShUeMzLckvv1Tmg/eAf8t2/jmGL2cG48LI9uDJAFRP21EjcCDQiSiVBJ+ufSQw2X+
         zL3weCklxHnyTNA/snfQcDCUMSk26gYSWAy6MWK2OB5pnBbGPUaXkSO8yZD5WO11PdF2
         7SNL4pPJ+c1FzVG0s72ZaI3wsEdVbtmkhh8eQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iazuwtOmYpAvBrdVj8TEytSBmpAo+XIqBVbhsQf9qWM=;
        b=suG+SlMIG8r+pW4khMS3DsLttIuY4keI/cGx8x8aDLwz7j7YlJKsf+2/5ER0pLDfhS
         Ndfyq4jVhlD1l5V4F31/UAEoJLBn04WLAe3iJqeBwet5BdDsxv2EBdXyC6l8J6GrilWv
         zXj2MLKRbYGSC6ffoJDKQqblkGsWK2tCVJGAujD4zrP/Ed8uMRwNMOxLm/UPE8ksT97b
         BWAIq4Mes5ymbVEJQf4zUuM3fJewuACk5FjA5rqFtnGKSsIH2DrSCsCsf4bZ/1xVzEKJ
         Av2s9ynQzVuvZMZA7+5eCQ+No2Ja0TPg/HOp8KknqXVNPMtkJJ0WGuf7V+AV0BDrpAnF
         FYEg==
X-Gm-Message-State: AGi0PuaU6rtw3lT76TQmvQ6sVa+HKhvK3aHhe1/Oyd+ccyojgRpmn/2P
        WupkWuQpKYPgHZfqVar0RPSO0Q==
X-Google-Smtp-Source: APiQypLbXC98cOz1Gk+AUmoZ9LfVbVf3dMcxa3rqqbc4bIsPb4a7998lvJd5neuYRjqaKOSq7JvUbQ==
X-Received: by 2002:a63:f658:: with SMTP id u24mr836796pgj.357.1586365186839;
        Wed, 08 Apr 2020 09:59:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h34sm60200pjb.47.2020.04.08.09.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 09:59:45 -0700 (PDT)
Date:   Wed, 8 Apr 2020 09:59:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: checking of validity of user vaddr in vfio_dma_rw
Message-ID: <202004080959.8C71F8DF7@keescook>
References: <20200408071121.25645-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408071121.25645-1-yan.y.zhao@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 08, 2020 at 03:11:21AM -0400, Yan Zhao wrote:
> instead of calling __copy_to/from_user(), use copy_to_from_user() to
> ensure vaddr range is a valid user address range before accessing them.
> 
> Cc: Kees Cook <keescook@chromium.org>
> 
> Fixes: 8d46c0cca5f4 ("vfio: introduce vfio_dma_rw to read/write a range of IOVAs")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

Thanks!

Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/vfio/vfio_iommu_type1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 3aefcc8e2933..fbc58284b333 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2345,10 +2345,10 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  	vaddr = dma->vaddr + offset;
>  
>  	if (write)
> -		*copied = __copy_to_user((void __user *)vaddr, data,
> +		*copied = copy_to_user((void __user *)vaddr, data,
>  					 count) ? 0 : count;
>  	else
> -		*copied = __copy_from_user(data, (void __user *)vaddr,
> +		*copied = copy_from_user(data, (void __user *)vaddr,
>  					   count) ? 0 : count;
>  	if (kthread)
>  		unuse_mm(mm);
> -- 
> 2.17.1
> 

-- 
Kees Cook
