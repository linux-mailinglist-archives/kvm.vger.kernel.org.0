Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32805355C48
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbhDFTib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:38:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244899AbhDFTiX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 15:38:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617737894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJhQUKqEV20liVnsgwrQmVyuB9gKm/Ks+xvFCx56LWo=;
        b=ZCCvz3kUDqJP02QfTBXG8HK53IHFiUITxH67wQWINcxkAPWlEXk1iMHMgRsvUImPyjPVA1
        fLxgq/QNX8BZDNaOUo4qvcbVeNjvBzX9ht++J1gam47sm3ax3IkkQJe7R5SExmKzs6Xplt
        TIwfWK+jlN5P/I0jNqCMR9/GismEXYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-y4Zh0538PROB9k8ijir18w-1; Tue, 06 Apr 2021 15:38:10 -0400
X-MC-Unique: y4Zh0538PROB9k8ijir18w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 466FC108BD06;
        Tue,  6 Apr 2021 19:38:08 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FD7A19D61;
        Tue,  6 Apr 2021 19:38:06 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:38:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/pci: remove vfio_pci_nvlink2
Message-ID: <20210406133805.715120bd@omen>
In-Reply-To: <20210326061311.1497642-2-hch@lst.de>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210326061311.1497642-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 07:13:10 +0100
Christoph Hellwig <hch@lst.de> wrote:

> This driver never had any open userspace (which for VFIO would include
> VM kernel drivers) that use it, and thus should never have been added
> by our normal userspace ABI rules.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/vfio/pci/Kconfig            |   6 -
>  drivers/vfio/pci/Makefile           |   1 -
>  drivers/vfio/pci/vfio_pci.c         |  18 -
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 490 ----------------------------
>  drivers/vfio/pci/vfio_pci_private.h |  14 -
>  include/uapi/linux/vfio.h           |  38 +--
>  6 files changed, 4 insertions(+), 563 deletions(-)
>  delete mode 100644 drivers/vfio/pci/vfio_pci_nvlink2.c

Hearing no objections, applied to vfio next branch for v5.13.  Thanks,

Alex

