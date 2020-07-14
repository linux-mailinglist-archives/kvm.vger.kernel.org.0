Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6921FFD2
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 23:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGNVPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 17:15:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23323 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgGNVPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 17:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594761341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2yUeCVBNsfxz7e6hyfh6Da3oh4d7VUvdlsBl1XdrAE=;
        b=RGSkQqDmz2TJCII72I9CfbGYZJp02spWWo4HCBJMOPw42UszpIKMc1WEtEpUsBc4VO7GSs
        +0hNZuc3ASsCclwoLvg5DeU/qn9OPQA92w9HUhnc7l4fLqpkD5ydkIcYuMwQe4vTW9xAo5
        xJx/ujrhrm4KOIiN/oOORJUfk/MWNUA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-rmKotVvNOdGAnecgTUkVcg-1; Tue, 14 Jul 2020 17:15:37 -0400
X-MC-Unique: rmKotVvNOdGAnecgTUkVcg-1
Received: by mail-wm1-f70.google.com with SMTP id v11so27812wmb.1
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 14:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2yUeCVBNsfxz7e6hyfh6Da3oh4d7VUvdlsBl1XdrAE=;
        b=hS4T68nuZGC+4BW7lkRdaStNM3UF0rgcGNs1S+3KVjoD39mlh3Ew1smlihi9D/7wUV
         Gaeuf0lEa6jM9mWikslAoPleCDLRVxMtuKv01cJJ09DoTDY6vUxtznb5J1qmkNAP17v9
         oC6zsk+DZj9aXtf4UHEadXdmWN5Y5cBanM6xKH8tHwmlU71r77DCdan6U6rWZ5tB1gpx
         G9JUhB8GezwD9iFDgZ9WEZuJaBzKEL7U19YiX9h6on6Y/Hw9UWDdzh2nkXWY9Mnmw6IM
         CPICnN0h2ZT1F6p1o/1YrWfXleBZsTMwu0XRXrTsvZI9bPKYKv9XhjKieST4mIpUfDbt
         RUsw==
X-Gm-Message-State: AOAM530Fi4Pkj3aSk2TBE0t8PjavNqZvof96T3dHeCtOTJ7UWLzZ/5qT
        yqvu/1jGPM0ommypw+Yf/bnNhtqB6khGrb5egtSuaWp+aMmnm3mT005xiabdbpVgKDcTkWc37GA
        GPEjJ7AT6PIog
X-Received: by 2002:a7b:c259:: with SMTP id b25mr5612109wmj.107.1594761336030;
        Tue, 14 Jul 2020 14:15:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmmveBRhbrDsLjXFLsE9r4jBFfkufRjmQ42Q0iOcp97kp81seqQ1oTs2zclhWmQWnZ96pqPA==
X-Received: by 2002:a7b:c259:: with SMTP id b25mr5612060wmj.107.1594761335391;
        Tue, 14 Jul 2020 14:15:35 -0700 (PDT)
Received: from pop-os ([51.37.88.107])
        by smtp.gmail.com with ESMTPSA id z8sm42307wmg.39.2020.07.14.14.15.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 14:15:34 -0700 (PDT)
Message-ID: <8ef6f52dd7e03d19c7d862350f2d1ecf070f1d63.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Daniel Berrange <berrange@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, smooney@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, corbet@lwn.net,
        kwankhede@nvidia.com, dgilbert@redhat.com, eauger@redhat.com,
        jian-feng.ding@intel.com, hejie.xu@intel.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, bao.yumeng@zte.com.cn,
        xin-ran.wang@intel.com, Shaohe Feng <shaohe.feng@intel.com>
Date:   Tue, 14 Jul 2020 22:15:33 +0100
In-Reply-To: <eb705c72cdc8b6b8959b6ebaeeac6069a718d524.camel@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
         <20200714102129.GD25187@redhat.com>
         <febb463fc7494aa20b6f57fef469cce7279d2c9a.camel@redhat.com>
         <20200714110148.0471c03c@x1.home>
         <eb705c72cdc8b6b8959b6ebaeeac6069a718d524.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

resending with full cc list since i had this typed up
i would blame my email provier but my email client does not seam to like long cc lists.
we probably want to continue on  alex's thread to not split the disscusion.
but i have responed inline with some example of  how openstack schdules and what i ment by different mdev_types


On Tue, 2020-07-14 at 20:29 +0100, Sean Mooney wrote:
> On Tue, 2020-07-14 at 11:01 -0600, Alex Williamson wrote:
> > On Tue, 14 Jul 2020 13:33:24 +0100
> > Sean Mooney <smooney@redhat.com> wrote:
> > 
> > > On Tue, 2020-07-14 at 11:21 +0100, Daniel P. Berrangé wrote:
> > > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote:  
> > > > > hi folks,
> > > > > we are defining a device migration compatibility interface that helps upper
> > > > > layer stack like openstack/ovirt/libvirt to check if two devices are
> > > > > live migration compatible.
> > > > > The "devices" here could be MDEVs, physical devices, or hybrid of the two.
> > > > > e.g. we could use it to check whether
> > > > > - a src MDEV can migrate to a target MDEV,  
> > > 
> > > mdev live migration is completely possible to do but i agree with Dan barrange's comments
> > > from the point of view of openstack integration i dont see calling out to a vender sepecific
> > > tool to be an accpetable
> > 
> > As I replied to Dan, I'm hoping Yan was referring more to vendor
> > specific knowledge rather than actual tools.
> > 
> > > solutions for device compatiablity checking. the sys filesystem
> > > that describs the mdevs that can be created shoudl also
> > > contain the relevent infomation such
> > > taht nova could integrate it via libvirt xml representation or directly retrive the
> > > info from
> > > sysfs.
> > > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,  
> > > 
> > > so vf to vf migration is not possible in the general case as there is no standarised
> > > way to transfer teh device state as part of the siorv specs produced by the pci-sig
> > > as such there is not vender neutral way to support sriov live migration. 
> > 
> > We're not talking about a general case, we're talking about physical
> > devices which have vfio wrappers or hooks with device specific
> > knowledge in order to support the vfio migration interface.  The point
> > is that a discussion around vfio device migration cannot be limited to
> > mdev devices.
> 
> ok upstream in  openstack at least we do not plan to support generic livemigration
> for passthough devivces. we cheat with network interfaces since in generaly operating
> systems handel hotplug of a nic somewhat safely so wehre no abstraction layer like
> an mdev is present or a macvtap device we hot unplug the nic before the migration
> and attach a new one after.  for gpus or crypto cards this likely would not be viable
> since you can bond generic hardware devices to hide the removal and readdtion of a generic
> pci device. we were hoping that there would be a convergenca around MDEVs as a way to provide
> that abstraction going forward for generic device or some other new mechanisum in the future.
> > 
> > > > > - a src MDEV can migration to a target VF in SRIOV.  
> > > 
> > > that also makes this unviable
> > > > >   (e.g. SIOV/SRIOV backward compatibility case)
> > > > > 
> > > > > The upper layer stack could use this interface as the last step to check
> > > > > if one device is able to migrate to another device before triggering a real
> > > > > live migration procedure.  
> > > 
> > > well actully that is already too late really. ideally we would want to do this compaiablity
> > > check much sooneer to avoid the migration failing. in an openstack envionment  at least
> > > by the time we invoke libvirt (assuming your using the libvirt driver) to do the migration we have alreaedy
> > > finished schduling the instance to the new host. if if we do the compatiablity check at this point
> > > and it fails then the live migration is aborted and will not be retired. These types of late check lead to a
> > > poor user experince as unless you check the migration detial it basically looks like the migration was ignored
> > > as it start to migrate and then continuge running on the orgininal host.
> > > 
> > > when using generic pci passhotuhg with openstack, the pci alias is intended to reference a single vendor
> > > id/product
> > > id so you will have 1+ alias for each type of device. that allows openstack to schedule based on the availability
> > > of
> > > a
> > > compatibale device because we track inventories of pci devices and can query that when selecting a host.
> > > 
> > > if we were to support mdev live migration in the future we would want to take the same declarative approch.
> > > 1 interospec the capability of the deivce we manage
> > > 2 create inventories of the allocatable devices and there capabilities
> > > 3 schdule the instance to a host based on the device-type/capabilities and claim it atomicly to prevent raceces
> > > 4 have the lower level hyperviors do addtional validation if need prelive migration.
> > > 
> > > this proposal seams to be targeting extending step 4 where as ideally we should focuse on providing the info that
> > > would
> > > be relevant in set 1 preferably in a vendor neutral way vai a kernel interface like /sys.
> > 
> > I think this is reading a whole lot into the phrase "last step".  We
> > want to make the information available for a management engine to
> > consume as needed to make informed decisions regarding likely
> > compatible target devices.
> 
> well openstack as a management engin has 3 stages for schdule and asignment,.
> in respocne to a live migration request the api does minimal valaidation then hand the task off to the conductor
> service
> ot orchestrate. the conductor invokes an rpc to the schduler service which makes a rest call to the plamcent service.
> the placment cervice generate a set of allocation candiate for host based on qunataive and qulaitivly
> queries agains an abstract resouce provider tree model of the hosts.
> currently device pasthough is not modeled in placment so plamcnet is basicaly returning a set of host that have enough
> cpu ram and disk for the instance. in the spacial of  vGPU they technically are modelled in placement but not in a way
> that would gurarentee compatiablity for migration. a generic pci device request is haneled in the second phase of
> schduling called filtering and weighing. in this pahse the nova schuleer apply a series  of filter to the list of host
> returned by plamcnet to assert things like anit afintiy, tenant isolation or in the case of this converation nuam
> affintiy and pci device avaiablity. when we have filtered the posible set of host down to X number we weigh the
> listing
> to select an optimal host and set of alternitive hosts. we then enter the code that this mail suggest modfiying which
> does an rpc call to the destiation host form teh conductor to have it assert compatiablity which internaly calls back
> to
> the sourc host.
> 
> so my point is we have done a lot of work  by the time we call check_can_live_migrate_destination and failing
> at this point is considerd quite a late failure but its still better then failing when qemu actully tries to migrate.
> in general we would prefer to move compatiablity check as early in that workflow as possible but to be fair we dont
> actully check cpu model compatiablity until check_can_live_migrate_destination.
> 
https://github.com/openstack/nova/blob/8988316b8c132c9662dea6cf0345975e87ce7344/nova/virt/libvirt/driver.py#L8325-L8331
> 
> if we needed too we could read the version string on the source and write the version string on the dest at this
> point.
> doing so however would be considerd, inelegant, we have found this does not scale as the first copmpatabilty check.
> for cpu for example there are way to filter hosts by groups sets fo host with the same cpu or filtering on cpu feature
> flags that happen in the placment or filter stage both of which are very early and cheap to do at runtime.
> 
> the "read for version, write for compatibility" workflow could be used as a final safe check if required but
> probing for compatibility via writes is basicaly considered an anti patteren in openstack. we try to always
> assert compatibility by reading avaiable info and asserting requirement over it not testing to see if it works.
> 
> this has come up in the past in the context of virtio feature flag where the idea of spawning an instrance or trying
> to add a virtio port to ovs dpdk that reqested a specific feature flag was rejected as unacceptable from a performance
> and security point of view.
> 
> >  
> > > > > we are not sure if this interface is of value or help to you. please don't
> > > > > hesitate to drop your valuable comments.
> > > > > 
> > > > > 
> > > > > (1) interface definition
> > > > > The interface is defined in below way:
> > > > > 
> > > > >              __    userspace
> > > > >               /\              \
> > > > >              /                 \write
> > > > >             / read              \
> > > > >    ________/__________       ___\|/_____________
> > > > >   | migration_version |     | migration_version |-->check migration
> > > > >   ---------------------     ---------------------   compatibility
> > > > >      device A                    device B
> > > > > 
> > > > > 
> > > > > a device attribute named migration_version is defined under each device's
> > > > > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).  
> > > 
> > > this might be useful as we could tag the inventory with the migration version and only might to
> > > devices with  the same version
> > 
> > Is cross version compatibility something that you'd consider using?
> 
> yes but it would depend on what cross version actully ment.
> 
> the version of an mdev is not something we would want to be exposed to endusers.
> it would be a security risk to do so as the version sting would potentaily allow the untrused user
> to discover if a device has an unpatch vulnerablity. as a result in the context of live migration
> we can only support cross verion compatiabilyt if the device in the guest  does not alter as
> part of the migration and the behavior does not change.
> 
> going form version 1.0 with feature X to verions 1.1 with feature X and Y but only X enabled would
> be fine. going gorm 1.0 to 2.0 where thre is only feature Y would not be ok.
> being abstract makes it a little harder to readabout but i guess i would sumerisei if its
> transparent to the guest for the lifetime of the qemu process then its ok for the backing version to change.
> if a vm is rebooted its also ok fo the vm to pick up feature Y form the 1.1 device although at that point
> it could not be migrated back to the 1.0 host as it now has feature X and Y and 1.0 only has X so that woudl be
> an obserable change if it was drop as a reult of the live migration.
> > 
> > > > > userspace tools read the migration_version as a string from the source device,
> > > > > and write it to the migration_version sysfs attribute in the target device.  
> > > 
> > > this would not be useful as the schduler cannot directlly connect to the compute host
> > > and even if it could it would be extreamly slow to do this for 1000s of hosts and potentally
> > > multiple devices per host.
> > 
> > Seems similar to Dan's requirement, looks like the 'read for version,
> > write for compatibility' test idea isn't really viable.
> 
> its ineffiecnt and we have reject adding such test in the case of virtio-feature flag compatiabilty
> in the past, so its more an option of last resourt if we have no other way to support compatiablity
> checking.
> > 
> > > > > 
> > > > > The userspace should treat ANY of below conditions as two devices not compatible:
> > > > > - any one of the two devices does not have a migration_version attribute
> > > > > - error when reading from migration_version attribute of one device
> > > > > - error when writing migration_version string of one device to
> > > > >   migration_version attribute of the other device
> > > > > 
> > > > > The string read from migration_version attribute is defined by device vendor
> > > > > driver and is completely opaque to the userspace.  
> > > 
> > > opaque vendor specific stings that higher level orchestros have to pass form host
> > > to host and cant reason about are evil, when allowed they prolifroate and
> > > makes any idea of a vendor nutral abstraction and interoperablity between systems
> > > impossible to reason about. that said there is a way to make it opaue but still useful
> > > to userspace. see below
> > > > > for a Intel vGPU, string format can be defined like
> > > > > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggregator count".
> > > > > 
> > > > > for an NVMe VF connecting to a remote storage. it could be
> > > > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > > > 
> > > > > for a QAT VF, it may be
> > > > > "PCI ID" + "driver version" + "supported encryption set".
> > > > > 
> > > > > (to avoid namespace confliction from each vendor, we may prefix a driver name to
> > > > > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)  
> > > 
> > > honestly i would much prefer if the version string was just a semver string.
> > > e.g. {major}.{minor}.{bugfix} 
> > > 
> > > if you do a driver/frimware update and break compatiablity with an older version bump the
> > > major version.
> > > 
> > > if you add optional a feature that does not break backwards compatiablity if you migrate
> > > an older instance to the new host then just bump the minor/feature number.
> > > 
> > > if you have a fix for a bug that does not change the feature set or compatiblity backwards or
> > > forwards then bump the bugfix number
> > > 
> > > then the check is as simple as 
> > > 1.) is the mdev type the same
> > > 2.) is the major verion the same
> > > 3.) am i going form the same version to same version or same version to newer version
> > > 
> > > if all 3 are true we can migrate.
> > > e.g. 
> > > 2.0.1 -> 2.1.1 (ok same major version and migrating from older feature release to newer feature release)
> > > 2.1.1 -> 2.0.1 (not ok same major version and migrating from new feature release to old feature release may be
> > > incompatable)
> > > 2.0.0 -> 3.0.0 (not ok chaning major version)
> > > 2.0.1 -> 2.0.0 (ok same major and minor version, all bugfixs in the same minor release should be compatibly)
> > 
> > What's the value of the bugfix field in this scheme?
> 
> its not require but really its for a non visable chagne form a feature standpoint.
> a rather contrived example but if it was quadratic to inital a set of queues or device bufferes
> in 1.0.0 and you made it liniar in 1.0.1 that is a performace improvment in the device intialisation time
> which is great but it would not affect the feature set or compatiablity in any way. you could call it
> a feature but its really just an internal change but you might want to still bump the version number.
> > 
> > The simplicity is good, but is it too simple.  It's not immediately
> > clear to me whether all features can be hidden behind a minor version.
> > For instance, if we have an mdev device that supports this notion of
> > aggregation, which is proposed as a solution to the problem that
> > physical hardware might support lots and lots of assignable interfaces
> > which can be combined into arbitrary sets for mdev devices, making it
> > impractical to expose an mdev type for every possible enumeration of
> > assignable interfaces within a device.
> 
> so this is a modeling problem and likely a limitation of the current way an mdev_type is exposed.
> stealing some linux doc eamples
> 
> 
>   |- [parent physical device]
>   |--- Vendor-specific-attributes [optional]
>   |--- [mdev_supported_types]
>   |     |--- [<type-id>]
>   |     |   |--- create
>   |     |   |--- name
>   |     |   |--- available_instances
>   |     |   |--- device_api
>   |     |   |--- description
> 
> you could adress this in 1 of at least 3 ways.
> 1.) mdev type for each enmartion which is fine for 1-2 variabley othersize its a combinitroial explotions.
> 2.) report each of the consomable sub componetns as an mdev type and create mupltipel mdevs and assign them to the vm.
> 3.) provider an api to dynamically compose mdevs types which staticaly partion the reqouese and can then be consomed
> perferably embeding the resouce infomation in the description filed in a huma/machince readable form.
> 
> 2 and 3 woudl work well with openstack however they both have there challanges
> 1 doesnt really work for anyone out side of a demo.
> >   We therefore expose a base type
> > where the aggregation is built later.  This essentially puts us in a
> > scenario where even within an mdev type running on the same driver,
> > there are devices that are not directly compatible with each other.
> >  
> > > we dont need vendor to rencode the driver name or vendor id and product id in the string. that info is alreay
> > > available both to the device driver and to userspace via /sys already we just need to know if version of
> > > the same mdev are compatiable so a simple semver version string which is well know in the software world
> > > at least is a clean abstration we can reuse.
> > 
> > This presumes there's no cross device migration.
> 
> no but it does assume no cross mdev_type migration.
> it assuems that nvida_mdev_type_x on host 1 is the same as nvida_mdev_type_x on host 2.
> if the parent device differese but support the same mdev type  we are asserting that they
> should be compatiable or a differnt mdev_type name should be used on each device.
> 
> so we are presuming the mdev type cant change as part of a live migration and if the type
> was to change it would no longer be a live migration operation it would be something else.
> that is based on the premis that changing the mdev type would change the capabilities of the mdev
> 
> >   An mdev type can only
> > be migrated to the same mdev type, all of the devices within that type
> > have some based compatibility, a phsyical device can only be migrated to
> > the same physical device.  In the latter case what defines the type?
> 
> the type-id in /sysfs
> 
>     /sys/devices/virtual/mtty/mtty/
>         |-- mdev_supported_types
>         |   |-- mtty-1 <---- this is an mdev type
>         |   |   |-- available_instances
>         |   |   |-- create
>         |   |   |-- device_api
>         |   |   |-- devices
>         |   |   `-- name
>         |   `-- mtty-2 <---- as is this
>         |       |-- available_instances
>         |       |-- create
>         |       |-- device_api
>         |       |-- devices
>         |       `-- name
> 
>   |- [parent phy device]
>   |--- [$MDEV_UUID]
>          |--- remove
>          |--- mdev_type {link to its type} <-- here
>          |--- vendor-specific-attributes [optional]
> 
> >   If
> > it's a PCI device, is it only vendor:device IDs?
> 
> no the mdev type is not defined by the vendor:device id of the parent device
> although the capablityes of that device will determin what mdev types if any it supprots.
> >   What about revision?
> > What about subsystem IDs?
> 
> at least for nvidia gpus i dont think if you by an evga branded v100 vs an pny branded one the capability
> would change but i do know that certenly the capablities of a dell branding intel nic and an intel branded
> one can. e.g. i have seen oem sku nics without sriov eventhoguh the same nic form intel supports it.
> sriov was deliberatly disabled in the dell firmware even though it share dhte same vendor and prodcut id but differnt
> subsystem id.
> 
> if the odm made an incomatipable change like that which affect an mdev type in some way i guess i would expect them to
> change the name or the description filed content to signal that.
> 
> >   What about possibly an onboard ROM or
> > internal firmware?
> 
> i would expect that updating the firmware/rom could result in changing a version string. that is how i was imagining
> it would change. 
> >   The information may be available, but which things
> > are relevant to migration?
> 
> that i dont know an i really would not like to encode that knolage in the vendor specific way in higher level
> tools like openstack or even libvirt. declarative version sting comparisons or even simile feature flag 
> check where an abstract huristic that can be applied across vendors would be fine. but yes i dont know
> what info would be needed in this case.
> >   We already see desires to allow migration
> > between physical and mdev,
> 
> migration between a phsical device and an mdev would not generally be considered a live migration in openstack.
> that would be a different operation as it would be user visible withing the guest vm.
> >  but also to expose mdev types that might be
> > composable to be compatible with other types.  Thanks,
> 
> i think composable mdev types are really challanging without some kind of feature flag concept
> like cpu flags or ethtool nic capablities that are both human readable and easily parsable.
> 
> we have the capability to schedule on cpu flags or gpu cuda level using a traits abstraction
> so instead of saying i want an vm on a host with an intel 2695v3 to ensure it has AVX
> you say i want an vm that is capable of using AVX
> https://github.com/openstack/os-traits/blob/master/os_traits/hw/cpu/x86/__init__.py#L18
> 
> we also have trait for cuda level so instead of asking for a specifc mdev type or nvida
> gpu the idea was you woudl describe what feature cuda in this exmple you need
> https://github.com/openstack/os-traits/blob/master/os_traits/hw/gpu/cuda.py#L16-L45
> 
> That is what we call qualitative schudleing and is why we create teh placement service.
> with out going in to the weeds we try to decouple quantaitive request such as 4 cpus and 1G of ram
> form the qunative i need AVX supprot
> 
> e.g. resouces:VCPU=4,resouces:MEMORY_MB=1024 triats:required=HW_CPU_X86_AVX
> 
> declarative quantitive and capablites reporting of resouces fits easily into that model.
> dynamic quantities that change as other mdev are allocated from the parent device or as
> new mdevs types are composed on the fly are very challenging.
> 
> > 
> > Alex
> > 
> 
> 

