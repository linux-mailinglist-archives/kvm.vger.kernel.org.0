Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484A1231D59
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 13:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgG2L24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 07:28:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20003 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2L2z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 07:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596022132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRCwriZuya4PIqyCKK+++y6J/9RTsVsLdq/Wykb7orU=;
        b=dnw325olbA9RL2m3yFxUG5EYYuBk2mqtxugmp0MkrY6oq4YF9IKXZ1bflT4Xz+aDJKFmYq
        SiO5hJw1bgrOmybAYbDtZVUcxaTIeUnhwsJW9o2QXvi5VOrFwTvR3q7XzWrRwW4+UHqMHu
        YntlMJs65B10SIDDek8oGVs1cwC2L48=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-KVqOY6ZuMsmB_JOqNGcqyg-1; Wed, 29 Jul 2020 07:28:51 -0400
X-MC-Unique: KVqOY6ZuMsmB_JOqNGcqyg-1
Received: by mail-wm1-f72.google.com with SMTP id f74so902539wmf.1
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 04:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bRCwriZuya4PIqyCKK+++y6J/9RTsVsLdq/Wykb7orU=;
        b=kIji7lBaBT4uLph2fWBX4lGoB7zEc641HMARO10tiGIQFrA5L1+oth1atik37TLWYf
         EvyV4n2QmJcxdySIgU5vSZTW2YH6Gd/FVpwKQC1KWdN1cHBEvvDwMt+nENUWf/Maa1WD
         kRhxSQxi2/+5H6epS1QSm/RtGbtJwQMLGRQif1tJzp2MMAb16FEtHtl3PllckHVXQ+TR
         bmBOhDQ2ZN1jI3RkKh5+5587P1hQumM0SLvAfisoSsk80oQU1UUjN922Ogbb6/B5I/xs
         7gBRl72wFno2YrQrL96f/DR0HlZKK+dq7ntb2sy3uzRgDl8/D/F02qgCZOZf2P5wGuEX
         GWzQ==
X-Gm-Message-State: AOAM530cQVDjx44YYKZ/pfJz2u+D5LOOanCorqjI1HCjywp1a7Fem76w
        HeWdx0VmglVnQ+GblIAftaL0pkeKyCFjJSbl3ia9i7HcYTg8X+rZpBNLzmRBRqwybRI3F9SxOO+
        MpIdSiGY5PuTx
X-Received: by 2002:a7b:ce04:: with SMTP id m4mr8106795wmc.1.1596022129931;
        Wed, 29 Jul 2020 04:28:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZvgnBRnonp6o9AsWUWxKGzzu2XlLjhGEgh0vj0YKqRBTQggJO98+P6VhHPzbp4gCHeHsQag==
X-Received: by 2002:a7b:ce04:: with SMTP id m4mr8106739wmc.1.1596022129417;
        Wed, 29 Jul 2020 04:28:49 -0700 (PDT)
Received: from pop-os ([2001:470:1f1d:1ea:4fde:6f63:1f5a:12b1])
        by smtp.gmail.com with ESMTPSA id c194sm4994688wme.8.2020.07.29.04.28.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 04:28:48 -0700 (PDT)
Message-ID: <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, devel@ovirt.org
Date:   Wed, 29 Jul 2020 12:28:46 +0100
In-Reply-To: <20200729080503.GB28676@joy-OptiPlex-7040>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
         <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
         <20200716083230.GA25316@joy-OptiPlex-7040>
         <20200717101258.65555978@x1.home>
         <20200721005113.GA10502@joy-OptiPlex-7040>
         <20200727072440.GA28676@joy-OptiPlex-7040>
         <20200727162321.7097070e@x1.home>
         <20200729080503.GB28676@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-07-29 at 16:05 +0800, Yan Zhao wrote:
> On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> > On Mon, 27 Jul 2020 15:24:40 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > > > As you indicate, the vendor driver is responsible for checking version
> > > > > information embedded within the migration stream.  Therefore a
> > > > > migration should fail early if the devices are incompatible.  Is it  
> > > > 
> > > > but as I know, currently in VFIO migration protocol, we have no way to
> > > > get vendor specific compatibility checking string in migration setup stage
> > > > (i.e. .save_setup stage) before the device is set to _SAVING state.
> > > > In this way, for devices who does not save device data in precopy stage,
> > > > the migration compatibility checking is as late as in stop-and-copy
> > > > stage, which is too late.
> > > > do you think we need to add the getting/checking of vendor specific
> > > > compatibility string early in save_setup stage?
> > > >  
> > > 
> > > hi Alex,
> > > after an offline discussion with Kevin, I realized that it may not be a
> > > problem if migration compatibility check in vendor driver occurs late in
> > > stop-and-copy phase for some devices, because if we report device
> > > compatibility attributes clearly in an interface, the chances for
> > > libvirt/openstack to make a wrong decision is little.
> > 
> > I think it would be wise for a vendor driver to implement a pre-copy
> > phase, even if only to send version information and verify it at the
> > target.  Deciding you have no device state to send during pre-copy does
> > not mean your vendor driver needs to opt-out of the pre-copy phase
> > entirely.  Please also note that pre-copy is at the user's discretion,
> > we've defined that we can enter stop-and-copy at any point, including
> > without a pre-copy phase, so I would recommend that vendor drivers
> > validate compatibility at the start of both the pre-copy and the
> > stop-and-copy phases.
> > 
> 
> ok. got it!
> 
> > > so, do you think we are now arriving at an agreement that we'll give up
> > > the read-and-test scheme and start to defining one interface (perhaps in
> > > json format), from which libvirt/openstack is able to parse and find out
> > > compatibility list of a source mdev/physical device?
> > 
> > Based on the feedback we've received, the previously proposed interface
> > is not viable.  I think there's agreement that the user needs to be
> > able to parse and interpret the version information.  Using json seems
> > viable, but I don't know if it's the best option.  Is there any
> > precedent of markup strings returned via sysfs we could follow?
> 
> I found some examples of using formatted string under /sys, mostly under
> tracing. maybe we can do a similar implementation.
> 
> #cat /sys/kernel/debug/tracing/events/kvm/kvm_mmio/format
> 
> name: kvm_mmio
> ID: 32
> format:
>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
> 
>         field:u32 type; offset:8;       size:4; signed:0;
>         field:u32 len;  offset:12;      size:4; signed:0;
>         field:u64 gpa;  offset:16;      size:8; signed:0;
>         field:u64 val;  offset:24;      size:8; signed:0;
> 
> print fmt: "mmio %s len %u gpa 0x%llx val 0x%llx", __print_symbolic(REC->type, { 0, "unsatisfied-read" }, { 1, "read"
> }, { 2, "write" }), REC->len, REC->gpa, REC->val
> 
this is not json fromat and its not supper frendly to parse.
> 
> #cat /sys/devices/pci0000:00/0000:00:02.0/uevent
> DRIVER=vfio-pci
> PCI_CLASS=30000
> PCI_ID=8086:591D
> PCI_SUBSYS_ID=8086:2212
> PCI_SLOT_NAME=0000:00:02.0
> MODALIAS=pci:v00008086d0000591Dsv00008086sd00002212bc03sc00i00
> 
this is ini format or conf formant 
this is pretty simple to parse whichi would be fine.
that said you could also have a version or capablitiy directory with a file
for each key and a singel value.

i would prefer to only have to do one read personally the list the files in
directory and then read tehm all ot build the datastucture myself but that is
doable though the simple ini format use d for uevent seams the best of 3 options
provided above.
> > 
> > Your idea of having both a "self" object and an array of "compatible"
> > objects is perhaps something we can build on, but we must not assume
> > PCI devices at the root level of the object.  Providing both the
> > mdev-type and the driver is a bit redundant, since the former includes
> > the latter.  We can't have vendor specific versioning schemes though,
> > ie. gvt-version. We need to agree on a common scheme and decide which
> > fields the version is relative to, ex. just the mdev type?
> 
> what about making all comparing fields vendor specific?
> userspace like openstack only needs to parse and compare if target
> device is within source compatible list without understanding the meaning
> of each field.
that kind of defeats the reason for having them be be parsable.
the reason openstack want to be able to understand the capablitys is so
we can staticaly declare the capablit of devices ahead of time on so our schduler
can select host based on that. is the keys and data are opaquce to userspace
becaue they are just random vendor sepecific blobs we cant do that.
> 
> > I had also proposed fields that provide information to create a
> > compatible type, for example to create a type_x2 device from a type_x1
> > mdev type, they need to know to apply an aggregation attribute.  If we
> > need to explicitly list every aggregation value and the resulting type,
> > I think we run aground of what aggregation was trying to avoid anyway,
> > so we might need to pick a language that defines variable substitution
> > or some kind of tagging.  For example if we could define ${aggr} as an
> > integer within a specified range, then we might be able to define a type
> > relative to that value (type_x${aggr}) which requires an aggregation
> > attribute using the same value.  I dunno, just spit balling.  Thanks,
> 
> what about a migration_compatible attribute under device node like
> below?
rather then listing comaptiable devices it would be better if you could declaritivly 
list the feature supported and we could compare those along with a simple semver version string.
> 
> #cat /sys/bus/pci/devices/0000\:00\:02.0/UUID1/migration_compatible
> SELF:
> 	device_type=pci
> 	device_id=8086591d
> 	mdev_type=i915-GVTg_V5_2
> 	aggregator=1
> 	pv_mode="none+ppgtt+context"
> 	interface_version=3
> COMPATIBLE:
> 	device_type=pci
> 	device_id=8086591d
> 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
this mixed notation will be hard to parse so i would avoid that.
> 	aggregator={val1}/2
> 	pv_mode={val2:string:"none+ppgtt","none+context","none+ppgtt+context"}
>  
> 	interface_version={val3:int:2,3}
> COMPATIBLE:
> 	device_type=pci
> 	device_id=8086591d
> 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> 	aggregator={val1}/2
> 	pv_mode=""  #"" meaning empty, could be absent in a compatible device
> 	interface_version=1
if you presented this information the only way i could see to use it would be to
extract the mdev_type name and interface_vertion  and build a database table as follows

source_mdev_type | source_version | target_mdev_type | target_version
i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | {val3:int:2,3}
i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | 1

this would either reuiqre use to use a post placment sechudler filter to itrospec this data base
or thansform the target_mdev_type and target_version colum data into CUSTOM_* traits we apply to
our placment resouce providers and we would have to prefrom multiple reuqest for each posible compatiable
alternitive.  if the vm has muplite mdevs this is combinatorially problmenatic as it is 1 query for each
device * the number of possible compatible devices for that device.

in other word if this is just opaque data we cant ever represent it efficently in our placment service and
have to fall back to an explisive post placment schdluer filter base on the db table approch.

this also ignore the fact that at present the mdev_type cannot change druing a migration so the compatiable
devicve with a different mdev type would not be considerd accpetable choice in openstack. they way you select a host
with a specific vgpu mdev type today is to apply a custome trait which is CUSTOM_<medev_type_goes_here> to the vGPU
resouce provider and then in the flavor you request 1 allcoaton of vGPU and require the CUSTOM_<medev_type_goes_here>
trait. so going form i915-GVTg_V5_2 to i915-GVTg_V5_{val1:int:1,2,4,8} would not currently be compatiable with that
workflow.


> #cat /sys/bus/pci/dei915-GVTg_V5_{val1:int:1,2,4,8}vices/0000\:00\:i915-
> GVTg_V5_{val1:int:1,2,4,8}2.0/UUID2/migration_compatible
> SELF:
> 	device_type=pci
> 	device_id=8086591d
> 	mdev_type=i915-GVTg_V5_4
> 	aggregator=2
> 	interface_version=1
> COMPATIBLE: 
> 	device_type=pci
> 	device_id=8086591d
> 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> 	aggregator={val1}/2
> 	interface_version=1
by the way this is closer to yaml format then it is to json but it does not align with any exsiting
format i know of so that just make the representation needless hard to consume
if we are going to use a markup lanag let use a standard one like yaml json or toml and not invent a new one.
> 
> Notes:
> - A COMPATIBLE object is a line starting with COMPATIBLE.
>   It specifies a list of compatible devices that are allowed to migrate
>   in.
>   The reason to allow multiple COMPATIBLE objects is that when it
>   is hard to express a complex compatible logic in one COMPATIBLE
>   object, a simple enumeration is still a fallback.
>   in the above example, device UUID2 is in the compatible list of
>   device UUID1, but device UUID1 is not in the compatible list of device
>   UUID2, so device UUID2 is able to migrate to device UUID1, but device
>   UUID1 is not able to migrate to device UUID2.
> 
> - fields under each object are of "and" relationship to each other,  meaning
>   all fields of SELF object of a target device must be equal to corresponding
>   fields of a COMPATIBLE object of source device, otherwise it is regarded as not
>   compatible.
> 
> - each field, however, is able to specify multiple allowed values, using
>   variables as explained below.
> 
> - variables are represented with {}, the first appearance of one variable
>   specifies its type and allowed list. e.g.
>   {val1:int:1,2,4,8} represents var1 whose type is integer and allowed
>   values are 1, 2, 4, 8.
> 
> - vendors are able to specify which fields are within the comparing list
>   and which fields are not. e.g. for physical VF migration, it may not
>   choose mdev_type as a comparing field, and maybe use driver name instead.
this format might be useful to vendors but from a orcestrator perspecive i dont think this has
value to us likely we would not use this api if it was added as it does not help us with schduling.
ideally instead fo declaring which other mdev types a device is compatiable with (which could presumably change over
time as new device and firmwares are released) i would prefer to see a declaritive non vendor specific api that declares
the feature set provided by each mdev_type from which we can infer comaptiablity similar to cpu feature flags.
for devices fo the same mdev_type name addtionally a declaritive version sting could also be used if required for
addtional compatiablity checks.
>  
> 
> Thanks
> Yan
> 
> 

