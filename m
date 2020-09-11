Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA48265D11
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgIKJ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 05:56:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgIKJ4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 05:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfohgZAXCNl+PKanfBorLKxCJJnZ1k32hZXabUGOmhw=;
        b=EWe/07for5I4ZXh55uiUXxsgLoKO8iuu51okJF83gBQW0GBTyXG+P3cCCt7iLwDvc/wmSa
        oVdDuV8FSITh5Dq5Dlqe7EByhSOtL3MLjzLgCjQ+T8cYswTa6JKmu3P39Eb47mIMLAXmku
        01AksNeL6lmc/iND5pRgg6VsW2uS4pE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-mpMRDpoCN86U_l1UVexmDA-1; Fri, 11 Sep 2020 05:56:22 -0400
X-MC-Unique: mpMRDpoCN86U_l1UVexmDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E119D81E20C;
        Fri, 11 Sep 2020 09:56:20 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B52135DA74;
        Fri, 11 Sep 2020 09:55:48 +0000 (UTC)
Date:   Fri, 11 Sep 2020 11:55:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] vfio: Fix typo of the device_state
Message-ID: <20200911115545.5161fa46.cohuck@redhat.com>
In-Reply-To: <20200910122508.705-1-yuzenghui@huawei.com>
References: <20200910122508.705-1-yuzenghui@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Sep 2020 20:25:08 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> A typo fix ("_RUNNNG" => "_RUNNING") in comment block of the uapi header.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  include/uapi/linux/vfio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 920470502329..d4bd39e124bf 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -462,7 +462,7 @@ struct vfio_region_gfx_edid {
>   * 5. Resumed
>   *                  |--------->|
>   *
> - * 0. Default state of VFIO device is _RUNNNG when the user application starts.
> + * 0. Default state of VFIO device is _RUNNING when the user application starts.
>   * 1. During normal shutdown of the user application, the user application may
>   *    optionally change the VFIO device state from _RUNNING to _STOP. This
>   *    transition is optional. The vendor driver must support this transition but

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

