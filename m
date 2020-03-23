Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D861900E2
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 23:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgCWWHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 18:07:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39612 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgCWWHC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 18:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585001221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dlnnCp+CN7Ddgykcpr9TWFrMI6YSlr7ZIhIFOrJ+XbA=;
        b=CE9imQNTEj+o+8Ovoy/fFH31ZlWIa3LxqBDGJbE80hfJAH2YwwF/pvab6MFMWLJb68zGoy
        mY5BbU5Pg1VIt61rweYBU7CJaYsFek41/9joSV7htuj+afPWhhJV+vymykGZ5+yWRSUHRp
        QscwOSMHe6kASwxuYaX4mvbsTBujDxk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-Tj-owEH0MMW7cYvmWrNIxA-1; Mon, 23 Mar 2020 18:07:00 -0400
X-MC-Unique: Tj-owEH0MMW7cYvmWrNIxA-1
Received: by mail-wm1-f72.google.com with SMTP id n188so528148wmf.0
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 15:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dlnnCp+CN7Ddgykcpr9TWFrMI6YSlr7ZIhIFOrJ+XbA=;
        b=cFaz27DflMqWL5GpIiY6SXR33pbFhiOQtI0ScGB9x5voZAzbq4BSuwxIRaVA0qBIoX
         GbNW62m5fdzb8qAhegTSvgF9B0bE6vVZg424lYlt+zJIjjAQ1embFpJO3NlaRJ/pN6+0
         7cfdL8b6DdDRsHFf/wWXRs7WFYYLsfsqyp0GP9SZbgS5eszqQ/FqN9DgNvW3rwcchkLS
         8xE74yMFMi7ttuL3jkv6FqZloal2RvuV+Z++52AucNuWHBOTlYSHVmJQilaXv6Y4QSXU
         ttUhCsKHEHOjkluW6KYEXQta9KXd1viDYl7bzhOtFI2PaA/yGvXCyit9ZWWu3Hdr2vVz
         pQmg==
X-Gm-Message-State: ANhLgQ2WkMOKBiuS3UYUrZZbkubnmMeaLgkwuEi6YFHTls2vxsoBt12L
        Zg56Dt2VlrBFcbIDxih/bc4NMFRc6xC8VoCWgkH/WheokUXQoBlTaEzTrz9GcGKXpMNQR1ZhV7O
        u1Vo5fZujaaij
X-Received: by 2002:a1c:4645:: with SMTP id t66mr1700166wma.6.1585001218947;
        Mon, 23 Mar 2020 15:06:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsAyyZRneAjCk4wKljM0NG4hzHtL55UEQ6TzSXls1zwplL0INr7A6Q09TsiongDtXfBzX+pGg==
X-Received: by 2002:a1c:4645:: with SMTP id t66mr1700142wma.6.1585001218695;
        Mon, 23 Mar 2020 15:06:58 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s131sm1271901wmf.35.2020.03.23.15.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:06:57 -0700 (PDT)
Date:   Mon, 23 Mar 2020 18:06:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 09/22] vfio/common: check PASID alloc/free availability
Message-ID: <20200323220653.GT127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-10-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-10-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:06AM -0700, Liu Yi L wrote:

[...]

> @@ -1256,11 +1334,19 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>      }
>  
>      if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
> -        /*
> -         * TODO: config flags per host IOMMU nesting capability
> -         * e.g. check if VFIO_TYPE1_NESTING_IOMMU supports PASID
> -         * alloc/free
> -         */
> +        struct vfio_iommu_type1_info_cap_nesting nesting = {
> +                                         .nesting_capabilities = 0x0,
> +                                         .stage1_formats = 0, };
> +
> +        ret = vfio_get_nesting_iommu_cap(container, &nesting);
> +        if (ret) {
> +            error_setg_errno(errp, -ret,
> +                             "Failed to get nesting iommu cap");
> +            return ret;
> +        }
> +
> +        flags |= (nesting.nesting_capabilities & VFIO_IOMMU_PASID_REQS) ?
> +                 HOST_IOMMU_PASID_REQUEST : 0;

I replied in the previous patch but I forgot to use reply-all...

Anyway I'll comment again here - I think it'll be slightly better we
use the previous patch to only offer the vfio specific hooks, and this
patch to do all the rest including host_iommu_ctx_init() below, which
will avoid creating the host_iommu_ctx_init().

Thanks,

>          host_iommu_ctx_init(&container->host_icx,
>                              sizeof(container->host_icx),
>                              TYPE_VFIO_HOST_IOMMU_CONTEXT,
> -- 
> 2.7.4
> 

-- 
Peter Xu

