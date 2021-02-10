Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3939C315C11
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 02:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhBJBTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 20:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbhBJBSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 20:18:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA1BC061788
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 17:17:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7so596718ybm.13
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 17:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4sl8hCVYIIQXoKXiaYQxzYCkEmKowx44CLAZnUGYVQs=;
        b=YkvoF37IrAacD5AjBdQZFGuE+sqb+HPbZ0qhtTS0gmDv1XP1r2Hv/AcFIZDnnN5WJd
         26pLWViCA7wdm7H4/QmSnpJlDhz2I44y8JE0eaKfu7gI3P+eGMGr7oiNnfkKbH0CBDMA
         o8xzlyXdUNogp1VR6BudLfgdj2bSrtGM1eh6/PUUu3zcKNCwguYUP+b3dWUxIwSPMPDg
         Qp1hJzmmVjnqYPcCevN7qAa3kub9UbdJxV9tlDtIqppBtIfB+tZNbUimxnqX2LzCkq3W
         5feHA8oRk/rKWYPS+nXzyb2btxspxoTY/a6QjiwFd1oTC9C1q3D7gMrhZNMg98fLyBO6
         DsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=4sl8hCVYIIQXoKXiaYQxzYCkEmKowx44CLAZnUGYVQs=;
        b=eJNGpDxRdJtJMCkWGDIYCFLO1/Y9RBspm/uwh10wfsDZ6FKBWIdKRNc6aTrr6Cx+72
         kSUclNfkSZGGsvoFvy5lXCSFGzEhZ7d7r4BEmta6NQfyTYimJ4ec6ROY2jp9C83eaN3z
         ZWFDS3vBto/z8J08k0YHs78Vqo7o+kc5TYzt1qf9Omn3RoVO7P3alBj4BNV6kt/hJYOF
         9ob+jRDztprPvWzCvSkHrEJWN5Urs9g05nE0iKIDzqBhPN3wXiTGSHKMpcTHxyfj5TdC
         SOjfG7PGnhhJmWH1YFdN0ccN39N4YBb+jns1FkIDoKrDGxBGWO1fWTPlwpWOlemOEyTs
         XvUA==
X-Gm-Message-State: AOAM533UENIh4cOVvbj2OV/HIQkevmngr0WvQcfIGQ45sMw6IbxU6J5x
        EF/de6s20TvvZ1q6evCOfowylT5Yilg=
X-Google-Smtp-Source: ABdhPJzPRKyyxJdYxkBjVQkd0UxE8M40kpQxENvRuhzY8gYI83CdYVh2q9wUF/UDyg08fHP70sxnxbDTjcM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1513:9e6:21c3:30d3])
 (user=seanjc job=sendgmr) by 2002:a25:e787:: with SMTP id e129mr889657ybh.478.1612919870827;
 Tue, 09 Feb 2021 17:17:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Feb 2021 17:17:47 -0800
Message-Id: <20210210011747.240913-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] KVM: selftests: Add missing header file needed by xAPIC IPI tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Shier <pshier@google.com>

Fixes: 678e90a349a4 ("KVM: selftests: Test IPI to halted vCPU in xAPIC while backing page moves")
Cc: Andrew Jones <drjones@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Delta patch taken verbatim from Peter's original submission.  Applying the
original patch directly is mildly annoying due to conflicts with kvm/next
in other files.

 tools/testing/selftests/kvm/include/numaif.h | 55 ++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/numaif.h

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
new file mode 100644
index 000000000000..b020547403fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/numaif.h
+ *
+ * Copyright (C) 2020, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Header file that provides access to NUMA API functions not explicitly
+ * exported to user space.
+ */
+
+#ifndef SELFTEST_KVM_NUMAIF_H
+#define SELFTEST_KVM_NUMAIF_H
+
+#define __NR_get_mempolicy 239
+#define __NR_migrate_pages 256
+
+/* System calls */
+long get_mempolicy(int *policy, const unsigned long *nmask,
+		   unsigned long maxnode, void *addr, int flags)
+{
+	return syscall(__NR_get_mempolicy, policy, nmask,
+		       maxnode, addr, flags);
+}
+
+long migrate_pages(int pid, unsigned long maxnode,
+		   const unsigned long *frommask,
+		   const unsigned long *tomask)
+{
+	return syscall(__NR_migrate_pages, pid, maxnode, frommask, tomask);
+}
+
+/* Policies */
+#define MPOL_DEFAULT	 0
+#define MPOL_PREFERRED	 1
+#define MPOL_BIND	 2
+#define MPOL_INTERLEAVE	 3
+
+#define MPOL_MAX MPOL_INTERLEAVE
+
+/* Flags for get_mem_policy */
+#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
+				    /* Warning: MPOL_F_NODE is unsupported and
+				     * subject to change. Don't use.
+				     */
+#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
+#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
+
+/* Flags for mbind */
+#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
+#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
+#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
+
+#endif /* SELFTEST_KVM_NUMAIF_H */
-- 
2.30.0.478.g8a0d178c01-goog

