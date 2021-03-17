Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB933EE61
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCQKg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:36:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhCQKgZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615977385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wXJO+zgJMcjIp9mp3HkPhC+I3szP/pv7rg7fduDT0BI=;
        b=cZaDsorIGFqkg7oJY1uj/ZCzXLjaY7e/zp9bmwnhO0CkKwZwxZPXjNFZfufwOybVdBg/3O
        HZ++Kns9uEu30NvDMUt2PWy9B4+X2vB8iSn/ke7PtRYs/pgYXZtzjU7tDJdwWvOu/N/oAc
        sJhfglLMiF8Bwry7KA16R6+Rv04bOjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-b0yzAiZEOvWMDQhGBuhWiQ-1; Wed, 17 Mar 2021 06:36:19 -0400
X-MC-Unique: b0yzAiZEOvWMDQhGBuhWiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBDDA1009446;
        Wed, 17 Mar 2021 10:36:17 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 002AE5D74F;
        Wed, 17 Mar 2021 10:36:09 +0000 (UTC)
Date:   Wed, 17 Mar 2021 11:36:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 10/14] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210317113607.04856997.cohuck@redhat.com>
In-Reply-To: <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:02 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> mdev gets little benefit because it doesn't actually do anything, however
> it is the last user, so move the code here for now.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c | 24 +++++++++++++++++++--
>  drivers/vfio/vfio.c           | 39 ++---------------------------------
>  include/linux/vfio.h          |  5 -----
>  3 files changed, 24 insertions(+), 44 deletions(-)

With switching to a bare vfio_device:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

