Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F7F34C85
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfFDPoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 11:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfFDPoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 11:44:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44779A0B61;
        Tue,  4 Jun 2019 15:44:46 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F3EB6057D;
        Tue,  4 Jun 2019 15:44:45 +0000 (UTC)
Date:   Tue, 4 Jun 2019 17:44:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        farman@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [PATCH v1 1/1] vfio-ccw: Destroy kmem cache region on module
 exit
Message-ID: <20190604174443.6f29a87e.cohuck@redhat.com>
In-Reply-To: <c0f39039d28af39ea2939391bf005e3495d890fd.1559576250.git.alifm@linux.ibm.com>
References: <cover.1559576250.git.alifm@linux.ibm.com>
        <c0f39039d28af39ea2939391bf005e3495d890fd.1559576250.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 04 Jun 2019 15:44:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Jun 2019 11:42:47 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> Free the vfio_ccw_cmd_region on module exit.

Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")

> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
> 
> I guess I missed this earlier while reviewing, but should'nt 
> we destroy the vfio_ccw_cmd_region on module exit, as well?
> 
>  drivers/s390/cio/vfio_ccw_drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 66a66ac..9cee9f2 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -299,6 +299,7 @@ static void __exit vfio_ccw_sch_exit(void)
>  	css_driver_unregister(&vfio_ccw_sch_driver);
>  	isc_unregister(VFIO_CCW_ISC);
>  	kmem_cache_destroy(vfio_ccw_io_region);
> +	kmem_cache_destroy(vfio_ccw_cmd_region);
>  	destroy_workqueue(vfio_ccw_work_q);
>  }
>  module_init(vfio_ccw_sch_init);

Thanks, applied.
