Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EB334ECBD
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhC3PjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232190AbhC3PjG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617118746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFh7gaRy+UbSQT3y5wfy9kfB9usF+mZ4/upTppB15e8=;
        b=h/16X9EBj5n6qkJTVmQk0/9Jg3SzTPhVQg2GcD1D2mUYbzx2S2JPiEU06uYWDbjDzZv2QS
        bdleoiqZ1lxykYhBlc7SLWV2eRKMYefpzAuQPrWNOKNsLvMdoEYfyjaELxNIvE2ylz5uNx
        phNpXWmhjUXYnNtXrQJj9dMkyEcwk6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-NjHniBjlMjydjnGOmmjh7A-1; Tue, 30 Mar 2021 11:39:01 -0400
X-MC-Unique: NjHniBjlMjydjnGOmmjh7A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 262321922020;
        Tue, 30 Mar 2021 15:39:00 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F268F5D9CC;
        Tue, 30 Mar 2021 15:38:54 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:38:52 +0200
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
Subject: Re: [PATCH 07/18] vfio/mdev: Add missing reference counting to
 mdev_type
Message-ID: <20210330173852.0c8e9173.cohuck@redhat.com>
In-Reply-To: <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:24 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
> but doesn't hold the kref. The lifetime of the parent becomes implicit
> because parent_remove_sysfs_files() is supposed to remove all the access
> before the parent can be freed, but this is very hard to reason about.
> 
> Make it obviously correct by adding the missing get.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

