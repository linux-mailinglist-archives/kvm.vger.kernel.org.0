Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0039E1C7D2
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfENLaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 07:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfENLaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 07:30:23 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C265A3082E5A;
        Tue, 14 May 2019 11:30:22 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04D9760BCF;
        Tue, 14 May 2019 11:30:09 +0000 (UTC)
Date:   Tue, 14 May 2019 13:30:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Erik Skultety <eskultet@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
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
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190514133007.5e1c6c2e.cohuck@redhat.com>
In-Reply-To: <20190514110143.GD2753@work-vm>
References: <20190510110838.2df4c4d0.cohuck@redhat.com>
        <20190510093608.GD2854@work-vm>
        <20190510114838.7e16c3d6.cohuck@redhat.com>
        <20190513132804.GD11139@beluga.usersys.redhat.com>
        <20190514061235.GC20407@joy-OptiPlex-7040>
        <20190514072039.GA2089@beluga.usersys.redhat.com>
        <20190514073219.GD20407@joy-OptiPlex-7040>
        <20190514074344.GB2089@beluga.usersys.redhat.com>
        <20190514074736.GE20407@joy-OptiPlex-7040>
        <20190514115135.078bbaf7.cohuck@redhat.com>
        <20190514110143.GD2753@work-vm>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 14 May 2019 11:30:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 12:01:45 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Cornelia Huck (cohuck@redhat.com) wrote:
> > On Tue, 14 May 2019 03:47:36 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:

> > > hi Cornelia and Dave,
> > > do you also agree on:
> > > 1. "not to define the specific errno returned for a specific situation,
> > > let the vendor driver decide, userspace simply needs to know that an errno on
> > > read indicates the device does not support migration version comparison and
> > > that an errno on write indicates the devices are incompatible or the target
> > > doesn't support migration versions. "
> > > 2. vendor driver should log detailed error reasons in kernel log.  
> > 
> > Two questions:
> > - How reasonable is it to refer to the system log in order to find out
> >   what exactly went wrong?
> > - If detailed error reporting is basically done to the syslog, do
> >   different error codes still provide useful information? Or should the
> >   vendor driver decide what it wants to do?  
> 
> I don't see error codes as being that helpful; if we can't actually get
> an error message back up the stack (which was my preference), then I guess
> syslog is as good as it will get.

Ok, so letting the vendor driver simply return an(y) error and possibly
dumping an error message into the syslog seems to be the most
reasonable approach.
