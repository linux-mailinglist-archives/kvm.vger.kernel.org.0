Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09AA34ECB8
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhC3Phg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:37:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232014AbhC3Phc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617118652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfJni2ShjjPQQ4MQFRiezq/thcZElCaCwech1KGkT1c=;
        b=CoydtzdFM0iwAp7Lz6Jy3wK4Em4vnxTDaLD9yp6F7ptHpJniSiMkEHfQlTNyHVgtgaqHOP
        O/wMlKSATTiomYjCH+kp+LdP3wZeksMw7/UBXV74IRB8aIctGztCjjBEx1Wa7DbkZCyjKP
        A8zxaj/KkdeagUFx2DliPO4zX0y6RZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-KxjTt4AAMqS6aR-FJU-unA-1; Tue, 30 Mar 2021 11:37:27 -0400
X-MC-Unique: KxjTt4AAMqS6aR-FJU-unA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9108B107ACCA;
        Tue, 30 Mar 2021 15:37:26 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D717648A9;
        Tue, 30 Mar 2021 15:37:21 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:37:18 +0200
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
Subject: Re: [PATCH 06/18] vfio/mdev: Expose mdev_get/put_parent to
 mdev_private.h
Message-ID: <20210330173718.59678d78.cohuck@redhat.com>
In-Reply-To: <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The next patch will use these in mdev_sysfs.c
> 
> While here remove the now dead code checks for NULL, a mdev_type can never
> have a NULL parent.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 23 +++--------------------
>  drivers/vfio/mdev/mdev_private.h | 12 ++++++++++++
>  2 files changed, 15 insertions(+), 20 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

