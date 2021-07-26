Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B833D651D
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhGZQWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:22:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238555AbhGZQUW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 12:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627318850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5k7GWvLVs2xrYrCnmvWJJpnVjOaJLwNh/7w/dom/CCc=;
        b=fGHLT9xkWZdYdm1nApt0TfoBpiPfX9F0exghqjy9QJUaPOfiwURDjbyKHpJfnL0Ie+928p
        Ll1OXCojk3RvW0158NCIvxfG+Td/EiwXsXDIQTHeRuPtD0gUEJu9FyucpF1PdSRRxr3xwG
        c3yRl/q9bvVBVqo5tezEN7JaOOnD+A8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-o-TFGi2YNHO-uCMdo14T_g-1; Mon, 26 Jul 2021 13:00:48 -0400
X-MC-Unique: o-TFGi2YNHO-uCMdo14T_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 841871934101;
        Mon, 26 Jul 2021 17:00:47 +0000 (UTC)
Received: from localhost (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5706860C0F;
        Mon, 26 Jul 2021 17:00:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/mdev: turn mdev_init into a subsys_initcall
In-Reply-To: <20210726143524.155779-2-hch@lst.de>
Organization: Red Hat GmbH
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-2-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 26 Jul 2021 19:00:41 +0200
Message-ID: <8735s157t2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26 2021, Christoph Hellwig <hch@lst.de> wrote:

> Without this setups with bu=D1=96lt-in mdev and mdev-drivers fail to
> register like this:
>
> [1.903149] Driver 'intel_vgpu_mdev' was unable to register with bus_type =
'mdev' because the bus was not initialized.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

