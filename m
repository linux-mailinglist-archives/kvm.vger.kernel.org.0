Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44239273F46
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 12:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIVKMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 06:12:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVKMf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 06:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600769554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQmzRrjIum2j+21S/6G+AhIckADHxRgR/1XpoCciLss=;
        b=Sa5e9D8L5bv+424X4enxxGTpkbX5ZwgYfjVAdQ1oC8sbJ+WmtkHsDDqmisjDL6IAHHzZas
        vfVn8Xs+ovauRczft37bIDnMpK2yLlYoIoqzQXVIma+kTiULLf+AX7iL9XwSyXXOIPmRvh
        LP9FfNI+ryGrJ2k6Mu29VRxHIQbbEAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-VItZEXbQOQeWOOsNTZjP5A-1; Tue, 22 Sep 2020 06:12:30 -0400
X-MC-Unique: VItZEXbQOQeWOOsNTZjP5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB87B1882FA0;
        Tue, 22 Sep 2020 10:12:28 +0000 (UTC)
Received: from gondolin (ovpn-112-114.ams2.redhat.com [10.36.112.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE195C1D0;
        Tue, 22 Sep 2020 10:12:07 +0000 (UTC)
Date:   Tue, 22 Sep 2020 12:12:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        thuth@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, philmd@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] s390x/pci: Add routine to get the vfio dma
 available count
Message-ID: <20200922121204.67425116.cohuck@redhat.com>
In-Reply-To: <1600352445-21110-5-git-send-email-mjrosato@linux.ibm.com>
References: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
        <1600352445-21110-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 10:20:44 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Create new files for separating out vfio-specific work for s390
> pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
> ioctl to collect the current dma available count.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/meson.build     |  1 +
>  hw/s390x/s390-pci-vfio.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
>  3 files changed, 72 insertions(+)
>  create mode 100644 hw/s390x/s390-pci-vfio.c
>  create mode 100644 hw/s390x/s390-pci-vfio.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

