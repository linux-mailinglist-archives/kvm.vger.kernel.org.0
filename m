Return-Path: <kvm+bounces-2336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9997F5325
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 23:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B88B31F20CE1
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 22:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CE6200AC;
	Wed, 22 Nov 2023 22:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4nje9Ql0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E89AD
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 14:15:31 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da033914f7cso323440276.0
        for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 14:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700691331; x=1701296131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rHQ5lVYi4/2MX2skoChLDy6Ocqhy29V3zUGeEPzVvPk=;
        b=4nje9Ql02zOsTvSoAPAvpOBNu7wg0GEhOvHpvYlYXOFidCjelO2vDEHo7qUJZ9VTU4
         xgnyqJZhshN0b1WfZk+ZvPvShKSbvthyw0HEKtWDGAGg6nfn9KXeCHkg4u9WSbMYyUvr
         y0Fb+1bawhV8YtiH+tJ2MbrucEmYDruXoV0kME455LZd5F91cm+YJ9Nlclhs4d+PjCNs
         9aa68yQMTXmq692YlD7PnPpZNjrWx5sgRnQB6urz2vIlE2+KzrxnueHo96POFFCrLxIP
         M5YQNxbP9XALPBXEYqzk8BuYqtAAUjfHcv6evKKrg5f7uLqj+05o/Ui+AvSaJFtG246X
         6vLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700691331; x=1701296131;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHQ5lVYi4/2MX2skoChLDy6Ocqhy29V3zUGeEPzVvPk=;
        b=UQq06CsoEeEUQ6oQlpdTs5FDuR8OTE7raVNWsWdPHP1YwCL2CzYI6m7caAtTF41gRE
         jbNvbKJnuopxshlo/+3PIyppt8ISa8Ggd2A65B1Mau8VlmMDhzZUEmAHc2ZdJ5k5zAKa
         O5MHnyIobwwWpi9YHf145yYQruzx/8Nm/Tf3Tf5rGXYFuZjkvbL+219wzMNxCvI+jpGG
         FdZ/D63cU/T5KqJenr4R4fIIshF+0GZLfwQcqNVzf81nj8p2x9sHN9yWFg9vBDmPATMi
         WOX4TXbtx+wSfHj49m/O45RAxVmQDAhgDsF2KW8OgM5RSZpTmvEBLLkC8LewpYNYT+um
         +RAA==
X-Gm-Message-State: AOJu0Yw1eIIONs2wv2OLZaDvt0ppNvnzL8vHtkvejqGWq/6+B9b7S5hg
	0qb1W/v1xygWqI1COvJMuwzUyqUm55xY
X-Google-Smtp-Source: AGHT+IEKPFb2EHSzpX16MEr8UpukYHRCQvq4K7GrE1lzHEciYPJMeZQvd7fCFY+au119NI7M63atWhaudwtg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ce4e:0:b0:da0:c6d7:8231 with SMTP id
 x75-20020a25ce4e000000b00da0c6d78231mr109435ybe.0.1700691330951; Wed, 22 Nov
 2023 14:15:30 -0800 (PST)
Date: Wed, 22 Nov 2023 22:15:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231122221526.2750966-1-rananta@google.com>
Subject: [PATCH] KVM: selftests: aarch64: Remove unused functions from vpmu test
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

vpmu_counter_access's disable_counter() carries a bug that disables
all the counters that are enabled, instead of just the requested one.
Fortunately, it's not an issue as there are no callers of it. Hence,
instead of fixing it, remove the definition entirely.

Remove enable_counter() as it's unused as well.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5ea78986e665f..e2f0b720cbfcf 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 	isb();
 }
 
-static inline void enable_counter(int idx)
-{
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenset_el0);
-	isb();
-}
-
-static inline void disable_counter(int idx)
-{
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
-	isb();
-}
-
 static void pmu_disable_reset(void)
 {
 	uint64_t pmcr = read_sysreg(pmcr_el0);
-- 
2.43.0.rc1.413.gea7ed67945-goog


