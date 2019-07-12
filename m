Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8DD66445
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbfGLCWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:22:08 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:45861 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728931AbfGLCUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 22:20:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0TWfK5gO_1562898032;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TWfK5gO_1562898032)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jul 2019 10:20:33 +0800
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
        kvm@vger.kernel.org, linux-sh@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 07/12] Documentation/parisc: repointer docs to Documentation/arch/
Date:   Fri, 12 Jul 2019 10:20:13 +0800
Message-Id: <20190712022018.27989-7-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.856.g8858448bb
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we move Documentation/parisc docs to Documentation/arch/parisc
dir, redirect the doc pointer to them.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03a8c687f87f..e1aad1b8224c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12000,7 +12000,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git
 S:	Maintained
 F:	arch/parisc/
-F:	Documentation/parisc/
+F:	Documentation/arch/parisc/
 F:	drivers/parisc/
 F:	drivers/char/agp/parisc-agp.c
 F:	drivers/input/serio/gscps2.c
-- 
2.19.1.856.g8858448bb

