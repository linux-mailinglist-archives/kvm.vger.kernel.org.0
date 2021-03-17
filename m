Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F2433F005
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 13:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCQMJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 08:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231573AbhCQMJK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 08:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615982949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdxgnyPpbT7juxUHUxOAe8mva0KlF49Q1H6rVeC+7nA=;
        b=iJXOoWxpmGluB/Xs8WAFtncxAL7VGEkr/jgLSQNaneX/mNatF2kuwijYYj/SGN1YLccqBR
        Wa1EN2gDJNvOBerqOqBgRGVx0GZt1qf+lmFot9HiHMJoM3uX0HPiubAfnpKCe8dPuGW77A
        Rmyr1Kk6XEsfdA70ozjwDmRGv/Eo0TQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-YxuPsa8mNl-vROq4a299oA-1; Wed, 17 Mar 2021 08:09:05 -0400
X-MC-Unique: YxuPsa8mNl-vROq4a299oA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5337483DD25;
        Wed, 17 Mar 2021 12:09:03 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA5312B3BB;
        Wed, 17 Mar 2021 12:08:54 +0000 (UTC)
Date:   Wed, 17 Mar 2021 13:08:52 +0100
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
Subject: Re: [PATCH v2 14/14] vfio: Remove device_data from the vfio bus
 driver API
Message-ID: <20210317130852.448dd019.cohuck@redhat.com>
In-Reply-To: <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:06 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> There are no longer any users, so it can go away. Everything is using
> container_of now.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst            |  3 +--
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
>  drivers/vfio/mdev/vfio_mdev.c                |  2 +-
>  drivers/vfio/pci/vfio_pci.c                  |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c |  2 +-
>  drivers/vfio/vfio.c                          | 12 +-----------
>  include/linux/vfio.h                         |  4 +---
>  7 files changed, 9 insertions(+), 21 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

