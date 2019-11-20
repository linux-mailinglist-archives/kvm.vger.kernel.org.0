Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07211030DF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 01:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKTAqe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 19 Nov 2019 19:46:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:32546 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfKTAqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 19:46:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 16:46:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="231748282"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 19 Nov 2019 16:46:33 -0800
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 16:46:33 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 16:46:32 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.248]) with mapi id 14.03.0439.000;
 Wed, 20 Nov 2019 08:46:31 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Libvirt Devel <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: RE: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikbbkH6FUlQ7kukEPc4R6T+S6d8oIgAgAB4FoCAAPFxAIANs7pwgAcBfACAAKIpUA==
Date:   Wed, 20 Nov 2019 00:46:30 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D605967@SHSMSX104.ccr.corp.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <20191105141042.17dd2d7d@x1.home>
        <20191106042031.GJ1769@zhen-hp.sh.intel.com>
        <20191106114440.7314713e@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D5F69A5@SHSMSX104.ccr.corp.intel.com>
 <20191119155826.64558003@x1.home>
In-Reply-To: <20191119155826.64558003@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmFkZmM0NjYtNjdjZi00NmYzLTg4NmYtNGE1YTA2YjdlMjUxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOUFvZndyZ2E1SkMxbkV1d0J0NzR3YUdRWjNld1dsU0tHbE1tZEtvQUtLXC9pU05KS3BHY2xzaUs0M1prbTFFZncifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Wednesday, November 20, 2019 6:58 AM
> 
> On Fri, 15 Nov 2019 04:24:35 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson
> > > Sent: Thursday, November 7, 2019 2:45 AM
> > >
> > > On Wed, 6 Nov 2019 12:20:31 +0800
> > > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > >
> > > > On 2019.11.05 14:10:42 -0700, Alex Williamson wrote:
> > > > > On Thu, 24 Oct 2019 13:08:23 +0800
> > > > > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > > > >
> > > > > > Hi,
> > > > > >
> > > > > > This is a refresh for previous send of this series. I got impression
> that
> > > > > > some SIOV drivers would still deploy their own create and config
> > > method so
> > > > > > stopped effort on this. But seems this would still be useful for
> some
> > > other
> > > > > > SIOV driver which may simply want capability to aggregate
> resources.
> > > So here's
> > > > > > refreshed series.
> > > > > >
> > > > > > Current mdev device create interface depends on fixed mdev type,
> > > which get uuid
> > > > > > from user to create instance of mdev device. If user wants to use
> > > customized
> > > > > > number of resource for mdev device, then only can create new
> mdev
> > > type for that
> > > > > > which may not be flexible. This requirement comes not only from
> to
> > > be able to
> > > > > > allocate flexible resources for KVMGT, but also from Intel scalable
> IO
> > > > > > virtualization which would use vfio/mdev to be able to allocate
> > > arbitrary
> > > > > > resources on mdev instance. More info on [1] [2] [3].
> > > > > >
> > > > > > To allow to create user defined resources for mdev, it trys to
> extend
> > > mdev
> > > > > > create interface by adding new "aggregate=xxx" parameter
> following
> > > UUID, for
> > > > > > target mdev type if aggregation is supported, it can create new
> mdev
> > > device
> > > > > > which contains resources combined by number of instances, e.g
> > > > > >
> > > > > >     echo "<uuid>,aggregate=10" > create
> > > > > >
> > > > > > VM manager e.g libvirt can check mdev type with "aggregation"
> > > attribute which
> > > > > > can support this setting. If no "aggregation" attribute found for
> mdev
> > > type,
> > > > > > previous behavior is still kept for one instance allocation. And new
> > > sysfs
> > > > > > attribute "aggregated_instances" is created for each mdev device
> to
> > > show allocated number.
> > > > >
> > > > > Given discussions we've had recently around libvirt interacting with
> > > > > mdev, I think that libvirt would rather have an abstract interface via
> > > > > mdevctl[1].  Therefore can you evaluate how mdevctl would support
> > > this
> > > > > creation extension?  It seems like it would fit within the existing
> > > > > mdev and mdevctl framework if aggregation were simply a sysfs
> > > attribute
> > > > > for the device.  For example, the mdevctl steps might look like this:
> > > > >
> > > > > mdevctl define -u UUID -p PARENT -t TYPE
> > > > > mdevctl modify -u UUID --addattr=mdev/aggregation --value=2
> > > > > mdevctl start -u UUID
> >
> > Hi, Alex, can you elaborate why a sysfs attribute is more friendly
> > to mdevctl? what is the complexity if having mdevctl to pass
> > additional parameter at creation time as this series originally
> > proposed? Just want to clearly understand the limitation of the
> > parameter way. :-)
> 
> We could also flip this question around, vfio-ap already uses sysfs to
> finish composing a device after it's created, therefore why shouldn't
> aggregation use this existing mechanism.  Extending the creation
> interface is a more fundamental change than simply standardizing an
> optional sysfs namespace entry.
> 
> > > > >
> > > > > When mdevctl starts the mdev, it will first create it using the
> > > > > existing mechanism, then apply aggregation attribute, which can
> > > consume
> > > > > the necessary additional instances from the parent device, or return
> an
> > > > > error, which would unwind and return a failure code to the caller
> > > > > (libvirt).  I think the vendor driver would then have freedom to
> decide
> > > > > when the attribute could be modified, for instance it would be
> entirely
> > > > > reasonable to return -EBUSY if the user attempts to modify the
> > > > > attribute while the mdev device is in-use.  Effectively aggregation
> > > > > simply becomes a standardized attribute with common meaning.
> > > Thoughts?
> > > > > [cc libvirt folks for their impression] Thanks,
> > > >
> > > > I think one problem is that before mdevctl start to create mdev you
> > > > don't know what vendor attributes are, as we apply mdev attributes
> > > > after create. You may need some lookup depending on parent.. I think
> > > > making aggregation like other vendor attribute for mdev might be the
> > > > simplest way, but do we want to define its behavior in formal? e.g
> > > > like previous discussed it should show maxium instances for
> aggregation,
> > > etc.
> > >
> > > Yes, we'd still want to standardize how we enable and discover
> > > aggregation since we expect multiple users.  Even if libvirt were to
> > > use mdevctl as it's mdev interface, higher level tools should have an
> > > introspection mechanism available.  Possibly the sysfs interfaces
> > > proposed in this series remains largely the same, but I think perhaps
> > > the implementation of them moves out to the vendor driver.  In fact,
> > > perhaps the only change to mdev core is to define the standard.  For
> > > example, the "aggregation" attribute on the type is potentially simply
> > > a defined, optional, per type attribute, similar to "name" and
> > > "description".  For "aggregated_instances" we already have the
> > > mdev_attr_groups of the mdev_parent_ops, we could define an
> > > attribute_group with .name = "mdev" as a set of standardized
> > > attributes, such that vendors could provide both their own vendor
> > > specific attributes and per device attributes with a common meaning
> and
> > > semantic defined in the mdev ABI.
> >
> > such standardization sounds good.
> >
> > >
> > > > The behavior change for driver is that previously aggregation is
> > > > handled at create time, but for sysfs attr it should handle any
> > > > resource allocation before it's really in-use. I think some SIOV
> > > > driver which already requires some specific config should be ok,
> > > > but not sure for other driver which might not be explored in this
> before.
> > > > Would that be a problem? Kevin?
> > >
> > > Right, I'm assuming the aggregation could be modified until the device
> > > is actually opened, the driver can nak the aggregation request by
> > > returning an errno to the attribute write.  I'm trying to anticipate
> > > whether this introduces new complications, for instances races with
> > > contiguous allocations.  I think these seem solvable within the vendor
> > > drivers, but please note it if I'm wrong.  Thanks,
> > >
> >
> > So far I didn't see a problem with this way. Regarding to contiguous
> > allocations, ideally it should be fine as long as aggregation paths are
> > properly locked similar  as creation paths when allocating resources.
> > It will introduce some additional work in vendor driver but such
> > overhead is worthy if it leads to cleaner uapi.
> >
> > There is one open though. In concept the aggregation feature can
> > be used for both increasing and decreasing the resource when
> > exposing as a sysfs attribute, any time when the device is not in-use.
> > Increasing resource is possibly fine, but I'm not sure about decreasing
> > resource. Is there any vendor driver which cannot afford resource
> > decrease once it has ever been used (after deassignment), or require
> > at least an explicit reset before decrease? If yes, how do we report
> > such special requirement (only-once, multiple-times, multiple-times-
> > before-1st-usage) to user space?
> 
> It seems like a sloppy vendor driver that couldn't return a device to a
> post-creation state, ie. drop and re-initialize the aggregation state.

might be hardware limitation too...

> Userspace would always need to handle an aggregation failure, there
> might be multiple processes attempting to allocate resources
> simultaneously or the user might simply be requesting more resources
> than available.  The vendor driver should make a reasonable attempt to
> satisfy the user request or else an insufficient resource error may
> appear at the application.  vfio-mdev devices should always be reset
> before and after usage.

the two scenarios are different. One is to let userspace know whether
aggregation is supported, and any limitation. The other is to use
the feature under claimed limitations and then includes error handling
logic in case resource contention.

> 
> > It's sort of like what Cornelia commented about standardization
> > of post-creation resource configuration. If it may end up to be
> > a complex story (or at least take time to understand/standardize
> > all kinds of requirements), does it still make sense to support
> > creation-time parameter as a quick-path for this aggregation feature? :-)
> 
> We're not going to do both, right?  We likely lock ourselves into one
> schema when we do it.  Not only is the sysfs approach already in use in
> vfio-ap, but it seems more flexible.  Above you raise the issue of
> dynamically resizing the aggregation between uses.  We can't do that
> with only a creation-time parameter.  With a sysfs parameter the vendor

yes, because creation-time parameter is one-off.

> driver can nak changes, allow changes when idle, potentially even allow
> changes while in use.  Connie essentially brings up the question of how
> we can introspect sysfs attribute, which is a big question.  Perhaps we
> can nibble off a piece of that question by starting with a namespace
> per attribute.  For instance, rather than doing:
> 
> echo 2 > /sys/bus/mdev/devices/UUID/mdev/aggregation
> 
> We could do:
> 
> echo 2 > /sys/bus/mdev/devices/UUID/mdev/aggregation/value
> 
> This allows us the whole mdev/aggregation/* namespace to describe other
> attributes to expose aspects of the aggregation support.  Thanks,
> 

en, this sounds a better option. We can start with one attribute (value)
and extend to cover any possible restriction in the future. One note to
Zhenyu - with this approach at least you should prepare for both
increasing and decreasing resource through 'value' in GVT-g driver.

Thanks
Kevin
