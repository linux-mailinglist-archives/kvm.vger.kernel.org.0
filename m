Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12BF240665
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgHJNGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:45 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47998 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726821AbgHJNGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5EF6A4C88F;
        Mon, 10 Aug 2020 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064796; x=1598879197; bh=Yu8w4ld04o1+eFBtzmy2ZK9TAqK6tEo2gu/
        o6kbO4K0=; b=I+OkQ4OrlunSsuy7VVpjU04zLPGCz5T1xR3gNwbhbXJbqzohJa4
        qoBrpvJZEIyFWcA+gHq4kNQSR4lSIhq7s6h0ioZWSi1WdR2skVRM/MdIjyqeq1q7
        DvTyLUy53b1M/PerYcVlMMHougn2Nicg/rPcyK23DPzqeSu0E/JMuMsQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wrVJtvs0XoZY; Mon, 10 Aug 2020 16:06:36 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id AB9614C89B;
        Mon, 10 Aug 2020 16:06:35 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:35 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 4/7] lib: Bundle debugreg.h from the kernel
Date:   Mon, 10 Aug 2020 16:06:15 +0300
Message-ID: <20200810130618.16066-5-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200810130618.16066-1-r.bolshakov@yadro.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86/vmx_tests.c depends on the kernel header and can't be compiled
otherwise on x86_64-elf gcc on macOS.

Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 lib/x86/asm/debugreg.h | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 lib/x86/asm/debugreg.h

diff --git a/lib/x86/asm/debugreg.h b/lib/x86/asm/debugreg.h
new file mode 100644
index 0000000..d95d080
--- /dev/null
+++ b/lib/x86/asm/debugreg.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_DEBUGREG_H
+#define _UAPI_ASM_X86_DEBUGREG_H
+
+
+/* Indicate the register numbers for a number of the specific
+   debug registers.  Registers 0-3 contain the addresses we wish to trap on */
+#define DR_FIRSTADDR 0        /* u_debugreg[DR_FIRSTADDR] */
+#define DR_LASTADDR 3         /* u_debugreg[DR_LASTADDR]  */
+
+#define DR_STATUS 6           /* u_debugreg[DR_STATUS]     */
+#define DR_CONTROL 7          /* u_debugreg[DR_CONTROL] */
+
+/* Define a few things for the status register.  We can use this to determine
+   which debugging register was responsible for the trap.  The other bits
+   are either reserved or not of interest to us. */
+
+/* Define reserved bits in DR6 which are always set to 1 */
+#define DR6_RESERVED	(0xFFFF0FF0)
+
+#define DR_TRAP0	(0x1)		/* db0 */
+#define DR_TRAP1	(0x2)		/* db1 */
+#define DR_TRAP2	(0x4)		/* db2 */
+#define DR_TRAP3	(0x8)		/* db3 */
+#define DR_TRAP_BITS	(DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)
+
+#define DR_STEP		(0x4000)	/* single-step */
+#define DR_SWITCH	(0x8000)	/* task switch */
+
+/* Now define a bunch of things for manipulating the control register.
+   The top two bytes of the control register consist of 4 fields of 4
+   bits - each field corresponds to one of the four debug registers,
+   and indicates what types of access we trap on, and how large the data
+   field is that we are looking at */
+
+#define DR_CONTROL_SHIFT 16 /* Skip this many bits in ctl register */
+#define DR_CONTROL_SIZE 4   /* 4 control bits per register */
+
+#define DR_RW_EXECUTE (0x0)   /* Settings for the access types to trap on */
+#define DR_RW_WRITE (0x1)
+#define DR_RW_READ (0x3)
+
+#define DR_LEN_1 (0x0) /* Settings for data length to trap on */
+#define DR_LEN_2 (0x4)
+#define DR_LEN_4 (0xC)
+#define DR_LEN_8 (0x8)
+
+/* The low byte to the control register determine which registers are
+   enabled.  There are 4 fields of two bits.  One bit is "local", meaning
+   that the processor will reset the bit after a task switch and the other
+   is global meaning that we have to explicitly reset the bit.  With linux,
+   you can use either one, since we explicitly zero the register when we enter
+   kernel mode. */
+
+#define DR_LOCAL_ENABLE_SHIFT 0    /* Extra shift to the local enable bit */
+#define DR_GLOBAL_ENABLE_SHIFT 1   /* Extra shift to the global enable bit */
+#define DR_LOCAL_ENABLE (0x1)      /* Local enable for reg 0 */
+#define DR_GLOBAL_ENABLE (0x2)     /* Global enable for reg 0 */
+#define DR_ENABLE_SIZE 2           /* 2 enable bits per register */
+
+#define DR_LOCAL_ENABLE_MASK (0x55)  /* Set  local bits for all 4 regs */
+#define DR_GLOBAL_ENABLE_MASK (0xAA) /* Set global bits for all 4 regs */
+
+/* The second byte to the control register has a few special things.
+   We can slow the instruction pipeline for instructions coming via the
+   gdt or the ldt if we want to.  I am not sure why this is an advantage */
+
+#ifdef __i386__
+#define DR_CONTROL_RESERVED (0xFC00) /* Reserved by Intel */
+#else
+#define DR_CONTROL_RESERVED (0xFFFFFFFF0000FC00UL) /* Reserved */
+#endif
+
+#define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
+#define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
+
+/*
+ * HW breakpoint additions
+ */
+
+#endif /* _UAPI_ASM_X86_DEBUGREG_H */
-- 
2.26.1

