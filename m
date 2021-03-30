Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1173D34ED4B
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhC3QP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231875AbhC3QPl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617120940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StDFXGAAhq5sJFd2PQRXksxf/3zJ8vC4fAeBWTpx1P4=;
        b=LONiClVWwmvjYoGPdSa6LWTDy0Xsvm7+tbmZNE9UiG0jgGQ48iw8mI0fqMt9eBdpey80rh
        54GIXtkNdFKj0GReyCF5+OvjABCY2SQ167d3IAaf900yRWng/Wazw7uX9+YML44GONOYP2
        3mp0WHOGikrfTEFI+XB8thSkyQfJn0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-Zm1jQoxeMbqaXLGQ3Rw3Ng-1; Tue, 30 Mar 2021 12:15:35 -0400
X-MC-Unique: Zm1jQoxeMbqaXLGQ3Rw3Ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A201005D57;
        Tue, 30 Mar 2021 16:15:34 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B228451C34;
        Tue, 30 Mar 2021 16:15:28 +0000 (UTC)
Date:   Tue, 30 Mar 2021 18:15:26 +0200
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
Subject: Re: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Message-ID: <20210330181526.7abcac2e.cohuck@redhat.com>
In-Reply-To: <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:27 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> mdev_device->type->parent is the same thing.
> 
> The struct mdev_device was relying on the kref on the mdev_parent to also
> indirectly hold a kref on the mdev_type pointer. Now that the type holds a
> kref on the parent we can directly kref the mdev_type and remove this
> implicit relationship.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 13 +++++--------
>  drivers/vfio/mdev/vfio_mdev.c | 14 +++++++-------
>  include/linux/mdev.h          |  1 -
>  3 files changed, 12 insertions(+), 16 deletions(-)

With or without an additional wrapper:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

