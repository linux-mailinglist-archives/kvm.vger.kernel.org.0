Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4813070B9
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhA1IJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:09:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:16602 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhA1IIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 03:08:37 -0500
IronPort-SDR: pk1OdI9ITonkx2UwJ1X5Le5lSh4E37oVNax9bSoG1nGaq4sKVtUpcXvs3Ow9j8mnOM+ZUO9qsc
 SXL46mq1osgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="177632199"
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="177632199"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 00:06:34 -0800
IronPort-SDR: gwiJP6YaMxuscNhGYPs0q08Q4i/JkVYx3t24FPKwU8pngfnoy909ERwqCSOOScAVkG9IYu04mC
 PrqVQUjmjn8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="362770166"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.148])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jan 2021 00:06:33 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Documentation: Fix documentation for nested.
Date:   Thu, 28 Jan 2021 23:47:47 +0800
Message-Id: <20210128154747.4242-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested VMX was enabled by default in commit <1e58e5e59148> ("KVM:
VMX: enable nested virtualization by default"), which was merged
in Linux 4.20. This patch is to fix the documentation accordingly.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 Documentation/virt/kvm/nested-vmx.rst            | 6 ++++--
 Documentation/virt/kvm/running-nested-guests.rst | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/nested-vmx.rst
index 6ab4e35..ac2095d 100644
--- a/Documentation/virt/kvm/nested-vmx.rst
+++ b/Documentation/virt/kvm/nested-vmx.rst
@@ -37,8 +37,10 @@ call L2.
 Running nested VMX
 ------------------
 
-The nested VMX feature is disabled by default. It can be enabled by giving
-the "nested=1" option to the kvm-intel module.
+The nested VMX feature is enabled by default since Linux kernel v4.20. For
+older Linux kernel, it can be enabled by giving the "nested=1" option to the
+kvm-intel module.
+
 
 No modifications are required to user space (qemu). However, qemu's default
 emulated CPU type (qemu64) does not list the "VMX" CPU feature, so it must be
diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documentation/virt/kvm/running-nested-guests.rst
index d0a1fc7..bd70c69 100644
--- a/Documentation/virt/kvm/running-nested-guests.rst
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -74,7 +74,7 @@ few:
 Enabling "nested" (x86)
 -----------------------
 
-From Linux kernel v4.19 onwards, the ``nested`` KVM parameter is enabled
+From Linux kernel v4.20 onwards, the ``nested`` KVM parameter is enabled
 by default for Intel and AMD.  (Though your Linux distribution might
 override this default.)
 
-- 
1.9.1

