Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8831447156
	for <lists+kvm@lfdr.de>; Sun,  7 Nov 2021 04:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhKGDt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Nov 2021 23:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhKGDt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 23:49:58 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA06C061570;
        Sat,  6 Nov 2021 20:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=m1mrkg1KCENusuCP1Uhak5JxRDb6vEFEHQG0eW+qSz0=; b=OrlugSmQkgJn0N0SXqnL4wBtD6
        9Pf1J8fI0Aboyv3XhJENorMl4BlA9c1upnEq+71qbQMvnL2q/2PgjePKsB+jH0K1pVsBRX97R9q4s
        KwaGUfsspL4nKMYi57ppmmYiWr5DixAFlCG2qFFW3TTA9ZV5xsHnw7Ye2IkvOX4bIuw+2BANu02a7
        pdoduAmmGq8M0oDW906m5B6WeQKQKsorM3XxfHC7jMb3UWp7EEBxvkFjIq9oLkTJFYgwypPp2EMT0
        r+LFGTsgUWW0gO7+U+MvdpLvKQ6z+9OYw3omrGEngHSX/IlGpPJr7VldDyNTu78W3NEidf2QoYdzu
        FYIPwzMw==;
Received: from [2601:1c0:6280:3f0:e65e:37ff:febd:ee53] (helo=merlin.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjZ9E-008bWR-6D; Sun, 07 Nov 2021 03:47:12 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup.patel@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH] riscv: kvm: fix non-kernel-doc comment block
Date:   Sat,  6 Nov 2021 20:47:06 -0700
Message-Id: <20211107034706.30672-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't use "/**" to begin a comment block for a non-kernel-doc comment.

Prevents this docs build warning:

vcpu_sbi.c:3: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Copyright (c) 2019 Western Digital Corporation or its affiliates.

Fixes: dea8ee31a039 ("RISC-V: KVM: Add SBI v0.1 support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Atish Patra <atish.patra@wdc.com>
Cc: Anup Patel <anup.patel@wdc.com>
Cc: kvm@vger.kernel.org
Cc: kvm-riscv@lists.infradead.org
Cc: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
---
 arch/riscv/kvm/vcpu_sbi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211106.orig/arch/riscv/kvm/vcpu_sbi.c
+++ linux-next-20211106/arch/riscv/kvm/vcpu_sbi.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * Copyright (c) 2019 Western Digital Corporation or its affiliates.
  *
  * Authors:
