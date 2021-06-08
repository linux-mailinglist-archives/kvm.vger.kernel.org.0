Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B5E3A05FD
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhFHV25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:28:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231760AbhFHV2z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 17:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANhdFVJMgOPlVeqKKH+dsmD0siNPfDTKlYNgvOQ5R3o=;
        b=iNtVZs9FUpi1ae3CShJl5CKLiHXeRv1KyAPR8p3JMcnbptJUdGMjsC0h/l6BUHFBuL5G93
        xqVIASxrxcyAs5l1zdZFn+thli19pxBhJx708HhcRah4m07Y+jh885/GVOxO7lYGIt4NVj
        bZd6UJjNvkODVgz45ScA6ViI2whRIVo=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-lTULs2kCNl2C0elZSKei-A-1; Tue, 08 Jun 2021 17:26:58 -0400
X-MC-Unique: lTULs2kCNl2C0elZSKei-A-1
Received: by mail-ot1-f70.google.com with SMTP id f7-20020a9d5e870000b02902f479dba730so14763005otl.21
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ANhdFVJMgOPlVeqKKH+dsmD0siNPfDTKlYNgvOQ5R3o=;
        b=n1qzg+OfYzMRenPym8TddUF7B9JgOecH8+4P5mBOf/Vk8/eWbTLr1WtLCp8Sk4hbjn
         8mu54rUnoAf67lIBGoYEluNzMmkfjRUHY8t0lqSKonddLfcJzRQcBRPdHc6/h5uMh1Qv
         ZIHVLPIU5jV/g3kAJG+JhEsDhu9Twyn+WCdFpFtXYKQjJe1eq4AvfUxG1qOhwMNIrrXI
         IXSeSsAIh/d/aB5YlBR3DyWSdYe/rH57SGKg8Gy//IJprcF/lAheih7j0YohjGfe8B7V
         ycyiYFdK7tS9gl4J+EGBkJ1IK0Fo62qESJ1JfXMXTe65eY1soyIR27ZTNjgu9IzHWqkN
         bcUg==
X-Gm-Message-State: AOAM5331fQE1L489/pNXSLEAchMRjOgt+lUgwStlW1pzijQ0nG+wNnFJ
        GydpJCBpnceQF2XMkxoFYDX34t4+qWgUmsVhLqXeqy1jWpEHr01AMQy+9VnB1tiU70O772PC75Q
        2c48eoZVUmgFw
X-Received: by 2002:a05:6808:13cb:: with SMTP id d11mr4168938oiw.138.1623187618240;
        Tue, 08 Jun 2021 14:26:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRvvGc6tdMNzZeUwij7tWuvUu215rQbuWwhep+IMzXG4f8s5RDIMcZh3VVPI9xldH1Y0wBIw==
X-Received: by 2002:a05:6808:13cb:: with SMTP id d11mr4168914oiw.138.1623187618064;
        Tue, 08 Jun 2021 14:26:58 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w8sm2086647otk.16.2021.06.08.14.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:26:57 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:26:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>
Subject: Re: [PATCH 10/11] vfio-pci: introduce vfio_pci_core subsystem
 driver
Message-ID: <20210608152656.5aa4cfa3.alex.williamson@redhat.com>
In-Reply-To: <20210603160809.15845-11-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-11-mgurtovoy@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 19:08:08 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 5e2e1b9a9fd3..384d06661f30 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -config VFIO_PCI
> -	tristate "VFIO support for PCI devices"
> +config VFIO_PCI_CORE
> +	tristate "VFIO core support for PCI devices"
>  	depends on VFIO && PCI && EVENTFD
>  	depends on MMU
>  	select VFIO_VIRQFD
> @@ -11,9 +11,17 @@ config VFIO_PCI
>  
>  	  If you don't know what to do here, say N.
>  
> +config VFIO_PCI
> +	tristate "VFIO support for PCI devices"
> +	depends on VFIO_PCI_CORE
> +	help
> +	  This provides a generic PCI support using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> +

I think it's going to generate a lot of user and distro frustration to
hide VFIO_PCI behind a new VFIO_PCI_CORE option.  The core should be a
dependency *selected* by the drivers, not a prerequisite for the
driver.  Thanks,

Alex

