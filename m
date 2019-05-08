Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6117BDD
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfEHOp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:45:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:59548 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbfEHOpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:45:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id A1F3611C1; Wed,  8 May 2019 17:44:31 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 59/62] x86/mktme: Document the MKTME kernel configuration requirements
Date:   Wed,  8 May 2019 17:44:19 +0300
Message-Id: <20190508144422.13171-60-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/mktme/index.rst               |  1 +
 Documentation/x86/mktme/mktme_configuration.rst | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 Documentation/x86/mktme/mktme_configuration.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
index a3a29577b013..0f021cc4a2db 100644
--- a/Documentation/x86/mktme/index.rst
+++ b/Documentation/x86/mktme/index.rst
@@ -7,3 +7,4 @@ Multi-Key Total Memory Encryption (MKTME)
 
    mktme_overview
    mktme_mitigations
+   mktme_configuration
diff --git a/Documentation/x86/mktme/mktme_configuration.rst b/Documentation/x86/mktme/mktme_configuration.rst
new file mode 100644
index 000000000000..91d2f80c736e
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_configuration.rst
@@ -0,0 +1,17 @@
+MKTME Configuration
+===================
+
+CONFIG_X86_INTEL_MKTME
+        MKTME is enabled by selecting CONFIG_X86_INTEL_MKTME on Intel
+        platforms supporting the MKTME feature.
+
+mktme_storekeys
+        mktme_storekeys is a kernel cmdline parameter.
+
+        This parameter allows the kernel to store the user specified
+        MKTME key payload. Storing this payload means that the MKTME
+        Key Service can always allow the addition of new physical
+        packages. If the mktme_storekeys parameter is not present,
+        users key data will not be stored, and new physical packages
+        may only be added to the system if no user type MKTME keys
+        are programmed.
-- 
2.20.1

