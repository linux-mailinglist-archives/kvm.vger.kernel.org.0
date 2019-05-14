Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE99B1C398
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfENHDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 03:03:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfENHDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 03:03:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84137307D941;
        Tue, 14 May 2019 07:03:42 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F266160C4D;
        Tue, 14 May 2019 07:03:28 +0000 (UTC)
Date:   Tue, 14 May 2019 09:03:26 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Erik Skultety <eskultet@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
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
        "Tian, Kevin" <kevin.tian@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190514090326.2f4288ae.cohuck@redhat.com>
In-Reply-To: <20190514061235.GC20407@joy-OptiPlex-7040>
References: <20190506014904.3621-1-yan.y.zhao@intel.com>
        <20190507151826.502be009@x1.home>
        <20190509173839.2b9b2b46.cohuck@redhat.com>
        <20190509154857.GF2868@work-vm>
        <20190509175404.512ae7aa.cohuck@redhat.com>
        <20190509164825.GG2868@work-vm>
        <20190510110838.2df4c4d0.cohuck@redhat.com>
        <20190510093608.GD2854@work-vm>
        <20190510114838.7e16c3d6.cohuck@redhat.com>
        <20190513132804.GD11139@beluga.usersys.redhat.com>
        <20190514061235.GC20407@joy-OptiPlex-7040>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 14 May 2019 07:03:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 02:12:35 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Mon, May 13, 2019 at 09:28:04PM +0800, Erik Skultety wrote:

> > In case of libvirt checking the compatibility, it won't matter how good the
> > error message in the kernel log is and regardless of how many error states you
> > want to handle, libvirt's only limited to errno here, since we're going to do
> > plain read/write, so our internal error message returned to the user is only
> > going to contain what the errno says - okay, of course we can (and we DO)
> > provide libvirt specific string, further specifying the error but like I
> > mentioned, depending on how many error cases we want to distinguish this may be
> > hard for anyone to figure out solely on the error code, as apps will most
> > probably not parse the
> > logs.
> > 
> > Regards,
> > Erik  
> hi Erik
> do you mean you are agreeing on defining common errors and only returning errno?
> 
> e.g.
> #define ENOMIGRATION         140  /* device not supporting migration */
> #define EUNATCH              49  /* software version not match */
> #define EHWNM                142  /* hardware not matching*/

Defining custom error codes is probably not such a good idea... can we
match to common error codes instead? Do we have a good idea about
common error categories, anyway?

(Btw: does libvirt do a generic error-to-description translation, or
does it match to the context? I.e., can libvirt translate well-defined
error codes to a useful message for a specific case?)
