Return-Path: <kvm+bounces-5958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5B2829190
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9D73B22943
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168B81376;
	Wed, 10 Jan 2024 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QbZY9/17"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0770C389
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbea39ed9f7so4001881276.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847365; x=1705452165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=04w38U9GonKmSGxDFO1/SRu2BQxYyvlVeJi9FSHTFdY=;
        b=QbZY9/17H+fRGiBJdZ3Fl6iRLglfOg7t5LZ5HCfGPZR9tYiLvKAhoChAdrxL8c1tPH
         JbtXs+r3j9bsFH7In910fqxDsrzCfLzxX3lBU0N7p0MlYo2SF07gCuF2wAITKXYi2+K0
         GTgxHEbCHCrqjhZ2ylHT7n6pADWgWbVYGnLpDAQAZSSkbIv0vM5rg2d4y/YJQRWF8aNh
         ZierED08Mldpo2q3vcXcK9yo+Cac4RC/xoteJcMfAmpmSIyAm9Lk99AUMs2d1EZQm2H/
         vS0oMdtWIM29EWsoO1w9U2cwqd67X6w/MXVRqsGeetPk6z/zT7Wl0NVxIPeBlxoKlZ5r
         iSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847365; x=1705452165;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04w38U9GonKmSGxDFO1/SRu2BQxYyvlVeJi9FSHTFdY=;
        b=V/w4wCXXpEDoR9sstSelo1FYD1Ay3XHQuWfjqQ8jKxTx4Etzc9BFSleic3B7JuqRgT
         Oa/uuxbkWXkCVZFn1evVFrTP0Sj8URWMEpPZgAwttJZrqVs41wPic2PTOubiJFreBNlB
         N5+68ADZbaXa2pJYV6lns/wkh5KSzihwFd00oDsvnkTBHUPSzV502jmb0r1KsTluGpav
         Uy1kawULwvNQcW9ttj7wZYPTrchR+C1ipEhaixisKI1heG6buda67p/ko3qw7K4K6i2f
         3dzuTTsavGWwJNumz0wPLlrMH5B3SFArJD7K+8AN2rYQ06pX1eqKGxaw3STwFiwjPG/h
         E0vQ==
X-Gm-Message-State: AOJu0YwzMH+gOvoQ9i7tMC1pll2/Bvv5yH+T+IPYZjgOYqjsK+NljBD6
	6EN1SM1k0bXCkFWQ4EWaOjOfChDLKSpdGlZRWg==
X-Google-Smtp-Source: AGHT+IGmfvtDwOOm8IfwTNj7WM0QUJgexKiSyyFjdUVgfHvnYtR2wmzMChAjIl6Mw/cWH4pRXsuaEtO/eUs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:84c6:0:b0:dbd:73bd:e55a with SMTP id
 x6-20020a2584c6000000b00dbd73bde55amr11011ybm.4.1704847365128; Tue, 09 Jan
 2024 16:42:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:42:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110004239.491290-1-seanjc@google.com>
Subject: [PATCH] KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end()
 calls
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When handling the end of an mmu_notifier invalidation, WARN if
mn_active_invalidate_count is already 0 do not decrement it further, i.e.
avoid causing mn_active_invalidate_count to underflow/wrap.  In the worst
case scenario, effectively corrupting mn_active_invalidate_count could
cause kvm_swap_active_memslots() to hang indefinitely.

end() calls are *supposed* to be paired with start(), i.e. underflow can
only happen if there is a bug elsewhere in the kernel, but due to lack of
lockdep assertions in the mmu_notifier helpers, it's all too easy for a
bug to go unnoticed for some time, e.g. see the recently introduced
PAGEMAP_SCAN ioctl().

Ideally, mmu_notifiers would incorporate lockdep assertions, but users of
mmu_notifiers aren't required to hold any one specific lock, i.e. adding
the necessary annotations to make lockdep aware of all locks that are
mutally exclusive with mm_take_all_locks() isn't trivial.

Link: https://lore.kernel.org/all/000000000000f6d051060c6785bc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..8f03b56dafbd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -890,7 +890,9 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
-	wake = (--kvm->mn_active_invalidate_count == 0);
+	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
+		--kvm->mn_active_invalidate_count;
+	wake = !kvm->mn_active_invalidate_count;
 	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


