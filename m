Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AA3CD55E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 15:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhGSMVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 08:21:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237143AbhGSMVM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 08:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626699712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4/8tpS7OrvF66jGpUtCqtGvB1csi0pb76/LV3TQ5V4M=;
        b=MLLM4xdtcWR2sPefV70MhkLWAfT9S/UYv4BVRkzQlnBEMU8ePHERMbcyR2Y75CC6LvoxzZ
        KoSSGyRPp6sEGtXtMDQEByfXoOIhKv086s0bWtgbEuH7VnqC4J5cDojRjYQaMwI4J5u3lF
        WcXPDqIF2igVO4VDwxG3HTP+85NUi4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-IEJIx_P3O0K--oUkDzHosg-1; Mon, 19 Jul 2021 09:01:48 -0400
X-MC-Unique: IEJIx_P3O0K--oUkDzHosg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 733F9800050;
        Mon, 19 Jul 2021 13:01:44 +0000 (UTC)
Received: from localhost (ovpn-112-158.ams2.redhat.com [10.36.112.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A01460CA0;
        Mon, 19 Jul 2021 13:01:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 04/13] vfio/samples: Delete useless open/close
In-Reply-To: <4-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <4-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 19 Jul 2021 15:01:35 +0200
Message-ID: <87tukqa24w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> The core code no longer requires these ops to be defined, so delete these
> empty functions and leave the op as NULL. mtty's functions only log a
> pointless message, delete that entirely.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mbochs.c |  6 ------
>  samples/vfio-mdev/mdpy.c   | 11 -----------
>  samples/vfio-mdev/mtty.c   | 13 -------------
>  3 files changed, 30 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

