Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8034EDC4
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhC3Q1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231579AbhC3Q0t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617121608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFuS6bJJcx8cqDUf55DRdOvg9VIEqCLE0G7H5nt5SpI=;
        b=PvFD4BtaQQdjaKY/+Jq433s4earhumDjjRuXEgQqDe13b3hU9B46dn0KE2fLleu6UBVP5H
        vDdNmozF5bIOj6PbcBv8PXDWQ4yf994tLZ5E/9JPE62yBX/Ob2HM6j3ClDl4JkaQdxzz3j
        /DuWJC6S8XXCwxxLmqtQqgXYWEXeYUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-OhloXgTbNHqrs3At9FY8RQ-1; Tue, 30 Mar 2021 12:26:44 -0400
X-MC-Unique: OhloXgTbNHqrs3At9FY8RQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3CD98030A1;
        Tue, 30 Mar 2021 16:26:34 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A984C19CB2;
        Tue, 30 Mar 2021 16:26:29 +0000 (UTC)
Date:   Tue, 30 Mar 2021 18:26:27 +0200
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
Subject: Re: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Message-ID: <20210330182627.3d15cb1a.cohuck@redhat.com>
In-Reply-To: <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:28 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This returns the index in the supported_type_groups array that is
> associated with the mdev_type attached to the struct mdev_device or its
> containing struct kobject.
> 
> Each mdev_device can be spawned from exactly one mdev_type, which in turn
> originates from exactly one supported_type_group.
> 
> Drivers are using weird string calculations to try and get back to this
> index, providing a direct access to the index removes a bunch of wonky
> driver code.
> 
> mdev_type->group can be deleted as the group is obtained using the
> type_group_id.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 20 ++++++++++++++++++++
>  drivers/vfio/mdev/mdev_private.h |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c   | 15 +++++++++------
>  include/linux/mdev.h             |  3 +++
>  4 files changed, 33 insertions(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

