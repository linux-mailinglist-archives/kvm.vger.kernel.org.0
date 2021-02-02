Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A7630C796
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhBBRZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:25:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237480AbhBBRWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/qoZi5ZLpNi2QThemswfpUvtVoBJ7tH1NpERx5PkV8=;
        b=cdLuCEMWGF6gDNxe3vumzzX4ew9ZEBbAvsEs+ivwnQDHQJ7v/l2Z8nlwEraLh6veacE49x
        fExIKelQZxMvOVC7l+03XrY+XD82tVnk2541LV2x7XAifa+wVnCcqpWU2DloUGAt2q6H8P
        4wuxLPttQmPJ6fz8gM00lo8/RSgmLRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-mMjaC4ANP4y79ga8-2WOSA-1; Tue, 02 Feb 2021 12:21:25 -0500
X-MC-Unique: mMjaC4ANP4y79ga8-2WOSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4F4C81621;
        Tue,  2 Feb 2021 17:21:22 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1A319C71;
        Tue,  2 Feb 2021 17:21:21 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:21:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 5/9] vfio-pci/zdev: remove unused vdev argument
Message-ID: <20210202102121.66cd39a2@omen.home.shazbot.org>
In-Reply-To: <20210202085755.3e06184e.cohuck@redhat.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-6-mgurtovoy@nvidia.com>
        <20210202085755.3e06184e.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 08:57:55 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, 1 Feb 2021 16:28:24 +0000
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> 
> > Zdev static functions does not use vdev argument. Remove it.  
> 
> s/does not use/do not use the/
> 
> > 
> > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_zdev.c | 20 ++++++++------------
> >  1 file changed, 8 insertions(+), 12 deletions(-)  
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Applied 5&6 to vfio next branch for v5.12 w/ Matt and Connie's R-b and
trivial fix above.  Thanks,

Alex

