Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2342529B3
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 11:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHZJDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 05:03:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:10517 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgHZJDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 05:03:42 -0400
IronPort-SDR: QHnPuGtYJDtY5t/ijIYEZHl4+WGodkXsCA8ZpSygAsoPawnTfqmP+UZEpomhboyOZ8nGo4WuCu
 2ythIKyX+cdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="136320222"
X-IronPort-AV: E=Sophos;i="5.76,355,1592895600"; 
   d="scan'208";a="136320222"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 01:59:40 -0700
IronPort-SDR: o0JI/YidWPYMHEVf05l0xeeJn1V75h47K5sqsODOYOBXtHTuKjZKavhiagHf/3gTuGfMxDzwbR
 WlFGGnRCaBcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,355,1592895600"; 
   d="scan'208";a="329154803"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2020 01:59:34 -0700
Date:   Wed, 26 Aug 2020 16:54:11 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Mooney <smooney@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
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
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200826085411.GB22243@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <20200820003922.GE21172@joy-OptiPlex-7040>
 <242591bb809b68c618f62fdc93d4f8ae7b146b6d.camel@redhat.com>
 <20200820040116.GB24121@joy-OptiPlex-7040>
 <da140e6d262632e2fb707f69f220915748d25d35.camel@redhat.com>
 <20200820062725.GB24997@joy-OptiPlex-7040>
 <47d216330e10152f0f5d27421da60a7b1c52e5f0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47d216330e10152f0f5d27421da60a7b1c52e5f0.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 02:24:26PM +0100, Sean Mooney wrote:
> On Thu, 2020-08-20 at 14:27 +0800, Yan Zhao wrote:
> > On Thu, Aug 20, 2020 at 06:16:28AM +0100, Sean Mooney wrote:
> > > On Thu, 2020-08-20 at 12:01 +0800, Yan Zhao wrote:
> > > > On Thu, Aug 20, 2020 at 02:29:07AM +0100, Sean Mooney wrote:
> > > > > On Thu, 2020-08-20 at 08:39 +0800, Yan Zhao wrote:
> > > > > > On Tue, Aug 18, 2020 at 11:36:52AM +0200, Cornelia Huck wrote:
> > > > > > > On Tue, 18 Aug 2020 10:16:28 +0100
> > > > > > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > > > > > > 
> > > > > > > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:
> > > > > > > > >    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> > > > > > > > > 
> > > > > > > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > > > > > > 
> > > > > > > > >  On 2020/8/14 下午1:16, Yan Zhao wrote:
> > > > > > > > > 
> > > > > > > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > > > > > > 
> > > > > > > > >  On 2020/8/10 下午3:46, Yan Zhao wrote:  
> > > > > > > > >  we actually can also retrieve the same information through sysfs, .e.g
> > > > > > > > > 
> > > > > > > > >  |- [path to device]
> > > > > > > > >     |--- migration
> > > > > > > > >     |     |--- self
> > > > > > > > >     |     |   |---device_api
> > > > > > > > >     |    |   |---mdev_type
> > > > > > > > >     |    |   |---software_version
> > > > > > > > >     |    |   |---device_id
> > > > > > > > >     |    |   |---aggregator
> > > > > > > > >     |     |--- compatible
> > > > > > > > >     |     |   |---device_api
> > > > > > > > >     |    |   |---mdev_type
> > > > > > > > >     |    |   |---software_version
> > > > > > > > >     |    |   |---device_id
> > > > > > > > >     |    |   |---aggregator
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > >  Yes but:
> > > > > > > > > 
> > > > > > > > >  - You need one file per attribute (one syscall for one attribute)
> > > > > > > > >  - Attribute is coupled with kobject
> > > > > > > 
> > > > > > > Is that really that bad? You have the device with an embedded kobject
> > > > > > > anyway, and you can just put things into an attribute group?
> > > > > > > 
> > > > > > > [Also, I think that self/compatible split in the example makes things
> > > > > > > needlessly complex. Shouldn't semantic versioning and matching already
> > > > > > > cover nearly everything? I would expect very few cases that are more
> > > > > > > complex than that. Maybe the aggregation stuff, but I don't think we
> > > > > > > need that self/compatible split for that, either.]
> > > > > > 
> > > > > > Hi Cornelia,
> > > > > > 
> > > > > > The reason I want to declare compatible list of attributes is that
> > > > > > sometimes it's not a simple 1:1 matching of source attributes and target attributes
> > > > > > as I demonstrated below,
> > > > > > source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatible to
> > > > > > target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
> > > > > >                (mdev_type i915-GVTg_V5_8 + aggregator 4)
> > > > > 
> > > > > the way you are doing the nameing is till really confusing by the way
> > > > > if this has not already been merged in the kernel can you chagne the mdev
> > > > > so that mdev_type i915-GVTg_V5_2 is 2 of mdev_type i915-GVTg_V5_1 instead of half the device
> > > > > 
> > > > > currently you need to deived the aggratod by the number at the end of the mdev type to figure out
> > > > > how much of the phsicial device is being used with is a very unfridly api convention
> > > > > 
> > > > > the way aggrator are being proposed in general is not really someting i like but i thin this at least
> > > > > is something that should be able to correct.
> > > > > 
> > > > > with the complexity in the mdev type name + aggrator i suspect that this will never be support
> > > > > in openstack nova directly requireing integration via cyborg unless we can pre partion the
> > > > > device in to mdevs staicaly and just ignore this.
> > > > > 
> > > > > this is way to vendor sepecif to integrate into something like openstack in nova unless we can guarentee
> > > > > taht how aggreator work will be portable across vendors genericly.
> > > > > 
> > > > > > 
> > > > > > and aggragator may be just one of such examples that 1:1 matching does not
> > > > > > fit.
> > > > > 
> > > > > for openstack nova i dont see us support anything beyond the 1:1 case where the mdev type does not change.
> > > > > 
> > > > 
> > > > hi Sean,
> > > > I understand it's hard for openstack. but 1:N is always meaningful.
> > > > e.g.
> > > > if source device 1 has cap A, it is compatible to
> > > > device 2: cap A,
> > > > device 3: cap A+B,
> > > > device 4: cap A+B+C
> > > > ....
> > > > to allow openstack to detect it correctly, in compatible list of
> > > > device 2, we would say compatible cap is A;
> > > > device 3, compatible cap is A or A+B;
> > > > device 4, compatible cap is A or A+B, or A+B+C;
> > > > 
> > > > then if openstack finds device A's self cap A is contained in compatible
> > > > cap of device 2/3/4, it can migrate device 1 to device 2,3,4.
> > > > 
> > > > conversely,  device 1's compatible cap is only A,
> > > > so it is able to migrate device 2 to device 1, and it is not able to
> > > > migrate device 3/4 to device 1.
> > > 
> > > yes we build the palcement servce aroudn the idea of capablites as traits on resocue providres.
> > > which is why i originally asked if we coudl model compatibality with feature flags
> > > 
> > > we can seaislyt model deivce as aupport A, A+B or  A+B+C
> > > and then select hosts and evice based on that but
> > > 
> > > the list of compatable deivce you are propsoeing hide this feature infomation which whould be what we are matching
> > > on.
> > > 
> > > give me a lset of feature you want and list ting the feature avaiable on each device allow highre level ocestation
> > > to
> > > easily match the request to a host that can fulllfile it btu thave a set of other compatihble device does not help
> > > with
> > > that
> > > 
> > > so if a simple list a capabliteis can be advertiese d and if we know tha two dievce with the same capablity are
> > > intercahangebale that is workabout i suspect that will not be the case however and it would onely work within a
> > > familay
> > > of mdevs that are closely related.  which i think agian is an argument for not changeing the mdev type and at least
> > > intially only look at migatreion where the mdev type doee not change initally. 
> > > 
> > 
> > sorry Sean, I don't understand your words completely.
> > Please allow me to write it down in my words, and please confirm if my
> > understanding is right.
> > 1. you mean you agree on that each field is regarded as a trait, and
> > openstack can compare by itself if source trait is a subset of target trait, right?
> > e.g.
> > source device
> > field1=A1
> > field2=A2+B2
> > field3=A3
> > 
> > target device
> > field1=A1+B1
> > field2=A2+B2
> > filed3=A3
> > 
> > then openstack sees that field1/2/3 in source is a subset of field1/2/3 in
> > target, so it's migratable to target?
> 
> yes this is basically how cpu feature work.
> if we see the host cpu on the dest is a supperset of the cpu feature used
> by the vm we know its safe to migrate.

got it. glad to know it :)
> > 
> > 2. mdev_type + aggregator make it hard to achieve the above elegant
> > solution, so it's best to avoid the combined comparing of mdev_type + aggregator.
> > do I understand it correctly?
> yes and no. one of the challange that mdevs pose right now is that sometiem mdev model
> independent resouces and sometimes multipe mdev types consume the same underlying resouces
> there is know way for openstack to know if i915-GVTg_V5_2 and i915-GVTg_V5_4 consume the same resouces
> or not. as such we cant do the accounting properly so i would much prefer to have just 1 mdev type
> i915-GVTg and which models the minimal allocatable unit and then say i want 4 of them comsed into 1 device
> then have a second mdev type that does that since
> 
> what that means in pratice is we cannot trust the available_instances for a given mdev type
> as consuming a different mdev type might change it. aggrators makes that problem worse.
> which is why i siad i would prefer if instead of aggreator as prposed each consumable
> resouce was reported indepenedly as different mdev types and then we composed those
> like we would when bond ports creating an attachment or other logical aggration that refers
> to instance of mdevs of differing type which we expose as a singel mdev that is exposed to the guest.
> in a concreate example we might say create a aggreator of 64 cuda cores and 32 tensor cores and "bond them"
> or aggrate them as a single attachme mdev and provide that to a ml workload guest. a differnt guest could request
> 1 instace of the nvenc video encoder and one instance of the nvenc video decoder but no cuda or tensor for a video
> transcoding workload.
> 
The "bond" you described is a little different from the intension of the
aggregator we introduced for scalable IOV. (as explained in another mail
to Cornelia https://lists.gnu.org/archive/html/qemu-devel/2020-08/msg06523.html).

But any way, we agree that mdevs are not compatible if mdev_types are not compatible.  

> if each of those componets are indepent mdev types and can be composed with that granularity then i think that approch
> is better then the current aggreator with vendor sepcific fileds.
> we can model the phsical device as being multipel nested resouces with different traits for each type of resouce and
> different capsities for the same. we can even model how many of the attachments/compositions can be done indepently
> if there is a limit on that.
> 
> |- [parent physical device]
> |--- Vendor-specific-attributes [optional]
> |--- [mdev_supported_types]
> |     |--- [<type-id>]
> |     |   |--- create
> |     |   |--- name
> |     |   |--- available_instances
> |     |   |--- device_api
> |     |   |--- description
> |     |   |--- [devices]
> |     |--- [<type-id>]
> |     |   |--- create
> |     |   |--- name
> |     |   |--- available_instances
> |     |   |--- device_api
> |     |   |--- description
> |     |   |--- [devices]
> |     |--- [<type-id>]
> |          |--- create
> |          |--- name
> |          |--- available_instances
> |          |--- device_api
> |          |--- description
> |          |--- [devices]
> 
> a benifit of this appoch is we would be the mdev types would not change on migration 
> and we could jsut compuare a a simeple version stirgh and feature flag list to determin comaptiablity
> in a vendor neutral way. i dont nessisarly need to know what the vendeor flags mean just that the dest is a subset of
> the source and that the semaitic version numbers say the mdevs are compatible.
> > 
as aggregator and some other attributes are only meaningful after
devices are created, and vendors' naming of mdev types are not unified,
do you think below way is good?


|- [parent physical device]
|--- [mdev_supported_types]
|     |--- [<type-id>]
|     |   |--- create
|     |   |--- name
|     |   |--- available_instances
|     |   |--- compatible_type [must]
|     |   |--- Vendor-specific-compatible-type-attributes [optional]
|     |   |--- device_api [must]
|     |   |--- software_version [must]
|     |   |--- description
|     |   |--- [devices]
|     |   |--------[<uuid>]
|     |   |            |--- vendor-specific-compatible-device-attriutes [optional]

all vendor specific compatible attributes begin with compatible in name.

in GVT's current case,
|- 0000\:00\:02.0
|--- mdev_supported_types
|     |--- i915-GVTg_V5_8
|     |   |--- create
|     |   |--- name
|     |   |--- available_instances
|     |   |--- compatible_type : i915-GVTg_V5_8, i915-GVTg_V4_8
|     |   |--- device_api : vfio-pci
|     |   |--- software_version : 1.0.0
|     |   |--- compatible_pci_ids : 5931, 591b
|     |   |--- description
|     |   |--- devices
|     |   |       |- 882cc4da-dede-11e7-9180-078a62063ab1
|     |   |       |     | --- aggregator : 1
|     |   |       |     | --- compatible_aggregator : 1

suppose 882cc4da-dede-11e7-9180-078a62063ab1 is a src mdev.
the sequence for openstack to find a compatible mdev in my mind is that
1. make src mdev type and compatible_type as traits.

2. look for a mdev type that is either i915-GVTg_V4_8 or i915-GVTg_V5_8
as that in compatible_type.
(this is just an example, currently we only support migration between
mdevs whose attributes are all matching, from mdev type to aggregator,
to pci_ids)

3. if 2 fails, try to find a mdev type whose compatible_type is a
superset of src compatible_type. if found one, go to step 4; otherwise,
quit.

4. check if device_api, software_version under the type are compatible.

5. check if other vendor specific type attributes under the type are compatible.
- check if src compatible_pci_ids is a subset of target compatible_pci_ids.

6. check if device is created and not occupied, if not, create one.

7. check if vendor specific attributes under the device are compatible.
- check if src compatible_aggregator is a subset of target compatible_aggregator.
  if fails, try to find counterpart attribute of vendor specific device attribute
  and set target value according to compatible_xxx in source side.
  (for compatible_aggregator, its counterpart is aggregator.)
  if attribute aggregator exists, step 7 succeeds when setting of its value succeeds.
  if attribute aggregator does not exist, step 7 fails.

8. a compatible target is found.

not sure if the above steps look good to you.

some changes are required for compatibility check for physical device when mdev_type is absent.
but let's first arrive at consensus for mdevs first :)

> > 3. you don't like self list and compatible list, because it is hard for
> > openstack to compare different traits?
> > e.g. if we have self list and compatible list, then as below, openstack needs
> > to compare if self field1/2/3 is a subset of compatible field 1/2/3.
> currnetly we only use mdevs for vGPUs and in our documentaiton we tell customer
> to model the mdev_type as a trait and request it as a reuiqred trait.
> so for customer that are doing that today changing mdev types is not really an option.
> we would prefer that they request the feature they need instead of a spefic mdev type
> so we can select any that meets there needs
> for example we have a bunch of traits for cuda support
> https://github.com/openstack/os-traits/blob/master/os_traits/hw/gpu/cuda.py
> or driectx/vulkan/opengl https://github.com/openstack/os-traits/blob/master/os_traits/hw/gpu/api.py
> these are closely analogous to cpu feature flag lix avx or sse
> https://github.com/openstack/os-traits/blob/master/os_traits/hw/cpu/x86/__init__.py#L16
> 
> so when it comes to compatiablities it would be ideal if you could express capablities as something like
> a cpu feature flag then we can eaisly model those as traits. 
> > 
> > source device:
> > self field1=A1
> > self field2=A2+B2
> > self field3=A3
> > 
> > compatible field1=A1
> > compatible field2=A2;B2;A2+B2;
> > compatible field3=A3
> > 
> > 
> > target device:
> > self field1=A1+B1
> > self field2=A2+B2
> > self field3=A3
> > 
> > compatible field1=A1;B1;A1+B1;
> > compatible field2=A2;B2;A2+B2;
> > compatible field3=A3
> > 
> > 
> > Thanks
> > Yan
> > 
> > 
> > > > 
> > > > 
> > > > > i woudl really prefer if there was just one mdev type that repsented the minimal allcatable unit and the
> > > > > aggragaotr where used to create compostions of that. i.e instad of i915-GVTg_V5_2 beign half the device,
> > > > > have 1 mdev type i915-GVTg and if the device support 8 of them then we can aggrate 4 of i915-GVTg
> > > > > 
> > > > > if you want to have muplie mdev type to model the different amoutn of the resouce e.g. i915-GVTg_small i915-
> > > > > GVTg_large
> > > > > that is totlaly fine too or even i915-GVTg_4 indcating it sis 4 of i915-GVTg
> > > > > 
> > > > > failing that i would just expose an mdev type per composable resouce and allow us to compose them a the user
> > > > > level
> > > > > with
> > > > > some other construct mudeling a attament to the device. e.g. create composed mdev or somethig that is an
> > > > > aggreateion
> > > > > of
> > > > > multiple sub resouces each of which is an mdev. so kind of like how bond port work. we would create an mdev for
> > > > > each
> > > > > of
> > > > > the sub resouces and then create a bond or aggrated mdev by reference the other mdevs by uuid then attach only
> > > > > the
> > > > > aggreated mdev to the instance.
> > > > > 
> > > > > the current aggrator syntax and sematic however make me rather uncofrotable when i think about orchestating vms
> > > > > on
> > > > > top
> > > > > of it even to boot them let alone migrate them.
> > > > > > 
> > > > > > So, we explicitly list out self/compatible attributes, and management
> > > > > > tools only need to check if self attributes is contained compatible
> > > > > > attributes.
> > > > > > 
> > > > > > or do you mean only compatible list is enough, and the management tools
> > > > > > need to find out self list by themselves?
> > > > > > But I think provide a self list is easier for management tools.
> > > > > > 
> > > > > > Thanks
> > > > > > Yan
> > > > > > 
> > > > 
> > > > 
> > 
> > 
> 
