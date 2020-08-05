Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354CC23CD0C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgHERSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:18:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728198AbgHERPq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 13:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wqh5Y54yRa5Ell3CvSDQvlBORfp1wfSW4h6prGelA0o=;
        b=LVwyI5EMV+/g9fhb6rphoiedgMZzxzymtXsK1q+myWDkF2dF4rc66mtFtXsb8NWTJBHXtu
        1/VE/7F7sAETOhWFtGUzx8fS6w1eK4TpjGuiAIjU17fCdYx/1A09CWBIRIVGhFQHJTCKWS
        kWpHuguz+uz+qLEDLhhGOn2m83wfzXM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-JVITltoPNCasva87CQYitg-1; Wed, 05 Aug 2020 07:35:07 -0400
X-MC-Unique: JVITltoPNCasva87CQYitg-1
Received: by mail-wm1-f71.google.com with SMTP id z1so2597320wmf.9
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 04:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wqh5Y54yRa5Ell3CvSDQvlBORfp1wfSW4h6prGelA0o=;
        b=SXEdAJA+glok7MogliSv/wBnP/gREaRMA/PmbX2JbEaIcundYtnHNbi6z5jgFFHBO7
         Upr6IQ6JTO3ccJHRPpPZ1cy56Iz0q4xzUUgmzVZyYZr0+IyA+6io3kdcdZSiyMTHlavF
         UGDL2ejebRiJnHLStAzMg714kV6OjzdjPaWGqLT2jNu3EBV3VK/NgJk3nCBynh0Q4az1
         qr02yDgFk75iKsdxMTn2PV+eazgDuIed4w76vEYrvecpOnbv//VXEfDFa8sB5jgaalmF
         ZE7GdEw51yJ+hBSkuqHSI/9ngWqfRzoI3gG3wjI1ZEvSzo/pgSv4YG0Yzs72fyQja2aA
         DkAg==
X-Gm-Message-State: AOAM5306SFX01a1wroi3oy4A9N+dTYALAsVOZW7tC3kjfJe033wo8Vq+
        j+yB8uSD5VWAimxltCxuDKxmhN8Zkz6lpJN4QsSLYgbB5t04XrRh2OWHTlO5VNrG6l4LQpdD1cr
        +HyMYfniPPuag
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr2526786wrr.426.1596627305786;
        Wed, 05 Aug 2020 04:35:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd8zrk3XL+M6scUs1DwtTce02e+SdUEmfrzO5R28SDB+n92FqioZgmMQUV+2TAz9P9uHNeYQ==
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr2526736wrr.426.1596627305447;
        Wed, 05 Aug 2020 04:35:05 -0700 (PDT)
Received: from pop-os ([2001:470:1f1d:1ea:4fde:6f63:1f5a:12b1])
        by smtp.gmail.com with ESMTPSA id z15sm2389331wrn.89.2020.08.05.04.35.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Aug 2020 04:35:04 -0700 (PDT)
Message-ID: <4cf2824c803c96496e846c5b06767db305e9fb5a.camel@redhat.com>
Subject: Re: device compatibility interface for live migration with assigned
 devices
From:   Sean Mooney <smooney@redhat.com>
To:     Jiri Pirko <jiri@mellanox.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>
Date:   Wed, 05 Aug 2020 12:35:01 +0100
In-Reply-To: <20200805105319.GF2177@nanopsycho>
References: <20200727072440.GA28676@joy-OptiPlex-7040>
         <20200727162321.7097070e@x1.home>
         <20200729080503.GB28676@joy-OptiPlex-7040>
         <20200804183503.39f56516.cohuck@redhat.com>
         <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
         <20200805021654.GB30485@joy-OptiPlex-7040>
         <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
         <20200805075647.GB2177@nanopsycho>
         <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
         <20200805093338.GC30485@joy-OptiPlex-7040>
         <20200805105319.GF2177@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-08-05 at 12:53 +0200, Jiri Pirko wrote:
> Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:
> > On Wed, Aug 05, 2020 at 04:02:48PM +0800, Jason Wang wrote:
> > > 
> > > On 2020/8/5 下午3:56, Jiri Pirko wrote:
> > > > Wed, Aug 05, 2020 at 04:41:54AM CEST, jasowang@redhat.com wrote:
> > > > > On 2020/8/5 上午10:16, Yan Zhao wrote:
> > > > > > On Wed, Aug 05, 2020 at 10:22:15AM +0800, Jason Wang wrote:
> > > > > > > On 2020/8/5 上午12:35, Cornelia Huck wrote:
> > > > > > > > [sorry about not chiming in earlier]
> > > > > > > > 
> > > > > > > > On Wed, 29 Jul 2020 16:05:03 +0800
> > > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > 
> > > > > > > > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> > > > > > > > 
> > > > > > > > (...)
> > > > > > > > 
> > > > > > > > > > Based on the feedback we've received, the previously proposed interface
> > > > > > > > > > is not viable.  I think there's agreement that the user needs to be
> > > > > > > > > > able to parse and interpret the version information.  Using json seems
> > > > > > > > > > viable, but I don't know if it's the best option.  Is there any
> > > > > > > > > > precedent of markup strings returned via sysfs we could follow?
> > > > > > > > 
> > > > > > > > I don't think encoding complex information in a sysfs file is a viable
> > > > > > > > approach. Quoting Documentation/filesystems/sysfs.rst:
> > > > > > > > 
> > > > > > > > "Attributes should be ASCII text files, preferably with only one value
> > > > > > > > per file. It is noted that it may not be efficient to contain only one
> > > > > > > > value per file, so it is socially acceptable to express an array of
> > > > > > > > values of the same type.
> > > > > > > > Mixing types, expressing multiple lines of data, and doing fancy
> > > > > > > > formatting of data is heavily frowned upon."
> > > > > > > > 
> > > > > > > > Even though this is an older file, I think these restrictions still
> > > > > > > > apply.
> > > > > > > 
> > > > > > > +1, that's another reason why devlink(netlink) is better.
> > > > > > > 
> > > > > > 
> > > > > > hi Jason,
> > > > > > do you have any materials or sample code about devlink, so we can have a good
> > > > > > study of it?
> > > > > > I found some kernel docs about it but my preliminary study didn't show me the
> > > > > > advantage of devlink.
> > > > > 
> > > > > CC Jiri and Parav for a better answer for this.
> > > > > 
> > > > > My understanding is that the following advantages are obvious (as I replied
> > > > > in another thread):
> > > > > 
> > > > > - existing users (NIC, crypto, SCSI, ib), mature and stable
> > > > > - much better error reporting (ext_ack other than string or errno)
> > > > > - namespace aware
> > > > > - do not couple with kobject
> > > > 
> > > > Jason, what is your use case?
> > > 
> > > 
> > > I think the use case is to report device compatibility for live migration.
> > > Yan proposed a simple sysfs based migration version first, but it looks not
> > > sufficient and something based on JSON is discussed.
> > > 
> > > Yan, can you help to summarize the discussion so far for Jiri as a
> > > reference?
> > > 
> > 
> > yes.
> > we are currently defining an device live migration compatibility
> > interface in order to let user space like openstack and libvirt knows
> > which two devices are live migration compatible.
> > currently the devices include mdev (a kernel emulated virtual device)
> > and physical devices (e.g.  a VF of a PCI SRIOV device).
> > 
> > the attributes we want user space to compare including
> > common attribues:
> >    device_api: vfio-pci, vfio-ccw...
> >    mdev_type: mdev type of mdev or similar signature for physical device
> >               It specifies a device's hardware capability. e.g.
> > 	       i915-GVTg_V5_4 means it's of 1/4 of a gen9 Intel graphics
> > 	       device.
by the way this nameing sceam works the opisite of how it would have expected
i woudl have expected to i915-GVTg_V5 to be the same as i915-GVTg_V5_1 and 
i915-GVTg_V5_4 to use 4 times the amount of resouce as i915-GVTg_V5_1 not 1 quarter.

i would much rather see i915-GVTg_V5_4 express as aggreataor:i915-GVTg_V5=4
e.g. that it is 4 of the basic i915-GVTg_V5 type
the invertion of the relationship makes this much harder to resonabout IMO.

if i915-GVTg_V5_8 and i915-GVTg_V5_4 are both actully claiming the same resouce
and both can be used at the same time with your suggested nameing scemem i have have
to fine the mdevtype with the largest value and store that then do math by devidign it by the suffix
of the requested type every time i want to claim the resouce in our placement inventoies.

if we represent it the way i suggest we dont
if it i915-GVTg_V5_8 i know its using 8 of i915-GVTg_V5
it makes it significantly simpler.

> >    software_version: device driver's version.
> >               in <major>.<minor>[.bugfix] scheme, where there is no
> > 	       compatibility across major versions, minor versions have
> > 	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
> > 	       bugfix version number indicates some degree of internal
> > 	       improvement that is not visible to the user in terms of
> > 	       features or compatibility,
> > 
> > vendor specific attributes: each vendor may define different attributes
> >   device id : device id of a physical devices or mdev's parent pci device.
> >               it could be equal to pci id for pci devices
> >   aggregator: used together with mdev_type. e.g. aggregator=2 together
> >               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
> > 	       graphics device.
> >   remote_url: for a local NVMe VF, it may be configured with a remote
> >               url of a remote storage and all data is stored in the
> > 	       remote side specified by the remote url.
> >   ...
just a minor not that i find ^ much more simmple to understand then
the current proposal with self and compatiable.
if i have well defiend attibute that i can parse and understand that allow
me to calulate the what is and is not compatible that is likely going to
more useful as you wont have to keep maintianing a list of other compatible
devices every time a new sku is released.

in anycase thank for actully shareing ^ as it make it simpler to reson about what
you have previously proposed.
> > 
> > Comparing those attributes by user space alone is not an easy job, as it
> > can't simply assume an equal relationship between source attributes and
> > target attributes. e.g.
> > for a source device of mdev_type=i915-GVTg_V5_4,aggregator=2, (1/2 of
> > gen9), it actually could find a compatible device of
> > mdev_type=i915-GVTg_V5_8,aggregator=4 (also 1/2 of gen9),
> > if mdev_type of i915-GVTg_V5_4 is not available in the target machine.
> > 
> > So, in our current proposal, we want to create two sysfs attributes
> > under a device sysfs node.
> > /sys/<path to device>/migration/self
> > /sys/<path to device>/migration/compatible
> > 
> > #cat /sys/<path to device>/migration/self
> > device_type=vfio_pci
> > mdev_type=i915-GVTg_V5_4
> > device_id=8086591d
> > aggregator=2
> > software_version=1.0.0
> > 
> > #cat /sys/<path to device>/migration/compatible
> > device_type=vfio_pci
> > mdev_type=i915-GVTg_V5_{val1:int:2,4,8}
> > device_id=8086591d
> > aggregator={val1}/2
> > software_version=1.0.0
> > 
> > The /sys/<path to device>/migration/self specifies self attributes of
> > a device.
> > The /sys/<path to device>/migration/compatible specifies the list of
> > compatible devices of a device. as in the example, compatible devices
> > could have
> > 	device_type == vfio_pci &&
> > 	device_id == 8086591d   &&
> > 	software_version == 1.0.0 &&
> >        (
> > 	(mdev_type of i915-GVTg_V5_2 && aggregator==1) ||
> > 	(mdev_type of i915-GVTg_V5_4 && aggregator==2) ||
> > 	(mdev_type of i915-GVTg_V5_8 && aggregator=4)
> > 	)
> > 
> > by comparing whether a target device is in compatible list of source
> > device, the user space can know whether a two devices are live migration
> > compatible.
> > 
> > Additional notes:
> > 1)software_version in the compatible list may not be necessary as it
> > already has a major.minor.bugfix scheme.
> > 2)for vendor attribute like remote_url, it may not be statically
> > assigned and could be changed with a device interface.
> > 
> > So, as Cornelia pointed that it's not good to use complex format in
> > a sysfs attribute, we'd like to know whether there're other good ways to
> > our use case, e.g. splitting a single attribute to multiple simple sysfs
> > attributes as what Cornelia suggested or devlink that Jason has strongly
> > recommended.
> 
> Hi Yan.
> 
> Thanks for the explanation, I'm still fuzzy about the details.
> Anyway, I suggest you to check "devlink dev info" command we have
> implemented for multiple drivers.

is devlink exposed as a filesytem we can read with just open?
openstack will likely try to leverage libvirt to get this info but when we
cant its much simpler to read sysfs then it is to take a a depenency on a commandline
too and have to fork shell to execute it and parse the cli output.
pyroute2 which we use in some openstack poject has basic python binding for devlink but im not
sure how complete it is as i think its relitivly new addtion. if we need to take a dependcy
we will but that would be a drawback fo devlink not that that is a large one just something
to keep in mind.

>  You can try netdevsim to test this.
> I think that the info you need to expose might be put there.
> 
> Devlink creates instance per-device. Specific device driver calls into
> devlink core to create the instance.  What device do you have? What
> driver is it handled by?
> 
> 
> > 
> > Thanks
> > Yan
> > 
> > 
> > 
> 
> 

