Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6454D264104
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgIJJMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:12:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:32976 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgIJJMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:12:23 -0400
IronPort-SDR: R+hbwZWSWxT419Ayjfrwxq0DPboX6tW2OieS87kchHi7Q2hgQ6LiWnVMEmLIFMrYXt321eqKIZ
 Y8ExM/BXttjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="155957847"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="155957847"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 02:12:23 -0700
IronPort-SDR: 9YX5pnQv+WO3E0ckxuRb/tHg1KSHKHbwJ64i9ZI6LJipe4tqLHaKYR6uFRhKxpLZUFhmD0bAZu
 JxSstQynzFlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="304822090"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga006.jf.intel.com with ESMTP; 10 Sep 2020 02:12:21 -0700
Date:   Thu, 10 Sep 2020 17:08:05 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Tom Rix <trix@redhat.com>
Cc:     mdf@kernel.org, alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-fpga@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgoncalv@redhat.com
Subject: Re: [PATCH 0/3] add VFIO mdev support for DFL devices
Message-ID: <20200910090805.GE16318@yilunxu-OptiPlex-7050>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
 <93200a4f-55a3-0798-3ef2-e0467288d5ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93200a4f-55a3-0798-3ef2-e0467288d5ba@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi tom:

The generic workflow of mdev is described in
Documentation/driver-api/vfio-mediated-device.rst, I could also share
some code offline.

But now I got the comments from Alex that it may not suitable we
implement the mdev for dfl devices. I think we need to first of all
reconsider the design.

Thanks,
Yilun 

On Wed, Sep 09, 2020 at 02:13:59PM -0700, Tom Rix wrote:
> This is a new interface, the documentation needs to go
> 
> into greater detail. I am particularly interested in the user workflow.
> 
> This seems like it would work only for kernel modules. 
> 
> Please describe both in the documentation.
> 
> A sample of a user mode driver would be helpful.
> 
> Is putting driver_override using sysfs for each device scalable ? would a list sets of {feature id,files}'s the vfio driver respond to better ? 
> 
> To be consistent the mdev driver file name should be dfl-vfio-mdev.c
> 
> There should be an opt-in flag for drivers being overridden instead of blanket approval of all drivers.
> 
> Tom
> 
> On 9/8/20 12:13 AM, Xu Yilun wrote:
> > These patches depend on the patchset: "Modularization of DFL private
> > feature drivers" & "add dfl bus support to MODULE_DEVICE_TABLE()"
> >
> > https://lore.kernel.org/linux-fpga/1599488581-16386-1-git-send-email-yilun.xu@intel.com/
> >
> > This patchset provides an VFIO Mdev driver for dfl devices. It makes
> > possible for dfl devices be direct accessed from userspace.
> >
> > Xu Yilun (3):
> >   fpga: dfl: add driver_override support
> >   fpga: dfl: VFIO mdev support for DFL devices
> >   Documentation: fpga: dfl: Add description for VFIO Mdev support
> >
> >  Documentation/ABI/testing/sysfs-bus-dfl |  20 ++
> >  Documentation/fpga/dfl.rst              |  20 ++
> >  drivers/fpga/Kconfig                    |   9 +
> >  drivers/fpga/Makefile                   |   1 +
> >  drivers/fpga/dfl.c                      |  54 ++++-
> >  drivers/fpga/vfio-mdev-dfl.c            | 391 ++++++++++++++++++++++++++++++++
> >  include/linux/fpga/dfl-bus.h            |   2 +
> >  7 files changed, 496 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/fpga/vfio-mdev-dfl.c
> >
