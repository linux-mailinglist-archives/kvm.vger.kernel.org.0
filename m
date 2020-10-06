Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1002E284EF4
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgJFP2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:28:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgJFP2e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYNNK59E+//vkdyVoaJfBYfCbmtPubUe+si5jONP6/c=;
        b=CD3rHR+IZTadtOphw8oG+IrS2ihY1Qs2AwiWwKZO1y+kq5DZejzY9GC+ItBlyhjuJcF4cG
        KclJAV6BifdkmGztZzGwn2tWMHHyPolwyVdMT/SYlKxMkYN6SHEMMrcNmbDX1iTEQ1c3FV
        FSsSCh+ztkC/WakoH+JKfqD/+47jaF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-HYQvmSj9OSeuAfdtz2WCbQ-1; Tue, 06 Oct 2020 11:28:29 -0400
X-MC-Unique: HYQvmSj9OSeuAfdtz2WCbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B03661084C80;
        Tue,  6 Oct 2020 15:28:26 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2AB9614F5;
        Tue,  6 Oct 2020 15:28:21 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:27:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] MAINTAINERS: Add entry for s390 vfio-pci
Message-ID: <20201006172718.121d2a26.cohuck@redhat.com>
In-Reply-To: <1601668844-5798-6-git-send-email-mjrosato@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
        <1601668844-5798-6-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:00:44 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Add myself to cover s390-specific items related to vfio-pci.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 190c7fa..389c4ad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15162,6 +15162,14 @@ F:	Documentation/s390/vfio-ccw.rst
>  F:	drivers/s390/cio/vfio_ccw*
>  F:	include/uapi/linux/vfio_ccw.h
>  
> +S390 VFIO-PCI DRIVER
> +M:	Matthew Rosato <mjrosato@linux.ibm.com>
> +L:	linux-s390@vger.kernel.org
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +F:	drivers/vfio/pci/vfio_pci_zdev.c
> +F:	include/uapi/linux/vfio_zdev.h
> +
>  S390 ZCRYPT DRIVER
>  M:	Harald Freudenberger <freude@linux.ibm.com>
>  L:	linux-s390@vger.kernel.org

Acked-by: Cornelia Huck <cohuck@redhat.com>

