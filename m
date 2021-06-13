Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55443A5853
	for <lists+kvm@lfdr.de>; Sun, 13 Jun 2021 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhFMMtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 08:49:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:40833 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhFMMtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Jun 2021 08:49:39 -0400
IronPort-SDR: q8C3C6gdMFXQERFFN2eTntN+/9ubt5Unbh5F1QnXFjdimfFxLjPvqyEX52KQMIpR7Gnl+rENez
 Ws5x/tpoKGbg==
X-IronPort-AV: E=McAfee;i="6200,9189,10013"; a="227158357"
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="227158357"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2021 05:47:38 -0700
IronPort-SDR: Iho/OtFheBiI/TyskV5pyURKpqkc0UdJmuoFy9pzwGLLqGpfFya8ngigiKRAN6gy4MOqp9vLBx
 FpgUAlq2zjwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="487109867"
Received: from sunyi-u2010.sh.intel.com ([10.239.48.3])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2021 05:47:36 -0700
From:   Yi Sun <yi.sun@intel.com>
To:     nadav.amit@gmail.com, yi.sun@intel.com, kvm@vger.kernel.org
Cc:     gordon.jin@intel.com
Subject: [PATCH v3 0/2] Wrap EFL binaries into ISO images 
Date:   Sun, 13 Jun 2021 20:47:22 +0800
Message-Id: <20210613124724.1850051-1-yi.sun@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set make use of tool 'grub-mkrescue' to wrap ELF binaries 
into bootable ISO images.

Cases in kvm-unit-tests can be run with QEMU. But the problem is that
some newer VMMs such as Crosvm/Cloud-hyperviosr does NOT support 
multiboot protocol with which QEMU loads and executes those testing 
binaries correctly. This patch set can wrap each kvm-unit-tests EFL 
binaries into a bootable ISO image aiming to adapt it to more usage 
scenarios. As we know, all PC BIOSes and vBIOSes know how to boot 
from a ISO from CD-ROM drive, hence it can extend the KVM-unit-tests 
a lot.

The patch set provides two approaches to create ISO. One is via 
"make iso". It wrap each ELF in foler x86 into a ISO without any 
parameters passed to the test cases.  The other is via script 
create_iso.sh. The script wraps the ELF according to the configure
file unittests.cfg which descripes various parameters for each testing.

Patch History:
V1: Initial version.
V2: Add the second parament to the script create_iso.sh, that could 
pass environment variables into test cases via the file.
V3: Add some failure handle.

 lib/grub/grub.cfg   |   7 +++
 x86/Makefile.common |  18 +++++++-
 x86/create_iso.sh   | 110 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 lib/grub/grub.cfg
 create mode 100755 x86/create_iso.sh

-- 
2.27.0

