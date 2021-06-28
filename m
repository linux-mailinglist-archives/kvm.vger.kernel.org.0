Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2183B6066
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhF1OY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 10:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233582AbhF1OXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 10:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624890052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XMHGCNWFuwOHxqdcWpoOkySMrHxKIMLHVe0kEFCvMqg=;
        b=HAnQCzGMvxUtav8Mv4V/IFstJXdxliM9Gt8aI2FjoCT+S4WJrG3d/AhEdqMHfmGFk9OPxl
        1UGZygvTxclNbChol8JEoT+984RsYm980UDD+4wthqUaMGbitmjanI+jDlVjQLkKLg9CKT
        vYNHVZ/PR+Th9lz+04NWgEoFWLpxyO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-bIGj6vLiPciJr36c0o7T3w-1; Mon, 28 Jun 2021 10:20:50 -0400
X-MC-Unique: bIGj6vLiPciJr36c0o7T3w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73098C7443;
        Mon, 28 Jun 2021 14:20:49 +0000 (UTC)
Received: from localhost (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 763445DF36;
        Mon, 28 Jun 2021 14:20:45 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vfio/mtty: Delete mdev_devices_list
In-Reply-To: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 28 Jun 2021 16:20:43 +0200
Message-ID: <878s2um5ok.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Dan points out that an error case left things on this list. It is also
> missing locking in available_instances_show().
>
> Further study shows the list isn't needed at all, just store the total
> ports in use in an atomic and delete the whole thing.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 09177ac91921 ("vfio/mtty: Convert to use vfio_register_group_dev()")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mtty.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

