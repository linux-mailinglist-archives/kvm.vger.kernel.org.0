Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B254944A2
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357786AbiATA33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiATA32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:28 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80531C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:28 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id g12-20020a63200c000000b00342cd03227aso2602636pgg.19
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xEzpTHEoEq/G2HUv56/F7AxziHIAxPWYaVOa6/Yl4Pg=;
        b=c/GzDa7EgQaKRcAx4Q+UWyj+uNfyioFgcnD9+SvMeG1WteNlyUyctG0TAJOJ6eCc3B
         qYIbdpXkndSr419hBEYNqopv7psZy/rGb7MmGKFNZDNq1FSZf0pyVF3P/ezcwpbYFBAN
         RRzgNvVIEePVQZtbqmH78BeRQbRk+vCqw2/EQO2fAF0bTudYtvR1FY3EHvpjWtACdpaJ
         9PKJcEO+pQd/SLvD5dr00Jfdcm77FIh6loT7IbzLdIoQQ2nb2AiCnmiOV/u8VIWmj5T6
         MxWsWw6/jFWSEBrSbnj03Sbf01onBmp7C8Nat02yHjYL0mcQ823HXC9ZsichM4hskKCH
         hdtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xEzpTHEoEq/G2HUv56/F7AxziHIAxPWYaVOa6/Yl4Pg=;
        b=cxs9+SITx0yw0H/UjM4Y+AM0wHzg1+JIaDlGHR1xDXMwImOjE8hgguMIaIS/iYX8Y7
         FCw8IMoFgLork0w/ZhYAMKVd5imuEu3zmBGZos1R9qCgvduLhsEGPy15snek1gwExIlY
         fIIZybJBkiwcHuxAT9pkq4ILHnai7OLDjXcNU2b1gzAP3EDi4VkX7fSP801x7qmeMA6U
         DnrDkJFwCnjGcr4wee4AlwYSrKSork0VZ/TR3034vcWveGHXKKvfGpmjRo4iz8dR67Um
         1/h8HvlSwk4+HuiqaKPGS/opvR/GX/IsJD2eKS1DylZw1sfXVR9Q/M/jf0C1x+A/DCPd
         MBiQ==
X-Gm-Message-State: AOAM533KTL0eq8mkJxi1e8ochtYq+5AGuZlmgD4R3JaPA0X0OZ8U5C4a
        lg2fk/mMiZTc0z6wwNIWfzyJb5cQs2k=
X-Google-Smtp-Source: ABdhPJwNEOUEw+J76vOyLCIWpykmV+Ct02d1jMC9kUqwl+CnVwyLCiS8T4o+LEqzhyJgTtd/bsRM4H30j4A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:56:: with SMTP id
 22mr7381810pjb.199.1642638568059; Wed, 19 Jan 2022 16:29:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:17 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 1/7] bitops: Include stdbool.h and stddef.h as necessary
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include stdbool.h and stddef.h in bitops.h to pick up the definitions for
"bool" and "size_t" respectively.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/bitops.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/bitops.h b/lib/bitops.h
index 308aa865..81a06a47 100644
--- a/lib/bitops.h
+++ b/lib/bitops.h
@@ -1,6 +1,9 @@
 #ifndef _BITOPS_H_
 #define _BITOPS_H_
 
+#include <stdbool.h>
+#include <stddef.h>
+
 /*
  * Adapted from
  *   include/linux/bitops.h
-- 
2.34.1.703.g22d0c6ccf7-goog

