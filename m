Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDB433C82
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 02:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfFDAkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 20:40:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:31379 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfFDAkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 20:40:14 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 17:40:13 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jun 2019 17:40:09 -0700
Date:   Mon, 3 Jun 2019 20:34:22 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>
Subject: Re: [PATCH v4 0/2] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20190604003422.GA30229@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20190531004438.24528-1-yan.y.zhao@intel.com>
 <20190603132932.1b5dc7fe@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603132932.1b5dc7fe@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 03:29:32AM +0800, Alex Williamson wrote:
> On Thu, 30 May 2019 20:44:38 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > This patchset introduces a migration_version attribute under sysfs of VFIO
> > Mediated devices.
> > 
> > This migration_version attribute is used to check migration compatibility
> > between two mdev devices of the same mdev type.
> > 
> > Patch 1 defines migration_version attribute in
> > Documentation/vfio-mediated-device.txt
> > 
> > Patch 2 uses GVT as an example to show how to expose migration_version
> > attribute and check migration compatibility in vendor driver.
> 
> Thanks for iterating through this, it looks like we've settled on
> something reasonable, but now what?  This is one piece of the puzzle to
> supporting mdev migration, but I don't think it makes sense to commit
> this upstream on its own without also defining the remainder of how we
> actually do migration, preferably with more than one working
> implementation and at least prototyped, if not final, QEMU support.  I
> hope that was the intent, and maybe it's now time to look at the next
> piece of the puzzle.  Thanks,
> 
> Alex

Got it. 
Also thank you and all for discussing and guiding all along:)
We'll move to the next episode now.

Thanks
Yan
