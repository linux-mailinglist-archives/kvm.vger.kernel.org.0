Return-Path: <kvm+bounces-5956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9388B82918C
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1772CB25FC8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187278F61;
	Wed, 10 Jan 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YZutqnol"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1EE523A
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28c05e74e36so4145162a91.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847186; x=1705451986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Pqe71wm1M+G2sxafHwJo+rZxz6yjUptaYMkbv+1aMM0=;
        b=YZutqnol1HrLWmrIvBtq9YKcUcRem3wQuRHt0Z6JPlQJdhkdkkIy6b0H1Novt9dfrw
         x3Y1+dfoAsXhqHNqwgbrnIiRlbJrc1EZam8ca79n9SxW1xiOyB/jpe0vrw2kSzE91B7u
         68QOdMNX6JKL3kBG7xhNoNfRph7JkNN9N6Do87ftmzaNsunYJBzQp7iEaDfW7t9SUP/I
         i3twlbvl2vaB70CY//4mX6SxTNsvZNX//3chVKTAw8c3k3CCWemLxE1nYOb0uQb0DkwQ
         zmJGzI7RlvjNTEOkWNt4KIEgXvGz/9cvXycDoWCuV8bse1qrm3bqFacrFtIUWnDFt3rd
         hUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847186; x=1705451986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pqe71wm1M+G2sxafHwJo+rZxz6yjUptaYMkbv+1aMM0=;
        b=xJNOFV7Co3ZVdWklRz1rIOQs9K/hTBOcWrHtFes6M5M1edKQgr1TWTlLWeQaTMkRFO
         1xsQPQWyWK/nj6roBLuXX+tqAQd4ySJAknp76DMkW4NbFqdZ8M7qCb030lXrtgxz/fE6
         V9+Pz7qzuhLztKaDQ8CajQciztNE5hj8qZyxT99yOB5IkDkyq+Ga2vKek1I7ljxeoWBW
         1Q54ufnojvTAYO8eW6HiZIx2OrCQfwQ76XZUQFcVZxsbbHE3Ud82RkvBD2bBSmIBH+cn
         9gsNhOuvZ8FYWqVPM66AFqjVTT/m7ZhuBdbmceTSglzVuyv99cdPDTnER18VOjljNK8J
         Xvjw==
X-Gm-Message-State: AOJu0YxNIoDGXlQCQYnfM+yTCE/d0wSbSe6ocoRdUqeSpLCBXDKEKAZ0
	1N4Sw+I9EKeL7SUHuW4ccyqggCgUlVJP6qSPnQ==
X-Google-Smtp-Source: AGHT+IHy3G82NSplUegkyA2Eh3U1cZHYVq7yVh3SDYUhCqB4HtyzIO3xeq0bjWvyF5FfhYIa/SDY5MlL1wM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:38c2:b0:28b:4489:38fc with SMTP id
 nn2-20020a17090b38c200b0028b448938fcmr10289pjb.2.1704847186504; Tue, 09 Jan
 2024 16:39:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:39:37 -0800
In-Reply-To: <20240110003938.490206-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003938.490206-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86: Clean up directed yield API for "has pending interrupt"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Directly return the boolean result of whether or not a vCPU has a pending
interrupt instead of effectively doing:

  if (true)
	return true;

  return false;

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77494f9c8d49..b7996a75d9a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13083,11 +13083,8 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_apicv_active(vcpu) &&
-	    static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
-		return true;
-
-	return false;
+	return kvm_vcpu_apicv_active(vcpu) &&
+	       static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu);
 }
 
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
-- 
2.43.0.472.g3155946c3a-goog


