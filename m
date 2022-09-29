Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CC35EFEDA
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiI2UrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiI2UrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:47:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A615312A
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so24792207b3.10
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=WdZO+QIKb9m1gAu11nH6SdOXw3nLX+qDN1D4O/5fVL0=;
        b=aL/OFNgk6ZbFlCVjZCLjGnI6qXi6HZGPFaWGCNPxiNm3aEk0A2sz+E3NaHjt50hzGS
         UWV9M3HUVDFbUjInMftB/OvV3bka/047A3ee91QT1hcpoB1nZ5lKydoGt/zsCfI55MkL
         UdaJIjF7HmpVrWz0sCbSaw2viOAhoQFBDWjGp/Mw2F6tPXssTXIOHKsyiQHNDxbcLyHG
         4JjQ/ErhdE88pgELD7osYmOGqBZJkmoz/CZJi8qu5OKZUNsXGUWzNZ6kdlWPLJtdWj6S
         OmATwqfhaCgu2WEwT9wlI5xrAaG9j9Q7aG78jAu7DB2IRJvxYAnbn5q+X4EiXi91js9Y
         jiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=WdZO+QIKb9m1gAu11nH6SdOXw3nLX+qDN1D4O/5fVL0=;
        b=SWTLAzsstZmOn0iOKhOxDLs7nFvyU8FCYnOsh7fGLgZY7BNAXMQOY8+Nqw9AW1C/0p
         +3UVFHJkSI8pEIDwlZJCGO3jmwZW2ifF7D9Vy3WHKVzvwRfu7EYcgGbESpPY+j4xIGvG
         3oYmh+Id68wsQUq+oBZSbXwOcv2mLElHQtEZOQkcMj6ArQQkNRagwgaSGb7NOHK1z4K4
         pTHC0NCMIZu0VfkFQlgOkZupMpMv78xHl8HCqtHqvWL//ruUl9su+ofTLSkEaF8OUI2O
         pQukz94OVZJwZkREMtX0bEUZbaGjFjJJaeSG+nO2hQSlqfqp3hdAZmd6uuF0YhmG19Wq
         yL3A==
X-Gm-Message-State: ACrzQf1u5tlqidYIyGj9xd6a+4oZ2jDCTLkTi3xDVvz+wS/9By3h2q+N
        VTcVO977JRjpnLvQUvY1G5fPlmHuj+4j3Q==
X-Google-Smtp-Source: AMsMyM5ooLGI519TR8RVoAzXlzJ0LlYJeZJ2lcMw5I66WIgvkWi+AZayc33tT0MdSs493AAlJf+l6bueV7tcWg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:11cc:0:b0:345:6c7c:e6db with SMTP id
 195-20020a8111cc000000b003456c7ce6dbmr5278953ywr.44.1664484438375; Thu, 29
 Sep 2022 13:47:18 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:06 -0700
In-Reply-To: <20220929204708.2548375-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929204708.2548375-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929204708.2548375-3-dmatlack@google.com>
Subject: [PATCH 2/4] KVM: selftests: Delete dead ucall code from emulator_error_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete a bunch of code related to ucall handling from
emulator_error_test. The only thing emulator_error_test needs to check
is that the vCPU exits with UCALL_DONE after the second vcpu_run().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../kvm/x86_64/emulator_error_test.c          | 46 +------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 2dff57991d31..52ff1eb772e9 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -84,28 +84,11 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void do_guest_assert(struct ucall *uc)
-{
-	REPORT_GUEST_ASSERT(*uc);
-}
-
-static void check_for_guest_assert(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
-	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
-		do_guest_assert(&uc);
-	}
-}
-
 static void process_ucall_done(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	check_for_guest_assert(vcpu);
-
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s)",
 		    run->exit_reason,
@@ -116,32 +99,6 @@ static void process_ucall_done(struct kvm_vcpu *vcpu)
 		    uc.cmd, UCALL_DONE);
 }
 
-static uint64_t process_ucall(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct ucall uc;
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		break;
-	case UCALL_ABORT:
-		do_guest_assert(&uc);
-		break;
-	case UCALL_DONE:
-		process_ucall_done(vcpu);
-		break;
-	default:
-		TEST_ASSERT(false, "Unexpected ucall");
-	}
-
-	return uc.cmd;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -168,8 +125,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
 	vcpu_run(vcpu);
-
-	TEST_ASSERT(process_ucall(vcpu) == UCALL_DONE, "Expected UCALL_DONE");
+	process_ucall_done(vcpu);
 
 	kvm_vm_free(vm);
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

