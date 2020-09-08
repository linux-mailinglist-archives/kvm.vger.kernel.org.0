Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F892260BCB
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIHHSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:18:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:30573 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgIHHR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:17:58 -0400
IronPort-SDR: Xk8CKzGo3Fs2RKo8r4urjeB0fVtMMi+aKgo1BSkcfOgYvGT1OB0YoaxAkXaCTMD52G1Jlrxvw7
 cexzOBhQadKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="159058709"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="159058709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 00:17:57 -0700
IronPort-SDR: k3dJR9sgxjeecLR+PyXWZPw2gWEd7XZnay9oDGqJ3JtZaj6AGpt3+5/pg0/IsDNr1vZ9ER/Wj0
 v3HV15uxN4Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="448677676"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2020 00:17:55 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     mdf@kernel.org, alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-fpga@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     trix@redhat.com, lgoncalv@redhat.com, yilun.xu@intel.com
Subject: [PATCH 0/3] add VFIO mdev support for DFL devices
Date:   Tue,  8 Sep 2020 15:13:29 +0800
Message-Id: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches depend on the patchset: "Modularization of DFL private
feature drivers" & "add dfl bus support to MODULE_DEVICE_TABLE()"

https://lore.kernel.org/linux-fpga/1599488581-16386-1-git-send-email-yilun.xu@intel.com/

This patchset provides an VFIO Mdev driver for dfl devices. It makes
possible for dfl devices be direct accessed from userspace.

Xu Yilun (3):
  fpga: dfl: add driver_override support
  fpga: dfl: VFIO mdev support for DFL devices
  Documentation: fpga: dfl: Add description for VFIO Mdev support

 Documentation/ABI/testing/sysfs-bus-dfl |  20 ++
 Documentation/fpga/dfl.rst              |  20 ++
 drivers/fpga/Kconfig                    |   9 +
 drivers/fpga/Makefile                   |   1 +
 drivers/fpga/dfl.c                      |  54 ++++-
 drivers/fpga/vfio-mdev-dfl.c            | 391 ++++++++++++++++++++++++++++++++
 include/linux/fpga/dfl-bus.h            |   2 +
 7 files changed, 496 insertions(+), 1 deletion(-)
 create mode 100644 drivers/fpga/vfio-mdev-dfl.c

-- 
2.7.4

