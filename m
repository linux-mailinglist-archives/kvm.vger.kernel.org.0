Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7177D26153A
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgIHQ36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 12:29:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731954AbgIHQ1P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 12:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599582433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CC6snRcqKb2t7XNU71lQO9/4I3L77xl85sRYz1Cl09k=;
        b=bTU9jE97fZaaUoVZYRvEr+OUHzTRPESnzYpKMWK1PHBYfsiu73DhbkzG6PQ7qgBtD2YBJo
        c48EqG/cyq2dE5DgcsQlFjL5AU+RBFC/T1iPVJCUMcC4uXMyVHUAlpdG42um8ai69rZkxG
        TPyolmarIJ/xPtNhg84rS1S2PlXoZeM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-ERN3ABuDN8GE57k_KPDQFg-1; Tue, 08 Sep 2020 08:01:48 -0400
X-MC-Unique: ERN3ABuDN8GE57k_KPDQFg-1
Received: by mail-wr1-f70.google.com with SMTP id r16so6859551wrm.18
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 05:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CC6snRcqKb2t7XNU71lQO9/4I3L77xl85sRYz1Cl09k=;
        b=OuvUKqI6Hszapfg82JxR9ZBDM0/hrjLl/Cx9ImsNmsTuwZVdzB5Tko5hbL1gykj5wE
         fFN6wrywJd75iybuezGzF1OSOxNGrSKz8XDq8VEsWu1fMNnHZC8YimpoiAwx++Z118qL
         DMJHC2UE5GwP7NliYG76UjkUyH3gA7yjMzhPS5RMWknnLXwlDhyEdg/jm0nQlONxSqa9
         D8anyMAVzVm29scJOaW53aPe090xDqUoFO7WVPKcGiGiTU0MKGWlXsDAS85GwBkoqFb4
         cSCx2JiSEuVuRSkqKXPpJ3tsinR4KXk5d2eW37fO2IbElKISCkmPgnGcFNpOB6cfz2ue
         GmTQ==
X-Gm-Message-State: AOAM533eHfPuzqL8n0ZnYKbxW+sI624AIeOyY+5qKRsZRG3szt9vqT8R
        KsKKsAJw+WIFYY+msdG3YC7jrL5esflt1/K0PXT7aJRdUPq2H3IGKzArJ3SIrNIM2pIHNVLxNgf
        T0JXsTS278k/w
X-Received: by 2002:a5d:4081:: with SMTP id o1mr9551426wrp.338.1599566507498;
        Tue, 08 Sep 2020 05:01:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIGUEV8/cOCR67/kfmxrIo77XblP+6o6ELbpGYr44ROyHpydGLeWxhd6eBSChaGzE6GwIXDQ==
X-Received: by 2002:a5d:4081:: with SMTP id o1mr9551409wrp.338.1599566507251;
        Tue, 08 Sep 2020 05:01:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-221-30.inter.net.il. [80.230.221.30])
        by smtp.gmail.com with ESMTPSA id d13sm8457295wrp.44.2020.09.08.05.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:01:46 -0700 (PDT)
Date:   Tue, 8 Sep 2020 08:01:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Dai, Lang" <lang.dai@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wang, Yuan1" <yuan1.wang@intel.com>
Subject: Re: [PATCH] A patch for uio to fix an error of "Failed to register
 UIO devices"
Message-ID: <20200908075929-mutt-send-email-mst@kernel.org>
References: <BN6PR11MB1971A3E5460B11C9589170DB89290@BN6PR11MB1971.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB1971A3E5460B11C9589170DB89290@BN6PR11MB1971.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 08:58:53AM +0000, Dai, Lang wrote:
> Hi,
> 
> This patch is for uio to fix an error of "Failed to register UIO devices". We encountered this uio error when we tried to attached and disconnected devices to a VM many times for pressure test.
> 
> Could you please help to review this patch and give some advices?
> Thanks a lot.
> 
> 
> commit 5c005f479e61a523f473b38361d2b241a24538ca
> Author: Lang Dai <lang.dai@intel.com<mailto:lang.dai@intel.com>>
> Date:   Mon Sep 7 13:21:39 2020 +0800
> 
>     UBUNTU: uio: free uio id after uio file node is freed
> 
>     uio_register_device() do two things.
>     1) get an uio id from a global pool, e.g. the id is <A>
>     2) create file nodes like /sys/class/uio/uio<A>
> 
>     uio_unregister_device() do two things.
>     1) free the uio id <A> and return it to the global pool
>     2) free the file node /sys/class/uio/uio<A>
> 
>     There is a situation is that one worker is calling uio_unregister_device(),
>     and another worker is calling uio_register_device().
>     If the two workers are X and Y, they go as below sequence,
>     1) X free the uio id <AAA>
>     2) Y get an uio id <AAA>
>     3) Y create file node /sys/class/uio/uio<AAA>
>     4) X free the file note /sys/class/uio/uio<AAA>
>     Then it will failed at the 3rd step and cause the phenomenon we saw as it
>     is creating a duplicated file node.
> 
>     Failure reports as follows:
>     sysfs: cannot create duplicate filename '/class/uio/uio10'
>     Call Trace:
>        sysfs_do_create_link_sd.isra.2+0x9e/0xb0
>        sysfs_create_link+0x25/0x40
>        device_add+0x2c4/0x640
>        __uio_register_device+0x1c5/0x576 [uio]
>        adf_uio_init_bundle_dev+0x231/0x280 [intel_qat]
>        adf_uio_register+0x1c0/0x340 [intel_qat]
>        adf_dev_start+0x202/0x370 [intel_qat]
>        adf_dev_start_async+0x40/0xa0 [intel_qat]
>        process_one_work+0x14d/0x410
>        worker_thread+0x4b/0x460
>        kthread+0x105/0x140
>      ? process_one_work+0x410/0x410
>      ? kthread_bind+0x40/0x40
>      ret_from_fork+0x1f/0x40
>      Code: 85 c0 48 89 c3 74 12 b9 00 10 00 00 48 89 c2 31 f6 4c 89 ef e8 ec c4 ff ff 4c 89 e2 48 89 de 48 c7 c7 e8 b4 ee b4 e8 6a d4 d7 ff <0f> 0b 48 89 df e8 20 fa f3 ff 5b 41 5c 41 5d 5d c3 66 0f 1f 84
>     ---[ end trace a7531c1ed5269e84 ]---
>      c6xxvf b002:00:00.0: Failed to register UIO devices
>      c6xxvf b002:00:00.0: Failed to register UIO devices
> 
>     Signed-off-by: Lang Dai <lang.dai@intel.com<mailto:lang.dai@intel.com>>


This isn't the right way to format patches, use git format-patch and
git send-email.

> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 73efb80..6dca744 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -1048,8 +1048,6 @@ void uio_unregister_device(struct uio_info *info)
> 
>         idev = info->uio_dev;
> 
> -       uio_free_minor(idev);
> -
>         mutex_lock(&idev->info_lock);
>         uio_dev_del_attributes(idev);
> 
> @@ -1064,6 +1062,8 @@ void uio_unregister_device(struct uio_info *info)
> 
>         device_unregister(&idev->dev);
> 
> +       uio_free_minor(idev);
> +
>         return;
> }
> EXPORT_SYMBOL_GPL(uio_unregister_device);


The patch itself makes sense since cleanup should be in
the reverse order of initialization.
However, pls fix error path in __uio_register_device to also be in
the same order.

Thanks!


> (END)
> 
> Best Regards,
> Dai, Lang

