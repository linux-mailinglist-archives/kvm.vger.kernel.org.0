Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6ED240321
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 10:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgHJIEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 04:04:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:24693 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgHJIEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 04:04:12 -0400
IronPort-SDR: pcrTSZpz7nWCnx4HSwtbBq8jzXfBxqTXRsrEGu6thFhww23ZOXOwV3fwhjz1Z7SCwyxzSOwehs
 2NJDthbhPX9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="217833780"
X-IronPort-AV: E=Sophos;i="5.75,456,1589266800"; 
   d="scan'208";a="217833780"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 01:04:10 -0700
IronPort-SDR: 1+BZswvKizqMDl2nnLt3Wbb4kj38KsrRKQlvIVQXxebMjEQXF1LjOhlHKoimsXfE2GzV+/kzCm
 YhlHLX16i7Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,456,1589266800"; 
   d="scan'208";a="324369748"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 10 Aug 2020 01:04:05 -0700
Date:   Mon, 10 Aug 2020 15:46:31 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jiri Pirko <jiri@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200810074631.GA29059@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040>
 <20200805105319.GF2177@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200805105319.GF2177@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 12:53:19PM +0200, Jiri Pirko wrote:
> Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:
> >On Wed, Aug 05, 2020 at 04:02:48PM +0800, Jason Wang wrote:
> >> 
> >> On 2020/8/5 下午3:56, Jiri Pirko wrote:
> >> > Wed, Aug 05, 2020 at 04:41:54AM CEST, jasowang@redhat.com wrote:
> >> > > On 2020/8/5 上午10:16, Yan Zhao wrote:
> >> > > > On Wed, Aug 05, 2020 at 10:22:15AM +0800, Jason Wang wrote:
> >> > > > > On 2020/8/5 上午12:35, Cornelia Huck wrote:
> >> > > > > > [sorry about not chiming in earlier]
> >> > > > > > 
> >> > > > > > On Wed, 29 Jul 2020 16:05:03 +0800
> >> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> > > > > > 
> >> > > > > > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> >> > > > > > (...)
> >> > > > > > 
> >> > > > > > > > Based on the feedback we've received, the previously proposed interface
> >> > > > > > > > is not viable.  I think there's agreement that the user needs to be
> >> > > > > > > > able to parse and interpret the version information.  Using json seems
> >> > > > > > > > viable, but I don't know if it's the best option.  Is there any
> >> > > > > > > > precedent of markup strings returned via sysfs we could follow?
> >> > > > > > I don't think encoding complex information in a sysfs file is a viable
> >> > > > > > approach. Quoting Documentation/filesystems/sysfs.rst:
> >> > > > > > 
> >> > > > > > "Attributes should be ASCII text files, preferably with only one value
> >> > > > > > per file. It is noted that it may not be efficient to contain only one
> >> > > > > > value per file, so it is socially acceptable to express an array of
> >> > > > > > values of the same type.
> >> > > > > > Mixing types, expressing multiple lines of data, and doing fancy
> >> > > > > > formatting of data is heavily frowned upon."
> >> > > > > > 
> >> > > > > > Even though this is an older file, I think these restrictions still
> >> > > > > > apply.
> >> > > > > +1, that's another reason why devlink(netlink) is better.
> >> > > > > 
> >> > > > hi Jason,
> >> > > > do you have any materials or sample code about devlink, so we can have a good
> >> > > > study of it?
> >> > > > I found some kernel docs about it but my preliminary study didn't show me the
> >> > > > advantage of devlink.
> >> > > 
> >> > > CC Jiri and Parav for a better answer for this.
> >> > > 
> >> > > My understanding is that the following advantages are obvious (as I replied
> >> > > in another thread):
> >> > > 
> >> > > - existing users (NIC, crypto, SCSI, ib), mature and stable
> >> > > - much better error reporting (ext_ack other than string or errno)
> >> > > - namespace aware
> >> > > - do not couple with kobject
> >> > Jason, what is your use case?
> >> 
> >> 
> >> I think the use case is to report device compatibility for live migration.
> >> Yan proposed a simple sysfs based migration version first, but it looks not
> >> sufficient and something based on JSON is discussed.
> >> 
> >> Yan, can you help to summarize the discussion so far for Jiri as a
> >> reference?
> >> 
> >yes.
> >we are currently defining an device live migration compatibility
> >interface in order to let user space like openstack and libvirt knows
> >which two devices are live migration compatible.
> >currently the devices include mdev (a kernel emulated virtual device)
> >and physical devices (e.g.  a VF of a PCI SRIOV device).
> >
> >the attributes we want user space to compare including
> >common attribues:
> >    device_api: vfio-pci, vfio-ccw...
> >    mdev_type: mdev type of mdev or similar signature for physical device
> >               It specifies a device's hardware capability. e.g.
> >	       i915-GVTg_V5_4 means it's of 1/4 of a gen9 Intel graphics
> >	       device.
> >    software_version: device driver's version.
> >               in <major>.<minor>[.bugfix] scheme, where there is no
> >	       compatibility across major versions, minor versions have
> >	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
> >	       bugfix version number indicates some degree of internal
> >	       improvement that is not visible to the user in terms of
> >	       features or compatibility,
> >
> >vendor specific attributes: each vendor may define different attributes
> >   device id : device id of a physical devices or mdev's parent pci device.
> >               it could be equal to pci id for pci devices
> >   aggregator: used together with mdev_type. e.g. aggregator=2 together
> >               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
> >	       graphics device.
> >   remote_url: for a local NVMe VF, it may be configured with a remote
> >               url of a remote storage and all data is stored in the
> >	       remote side specified by the remote url.
> >   ...
> >
> >Comparing those attributes by user space alone is not an easy job, as it
> >can't simply assume an equal relationship between source attributes and
> >target attributes. e.g.
> >for a source device of mdev_type=i915-GVTg_V5_4,aggregator=2, (1/2 of
> >gen9), it actually could find a compatible device of
> >mdev_type=i915-GVTg_V5_8,aggregator=4 (also 1/2 of gen9),
> >if mdev_type of i915-GVTg_V5_4 is not available in the target machine.
> >
> >So, in our current proposal, we want to create two sysfs attributes
> >under a device sysfs node.
> >/sys/<path to device>/migration/self
> >/sys/<path to device>/migration/compatible
> >
> >#cat /sys/<path to device>/migration/self
> >device_type=vfio_pci
> >mdev_type=i915-GVTg_V5_4
> >device_id=8086591d
> >aggregator=2
> >software_version=1.0.0
> >
> >#cat /sys/<path to device>/migration/compatible
> >device_type=vfio_pci
> >mdev_type=i915-GVTg_V5_{val1:int:2,4,8}
> >device_id=8086591d
> >aggregator={val1}/2
> >software_version=1.0.0
> >
> >The /sys/<path to device>/migration/self specifies self attributes of
> >a device.
> >The /sys/<path to device>/migration/compatible specifies the list of
> >compatible devices of a device. as in the example, compatible devices
> >could have
> >	device_type == vfio_pci &&
> >	device_id == 8086591d   &&
> >	software_version == 1.0.0 &&
> >        (
> >	(mdev_type of i915-GVTg_V5_2 && aggregator==1) ||
> >	(mdev_type of i915-GVTg_V5_4 && aggregator==2) ||
> >	(mdev_type of i915-GVTg_V5_8 && aggregator=4)
> >	)
> >
> >by comparing whether a target device is in compatible list of source
> >device, the user space can know whether a two devices are live migration
> >compatible.
> >
> >Additional notes:
> >1)software_version in the compatible list may not be necessary as it
> >already has a major.minor.bugfix scheme.
> >2)for vendor attribute like remote_url, it may not be statically
> >assigned and could be changed with a device interface.
> >
> >So, as Cornelia pointed that it's not good to use complex format in
> >a sysfs attribute, we'd like to know whether there're other good ways to
> >our use case, e.g. splitting a single attribute to multiple simple sysfs
> >attributes as what Cornelia suggested or devlink that Jason has strongly
> >recommended.
> 
> Hi Yan.
> 
Hi Jiri,
> Thanks for the explanation, I'm still fuzzy about the details.
> Anyway, I suggest you to check "devlink dev info" command we have
> implemented for multiple drivers. You can try netdevsim to test this.
> I think that the info you need to expose might be put there.
do you mean drivers/net/netdevsim/ ?
> 
> Devlink creates instance per-device. Specific device driver calls into
> devlink core to create the instance.  What device do you have? What
the devlink core is net/core/devlink.c ?

> driver is it handled by?

It looks that the devlink is for network device specific, and in
devlink.h, it says
include/uapi/linux/devlink.h - Network physical device Netlink
interface, I feel like it's not very appropriate for a GPU driver to use
this interface. Is that right?

Thanks
Yan
 
