Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67C36C498
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhD0LGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235372AbhD0LGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 07:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619521541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uo5IubiUgaEAcCKINk4U2wSN84Tzj30VgFH40sgQJoA=;
        b=gDJov7I9T/4S1E4JAKitVFjoGXeEK2yJdxjbUojbqKbHBldOoP2K3YRTf+f86s+YF9nuli
        R9EqlJWSlYV/1cj80j/lTaxw3Dvm7SbAteyxHzmubTFnnwbW1yWJu0TE3A50jXuW0MqoUa
        BiSAukZiwXhPzBySQ3y1mXKW6sb1cBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-ZMaLEpRyNYaooxcSGpQ_2Q-1; Tue, 27 Apr 2021 07:05:38 -0400
X-MC-Unique: ZMaLEpRyNYaooxcSGpQ_2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A602107ACE4;
        Tue, 27 Apr 2021 11:05:35 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE31D60CC6;
        Tue, 27 Apr 2021 11:05:26 +0000 (UTC)
Date:   Tue, 27 Apr 2021 13:05:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 01/13] vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
Message-ID: <20210427130523.3345913d.cohuck@redhat.com>
In-Reply-To: <1-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <1-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 17:00:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> For some reason the vfio_mdev shim mdev_driver has its own module and
> kconfig. As the next patch requires access to it from mdev.ko merge the
> two modules together and remove VFIO_MDEV_DEVICE.
> 
> A later patch deletes this driver entirely.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/s390/vfio-ap.rst   |  1 -
>  arch/s390/Kconfig                |  2 +-
>  drivers/gpu/drm/i915/Kconfig     |  2 +-
>  drivers/vfio/mdev/Kconfig        |  7 -------
>  drivers/vfio/mdev/Makefile       |  3 +--
>  drivers/vfio/mdev/mdev_core.c    | 16 ++++++++++++++--
>  drivers/vfio/mdev/mdev_private.h |  2 ++
>  drivers/vfio/mdev/vfio_mdev.c    | 24 +-----------------------
>  samples/Kconfig                  |  6 +++---
>  9 files changed, 23 insertions(+), 40 deletions(-)

This also fixes the dependencies for vfio-ccw, which never depended on
VFIO_MDEV_DEVICE directly...

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

