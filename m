Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4480D305E6
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 02:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfEaAur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 20:50:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:42235 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfEaAur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 20:50:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 17:50:46 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by orsmga001.jf.intel.com with ESMTP; 30 May 2019 17:50:40 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 0/2] introduction of migration_version attribute for VFIO live migration
Date:   Thu, 30 May 2019 20:44:38 -0400
Message-Id: <20190531004438.24528-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset introduces a migration_version attribute under sysfs of VFIO
Mediated devices.

This migration_version attribute is used to check migration compatibility
between two mdev devices of the same mdev type.

Patch 1 defines migration_version attribute in
Documentation/vfio-mediated-device.txt

Patch 2 uses GVT as an example to show how to expose migration_version
attribute and check migration compatibility in vendor driver.

v4:
1. fixed indentation/spell errors, reworded several error messages
2. added a missing memory free for error handling in patch 2

v3:
1. renamed version to migration_version
2. let errno to be freely defined by vendor driver
3. let checking mdev_type be prerequisite of migration compatibility check
4. reworded most part of patch 1
5. print detailed error log in patch 2 and generate migration_version
string at init time

v2:
1. renamed patched 1
2. made definition of device version string completely private to vendor
driver
3. reverted changes to sample mdev drivers
4. described intent and usage of version attribute more clearly.


Yan Zhao (2):
  vfio/mdev: add migration_version attribute for mdev device
  drm/i915/gvt: export migration_version to mdev sysfs for Intel vGPU

 Documentation/vfio-mediated-device.txt       | 113 +++++++++++++
 drivers/gpu/drm/i915/gvt/Makefile            |   2 +-
 drivers/gpu/drm/i915/gvt/gvt.c               |  39 +++++
 drivers/gpu/drm/i915/gvt/gvt.h               |   5 +
 drivers/gpu/drm/i915/gvt/migration_version.c | 168 +++++++++++++++++++
 drivers/gpu/drm/i915/gvt/vgpu.c              |  13 +-
 6 files changed, 337 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/gvt/migration_version.c

-- 
2.17.1

