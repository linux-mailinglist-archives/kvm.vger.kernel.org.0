Return-Path: <kvm+bounces-4262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9838480F860
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8BAD1C20DEB
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFE165A86;
	Tue, 12 Dec 2023 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KO1fhvEq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B4A1FE1
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5e15b0bdfcbso24718907b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 12:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702414067; x=1703018867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TFmE+BG4/EJDZrVEh/xZNdnTy9FeH/PqMcDgQWjrrOU=;
        b=KO1fhvEqSnWjbbd24F9xNUUoNic6nJw5QlWdLiaY2/t6mmt2DuSGLbGWmtuJr2Et1t
         GqhUuBBAwUbG2cj2Xl8vHL2WpJK1O90k9XkTJxyqVAfyVSav/QVBguBih8lZ0qzAoy6U
         Zf0tzH8GCWmg2B3qlzb0ey9zvI446FRhDMCIDgqXpNr9lQfESw6uOeP3wvVfiBFIJbUT
         WUf0PY8RNQ9FZIcCA4emQ9BdMnJOxV0lHMw78fz3SfLxhXDndpnwf+dRgE0dMyFyvbh/
         5CY+5wTN9TQBbv3z2YWFqbECdObzcedrIToGy/BgdPfHvbcqcIy9fv1SudSqcWsmEEox
         RKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414067; x=1703018867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFmE+BG4/EJDZrVEh/xZNdnTy9FeH/PqMcDgQWjrrOU=;
        b=Uux1xZQCAKW0YKM2mZGW2Oj1JeegM9ZbV2mirsTi54R8I1y17Z3oBCMhVHWZ9mYZ5V
         e0nuPEThAL07QXDS0lbJ7irHktUtaZ9PhwTTNocNEqAXeJFUpTBFbUNFgHEfrMvYzD6/
         bWL1YtlQFYBcdmsjIJ9nMcG8Yk8YRRL9Wre1tmNAj/bF46+Y5EEGdAPzqVxL4RQ049zC
         V03ksnDcwBd5jRBovp4yJzZJgijU6+dOuF0V+ihJgxhf7mg5P5ocVF6iPtTMsSh+x18r
         ++grJOj6vD10XMcfSK+PpYqAXc0fJOuTJicWzlTfxHoM3Z3R6M/6ENtBsHn3VncOhCBq
         s9cA==
X-Gm-Message-State: AOJu0YwRIJfxzAWBIIZqmvoow5vVVTgqitW1F5upmdIgVA1XERN7LQQt
	RcjxUG+KDIXWz9AqQVWoT4SKMRo3GA==
X-Google-Smtp-Source: AGHT+IEfV9mKSOUMKRt6QzMdx4NjK5Xm4g7Lzg/OSBchtLDS9HiwFFeqtcXo/zBjodXwgzfPibVCMzwJXQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a25:d204:0:b0:dbc:cbd9:3cd0 with SMTP id
 j4-20020a25d204000000b00dbccbd93cd0mr566ybg.8.1702414067193; Tue, 12 Dec 2023
 12:47:47 -0800 (PST)
Date: Tue, 12 Dec 2023 12:46:42 -0800
In-Reply-To: <20231212204647.2170650-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212204647.2170650-1-sagis@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231212204647.2170650-28-sagis@google.com>
Subject: [RFC PATCH v5 27/29] KVM: selftests: Propagate KVM_EXIT_MEMORY_FAULT
 to userspace
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	Sagi Shahar <sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Peter Gonda <pgonda@google.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Roger Wang <runanwang@google.com>, Vipin Sharma <vipinsh@google.com>, jmattson@google.com, 
	dmatlack@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Allow userspace to handle KVM_EXIT_MEMORY_FAULT instead of triggering
TEST_ASSERT.

From the KVM_EXIT_MEMORY_FAULT documentation:
Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace should assume
kvm_run.exit_reason is stale/undefined for all other error numbers.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d024abc5379c..8fb041e51484 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1742,6 +1742,10 @@ void vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int ret = _vcpu_run(vcpu);
 
+	// Allow this scenario to be handled by the caller.
+	if (ret == -1 && errno == EFAULT)
+		return;
+
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_RUN, ret));
 }
 
-- 
2.43.0.472.g3155946c3a-goog


