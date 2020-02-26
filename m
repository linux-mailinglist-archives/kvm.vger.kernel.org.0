Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF116FB26
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgBZJo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:56 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:57536 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgBZJo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:56 -0500
Received: by mail-pj1-f74.google.com with SMTP id ca1so1665438pjb.7
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sg86NFabOORN55y8mAlbwofI2HO6OYeN468A2bA7JSc=;
        b=N02PQoPx28uH+iDBbBc2vnpkLXtsQTQQXZ3+6X44hv6QdgS81uCRK9NuUKiVkTc2jc
         ZuE0bSQNKirIN6U9+YHODQhBoZhr2SrJVHi9aC0qCIBPW+tk/oeMamwEMc0ZkN8o1fHc
         cX0qfzje2/HdF4W9hE1n4kj1qBgiB6CDgEULD+Rp5Rn/Yq8lSTW7n69LLTemqpte203F
         RWQU1NObSUJoZWTxFAiWza1UgxwV1OShQ0cClnalp7zwfNcsoEC+e4NduQItB9iYy4sS
         uuuy7YKBH1h2nqfjyMRjGanv0t/XOWCmnFV+AxjRnepvrKYO0Y6rPCeB8qrDa57ZZXtB
         PB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sg86NFabOORN55y8mAlbwofI2HO6OYeN468A2bA7JSc=;
        b=nR071fInflBtnnLwEv2JzDPUSgMdpHZAb6TBLMuMuTmUasTvxmK5g5ieDpGAU8fcJ+
         JSeKKMJ/4Wp2iO7tGrbVEuUss4Gb1tAx8BTipryD+oIqGnvnuCNmVZgJZX1pHrR9O+cy
         b9ruWF/vxfFLFyEdlLHjjQT6Rq5tZ6+Yw2+geqJZkecYmIRbhsBqMPsHBimvQR/+Jn0v
         uEySYrue23yu0DRVJgwR8yfvAYLA0LB/fSXIXNuJfaB0JmVYmYrQHhbHL7OHAl1rOcDN
         +vG5QwyQllinFuYtnPQAGuY5pFQ/2VkGxa3DNMzUu2uehxUMIOCnEighX5uoZyCfdK5i
         TzWA==
X-Gm-Message-State: APjAAAWtLmtyefqvkBlPgwP0zSyFV1sNE4279pym47eiQ5KJbDz5Kge+
        nn8qtLD5DN/kyAS/ZReWSt8MmrOwcroRciddr1aUGgbHSTkuVJQrSvZpgQF5ZNdL95NMMj709OY
        9ICVdR+TBWQ9b8IwD0+/v83HLdRGt/uXAaxRn5g0XSQC9aruHTLO/DA==
X-Google-Smtp-Source: APXvYqwacKJw9k01HLK6W/jVZT5NU48LjjPU7YSirBUcTtK5ZdctIVp/Zad4bZumDV01Dl1a+P8jK0j1IA==
X-Received: by 2002:a63:cb11:: with SMTP id p17mr3137357pgg.42.1582710294688;
 Wed, 26 Feb 2020 01:44:54 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:26 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-8-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 4/7] svm: change operand to output-only for
 matching constraint
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to GNU extended asm documentation, "the two operands [of
matching constraints] must include one input-only operand and one
output-only operand." So remove the read/write modifier from the output
constraint.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index aa3d995..ae85194 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -288,8 +288,8 @@ static void test_run(struct test *test, struct vmcb *vmcb)
             "cli \n\t"
             "stgi"
             : // inputs clobbered by the guest:
-	      "+D" (the_test),            // first argument register
-	      "+b" (the_vmcb)             // callee save register!
+	      "=D" (the_test),            // first argument register
+	      "=b" (the_vmcb)             // callee save register!
             : [test] "0" (the_test),
 	      [vmcb_phys] "1"(the_vmcb),
 	      [PREPARE_GIF_CLEAR] "i" (offsetof(struct test, prepare_gif_clear))
-- 
2.25.0.265.gbab2e86ba0-goog

