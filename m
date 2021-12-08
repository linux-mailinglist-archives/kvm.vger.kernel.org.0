Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A946DBE4
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbhLHTU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhLHTUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 14:20:24 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E3CC0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 11:16:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x18-20020a17090a789200b001a7317f995cso4258307pjk.4
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 11:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+rUb4EcNLHXprRGqicoOenA63+zorwY5WA3oAPDA1u8=;
        b=fwDpE7kawJMsXyteTfbEn8A3BclDGm4jhjcP0qfEWLJ61ICFBv7/rCgod5IaDpJXAb
         jeTB4HtI0CygoWMsq7BMbR7naWpCTFnlRzFsG/M/kk5TSzzQo5u+d5dKDLXUIOLKKxQC
         566AnHZoV3fev/pLoGZwBtvQTJcXlolt74D3M9MqNHeXrEwaQ/n34Vmk2lXULruuYQak
         Dtw6eFHQjeSJwv40pulCVICe4pFev1wUQ0aiKn6BeRpvhHJFIc610xiIxWNOjLG7WWxs
         RN5f0ClQJZ5/DUlHFFVJFnrVhz0axJS951fcpkufW5wD5pk+X+jSwQCTvBviS4lr9X19
         fOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+rUb4EcNLHXprRGqicoOenA63+zorwY5WA3oAPDA1u8=;
        b=DgV6O7qGDHOzCnp8tU5UEugsSCRCCkg7Nsk1WKo6SgclFGS4qQN3rxFLaNN1Vkh+PM
         zQEOS4r/TtAhvH044dJZB7k8CzE/g2cQ347dGt35qtWdG3LNuWDruqzyVRr0xWUD2cxv
         ZPiz8cDrQloB5KQpk8R4aIT9rOZOdyF4kNjUYpd/CxsEemrfsjDI+ShjK/BmlGAMVkFl
         qSy9pxpI3sxUuBW+zdwJo88u4LbCgbG8twWjEZ6g7jweOkw5gdumo/u32XQQ/3p4Pvzh
         6lFLPGnRjn/icgB2DLzl+WMs2r3ATiY/MqGxeX2yc0kFK1Fo21giDDjV04DImJJnGmXh
         bRGA==
X-Gm-Message-State: AOAM532pry5rkcdi9p1u+DmNl1C9pMnsaU9qJaiDgC98kJhl5pK2lYBj
        2kiuPspfw37iVN/2Piqa4D3HriKlJnM=
X-Google-Smtp-Source: ABdhPJyQ05g7P13b2YRufccjN8TF/Br/V30j4aaI/54yAgNMPP03l7wreqeDrWzZObJQbWGgl2jnInka1fM=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ff20:12b0:c79e:3e6b])
 (user=pgonda job=sendgmr) by 2002:a17:90a:6f61:: with SMTP id
 d88mr9548836pjk.109.1638991012130; Wed, 08 Dec 2021 11:16:52 -0800 (PST)
Date:   Wed,  8 Dec 2021 11:16:42 -0800
In-Reply-To: <20211208191642.3792819-1-pgonda@google.com>
Message-Id: <20211208191642.3792819-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211208191642.3792819-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 3/3] selftests: sev_migrate_tests: Add mirror command tests
From:   Peter Gonda <pgonda@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests to confirm mirror vms can only run correct subset of commands.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 55 +++++++++++++++++--
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 4bb960ca6486..80056bbbb003 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -21,7 +21,7 @@
 #define NR_LOCK_TESTING_THREADS 3
 #define NR_LOCK_TESTING_ITERATIONS 10000
 
-static void sev_ioctl(int vm_fd, int cmd_id, void *data)
+static int __sev_ioctl(int vm_fd, int cmd_id, void *data, __u32 *fw_error)
 {
 	struct kvm_sev_cmd cmd = {
 		.id = cmd_id,
@@ -30,11 +30,20 @@ static void sev_ioctl(int vm_fd, int cmd_id, void *data)
 	};
 	int ret;
 
-
 	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
-	TEST_ASSERT(ret == 0 && cmd.error == SEV_RET_SUCCESS,
+	*fw_error = cmd.error;
+	return ret;
+}
+
+static void sev_ioctl(int vm_fd, int cmd_id, void *data)
+{
+	int ret;
+	__u32 fw_error;
+
+	ret = __sev_ioctl(vm_fd, cmd_id, data, &fw_error);
+	TEST_ASSERT(ret == 0 && fw_error == SEV_RET_SUCCESS,
 		    "%d failed: return code: %d, errno: %d, fw error: %d",
-		    cmd_id, ret, errno, cmd.error);
+		    cmd_id, ret, errno, fw_error);
 }
 
 static struct kvm_vm *sev_vm_create(bool es)
@@ -226,6 +235,42 @@ static void sev_mirror_create(int dst_fd, int src_fd)
 	TEST_ASSERT(!ret, "Copying context failed, ret: %d, errno: %d\n", ret, errno);
 }
 
+static void verify_mirror_allowed_cmds(int vm_fd)
+{
+	struct kvm_sev_guest_status status;
+
+	for (int cmd_id = KVM_SEV_INIT; cmd_id < KVM_SEV_NR_MAX; ++cmd_id) {
+		int ret;
+		__u32 fw_error;
+
+		/*
+		 * These commands are allowed for mirror VMs, all others are
+		 * not.
+		 */
+		switch (cmd_id) {
+		case KVM_SEV_LAUNCH_UPDATE_VMSA:
+		case KVM_SEV_GUEST_STATUS:
+		case KVM_SEV_DBG_DECRYPT:
+		case KVM_SEV_DBG_ENCRYPT:
+			continue;
+		default:
+			break;
+		}
+
+		/*
+		 * These commands should be disallowed before the data
+		 * parameter is examined so NULL is OK here.
+		 */
+		ret = __sev_ioctl(vm_fd, cmd_id, NULL, &fw_error);
+		TEST_ASSERT(
+			ret == -1 && errno == EINVAL,
+			"Should not be able call command: %d. ret: %d, errno: %d\n",
+			cmd_id, ret, errno);
+	}
+
+	sev_ioctl(vm_fd, KVM_SEV_GUEST_STATUS, &status);
+}
+
 static void test_sev_mirror(bool es)
 {
 	struct kvm_vm *src_vm, *dst_vm;
@@ -243,6 +288,8 @@ static void test_sev_mirror(bool es)
 	if (es)
 		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
 
+	verify_mirror_allowed_cmds(dst_vm->fd);
+
 	kvm_vm_free(src_vm);
 	kvm_vm_free(dst_vm);
 }
-- 
2.34.1.400.ga245620fadb-goog

