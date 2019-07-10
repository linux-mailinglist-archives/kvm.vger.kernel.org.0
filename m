Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2E649AA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfGJPbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 11:31:49 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41527 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbfGJPbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 11:31:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id 62so1905360lfa.8
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 08:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iaKa3sSy2TMJewprEBabjIU4mKVmcxPtQBjA4QDbmn0=;
        b=UUzVeCXTViOeS329ulCFq+Hz43TUVXtDWlWrCHNGfGXF3mlN4g7U3i42I7j+vqjga3
         l3MGHSL71cjlI5wcM9ZbWkTGQrgF2eOGsDBvdIdNh+HE4oxSzYNz8U0ldOgdcEGv5k2v
         wqdOsIcf3eCSbyTwe/UGRVNsb/5OFLGQTbX4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iaKa3sSy2TMJewprEBabjIU4mKVmcxPtQBjA4QDbmn0=;
        b=Fxbvs947lQwVcNbwaBMMdZMYbvhVEMaC6cJpcRXC9PVPC0zSdPazaVHygGBPyqJgQj
         zLGT94t7HzUa/wB82byWmnTzq+QOKRBrmjvYTcGBDfspLF6h4P3w+fPLdqie7Odeb1JC
         FM5JmcllYA2oowBFHUZSGp4Soo0cstg++ERaDFTtnA9bDxZIC4dtkfU5MGkP/S6XWRon
         HEVbs2Rr2guXLS3ABnWeO/zlFt7Ta/bmT9QAhiPAHbj2vxNUH5y1dyPx3Pnu4VPz96fg
         5Jnh6x8GEhPWBBtkZFBMPEKr28AxUWVEP4NRR6ROJEK8k6oYSuj8/7RmV0zsR0XReuGA
         eYEA==
X-Gm-Message-State: APjAAAWgHjLxlDFqX5ZvzdHzQjU2p2si+AvlOcK3q+UPdvck7xqHCzIE
        x59e5wLRGxmDfBU1ojG0VBCwjg==
X-Google-Smtp-Source: APXvYqye8Vs3VVDTfx2ic4t433ZNvo5KeS/BLYowQ8YqT568ojQnM+RFldGQEiyEYzmEvpN4l6RS4Q==
X-Received: by 2002:ac2:495e:: with SMTP id o30mr15233962lfi.140.1562772699900;
        Wed, 10 Jul 2019 08:31:39 -0700 (PDT)
Received: from luke-XPS-13.home (159-205-76-204.adsl.inetia.pl. [159.205.76.204])
        by smtp.gmail.com with ESMTPSA id o17sm517208ljg.71.2019.07.10.08.31.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 08:31:39 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] Documentation: virtual: Add toctree hooks
Date:   Wed, 10 Jul 2019 08:30:54 -0700
Message-Id: <20190710153054.29564-4-lnowakow@neg.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710153054.29564-1-lnowakow@neg.ucsd.edu>
References: <20190710153054.29564-1-lnowakow@neg.ucsd.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

Added toctree hooks for indexing. Hooks added only for newly added
files.

The hook for the top of the tree will be added in a later patch series
when a few more substantial changes have been added.

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 Changes since v3:
 none
 Changes since v2:
 - Removed vcpu-request from hooks that was added in v1
 Changes since v1:
 + Added index.rst file in virtual directory
 + Added index.rst file in virtual/kvm directory

 Documentation/virtual/index.rst     | 18 ++++++++++++++++++
 Documentation/virtual/kvm/index.rst | 11 +++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 Documentation/virtual/index.rst
 create mode 100644 Documentation/virtual/kvm/index.rst

diff --git a/Documentation/virtual/index.rst b/Documentation/virtual/index.rst
new file mode 100644
index 000000000000..19c9fa2266f4
--- /dev/null
+++ b/Documentation/virtual/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+Linux Virtual Documentation
+===========================
+
+.. toctree::
+   :maxdepth: 2
+
+   kvm/index
+   paravirt_ops
+
+.. only:: html and subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/virtual/kvm/index.rst b/Documentation/virtual/kvm/index.rst
new file mode 100644
index 000000000000..0b206a06f5be
--- /dev/null
+++ b/Documentation/virtual/kvm/index.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+KVM
+===
+
+.. toctree::
+   :maxdepth: 2
+
+   amd-memory-encryption
+   cpuid
-- 
2.20.1

