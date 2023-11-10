Return-Path: <kvm+bounces-1419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CB57E772A
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27D6CB215A2
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F10612F;
	Fri, 10 Nov 2023 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4UsDFgy+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1562567B
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:33 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC22D49CA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28047dbd6dcso1733364a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582412; x=1700187212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xR4tNxv+g07FJHlmB9dj3yDxoywssp8UIvL+izkb3n8=;
        b=4UsDFgy+kwsdVXxWBCJ2D9vib0ODCGM75Lhsb373o099RH5BDg1qGOO+FAN0pF+3bM
         FKK7/MyRXMn+ZDvia2IeBOLpechVYY984TXowFicuivK/SizSWT/Y30aZDftDPSNxjQL
         opYK41R6Ue982jaJ/H9MCvMT2M1a6etxQKbIdOc/orIpTLEYPNbDvLk4fh46ncWv7pV+
         DX36j0ySDUQ6YjoMGsXqzFiY9n+q0v0yw8sfMsMnyxgyZ3mBJHhvBhtXrPzuOxdRFil7
         BTLrjXY9vFOIJ5DVIj9MGiIwoWHTpXqnPKlNXIUEju5PUbaXWSo7z+o/UnT7FeBwT9F4
         Ztlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582412; x=1700187212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xR4tNxv+g07FJHlmB9dj3yDxoywssp8UIvL+izkb3n8=;
        b=QBH61+FbAuTYDOXuqHPm8djQ5DRVYqcNPVIuqm5h+bRUD7L/ZAFm41F3qt4HMb4PEj
         6mXEameFSQyLdeWLh04wWcWXmOwEqhIp4EaDsZbwLCrCpBwJ+X0qoOau7ugJrvWpwYBg
         yZ59F4A0gLYRfYTDYw9AyPtnd1javwx0NFaeUBw7oxginkmbxS5XzSiDOFh+GaZwxt5/
         WzqnhacCQSfFustPaf1uKog3OZK7R5HpcoMC42Tay2qsha2bw737i2vG+W5vk7vL7Ha1
         deo9XF9O3l7JdVS3va/ZNO88hoMnVSrExxbX4GsgQ30sf9n+WIjgNrcQ/Ig5HXwNpT93
         SQsQ==
X-Gm-Message-State: AOJu0Ywjws9YSHyAeiYRp2eBk9i12i7CUf9/h4Xxve0CQF0B0DH6WRS2
	Bv4jGKY/zvLqnHluXHBeh219hh+8Evw=
X-Google-Smtp-Source: AGHT+IGk9Th9IVLtHKmeUR2wtmElNnCg6h0KoNuCyxTp8Aq1fusMyQ/Jl9J62V/d2c1CkvE5vAdM050RYzI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:344a:b0:280:cd4e:76d2 with SMTP id
 lj10-20020a17090b344a00b00280cd4e76d2mr823816pjb.7.1699582412087; Thu, 09 Nov
 2023 18:13:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:50 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-11-seanjc@google.com>
Subject: [PATCH v8 10/26] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
the name is redundant with the macro, i.e. it's truly useless.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a01931f7d954..2d9771151dd9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -289,7 +289,7 @@ struct kvm_x86_cpu_property {
 struct kvm_x86_pmu_feature {
 	struct kvm_x86_cpu_feature anti_feature;
 };
-#define	KVM_X86_PMU_FEATURE(name, __bit)					\
+#define	KVM_X86_PMU_FEATURE(__bit)						\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
 		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
@@ -298,7 +298,7 @@ struct kvm_x86_pmu_feature {
 	feature;								\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-- 
2.42.0.869.gea05f2083d-goog


