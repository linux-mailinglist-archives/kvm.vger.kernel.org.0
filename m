Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20C738F3C6
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhEXThU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:37:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232911AbhEXThT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 15:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621884951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQAyBAxfxfWDYAtqb1BB6klbTmzWLAaG7tBwwGsm+Lo=;
        b=AKdo36hX7lJMzhEj9IDl1li+6oDf+UbRCgygXiMqWVToA2U4p0afv7eeY7xwyDreZey5Ip
        TWqCXg0nAvAMDHwj0wfjDHRqeaUD14cfkVaZpYLlI/GplwWvIwYgtPdTw+q0ExklU5tjf1
        zn2e0TXCCzBANL3+QmYr5ewlhz7zjJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-ir_ifxBNMuKmwK_rwds2eQ-1; Mon, 24 May 2021 15:35:49 -0400
X-MC-Unique: ir_ifxBNMuKmwK_rwds2eQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E5F801107;
        Mon, 24 May 2021 19:35:47 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92A345C701;
        Mon, 24 May 2021 19:35:47 +0000 (UTC)
Date:   Mon, 24 May 2021 13:35:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/1] vfio/pci: Fix error return code in vfio_ecap_init()
Message-ID: <20210524133547.0850d213@x1.home.shazbot.org>
In-Reply-To: <20210515020458.6771-1-thunder.leizhen@huawei.com>
References: <20210515020458.6771-1-thunder.leizhen@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 15 May 2021 10:04:58 +0800
Zhen Lei <thunder.leizhen@huawei.com> wrote:

> The error code returned from vfio_ext_cap_len() is stored in 'len', not
> in 'ret'.
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d57f037f65b85d4..70e28efbc51f80e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1581,7 +1581,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
>  			if (len == 0xFF) {
>  				len = vfio_ext_cap_len(vdev, ecap, epos);
>  				if (len < 0)
> -					return ret;
> +					return len;
>  			}
>  		}
>  

Added to vfio for-linus branch for v5.13 w/ Max's R-b.  Thanks!

Alex

