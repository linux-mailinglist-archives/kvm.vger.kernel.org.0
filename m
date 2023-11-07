Return-Path: <kvm+bounces-1046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F207E4827
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BC5B281227
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E067D358B0;
	Tue,  7 Nov 2023 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDLrIUwp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B35358A5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:22:02 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E3125
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:22:02 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afc00161daso70318957b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699381321; x=1699986121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pF19+OXVW5UGsHvBJEM1Rd3K8EFj2d9Zm0BTvFFwkOQ=;
        b=iDLrIUwp0Ijph4F3Az7lVjSHowRY4OUyYh2DU1g+ztoDpy3vYqHsAopDKg6Iz5AY/Q
         1ixMOCTp18Cwu8LkaawJyZThs6812KUqudT3jwQkb+xtOXx0F1msW0veZ9exnGI5E7iW
         5MiTZ8lvNH4aUqff85s9DNsZLrEvGayqZYKJlnuxGLnswPh52gxSSWSFvPSAfncMHpnI
         NVAboraXOtYGpuAVuvJKW0Fyb30VVN537ocaXmvdw+kdYRdOxteQkltsFnokIIa4Xko+
         VwvPorGoCJ/mZnt8eVonKO/PP2oQIiFYQJnNoB6RI4jCnV4e6p4MmF4z1kjkxS99YCro
         1kgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381321; x=1699986121;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pF19+OXVW5UGsHvBJEM1Rd3K8EFj2d9Zm0BTvFFwkOQ=;
        b=HTtpj+Kab2wLjHDvfY83hHZmUvlcakecL59V3cOzWUHI7NBfMsbaVdHhNYuX4J8hwC
         4A9KTPzCs9eHSTrxoqu4RRJ1E6FRcAgjgfzcjUkEZuNfVxpsTIbzV/HZsNrH5lD+n2Lr
         C/B1OHoCqAIbJ1Za96451e5wsKkUtrSZbvKOKFxMhdano6IqJawNUnOzA3Ev9u8PVaDR
         kt8J5ROqajjUL7T5t7SmmT7jwzEtmMujuL3YfaRXfkVkpfvJy6+sGhNKJNhe9VLf5J3Y
         JR/BW1BklgtOh/0MO8OI+5TY9NhT62wfgtwJ/uYboxiUa+RvPBpfvWQhjLCa4a2MJrQW
         XsOg==
X-Gm-Message-State: AOJu0YyqG+rU/xoeM7g3m4d8Um1j5yMu9H03MHClRd5lgZ6L5N13EnM2
	j14bxV8pGIVts/8yv3LC2hlP1xFkQrA=
X-Google-Smtp-Source: AGHT+IEDf6RUwUXmKQRccOF/Lx6Rlskhqqt2UmcBCDHA+7KXiu9sCsGdSay6ypnVQLil31O2Iq9zsbVpkVM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:9d2:0:b0:d9a:bce6:acf3 with SMTP id
 y18-20020a5b09d2000000b00d9abce6acf3mr672242ybq.0.1699381321569; Tue, 07 Nov
 2023 10:22:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 10:21:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107182159.404770-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix MWAIT error message when guest assertion fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Print out the test and vector as intended when a guest assert fails an
assertion regarding MONITOR/MWAIT faulting.  Unfortunately, the guest
printf support doesn't detect such issues at compile-time, so the bug
manifests as a confusing error message, e.g. in the most confusing case,
the test complains that it got vector "0" instead of expected vector "0".

Fixes: 0f52e4aaa614 ("KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 80aa3d8b18f8..853802641e1e 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -27,10 +27,12 @@ do {									\
 									\
 	if (fault_wanted)						\
 		__GUEST_ASSERT((vector) == UD_VECTOR,			\
-			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
+			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
+			       testcase, vector);			\
 	else								\
 		__GUEST_ASSERT(!(vector),				\
-			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
+			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
+			       testcase, vector);			\
 } while (0)
 
 static void guest_monitor_wait(int testcase)

base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


