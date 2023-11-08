Return-Path: <kvm+bounces-1104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 699AA7E4E11
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67CE01C20DA2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643F66122;
	Wed,  8 Nov 2023 00:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mcuBP0qP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F1846AF
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:31:52 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A48170B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:31:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da03390793fso7188600276.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403511; x=1700008311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xR4tNxv+g07FJHlmB9dj3yDxoywssp8UIvL+izkb3n8=;
        b=mcuBP0qPGUO84/kUz8vmjV6Gtnm+1X39C8G3AoHnlxpn9GODEWIQICrU97Y8LVHmH5
         wsisMZjO9tHWduxCKM7Hk3y9zWAKSZPkEhPjZ+b6G/CK5eYmahqJxGgkbGXSaA3QVIp1
         lpkeRKeq58bpXFr3qhEQOKY/0n6lTxX/qNENL81LC5s8MiCh3aMltl3Ggrf4G0RXS3uc
         QKIhPueQkz/3PgQcu1/rAbK1DOdyrLAsqbzqcR65xNlcNFjSuOYrpsLvIo5blZkkpqYL
         NJPeRXtsXHO85/v20pnmK/rtFUQNR0ZvfEf+BTWFd3VswUtMtF5eIfIc/afOZOwAornB
         VQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403511; x=1700008311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xR4tNxv+g07FJHlmB9dj3yDxoywssp8UIvL+izkb3n8=;
        b=veyDSVAFZAdljoT8duv8NJ7TtzzFAhf5hGcxsVnfWN+UCmLGXOGy48aYhUxgO77O2z
         rcsgBz3y1LqQ3abZF4L2vuYvtd55f4CJCJUCNPJ+XEzFs3FVLEjSgWjAi0IGxwKlFeoe
         3uQ+4TUBIcAb5FbQnJS1oTtGZW8eGt86rVgX8jbhLa4BV6g8L42wWMbi/hhoHWdXHizs
         Lka+2wYLGTZZL9rxxfbE2rKaJKw1aDo7EUw02ZyJYZBdhoF1odeTPcYbesiNKqHJxWrB
         1qv6ijLh3HtS/U9So3UG51K8t6m1bfO0mCHjXbYwG0iC03JV1C5AkoWimHTjpcNNOrR5
         zwGg==
X-Gm-Message-State: AOJu0YxpNKZfuj81+sWkqAHIudZ8yiSFfUjkfzlQ7Ehes2WGI4OWFN2/
	Hbs7OkyLYotAFzFt2/DRbTPhIBc7+JQ=
X-Google-Smtp-Source: AGHT+IEMuUTqh4Bl3DMMRgwFv9jyV30xQL6LnHwAkTaR1MPQyVNzmMe6GDxJa4AwDqIXY4bVj1WjZTNM/DQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1366:b0:dae:49a3:ae23 with SMTP id
 bt6-20020a056902136600b00dae49a3ae23mr6014ybb.7.1699403511034; Tue, 07 Nov
 2023 16:31:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:22 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-7-seanjc@google.com>
Subject: [PATCH v7 06/19] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
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


