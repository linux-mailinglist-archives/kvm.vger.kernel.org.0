Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE37288642
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgJIJol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 05:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733190AbgJIJok (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 05:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602236679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApnJ4rmyHZgjW0CSRxg458SeB02+Q3oxy6Iq5vW6bsQ=;
        b=B69me5OYXcYGsE1tChgHkk3i/aWO7Lb3dItRmmRXlVxpvZkWjBmVFccA/afWpXt4tGqho3
        CCF3elD9vDNyU9sHPMduMiSBuhT4dQceLyWLJ3Vl+Nw3r6nwUlfDwaqdHUkvnwbb0X8Hg0
        XPfU3997eboGQf8+f0GvvYIL3MN5jFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-fKsuyehIPyCGk3JZXhpKkg-1; Fri, 09 Oct 2020 05:44:37 -0400
X-MC-Unique: fKsuyehIPyCGk3JZXhpKkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4DED1007465;
        Fri,  9 Oct 2020 09:44:35 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43B65C1C7;
        Fri,  9 Oct 2020 09:44:30 +0000 (UTC)
Date:   Fri, 9 Oct 2020 11:44:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] vfio-pci/zdev: Add zPCI capabilities to
 VFIO_DEVICE_GET_INFO
Message-ID: <20201009114427.41f96cc6.cohuck@redhat.com>
In-Reply-To: <1602096984-13703-5-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
        <1602096984-13703-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 14:56:23 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Define a new configuration entry VFIO_PCI_ZDEV for VFIO/PCI.
> 
> When this s390-only feature is configured we add capabilities to the
> VFIO_DEVICE_GET_INFO ioctl that describe features of the associated
> zPCI device and its underlying hardware.
> 
> This patch is based on work previously done by Pierre Morel.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig            |  13 ++++
>  drivers/vfio/pci/Makefile           |   1 +
>  drivers/vfio/pci/vfio_pci.c         |  37 ++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  12 +++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 143 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 206 insertions(+)
>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c

With the compilation fix,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

