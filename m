Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1BCEF4F17
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfKHPPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 10:15:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33492 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKHPPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 10:15:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id a17so6835485wmb.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 07:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VADyXkmyEZwfz7UJm4aPW0AfoCAr6udjM9RfkA0/AnM=;
        b=NndXX4Geris7hE8V/Ztnx+9bbxzvSDFEhdn26kChY8owv7CATc2cz9mhRKtGY4nwSL
         Oyb43cBXpw93oZfh+ia9K8r3NlRuke95gm4KhOQMSuA3WUiKNaIUunHFUzmG7dCLmzUY
         ccYtg9tPwXvJew37XZ9GriStnVOfCN9yoA+KaQFXB5xT2sVc3xn6tsAaK8WvV0lnxCwJ
         4fo+I6EwSiImHP4gyJjvq0ZTmEfJG3HlksfGCE3u5tmPctQXeGCPWWi4JItZQ8rbu3MP
         nP0m2i2YjP42HW6R3f3xJvJFYaxu4OuZjEU3ueIPhd6B5ZpDl0JZe434fpEfDpFF7VxU
         ypOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VADyXkmyEZwfz7UJm4aPW0AfoCAr6udjM9RfkA0/AnM=;
        b=LVp0Uabwj2kukpZirqArvQpwlp4PFHN22uC6blzEPKsgp5D96MH+QwnKaE6UjwI1lc
         VRZ+AoTrehQj7LTgYUNiU+Fa6I1uIQ3622nbJojmpkenRPqgKbCjTJv2wMG4VUQEKyKF
         jnKsY5B+SSbrCWKj5GLDke3OSS8hScgK0yUDWxPglFjlBWb8oC10pPe9vIujL8QzuZq/
         Hj22ut80brScztuaZJQSvd0sNyuhr9Bg46gXf5I3iNzRS8Z9c4guUSdAi3t4lGeuPq1c
         ZhHQ7SUAXUKPSyRnxSxsmyM5+dcTvyBZQmTKQXBoeWUjJfhZ0/YCM1sRWBf/X/q1WYMV
         Vaig==
X-Gm-Message-State: APjAAAUPlve1DaKSGMqiUcPCXQOoWxdCN/pdberrU2wU77sknTDJRVFZ
        +hkp7v3W1LV12ubPGcTKGae4TQ==
X-Google-Smtp-Source: APXvYqzINYRoUuFX5NaF77jpHF+D0eryv4W23kT3xH8z73wcQ98F4Yz0rU59bhdkqSPWnxEUfSRslQ==
X-Received: by 2002:a1c:39c1:: with SMTP id g184mr8682539wma.75.1573226136346;
        Fri, 08 Nov 2019 07:15:36 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id d202sm5462271wmd.47.2019.11.08.07.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 07:15:36 -0800 (PST)
Date:   Fri, 8 Nov 2019 16:15:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108151535.GL6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-19-parav@mellanox.com>
 <20191108104505.GF6990@nanopsycho>
 <AM0PR05MB486674869FD72D1FCE3C7B53D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB486674869FD72D1FCE3C7B53D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fri, Nov 08, 2019 at 04:08:22PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, November 8, 2019 4:45 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: alex.williamson@redhat.com; davem@davemloft.net;
>> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
>> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
>> rdma@vger.kernel.org
>> Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
>> 
>> Thu, Nov 07, 2019 at 05:08:34PM CET, parav@mellanox.com wrote:
>> >Provide a module parameter to set alias length to optionally generate
>> >mdev alias.
>> >
>> >Example to request mdev alias.
>> >$ modprobe mtty alias_length=12
>> >
>> >Make use of mtty_alias() API when alias_length module parameter is set.
>> >
>> >Signed-off-by: Parav Pandit <parav@mellanox.com>
>> 
>> This patch looks kind of unrelated to the rest of the set.
>> I think that you can either:
>> 1) send this patch as a separate follow-up to this patchset
>> 2) use this patch as a user and push out the mdev alias patches out of this
>> patchset to a separate one (I fear that this was discussed and declined
>> before).
>Yes, we already discussed to run mdev 5-6 patches as pre-patch before this series when reviewed on kvm mailing list.
>Alex was suggesting to package with this series as mlx5_core being the first user.
>Series will have conflict (not this patch) if Jason Wang's series [9] is merged first.
>So please let me know how shall we do it.

Just remove this patch from the set and push it later on individually
(if ever).

>
>[9] https://patchwork.ozlabs.org/patch/1190425
>
>
