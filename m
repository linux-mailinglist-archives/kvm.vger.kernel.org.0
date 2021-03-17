Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDFE33EFFC
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 13:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCQMGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 08:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhCQMGb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 08:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615982790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5CfaXOuisOb4lk7RhVwwTc4twfH+xjivn8O+wWD3QM=;
        b=HWOPexoI7U7M/dhRimK3cM85b696XcUYU0WgKhzjJiAklv3slIrnayixPRQDzau91PNj2p
        W6D3UBtU2MjJfN7+fzBFP8g77MHDhUO8B8KOKkR/n75Xh1Y/cFjz2wnJscGLb00NzpT54a
        Uj1J4ekXkVhJOZalswdHaoKdX3k0RxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-tc_bTcVqP9GBQyDisFETmA-1; Wed, 17 Mar 2021 08:06:26 -0400
X-MC-Unique: tc_bTcVqP9GBQyDisFETmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 570CA800D53;
        Wed, 17 Mar 2021 12:06:24 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ABC8648A1;
        Wed, 17 Mar 2021 12:06:22 +0000 (UTC)
Date:   Wed, 17 Mar 2021 13:06:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 13/14] vfio/pci: Replace uses of vfio_device_data()
 with container_of
Message-ID: <20210317130619.6de79abd.cohuck@redhat.com>
In-Reply-To: <13-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <13-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:05 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This tidies a few confused places that think they can have a refcount on
> the vfio_device but the device_data could be NULL, that isn't possible by
> design.
> 
> Most of the change falls out when struct vfio_devices is updated to just
> store the struct vfio_pci_device itself. This wasn't possible before
> because there was no easy way to get from the 'struct vfio_pci_device' to
> the 'struct vfio_device' to put back the refcount.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 67 +++++++++++++------------------------
>  1 file changed, 24 insertions(+), 43 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

