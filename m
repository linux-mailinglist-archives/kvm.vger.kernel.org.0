Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02F34EC84
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhC3PcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhC3Pb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617118317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VzNHCWSvANMRzv0N5DXby72j2GQaADl995RERkQy4LU=;
        b=WxoJlUP9qSoNqNBA2AE0+r5fgwfj7V+FbjwnNtSZ24wcpbvGfriC7VOXkSxkxVD0B69/2v
        jGH51p1SqliqkLMqg0rgp7O6T7pArAxvYQS9yCDTP49b41FYDIYl35YDzUndA/taYg0tPj
        KJkLcECbG7OkdTZbDLyeVV35lr92f5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-vyPlO3TRPDKe6P9WI14fpA-1; Tue, 30 Mar 2021 11:31:55 -0400
X-MC-Unique: vyPlO3TRPDKe6P9WI14fpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 112501005D58;
        Tue, 30 Mar 2021 15:31:54 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE17D19D80;
        Tue, 30 Mar 2021 15:31:48 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:31:46 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct
 mdev_device
Message-ID: <20210330173146.1b35d8d0.cohuck@redhat.com>
In-Reply-To: <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:21 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The kobj pointer in mdev_device is actually pointing at a struct
> mdev_type. Use the proper type so things are understandable.
> 
> There are a number of places that are confused and passing both the mdev
> and the mtype as function arguments, fix these to derive the mtype
> directly from the mdev to remove the redundancy.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 16 ++++++----------
>  drivers/vfio/mdev/mdev_private.h |  7 +++----
>  drivers/vfio/mdev/mdev_sysfs.c   | 15 ++++++++-------
>  include/linux/mdev.h             |  4 +++-
>  4 files changed, 20 insertions(+), 22 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

