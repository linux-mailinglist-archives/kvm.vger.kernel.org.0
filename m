Return-Path: <kvm+bounces-1617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A907EA30D
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 19:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C486FB20912
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC8224EA;
	Mon, 13 Nov 2023 18:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZ7gqsa8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393C42232A
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 18:49:03 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599F210DA
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 10:49:02 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so5807504276.2
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 10:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699901341; x=1700506141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jNgWH/rFc3mGC/ACCx2wHKBEbV4edYtwRLQu6JPd9JU=;
        b=yZ7gqsa8NnAipQebUj3LJmIXUoHwFHEisgBs8uwTrZCx+EyQbP63n0muSOiUaj5MUS
         unCNTvYbvMpYv0Gb/DY01UokE2FfMQ05gsvH7DTb6/I0oQbquy/66iluZkDoElgBzLFy
         X4SDZmydNvbe8/u7K+4QZG/Jj4rUP1gRCS/7MymjAXynt+H4X4TjBoPPO0BA2xqVF+Pg
         bHMvkcqOxaBGAwtDMJ+mcXhKRdJfrUCdHS/IhWBKRZMxe6bQMfu9swsojVmGgwKNcOsl
         39gnxmFSIedASsxcplQ8zh853z3Zrsb846O6b5cN1LavcG/bYDaDBc6IRakALpcEO+CR
         4uwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699901341; x=1700506141;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNgWH/rFc3mGC/ACCx2wHKBEbV4edYtwRLQu6JPd9JU=;
        b=dmGCtgYnBvYw2+z/qG7mYAJEpeARowE5IC9YJ+U4w+Oa+aE8caHAMF1LINoaVe0XDs
         YW8Cw5A9QFp5qlYPZqIvP1oDXAJDK6oRUC4jb+jfzAUWxAv+Vp/LTHgCJA+2ec9xUQKt
         Ueznvw2Bpo4cxx7Y9F+/pklYVFZ5F7tmI61+cDrSz+MwQEk+3cNpVdhQZXE7NI7VlZC4
         s/GoQqlkYAMYXTVHx9z5XxP4zXlVpUqmF8vs42ZnHoV4ipLDxcUNZ+U6X9cP1omJY1Rx
         dbYJw3tyFWIvJhujjWU9/AhF7GsJDGCFfMI8r4MpU+rXuPMSeJsGXtRRjNYPLGpY2AR5
         D92g==
X-Gm-Message-State: AOJu0YyKoPPMOnaDjx4e1D+0XBP7ILE4uELdfE4j9PowuF4z4VVOn7To
	GFmi9L0A30DdR15s7eUDCAvn1fgQ6ZMvKBHng6A8qCmIss119S9hzbyg68Djm6DnugZCwvXQJ0W
	nBRhbCV61TRlqjFAOf0EgMlnRlpIuzohB/JzJIrXxcwvKMXF2Kl+i/8XyjvuHDU0=
X-Google-Smtp-Source: AGHT+IHbHpoJiJ5GfhNkv6CX9tr9hziAKu6gd9gEqF8U/XSOc2fdBzp/vF0GBK/lSCQqHkQs4SAeu4DZAtQYnQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a5b:584:0:b0:da0:5a30:6887 with SMTP id
 l4-20020a5b0584000000b00da05a306887mr201468ybp.4.1699901341321; Mon, 13 Nov
 2023 10:49:01 -0800 (PST)
Date: Mon, 13 Nov 2023 10:48:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231113184854.2344416-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Remove IA32_PERF_GLOBAL_OVF_CTRL from KVM_GET_MSR_INDEX_LIST
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org, "'Paolo Bonzini '" <pbonzini@redhat.com>, 
	"'Sean Christopherson '" <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

This MSR reads as 0, and any host-initiated writes are ignored, so
there's no reason to enumerate it in KVM_GET_MSR_INDEX_LIST.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..54bcc197b314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1470,7 +1470,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
-	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	MSR_CORE_PERF_GLOBAL_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
-- 
2.43.0.rc0.421.g78406f8d94-goog


