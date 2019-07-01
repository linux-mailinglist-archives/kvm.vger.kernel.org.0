Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBBB14374
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 03:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfEFBwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 21:52:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:18307 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEFBwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 21:52:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 18:52:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="140310192"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by orsmga008.jf.intel.com with ESMTP; 05 May 2019 18:52:35 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     arei.gonglei@huawei.com, aik@ozlabs.ru,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        qemu-devel@nongnu.org, eauger@redhat.com, yi.l.liu@intel.com,
        ziye.yang@intel.com, mlevitsk@redhat.com, pasic@linux.ibm.com,
        felipe@nutanix.com, changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/2] introduction of version attribute for VFIO live migration
Date:   Sun,  5 May 2019 21:45:14 -0400
Message-Id: <20190506014514.3555-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset introduces a version attribute under sysfs of VFIO Mediated
devices.

This version attribute is used to check whether two mdev devices are
compatible.
user space software can take advantage of this version attribute to
determine whether to launch live migration between two mdev devices.

Patch 1 defines version attribute in Documentation/vfio-mediated-device.txt

Patch 2 uses GVT as an example to show how to expose version attribute and
check device compatibility in vendor driver.


v2:
1. renamed patched 1
2. made definition of device version string completely private to vendor
   driver
3. abandoned changes to sample mdev drivers
4. described intent and usage of version attribute more clearly.

Yan Zhao (2):
  vfio/mdev: add version attribute for mdev device
  drm/i915/gvt: export mdev device version to sysfs for Intel vGPU

 Documentation/vfio-mediated-device.txt    | 135 ++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/Makefile         |   2 +-
 drivers/gpu/drm/i915/gvt/device_version.c |  84 ++++++++++++++
 drivers/gpu/drm/i915/gvt/gvt.c            |  51 ++++++++
 drivers/gpu/drm/i915/gvt/gvt.h            |   6 +
 5 files changed, 277 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/i915/gvt/device_version.c

-- 
2.17.1

