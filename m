Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC82D6D70
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 02:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389706AbgLKBYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 20:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389606AbgLKBYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 20:24:03 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827CAC0613D6
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 17:23:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z1so9090410ybg.22
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 17:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=76I2HkR/QhH41Al/kavpSZwfOHx+HGfAs7s/cIpsiMQ=;
        b=v26DmsxffYDRU0SN13OvI97KA4NYXbgOXESuqmnU7acvsDpH+XEhpF4Mq5ih4E2Nhz
         PvuKDtqI5UeZ0ESZl48s2g+ferGE6tdYrvXccAmjkobyTOMSnhsk+r1GIcnUTQ9fUsf+
         +udv2LLfV623oLgbJAhIPyTPC2/Z5VkbufNxrc6IEVSGnNJjcxH+tu9LtI7GdYQeg8f/
         2wu+W3m/t4WhECfKWze5Ddyec5+RHpIY4KrtRIK2R0cM5u1FJX5ezs4z+XpikFvl+LGg
         La+IqcaIs4XK2LwYmGt7xk0iUvsRpxS+lqvmGS5mIMHIhVA5QqOyVy9O7JH8+2zLUQqE
         LV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=76I2HkR/QhH41Al/kavpSZwfOHx+HGfAs7s/cIpsiMQ=;
        b=rV9nX3er/dD+1CKBq13cdYdwyOdAH6XYDAlSOiNzJP5asreR6IiinQSpuxmJkJj4rI
         faNx6EROs3+V9FIN48Cw1kOZMqoc/kmBp9KQGeJI7B5EyQgJ0bmJ5ldeJEIc7aSTw/Xc
         Itf5PJzsehiSqLIr7XPA73NyAk96x5yZ8SFbMP3Il8cEclFxk/Sz1OZbysJnO+RD7+dR
         OhWHIon1WExTS2GGE45/pQh82xBedysjMv2a6pgdVF2Uk7VRQvSkPTvCeWO3t9eSlIwj
         ZkdUGQbn1S7IzC7Aj7bs+STCVX8ejBDY6b2KjKsm/uauULTTXO+nMJCkSngsoybcN28M
         iltQ==
X-Gm-Message-State: AOAM5311khG5mzQ/RxG136uQYb8pCsvJlI5+hNlt5srkfGvXOXdE2HOW
        ECewNnTGpyUlZzAo7jihIvjLUVDJ
X-Google-Smtp-Source: ABdhPJzXE1mavmdvah8ChyCslZLxYWJzdsnmppMUbOd4X2HEw6nIUy3OJgKoq6nRbulcMKSwI+gIwb8HCQ==
Sender: "morbo via sendgmr" <morbo@fawn.svl.corp.google.com>
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:7220:84ff:fe0f:9f6a])
 (user=morbo job=sendgmr) by 2002:a25:ca17:: with SMTP id a23mr16202134ybg.229.1607649802623;
 Thu, 10 Dec 2020 17:23:22 -0800 (PST)
Date:   Thu, 10 Dec 2020 17:23:17 -0800
In-Reply-To: <X9LJE6ElVfKECnno@google.com>
Message-Id: <20201211012317.3722214-1-morbo@google.com>
Mime-Version: 1.0
References: <X9LJE6ElVfKECnno@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v2] selftests: kvm: remove reassignment of non-absolute variables
From:   Bill Wendling <morbo@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shuah Khan <shuah@kernel.org>,
        Bill Wendling <morbo@google.com>, Jian Cai <caij2003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang's integrated assembler does not allow symbols with non-absolute
values to be reassigned. Modify the interrupt entry loop macro to be
compatible with IAS by using a label and an offset.

Cc: Jian Cai <caij2003@gmail.com>
Signed-off-by: Bill Wendling <morbo@google.com>
References: https://lore.kernel.org/lkml/20200714233024.1789985-1-caij2003@gmail.com/
---
 tools/testing/selftests/kvm/lib/x86_64/handlers.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/handlers.S b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
index aaf7bc7d2ce1..7629819734af 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/handlers.S
+++ b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
@@ -54,9 +54,9 @@ idt_handlers:
 	.align 8
 
 	/* Fetch current address and append it to idt_handlers. */
-	current_handler = .
+666 :
 .pushsection .rodata
-.quad current_handler
+	.quad 666b
 .popsection
 
 	.if ! \has_error
-- 
2.29.2.576.ga3fc446d84-goog

