Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114B4663C7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfGLCUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:20:44 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48113 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbfGLCUj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 22:20:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0TWfK5gm_1562898033;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TWfK5gm_1562898033)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jul 2019 10:20:34 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 09/12] Dcumentation/sh: repointer docs to Documentation/arch/
Date:   Fri, 12 Jul 2019 10:20:15 +0800
Message-Id: <20190712022018.27989-9-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.856.g8858448bb
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we move Documentation/sh docs to Documentation/arch/sh
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org
---
 Documentation/conf.py | 2 +-
 MAINTAINERS           | 2 +-
 arch/sh/Kconfig.cpu   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 3b2397bcb565..8bbe421c1d97 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -402,7 +402,7 @@ latex_documents = [
      'The kernel development community', 'manual'),
     ('security/index', 'security.tex', 'The kernel security subsystem manual',
      'The kernel development community', 'manual'),
-    ('sh/index', 'sh.tex', 'SuperH architecture implementation manual',
+    ('arch/sh/index', 'sh.tex', 'SuperH architecture implementation manual',
      'The kernel development community', 'manual'),
     ('sound/index', 'sound.tex', 'Linux Sound Subsystem Documentation',
      'The kernel development community', 'manual'),
diff --git a/MAINTAINERS b/MAINTAINERS
index 7a245d3f02fd..84448d5838b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15169,7 +15169,7 @@ M:	Rich Felker <dalias@libc.org>
 L:	linux-sh@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-sh/list/
 S:	Maintained
-F:	Documentation/sh/
+F:	Documentation/arch/sh/
 F:	arch/sh/
 F:	drivers/sh/
 
diff --git a/arch/sh/Kconfig.cpu b/arch/sh/Kconfig.cpu
index 4a4edc7e03d4..fdc8b565241b 100644
--- a/arch/sh/Kconfig.cpu
+++ b/arch/sh/Kconfig.cpu
@@ -94,7 +94,7 @@ config CPU_HAS_SR_RB
 	  that are lacking this bit must have another method in place for
 	  accomplishing what is taken care of by the banked registers.
 
-	  See <file:Documentation/sh/register-banks.txt> for further
+	  See <file:Documentation/arch/sh/register-banks.txt> for further
 	  information on SR.RB and register banking in the kernel in general.
 
 config CPU_HAS_PTEAEX
-- 
2.19.1.856.g8858448bb

