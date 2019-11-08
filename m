Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91DCF57E3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbfKHTsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 14:48:41 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34943 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbfKHTsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 14:48:40 -0500
Received: by mail-lf1-f67.google.com with SMTP id y6so5361171lfj.2
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 11:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4GeYl/JbmaQ+nNNGRRXeewY0GX5EX1yGt/fIXbi0lcQ=;
        b=baEWTVBGrFUgZcK2tuV+LCR0I1Lug9a5Sa6Pc3HTQihrbuuSG5W4eGJLZrXivlqEpO
         C2TTMPLivHxRNvJAc/cABFZoBmtOb9+pcG+JdOAVziOL8T6GP8GTgMySHw0hlooPFyF8
         9KF56BtyKUYVVT5P2Sz3FGO3PrVQm4dmWKznxDasf3qmUr5WfIUxtnmo99gJVDvJrw4m
         LYgGj4zw3CYHP2rGgdUQ52+xN/e92Dp7iGvjeMRYtHTZ7kZehNlRg/Mexc1vsJWkcMqS
         1DlRfM3YrAScdCkF57aVtE2IaS6GOJTBD5r/jMWpBwBXPJ7EnVzF+USSxRrZBkhh/1Ow
         m3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4GeYl/JbmaQ+nNNGRRXeewY0GX5EX1yGt/fIXbi0lcQ=;
        b=FP36aX1wahxZ3724VR4YozP1AxMg2vKmO8H1dq+OLUFrajQDKtUyy6Gn8c2165ez+F
         HCNMga8qCApW45Ej1gNvk9d/W9aTb0Nw3I5aEX1qolYMW9oOt0pGfbHblaOvIXtL+atZ
         qqXoQMC5P+ViTTohmRxcXCWoVu7x4cHu6KB8z08QaL7Y84A+2/JZZ6/Z+17BCHoxeXFy
         YD/lATwlydDuy6cyDNqMoobsGKQpibTBiz9nQq+BRUY3kGUci9fwIpg3ZueTXadIJdZi
         CzQyMlGFNx/7ev/U/yb1qM+YS15TETsiN1F/FVpVfhlTu6y51KRht/brfIIQzcb0BANG
         Gd+Q==
X-Gm-Message-State: APjAAAWQneYKJL+eRq2BLq/2Nd/KYY29E4OPodSsrZpO7O9mP1sgLT+x
        weizbPqokiokBUtIe+aVMpmdBQ==
X-Google-Smtp-Source: APXvYqzblZmoKjD9onc9Zui7MoXcErFTsLEVRUVVbR6WsIVxiOMADI2lS5/NZ2ASUDvRFLsn9ImzAA==
X-Received: by 2002:ac2:46c9:: with SMTP id p9mr7147719lfo.166.1573242518612;
        Fri, 08 Nov 2019 11:48:38 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n19sm2983782lfl.85.2019.11.08.11.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 11:48:38 -0800 (PST)
Date:   Fri, 8 Nov 2019 11:48:27 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108114827.0b95b032@cakuba>
In-Reply-To: <AM0PR05MB4866B735135F667D0D512552D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108110640.225b2724@cakuba>
        <AM0PR05MB4866B735135F667D0D512552D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Nov 2019 19:34:07 +0000, Parav Pandit wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>  
>  
> > On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:  
> > > Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:  
> > > >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:  
> > > >> Mellanox sub function capability allows users to create several
> > > >> hundreds of networking and/or rdma devices without depending on PCI  
> > SR-IOV support.  
> > > >
> > > >You call the new port type "sub function" but the devlink port
> > > >flavour is mdev.
> > > >
> > > >As I'm sure you remember you nacked my patches exposing NFP's PCI sub
> > > >functions which are just regions of the BAR without any mdev
> > > >capability. Am I in the clear to repost those now? Jiri?  
> > >
> > > Well question is, if it makes sense to have SFs without having them as
> > > mdev? I mean, we discussed the modelling thoroughtly and eventually we
> > > realized that in order to model this correctly, we need SFs on "a bus".
> > > Originally we were thinking about custom bus, but mdev is already
> > > there to handle this.  
> > 
> > But the "main/real" port is not a mdev in your case. NFP is like mlx4.
> > It has one PCI PF for multiple ports.
> >   
> > > Our SFs are also just regions of the BAR, same thing as you have.
> > >
> > > Can't you do the same for nfp SFs?
> > > Then the "mdev" flavour is enough for all.  
> > 
> > Absolutely not.
> >   
> Please explain what is missing in mdev.
> And frankly it is too late for such a comment.
> I sent out RFC patches back in March-19, 
> further discussed in netdevconf0x13, 
> further discussed several times while we introduced devlink ports,
> further discussed in august with mdev alias series and phys_port_name formation for mdev.
> This series shouldn't be any surprise for you at all.
> Anyways.
> 
> > Why not make the main device of mlx5 a mdev, too, if that's acceptable.
> > There's (a) long precedence for multiple ports on one PCI PF in networking
> > devices, (b) plenty deployed software which depend on the main devices
> > hanging off the PCI PF directly.
> > 
> > The point of mdevs is being able to sign them to VFs or run DPDK on them (map
> > to user space).
> >   
> That can be one use case. That is not the only use case.
> I clearly explained the use case scenarios in motivation section of the cover letter. Please go through it again.
> This series is certainly not targeting the DPDK usecase right now.
> 
> Also please read design decisions section of cover letter...
> 
> > For normal devices existing sysfs hierarchy were one device has multiple
> > children of a certain class, without a bus and a separate driver is perfectly fine.
> > Do you think we should also slice all serial chips into mdevs if they have
> > multiple lines.
> > 
> > Exactly as I predicted much confusion about what's being achieved here, heh :)  
> 
> We don't see confusion here. Please be specific on the point that confuses you.
> A PCI device is sliced to multiple devices to make use of it in different ways. Serial chips are not good example of it.
> This is fitting in with 
> - overall kernel bus-driver model, 
> - suitable for multiple types of devices (netdev, rdma and their different link layers), 
> - devlink framework of bus/device notion for health reporters, ports, resources
> - mapping to VM/bare-metal/container usecase.
> - and more..
> I don't want to further repeat the cover-letter here.. let's talk specific points to improve upon.

Parav, I think you completely missed the point of my email.

I was replying to Jiri saying that mdev does not fit the nfp/mlx4
mutli-port devices, and we still need a normal "PCI split" or something
along those lines to have multiple PF ports on one PF.

I'm not talking about your use of mdev at all.

The discussion on patch 12 also seems to indicate you don't read the
emails you reply to...
