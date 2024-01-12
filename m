Return-Path: <kvm+bounces-6135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D6B82BCB5
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 10:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A97EC2847C6
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 09:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B76F55C0E;
	Fri, 12 Jan 2024 09:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jhr2AQNI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CBD53E23;
	Fri, 12 Jan 2024 09:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d542701796so34974145ad.1;
        Fri, 12 Jan 2024 01:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705050708; x=1705655508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qMuJxodUd9VV3Qxl91WTHBtCJuBuWwNcEvUDQ+YaOzU=;
        b=Jhr2AQNIP+nM5qzASgypn9itQ6hU+1SBYA1QjzFkFA0I/ds8ey2MIPyiTN1YY61clQ
         kvUZyYDUcXgow0I6TBbZfAOA1hJVYn2jU34x0hHWOY5nxmuLd3J8lfU+FDKBSa7iwRzl
         Yfnf89eiI/wGr3hsJ7GbtrN9qkd7E3qKCjmN9rIBbNpostnTN3/7gFuOSPDKCsNLjEpk
         hLfgQokmr4CzTNeq3ORvL0eT6Ub+j5szbd6E/8/sb3PjrvuWlB/aIkeQOH6+8y3aaMnf
         xgqDMtB6GThIrHMdOrg5ADOqlWKRQcRVCzSsMCKudlT/GdJPsEL5pSc4Ef7yneT3Y2ac
         XFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705050708; x=1705655508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMuJxodUd9VV3Qxl91WTHBtCJuBuWwNcEvUDQ+YaOzU=;
        b=WpSD2y6rKLK4/SIwV8cgQJ0v8dv59Bet2D+n2Qa9X7qmfSaW+gpFj3KdW51CCfjRAT
         FpLgWMdxzEHB868ZLkXSKjnXyq5dc7YdvEHTg6SPC8wSPtvEpiAAyGIWzNa/UoLDMOTm
         Y19HfG6fLT9yON1PZaRFeHPXcSvdF8g4qImNIKK+wnuGtzvRz4WlFdTwpH35IHNFWj6v
         4wXG25aiBYZiF/Al3+uVr+b8+EoWWuprVzWOCJO3jUr475THFz24UxXQDvu2ZctRAGYJ
         vgGGhrlOoHiHahEhwxo0WjKL4/bJiIMXbroVDo8MLYA0dzd735iAP37xsBOMatT8du1R
         VdTA==
X-Gm-Message-State: AOJu0YyMAxjfKyPnOlLigJKwPRFDxoCWvXVJyRAyA7kS2HSOawWMybj4
	tJDXy3S6/Jz6QYOOQoFMm44=
X-Google-Smtp-Source: AGHT+IFFsmtJjYTRQMDLmi+7YLinX3zx+FkqB+3/SiZ8HjUkMSUys2T0G9ooEh92WPBbE311nbf3HQ==
X-Received: by 2002:a17:903:298f:b0:1d4:1ee8:869d with SMTP id lm15-20020a170903298f00b001d41ee8869dmr634978plb.37.1705050707646;
        Fri, 12 Jan 2024 01:11:47 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id li4-20020a170903294400b001d59f73a0b5sm1416918plb.75.2024.01.12.01.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 01:11:47 -0800 (PST)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: wanpengli@tencent.com,
	up2wing@gmail.com,
	Yi Wang <foxywang@tencent.com>
Subject: [PATCH] KVM: irqchip: synchronize srcu only if needed
Date: Fri, 12 Jan 2024 17:11:28 +0800
Message-Id: <20240112091128.3868059-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

We found that it may cost more than 20 milliseconds very accidentally
to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
already.

The reason is that when vmm(qemu/CloudHypervisor) invokes
KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
might_sleep and kworker of srcu may cost some delay during this period.
Since this happens during creating vm, it's no need to synchronize srcu
now 'cause everything is not ready(vcpu/irqfd) and none uses irq_srcu now.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 arch/x86/kvm/irq_comm.c  | 2 +-
 include/linux/kvm_host.h | 2 ++
 virt/kvm/irqchip.c       | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 16d076a1b91a..37c92b7486c7 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -394,7 +394,7 @@ static const struct kvm_irq_routing_entry empty_routing[] = {};
 
 int kvm_setup_empty_irq_routing(struct kvm *kvm)
 {
-	return kvm_set_irq_routing(kvm, empty_routing, 0, 0);
+	return kvm_set_irq_routing(kvm, empty_routing, 0, NONEED_SYNC_SRCU);
 }
 
 void kvm_arch_post_irq_routing_update(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..a46370cca355 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1995,6 +1995,8 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
 
 #define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
 
+#define NONEED_SYNC_SRCU	(1U << 0)
+
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
 int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *entries,
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..cea5c43c1a49 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -224,7 +224,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	kvm_arch_post_irq_routing_update(kvm);
 
-	synchronize_srcu_expedited(&kvm->irq_srcu);
+	if (!(flags & NONEED_SYNC_SRCU))
+		synchronize_srcu_expedited(&kvm->irq_srcu);
 
 	new = old;
 	r = 0;
-- 
2.39.3


