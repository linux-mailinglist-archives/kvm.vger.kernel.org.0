Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8B24AC9E
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 03:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHTB3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 21:29:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726707AbgHTB3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 21:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597886952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mv65M1+t+HPSl/WRfYZMesR9s3J7YwA43eBtlMjfynM=;
        b=dkGib0eY81Kw0+YUS4GeTHdbIwRg4eo9DNtv9g48yRXq9NPnfxTYe333BaXIVPvaHgiA6Z
        GL9p41+xkHne256gk5UGHFnFcSJ+UkMu2aoLcmyySPCZaPy+3YqCC1um2VcXE51fHc0plT
        YnJLuVpKqHccF6V9t6owaba5btFp59A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-jI6AqBgnPEqpIrBcJ8NYKw-1; Wed, 19 Aug 2020 21:29:10 -0400
X-MC-Unique: jI6AqBgnPEqpIrBcJ8NYKw-1
Received: by mail-ej1-f71.google.com with SMTP id bx27so232113ejc.15
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 18:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mv65M1+t+HPSl/WRfYZMesR9s3J7YwA43eBtlMjfynM=;
        b=omfNbCtYf+0wtG3J5QQH6LrcaWusTBjwKS3xq9eQxrqAp4PRaHW+Pze4gZjPDe12FG
         3HAcffpMhWPfhbpID96nt2nB44cTgOU8aVdPvG1IGC2peDKB5VbEB23bs2wQvOM2HMGI
         h76wqGn7quPwasqrOLYR0xv3LR9YrWb/A4zHeUh/3tr9EU9KLeUAeKnumRxY5DTlT+35
         VG90way8bxYfeOEJI4UwVRdzEqU/yBAmRFJSvSefYfot2T1cwEoiXf4Q0x62i9JjpCCF
         iwdRIVBtDXyvV9bAH/CZaERsz+vTP+sR7kfcuLlo/DM6L2O6o1j4lkm3QQK+rT9TSbmZ
         hCxA==
X-Gm-Message-State: AOAM533rRfGALeNt+m64C+CTZWLRU4DBjLVemus5LagBMHwVF4dCHwGF
        BBsLfI/Mruerej2QlKcWhbf1KQzMV/gZHBL/2OTrPYJZQEfWfDrU+QNa454/rVFUlg82lWgbNtL
        t5gVlqm0iXuHz
X-Received: by 2002:a17:906:4356:: with SMTP id z22mr1078926ejm.414.1597886949030;
        Wed, 19 Aug 2020 18:29:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoyKfjf0D7MrJMX9479zeQtARXzClfhI3mERBVAU5/JYOmhYh4Jk1gt0aNrlay6m1myoOVsg==
X-Received: by 2002:a17:906:4356:: with SMTP id z22mr1078909ejm.414.1597886948787;
        Wed, 19 Aug 2020 18:29:08 -0700 (PDT)
Received: from pop-os ([51.37.51.98])
        by smtp.gmail.com with ESMTPSA id m12sm287263edv.94.2020.08.19.18.29.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Aug 2020 18:29:08 -0700 (PDT)
Message-ID: <242591bb809b68c618f62fdc93d4f8ae7b146b6d.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     "Daniel P." =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org, eskultet@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Date:   Thu, 20 Aug 2020 02:29:07 +0100
In-Reply-To: <20200820003922.GE21172@joy-OptiPlex-7040>
References: <20200805093338.GC30485@joy-OptiPlex-7040>
         <20200805105319.GF2177@nanopsycho>
         <20200810074631.GA29059@joy-OptiPlex-7040>
         <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
         <20200814051601.GD15344@joy-OptiPlex-7040>
         <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
         <20200818085527.GB20215@redhat.com>
         <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
         <20200818091628.GC20215@redhat.com>
         <20200818113652.5d81a392.cohuck@redhat.com>
         <20200820003922.GE21172@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 08:39 +0800, Yan Zhao wrote:
> On Tue, Aug 18, 2020 at 11:36:52AM +0200, Cornelia Huck wrote:
> > On Tue, 18 Aug 2020 10:16:28 +0100
> > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > 
> > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
> > > >    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> > > > 
> > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > 
> > > >  On 2020/8/14 下午1:16, Yan Zhao wrote:
> > > > 
> > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > 
> > > >  On 2020/8/10 下午3:46, Yan Zhao wrote:  
> > > >  we actually can also retrieve the same information through sysfs, .e.g
> > > > 
> > > >  |- [path to device]
> > > >     |--- migration
> > > >     |     |--- self
> > > >     |     |   |---device_api
> > > >     |    |   |---mdev_type
> > > >     |    |   |---software_version
> > > >     |    |   |---device_id
> > > >     |    |   |---aggregator
> > > >     |     |--- compatible
> > > >     |     |   |---device_api
> > > >     |    |   |---mdev_type
> > > >     |    |   |---software_version
> > > >     |    |   |---device_id
> > > >     |    |   |---aggregator
> > > > 
> > > > 
> > > >  Yes but:
> > > > 
> > > >  - You need one file per attribute (one syscall for one attribute)
> > > >  - Attribute is coupled with kobject
> > 
> > Is that really that bad? You have the device with an embedded kobject
> > anyway, and you can just put things into an attribute group?
> > 
> > [Also, I think that self/compatible split in the example makes things
> > needlessly complex. Shouldn't semantic versioning and matching already
> > cover nearly everything? I would expect very few cases that are more
> > complex than that. Maybe the aggregation stuff, but I don't think we
> > need that self/compatible split for that, either.]
> 
> Hi Cornelia,
> 
> The reason I want to declare compatible list of attributes is that
> sometimes it's not a simple 1:1 matching of source attributes and target attributes
> as I demonstrated below,
> source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatible to
> target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
>                (mdev_type i915-GVTg_V5_8 + aggregator 4)
the way you are doing the nameing is till really confusing by the way
if this has not already been merged in the kernel can you chagne the mdev
so that mdev_type i915-GVTg_V5_2 is 2 of mdev_type i915-GVTg_V5_1 instead of half the device

currently you need to deived the aggratod by the number at the end of the mdev type to figure out
how much of the phsicial device is being used with is a very unfridly api convention

the way aggrator are being proposed in general is not really someting i like but i thin this at least
is something that should be able to correct.

with the complexity in the mdev type name + aggrator i suspect that this will never be support
in openstack nova directly requireing integration via cyborg unless we can pre partion the
device in to mdevs staicaly and just ignore this.

this is way to vendor sepecif to integrate into something like openstack in nova unless we can guarentee
taht how aggreator work will be portable across vendors genericly.

> 
> and aggragator may be just one of such examples that 1:1 matching does not
> fit.
for openstack nova i dont see us support anything beyond the 1:1 case where the mdev type does not change.

i woudl really prefer if there was just one mdev type that repsented the minimal allcatable unit and the
aggragaotr where used to create compostions of that. i.e instad of i915-GVTg_V5_2 beign half the device,
have 1 mdev type i915-GVTg and if the device support 8 of them then we can aggrate 4 of i915-GVTg

if you want to have muplie mdev type to model the different amoutn of the resouce e.g. i915-GVTg_small i915-GVTg_large
that is totlaly fine too or even i915-GVTg_4 indcating it sis 4 of i915-GVTg

failing that i would just expose an mdev type per composable resouce and allow us to compose them a the user level with
some other construct mudeling a attament to the device. e.g. create composed mdev or somethig that is an aggreateion of
multiple sub resouces each of which is an mdev. so kind of like how bond port work. we would create an mdev for each of
the sub resouces and then create a bond or aggrated mdev by reference the other mdevs by uuid then attach only the
aggreated mdev to the instance.

the current aggrator syntax and sematic however make me rather uncofrotable when i think about orchestating vms on top
of it even to boot them let alone migrate them.
> 
> So, we explicitly list out self/compatible attributes, and management
> tools only need to check if self attributes is contained compatible
> attributes.
> 
> or do you mean only compatible list is enough, and the management tools
> need to find out self list by themselves?
> But I think provide a self list is easier for management tools.
> 
> Thanks
> Yan
> 

