Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC5C3D0894
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhGUFXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 01:23:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhGUFW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 01:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626847413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lsd8OB8vXTZClsJbNmjevxKUNiMpNnygBPvPjBnGKkI=;
        b=K5c3XjC9Cp9TKrnf4+3xTDcIzO2flPI50nMEb33bRgCV50W4Wb0kYFKBYLvcxdTzpCwn0W
        bGszEGPIEwq46yJxmryG3kP/Kc1POTCalEtVaO64udlbfq/lUHebSV2bwWmhv0mVEQaFKU
        K2ZYsOFPUxhIVgim97cOz/GEb47UpcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-b5ULAGktMh-ppuCsCqSBvw-1; Wed, 21 Jul 2021 02:03:31 -0400
X-MC-Unique: b5ULAGktMh-ppuCsCqSBvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD6A21005D54;
        Wed, 21 Jul 2021 06:03:30 +0000 (UTC)
Received: from localhost (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E4A260CCC;
        Wed, 21 Jul 2021 06:03:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio_pci_core: Make vfio_pci_regops->rw() return
 ssize_t
In-Reply-To: <0-v2-459be47fb870+c0-vfio_rw_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <0-v2-459be47fb870+c0-vfio_rw_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 21 Jul 2021 08:03:25 +0200
Message-ID: <87im148aqa.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
>
> The only implementation of this in IGD returns a -ERRNO which is
> implicitly cast through a size_t and then casted again and returned as a
> ssize_t in vfio_pci_rw().
>
> Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
> consistent.
>
> Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

This is missing your s-o-b...

> ---
>  drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> v2:
> - Diff fixed to be against v5.14-rc1, woops

Could you please also fix the subject prefix?

The change itself looks good to me.

