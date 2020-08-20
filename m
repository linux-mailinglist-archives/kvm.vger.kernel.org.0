Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B2C24AD4B
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 05:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgHTD2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 23:28:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:10221 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgHTD2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 23:28:35 -0400
IronPort-SDR: PGs0VnP9Q1TicahVMsoHD0/9N2eIIKocxRNW5aongPBryfRNNieGKlywvJTgoy2X+wCRAdQybB
 ovZYAVn0ceiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="240057695"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="240057695"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 20:28:34 -0700
IronPort-SDR: 5Ny6jA7KhA8lJCsOir9TP57QNBIByN+QNcAZddSmKuJ1rbdS7J8N1MrhVKpYdsnjbRggx0kBQc
 89JhrB8/QU8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="327281803"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2020 20:28:28 -0700
Date:   Thu, 20 Aug 2020 11:16:21 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, eskultet@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200820031621.GA24997@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200810074631.GA29059@joy-OptiPlex-7040>
 <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
 <20200814051601.GD15344@joy-OptiPlex-7040>
 <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
 <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <20200820003922.GE21172@joy-OptiPlex-7040>
 <20200819212234.223667b3@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200819212234.223667b3@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 09:22:34PM -0600, Alex Williamson wrote:
> On Thu, 20 Aug 2020 08:39:22 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, Aug 18, 2020 at 11:36:52AM +0200, Cornelia Huck wrote:
> > > On Tue, 18 Aug 2020 10:16:28 +0100
> > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > >   
> > > > On Tue, Aug 18, 2020 at 05:01:51PM +0800, Jason Wang wrote:  
> > > > >    On 2020/8/18 下午4:55, Daniel P. Berrangé wrote:
> > > > > 
> > > > >  On Tue, Aug 18, 2020 at 11:24:30AM +0800, Jason Wang wrote:
> > > > > 
> > > > >  On 2020/8/14 下午1:16, Yan Zhao wrote:
> > > > > 
> > > > >  On Thu, Aug 13, 2020 at 12:24:50PM +0800, Jason Wang wrote:
> > > > > 
> > > > >  On 2020/8/10 下午3:46, Yan Zhao wrote:    
> > > >   
> > > > >  we actually can also retrieve the same information through sysfs, .e.g
> > > > > 
> > > > >  |- [path to device]
> > > > >     |--- migration
> > > > >     |     |--- self
> > > > >     |     |   |---device_api
> > > > >     |    |   |---mdev_type
> > > > >     |    |   |---software_version
> > > > >     |    |   |---device_id
> > > > >     |    |   |---aggregator
> > > > >     |     |--- compatible
> > > > >     |     |   |---device_api
> > > > >     |    |   |---mdev_type
> > > > >     |    |   |---software_version
> > > > >     |    |   |---device_id
> > > > >     |    |   |---aggregator
> > > > > 
> > > > > 
> > > > >  Yes but:
> > > > > 
> > > > >  - You need one file per attribute (one syscall for one attribute)
> > > > >  - Attribute is coupled with kobject  
> > > 
> > > Is that really that bad? You have the device with an embedded kobject
> > > anyway, and you can just put things into an attribute group?
> > > 
> > > [Also, I think that self/compatible split in the example makes things
> > > needlessly complex. Shouldn't semantic versioning and matching already
> > > cover nearly everything? I would expect very few cases that are more
> > > complex than that. Maybe the aggregation stuff, but I don't think we
> > > need that self/compatible split for that, either.]  
> > Hi Cornelia,
> > 
> > The reason I want to declare compatible list of attributes is that
> > sometimes it's not a simple 1:1 matching of source attributes and target attributes
> > as I demonstrated below,
> > source mdev of (mdev_type i915-GVTg_V5_2 + aggregator 1) is compatible to
> > target mdev of (mdev_type i915-GVTg_V5_4 + aggregator 2),
> >                (mdev_type i915-GVTg_V5_8 + aggregator 4)
> > 
> > and aggragator may be just one of such examples that 1:1 matching does not
> > fit.
> 
> If you're suggesting that we need a new 'compatible' set for every
> aggregation, haven't we lost the purpose of aggregation?  For example,
> rather than having N mdev types to represent all the possible
> aggregation values, we have a single mdev type with N compatible
> migration entries, one for each possible aggregation value.  BTW, how do
> we have multiple compatible directories?  compatible0001,
> compatible0002? Thanks,
> 
do you think the bin_attribute I proposed yesterday good?
Then we can have a single compatible with a variable in the mdev_type and
aggregator.

   mdev_type=i915-GVTg_V5_{val1:int:2,4,8}
   aggregator={val1}/2

Thanks
Yan
