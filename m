Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7088215FC7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 10:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfEGIvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 04:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfEGIvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 04:51:42 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E04966993;
        Tue,  7 May 2019 08:51:41 +0000 (UTC)
Received: from gondolin (dhcp-192-187.str.redhat.com [10.33.192.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB47C171C5;
        Tue,  7 May 2019 08:51:28 +0000 (UTC)
Date:   Tue, 7 May 2019 10:51:26 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH 1/2] vfio/mdev: add version field as mandatory attribute
 for mdev device
Message-ID: <20190507105126.4be3a6da.cohuck@redhat.com>
In-Reply-To: <20190507053913.GA14284@joy-OptiPlex-7040>
References: <20190419083258.19580-1-yan.y.zhao@intel.com>
        <20190419083505.19654-1-yan.y.zhao@intel.com>
        <20190423115932.42619422.cohuck@redhat.com>
        <20190424031036.GB26247@joy-OptiPlex-7040>
        <20190424095624.0ce97328.cohuck@redhat.com>
        <20190424081558.GE26247@joy-OptiPlex-7040>
        <20190430172908.2ae77fa9.cohuck@redhat.com>
        <20190507053913.GA14284@joy-OptiPlex-7040>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 07 May 2019 08:51:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 May 2019 01:39:13 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, Apr 30, 2019 at 11:29:08PM +0800, Cornelia Huck wrote:

> > If I followed the discussion correctly, I think you plan to drop this
> > format, don't you? I'd be happy if a vendor driver can use a simple
> > number without any prefixes if it so chooses.
> > 
> > I also like the idea of renaming this "migration_version" so that it is
> > clear we're dealing with versioning of the migration capability (and
> > not a version of the device or so).  
> hi Cornelia,
> sorry I just saw this mail after sending v2 of this patch set...
> yes, I dropped the common part and vendor driver now can define whatever it
> wishes to identify a device version.

Ok, I'll look at v2.

> However, I don't agree to rename it to "migration_version", as it still may
> bring some kind of confusing with the migration version a vendor driver is
> using, e.g. vendor driver changes migration code and increases that migration
> version.
> In fact, what info we want to get from this attribute is whether this mdev
> device is compatible with another mdev device, which is tied to device, and not
> necessarily bound to migration.
> 
> do you think so?

I'm not 100% convinced; but we can continue the discussion on v2.
