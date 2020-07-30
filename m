Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2382332C9
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 15:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgG3NOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:14:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60739 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgG3NOs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 09:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596114884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2fnkCH5A5yRuvfKVwetPp6EAc66m24tZuofFPcs1Ie8=;
        b=UrROuIQIlxgDTcy4tr/g9MvkTiJy4Zn1jhzeFMKZFwWh1F46taWnkpqUodMG4ilHbH/1i0
        UWj/K3exxt3quk7nZcoqywzzyQy6BoMspN3Al2nteq8d6QrrQJD3//hBLEfmx/rdDA07DF
        viXiY5JzbD5aL+Eb+HtlJta489FjcIA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160--HB63nVLPEmfPbRx-2b1zw-1; Thu, 30 Jul 2020 09:14:41 -0400
X-MC-Unique: -HB63nVLPEmfPbRx-2b1zw-1
Received: by mail-wr1-f70.google.com with SMTP id t3so6896316wrr.5
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 06:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2fnkCH5A5yRuvfKVwetPp6EAc66m24tZuofFPcs1Ie8=;
        b=ZS+X/grReUICnIEFMsOmCSe0lcUv0FCsfoGuGoG3S7evXdR0TYHRvVfPHlr9kPjw5A
         K7q+3v4zl+3hLaYaOkM2oj6WVM67UUtkhaOtC1Milad4BqCfBc1Onbis+r/JDTt9yYIF
         pTVKIkc6tGKYOBhq9SUip5ICrSfsXBzQxj8Vla8jp75GIoU8cPgKekbwYTrFsldjdvqK
         PabHb0m5uQ/ZQltrxhiQt89wpPjww5hX49pOhvirbZ0dJYI3/PCp7058mG+O3JdG/EYl
         vMUwx8P0ASv23007+6g54mas61dRLGUXDoGCRKgPfgx5EbNTvs/lNGyfSYy65vhO/uT6
         PIAA==
X-Gm-Message-State: AOAM5307ZZ+v8cc9GX1K2iGoEdZwyaLllZFac/os0EGMJ82lhO5Pmjtb
        q4Kk3OPiu5RnZEJ5q/5Sj0PH68fp3y4pRoZyNgZs4fOhwKKToxAI8eGiTMWkfWNlZfIsjpl2bv5
        4r82BrxnN/ugT
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr6942405wml.133.1596114879920;
        Thu, 30 Jul 2020 06:14:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBPI9d2ddmEirlDC+WBglNCXl8LeEZPjCvC9K1UUHkPRt+i0L9WpZe6Y6kiq/XHobTczjdMw==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr6942348wml.133.1596114879246;
        Thu, 30 Jul 2020 06:14:39 -0700 (PDT)
Received: from pop-os ([2001:470:1f1d:1ea:4fde:6f63:1f5a:12b1])
        by smtp.gmail.com with ESMTPSA id m126sm9113857wmf.3.2020.07.30.06.14.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 06:14:38 -0700 (PDT)
Message-ID: <a3166cd4fd4678ff1b5bb31bdf7d6c0384544e75.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Jason Wang <jasowang@redhat.com>,
        qemu-devel@nongnu.org, kwankhede@nvidia.com, eauger@redhat.com,
        xin-ran.wang@intel.com, corbet@lwn.net,
        openstack-discuss@lists.openstack.org, shaohe.feng@intel.com,
        kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, devel@ovirt.org
Date:   Thu, 30 Jul 2020 14:14:35 +0100
In-Reply-To: <20200730015639.GA32327@joy-OptiPlex-7040>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
         <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
         <20200716083230.GA25316@joy-OptiPlex-7040>
         <20200717101258.65555978@x1.home>
         <20200721005113.GA10502@joy-OptiPlex-7040>
         <20200727072440.GA28676@joy-OptiPlex-7040>
         <20200727162321.7097070e@x1.home>
         <20200729080503.GB28676@joy-OptiPlex-7040>
         <e8a973ea0bb2bc3eb15649fb1c44599ae3509e84.camel@redhat.com>
         <20200730015639.GA32327@joy-OptiPlex-7040>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-07-30 at 09:56 +0800, Yan Zhao wrote:
> On Wed, Jul 29, 2020 at 12:28:46PM +0100, Sean Mooney wrote:
> > On Wed, 2020-07-29 at 16:05 +0800, Yan Zhao wrote:
> > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> > > > On Mon, 27 Jul 2020 15:24:40 +0800
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > 
> > > > > > > As you indicate, the vendor driver is responsible for checking version
> > > > > > > information embedded within the migration stream.  Therefore a
> > > > > > > migration should fail early if the devices are incompatible.  Is it  
> > > > > > 
> > > > > > but as I know, currently in VFIO migration protocol, we have no way to
> > > > > > get vendor specific compatibility checking string in migration setup stage
> > > > > > (i.e. .save_setup stage) before the device is set to _SAVING state.
> > > > > > In this way, for devices who does not save device data in precopy stage,
> > > > > > the migration compatibility checking is as late as in stop-and-copy
> > > > > > stage, which is too late.
> > > > > > do you think we need to add the getting/checking of vendor specific
> > > > > > compatibility string early in save_setup stage?
> > > > > >  
> > > > > 
> > > > > hi Alex,
> > > > > after an offline discussion with Kevin, I realized that it may not be a
> > > > > problem if migration compatibility check in vendor driver occurs late in
> > > > > stop-and-copy phase for some devices, because if we report device
> > > > > compatibility attributes clearly in an interface, the chances for
> > > > > libvirt/openstack to make a wrong decision is little.
> > > > 
> > > > I think it would be wise for a vendor driver to implement a pre-copy
> > > > phase, even if only to send version information and verify it at the
> > > > target.  Deciding you have no device state to send during pre-copy does
> > > > not mean your vendor driver needs to opt-out of the pre-copy phase
> > > > entirely.  Please also note that pre-copy is at the user's discretion,
> > > > we've defined that we can enter stop-and-copy at any point, including
> > > > without a pre-copy phase, so I would recommend that vendor drivers
> > > > validate compatibility at the start of both the pre-copy and the
> > > > stop-and-copy phases.
> > > > 
> > > 
> > > ok. got it!
> > > 
> > > > > so, do you think we are now arriving at an agreement that we'll give up
> > > > > the read-and-test scheme and start to defining one interface (perhaps in
> > > > > json format), from which libvirt/openstack is able to parse and find out
> > > > > compatibility list of a source mdev/physical device?
> > > > 
> > > > Based on the feedback we've received, the previously proposed interface
> > > > is not viable.  I think there's agreement that the user needs to be
> > > > able to parse and interpret the version information.  Using json seems
> > > > viable, but I don't know if it's the best option.  Is there any
> > > > precedent of markup strings returned via sysfs we could follow?
> > > 
> > > I found some examples of using formatted string under /sys, mostly under
> > > tracing. maybe we can do a similar implementation.
> > > 
> > > #cat /sys/kernel/debug/tracing/events/kvm/kvm_mmio/format
> > > 
> > > name: kvm_mmio
> > > ID: 32
> > > format:
> > >         field:unsigned short common_type;       offset:0;       size:2; signed:0;
> > >         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
> > >         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
> > >         field:int common_pid;   offset:4;       size:4; signed:1;
> > > 
> > >         field:u32 type; offset:8;       size:4; signed:0;
> > >         field:u32 len;  offset:12;      size:4; signed:0;
> > >         field:u64 gpa;  offset:16;      size:8; signed:0;
> > >         field:u64 val;  offset:24;      size:8; signed:0;
> > > 
> > > print fmt: "mmio %s len %u gpa 0x%llx val 0x%llx", __print_symbolic(REC->type, { 0, "unsatisfied-read" }, { 1,
> > > "read"
> > > }, { 2, "write" }), REC->len, REC->gpa, REC->val
> > > 
> > 
> > this is not json fromat and its not supper frendly to parse.
> 
> yes, it's just an example. It's exported to be used by userspace perf &
> trace_cmd.
> 
> > > 
> > > #cat /sys/devices/pci0000:00/0000:00:02.0/uevent
> > > DRIVER=vfio-pci
> > > PCI_CLASS=30000
> > > PCI_ID=8086:591D
> > > PCI_SUBSYS_ID=8086:2212
> > > PCI_SLOT_NAME=0000:00:02.0
> > > MODALIAS=pci:v00008086d0000591Dsv00008086sd00002212bc03sc00i00
> > > 
> > 
> > this is ini format or conf formant 
> > this is pretty simple to parse whichi would be fine.
> > that said you could also have a version or capablitiy directory with a file
> > for each key and a singel value.
> > 
> 
> if this is easy for openstack, maybe we can organize the data like below way?
>  
>  |- [device]
>     |- migration
>         |-self
> 	|-compatible1
> 	|-compatible2
> 
> e.g. 
> #cat /sys/bus/pci/devices/0000:00:02.0/UUID1/migration/self
>  	filed1=xxx
>  	filed2=xxx
>  	filed3=xxx
>  	filed3=xxx
> #cat /sys/bus/pci/devices/0000:00:02.0/UUID1/migration/compatible
>  	filed1=xxx
>  	filed2=xxx
>  	filed3=xxx
>  	filed3=xxx

ya this would work.
nova specificly the libvirt driver trys to avoid reading sysfs directly if libvirt
has an api that provides the infomation but where it does not it can read it and that
structure  woudl be easy for use to consume.

libs like os-vif which cant depend on libvirt use it a little more
for example to look up a PF form one of its VFs
https://github.com/openstack/os-vif/blob/master/vif_plug_ovs/linux_net.py#L384-L391

we are carefult not to over use sysfs as it can change over time based on kernel version in somecase
but its is genernal seen a preferable to calling an every growing list of comnnadline clients to retrive
the same info.
> 
> or in a flat layer
>  |- [device]
>     |- migration-self-traits
>     |- migration-compatible-traits
> 
> I'm not sure whether json format in a single file is better, as I didn't
> find any precedent.
i think i prefer the nested directories to this flatend styple but there isnent really any significant increase
in complexity form a bash scripting point of view if i was manually debuging something the multi layer reprentation is
slight simpler to work with but not enough so that it really matters.
> 
> > i would prefer to only have to do one read personally the list the files in
> > directory and then read tehm all ot build the datastucture myself but that is
> > doable though the simple ini format use d for uevent seams the best of 3 options
> > provided above.
> > > > 
> > > > Your idea of having both a "self" object and an array of "compatible"
> > > > objects is perhaps something we can build on, but we must not assume
> > > > PCI devices at the root level of the object.  Providing both the
> > > > mdev-type and the driver is a bit redundant, since the former includes
> > > > the latter.  We can't have vendor specific versioning schemes though,
> > > > ie. gvt-version. We need to agree on a common scheme and decide which
> > > > fields the version is relative to, ex. just the mdev type?
> > > 
> > > what about making all comparing fields vendor specific?
> > > userspace like openstack only needs to parse and compare if target
> > > device is within source compatible list without understanding the meaning
> > > of each field.
> > 
> > that kind of defeats the reason for having them be be parsable.
> > the reason openstack want to be able to understand the capablitys is so
> > we can staticaly declare the capablit of devices ahead of time on so our schduler
> > can select host based on that. is the keys and data are opaquce to userspace
> > becaue they are just random vendor sepecific blobs we cant do that.
> 
> I heard that cyborg can parse the kernel interface and generate several
> traits without understanding the meaning of each trait. Then it reports
> those traits to placement for scheduling.
if it is doing a raw passthough like that 1 it will break users if a vendor every
removes a trait or renames it as part of a firwmware update and second it will require them to use
CUSTOM_ triant in stead of standardised traits. in other words is an interoperatbltiy problem between clouds.

at present cyborg does not support mdevs
there is a proposal for adding a generic mdev driver for generic stateless devices.
it could report arbitary capablity to placment although its does not exsit yet so its kind of premature ot point
to it as an example
> 
> but I agree if mdev creation is involved, those traits need to match
> to mdev attributes and mdev_type.
currently the only use of mdevs in openstack is for vGPU with nvidia devices.
in theory intel gpus can work with the existing code but it has not been tested.
> 
> could you explain a little how you plan to create a target mdev device?
> is it dynamically created during searching of compatible mdevs or just statically
> created before migration?
the mdevs are currently created dynamically when a vm is created based on a set of pre defiend
flavor which have static metadata in the form of flavor extra_specs.
thost extra specs request a vgpu by spcifying resouces:VGPU=1 in the extra specs.
e.g. openstack flavor set vgpu_1 --property "resources:VGPU=1"
if you want a specific vgpu type then you must request a custom trait in addtion to the resouce class
openstack --os-placement-api-version 1.6 trait create CUSTOM_NVIDIA_11
openstack flavor set --property trait:CUSTOM_NVIDIA_11=required vgpu_1

when configuring the host for vGPUs you list the enabled vgpu mdev types and the device that can use them

   [devices]
   enabled_vgpu_types = nvidia-35, nvidia-36

   [vgpu_nvidia-35]
   device_addresses = 0000:84:00.0,0000:85:00.0

   [vgpu_nvidia-36]
   device_addresses = 0000:86:00.0

each device that is listed will be created as a resouce provider in the plamcent service
so to associate the custom trait with the physical gpu and mdev type you manually tag the RP withthe trait

openstack --os-placement-api-version 1.6 resource provider trait set \
    --trait CUSTOM_NVIDIA_11 e2f8607b-0683-4141-a8af-f5e20682e28c

this decouple the name of the CUSTOM_ trait form the underliying mdev type
so the operator is free to use small|medium|large or bronze|silver|gold if they want to or they coudld chose to use the
mdev_type name if they want too.

currently we dont support live migration with vGPU because the required code has not been upstream to qemu/kvm
yet? i belive it just missed the kernel 5.7 merge window? i know its in flight but have not been following too closely

if you do a cold/offline migration currenlty and you had multiple mdev types then technical the mdev type could change.
we had planned for operators to ensure that what ever trait they choose would map to the same mdev type on all hosts.
if we were to supprot live migration in the future without this new api we are disccusing we woudl make the trait to
mdev type relationship required to be 1:1 for live migration.

we have talked auto creating traits for gvpus which would be in the form of CUSTOM_<mdev type> but shyed away from it
as we are worried vendors will break us and our user by changing mdev_types in frimware updates or driver updates.
we kind of need to rely on them being stable but we are hesitent to encode them in our public api in this manner.

> > > 
> > > > I had also proposed fields that provide information to create a
> > > > compatible type, for example to create a type_x2 device from a type_x1
> > > > mdev type, they need to know to apply an aggregation attribute.
honestly form an opesntack point of view i woudl prefer if each consumable resouce was
exposed as a different mdev_type and we could just create multiple mdevs and attach them to
a vm. that would allow use to do the aggreatation our selves. parsing mdev atributes
and dynamicaly creating 1 mdev type from aggregation of other requires detailed knoladge of the
vendor device.

the cyborg(acclerator managment) project might be open to this becuase they have plugable vendor specific and could
write a driver that only work with a sepecifc sku of a vendoer deivce or a device familay e.g. a qat
driver that could have the require knoladge to do the compostion.

that type of lowlevel device management is out of scope of the nova (compute) project
we woudl be far more likely to require operator to staticly parttion the device up front into mdevs
and pass us a list of them which we could then provend to vms.

we more or less already do this for vGPU today as the phsycal gpus need to be declared to support exactly 1 mdev_type
each and the same is true for persistent memroy. you need to pre create the persistent memeroy namespaces and then
provide the list of namespaces to nova.

so aggregation is something i suspect taht will only be supported in cyborg if it eventually supprot mdevs.
it has not been requested or assesed for nova yet but it seams unlikely.
in a migration work flow i would expect the nova conduction or source host to make an rpc call to the destination
host in pre live migration to create the mdev. this is before the call to libvirt to migrate the vm and before it would
do any validation but after schduleing. so ideally we shoudl know at this point that the destination host has a
comaptiable device.
> > > >   If we
> > > > need to explicitly list every aggregation value and the resulting type,
> > > > I think we run aground of what aggregation was trying to avoid anyway,
> > > > so we might need to pick a language that defines variable substitution
> > > > or some kind of tagging.  For example if we could define ${aggr} as an
> > > > integer within a specified range, then we might be able to define a type
> > > > relative to that value (type_x${aggr}) which requires an aggregation
> > > > attribute using the same value.  I dunno, just spit balling.  Thanks,
> > > 
> > > what about a migration_compatible attribute under device node like
> > > below?
> > 
> > rather then listing comaptiable devices it would be better if you could declaritivly 
> > list the feature supported and we could compare those along with a simple semver version string.
> 
> I think below is already in a way of listing feature supported.
> The reason I also want to declare compatible lists of features is that
> sometimes it's not a simple 1:1 matching of source list and target list.
> as I demonstrated below,
> source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatible to
> target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
>                (mdev_type i915-GVTg_V5_8 + aggregator 4)
> 
> and aggragator may be just one of such examples that 1:1 matching is not
> fit.
so far i am not conviced that aggragators are a good concept to model at this level.
is there some document that explains why they are need and we cant jsut have multipel
mdev_type per consumable resouce and attach multiple mdevs to a singel vm.

i suspect this is due to limitation in compoasblity in hardware such as nvidia multi
instance gpu tech. however (mdev_type i915-GVTg_V5_8 + aggregator 4) seams unfriendly to work with
form an orchestrato perspective.

on of our current complaint with the mdev api today is that depending on the device consoming
and instance of 1 mdev type may impact the availablity of other or change the avaiablity capastiyt of others.
that make it very hard to reason about capastiy avaiablity and aggregator sound like it will
make that problem worse not better.

> so I guess it's best not to leave the hard decision to openstack.
> 
> Thanks
> Yan
> > > 
> > > #cat /sys/bus/pci/devices/0000\:00\:02.0/UUID1/migration_compatible
> > > SELF:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_2
> > > 	aggregator=1
> > > 	pv_mode="none+ppgtt+context"
> > > 	interface_version=3
> > > COMPATIBLE:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > 
> > this mixed notation will be hard to parse so i would avoid that.
> > > 	aggregator={val1}/2
> > > 	pv_mode={val2:string:"none+ppgtt","none+context","none+ppgtt+context"}
> > >  
> > > 	interface_version={val3:int:2,3}
> > > COMPATIBLE:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > > 	aggregator={val1}/2
> > > 	pv_mode=""  #"" meaning empty, could be absent in a compatible device
> > > 	interface_version=1
> > 
> > if you presented this information the only way i could see to use it would be to
> > extract the mdev_type name and interface_vertion  and build a database table as follows
> > 
> > source_mdev_type | source_version | target_mdev_type | target_version
> > i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | {val3:int:2,3}
> > i915-GVTg_V5_2 | 3 | 915-GVTg_V5_{val1:int:1,2,4,8} | 1
> > 
> > this would either reuiqre use to use a post placment sechudler filter to itrospec this data base
> > or thansform the target_mdev_type and target_version colum data into CUSTOM_* traits we apply to
> > our placment resouce providers and we would have to prefrom multiple reuqest for each posible compatiable
> > alternitive.  if the vm has muplite mdevs this is combinatorially problmenatic as it is 1 query for each
> > device * the number of possible compatible devices for that device.
> > 
> > in other word if this is just opaque data we cant ever represent it efficently in our placment service and
> > have to fall back to an explisive post placment schdluer filter base on the db table approch.
> > 
> > this also ignore the fact that at present the mdev_type cannot change druing a migration so the compatiable
> > devicve with a different mdev type would not be considerd accpetable choice in openstack. they way you select a host
> > with a specific vgpu mdev type today is to apply a custome trait which is CUSTOM_<medev_type_goes_here> to the vGPU
> > resouce provider and then in the flavor you request 1 allcoaton of vGPU and require the
> > CUSTOM_<medev_type_goes_here>
> > trait. so going form i915-GVTg_V5_2 to i915-GVTg_V5_{val1:int:1,2,4,8} would not currently be compatiable with that
> > workflow.
> > 
> > 
> > > #cat /sys/bus/pci/dei915-GVTg_V5_{val1:int:1,2,4,8}vices/0000\:00\:i915-
> > > GVTg_V5_{val1:int:1,2,4,8}2.0/UUID2/migration_compatible
> > > SELF:
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_4
> > > 	aggregator=2
> > > 	interface_version=1
> > > COMPATIBLE: 
> > > 	device_type=pci
> > > 	device_id=8086591d
> > > 	mdev_type=i915-GVTg_V5_{val1:int:1,2,4,8}
> > > 	aggregator={val1}/2
> > > 	interface_version=1
> > 
> > by the way this is closer to yaml format then it is to json but it does not align with any exsiting
> > format i know of so that just make the representation needless hard to consume
> > if we are going to use a markup lanag let use a standard one like yaml json or toml and not invent a new one.
> > > 
> > > Notes:
> > > - A COMPATIBLE object is a line starting with COMPATIBLE.
> > >   It specifies a list of compatible devices that are allowed to migrate
> > >   in.
> > >   The reason to allow multiple COMPATIBLE objects is that when it
> > >   is hard to express a complex compatible logic in one COMPATIBLE
> > >   object, a simple enumeration is still a fallback.
> > >   in the above example, device UUID2 is in the compatible list of
> > >   device UUID1, but device UUID1 is not in the compatible list of device
> > >   UUID2, so device UUID2 is able to migrate to device UUID1, but device
> > >   UUID1 is not able to migrate to device UUID2.
> > > 
> > > - fields under each object are of "and" relationship to each other,  meaning
> > >   all fields of SELF object of a target device must be equal to corresponding
> > >   fields of a COMPATIBLE object of source device, otherwise it is regarded as not
> > >   compatible.
> > > 
> > > - each field, however, is able to specify multiple allowed values, using
> > >   variables as explained below.
> > > 
> > > - variables are represented with {}, the first appearance of one variable
> > >   specifies its type and allowed list. e.g.
> > >   {val1:int:1,2,4,8} represents var1 whose type is integer and allowed
> > >   values are 1, 2, 4, 8.
> > > 
> > > - vendors are able to specify which fields are within the comparing list
> > >   and which fields are not. e.g. for physical VF migration, it may not
> > >   choose mdev_type as a comparing field, and maybe use driver name instead.
> > 
> > this format might be useful to vendors but from a orcestrator perspecive i dont think this has
> > value to us likely we would not use this api if it was added as it does not help us with schduling.
> > ideally instead fo declaring which other mdev types a device is compatiable with (which could presumably change over
> > time as new device and firmwares are released) i would prefer to see a declaritive non vendor specific api that
> > declares
> > the feature set provided by each mdev_type from which we can infer comaptiablity similar to cpu feature flags.
> > for devices fo the same mdev_type name addtionally a declaritive version sting could also be used if required for
> > addtional compatiablity checks.
> > >  
> > > 
> > > Thanks
> > > Yan
> > > 
> > > 
> 
> 

