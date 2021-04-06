Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF7F355C3C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241805AbhDFTht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241408AbhDFThr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 15:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617737859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oN4lQwe39DmpzV8zNB7m8jKeorv4VWju//qpmvx/Crs=;
        b=V8XAa/3lKMLWjWObyxy1Vn+gPVq1rrxUn4QmZgfyuKuuUUv8x9/Ka6exM0XYSNcHuJSHro
        nnQd+64IJjvoep/mKF543NvOHhJdiQ4XRqbC0UpzPkmiLbALXgVcLwtBa3N4omX+6KzqaF
        CEN5ta5iUXy77syxWmrI2+v5+dIdKuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55--nz6wfRdN5enfZYvE3mBhA-1; Tue, 06 Apr 2021 15:37:34 -0400
X-MC-Unique: -nz6wfRdN5enfZYvE3mBhA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58325911E4;
        Tue,  6 Apr 2021 19:37:30 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 381AA369A;
        Tue,  6 Apr 2021 19:37:25 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:37:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     cohuck@redhat.com, kevin.tian@intel.com, akpm@linux-foundation.org,
        peterx@redhat.com, giovanni.cabiddu@intel.com, walken@google.com,
        jannh@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] vfio: pci: Spello fix in the file vfio_pci.c
Message-ID: <20210406133724.38692cf3@omen>
In-Reply-To: <20210314052925.3560-1-unixbhaskar@gmail.com>
References: <20210314052925.3560-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 14 Mar 2021 10:59:25 +0530
Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/permision/permission/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 706de3ef94bb..62f137692a4f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2411,7 +2411,7 @@ static int __init vfio_pci_init(void)
>  {
>  	int ret;
> 
> -	/* Allocate shared config space permision data used by all devices */
> +	/* Allocate shared config space permission data used by all devices */
>  	ret = vfio_pci_init_perm_bits();
>  	if (ret)
>  		return ret;
> --
> 2.26.2
> 

Applied to vfio next branch for v5.13.  Thanks,

Alex

