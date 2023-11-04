Return-Path: <kvm+bounces-550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3834E7E0C75
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC1BAB21715
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54B5646;
	Sat,  4 Nov 2023 00:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cf35BIGg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FF320EA
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:48 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C0FD5F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afe220cadeso35256067b3.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056166; x=1699660966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D/rIH8GJk/IJPB5pqHHZ2EWC6jVCZLZPq4HYOnxUc90=;
        b=Cf35BIGgAvlwQ+n1pQBl2TYlhFecQtLuiALXRejxKRxu8FSdNrEBVqY404/+ZunHwF
         1/A3RdiT2KpfK2JDtTPWw6ZpVyqQ3yvWlSPj3KGXOQfokkhfhOQkS5uGWtQEy3LwIjSr
         F0VFdPqlsxuMHhKoAywFRRhmaTFU9pV1ZZIS5Mf2VBzp78alsa1P+sWhkFVvaiNUDL1u
         qCrziZX2Zcn/Od6TZfKIdGzumybkDniVdyWReh2/H0FxboEyC48+6GXzt11douvrP1Jk
         HuzG5VDnhyjY5G6xP+9/ETJ02RqrHTzAO5kGuKlLoE7Wds9yQle/VRJTnRBta/vjNq53
         LalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056166; x=1699660966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/rIH8GJk/IJPB5pqHHZ2EWC6jVCZLZPq4HYOnxUc90=;
        b=PDxQ8hWiYLc3382jDSYl+G2ysEIARGLutgQx2aHu8VZxobMljt3EAGjLgE3Z3V7ekG
         RoXBXtS+eCHKXarkY97iYgekJtqgp9vIXdMhYWkkOnlLd3ohtHxEtV2qgCQWrWl+jMgr
         bJOOVJMzmM/usRkBD4SkyJBKiL4FrTZ8sMLnRQ6XHqe7LkqVdXfZIhN+PHiaXccE+Q3b
         rRBczDIvC7RxaQwa8DSPmhQaf2eOtI8H2wQC0AfzH4hlyrjTQVZAhr4ZFOiVnYA7VERI
         TFAk+mOjQLZFUFheQbJd9//Zuj6S9xVo4XZ7tIo6+Lv6HZkJCr8a7LaaA8JSG0EQAu5N
         sSdw==
X-Gm-Message-State: AOJu0YxnyXZF+WrIbrSuvP0u0Rt8g/tYQvb5r2P/sZx1AvvqERm7dO8r
	N4qlRw2YwN8vVZYwGz8htFd34LH7WWo=
X-Google-Smtp-Source: AGHT+IG48HKOrJNtDtKClRR1cSurzfdJukbcmuWuNiNDq8LQjymDh0gNZfHiM6JwALmJySH4WydrLAOP3ds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr544412ybu.7.1699056166538; Fri, 03 Nov
 2023 17:02:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:21 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-4-seanjc@google.com>
Subject: [PATCH v6 03/20] KVM: x86/pmu: Don't enumerate arch events KVM
 doesn't support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't advertise support to userspace for architectural events that KVM
doesn't support, i.e. for "real" events that aren't listed in
intel_pmu_architectural_events.  On current hardware, this effectively
means "don't advertise support for Top Down Slots".

Mask off the associated "unavailable" bits, as said bits for undefined
events are reserved to zero.  Arguably the events _are_ defined, but from
a KVM perspective they might as well not exist, and there's absolutely no
reason to leave useless unavailable bits set.

Fixes: a6c06ed1a60a ("KVM: Expose the architectural performance monitoring CPUID leaf")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3316fdea212a..8d545f84dc4a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -73,6 +73,15 @@ static void intel_init_pmu_capability(void)
 	int i;
 
 	/*
+	 * Do not enumerate support for architectural events that KVM doesn't
+	 * support.  Clear unsupported events "unavailable" bit as well, as
+	 * architecturally such bits are reserved to zero.
+	 */
+	kvm_pmu_cap.events_mask_len = min(kvm_pmu_cap.events_mask_len,
+					  NR_REAL_INTEL_ARCH_EVENTS);
+	kvm_pmu_cap.events_mask &= GENMASK(kvm_pmu_cap.events_mask_len - 1, 0);
+
+	 /*
 	 * Perf may (sadly) back a guest fixed counter with a general purpose
 	 * counter, and so KVM must hide fixed counters whose associated
 	 * architectural event are unsupported.  On real hardware, this should
-- 
2.42.0.869.gea05f2083d-goog


