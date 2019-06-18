Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496F44AE34
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfFRWvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:51708 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfFRWvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009389"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 15/17] x86/split_lock: Add documentation for split lock detection interface
Date:   Tue, 18 Jun 2019 15:41:17 -0700
Message-Id: <1560897679-228028-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is useful for development and debugging to document the new debugfs
interface /sys/kernel/debug/x86/split_lock_detect.

A new debugfs documentation is created to describe the split lock detection
interface. In the future, more entries may be added in the documentation to
describe other interfaces under /sys/kernel/debug/x86 directory.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/ABI/testing/debugfs-x86 | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-x86

diff --git a/Documentation/ABI/testing/debugfs-x86 b/Documentation/ABI/testing/debugfs-x86
new file mode 100644
index 000000000000..17a1e9ed6712
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-x86
@@ -0,0 +1,21 @@
+What:		/sys/kernel/debugfs/x86/split_lock_detect
+Date:		May 2019
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	(RW) Control split lock detection on Intel Tremont and
+		future CPUs
+
+		Reads return split lock detection status:
+			0: disabled
+			1: enabled
+
+		Writes enable or disable split lock detection:
+			The first character is one of 'Nn0' or [oO][fF] for off
+			disables the feature.
+			The first character is one of 'Yy1' or [oO][nN] for on
+			enables the feature.
+
+		Please note the interface only shows or controls global setting.
+		During run time, split lock detection on one CPU may be
+		disabled if split lock operation in kernel code happens on
+		the CPU. The interface doesn't show or control split lock
+		detection on individual CPU.
-- 
2.19.1

