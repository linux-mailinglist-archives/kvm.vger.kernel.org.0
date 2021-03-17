Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D931333EFAF
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 12:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCQLeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 07:34:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231367AbhCQLdn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 07:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615980823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAnF1vYY3gBdcvWdXcgN/3PXukv2xlMHhVBn3KTxPzY=;
        b=R0ZZLC++jy+LgyMhSFHt8ev3uH3zZiRYB3y251gXi/vbLthahm9NgrBFoIbj7RYC/EjSs3
        Ma5D9dvGaA1SfR+Az4cV7NFA1V4S8ZXAEvpYthuij11RrQbeZRAMVXSpcyzp3TJtTWjZiB
        S34V6o9WxU6wlh2fjXJPnTxmlIq3+AU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-1kXcIWkRPBSJBBrTVqqDhg-1; Wed, 17 Mar 2021 07:33:40 -0400
X-MC-Unique: 1kXcIWkRPBSJBBrTVqqDhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51B9E91152;
        Wed, 17 Mar 2021 11:33:38 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D75F55D747;
        Wed, 17 Mar 2021 11:33:34 +0000 (UTC)
Date:   Wed, 17 Mar 2021 12:33:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 12/14] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
Message-ID: <20210317123332.7ab93789.cohuck@redhat.com>
In-Reply-To: <12-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <12-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:04 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is the standard kernel pattern, the ops associated with a struct get
> the struct pointer in for typesafety. The expected design is to use
> container_of to cleanly go from the subsystem level type to the driver
> level type without having any type erasure in a void *.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst            | 18 ++++----
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 36 +++++++++------
>  drivers/vfio/mdev/vfio_mdev.c                | 33 +++++++-------
>  drivers/vfio/pci/vfio_pci.c                  | 47 ++++++++++++--------
>  drivers/vfio/platform/vfio_platform_common.c | 33 ++++++++------
>  drivers/vfio/vfio.c                          | 20 ++++-----
>  include/linux/vfio.h                         | 16 +++----
>  7 files changed, 117 insertions(+), 86 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

