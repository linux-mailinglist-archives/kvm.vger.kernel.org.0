Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CBF44F5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 11:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfKHKt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 05:49:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33944 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfKHKt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 05:49:57 -0500
Received: by mail-wm1-f65.google.com with SMTP id v3so7046222wmh.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 02:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kVQFGbjJWjVVeexPqhE+wf9oeaQlVSB/nxfL9025DxA=;
        b=VsZPmAgRazffphLtYn3oJquePLz98rYK+cDazoRJS4qZuDgNUYcklxFiCoA9YIpdJY
         MS02GMYflru5YqdN7iL+ZS53Hx3jpWYsOOxRpliD02cHbOu0c286mDvLcOoWGNjtTt3w
         Zwyh3x7bG6WjClWSVz4uIBu90DFzpB9MEwOV2iC4DpePeAAj7x8RuMnBRM6Fu9F/C3T2
         0yDzwo4XnPd/xNCokPh5jQl57JAaOR9rs3tCPpbFeVUm5O1MA3qhXMbObRVpTenQYzTF
         uiW+AHnYIbcv2VDCZ1lRasgy3slWHWj+FyVL/2+eNI80XNSr66pVkEsH3EPEk27X3B7N
         +AVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kVQFGbjJWjVVeexPqhE+wf9oeaQlVSB/nxfL9025DxA=;
        b=fKEvrKTaZticqukJt34JIM5h+PdLyzI93eHHwcg8csi9AqWkIEOCUtf1A0V+D6OBpz
         ndTewmWemkCXm5pjtC2yQk3I0wYfMhgmt6RX/x5XuTjdRR5QtUHZ3a1dnzWkIozLuE88
         27y9jR/hU5unEWcVwPatBEWvmmuNvCAWufrzLpQ6m4CkLvWnn7fEs8eYrB6qXitkFpyu
         z1CcO55c7m4doodasJqA/QvbTSokNp3JE2p+fgZ5qATYQ8TsdMHwpCocDnQubdVZDdMT
         ea+YBK22KuO/Oqw0s8yPYoon7aLIsiKljIuOjU5NJ+W6uHMlIQ6b2BSDed94eH+Y1ege
         4GwQ==
X-Gm-Message-State: APjAAAXgVkt2hn3o/iVeY/srLXyt3RYpUpt50hQkvOGStOOWURTC0qww
        CA6CuVs40prCJNV3vq4CmjMSSQ==
X-Google-Smtp-Source: APXvYqwV/c7PEld5ZK1WNUtOvZslB1nHq9Q8lZWnvarNw07sp+xFA//kSSC8kbi/sR0RT98JS7TVRw==
X-Received: by 2002:a1c:3b82:: with SMTP id i124mr5907392wma.122.1573210195429;
        Fri, 08 Nov 2019 02:49:55 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id l4sm4857627wml.33.2019.11.08.02.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 02:49:55 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:49:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 08/19] vfio/mdev: Make mdev alias unique among
 all mdevs
Message-ID: <20191108104954.GG6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-8-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-8-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thu, Nov 07, 2019 at 05:08:23PM CET, parav@mellanox.com wrote:
>Mdev alias should be unique among all the mdevs, so that when such alias
>is used by the mdev users to derive other objects, there is no
>collision in a given system.
>
>Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>Signed-off-by: Parav Pandit <parav@mellanox.com>
>---
> drivers/vfio/mdev/mdev_core.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>index 3bdff0469607..c8cd40366783 100644
>--- a/drivers/vfio/mdev/mdev_core.c
>+++ b/drivers/vfio/mdev/mdev_core.c
>@@ -388,6 +388,13 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
> 			ret = -EEXIST;
> 			goto mdev_fail;
> 		}
>+		if (alias && tmp->alias && !strcmp(alias, tmp->alias)) {
>+			mutex_unlock(&mdev_list_lock);
>+			ret = -EEXIST;
>+			dev_dbg_ratelimited(dev, "Hash collision in alias creation for UUID %pUl\n",
>+					    uuid);
>+			goto mdev_fail;
>+		}

I don't understand why this needs to be a separate patch. This check
seems to be an inseparable part of mdev alias feature.
Please squash to the previous patch.


> 	}
> 
> 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>-- 
>2.19.2
>
