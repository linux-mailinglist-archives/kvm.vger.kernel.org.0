Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3817833919
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFCT3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 15:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfFCT3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 15:29:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13F7581E07;
        Mon,  3 Jun 2019 19:29:42 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E968A17ADA;
        Mon,  3 Jun 2019 19:29:32 +0000 (UTC)
Date:   Mon, 3 Jun 2019 13:29:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, aik@ozlabs.ru,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        qemu-devel@nongnu.org, eauger@redhat.com, yi.l.liu@intel.com,
        ziye.yang@intel.com, mlevitsk@redhat.com, pasic@linux.ibm.com,
        felipe@nutanix.com, changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, eskultet@redhat.com, dgilbert@redhat.com,
        cohuck@redhat.com, kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v4 0/2] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20190603132932.1b5dc7fe@x1.home>
In-Reply-To: <20190531004438.24528-1-yan.y.zhao@intel.com>
References: <20190531004438.24528-1-yan.y.zhao@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 03 Jun 2019 19:29:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 May 2019 20:44:38 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This patchset introduces a migration_version attribute under sysfs of VFIO
> Mediated devices.
> 
> This migration_version attribute is used to check migration compatibility
> between two mdev devices of the same mdev type.
> 
> Patch 1 defines migration_version attribute in
> Documentation/vfio-mediated-device.txt
> 
> Patch 2 uses GVT as an example to show how to expose migration_version
> attribute and check migration compatibility in vendor driver.

Thanks for iterating through this, it looks like we've settled on
something reasonable, but now what?  This is one piece of the puzzle to
supporting mdev migration, but I don't think it makes sense to commit
this upstream on its own without also defining the remainder of how we
actually do migration, preferably with more than one working
implementation and at least prototyped, if not final, QEMU support.  I
hope that was the intent, and maybe it's now time to look at the next
piece of the puzzle.  Thanks,

Alex
