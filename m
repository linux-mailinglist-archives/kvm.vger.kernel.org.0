Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098C37B613C
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbjJCGyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjJCGyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CB8BD;
        Mon,  2 Oct 2023 23:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316078; x=1727852078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IaxeoNWuhGDXlIm0wMB8nNslGvpF2+LIDATl0KgTQLA=;
  b=ec4QYHFK1qDLdwGykgsn+IpRBDuEfHgaL/mEVGzp249u8UG7WZWUCKF8
   u0SSJIS+s/8ffX+/OumM6wdTa3obUpzB/U9QigXORmy75Bh9LZVMsQBi7
   MBPmug/tnm7BYBGFrnAUUuQ7rH85JXdQNhVB3pKtix+G1MyBGobN3CD0e
   3YZRgPLQNGGg3hVg8arJyL1kqioy3ZOImOfvQZ1CMsJTcdAifQYkO0kXu
   Lsnlfi2XKFWBneBjFtgNRfrJeVO+ojSoZlzfa4UU0giV4rzOp+5buVzQQ
   9TjHSJ9oWd6VBIhzmO5YsriBlC1GZwePskARDLdV28B8QbN1vITgQ+kBA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367857938"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367857938"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900906"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900906"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:36 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v12 04/37] x86/entry: Remove idtentry_sysvec from entry_{32,64}.S
Date:   Mon,  2 Oct 2023 23:24:25 -0700
Message-Id: <20231003062458.23552-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

idtentry_sysvec is really just DECLARE_IDTENTRY defined in
<asm/idtentry.h>, no need to define it separately.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_32.S       | 4 ----
 arch/x86/entry/entry_64.S       | 8 --------
 arch/x86/include/asm/idtentry.h | 2 +-
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 6e6af42e044a..e0f22ad8ff7e 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -649,10 +649,6 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
 SYM_CODE_END(asm_\cfunc)
 .endm
 
-.macro idtentry_sysvec vector cfunc
-	idtentry \vector asm_\cfunc \cfunc has_error_code=0
-.endm
-
 /*
  * Include the defines which emit the idt entries which are shared
  * shared between 32 and 64 bit and emit the __irqentry_text_* markers
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 9b4b512f2a75..aa4214703091 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -432,14 +432,6 @@ SYM_CODE_END(\asmsym)
 	idtentry \vector asm_\cfunc \cfunc has_error_code=1
 .endm
 
-/*
- * System vectors which invoke their handlers directly and are not
- * going through the regular common device interrupt handling code.
- */
-.macro idtentry_sysvec vector cfunc
-	idtentry \vector asm_\cfunc \cfunc has_error_code=0
-.endm
-
 /**
  * idtentry_mce_db - Macro to generate entry stubs for #MC and #DB
  * @vector:		Vector number
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 05fd175cec7d..cfca68f6cb84 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -447,7 +447,7 @@ __visible noinstr void func(struct pt_regs *regs,			\
 
 /* System vector entries */
 #define DECLARE_IDTENTRY_SYSVEC(vector, func)				\
-	idtentry_sysvec vector func
+	DECLARE_IDTENTRY(vector, func)
 
 #ifdef CONFIG_X86_64
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
-- 
2.34.1

