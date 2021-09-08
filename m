Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAF404047
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350850AbhIHUrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350635AbhIHUrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EDDC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:46:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d93-20020a25a366000000b0059fff274d9aso3972314ybi.4
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P1Y+Ph+GsXSaPrabuDpgFnMWRNrhcn0BGPQpycHKo6E=;
        b=q6WpTAFJFgsQgY1MhvHfJ+Bt7XYCaWsE9QlPYKXAp5mppBcK02anOXpEkLvFC1z9+W
         dxkPTyzfY93L9vLi9UQ1iczH9T8rIAB8VV5pnMS9YOsdYkVziaiwE7pavOe6iA88ToWZ
         dZLSbcvuqvRvkM6V9a/kLo3YcUP38XejXNBjFqCUULS7E+K53BheEclM8M6ymgZURKJV
         WCtWIE2dJiXPAa2GNJQktiIkrep3S1BFXt8FCgmLvKMQWoUCWwoR0539TebuSR43CwVS
         0kmaJV/dhVd463M7rIgL+OTWxVs6C32GKVaDq31bfKV21TCyTAIbSbcubWd6sAZSQrnE
         ox7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P1Y+Ph+GsXSaPrabuDpgFnMWRNrhcn0BGPQpycHKo6E=;
        b=eST7oyWMr+9lFbIR/1YmFM/ina1KG4AemflmsRSo0NZuDyTVVHxICGYTIFZvF5lJ39
         Z6LTu3Of2EfHQ/I/HNIN/B9WyNMkprM/Oq4Arp7WRUQIhRu8GZ8VLG+wHJqursb4vVXo
         Vart7FSBTWJumt4SJ4445asV5LeurFooY5R6Of5xJa2ENDn+lCe/oyyHeKigBcx5ce/X
         loZ4bMV7ZPb6HyWmL+dYyBaxRXjS8fVB23ymFrtUTuro7RHhb09IKkc+sPEQ7QcT529/
         5AV8GrA3v2z/EfM496hz/BjlSeiewsEYTAafhUml63RQ+5zHYUPmF2tmQeMevAfQKqnb
         Fjdw==
X-Gm-Message-State: AOAM533KTsc4dcTKoC/spIQq5Hd4xhiTzEhMDJ1fBJ6PmAVELWQq3sR/
        dSQVZxACvXZetk9MdZp0r/NVEFF8ThnY6bdy/PgNJVF0yZKFu1TptFwYbkTC7MiMD61ohm3T+WY
        sNnUapF3vVSd8yVEenydEnHX9EhV38DhSJBpus5c4+ee9WJju1wximQ==
X-Google-Smtp-Source: ABdhPJwur+D5rxMNWGzXvTHrFO3FN3OFrrBBU9rEhAonzNZE3Kxnr7GnzrnAMDjHl9qMC/e32FUS562PHw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:a25:b94:: with SMTP id 142mr198390ybl.508.1631133960940;
 Wed, 08 Sep 2021 13:46:00 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:39 -0700
In-Reply-To: <20210908204541.3632269-1-morbo@google.com>
Message-Id: <20210908204541.3632269-4-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 3/5] x86: svm: mark test_run as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

test_run uses inline asm that has labels. Clang decides that it can
inline this function, which causes the assembler to complain about
duplicate symbols. Mark the function as "noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
v2: Use "noinline" instead of "__attribute__((noinline)).
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index beb40b7..3f94b2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -256,7 +256,7 @@ int svm_vmrun(void)
 
 extern u8 vmrun_rip;
 
-static void test_run(struct svm_test *test)
+static noinline void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
-- 
2.33.0.309.g3052b89438-goog

