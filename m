Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CA046B7CD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhLGJsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:48:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:52335 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhLGJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:48:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323796363"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="323796363"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 01:44:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515207310"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2021 01:44:35 -0800
From:   Yi Sun <yi.sun@intel.com>
To:     yi.sun@linux.intel.com, yi.sun@intel.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH RESEND v3 0/2] Wrap EFL binaries into ISO images 
Date:   Tue,  7 Dec 2021 17:44:30 +0800
Message-Id: <20211207094432.189576-1-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set make use of tool 'grub-mkrescue' to wrap ELF binaries into bootable ISO images.

Cases in kvm-unit-tests can be run with QEMU. But the problem is that some newer VMMs such as Crosvm/Cloud-hyperviosr does NOT support multiboot protocol with which QEMU loads and executes those testing binaries correctly. This patch set can wrap each kvm-unit-tests EFL binaries into a bootable ISO image aiming to adapt it to more usage scenarios. As we know, all PC BIOSes and vBIOSes know how to boot from a ISO from CD-ROM drive, hence it can extend the KVM-unit-tests a lot.

The patch set provides two approaches to create ISO. One is via "make iso". It wrap each ELF in foler x86 into a ISO without any parameters passed to the test cases.  The other is via script create_iso.sh. The script wraps the ELF according to the configure file unittests.cfg which descripes various parameters for each testing.

Patch History:
V1: Initial version.
V2: Add the second parament to the script create_iso.sh, that could pass environment variables into test cases via the file.
V3: Add some failure handle.


Yi Sun (2):
  x86: Build ISO images from x86/*.elf
  x86: Create ISO images according to unittests.cfg

 lib/grub/grub.cfg   |   7 +++
 x86/Makefile.common |  18 ++++++-
 x86/create_iso.sh   | 112 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 lib/grub/grub.cfg
 create mode 100755 x86/create_iso.sh

-- 
2.27.0

