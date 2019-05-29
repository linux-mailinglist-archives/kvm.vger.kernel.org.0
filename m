Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76BF2E75D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfE2VX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 17:23:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfE2VX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 17:23:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E9C63082B40;
        Wed, 29 May 2019 21:23:56 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 129FA60C4E;
        Wed, 29 May 2019 21:23:56 +0000 (UTC)
Date:   Wed, 29 May 2019 15:23:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Thomas Meyer" <thomas@m3y3r.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio-pci/nvlink2: Use vma_pages function instead of
 explicit computation
Message-ID: <20190529152355.5ea4823f@x1.home>
In-Reply-To: <1559160524648-1049343203-1-diffsplit-thomas@m3y3r.de>
References: <1559160524618-2047588593-0-diffsplit-thomas@m3y3r.de>
        <1559160524648-1049343203-1-diffsplit-thomas@m3y3r.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 29 May 2019 21:23:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 May 2019 22:11:06 +0200
"Thomas Meyer" <thomas@m3y3r.de> wrote:

> Use vma_pages function on vma object instead of explicit computation.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -161,7 +161,7 @@ static int vfio_pci_nvgpu_mmap(struct vf
>  
>  	atomic_inc(&data->mm->mm_count);
>  	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
> -			(vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
> +			vma_pages(vma),
>  			data->gpu_hpa, &data->mem);
>  
>  	trace_vfio_pci_nvgpu_mmap(vdev->pdev, data->gpu_hpa, data->useraddr,

Not sure if our emails crossed in flight[1], but the other patch[2]
still has precedence.  You're welcome to add a reviewed-by.  Thanks,

Alex

[1]https://lkml.org/lkml/2019/5/29/871
[2]https://lkml.org/lkml/2019/5/16/658
