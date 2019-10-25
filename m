Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CECAE4693
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408663AbfJYJD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:03:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:37164 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408378AbfJYJD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 05:03:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 02:03:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="202556660"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 02:03:27 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: pku: fix parameter passing
Date:   Fri, 25 Oct 2019 17:03:29 +0800
Message-Id: <20191025090329.11679-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025090329.11679-1-chenyi.qiang@intel.com>
References: <20191025090329.11679-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Parameter error_code is passed in the function definition while
the caller miss it. Fix it.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 x86/pku.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pku.c b/x86/pku.c
index 62fb261..1ce73fa 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -38,6 +38,7 @@ asm ("pf_tss: \n\t"
     // no task on x86_64, save/restore caller-save regs
     "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
     "push %r8; push %r9; push %r10; push %r11\n"
+    "mov 9*8(%rsp),%rdi\n"
 #endif
     "call do_pf_tss \n\t"
 #ifdef __x86_64__
-- 
2.17.1

