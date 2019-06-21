Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578434E5D2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 12:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfFUKXQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 21 Jun 2019 06:23:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:22203 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfFUKXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 06:23:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 03:23:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,400,1557212400"; 
   d="scan'208";a="171176965"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2019 03:23:13 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 03:23:13 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 03:23:12 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.185]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.225]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 18:23:11 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Topic: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Index: AQHVHsiVLTtm/WvGlEKSmQ2lKcl2F6ajfRGAgAC0NOCAAGOFgIABGcaQ
Date:   Fri, 21 Jun 2019 10:23:10 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
 <20190620150757.7b2fa405@x1.home>
In-Reply-To: <20190620150757.7b2fa405@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjJiYzYyNDgtNGQ2Zi00MmRmLWFiODgtM2IxODkyZWE3Y2I4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSU84NmJjeWVjM0dMblFwcFo1T3krRDZteUpaWEU0YisyXC9pSkhWbGs0VTJ2MThIY2tGRlRvWUtDNFlHR3dpaFkifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, June 21, 2019 5:08 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> 
> On Thu, 20 Jun 2019 13:00:34 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Thursday, June 20, 2019 12:27 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > >
> > > On Sat,  8 Jun 2019 21:21:11 +0800
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > >
> > > > This patch adds sample driver named vfio-mdev-pci. It is to wrap
> > > > a PCI device as a mediated device. For a pci device, once bound
> > > > to vfio-mdev-pci driver, user space access of this device will
> > > > go through vfio mdev framework. The usage of the device follows
> > > > mdev management method. e.g. user should create a mdev before
> > > > exposing the device to user-space.
[...]
> >
> > > However, the patch below just makes the mdev interface behave
> > > correctly, I can't make it work on my system because commit
> > > 7bd50f0cd2fd ("vfio/type1: Add domain at(de)taching group helpers")
> >
> > What error did you encounter. I tested the patch with a device in a
> > singleton iommu group. I'm also searching a proper machine with
> > multiple devices in an iommu group and test it.
> 
> In vfio_iommu_type1, iommu backed mdev devices use the
> iommu_attach_device() interface, which includes:
> 
>         if (iommu_group_device_count(group) != 1)
>                 goto out_unlock;
> 
> So it's impossible to use with non-singleton groups currently.

Hmmm, I think it is no longer good to use iommu_attach_device() for iommu
backed mdev devices now. In this flow, the purpose here is to attach a device
to a domain and no need to check whether the device is in a singleton iommu
group. I think it would be better to use __iommu_attach_device() instead of
iommu_attach_device().

Also I found a potential mutex lock issue if using iommu_attach_device().
In vfio_iommu_attach_group(), it uses iommu_group_for_each_dev() to loop
all the devices in the group. It holds group->mutex. And then vfio_mdev_attach_domain()
calls iommu_attach_device() which also tries to get group->mutex. This would be
an issue. If you are fine with it, I may post another patch for it. :-)

> > > used iommu_attach_device() rather than iommu_attach_group() for non-aux
> > > mdev iommu_device.  Is there a requirement that the mdev parent device
> > > is in a singleton iommu group?
> >
> > I don't think there should have such limitation. Per my understanding,
> > vfio-mdev-pci should also be able to bind to devices which shares
> > iommu group with other devices. vfio-pci works well for such devices.
> > And since the two drivers share most of the codes, I think vfio-mdev-pci
> > should naturally support it as well.
> 
> Yes, the difference though is that vfio.c knows when devices are in the
> same group, which mdev vfio.c only knows about the non-iommu backed
> group, not the group that is actually used for the iommu backing.  So
> we either need to enlighten vfio.c or further abstract those details in
> vfio_iommu_type1.c.

Not sure if it is necessary to introduce more changes to vfio.c or
vfio_iommu_type1.c. If it's only for the scenario which two devices share an
iommu_group, I guess it could be supported by using __iommu_attach_device()
which has no device counting for the group. But maybe I missed something
here. It would be great if you can elaborate a bit for it. :-)

> 
> > > If this is a simplification, then
> > > vfio-mdev-pci should not bind to devices where this is violated since
> > > there's no way to use the device.  Can we support it though?
> >
> > yeah, I think we need to support it.
> >
> > > If I have two devices in the same group and bind them both to
> > > vfio-mdev-pci, I end up with three groups, one for each mdev device and
> > > the original physical device group.  vfio.c works with the mdev groups
> > > and will try to match both groups to the container.  vfio_iommu_type1.c
> > > also works with the mdev groups, except for the point where we actually
> > > try to attach a group to a domain, which is the only window where we use
> > > the iommu_device rather than the provided group, but we don't record
> > > that anywhere.  Should struct vfio_group have a pointer to a reference
> > > counted object that tracks the actual iommu_group attached, such that
> > > we can determine that the group is already attached to the domain and
> > > not try to attach again?
> >
> > Agreed, we need to avoid such duplicated attach. Instead of adding
> > reference counted object in vfio_group. I'm also considering the logic
> > below:

Re-walked the code, I find the duplicated attach will happen on the vfio-mdev-pci
device as vfio_mdev_attach_domain() only attaches the parent devices of
iommu backed mdevs instead of all the devices within the physical iommu_group.
While for a vfio-pci device, it will use iommu_attach_group() which attaches all the
devices within the iommu backed group. The same with detach,
vfio_mdev_detach_domain() detaches selective devices instead of all devices within
the iommu backed group.

> >     /*
> >       * Do this check in vfio_iommu_type1_attach_group(), after mdev_group
> >       * is initialized.
> >       */
> >     if (vfio_group->mdev_group) {
> >          /*
> >            * vfio_group->mdev_group is true means vfio_group->iommu_group
> >            * is not the actual iommu_group which is going to be attached to
> >            * domain. To avoid duplicate iommu_group attach, needs to check if
> >            * the actual iommu_group. vfio_get_parent_iommu_group() is a
> >            * newly added helper function which returns the actual attach
> >            * iommu_group going to be attached for this mdev group.
> >               */
> >          p_iommu_group = vfio_get_parent_iommu_group(
> >                                                                          vfio_group->iommu_group);
> >          list_for_each_entry(d, &iommu->domain_list, next) {
> >                  if (find_iommu_group(d, p_iommu_group)) {
> >                          mutex_unlock(&iommu->lock);
> >                          // skip group attach;
> >                  }
> >          }
> 
> We don't currently create a struct vfio_group for the parent, only for
> the mdev iommu group.  The iommu_attach for an iommu backed mdev
> doesn't leave any traces of where it is actually attached, we just
> count on retracing our steps for the detach.  That's why I'm thinking
> we need an object somewhere to track it and it needs to be reference
> counted so that if both a vfio-mdev-pci device and a vfio-pci device
> are using it, we leave it in place if either one is removed.

Hmmm, here we are talking about tracking in iommu_group level though
no good idea on where the object should  be placed yet. However, we may
need to tack in device level as I mentioned in above paragraph. If not,
there may be sequence issue. e.g. if vfio-mdev-pci device is attached
firstly, then the object will be initialized, and when vfio-pci device is
attached, we will find the attach should be skipped and just inc the ref count.
But actually it should not be skipped since the vfio-mdev-pci attach does not
attach all devices within the iommu backed group.

What's more, regards to sIOV case,  a parent devices may have multiple
mdevs and the mdevs may be assigned to the same VM. Thus there will be multiple
attach on this parent device. This also makes me believe track in device level would
be better. 

> 
> > > Ideally I'd be able to bind one device to
> > > vfio-pci, the other to vfio-mdev-pci, and be able to use them both
> > > within the same container.  It seems like this should be possible, it's
> > > the same effective iommu configuration as if they were both bound to
> > > vfio-pci.  Thanks,
> >
> > Agreed. Will test it. And thanks for the fix patch below. I've test it
> > with a device in a singleton iommu group. Need to test the scenario
> > you mentioned above. :-)
> 
> Thanks!

You are welcomed. :-)

> Alex

Regards,
Yi Liu
