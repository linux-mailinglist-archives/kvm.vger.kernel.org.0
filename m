Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C327271F0
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjFGWpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjFGWpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D453119AC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb3855c34deso64831276.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177931; x=1688769931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rEtSIdYhwqCu9OuuuihNc8Xe1CSgOswix6v9nvhvk8=;
        b=L/Lfn0l4B3zv0mEaPgQpTGDF0klTBOu0dHp2wJsdgAVRzx2HVT6MHZ23MofMUCfgqq
         9lugGsaNbp9aB4CVNCgT5U97p76JcSkYzAUvHaF+5KHbNLQf1urZMGPUSEOiXcGgXyFs
         G6h5LOK1cKe3hDNx7SaozhV3V53hPyrR+k9bOoTP6C8ixgpJoZnaqGrD7bnqHZKDFuW2
         axSfKjkj7J3odt8cn0lefw4+yZqcFBALqYkPvuH6DbyH7qEem07Yj8ngsPa91+xu8jL2
         i8TAlGaePYy1Oc9DOPbK/6IYfj164UMv8eFQ1d+FNc2zRkxt69nZaj5ZCDxLA+k4MAbX
         0ClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177931; x=1688769931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rEtSIdYhwqCu9OuuuihNc8Xe1CSgOswix6v9nvhvk8=;
        b=C1pC6Zhlf5lkwZl2LZDVHzJzKsAw+UvDDxC6jTHUqoBjupuFvUbEm54E97RysDRFgm
         L0rPq0kMbdxwv4orJz609UIqbXbpAiXXlI56jJTacC8XKfvQvcyS6FRQwMEjwmdkrs3g
         7OuqCTE13A5xXgWHc/78IcdjaHr8i3yzz0nXHmnUGYacN6L8B8tNZsZhbY9hg18KkdgH
         wgMQHpgottV8xW8aQM/7Ct85PaKAIpuN86LISqYqEgOHtewK+v8uXRbceqtME/viWDH2
         rMiF+BLq8dYTMQ8mBd2OImsF8hv0yWukxIMc5nuoutkP8eJUD/tijo127ZVPTfNQDyoW
         KRiw==
X-Gm-Message-State: AC+VfDyaw3aQyA7t3vZ9ctDIlqpXz1SpybrI+XLKcbrtoBa6cvYBBI1K
        +jXxsVfpk1ZNAT/BvqA4yvnULEPv/0TKygd0S9AMpNsssKHDWYYF3RiceCy5xWCjA2hyXmf2/5l
        BENikX41DxCiolR96xzpaHr4lxSF+Jnp/cR/pawHVsnmdZ33VqTgRStrbdItmIvw6ilbf
X-Google-Smtp-Source: ACHHUZ7XVbL8ikk3YBF/pBWsCukxBZxYsBANlVjVrz2Eru7Hqlo+AJlTC7nK6MDJb3r1EOPQiXFDoyyQz3eHvatn
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:1823:b0:bb1:446f:1d00 with
 SMTP id cf35-20020a056902182300b00bb1446f1d00mr3856521ybb.10.1686177931082;
 Wed, 07 Jun 2023 15:45:31 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:19 +0000
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-5-aaronlewis@google.com>
Subject: [PATCH v3 4/5] KVM: selftests: Add string formatting options to ucall
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add more flexibility to guest debugging and testing by adding
GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.

A buffer to hold the formatted string was added to the ucall struct.
That allows the guest/host to avoid the problem of passing an
arbitrary number of parameters between themselves when resolving the
string.  Instead, the string is resolved in the guest then passed
back to the host to be logged.

The formatted buffer is set to 1024 bytes which increases the size
of the ucall struct.  As a result, this will increase the number of
pages requested for the guest.

The buffer size was chosen to accommodate most use cases, and based on
similar usage.  E.g. printf() uses the same size buffer in
arch/x86/boot/printf.c.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 23 +++++++++++++++++++
 .../testing/selftests/kvm/lib/ucall_common.c  | 17 ++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bcbb362aa77f..b4f4c88e8d84 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -13,15 +13,18 @@ enum {
 	UCALL_NONE,
 	UCALL_SYNC,
 	UCALL_ABORT,
+	UCALL_PRINTF,
 	UCALL_DONE,
 	UCALL_UNHANDLED,
 };
 
 #define UCALL_MAX_ARGS 7
+#define UCALL_BUFFER_LEN 1024
 
 struct ucall {
 	uint64_t cmd;
 	uint64_t args[UCALL_MAX_ARGS];
+	char buffer[UCALL_BUFFER_LEN];
 
 	/* Host virtual address of this struct. */
 	struct ucall *hva;
@@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
+void ucall_fmt(uint64_t cmd, const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -47,8 +51,11 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
+#define REPORT_GUEST_PRINTF(_ucall) pr_info("%s", _ucall.buffer)
+
 enum guest_assert_builtin_args {
 	GUEST_ERROR_STRING,
 	GUEST_FILE,
@@ -56,6 +63,20 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
+#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)			\
+do {										\
+	char fmt[UCALL_BUFFER_LEN];						\
+										\
+	if (!(_condition)) {							\
+		guest_snprintf(fmt, sizeof(fmt), "%s\n  %s",			\
+			     "Failed guest assert: " _str " at %s:%ld", _fmt);	\
+		ucall_fmt(UCALL_ABORT, fmt, __FILE__, __LINE__, ##_args);	\
+	}									\
+} while (0)
+
+#define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
+	__GUEST_ASSERT_FMT(_condition, #_condition, _fmt, ##_args)
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
 do {									\
 	if (!(_condition))						\
@@ -81,6 +102,8 @@ do {									\
 
 #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
 
+#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
+
 #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
 	TEST_FAIL("%s at %s:%ld\n" fmt,					\
 		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 77ada362273d..b507db91139b 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -75,6 +75,23 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_fmt(uint64_t cmd, const char *fmt, ...)
+{
+	struct ucall *uc;
+	va_list va;
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	va_start(va, fmt);
+	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
+}
+
 void ucall(uint64_t cmd, int nargs, ...)
 {
 	struct ucall *uc;
-- 
2.41.0.rc0.172.g3f132b7071-goog

