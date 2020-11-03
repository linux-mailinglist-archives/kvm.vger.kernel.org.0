Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A252A4E43
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgKCSUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:20:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgKCSUQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rB8I6G9qs+tpAlTkO14nybmm3TLGcS/K/5ez3RfylJc=;
        b=bOOaT0eFTyHkC4Fzygopow6kKjIVhgh2Uit5XoEwwgNic9f2/786IvMrDxsgw7aOOlDx22
        RsJFA4+cjnhRHK8GdfEyj3nB2/YtCkGVfFSRYq+Uka4VARiRKXhDvYHDF89XGwHa2DpKbx
        58W2W9mK/z61R4oOpkErlk/ey4EYpBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-4z9JkQCvOt6XCXuszhUokQ-1; Tue, 03 Nov 2020 13:20:11 -0500
X-MC-Unique: 4z9JkQCvOt6XCXuszhUokQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C2BD809DDB;
        Tue,  3 Nov 2020 18:20:10 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2931F5B4D8;
        Tue,  3 Nov 2020 18:20:10 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:20:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com
Subject: Re: [PATCH] vfio/fsl-mc: Make vfio_fsl_mc_irqs_allocate static
Message-ID: <20201103112009.4d00dcb5@w520.home>
In-Reply-To: <20201026165336.31125-1-diana.craciun@oss.nxp.com>
References: <20201026165336.31125-1-diana.craciun@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Oct 2020 18:53:36 +0200
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> Fixed compiler warning:
> drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c:16:5: warning: no previous
> prototype for function 'vfio_fsl_mc_irqs_allocate' [-Wmissing-prototypes]
>        ^
> drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c:16:1: note: declare 'static'
> if the function is not intended to be used outside of this translation unit
> int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio for-linus branch for v5.10.  Thanks,

Alex


> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> index c80dceb46f79..0d9f3002df7f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -13,7 +13,7 @@
>  #include "linux/fsl/mc.h"
>  #include "vfio_fsl_mc_private.h"
>  
> -int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
> +static int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
>  {
>  	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>  	struct vfio_fsl_mc_irq *mc_irq;

