Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A348D24AE56
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 07:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgHTFQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 01:16:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgHTFQh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 01:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597900595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YBmMlDK08ygRLxBOtV4fn8Ya8+7txjXr1BlgEUxCss=;
        b=eVJLxuYKL8vAtqsfOgQ87JLDQoyZUvRR89Bg13EZMO6nzfmlBUIVWccP0ODHJqILN7/puF
        M9P6pdT7iOlZxUuwRbEZJWiW1jIujyehpFjkd5PCV8kpDIa6S73YJVaFt7SzAPn5FjF2Nt
        pDUXB7ZQnYovKxpJ92nXyMlaizJ/ZWI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-KSOvcKNEPbi3gi8AXzQZBQ-1; Thu, 20 Aug 2020 01:16:33 -0400
X-MC-Unique: KSOvcKNEPbi3gi8AXzQZBQ-1
Received: by mail-ed1-f69.google.com with SMTP id p7so437220edm.5
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 22:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YBmMlDK08ygRLxBOtV4fn8Ya8+7txjXr1BlgEUxCss=;
        b=WNc9ILSd7DHOPEUlJonQZyy1i8taL0MaiTAAoysE+l3dyOpJtYsK9cAJAIYWp+zPZC
         NEkyo1gKayt/osJ+Q/9R/uOSCVjD3/VdXoFZqfYQRc1gqSnspds9DVC6pxy19o/KRx8a
         czOn798X+GeqorhN5MZC0ESWpKpa7+LcM+U+/vcR4coPs0+3Mt4DZrSL2cSsD80qnliM
         5QqtIUEOSAkqqjoVCsryF8imcSysN8GSTghQ8FFK0PBfSYMet/BHPxNYLv03idXvT7yb
         IpaNpM7wAJWzucKg7m546ArbW5gvERrVzdt0xMfeanQa9B1cWw2pY1C+ovoaph0dZd3h
         tySQ==
X-Gm-Message-State: AOAM533oBeFXV268L/jXX1BBJ07sqBXLfi78hgY5kzgeFwZAzHPXCziq
        v94gCxLvqUihEEMvx9qgbuzQ4RWEagR8tq4VpZyNkCduIlQiXYuQ7F5uDZ8AmTQ/4NbbejEV57n
        vQ2viKn+DI+u2
X-Received: by 2002:a17:906:960a:: with SMTP id s10mr1623671ejx.60.1597900591861;
        Wed, 19 Aug 2020 22:16:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLVGyxG1fhJkbUY7K9ahB2oumCnCBxXdHKmSC3so6VH3GxguXSWKeiO37z2o8foD+A/q4xmQ==
X-Received: by 2002:a17:906:960a:: with SMTP id s10mr1623641ejx.60.1597900591553;
        Wed, 19 Aug 2020 22:16:31 -0700 (PDT)
Received: from pop-os ([51.37.51.98])
        by smtp.gmail.com with ESMTPSA id bd13sm602373edb.38.2020.08.19.22.16.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Aug 2020 22:16:30 -0700 (PDT)
Message-ID: <da140e6d262632e2fb707f69f220915748d25d35.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "Daniel P." =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
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
Date:   Thu, 20 Aug 2020 06:16:28 +0100
In-Reply-To: <20200820040116.GB24121@joy-OptiPlex-7040>
References: <20200810074631.GA29059@joy-OptiPlex-7040>
         <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
         <20200814051601.GD15344@joy-OptiPlex-7040>
         <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
         <20200818085527.GB20215@redhat.com>
         <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
         <20200818091628.GC20215@redhat.com>
         <20200818113652.5d81a392.cohuck@redhat.com>
         <20200820003922.GE21172@joy-OptiPlex-7040>
         <242591bb809b68c618f62fdc93d4f8ae7b146b6d.camel@redhat.com>
         <20200820040116.GB24121@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 12:01 +0800, Yan Zhao wrote:
> On Thu, Aug 20, 2020 at 02:29:07AM +0100, Sean Mooney wrote:
> > On Thu, 2020-08-20 at 08:39 +0800, Yan Zhao wrote:
> > > On Tue, Aug 18, 2020 at 11:36:52AM +0200, Cornelia Huck wrote:
> > > > On Tue, 18 Aug 2020 10:16:28 +0100
> > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > 
> > > > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
> > > > > >    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> > > > > > 
> > > > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > > > 
> > > > > >  On 2020/8/14 下午1:16, Yan Zhao wrote:
> > > > > > 
> > > > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > > > 
> > > > > >  On 2020/8/10 下午3:46, Yan Zhao wrote:  
> > > > > >  we actually can also retrieve the same information through sysfs, .e.g
> > > > > > 
> > > > > >  |- [path to device]
> > > > > >     |--- migration
> > > > > >     |     |--- self
> > > > > >     |     |   |---device_api
> > > > > >     |    |   |---mdev_type
> > > > > >     |    |   |---software_version
> > > > > >     |    |   |---device_id
> > > > > >     |    |   |---aggregator
> > > > > >     |     |--- compatible
> > > > > >     |     |   |---device_api
> > > > > >     |    |   |---mdev_type
> > > > > >     |    |   |---software_version
> > > > > >     |    |   |---device_id
> > > > > >     |    |   |---aggregator
> > > > > > 
> > > > > > 
> > > > > >  Yes but:
> > > > > > 
> > > > > >  - You need one file per attribute (one syscall for one attribute)
> > > > > >  - Attribute is coupled with kobject
> > > > 
> > > > Is that really that bad? You have the device with an embedded kobject
> > > > anyway, and you can just put things into an attribute group?
> > > > 
> > > > [Also, I think that self/compatible split in the example makes things
> > > > needlessly complex. Shouldn't semantic versioning and matching already
> > > > cover nearly everything? I would expect very few cases that are more
> > > > complex than that. Maybe the aggregation stuff, but I don't think we
> > > > need that self/compatible split for that, either.]
> > > 
> > > Hi Cornelia,
> > > 
> > > The reason I want to declare compatible list of attributes is that
> > > sometimes it's not a simple 1:1 matching of source attributes and target attributes
> > > as I demonstrated below,
> > > source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatible to
> > > target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
> > >                (mdev_type i915-GVTg_V5_8 + aggregator 4)
> > 
> > the way you are doing the nameing is till really confusing by the way
> > if this has not already been merged in the kernel can you chagne the mdev
> > so that mdev_type i915-GVTg_V5_2 is 2 of mdev_type i915-GVTg_V5_1 instead of half the device
> > 
> > currently you need to deived the aggratod by the number at the end of the mdev type to figure out
> > how much of the phsicial device is being used with is a very unfridly api convention
> > 
> > the way aggrator are being proposed in general is not really someting i like but i thin this at least
> > is something that should be able to correct.
> > 
> > with the complexity in the mdev type name + aggrator i suspect that this will never be support
> > in openstack nova directly requireing integration via cyborg unless we can pre partion the
> > device in to mdevs staicaly and just ignore this.
> > 
> > this is way to vendor sepecif to integrate into something like openstack in nova unless we can guarentee
> > taht how aggreator work will be portable across vendors genericly.
> > 
> > > 
> > > and aggragator may be just one of such examples that 1:1 matching does not
> > > fit.
> > 
> > for openstack nova i dont see us support anything beyond the 1:1 case where the mdev type does not change.
> > 
> 
> hi Sean,
> I understand it's hard for openstack. but 1:N is always meaningful.
> e.g.
> if source device 1 has cap A, it is compatible to
> device 2: cap A,
> device 3: cap A+B,
> device 4: cap A+B+C
> ....
> to allow openstack to detect it correctly, in compatible list of
> device 2, we would say compatible cap is A;
> device 3, compatible cap is A or A+B;
> device 4, compatible cap is A or A+B, or A+B+C;
> 
> then if openstack finds device A's self cap A is contained in compatible
> cap of device 2/3/4, it can migrate device 1 to device 2,3,4.
> 
> conversely,  device 1's compatible cap is only A,
> so it is able to migrate device 2 to device 1, and it is not able to
> migrate device 3/4 to device 1.

yes we build the palcement servce aroudn the idea of capablites as traits on resocue providres.
which is why i originally asked if we coudl model compatibality with feature flags

we can seaislyt model deivce as aupport A, A+B or  A+B+C
and then select hosts and evice based on that but

the list of compatable deivce you are propsoeing hide this feature infomation which whould be what we are matching on.

give me a lset of feature you want and list ting the feature avaiable on each device allow highre level ocestation to
easily match the request to a host that can fulllfile it btu thave a set of other compatihble device does not help with
that

so if a simple list a capabliteis can be advertiese d and if we know tha two dievce with the same capablity are
intercahangebale that is workabout i suspect that will not be the case however and it would onely work within a familay
of mdevs that are closely related.  which i think agian is an argument for not changeing the mdev type and at least
intially only look at migatreion where the mdev type doee not change initally. 

> 
> Thanks
> Yan
> 
> > i woudl really prefer if there was just one mdev type that repsented the minimal allcatable unit and the
> > aggragaotr where used to create compostions of that. i.e instad of i915-GVTg_V5_2 beign half the device,
> > have 1 mdev type i915-GVTg and if the device support 8 of them then we can aggrate 4 of i915-GVTg
> > 
> > if you want to have muplie mdev type to model the different amoutn of the resouce e.g. i915-GVTg_small i915-
> > GVTg_large
> > that is totlaly fine too or even i915-GVTg_4 indcating it sis 4 of i915-GVTg
> > 
> > failing that i would just expose an mdev type per composable resouce and allow us to compose them a the user level
> > with
> > some other construct mudeling a attament to the device. e.g. create composed mdev or somethig that is an aggreateion
> > of
> > multiple sub resouces each of which is an mdev. so kind of like how bond port work. we would create an mdev for each
> > of
> > the sub resouces and then create a bond or aggrated mdev by reference the other mdevs by uuid then attach only the
> > aggreated mdev to the instance.
> > 
> > the current aggrator syntax and sematic however make me rather uncofrotable when i think about orchestating vms on
> > top
> > of it even to boot them let alone migrate them.
> > > 
> > > So, we explicitly list out self/compatible attributes, and management
> > > tools only need to check if self attributes is contained compatible
> > > attributes.
> > > 
> > > or do you mean only compatible list is enough, and the management tools
> > > need to find out self list by themselves?
> > > But I think provide a self list is easier for management tools.
> > > 
> > > Thanks
> > > Yan
> > > 
> 
> 

