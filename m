Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0198C6ED83F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjDXW7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjDXW7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC0B9025
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-52503bfeb07so1251805a12.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377146; x=1684969146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hbOymScOo75LUEkrgYekJoiRx67W5YRYoUgYkSf+Iw0=;
        b=I8UYl8b6RChd3RSlGjrJh5uJwG+eQ1eF4yDeileuL3L06Bmsy1LCK4cKGsKknmR+/T
         7+XVazxbwgO+MlKLyuwI/KLT1+6DbEFZzy6+WsUHEix6Ya2uVVD5WN8j/RgbCpug1uo/
         wDNw9Vk+9dJVeOG4wWwfgTA5V/7+ymggp2pT9uZnlsFi3rFayReeuBrnn/aabNJcrPEO
         igLvIS+8fKmwx6+ijZkg8xjxspuhNhcjUvHjF2hRyaHFstuDKxk/4kyIiFkR3Z7uoUt5
         BC+KsW4NS9ogzmNCIVuTbxA3uvtQr1YCOPRFR+BUvr09CXrhjAFVxo52KAQBd34RWFhN
         CNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377146; x=1684969146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbOymScOo75LUEkrgYekJoiRx67W5YRYoUgYkSf+Iw0=;
        b=WYZbBZ4B2/mWe252/ZkuDfNjfVG0Dao8wue9v4tiYeRytBBFNaLAP9PmFdzB0FNosV
         T/+wsraBtNoobY7Pi5entEsE7nrzufKO8Cn5/9afL2zDJSRLOyrF7lUAP0eFSYzVv5N+
         4LBeSW7BUWse9oV78kMJLgecIIU56S83Fj2GF6QfuV4NddK2WcWCRkHPc1x53skyCzjV
         GKz7HfaYDqztlJbZRunGn157evJDtR9fRNH3Jg0q3MkOiD8ns1lOISHDoQN/jX048M33
         AoOjiV4y/mFQo56SY7b3T/zo2pV0vNW8BAAlqb8qhViIFOziKU87sTU/8mVTpKMRVQcs
         hi/w==
X-Gm-Message-State: AAQBX9d/ab2B1Jafep7Hauex7xihNIZ+tDX/pI1y++zzKON6nwXWcMXv
        02GrLdWsn3RMu+yytlgu+PFmOcZan58IHrwjHyjIS1jVNjKPAKm3W2ciEXffzb5sKGDizb3ZmD5
        iGqLCuZtDKRQJLL7bqTp7baT295XJ2DmFr9/nwevUZGWLYpgz1p4STG+OCQ+gxkDMmX2I
X-Google-Smtp-Source: AKy350azkvYPOXXoggpdpuQ1osIj+QMvmReGe4f96bDDGccPVftOm8sqqpa0I742jmQjy5fYY9wzPupeS9Iaruw1
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a63:5f83:0:b0:520:4c05:221 with SMTP id
 t125-20020a635f83000000b005204c050221mr3496835pgb.9.1682377146661; Mon, 24
 Apr 2023 15:59:06 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:53 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-6-aaronlewis@google.com>
Subject: [PATCH v2 5/6] KVM: selftests: Add ucall_fmt2()
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

Add a second ucall_fmt() function that takes two format strings instead
of one.  This provides more flexibility because the string format in
GUEST_ASSERT_FMT() is no linger limited to only using literals.

This provides better consistency between GUEST_PRINTF() and
GUEST_ASSERT_FMT() as GUEST_PRINTF() is not limited to only using
literals either.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/ucall_common.h      | 13 +++++-----
 .../testing/selftests/kvm/lib/ucall_common.c  | 24 +++++++++++++++++++
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 7281a6892779..3e8135aaa812 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -36,6 +36,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
 void ucall_fmt(uint64_t cmd, const char *fmt, ...);
+void ucall_fmt2(uint64_t cmd, const char *fmt1, const char *fmt2, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
@@ -61,12 +62,12 @@ enum guest_assert_builtin_args {
 	GUEST_ASSERT_BUILTIN_NARGS
 };
 
-#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)		  \
-do {										  \
-	if (!(_condition))							  \
-		ucall_fmt(UCALL_ABORT,						  \
-			  "Failed guest assert: " _condstr " at %s:%ld\n  " _fmt, \
-			  , __FILE__, __LINE__, ##_args);			  \
+#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)	     \
+do {									     \
+	if (!(_condition))						     \
+		ucall_fmt2(UCALL_ABORT,					     \
+			   "Failed guest assert: " _condstr " at %s:%ld\n  ",\
+			   _fmt, __FILE__, __LINE__, ##_args);		     \
 } while (0)
 
 #define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index c09e57c8ef77..d0f1ad6c0c44 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -76,6 +76,30 @@ static void ucall_free(struct ucall *uc)
 	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
 }
 
+void ucall_fmt2(uint64_t cmd, const char *fmt1, const char *fmt2, ...)
+{
+	const int fmt_len = 128;
+	char fmt[fmt_len];
+	struct ucall *uc;
+	va_list va;
+	int len;
+
+	len = kvm_snprintf(fmt, fmt_len, "%s%s", fmt1, fmt2);
+	if (len > fmt_len)
+		ucall_arch_do_ucall(GUEST_UCALL_FAILED);
+
+	uc = ucall_alloc();
+	uc->cmd = cmd;
+
+	va_start(va, fmt2);
+	kvm_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
+	va_end(va);
+
+	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+
+	ucall_free(uc);
+}
+
 void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 {
 	struct ucall *uc;
-- 
2.40.0.634.g4ca3ef3211-goog

