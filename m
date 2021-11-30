Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBCE463EA2
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbhK3TeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 14:34:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343513AbhK3Tdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 14:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638300636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ab/eEvberRXEPRpb3m3KuYEHLhIA3GZ7+BfNOiqphxQ=;
        b=SPP9kY3zmKN1i4+TgGRibG23GUswozRzDOH2V0V1m+5qPcTeztFeP8W/p3gzQC9Y3kSdoW
        MeFqhCRXrp0OV+9kyPJCnbeLpciFblEvaAJ3nmXOeUpVYl+TV4Xe3dKViMe3wIw857e1lK
        RsPNwX48QQx2QWXF3d76s6DSYm7xeKA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-273-GNWGMUG_OxudPK2QGH3hRA-1; Tue, 30 Nov 2021 14:30:34 -0500
X-MC-Unique: GNWGMUG_OxudPK2QGH3hRA-1
Received: by mail-oi1-f197.google.com with SMTP id bm27-20020a0568081a9b00b002bd445624cdso14543963oib.11
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 11:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ab/eEvberRXEPRpb3m3KuYEHLhIA3GZ7+BfNOiqphxQ=;
        b=wK3RC1e+sbbHzZ9hTGt+2Yq6icy/bneRZO0L03ugSAnv2t7Yo6oXrOnQyrE/4k7PWZ
         c/YBYTCKRGJCgumStTE3XjhfQjtGK9Kwzw9hmlD7z803J1zSTM4Wz7sVK+DjSwtWWolF
         ReVhnOB1wwjEnuIcrtbFltq1tki4dA79Ecfw1cqJK/uvvVTXKx+pLXUTvJr1szOSZQaq
         WLbhhmwuyCeD9fhIzY9wqvAxVinxB8CDf9OircMDmLrqnku4Bh99Jy7cGWIeOQ3aqUUz
         fxhIUl70MN501IRWvFraeNub6Wb44L1f4g/xcPftNTWQ3wBnYg66DmFUXWrY2JOOcwEZ
         5D7w==
X-Gm-Message-State: AOAM532cl6PQbRAddn1q+I5XuEYrtdjGoAOq44NZBkeN/nswLRG13t/z
        ElX8GaHWOjDBTk8CMnbTyFfCamWIg1WVS0+1eF+7Hs3zgcyWSt8zNna/mNyqLn28FjO0Z3aoYOk
        GhzixiAg38i1C
X-Received: by 2002:a05:6808:1644:: with SMTP id az4mr1031477oib.86.1638300633999;
        Tue, 30 Nov 2021 11:30:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3Si/RLkbte2UbCSB+fXYe0z9rbN1DldK0ufEbhrVBrNTEHU0y5Rd9OyyNvf+l26pUv4YugA==
X-Received: by 2002:a05:6808:1644:: with SMTP id az4mr1031454oib.86.1638300633775;
        Tue, 30 Nov 2021 11:30:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e14sm3815037oie.7.2021.11.30.11.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 11:30:33 -0800 (PST)
Date:   Tue, 30 Nov 2021 12:30:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: drivers/vfio/vfio.c:293: warning: expecting prototype for
 Container objects(). Prototype was for vfio_container_get() instead
Message-ID: <20211130123032.035e06a3.alex.williamson@redhat.com>
In-Reply-To: <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
References: <202111102328.WDUm0Bl7-lkp@intel.com>
        <20211110164256.GY1740502@nvidia.com>
        <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Nov 2021 15:19:40 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/10/21 8:42 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 10, 2021 at 11:12:39PM +0800, kernel test robot wrote:  
> >> Hi Jason,
> >>
> >> FYI, the error/warning still remains.  
> > 
> > This is just a long standing kdoc misuse.
> > 
> > vfio is not W=1 kdoc clean.
> > 
> > Until someone takes a project to fix this comprehensively there is not
> > much point in reporting new complaints related the existing mis-use..  
> 
> Hi,
> 
> Can we just remove all misused "/**" comments in vfio.c until
> someone cares enough to use proper kernel-doc there?
> 
> ---
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: [PATCH] vfio/vfio: remove all kernel-doc notation
> 
> vfio.c abuses (misuses) "/**", which indicates the beginning of
> kernel-doc notation in the kernel tree. This causes a bunch of
> kernel-doc complaints about this source file, so quieten all of
> them by changing all "/**" to "/*".
> 
> vfio.c:236: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * IOMMU driver registration
> vfio.c:236: warning: missing initial short description on line:
>   * IOMMU driver registration
> vfio.c:295: warning: expecting prototype for Container objects(). Prototype was for vfio_container_get() instead
> vfio.c:317: warning: expecting prototype for Group objects(). Prototype was for __vfio_group_get_from_iommu() instead
> vfio.c:496: warning: Function parameter or member 'device' not described in 'vfio_device_put'
> vfio.c:496: warning: expecting prototype for Device objects(). Prototype was for vfio_device_put() instead
> vfio.c:599: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Async device support
> vfio.c:599: warning: missing initial short description on line:
>   * Async device support
> vfio.c:693: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO driver API
> vfio.c:693: warning: missing initial short description on line:
>   * VFIO driver API
> vfio.c:835: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Get a reference to the vfio_device for a device.  Even if the
> vfio.c:835: warning: missing initial short description on line:
>   * Get a reference to the vfio_device for a device.  Even if the
> vfio.c:969: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO base fd, /dev/vfio/vfio
> vfio.c:969: warning: missing initial short description on line:
>   * VFIO base fd, /dev/vfio/vfio
> vfio.c:1187: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO Group fd, /dev/vfio/$GROUP
> vfio.c:1187: warning: missing initial short description on line:
>   * VFIO Group fd, /dev/vfio/$GROUP
> vfio.c:1540: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO Device fd
> vfio.c:1540: warning: missing initial short description on line:
>   * VFIO Device fd
> vfio.c:1615: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1615: warning: missing initial short description on line:
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1663: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1663: warning: missing initial short description on line:
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1742: warning: Function parameter or member 'caps' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'size' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'id' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'version' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: expecting prototype for Sub(). Prototype was for vfio_info_cap_add() instead
> vfio.c:2276: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Module/class support
> vfio.c:2276: warning: missing initial short description on line:
>   * Module/class support
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
>   drivers/vfio/vfio.c |   28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)

These were never intended to be kernel-doc, thanks for the cleanup.
I've scraped this into my for-linus branch with Jason and Connie's acks
for v5.16.  Thanks,

Alex

