Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD65920A18
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfEPOsl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 May 2019 10:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfEPOsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 10:48:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 626148F039;
        Thu, 16 May 2019 14:48:36 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75BBD5D6A9;
        Thu, 16 May 2019 14:48:34 +0000 (UTC)
Date:   Thu, 16 May 2019 08:48:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "richard.peng@oppo.com" <richard.peng@oppo.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: vfio_pci_nvlink2: use a vma helper function
Message-ID: <20190516084833.757140bc@x1.home>
In-Reply-To: <2019051620382477288130@oppo.com>
References: <2019051620382477288130@oppo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 16 May 2019 14:48:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc Alexey + kvm]

On Thu, 16 May 2019 20:38:26 +0800
"richard.peng@oppo.com" <richard.peng@oppo.com> wrote:

> Use a vma helper function to simply code.
> 
> Signed-off-by: Peng Hao <richard.peng@oppo.com>
> ---
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index 32f695ffe128..dc42aa0e47f6 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -161,8 +161,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
>  
>  	atomic_inc(&data->mm->mm_count);
>  	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
> -			(vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
> -			data->gpu_hpa, &data->mem);
> +			vma_pages(vma), data->gpu_hpa, &data->mem);
>  
>  	trace_vfio_pci_nvgpu_mmap(vdev->pdev, data->gpu_hpa, data->useraddr,
>  			vma->vm_end - vma->vm_start, ret);
> -- 
> 2.20.1
