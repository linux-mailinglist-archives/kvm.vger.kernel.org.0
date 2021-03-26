Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C0034A430
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCZJTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:19:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231172AbhCZJT0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616750365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Gm5xVwD6ofL9DwJM6MnHGvFGWNP3uwUsMGjRnDOtXU=;
        b=FR2LQgZDYa2ePb2kBpofgPTShXF/eNm3tfFqBX3qHPPMqlHbR4btarubHqjRS1PLWbKyNr
        lxcx1RvmUeGpwgOyR0gXxoEkf9yy55mhwlWQIvZgRWpatzoFOLkieW0haSwv56kE+S9lzb
        SiH5zWv/rb8dn+KWOw2Nhe7rOgdie+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-trXFP2WyOUm-DyMIAs8tMw-1; Fri, 26 Mar 2021 05:19:23 -0400
X-MC-Unique: trXFP2WyOUm-DyMIAs8tMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5481D6B9C0;
        Fri, 26 Mar 2021 09:19:22 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F08C86E6F5;
        Fri, 26 Mar 2021 09:19:17 +0000 (UTC)
Subject: Re: [PATCH 2/4] vfio/mdev: Fix spelling mistake "interal" ->
 "internal"
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
 <20210326083528.1329-3-thunder.leizhen@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <96794422-5d17-4d68-80a3-b8ba65ed2b3b@redhat.com>
Date:   Fri, 26 Mar 2021 10:19:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326083528.1329-3-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/21 9:35 AM, Zhen Lei wrote:
> There is a spelling mistake in a comment, fix it.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf3c1..4d62b76c473409d 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * Mediated device interal definitions
> + * Mediated device internal definitions
>   *
>   * Copyright (c) 2016, NVIDIA CORPORATION. All rights reserved.
>   *     Author: Neo Jia <cjia@nvidia.com>
> 

