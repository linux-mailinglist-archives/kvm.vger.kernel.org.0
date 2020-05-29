Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7875E1E74CC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 06:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgE2EZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 00:25:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:39685 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgE2EZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 00:25:17 -0400
IronPort-SDR: YnmGchEwzcww1ijJDYeAp9MxNeSlM9w2VOxQW2h1WWYiar7G/y8vE/xIeXoMWxjconti4Mao65
 bRwytFRGU3WA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:25:16 -0700
IronPort-SDR: LbimR6ujBCgASJuPZXnR+I9UPBzufB/aMJUq2aUy/HaeKwBGRfuKRCo7pz21sinVhhdMj1UGnA
 IJvBOc/sk6OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414847654"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:25:11 -0700
Date:   Fri, 29 May 2020 00:15:17 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, jonathan.davies@nutanix.com, eauger@redhat.com,
        aik@ozlabs.ru, pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200529041516.GE1378@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home>
 <20200525065925.GA698@joy-OptiPlex-7040>
 <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
 <20200526141939.2632f100@x1.home>
 <20200527062358.GD19560@joy-OptiPlex-7040>
 <20200527084822.GC3001@work-vm>
 <20200528165906.7d03f689@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528165906.7d03f689@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 28, 2020 at 04:59:06PM -0600, Alex Williamson wrote:
> On Wed, 27 May 2020 09:48:22 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > * Yan Zhao (yan.y.zhao@intel.com) wrote:
> > > BTW, for viommu, the downtime data is as below. under the same network
> > > condition and guest memory size, and no running dirty data/memory produced
> > > by device.
> > > (1) viommu off
> > > single-round dirty query: downtime ~100ms   
> > 
> > Fine.
> > 
> > > (2) viommu on
> > > single-round dirty query: downtime 58s   
> > 
> > Youch.
> 
> Double Youch!  But we believe this is because we're getting the dirty
> bitmap one IOMMU leaf page at a time, right?  We've enable the kernel
> to get a dirty bitmap across multiple mappings, but QEMU isn't yet
> taking advantage of it.  Do I have this correct?  Thanks,
>
Yes, I think so, but I haven't looked into it yet.

Thanks
Yan
