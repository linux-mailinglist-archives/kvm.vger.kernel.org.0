Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD8C45D2A9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352941AbhKYCBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbhKYB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28BCC061371
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:02 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf12-20020a17090ac7cc00b001a968c11642so2316089pjb.4
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4GgRH8rX1YJ31D+XrJ+F+809T04jmhGE1vvXnoaTT1k=;
        b=Z3Pfkipj8YjBwq7VQMBqOyDMO6uudTtIKaZy1XxeTunAw7c89MdL0njq5re8GLeF43
         6cTxl7mw6V4nm5mIsKH8XLRB2ISzm1aXeJolOgSg6MYvw6gNx5Nyb05QoTsW8n2EFK5m
         IiQ9lIPGR5soMNHo+U4LlBhh3nbjcJlK2Vp14CmOY9HsmARdBiga1pRaLZ3uIpaxxDoy
         hMPjHxfw60Mm/eYaIxwmW9xnmqt3Rnx5cF2U8C1fMZjoVoHssPcCOqfHWpQ0ghk9mo8/
         meRRd3N0kq0rzFjyaYZEm+97MR058wYFntzXRBBxc99fMTAZcxBcTLbCZAN7lQqI893w
         dyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4GgRH8rX1YJ31D+XrJ+F+809T04jmhGE1vvXnoaTT1k=;
        b=r7zatDcKYmOfnD+xN63dUj74rP01lS4J5VLlcKNQWIjFdcjURrfJEGbkKpNP4Ert25
         rHhqTIyIMpthxfAIxl18yUTInVwNZb7BtPPi3r0fYHpXp43VIYVgP5qFIUKpALgYxQgx
         /NtO3/Ie+EtcH7QTtYybKc6R5/9nN0Lw7vAVXTwCSUuClY4lBoaAZFbnDRV1SMsWXrt2
         qocAIppgKe+KA0UcF4UQlg+DBa4Xqs+8Nw7eOg6AZFTV/rf5emSXEDwUyomNTRKjpT65
         7uNe/IK346ukTDeTZKF1VU3N2BV7fF9bc/0OzotmfE3vNOgewwtbsz390cy2YvHLdKbk
         hXZg==
X-Gm-Message-State: AOAM533nQyKB1gVOQeT5SF4uEdg5CLizeamH6RU4o5PJM/W2Hh5/fixu
        QJlvedzr4srcbWffd8eoaJeDK+en7JU=
X-Google-Smtp-Source: ABdhPJwKwU7bzAP8v5X4BFjgeDYzLBTrCB02HF1Jl4oTPVI2gE1+NSHOVy7KbbTfbEKkXo/1f18bFCg5jbw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2004:b0:142:6344:2c08 with SMTP id
 s4-20020a170903200400b0014263442c08mr24316171pla.51.1637803742426; Wed, 24
 Nov 2021 17:29:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:19 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 01/39] x86/access: Add proper defines for
 hardcoded addresses
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use defines to differentiate between the paging structure and code/data
physical address ranges to reduce the magic ever so slightly.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index c5e71db..2e0636a 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -15,6 +15,10 @@ static _Bool verbose = false;
 typedef unsigned long pt_element_t;
 static int invalid_mask;
 
+/* Test code/data is at 32MiB, paging structures at 33MiB. */
+#define AT_CODE_DATA_PHYS	  32 * 1024 * 1024
+#define AT_PAGING_STRUCTURES_PHYS 33 * 1024 * 1024
+
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
 
@@ -273,7 +277,7 @@ static void ac_env_int(ac_pool_t *pool)
 	set_idt_entry(14, &page_fault, 0);
 	set_idt_entry(0x20, &kernel_entry, 3);
 
-	pool->pt_pool = 33 * 1024 * 1024;
+	pool->pt_pool = AT_PAGING_STRUCTURES_PHYS;
 	pool->pt_pool_size = 120 * 1024 * 1024 - pool->pt_pool;
 	pool->pt_pool_current = 0;
 }
@@ -284,7 +288,7 @@ static void ac_test_init(ac_test_t *at, void *virt, int page_table_levels)
 	set_cr0_wp(1);
 	at->flags = 0;
 	at->virt = virt;
-	at->phys = 32 * 1024 * 1024;
+	at->phys = AT_CODE_DATA_PHYS;
 	at->page_table_levels = page_table_levels;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

