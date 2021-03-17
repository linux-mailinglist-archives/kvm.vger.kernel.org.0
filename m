Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D322033EE5D
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCQKeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:34:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229829AbhCQKdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615977225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gQGD9bNv2GkbO1EXhG+rjpctLYrJcPnmglmj2EryViw=;
        b=D98CpP1EjLn2tpN2KNoZVVgUELeqoZexuNMENmSgWqKGbxjTythOeQB+ZVzXSdoJ80tkar
        o3B9wfwyW/xCYUo6f1cfgP2dGZksHs4E+eeRJqv8YhWEzk+VJC2UH3YjqIrxsL5e5kyLIj
        /pr6sipqqOMrBG7eZ0EOJvnrvKcWvfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-yfuPWDQeOY-tWpq77J6eYg-1; Wed, 17 Mar 2021 06:33:41 -0400
X-MC-Unique: yfuPWDQeOY-tWpq77J6eYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0F97100A242;
        Wed, 17 Mar 2021 10:33:39 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01E14610AF;
        Wed, 17 Mar 2021 10:33:33 +0000 (UTC)
Date:   Wed, 17 Mar 2021 11:33:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 09/14] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210317113331.6db06739.cohuck@redhat.com>
In-Reply-To: <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:01 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> pci already allocates a struct vfio_pci_device with exactly the same
> lifetime as vfio_device, switch to the new API and embed vfio_device in
> vfio_pci_device.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 6 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

