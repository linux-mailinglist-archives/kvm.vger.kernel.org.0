Return-Path: <kvm+bounces-1445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D69C7E7782
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6F351F20C1D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0295679;
	Fri, 10 Nov 2023 02:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVYanNPj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC55224
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:17 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF414698
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:17 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5ae5b12227fso23110457b3.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583356; x=1700188156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ViZOepyyuHgGywDg5p020KLGJgQ5sVyIecAWPub5Hkc=;
        b=FVYanNPjEfH+zeSC5oEqFite2i8NIG+HdTxHDaSx6wnqHorabARC7TWVNA9o5LYRaS
         TCEyrbmz2I4tdvWVo5zg5a2SjyPRbuvd2xwLDfdj1r0eZuoGExVICIckYrGhkoPgYF9F
         rxvro0cjTbu4zNRXx7/8ejk3q8INK80cCE7N+vUHD6nJyhOlD7/ARqs6gX/VVQQkugHg
         cDT5mHrtS93c4vXPaVfqr8bDT7U8orVJYuVFowQccUvjwv2qaysrVb0EZ/+JL+IDsoYF
         J7wQgdtDSVt5KsGbthOYVbWfRFiFLFl8OFc6nDi0I1nwnvzEfU9eaq4Zav/TJePoeW6k
         Q3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583356; x=1700188156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ViZOepyyuHgGywDg5p020KLGJgQ5sVyIecAWPub5Hkc=;
        b=W7rhdojre/axQa9rgGbYPNp/Vk9Zju9DRU5VinmIoVkpskI6ffL3TDzU62liSi8SVD
         gQLgU/tjt+iSltiANOtVLaohxXb6S16Q8ZbXCZJ3D6VC47goS/ntBtdy3tAb+e+eP+vE
         jK6OBaAF98GoR/QvdFviJbqVtoyrxXbaxknC8TjotQQgzzkHNDh4OrXdRQqMP8SP/lqH
         h3BFbj/jbxUWnF3VjxEQVAXzGthhPYVBTA9mwjExEW/xDQqIz4gn06I9H/dwdn4fGcT7
         QFB9XUAHv1LXYW6IML570/6WwbvhudSldNmGm/fcAudHqrboEDmllsy25bTXSkzf3Qix
         s/tg==
X-Gm-Message-State: AOJu0YzhzCk5wriIh7C2eRm0JbwnfbV2S5y1cSP/XyezawCuSdz1oIOC
	xqnm0iMuyJg1flFxqlR9EjrbJf/uUfk=
X-Google-Smtp-Source: AGHT+IEz4Npt3on2y4c0ZdLIwoyVoJbdLf5cd4Ndcm7P56uuGjm8a/8+nhf+7OOsw6XqF0hZ+DExIx7za1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9a44:0:b0:5be:94a6:d84b with SMTP id
 r65-20020a819a44000000b005be94a6d84bmr197455ywg.5.1699583356692; Thu, 09 Nov
 2023 18:29:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:55 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-9-seanjc@google.com>
Subject: [PATCH 08/10] KVM: x86/pmu: Expand the comment about what bits are
 check emulating events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the comment about what bits are and aren't checked when emulating
PMC events in software.  As pointed out by Jim, AMD's mask includes bits
35:32, which on Intel overlap with the IN_TX and IN_TXCP bits (32 and 33)
as well as reserved bits (34 and 45).

Checking The IN_TX* bits is actually correct, as it's safe to assert that
the vCPU can't be in an HLE/RTM transaction if KVM is emulating an
instruction, i.e. KVM *shouldn't count if either of those bits is set.

For the reserved bits, KVM is has equal odds of being right if Intel adds
new behavior, i.e. ignoring them is just as likely to be correct as
checking them.

Opportunistically explain *why* the other flags aren't checked.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 45cb8b2a024b..ba561849fd3e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -850,7 +850,20 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		if (!pmc_event_is_allowed(pmc))
 			continue;
 
-		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
+		/*
+		 * Ignore checks for edge detect (all events currently emulated
+		 * but KVM are always rising edges), pin control (unsupported
+		 * by modern CPUs), and counter mask and its invert flag (KVM
+		 * doesn't emulate multiple events in a single clock cycle).
+		 *
+		 * Note, the uppermost nibble of AMD's mask overlaps Intel's
+		 * IN_TX (bit 32) and IN_TXCP (bit 33), as well as two reserved
+		 * bits (bits 35:34).  Checking the "in HLE/RTM transaction"
+		 * flags is correct as the vCPU can't be in a transaction if
+		 * KVM is emulating an instruction.  Checking the reserved bits
+		 * might be wrong if they are defined in the future, but so
+		 * could ignoring them, so do the simple thing for now.
+		 */
 		if ((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB)
 			continue;
 
-- 
2.42.0.869.gea05f2083d-goog


