Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9862F5126
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKHQbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 11:31:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34897 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHQbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 11:31:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id 8so6874514wmo.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 08:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ERVJK5BuyURirDcUPt+CClmNLwklFNofFChTUhig2gA=;
        b=Qcfo+t2fqY2axoyd2EON6su+W3MPUNRLktCOeMSsIFMcCT06jV7ifNTviy/2OozlrA
         k1AS65YvW0jmEQkUiSRKUsRMwCKgoybDrlyMUdqe0xS0UKPB5HDDzhCrZDbcF1+6RHPG
         OeD/ZUsMotXyABetY/QBIig29nEEwp4oZnopcHAb92Tv2wxRCxoXQ8lSkZsOXKZlAcYs
         6SJlul+Bt5u4zsOB5TYHdr7Zi28TbGGKZJLK0SPvjHpK5ldwSyICEkYG3WRCgb41Tm84
         QGAomc8Gkd69kC9sOF1yAcMUU71eEgTNPqK7UcndefpU2WiUBkXnvEH97eYVxyiL1z6B
         QyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ERVJK5BuyURirDcUPt+CClmNLwklFNofFChTUhig2gA=;
        b=NBksbFU4lHa3PZmeuiwXkvK00Dj//vdwEwOvxj4a8GTxPPSOU005udCyrBZX9xRzgL
         4hOU27w4G6K2dTVKfrfqAUYWxm0MPiplD2SfH26RVXxl741Uz0syLFynshVdbWaaR4aU
         FbfrgAGPZDQU8dQcels3unSDZb1AF+XkS7yXieS+HwYjb7plK1b//4J/gt5kCep1xGiG
         vB/LiPv5TnjhVXjklRcfCuIfAoKV/imddUOXVfQiq7vNtMGuvygUvLDzaJ54KbyScJ57
         E0K4Zy+8hmup1PnA8DFQMiKNXree4CEdU/5NccAM2uwql6MsVDRcg4Ogmne13BvrKpIS
         WxVQ==
X-Gm-Message-State: APjAAAVr4l4e3vvG7QNq2bihSAeB5UwuwBv/0XD84l3DsxlAQfiAu2hM
        YpwfHHkWTOd088ZRLbfXN0AceA==
X-Google-Smtp-Source: APXvYqyLKg2EQBwy6sCm6b4sMY++gGDhlFdzt1UxrdmFDkk302hJsE6uRP5hbKrqBIrs5NjAudUDmw==
X-Received: by 2002:a05:600c:506:: with SMTP id i6mr9328843wmc.153.1573230700377;
        Fri, 08 Nov 2019 08:31:40 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id q17sm5561065wmj.12.2019.11.08.08.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 08:31:40 -0800 (PST)
Date:   Fri, 8 Nov 2019 17:31:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191108163139.GQ6990@nanopsycho>
References: <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fri, Nov 08, 2019 at 04:45:06PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Friday, November 8, 2019 3:47 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>;
>> alex.williamson@redhat.com; davem@davemloft.net; kvm@vger.kernel.org;
>> netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
>> kwankhede@nvidia.com; leon@kernel.org; cohuck@redhat.com; Jiri Pirko
>> <jiri@mellanox.com>; linux-rdma@vger.kernel.org
>> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>> 
>> Fri, Nov 08, 2019 at 03:31:02AM CET, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> >> Sent: Thursday, November 7, 2019 8:20 PM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: alex.williamson@redhat.com; davem@davemloft.net;
>> >> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> >> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
>> >> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
>> >> rdma@vger.kernel.org
>> >> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port
>> >> flavour
>> >>
>> >> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
>> >> > > I'm talking about netlink attributes. I'm not suggesting to
>> >> > > sprintf it all into the phys_port_name.
>> >> > >
>> >> > I didn't follow your comment. For devlink port show command output
>> >> > you said,
>> >> >
>> >> > "Surely those devices are anchored in on of the PF (or possibly
>> >> > VFs) that should be exposed here from the start."
>> >> > So I was trying to explain why we don't expose PF/VF detail in the
>> >> > port attributes which contains
>> >> > (a) flavour
>> >> > (b) netdev representor (name derived from phys_port_name)
>> >> > (c) mdev alias
>> >> >
>> >> > Can you please describe which netlink attribute I missed?
>> >>
>> >> Identification of the PCI device. The PCI devices are not linked to
>> >> devlink ports, so the sysfs hierarchy (a) is irrelevant, (b) may not
>> >> be visible in multi- host (or SmartNIC).
>> >>
>> >
>> >It's the unique mdev device alias. It is not right to attach to the PCI device.
>> >Mdev is bus in itself where devices are identified uniquely. So an alias
>> suffice that identity.
>> 
>> Wait a sec. For mdev, what you say is correct. But here we talk about
>> devlink_port which is representing this mdev. And this devlink_port is very
>> similar to VF devlink_port. It is bound to specific PF (in case of mdev it could
>> be PF-VF).
>>
>But mdev port has unique phys_port_name in system, it incorrect to use PF/VF prefix.

Why incorrect? It is always bound to pf/vf?

>What in hypothetical case, mdev is not on top of PCI...

Okay, let's go hypothetical. In that case, it is going to be on top of
something else, wouldn't it?
