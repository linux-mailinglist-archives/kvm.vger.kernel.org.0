Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C531BED3C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 02:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgD3Az2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 20:55:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:21869 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD3Az2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 20:55:28 -0400
IronPort-SDR: Yf20lfQHPwm6r+jBqapudIdjMW3i/G39/i6RmS3Iib2G0bB0OaJju6CBBZ//VcB6iOqAxp1SLe
 E+iqfClPvOSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 17:55:27 -0700
IronPort-SDR: +gRX2R/WV/4QXJPPo6djRHcjf8PsJ1DwkfropLFEC/MLZ7TCqHkGV7ms5qWKqZXcpf0RzixPXC
 dDGi/gCLRJ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="249600406"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 29 Apr 2020 17:55:21 -0700
Date:   Wed, 29 Apr 2020 20:45:38 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Eric Blake <eblake@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
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
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200430004537.GO12879@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200422073628.GA12879@joy-OptiPlex-7040>
 <20200424191049.GU3106@work-vm>
 <20200426013628.GC12879@joy-OptiPlex-7040>
 <20200427153743.GK2923@work-vm>
 <20200428005429.GJ12879@joy-OptiPlex-7040>
 <20200428141437.GG2794@work-vm>
 <20200429072616.GL12879@joy-OptiPlex-7040>
 <20200429082201.GA2834@work-vm>
 <20200429093555.GM12879@joy-OptiPlex-7040>
 <94cd58d2-0580-53cd-6ca2-2c33146e0f2c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94cd58d2-0580-53cd-6ca2-2c33146e0f2c@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 10:13:01PM +0800, Eric Blake wrote:
> [meta-comment]
> 
> On 4/29/20 4:35 AM, Yan Zhao wrote:
> > On Wed, Apr 29, 2020 at 04:22:01PM +0800, Dr. David Alan Gilbert wrote:
> [...]
> >>>>>>>>>>>>>>>>> This patchset introduces a migration_version attribute under sysfs
> >>>>>>>>>>> of VFIO
> >>>>>>>>>>>>>>>>> Mediated devices.
> 
> Hmm, several pages with up to 16 levels of quoting, with editors making 
> the lines ragged, all before I get to the real meat of the email. 
> Remember, it's okay to trim content,...
> 
> >> So why don't we split the difference; lets say that it should start with
> >> the hex PCI Vendor ID.
> >>
> > The problem is for mdev devices, if the parent devices are not PCI devices,
> > they don't have PCI vendor IDs.
> 
> ...to just what you are replying to.
>
sorry for that. next time I'll try to make a better balance between
keeping conversation background and leaving the real meat of the email.

Thanks for reminding.
Yan
