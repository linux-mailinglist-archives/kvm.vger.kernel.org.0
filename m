Return-Path: <kvm+bounces-6291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6887F82E267
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 23:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CF1DB21FA3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 22:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4261E1B59C;
	Mon, 15 Jan 2024 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdSWXhPI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D261B592
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a541b720aso12576206276.0
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 14:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705356138; x=1705960938; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=GdSWXhPIdhsVKE1MagtTBz87Y54PzzY8DTxczBH8PswNXGi9QMsQ3ZsteiKZoDs67Q
         108bIvpBTYsHAT9LnrVGGdq1GrhkdWHubU9+6PlzWz+ZVviPvu2dRf0uTThSniNeFgoC
         v6f5Ix53JsCglUr5LBQRU8oc0bCfZw3XE4szYUOcaGbTqBG0izG1dJpJa8g5Sr3AKbXU
         Y+5tGrCg+hVMio7IPutBjkmaFg2pB6y5PYmWgM69TlRsOgbOw48lIwey1rUmW/w74+J1
         Phg7OkUDZy7shhz5J2/M3YSpP0RrWKDYvU2wSlGNGTl97ReuLLuMXFLmYd9TVEZE6Ha+
         2mkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705356138; x=1705960938;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=u3EWUTaGfwo1HV56djZIsx70kXJzYHOFpn8nu0rHuZKAE45iabJjiKO1/rJsw+BCqa
         QqzsheXhFZXrIBgshxP7gW2j4YXplkQYgFYXccgQumL7aE0XE5mgs3x//DzaAk1febkV
         7ZVOIhATGdPEKLuG+ri/2QwaKu2/tvAHGwYrHFNf1lMD/7hgnBFy0ZZLWGn6GaMWWXFt
         dIt75FOw23SgYsUmZGxHwg4vd0KJJVYN5ugPhGciB0PtEFymE5i1Ek6QWJnx9Tx7yuhV
         OUho+mEoqm1l6zhd6QqDGYE+NM51IPMeTa5E1betA/5XFxFkkkAHjCe0l/4IO1m6MmKP
         T8uA==
X-Gm-Message-State: AOJu0YzilAiTy8p9l50YGcMscwhZR+vbPW8HdZ84UAZ701VmVic8J6CX
	G9d8Uk7ZUChMRnc/MTGWk5AenyBAlaVPRUw06JqUEGOPfTerbt8Vor49Nmnq7+CANIB9qltjgUR
	fZzCAXLR3gOsgu4eSyTVbDqwNRO83fkhGiPMYd9wBIF/qvxINlErKPQnal1UQiANVXA87aE6GgX
	u6mg==
X-Google-Smtp-Source: AGHT+IG/Iz6XwIuapV7X0ZZ3a5fIRKR0t1lv2wuRi/0Zp4hZu5zvYSaE2O3U898S6kuTsnCQsTVHzwgeQxaXgAgzGg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:8c:b0:dc1:f6f0:16cf with SMTP
 id h12-20020a056902008c00b00dc1f6f016cfmr1218961ybs.11.1705356137876; Mon, 15
 Jan 2024 14:02:17 -0800 (PST)
Date: Mon, 15 Jan 2024 14:02:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240115220210.3966064-1-jingzhangos@google.com>
Subject: [PATCH v1] KVM: arm64: selftests: Handle feature fields with nonzero
 minimum value correctly
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

There are some feature fields with nonzero minimum valid value. Make
sure get_safe_value() won't return invalid field values for them.
Also fix a bug that wrongly uses the feature bits type as the feature
bits sign causing all fields as signed in the get_safe_value() and
get_invalid_value().

Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID register from usersapce")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index bac05210b539..f17454dc6d9e 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
-	if (ftr_bits->type == FTR_UNSIGNED) {
+	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = ftr_bits->safe_val;
 			break;
 		case FTR_LOWER_SAFE:
-			if (ftr > 0)
+			uint64_t min_safe = 0;
+
+			if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_DebugVer"))
+				min_safe = ID_AA64DFR0_EL1_DebugVer_IMP;
+			else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_CopDbg"))
+				min_safe = ID_DFR0_EL1_CopDbg_Armv8;
+
+			if (ftr > min_safe)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 			ftr = ftr_bits->safe_val;
 			break;
 		case FTR_LOWER_SAFE:
-			if (ftr > 0)
+			uint64_t min_safe = 0;
+
+			if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"))
+				min_safe = ID_DFR0_EL1_PerfMon_PMUv3;
+
+			if (ftr > min_safe)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
-	if (ftr_bits->type == FTR_UNSIGNED) {
+	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);

base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
-- 
2.43.0.472.g3155946c3a-goog


