Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EE13CCDD3
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 08:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhGSGWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 02:22:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229916AbhGSGWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 02:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626675558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QU07BaOUQ5KE9up74aY1kEZdBz5nOO5odKeCJ2gfW4s=;
        b=RE6kwVDUz9Q8SqCpN7a1fGDHHWPAltaNl8YUyv6Pyv3uzsvmHgqKbU4lXO37po4guf5SlA
        W2CklOeED7OQOR4d5SSXCenXRDzin9mjDuJEjEwDD+thCB3gYmu6OfnmZKUCh2foDUrf/l
        g8hvd0wGL05XAMztzK9wpJtJe1UchyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-LFxKNAOLOPaVC7zsrllv3A-1; Mon, 19 Jul 2021 02:19:14 -0400
X-MC-Unique: LFxKNAOLOPaVC7zsrllv3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7848100C610;
        Mon, 19 Jul 2021 06:19:13 +0000 (UTC)
Received: from localhost (ovpn-112-158.ams2.redhat.com [10.36.112.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAAC45D6A1;
        Mon, 19 Jul 2021 06:19:09 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: Use config not menuconfig for VFIO_NOIOMMU
In-Reply-To: <0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 19 Jul 2021 08:19:08 +0200
Message-ID: <87eebubzc3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO_NOIOMMU is supposed to be an element in the VFIO menu, not start
> a new menu. Correct this copy-paste mistake.
>
> Fixes: 03a76b60f8ba ("vfio: Include No-IOMMU mode")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

