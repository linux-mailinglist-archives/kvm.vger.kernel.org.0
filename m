Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B27132C60
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 18:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAGRAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 12:00:34 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46142
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728211AbgAGRAe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jan 2020 12:00:34 -0500
X-IronPort-AV: E=Sophos;i="5.69,406,1571695200"; 
   d="scan'208";a="335051849"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 18:00:31 +0100
Date:   Tue, 7 Jan 2020 18:00:31 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: julia@hadrien
To:     Alex Williamson <alex.williamson@redhat.com>
cc:     kernel-janitors@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: vfio_pci_nvlink2: use mmgrab
In-Reply-To: <20200106160505.2f962d38@w520.home>
Message-ID: <alpine.DEB.2.21.2001071800090.3004@hadrien>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr> <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr> <20200106160505.2f962d38@w520.home>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Mon, 6 Jan 2020, Alex Williamson wrote:

> On Sun, 29 Dec 2019 16:42:56 +0100
> Julia Lawall <Julia.Lawall@inria.fr> wrote:
>
> > Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
> > helper") and most of the kernel was updated to use it. Update a
> > remaining file.
> >
> > The semantic patch that makes this change is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > <smpl>
> > @@ expression e; @@
> > - atomic_inc(&e->mm_count);
> > + mmgrab(e);
> > </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> >
> > ---
> >  drivers/vfio/pci/vfio_pci_nvlink2.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> > index f2983f0f84be..43df10af7f66 100644
> > --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> > +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> > @@ -159,7 +159,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
> >  	data->useraddr = vma->vm_start;
> >  	data->mm = current->mm;
> >
> > -	atomic_inc(&data->mm->mm_count);
> > +	mmgrab(data->mm);
> >  	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
> >  			vma_pages(vma), data->gpu_hpa, &data->mem);
> >
> >
>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
>
> Thanks!  I'm assuming these will be routed via janitors tree, please
> let me know if you intend me to grab these two vfio patches from the
> series.  Thanks,

Please take them directly.

thanks,
julia
