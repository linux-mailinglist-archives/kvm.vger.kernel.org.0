Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED23D1050
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhGUNQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 09:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238684AbhGUNQf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 09:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626875831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DDrHjh3VhLT0AfhlZPlV06wXQC67/bVbhkLa9iM0YQw=;
        b=XDhkHW1hmGcZPV+8dQo7tV4EEILxujCS2WbeX9C79qYipIIvrHaXZxFxVQKO5lrmLklIne
        MqwY11Rm8WhaIwcLBW5oskak55NJCpvp5oemofk99ljJjNDlA8mzDK5uJJ6hhZ0PD5K9dz
        jE2KiYLGMdlVzaCH9C5ak8Ai0S/u3bM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-qBICz2xPMMKSW_mnu_nLeg-1; Wed, 21 Jul 2021 09:57:09 -0400
X-MC-Unique: qBICz2xPMMKSW_mnu_nLeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6232510150B7;
        Wed, 21 Jul 2021 13:57:07 +0000 (UTC)
Received: from localhost (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 286FC779D0;
        Wed, 21 Jul 2021 13:56:45 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v3] vfio/pci: Make vfio_pci_regops->rw() return ssize_t
In-Reply-To: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 21 Jul 2021 15:56:43 +0200
Message-ID: <874kcn93dw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

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
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

