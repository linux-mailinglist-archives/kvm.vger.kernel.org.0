Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563776130D
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 23:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGFViu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 17:38:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39250 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfGFViu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 17:38:50 -0400
Received: by mail-lf1-f67.google.com with SMTP id v85so5462434lfa.6
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2019 14:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DuOAz4hI1m2Eoq4BKu5qv1f4XbKgapdVxFndOFJhe6o=;
        b=QBXdetEEpDaQgyKLsnLHWzmH1wldyzKyMqgVaGRkXUH7b2DUVhfwIGklzwY5EyGuGd
         p0jX2hj6wplRBkrUvKGhHzBQmfS/DGh6kcZ2mVieoj/1XZ04CejtWhD7pn/cSKQR37Cc
         UA3W4LhliS5DpwBmJdMq3piFIlMccXkj9miRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DuOAz4hI1m2Eoq4BKu5qv1f4XbKgapdVxFndOFJhe6o=;
        b=jjviRJh5PBL8LJzsAz/+6Eph2OdEF19CtJ4ko9x3k647LwjAAKLrkYcCT/iQmA4Ira
         A/0YUo0sL3rxnjfbZiDazKkPlcPWAXXfA0P4/q15+9oGfdCYeIg6EcbcAQcH4g4/IezS
         8S4TQ3EDHUeJw7a0w8vjphUS+XN6pSLcCS9ipTgn9+jaGs4bKjGFiKxGxkOxPh95QPpV
         U+UtyGWtI+flKGjL1tW3gQIapSwJWXT9QF19VfGXdvm7NDYGxv50s/ZpPhem3au9eCKO
         JfijnpY32HeWN2m8dIiW5RoWFPkwEhVyU7Ae/NaDxIuH7OB4q/WTIRvz6OWju3UnVV52
         gEQQ==
X-Gm-Message-State: APjAAAVP8H9B8tsAppTyP52kauhtH+gqOvKqhhmddgYrD8WUHjGEd5ip
        Mhw9zBnFVg5LhVJXiPDof/LFiw==
X-Google-Smtp-Source: APXvYqw2mCxi+OdS68ITvrMO+wzb5K1SYQRv2FpmzKWs4N8eOtOcBKONNRQqxrUEs+Ta2YigyP36LA==
X-Received: by 2002:a19:490d:: with SMTP id w13mr4907625lfa.58.1562449128132;
        Sat, 06 Jul 2019 14:38:48 -0700 (PDT)
Received: from luke-XPS-13.home (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id j3sm1322449lfp.34.2019.07.06.14.38.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 14:38:47 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Documentation: virtual: Add toctree hooks
Date:   Sat,  6 Jul 2019 14:38:13 -0700
Message-Id: <ef1edb15bd6a6ef87abf4fef7636cd9213450e3c.1562448500.git.lnowakow@eng.ucsd.edu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
References: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

Added toctree hooks for indexing. Hooks added only for newly added files
or already existing files. 

The hook for the top of the tree will be added in a later patch series
when a few more substantial changes have been added. 

Signed-off-by: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
---
 Documentation/virtual/index.rst     | 18 ++++++++++++++++++
 Documentation/virtual/kvm/index.rst | 12 ++++++++++++
 2 files changed, 30 insertions(+)
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
index 000000000000..ada224a511fe
--- /dev/null
+++ b/Documentation/virtual/kvm/index.rst
@@ -0,0 +1,12 @@
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
+   vcpu-requests
-- 
2.20.1

