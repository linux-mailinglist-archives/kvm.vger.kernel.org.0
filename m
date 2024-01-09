Return-Path: <kvm+bounces-5901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01949828A8A
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A66FC285FB6
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54EF3A8E8;
	Tue,  9 Jan 2024 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MQRNZ0iB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B643A8C5
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5efb07ddb0fso42303827b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 08:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704819411; x=1705424211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=MQRNZ0iBYKa2MG83YojQ4HurFcILJ4v6RpreGmTVnDeaBHbu11DX614FupgJJOi/7k
         7wxv0o/IqlFg4Ow8GglKaiIOn0wBZhry+v6tVyy6nS7j/caD+HuMMUw/Gr2JZfEMJ60/
         /12PJbVLmXndngNsC+aOXCqEp0GrmSnu8GbQ/JhycduZMTf7GN0EW1Zq30ad45uScBHX
         VZfpQiIgACF5RPQQH+erj6244R4KXbRp4GOmOHGacHVnz+ccbXZQA+Ts7IGNefGpZvJM
         B9RSXPsLknJ/ybBwobIEk9Wg2IfYpLywgvxdbi7DWyGtpxMLNgpJUPB45AYylpJSg5Ye
         RxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704819411; x=1705424211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=Ab8crV9C/3IiYdtB7p8rgxIsryTEuvq7vFUwaNBhxWtuKBUyHqyb9OjbLtfDQdl/oJ
         gqf8nPGstn/vxSdwjPglEMI2xVC3XN9n7g88SlEB3s8rWXjB7mwh5c4nadMvhYHtAP13
         gvtDIsQVBots1Wor52VngfK1EWAVDgn9h/OeLG9iLLUowxWoP3Q0Ct+BK/T6nAFwlZKE
         AQdLn63xNnJDtl8wshHrkuvbcZFshmj8gMD6BvtjCfLLxbByEPtLqthQuyl95uEXLSd7
         4CsgZQvLFL+J+y59Q9uxBU7Xx42/+f8fNFT/tlrfZdqX6oyyB38rbxLfLuDXyEHq+5kg
         cGFg==
X-Gm-Message-State: AOJu0YzCdIrCUcK70R3rNHVVNZtVo5W90NXu+P+Ktzi9DPlTGW7Msmz+
	vfg19YEld8R0WLsx0wExxKc05zpjL6uQPbLV7AGpCwCY4+K1Bw4Lv2p5RGuqOMRpdGS2yhBDZdX
	Eb5x4U3UcEtY2d2ST/zwLzazl7Bwl28ztSudgc/RB/6aDQSwwzctyK8apweM9jJDrpGPMI6RYao
	rOMg==
X-Google-Smtp-Source: AGHT+IFJYk3i2RC1bH88fwAuau9C4zuiOPot5e3J0BArmIefW2S8KwtUXxKUu+wt+MEHyKZAdOV1+wsmcKU76wbbYQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1369:b0:dbe:ab5b:c667 with
 SMTP id bt9-20020a056902136900b00dbeab5bc667mr159057ybb.2.1704819411220; Tue,
 09 Jan 2024 08:56:51 -0800 (PST)
Date: Tue,  9 Jan 2024 08:56:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109165622.4104387-1-jingzhangos@google.com>
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


