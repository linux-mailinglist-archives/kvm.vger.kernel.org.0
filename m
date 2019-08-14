Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550BD8D7F7
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 18:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfHNQWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 12:22:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37220 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfHNQWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 12:22:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so4987180wmf.2;
        Wed, 14 Aug 2019 09:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wZo+HAsrUj/Kw4UvtL/TEz9wPlQYNsu6PTm1383LfLY=;
        b=oP51eZQUXMmLRbDeCYOkf4P47J1oJKUutGh4AX/7V34VD3Xz/++eNtMFBLRBZw9tr9
         OISGpnQoBlkiAkQQxdmCeiL6+jY9KZFfu2Au+q5R6Jt0SygTlPP6rFXcTApEihP1KAt8
         fG5JxbCNA1bgv9YkQGOmwsYSYYooAz8jfXeQREv0P9tBMZfQBLH5C+LERJDaQUCMV5xc
         rAKzGqRbesEjbhCO1yf67HHOb7c2d0IB9pULgBEEUi+ze8NfIyufmKx6eDmln4DWt4Mq
         S8m4OGN0JD8a+TbcjcN4SdCRym4vbNvb569u+hxGcxR34MgRJ9BF6QU7jK1ceWgpJhGl
         NWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=wZo+HAsrUj/Kw4UvtL/TEz9wPlQYNsu6PTm1383LfLY=;
        b=bjwYJe9ePLLtgHg/vX0W9z7tTmybsLM5im5byMc4rqRnta+jP7FaUzzkB3X96V0jmd
         XfT5CxGjfAC0c+BLfLkNufVFW4K1IarmghdVkqyTq58wfU8jgVkWtA5jbhHzOfIXiPlD
         BXcn5RO89+4hEHzcSuR+uHRAgY+/k1yn+wUPgRwH2z+bvnEgST0+Egdxbpn8Iv8Dds46
         KsDfYZSQQg1SZyXQ8MSsm/Dlenj3wPjE9PvWF7V6kLps9sp1UdJRUXhDH72Y7LdRSjbw
         ZFoF7MBC7EsXI/sM1Pzq3YeS6ve8qayJH9ubi8DWvzM2fqRJh91cgPZaCIdGB/y8eYeT
         W/9g==
X-Gm-Message-State: APjAAAU8iso1U15gyvAPF2wAGRiiXH6uoFRxX3kC3/9TWWboKKECFBNz
        qnIXm+883ibXfVb7YqLMH9+NEx2H
X-Google-Smtp-Source: APXvYqxQ3LV9hhpjouPQzvw8y3xfnGyfDtK43vIvbpKIweDNLDlYskUTD/ziCK7fN9YRLFpvQz67zg==
X-Received: by 2002:a05:600c:24cb:: with SMTP id 11mr904685wmu.94.1565799757758;
        Wed, 14 Aug 2019 09:22:37 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k124sm191620wmk.47.2019.08.14.09.22.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:22:37 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com
Subject: [PATCH 1/3] selftests: kvm: do not try running the VM in vmx_set_nested_state_test
Date:   Wed, 14 Aug 2019 18:22:31 +0200
Message-Id: <1565799753-3006-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
References: <1565799753-3006-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test is only covering various edge cases of the
KVM_SET_NESTED_STATE ioctl.  Running the VM does not really
add anything.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c      | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index ed7218d166da..a99fc66dafeb 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -27,22 +27,13 @@
 
 void test_nested_state(struct kvm_vm *vm, struct kvm_nested_state *state)
 {
-	volatile struct kvm_run *run;
-
 	vcpu_nested_state_set(vm, VCPU_ID, state, false);
-	run = vcpu_state(vm, VCPU_ID);
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
-		run->exit_reason,
-		exit_reason_str(run->exit_reason));
 }
 
 void test_nested_state_expect_errno(struct kvm_vm *vm,
 				    struct kvm_nested_state *state,
 				    int expected_errno)
 {
-	volatile struct kvm_run *run;
 	int rv;
 
 	rv = vcpu_nested_state_set(vm, VCPU_ID, state, true);
@@ -50,12 +41,6 @@ void test_nested_state_expect_errno(struct kvm_vm *vm,
 		"Expected %s (%d) from vcpu_nested_state_set but got rv: %i errno: %s (%d)",
 		strerror(expected_errno), expected_errno, rv, strerror(errno),
 		errno);
-	run = vcpu_state(vm, VCPU_ID);
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		"Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s),\n",
-		run->exit_reason,
-		exit_reason_str(run->exit_reason));
 }
 
 void test_nested_state_expect_einval(struct kvm_vm *vm,
-- 
1.8.3.1


