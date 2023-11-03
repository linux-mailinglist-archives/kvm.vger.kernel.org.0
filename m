Return-Path: <kvm+bounces-539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF6D7E0BDE
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D0C280402
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6969E2628A;
	Fri,  3 Nov 2023 23:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WEk0je4O"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7F1250F0
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:05:53 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118A5125
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:05:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc1ddb34ccso20328145ad.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052751; x=1699657551; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8r9KyLTXzHPbLN5BIkdsSD83nOYaYPo3Uiesh5mapqg=;
        b=WEk0je4OxmlYws5A2zp0yML7uSsa2wiAdrh7tf36y8axz/Kpgm2WMW0ZZVjKt5zK3r
         9GYmXPcJekkE+uP/C7F8u5HsvDNNLiRweecdeuTq9GjRGKxJhKRR/ll359lOd1JAPy/I
         XRsJobfd0Ai/SfB3MkcV2Vq7aVJF1vISz/km47vleHaT8ypy0UUweRvFvm8WSfBkMiBN
         umfs1WZI2w+6TOqWWc/NAF7nsxxKQfrDlO41VpPVKYqJJF4jsmmHZH5GhCpDBIhY9C1K
         Qonw36bPXDzwrIhwxYeIyif5+SKuZ8P5/BKjYRsuojXBKfzjLSdCJXcOheBmGZQpFJNo
         uclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052751; x=1699657551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8r9KyLTXzHPbLN5BIkdsSD83nOYaYPo3Uiesh5mapqg=;
        b=RrWNzaC2LAP6sqRnR/WTTet7b4rkYkKpa6SolGv3jMdFOwCRMF/pE4ZGR6jPfNSYSE
         OiVMhmwGcWPEIkgOYNSDmBY8K+Z/7d66TH/55EsEg1UYwxWWVhjyg7bVBhRsMSw+8711
         En7a8EVlfNWQaeSgb8ff31iwxn2PZJFj3wKaqyLJ+SGIEQCzfwH5oNaapRn0JjeBh8nt
         C4O0Ana0G4m97GJM5iSVVVBzchMkdtN9XtLLEX7exsQRefaRgJscyP5ZD8jEhB2VA6EJ
         AxxVKgOVTzTqzMgnWIvT5i0AtLuzyX1sWLDWN5154bvsra37sV0oXo+I/wBilwA/roPy
         HspQ==
X-Gm-Message-State: AOJu0YwQkbH/xm+ThmZlLpyxXa0Dj+8P25g+I2niAnTSKb0D6un80XFp
	fwFqyuEm/gj3V45WJwzVqpEFFjK1/2E=
X-Google-Smtp-Source: AGHT+IHPFl9rx3FEGjophWX1BIYSgQUn/Wb8sMkl1ur3aPB+4a48Xmek6HCimoafytzVOV/hsiz7QCQWDgE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d718:b0:1c5:7c07:e403 with SMTP id
 w24-20020a170902d71800b001c57c07e403mr408772ply.10.1699052751476; Fri, 03 Nov
 2023 16:05:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 16:05:39 -0700
In-Reply-To: <20231103230541.352265-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103230541.352265-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103230541.352265-5-seanjc@google.com>
Subject: [PATCH v2 4/6] KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Remove code that unnecessarily clears event_count and need_cleanup in
kvm_pmu_init(), the entire kvm_pmu is zeroed just a few lines earlier.
Vendor code doesn't set event_count or need_cleanup during .init(), and
if either VMX or SVM did set those fields it would be a flagrant bug.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 458e836c6efe..c06090196b00 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -710,8 +710,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	static_call(kvm_x86_pmu_init)(vcpu);
-	pmu->event_count = 0;
-	pmu->need_cleanup = false;
 	kvm_pmu_refresh(vcpu);
 }
 
-- 
2.42.0.869.gea05f2083d-goog


