Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD636F43D7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfKHJs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:48:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50820 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731222AbfKHJs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 04:48:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id l17so4669832wmh.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 01:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hQIfJOwr2U69WzdbMGlOE3SDtRTxC/4X/cZpBo7hwt0=;
        b=Tq7BH7jDrUsvXXaVacVmr01CROcNUoc6DKF8OzHi1SMHhAR4UOmQFv3IlxC7nV7Q8v
         5DrqGlriWv4ssczbmpfwyKNDo31ox3VrTszUikCw4YHJ7oiAqrD8FyVjOs4BLHzx9QV5
         tec+1j0bALhIe0oKYzgkbYB/Fta/j6KpNZVDJRL7MNx7CVzW8AoUVzOKXuir/8a+84K4
         nc7/+7pZi1I28upuwcAK+my4DmhuelfzLCbIDT6t7t3ule+eWajculTQ2gxD5VWbdk76
         K/VD1VM6rvBRrSEiDwv22Tclub/sMuwO0WUrewtzXqJtsTi3pko1Oxlr/F4Z1j7RZn+D
         56/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hQIfJOwr2U69WzdbMGlOE3SDtRTxC/4X/cZpBo7hwt0=;
        b=CfxztsWcpODfoYXn7HBNGJasXN8PNjDGOHo3MIy5dq8Hic6uRm5eNRvz/TbO/rqo42
         lg3RcYlqTuR2RqiqruBdMJTCAyXfpDTVKFOFeIYsKkG3HBdJ5wcy2W4HKiu0brvI9l7+
         4xxMhg33MuEj+JsJGENEB5eMnCEblq0yO+qOO4yUn3C9c+C93ZVZGS4+tzeyqyPBCIBA
         eN+MEBpE2JzlquSrF2+WVSpp6usgBzhr5FnTwoGdK3+5V9uVtrCYCWoKUhmucxYlrMM/
         jXXbtho77C1mMxY8c8RbH0QWNzYLQZmTwJOGPLm61lAQituipT/VRMMdnXhIc820UnIr
         y7Vg==
X-Gm-Message-State: APjAAAXCXg/AYSq74VKu4qLQ7SNsughqv2nrS9l4ZVXDEhOvr+7ei14A
        kVfuEvjBsCKEf9Hf0/xzjIdwhQ==
X-Google-Smtp-Source: APXvYqx5svqQC4UbvktR6txIPzkeLvSae3TY6GwuO93GpV9VKZIxrnjkuyaVKKe2OijNrS0zDirplQ==
X-Received: by 2002:a1c:de88:: with SMTP id v130mr7673674wmg.89.1573206534835;
        Fri, 08 Nov 2019 01:48:54 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id w18sm4960016wrl.2.2019.11.08.01.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 01:48:54 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:48:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>
Subject: Re: [PATCH net-next 15/19] net/mlx5: Add load/unload routines for SF
 driver binding
Message-ID: <20191108094854.GC6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-15-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-15-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:30PM CET, parav@mellanox.com wrote:
>Add SF load/unload helper routines which will be used during
>binding/unbinding a SF to mlx5_core driver as mediated device.
>
>Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>Signed-off-by: Vu Pham <vuhuong@mellanox.com>
>Signed-off-by: Parav Pandit <parav@mellanox.com>
>---
> .../net/ethernet/mellanox/mlx5/core/main.c    | 11 ++-
> .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 67 +++++++++++++++++++

Nit: Why not s/meddev/mdev/ ? I think that "mdev" is widely recognized term.

[...]
