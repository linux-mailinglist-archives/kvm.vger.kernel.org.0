Return-Path: <kvm+bounces-5654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2026824524
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B2C3282FBC
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9356424201;
	Thu,  4 Jan 2024 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqIe4ayG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A08241E6
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704382785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lR9Lg6efDMWUQ39ZY0+d6GK0COxADHJuB4vzRo0+m64=;
	b=KqIe4ayGncbWLuNQtY1VHNCxWbB6xR98yhONYoOelJhurWhP9ZPaUk7gMDuAg9d/0WS4rI
	MGl9Cl9pwD49A7e8iLeqj8rlu9U3uv9wAmLhnyWFWBli3BN4/ln0T/A06a1JiCRKa2RhY/
	iRW4OEHHjfy46VJz+zcz3dD6rUH4gwI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-QHHWIMB5PTe9pbsGlcqFBw-1; Thu, 04 Jan 2024 10:39:44 -0500
X-MC-Unique: QHHWIMB5PTe9pbsGlcqFBw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50e7b20360bso563350e87.3
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 07:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704382782; x=1704987582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lR9Lg6efDMWUQ39ZY0+d6GK0COxADHJuB4vzRo0+m64=;
        b=fgaKTN4Kp/nWiqK/u1bHiMx3Gmz0+FUpp1rXteqM7yD/V9nBjiYhB3g5BWE+P20jCS
         Z2RBxRtuJl3mqM92Mv6XDGhZS/3rEolRcasUWPXQpeg/xaZ6g7Y4iSMiLOYkY7J6EX1H
         Pc8DTDEAqf+ZAZdJy92Nf4TwUC7i2qWZwWZRGdpe2QkyI6QNSVmv/TwcCuAQK9sIySSz
         mKif5bCQ9VLMcAHJRBTcnutQ3uqkPnYoIu44Ftqnnu+HFAtIefoWRoXtLoQ/kQAjoBU9
         JEhtbVGXffvWsLiL3i9UOTY8mJhN5Yupe8GE3TvRiHLsbWqe5aVLZKGI3SHNDoTDPZWB
         XGiA==
X-Gm-Message-State: AOJu0Yy2vqLYKvz7T9IOvvbf2mBW8KyAR4j2Vwp36mI9WGVkZVbFok/G
	ioi173EOHunDu7dNV8E6nmBy8r0g9l1qjgTLWv69vvroKsOSWgQbzAV8Oi6iEmy2yKt2mRLDD9r
	7yPNhGUjbWU+4OOjMV8cL
X-Received: by 2002:a19:f01a:0:b0:50e:554a:5254 with SMTP id p26-20020a19f01a000000b0050e554a5254mr474322lfc.13.1704382782606;
        Thu, 04 Jan 2024 07:39:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu9javDIy7DAvlh5SvpsOLrDB2cSXh02eiu2QZnwzU3RtCF7X/KQBdvren0KIGZjgmGmI6YQ==
X-Received: by 2002:a19:f01a:0:b0:50e:554a:5254 with SMTP id p26-20020a19f01a000000b0050e554a5254mr474316lfc.13.1704382782236;
        Thu, 04 Jan 2024 07:39:42 -0800 (PST)
Received: from [192.168.10.118] ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.gmail.com with ESMTPSA id fw34-20020a170907502200b00a27aabff0dcsm5751748ejc.179.2024.01.04.07.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 07:39:41 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kan.liang@linux.intel.com,
	peterz@infradead.org,
	luwei.kang@linux.intel.com,
	linux-perf-users@vger.kernel.org,
	leitao@debian.org,
	acme@kernel.org,
	mingo@redhat.com,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: fix masking logic for MSR_CORE_PERF_GLOBAL_CTRL
Date: Thu,  4 Jan 2024 16:39:39 +0100
Message-ID: <20240104153939.129179-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When commit c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE
MSR emulation for extended PEBS") switched the initialization of
cpuc->guest_switch_msrs to use compound literals, it screwed up
the boolean logic:

+	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
...
-	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
+               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),

Before the patch, the value of arr[0].guest would have been intel_ctrl &
~cpuc->intel_ctrl_host_mask & ~pebs_mask.  The intent is to always treat
PEBS events as host-only because, while the guest runs, there is no way
to tell the processor about the virtual address where to put PEBS records
intended for the host.

Unfortunately, the new expression can be expanded to

	(intel_ctrl & ~cpuc->intel_ctrl_host_mask) | (intel_ctrl & ~pebs_mask)

which makes no sense; it includes any bit that isn't *both* marked as
exclude_guest and using PEBS.  So, reinstate the old logic.  Another
way to write it could be "intel_ctrl & ~(cpuc->intel_ctrl_host_mask |
pebs_mask)", presumably the intention of the author of the faulty.
However, I personally find the repeated application of A AND NOT B to
be a bit more readable.

This shows up as guest failures when running concurrent long-running
perf workloads on the host, and was reported to happen with rcutorture.
All guests on a given host would die simultaneously with something like an
instruction fault or a segmentation violation.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Analyzed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/intel/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ce1c777227b4..0f2786d4e405 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4051,12 +4051,17 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
 
+	/*
+	 * In addition to obeying exclude_guest/exclude_host, remove bits being
+	 * used for PEBS when running a guest, because PEBS writes to virtual
+	 * addresses (not physical addresses).
+	 */
 	*nr = 0;
 	global_ctrl = (*nr)++;
 	arr[global_ctrl] = (struct perf_guest_switch_msr){
 		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
 		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
-		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+		.guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask & ~pebs_mask,
 	};
 
 	if (!x86_pmu.pebs)
-- 
2.43.0


