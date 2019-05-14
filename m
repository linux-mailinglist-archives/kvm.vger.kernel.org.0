Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAA61C3EB
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfENHiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:38:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:5204 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfENHiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:38:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 00:38:04 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2019 00:37:58 -0700
Date:   Tue, 14 May 2019 03:32:19 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Erik Skultety <eskultet@redhat.com>
Cc:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190514073219.GD20407@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20190509173839.2b9b2b46.cohuck@redhat.com>
 <20190509154857.GF2868@work-vm>
 <20190509175404.512ae7aa.cohuck@redhat.com>
 <20190509164825.GG2868@work-vm>
 <20190510110838.2df4c4d0.cohuck@redhat.com>
 <20190510093608.GD2854@work-vm>
 <20190510114838.7e16c3d6.cohuck@redhat.com>
 <20190513132804.GD11139@beluga.usersys.redhat.com>
 <20190514061235.GC20407@joy-OptiPlex-7040>
 <20190514072039.GA2089@beluga.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514072039.GA2089@beluga.usersys.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 03:20:40PM +0800, Erik Skultety wrote:
> On Tue, May 14, 2019 at 02:12:35AM -0400, Yan Zhao wrote:
> > On Mon, May 13, 2019 at 09:28:04PM +0800, Erik Skultety wrote:
> > > On Fri, May 10, 2019 at 11:48:38AM +0200, Cornelia Huck wrote:
> > > > On Fri, 10 May 2019 10:36:09 +0100
> > > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > > >
> > > > > * Cornelia Huck (cohuck@redhat.com) wrote:
> > > > > > On Thu, 9 May 2019 17:48:26 +0100
> > > > > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > > > > >
> > > > > > > * Cornelia Huck (cohuck@redhat.com) wrote:
> > > > > > > > On Thu, 9 May 2019 16:48:57 +0100
> > > > > > > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > > > > > > >
> > > > > > > > > * Cornelia Huck (cohuck@redhat.com) wrote:
> > > > > > > > > > On Tue, 7 May 2019 15:18:26 -0600
> > > > > > > > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > > On Sun,  5 May 2019 21:49:04 -0400
> > > > > > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > > >
> > > > > > > > > > > > +  Errno:
> > > > > > > > > > > > +  If vendor driver wants to claim a mdev device incompatible to all other mdev
> > > > > > > > > > > > +  devices, it should not register version attribute for this mdev device. But if
> > > > > > > > > > > > +  a vendor driver has already registered version attribute and it wants to claim
> > > > > > > > > > > > +  a mdev device incompatible to all other mdev devices, it needs to return
> > > > > > > > > > > > +  -ENODEV on access to this mdev device's version attribute.
> > > > > > > > > > > > +  If a mdev device is only incompatible to certain mdev devices, write of
> > > > > > > > > > > > +  incompatible mdev devices's version strings to its version attribute should
> > > > > > > > > > > > +  return -EINVAL;
> > > > > > > > > > >
> > > > > > > > > > > I think it's best not to define the specific errno returned for a
> > > > > > > > > > > specific situation, let the vendor driver decide, userspace simply
> > > > > > > > > > > needs to know that an errno on read indicates the device does not
> > > > > > > > > > > support migration version comparison and that an errno on write
> > > > > > > > > > > indicates the devices are incompatible or the target doesn't support
> > > > > > > > > > > migration versions.
> > > > > > > > > >
> > > > > > > > > > I think I have to disagree here: It's probably valuable to have an
> > > > > > > > > > agreed error for 'cannot migrate at all' vs 'cannot migrate between
> > > > > > > > > > those two particular devices'. Userspace might want to do different
> > > > > > > > > > things (e.g. trying with different device pairs).
> > > > > > > > >
> > > > > > > > > Trying to stuff these things down an errno seems a bad idea; we can't
> > > > > > > > > get much information that way.
> > > > > > > >
> > > > > > > > So, what would be a reasonable approach? Userspace should first read
> > > > > > > > the version attributes on both devices (to find out whether migration
> > > > > > > > is supported at all), and only then figure out via writing whether they
> > > > > > > > are compatible?
> > > > > > > >
> > > > > > > > (Or just go ahead and try, if it does not care about the reason.)
> > > > > > >
> > > > > > > Well, I'm OK with something like writing to test whether it's
> > > > > > > compatible, it's just we need a better way of saying 'no'.
> > > > > > > I'm not sure if that involves reading back from somewhere after
> > > > > > > the write or what.
> > > > > >
> > > > > > Hm, so I basically see two ways of doing that:
> > > > > > - standardize on some error codes... problem: error codes can be hard
> > > > > >   to fit to reasons
> > > > > > - make the error available in some attribute that can be read
> > > > > >
> > > > > > I'm not sure how we can serialize the readback with the last write,
> > > > > > though (this looks inherently racy).
> > > > > >
> > > > > > How important is detailed error reporting here?
> > > > >
> > > > > I think we need something, otherwise we're just going to get vague
> > > > > user reports of 'but my VM doesn't migrate'; I'd like the error to be
> > > > > good enough to point most users to something they can understand
> > > > > (e.g. wrong card family/too old a driver etc).
> > > >
> > > > Ok, that sounds like a reasonable point. Not that I have a better idea
> > > > how to achieve that, though... we could also log a more verbose error
> > > > message to the kernel log, but that's not necessarily where a user will
> > > > look first.
> > >
> > > In case of libvirt checking the compatibility, it won't matter how good the
> > > error message in the kernel log is and regardless of how many error states you
> > > want to handle, libvirt's only limited to errno here, since we're going to do
> > > plain read/write, so our internal error message returned to the user is only
> > > going to contain what the errno says - okay, of course we can (and we DO)
> > > provide libvirt specific string, further specifying the error but like I
> > > mentioned, depending on how many error cases we want to distinguish this may be
> > > hard for anyone to figure out solely on the error code, as apps will most
> > > probably not parse the
> > > logs.
> > >
> > > Regards,
> > > Erik
> > hi Erik
> > do you mean you are agreeing on defining common errors and only returning errno?
> 
> In a sense, yes. While it is highly desirable to have logs with descriptive
> messages which will help in troubleshooting tremendously, I wanted to point out
> that spending time with error logs may not be that worthwhile especially since
> most apps (like libvirt) will solely rely on using read(3)/write(3) to sysfs.
> That means that we're limited by the errnos available, so apart from
> reporting the generic system message we can't any more magic in terms of the
> error messages, so the driver needs to assure that a proper message is
> propagated to the journal and at best libvirt can direct the user (consumer) to
> look through the system logs for more info. I also agree with the point
> mentioned above that defining a specific errno is IMO not the way to go, as
> these would be just too specific for the read(3)/write(3) use case.
> 
> That said, from libvirt POV as a consumer, I'd expect there to be truly only 2
> errors (I believe Alex has mentioned something similar in one of his responses
> in one of the threads):
>     a) read error indicating that an mdev type doesn't support migration
>         - I assume if one type doesn't support migration, none of the other
>           types exposed on the parent device do, is that a fair assumption?
>     b) write error indicating that the mdev types are incompatible for
>     migration
> 
> Regards,
> Erik
Thanks for this explanation.
so, can we arrive at below agreements?

1. "not to define the specific errno returned for a specific situation,
let the vendor driver decide, userspace simply needs to know that an errno on
read indicates the device does not support migration version comparison and
that an errno on write indicates the devices are incompatible or the target
doesn't support migration versions. "
2. vendor driver should log detailed error reasons in kernel log. 

Thanks
Yan

> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
