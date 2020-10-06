Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E575284F1E
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFPkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJFPkE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVKzhPnNWnTR0T+C26GTxek83BgSeJCF9XBuHyTo+SM=;
        b=Evx0L7TBkEkQzWo7PDuuduruP5D9TPqZ0+kaX00uW6iqKOpT12o1ZcWfy+33ZKKfjGaigq
        WOzeXFXlgxy2YNuU+YqLeCipaZRJLGHfMFNbe0kkxSGVzW7PZhxw225BN+V+m2mLSdL5aN
        Nv3EqO76foIkUCYcrkUSomFs23OqC0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-ud2z3xMLP46eJ3pD_4YUxQ-1; Tue, 06 Oct 2020 11:40:01 -0400
X-MC-Unique: ud2z3xMLP46eJ3pD_4YUxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10D2D1868412;
        Tue,  6 Oct 2020 15:40:00 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 503EA55767;
        Tue,  6 Oct 2020 15:39:47 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:39:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/9] linux-headers: update against 5.9-rc7
Message-ID: <20201006173944.611048c5.cohuck@redhat.com>
In-Reply-To: <1601669191-6731-5-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
        <1601669191-6731-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:06:26 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> PLACEHOLDER as the kernel patch driving the need for this ("vfio-pci/zdev:
> define the vfio_zdev header") isn't merged yet.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h         | 14 +++++++-------
>  linux-headers/linux/kvm.h                                  |  6 ++++--
>  linux-headers/linux/vfio.h                                 |  5 +++++
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> index 7b4062a..acd4c83 100644
> --- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> +++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> @@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
>  
>  static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>  {
> -	const unsigned int idx = qatomic_read(var);
> +	const unsigned int idx = atomic_read(var);

Hm... either this shouldn't have been renamed to qatomic_read() in the
first place, or we need to add some post-processing to the update
script.

>  
>  	if (pvrdma_idx_valid(idx, max_elems))
>  		return idx & (max_elems - 1);

