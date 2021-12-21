Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1068B47C806
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhLUUGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 15:06:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229916AbhLUUGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 15:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640117163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPYFoqLCmg5azjJZ4qzolcn1IlMHROpllp+HZVw/bJE=;
        b=YAuMEhGH9qCYTxEolsefU9fOpMtewwMea+lJg9o3InrvMrlW7C5PQ8aZLgUrrnKSrstoqW
        ubM+jMke6gqMYbFBBiPa/lyG5C1F5wmX3HirwNzCzZdv1yMKNUC6H4qZBOQJ++XL68Depo
        8TLShwnE/RmInpb4K0J1ObXmZpnbtJQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-eOmPPYgqPpm8qLlnqMKObw-1; Tue, 21 Dec 2021 15:06:01 -0500
X-MC-Unique: eOmPPYgqPpm8qLlnqMKObw-1
Received: by mail-oi1-f200.google.com with SMTP id s37-20020a05680820a500b002bcbae866f9so153130oiw.6
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 12:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPYFoqLCmg5azjJZ4qzolcn1IlMHROpllp+HZVw/bJE=;
        b=UTF6IZMVfBQOlzcJabmyD07uijYJfz90QiTnOaiAAOP5rmpB7zazK0RglgS4gIvK3g
         HnL6qXDGnJaxZc/u81XoUy7OZzq5/c2zhcXDFtSuMIVo2vRlZxG2VrtyFUi2LuQtfi5q
         DSMzY0ZPkgHFh3xT62tQusgvEyOBvzaHnUEWEOU4viOFqkXzbqCHONKhuTWocu3M/bOl
         HA43lqGRgsx7I2kh/H0kcVJnolVsr8m0MExqH+CoCyP7o6/j6ZNjcfD4CROvZp2W1E/6
         A2QEWoA3W+spnRXlmW/ch65Sd1DHRog+7q/S/H6Nsp64MPIgw+/dtkhTyF/TUdKlB8Bc
         Q2XA==
X-Gm-Message-State: AOAM532d7lbLeRk97faVm8bV5chPDAgkq4k6MDQnJ9ps/tZtFC3WSC5P
        abd+FOvzkcFSzAE0/FXOviToNMsBoU/BEr2w9+h72COovSEf4q1m7Kyqr9yRS/mozkZL+KxcfQU
        ra9RjW/w7RY0e
X-Received: by 2002:a4a:ba86:: with SMTP id d6mr3097667oop.87.1640117160933;
        Tue, 21 Dec 2021 12:06:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKcc85CqvRTsIEyT3YGa96VE4CKrrC8+f5tHfYAoGdAqeg7f/d51Oo1XHdMTMkrd/nrCfmgw==
X-Received: by 2002:a4a:ba86:: with SMTP id d6mr3097658oop.87.1640117160718;
        Tue, 21 Dec 2021 12:06:00 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u28sm3806327otj.57.2021.12.21.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:06:00 -0800 (PST)
Date:   Tue, 21 Dec 2021 13:05:58 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jiacheng Shi <billsjc@sjtu.edu.cn>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/iommu_type1: replace kfree with kvfree
Message-ID: <20211221130558.2640c363.alex.williamson@redhat.com>
In-Reply-To: <20211212091600.2560-1-billsjc@sjtu.edu.cn>
References: <20211212091600.2560-1-billsjc@sjtu.edu.cn>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Dec 2021 01:16:00 -0800
Jiacheng Shi <billsjc@sjtu.edu.cn> wrote:

> Variables allocated by kvzalloc should not be freed by kfree.
> Because they may be allocated by vmalloc.
> So we replace kfree with kvfree here.
> 
> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Signed-off-by: Jiacheng Shi <billsjc@sjtu.edu.cn>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index f17490ab238f..9394aa9444c1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -256,7 +256,7 @@ static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
>  
>  static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>  {
> -	kfree(dma->bitmap);
> +	kvfree(dma->bitmap);
>  	dma->bitmap = NULL;
>  }
>  

Looks good to me, applied to vfio next branch for v5.17.  Thanks,

Alex

