Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AF8411362
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 13:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhITLOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 07:14:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229735AbhITLOT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 07:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632136372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+cEXBCv3p2JJaUUhjnLsa8UXFemD949tckGIE20lGD4=;
        b=PBB/DkDXGYQ3vvazq6178wOfuRLeLbljqliUHrwlcnnAvqucCg6LRfWWtVMRpzF/H7CV3L
        1ASQQnK1Pylky3MqbyuzpKHmQ6KBjbVJFO2gf6SJu5UctbByPGT8OCDAaH2PhN1TLTVaDU
        hkCyjXdJ+cE2edaLlzvxmMgv70i8OVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-rqEgMrLrPOK9YDeOoXLLgA-1; Mon, 20 Sep 2021 07:12:49 -0400
X-MC-Unique: rqEgMrLrPOK9YDeOoXLLgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BBC9180830B;
        Mon, 20 Sep 2021 11:12:46 +0000 (UTC)
Received: from localhost (unknown [10.39.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B495E60C17;
        Mon, 20 Sep 2021 11:12:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
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
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/9] vfio/ccw: Pass vfio_ccw_private not mdev_device
 to various functions
In-Reply-To: <2-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <2-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 20 Sep 2021 13:12:34 +0200
Message-ID: <8735pzh55p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> mdev_device should only be used in functions assigned to ops callbacks,
> interior functions should use the struct vfio_ccw_private instead of
> repeatedly trying to get it from the mdev.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c | 37 +++++++++++++--------------------
>  1 file changed, 15 insertions(+), 22 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

