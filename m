Return-Path: <kvm+bounces-5526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D411822D4C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 13:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C495CB233E3
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 12:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672EA199BD;
	Wed,  3 Jan 2024 12:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEkq6b4+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74834199A3
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 12:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d41bb4da91so31159325ad.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 04:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704285617; x=1704890417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=biXieFKBxT3YGaAIvKZ+VRN1/qPv4rprLydVDOClVZ4=;
        b=TEkq6b4+B7BOvR1dCgf1JnxrjMCqRgUhD+GYuXgzrvMqyZiba+SdbG2cTCB4+DiloY
         FYf1CcmNb6946Os6UQbJReEx46m3rVVy30arGApWYslYa8a6XtWY7vKS8mSW6V4wnrQh
         wUR/TjY4nXT9O21hiqsVSlFvVID13A6kmuyKAV0n33mt4IOCrxVGSeQZrznA+gOgI8AR
         oy+c6AJpvugGeUjJSKgUQg2KkujdnaDVxou2qbAGn4x0DA0NTedWxzmQpUPs3hnJjUFJ
         UsCw6g4OZsWsg9PQtkoKTdecoHzlIJH0VaC4JcKQNMLhmRHxrmYL0wdRjRMUA9/oFTmA
         9nZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704285617; x=1704890417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=biXieFKBxT3YGaAIvKZ+VRN1/qPv4rprLydVDOClVZ4=;
        b=oos+mEwn2x3UmG9UzSVcehOvVgo7WDocskcUNefL/3gPxMgPPPm4cwxtfhfmBbCVbA
         MLqlHuOSznIWZr6rIWZb+bH1/Tw3WQ3I9PwutO+L0q5vkjg6CuTLPybcUqUILRljA5Ld
         XJ5oJQB58ZyFSvX542QtwHlQFEVQIRTWo+yslYCK+gcGzSd8r2mw8Su4XhgRtaps7jVW
         yd1R3jx2SYCvdU1+ATTDi5IYs7YcMNDKf+saK/rkT22VKbUQdaCyRkzKEKNDhc8A7b0x
         BD0A5aUPKoL1TK1uT7jmA3NT4Yi72HupWak9psGFnl/X3la5K0dlZmg0TaDJlzaaR5Hh
         +nOA==
X-Gm-Message-State: AOJu0YyB8bDdGksS9sgSpJ+56Z9WPNSzEQSFmB63AXaxZF3UG6l+jpBK
	SmJIOKTBcka4MbaRsWA3Vx0=
X-Google-Smtp-Source: AGHT+IEJaHQ+FzQnIXl5iqeMMSrw/CLOUve26Z3etZlMhKZfNbJ+xYYQjYVt3OBgQmDT7VfFih6QkA==
X-Received: by 2002:a17:903:1cd:b0:1d4:35ad:41cb with SMTP id e13-20020a17090301cd00b001d435ad41cbmr8268416plh.49.1704285616521;
        Wed, 03 Jan 2024 04:40:16 -0800 (PST)
Received: from localhost.localdomain ([108.181.41.234])
        by smtp.gmail.com with ESMTPSA id v3-20020a1709028d8300b001d4b5e444d2sm5799595plo.48.2024.01.03.04.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 04:40:15 -0800 (PST)
From: Liang Chen <liangchen.linux@gmail.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	liangchen.linux@gmail.com
Subject: [PATCH] KVM: x86: count number of zapped pages for tdp_mmu
Date: Wed,  3 Jan 2024 20:39:59 +0800
Message-Id: <20240103123959.46994-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Count the number of zapped pages of tdp_mmu for vm stat.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2f..7f8bc1329aac 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -325,6 +325,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
+	++kvm->stat.mmu_shadow_zapped;
 
 	tdp_mmu_unlink_sp(kvm, sp, shared);
 
-- 
2.40.1


