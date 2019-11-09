Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9229CF60AE
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 18:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfKIR1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 12:27:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43165 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKIR1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 12:27:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so6216506pgh.10
        for <kvm@vger.kernel.org>; Sat, 09 Nov 2019 09:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LNQy0C8TcfPweZgVjRqECLUUZS65m+iNRLaqpO28cpc=;
        b=T9i//IAbBC0AuabiLwtwWc7GE+oaapJVgv4mWfiAvm0tpKnuFX/p9p3+p75rgAkSCW
         vpOG8Qzzsszbth7hG21E7J8LpS2L9ObGM1WfWGlbQUSUc7352dyS8kfQb1pM83mrZygG
         Dk/C5Wht+yYMeqKw24JOr99J9W2Of3g3bwZ5vNaFVeLz9CYB0e3lPshdMTgtwaRNOu+C
         0A1ZiQLKDsOumhuPldMxmrrRmlWULplc2cP0SgsU+BDidu7DgRvzbVl4PI4b3t7yslSH
         aQDCflTyNxx9w6Jq4ZWzgUbSFetKEKa2Hae8760EUUZgrV340uyq8HPnQaQRxnUL3ypl
         pL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LNQy0C8TcfPweZgVjRqECLUUZS65m+iNRLaqpO28cpc=;
        b=a8wSQcwJapjaJMJL84U7z5G2oHlD37LF+xJ06tNez8nFWP3SkTvtqnNTvhPxOjmOgz
         3Aj1VVLYEAYO1NrB3EPqZcM6DPZgpl8cNIxfpmGtlpTfXOypjKk/tZ7wCnLvIs5CFGm9
         LzVmMFUmoyC6WneCDDug5CRhMX45G0HgBM3gHBciqr3GxwgFJeHX6qtNgQglmU0+2soh
         0zD0HmlRS8sRY7tec5hZwUrQCuX/naJgAz5jyguS+EcArdm4BOKf6bG8i5S0L2zWR81m
         nD/haR31AUHR53fFRib2+j4gVFzNjk/vpKRZgi3/+JtIs6hpIAK2LXHbduBk5tSKIyXn
         r4IA==
X-Gm-Message-State: APjAAAW/6aGWfW0NVazdzgIZ/uY0yvSn5sJ24XetF8NWgm5ajEzI7RhE
        P98qVGeOlYTaW9dWp6zBWxkABw==
X-Google-Smtp-Source: APXvYqyN0v9xi3O8NCMrCgGvJFhuxJlRvphL7ukGcg37cddjg2OFxXn/V8x/utaCJW36E2hLJrshfw==
X-Received: by 2002:a17:90a:9f8a:: with SMTP id o10mr22359546pjp.91.1573320471840;
        Sat, 09 Nov 2019 09:27:51 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j14sm9273772pfi.168.2019.11.09.09.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 09:27:51 -0800 (PST)
Date:   Sat, 9 Nov 2019 09:27:47 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <20191109092747.26a1a37e@cakuba>
In-Reply-To: <20191109004426.GB31761@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Nov 2019 20:44:26 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 01:45:59PM -0800, Jakub Kicinski wrote:
> > Yes, my suggestion to use mdev was entirely based on the premise that
> > the purpose of this work is to get vfio working.. otherwise I'm unclear
> > as to why we'd need a bus in the first place. If this is just for
> > containers - we have macvlan offload for years now, with no need for a
> > separate device.  
> 
> This SF thing is a full fledged VF function, it is not at all like
> macvlan. This is perhaps less important for the netdev part of the
> world, but the difference is very big for the RDMA side, and should
> enable VFIO too..

Well, macvlan used VMDq so it was pretty much a "legacy SR-IOV" VF.
I'd perhaps need to learn more about RDMA to appreciate the difference.

> > On the RDMA/Intel front, would you mind explaining what the main
> > motivation for the special buses is? I'm a little confurious.  
> 
> Well, the issue is driver binding. For years we have had these
> multi-function netdev drivers that have a single PCI device which must
> bind into multiple subsystems, ie mlx5 does netdev and RDMA, the cxgb
> drivers do netdev, RDMA, SCSI initiator, SCSI target, etc. [And I
> expect when NVMe over TCP rolls out we will have drivers like cxgb4
> binding to 6 subsytems in total!]

What I'm missing is why is it so bad to have a driver register to
multiple subsystems.

I've seen no end of hacks caused people trying to split their driver
too deeply by functionality. Separate sub-drivers, buses and modules.

The nfp driver was split up before I upstreamed it, I merged it into
one monolithic driver/module. Code is still split up cleanly internally,
the architecture doesn't change in any major way. Sure 5% of developers
were upset they can't do some partial reloads they were used to, but
they got used to the new ways, and 100% of users were happy about the
simplicity.

For the nfp I think the _real_ reason to have a bus was that it
was expected to have some out-of-tree modules bind to it. Something 
I would not encourage :)

Maybe RDMA and storage have some requirements where the reload of the
part of the driver is important, IDK..

> > My understanding is MFD was created to help with cases where single
> > device has multiple pieces of common IP in it.   
> 
> MFD really seems to be good at splitting a device when the HW is
> orthogonal at the register level. Ie you might have regs 100-200 for
> ethernet and 200-300 for RDMA.
> 
> But this is not how modern HW works, the functional division is more
> subtle and more software based. ie on most devices a netdev and rdma
> queue are nearly the same, just a few settings make them function
> differently.
> 
> So what is needed isn't a split of register set like MFD specializes
> in, but a unique per-driver API between the 'core' and 'subsystem'
> parts of the multi-subsystem device.

Exactly, because the device is one. For my simplistic brain one device
means one driver, which can register to as many subsystems as it wants.

> > Do modern RDMA cards really share IP across generations?   
> 
> What is a generation? Mellanox has had a stable RDMA driver across
> many sillicon generations. Intel looks like their new driver will
> support at least the last two or more sillicon generations..
> 
> RDMA drivers are monstrous complex things, there is a big incentive to
> not respin them every time a new chip comes out.

Ack, but then again none of the drivers gets rewritten from scratch,
right? It's not that some "sub-drivers" get reused and some not, no?

> > Is there a need to reload the drivers for the separate pieces (I
> > wonder if the devlink reload doesn't belong to the device model :().  
> 
> Yes, it is already done, but without driver model support the only way
> to reload the rdma driver is to unload the entire module as there is
> no 'unbind'

The reload is the only thing that I can think of (other than
out-of-tree code), but with devlink no I believe it can be solved
differently.

Thanks a lot for the explanation Jason, much appreciated!

The practicality of this is still a little elusive to me, but since 
Greg seems on board I guess it's just me :)
