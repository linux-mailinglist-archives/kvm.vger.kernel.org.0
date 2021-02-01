Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DDA30A34F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhBAIbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:31:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232229AbhBAIbd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 03:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612168206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9abuyB1cdyK0EkjXW3R63neo8lvwSJKL9r9wYH7jDK8=;
        b=OPqCAi6h3j8xyH3KGwB/KN/tTODDpjUnZP/Exp9FKAKzFRF5rFK4992YZBNHyX7pJqEuUX
        ZXTHqgqGE0s4KqmBLmGnR/B6LLBk1FafhOat2vT1a7ybE7lFpgs7aq1yh68Vg/4KsnvDkk
        Uq/f5cVET1twzgVvvckbvngGBcshgZ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-A5hYDJlRMEuAvSlWp2m1Fw-1; Mon, 01 Feb 2021 03:30:03 -0500
X-MC-Unique: A5hYDJlRMEuAvSlWp2m1Fw-1
Received: by mail-wm1-f69.google.com with SMTP id 5so4257515wmq.0
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 00:30:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9abuyB1cdyK0EkjXW3R63neo8lvwSJKL9r9wYH7jDK8=;
        b=je+lD9tKrJhwQb3DqVopO8Cf7HWF7GONYfsjw3eo9Y3TiwhJ3Q44aLVCWd3WtNO9x2
         0sRN/Lo1Tl159pZi45s1vTpEoGvY5OITK1Hj/G5RTbtvc5h7axdVOrZ44I2E0asObSrV
         DDiJU2uPTvwjRgBzxuZalEHVt0H4ysuwpEvXzlbhg6ouOewDbd0ANVYauJI6Lt364FSL
         WhKDN1OOHUbM1qBfLJR3ezvMU3bconAFGjL0lm8iNpY2zRBNHltQu1jjEJw/7c13EnFt
         j7Sn5GFsUgGHXYWNqEeYxcgeI7nac7Aw+a+TRi6laJB2UaWnI70vmAUgwlt4k8U8zKZZ
         n6LQ==
X-Gm-Message-State: AOAM532nfMDQRI1xxX6sX7ojtliMTMIzEXyI3PL7IRA5UKtBQUoFhFWT
        jCEZSQZ6+tR0alYUXKjHkFb3NusB7/cPOM8ZqEyOo5SLv6oKe1V/MQ6+EGrDqWQx9WJ9fIfIXUR
        k4Sl1QVyg7VEg
X-Received: by 2002:a05:6000:1045:: with SMTP id c5mr17350734wrx.250.1612168201727;
        Mon, 01 Feb 2021 00:30:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6UZr189pCeRP1YezATVaXeQQHRGHCvETS8Jr7AzP2dFOuy5pRO24CAZQYIXQgraHCwm17sg==
X-Received: by 2002:a05:6000:1045:: with SMTP id c5mr17350715wrx.250.1612168201566;
        Mon, 01 Feb 2021 00:30:01 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id w14sm25577889wro.86.2021.02.01.00.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 00:30:00 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:29:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/10] vdpa: add vdpa simulator for block device
Message-ID: <20210201082958.646etcwgssvi22cq@steredhat>
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-9-sgarzare@redhat.com>
 <e8f97ea2-d179-de37-a0ea-b2858510f3ce@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e8f97ea2-d179-de37-a0ea-b2858510f3ce@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 31, 2021 at 05:31:43PM +0200, Max Gurtovoy wrote:
>
>On 1/28/2021 4:41 PM, Stefano Garzarella wrote:
>>From: Max Gurtovoy <mgurtovoy@nvidia.com>
>>
>>This will allow running vDPA for virtio block protocol.
>>
>>Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>[sgarzare: various cleanups/fixes]
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>v2:
>>- rebased on top of other changes (dev_attr, get_config(), notify(), etc.)
>>- memset to 0 the config structure in vdpasim_blk_get_config()
>>- used vdpasim pointer in vdpasim_blk_get_config()
>>
>>v1:
>>- Removed unused headers
>>- Used cpu_to_vdpasim*() to store config fields
>>- Replaced 'select VDPA_SIM' with 'depends on VDPA_SIM' since selected
>>   option can not depend on other [Jason]
>>- Start with a single queue for now [Jason]
>>- Add comments to memory barriers
>>---
>>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 145 +++++++++++++++++++++++++++
>>  drivers/vdpa/Kconfig                 |   7 ++
>>  drivers/vdpa/vdpa_sim/Makefile       |   1 +
>>  3 files changed, 153 insertions(+)
>>  create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>>
>>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>>new file mode 100644
>>index 000000000000..999f9ca0b628
>>--- /dev/null
>>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>>@@ -0,0 +1,145 @@
>>+// SPDX-License-Identifier: GPL-2.0-only
>>+/*
>>+ * VDPA simulator for block device.
>>+ *
>>+ * Copyright (c) 2020, Mellanox Technologies. All rights reserved.
>
>I guess we can change the copyright from Mellanox to:
>
>Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.

I'll update in the next version.

Thanks,
Stefano

