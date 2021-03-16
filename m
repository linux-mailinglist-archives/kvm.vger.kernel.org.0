Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1633D93D
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhCPQXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:23:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238669AbhCPQWn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 12:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615911761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=29nfLbleOVpD7DeQKsZ03C3l4zSvLVQ0UeNSRaaPycg=;
        b=Zy3U8cOttp/6pa4jHgF/ZZL3Hc+n+sckejlINA08MRLQPVcPJrn7N/V3xdjSZ1tx0cJx7w
        MbkOF/8FT+pTrfY9Qi9kNTrALLTb4rff7i/umC45p9Qw9hjZPexLHl685MqcgpaVpRx/Jp
        gymYxfg7W0377ilCA1Gquo73WXsYeGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-8UerbngNPHqNMAS8mG6v7Q-1; Tue, 16 Mar 2021 12:22:39 -0400
X-MC-Unique: 8UerbngNPHqNMAS8mG6v7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EBB5800FF0;
        Tue, 16 Mar 2021 16:22:37 +0000 (UTC)
Received: from gondolin (ovpn-113-185.ams2.redhat.com [10.36.113.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F4E05C1A1;
        Tue, 16 Mar 2021 16:22:29 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:22:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 04/14] vfio/platform: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210316172226.7121f139.cohuck@redhat.com>
In-Reply-To: <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:55:56 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> platform already allocates a struct vfio_platform_device with exactly
> the same lifetime as vfio_device, switch to the new API and embed
> vfio_device in vfio_platform_device.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  8 ++++---
>  drivers/vfio/platform/vfio_platform.c         | 21 ++++++++---------
>  drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
>  drivers/vfio/platform/vfio_platform_private.h |  5 ++--
>  4 files changed, 26 insertions(+), 31 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

