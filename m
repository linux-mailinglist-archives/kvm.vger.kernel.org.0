Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4722030AD25
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhBAQya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:54:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231856AbhBAQyQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 11:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612198369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gk2/jVFcOiHNETdBynXJ/yTxuiyuRTVxnfL8YgjYp6s=;
        b=CJVPnRUlZIN/DIAfSv2ZEWdAPMpqJz2ma3VhxJ+cqQunSnQl7QKz6xeA32VsJFdv/ykS19
        vA60i9dMVzBCz/BFu9J0cky3uWQxHcoqM6jUDaHigHMeuOGTdQ15wNPC52m7VOeRAxDS7u
        B4sFPB6Oba1TymZE2vRqrDNjG67s/B8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-qlwRDgIzPtCBXhCiapM7Kw-1; Mon, 01 Feb 2021 11:52:45 -0500
X-MC-Unique: qlwRDgIzPtCBXhCiapM7Kw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FBEA1006292;
        Mon,  1 Feb 2021 16:52:21 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A4CA60C66;
        Mon,  1 Feb 2021 16:52:17 +0000 (UTC)
Date:   Mon, 1 Feb 2021 17:52:14 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 6/9] vfio-pci/zdev: fix possible segmentation fault
 issue
Message-ID: <20210201175214.0dc3ba14.cohuck@redhat.com>
In-Reply-To: <20210201162828.5938-7-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-7-mgurtovoy@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 16:28:25 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> In case allocation fails, we must behave correctly and exit with error.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

Fixes: e6b817d4b821 ("vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO")

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

I think this should go in independently of this series.

> ---
>  drivers/vfio/pci/vfio_pci_zdev.c | 4 ++++
>  1 file changed, 4 insertions(+)

