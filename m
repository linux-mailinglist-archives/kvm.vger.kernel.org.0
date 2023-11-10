Return-Path: <kvm+bounces-1447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 291F87E7784
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF560B213EB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A8063BC;
	Fri, 10 Nov 2023 02:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zRKh4SLV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5D5C96
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:21 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDE946A2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:21 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7be940fe1so23203197b3.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583360; x=1700188160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nldJcIoxrE7izfzF9tusQOHRIp84adzxmoDFeEutDYo=;
        b=zRKh4SLVVccVIIY2w+/ksNwChGdMHeCC8urKg8hX1Uj3SHDFS47SJachQQiZoLiAi2
         3s805g1nae/9qvvqbpBJ2GIyQENa1+ZDSQh+1zy/rPE3tcYTR5TXpKm1MSrxzjAyvHUh
         ndqcyEOvOMqSH6/ANOnVHKCjMoMLczgOIrqI0KoYOtIIS4tIOMZjXceHGG/4EU8SIU3e
         ah0a/KwctVPF0JUX7KP3f8863qrBcqBZiFmFi/3XjWQ7od3sLF2YSV9XmUO+JmhlV6aY
         J//CueNrqVCQcXng1Xey/Ro/sOGdMlxnmiG8736ASI7XEarduldYXGzV3a/uWzQHfSh+
         iNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583360; x=1700188160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nldJcIoxrE7izfzF9tusQOHRIp84adzxmoDFeEutDYo=;
        b=lZd8ctfErXUahIqIUFLHNPQhx3PJX110AlTf1hPn2D1GtDFiJPaxObgaQTgmZvp8zg
         jQ49wVggIRenXItvoofRfYn+m/CMfajS4eP4US7tm+Ml8uJ5tA5XRO9XNb3y5i4D9Vn9
         0MQjNDEMplfe+F87L3EULB43oNi27l1SHXDodFqh77uWAPmJ9i+KLR71ipy9d3lV+3CC
         LoIIb72NyQqrcOrc+ZdtSx26c8ez5GGYGcdWADfVM6Wx9ErR/4WZH33SCJtiputBnbVh
         8hvK5BeLSpys0Gbo3+9o6XsWHOG4T8p4rMbsUbkjMUojqWihVQzfOOHaNMmk5GsKXcxL
         r0BQ==
X-Gm-Message-State: AOJu0Yzn6/tHnd/kw8NyuuVJ+AcJ76tkmllXipGL454wRUAlK+8i/QDJ
	ANFLVxGVS1BEKC/DOH4JonjWWQm2Pqo=
X-Google-Smtp-Source: AGHT+IFi2OuUxDtj5dLEyBOq5j0Fpq5odHUnkilHEMHd4jTjkDkeO9IJsflGDTKbTVEEKP8m+JUs86IyIw8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9286:0:b0:595:5cf0:a9b0 with SMTP id
 j128-20020a819286000000b005955cf0a9b0mr173826ywg.9.1699583360474; Thu, 09 Nov
 2023 18:29:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:57 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-11-seanjc@google.com>
Subject: [PATCH 10/10] KVM: x86/pmu: Avoid CPL lookup if PMC enabline for USER
 and KERNEL is the same
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother querying the CPL if a PMC is (not) counting for both USER and
KERNEL, i.e. if the end result is guaranteed to be the same regardless of
the CPL.  Querying the CPL on Intel requires a VMREAD, i.e. isn't free,
and a single CMP+Jcc is cheap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a5ea729b16f2..231604d6dc86 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -828,6 +828,13 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 		select_user = config & 0x2;
 	}
 
+	/*
+	 * Skip the CPL lookup, which isn't free on Intel, if the result will
+	 * be the same regardless of the CPL.
+	 */
+	if (select_os == select_user)
+		return select_os;
+
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
 }
 
-- 
2.42.0.869.gea05f2083d-goog


