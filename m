Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C32286A4C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 23:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgJGVdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 17:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbgJGVdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 17:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602106382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+H8s1EQ6O3e5JqW+svymMSt2jDcQMGfdx1WqAcR8t3Y=;
        b=QB959QQWdmYLpEaCWWYvMy5ez1bO4N7R5GZIHRRpWqpwPr8OgfTr4W4m9sdsgphFd9HLo3
        YnUArgZfWhx+qnGTs8/uJqjCceiFz5BA+1GHFIbkcgiunrz1CLftdA9OF+2APDNpGNDvG2
        s4qoJZ1Nv+jW3cQtcOHebKk1bhCYl1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-RrCG4nC5OESMjf9688Axwg-1; Wed, 07 Oct 2020 17:32:58 -0400
X-MC-Unique: RrCG4nC5OESMjf9688Axwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F0C21007464;
        Wed,  7 Oct 2020 21:32:56 +0000 (UTC)
Received: from w520.home (ovpn-113-244.phx2.redhat.com [10.3.113.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA8BC55761;
        Wed,  7 Oct 2020 21:32:55 +0000 (UTC)
Date:   Wed, 7 Oct 2020 15:32:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] vfio-pci/zdev: Add zPCI capabilities to
 VFIO_DEVICE_GET_INFO
Message-ID: <20201007153255.41d2a102@w520.home>
In-Reply-To: <1602096984-13703-5-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
        <1602096984-13703-5-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 14:56:23 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 61ca8ab..9d28484 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -213,4 +213,16 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>  	return -ENODEV;
>  }
>  #endif
> +
> +#ifdef CONFIG_VFIO_PCI_ZDEV
> +extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
> +				       struct vfio_info_cap *caps);
> +#else
> +static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
> +					      struct vfio_info_cap *caps);

Ooops......................................................................^

Fixed.  Thanks,

Alex

