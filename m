Return-Path: <kvm+bounces-1404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C597E7601
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B8A728181D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2E315BB;
	Fri, 10 Nov 2023 00:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iV98z4mh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D411100
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:37:55 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DF330F7
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:37:55 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6baaa9c0ba5so1442352b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699576675; x=1700181475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YXe1be8qnNn0x7GZbKXXV/k/uEMYhSF1HxhpE5xWXKw=;
        b=iV98z4mhuRmPoQY5FmM5Z/BrXWxFbosl1deZHRFbclyy1aa0rPb+h2gkUeVwFzArgc
         7AzwLN1yu6jqF7VFd4W1jwvptIPHgR6AsI/vIyUbieQ/tB7aEoD1VGoGU1ZhcX3cPBmC
         BDaVj0vyc/hOw/3+bhMHabPwl/5VTToAoLy2mOpGiMz6APY/ebrpzgb/XazQxLDu3pFa
         sYnjSxtyk9g5YIX+tWwGyGOFWMbnzKpwkWi5iCxa2fdoP+Z14uk8KuUB5zBKfDGuaOlo
         kTUB3NuG4i9GzlfpG66h3ln0H6nWP2Vfj/vzOp1w+Gj6gT9wWsojnw3oxeInzDRr9gsm
         TS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699576675; x=1700181475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YXe1be8qnNn0x7GZbKXXV/k/uEMYhSF1HxhpE5xWXKw=;
        b=hsFYBPZcBgNI0zptEgMl0RA9P/l6BWcG16rLY2FwmoLHzmfGJUN/RYCfuT1LnZrl/j
         OZl5JFJRBXpdrTEKAXkVnPplCfyB6rvIM1NkhprCw5FX969/nnjLJKtv67hnE/gcchOd
         FhxlcD/KZ2MoFoJ4lSkEfSeg6PLtB2nzaFUeYh+TkU4pyOnWDOqFXAgT8JheblDrTAIE
         HUFd31D0/WgAx/sTPvbEZKTbfzHmyRkDsvvEgizpdgyYWfkN4mUFckNTii/irMY1fhSe
         go/zQiF3KFs+b6oSM4i1Id4FIfX6k3DdlrXoKNl72MamJzjPcY1mnfRj1JLXfMAumckp
         61dA==
X-Gm-Message-State: AOJu0Yy3QnbG0+ZXF0BH0jHsOuz1kiRlgz1m6Hv05QDk6TUdWQyGKt2X
	CKD9k9YRwSVO5jjbNio0S4bMHwbjpyc=
X-Google-Smtp-Source: AGHT+IEvp5PwpdGC1FM/b65hH3sJ3uWP2EQVNqWLMqkuS2ZtSg/vI3UJs4HyW1wN7whkXJ+iaNUMqrG6YVhX
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a05:6a00:80c8:b0:6c2:bca7:640b with SMTP
 id ei8-20020a056a0080c800b006c2bca7640bmr906522pfb.3.1699576674765; Thu, 09
 Nov 2023 16:37:54 -0800 (PST)
Date: Fri, 10 Nov 2023 00:37:33 +0000
In-Reply-To: <20231110003734.1014084-1-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231110003734.1014084-4-jackyli@google.com>
Subject: [RFC PATCH 3/4] KVM: SEV: Limit the call of WBINVDs based on the
 event type of mmu notifier
From: Jacky Li <jackyli@google.com>
To: Sean Christpherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"

The cache flush was originally introduced to enforce the cache coherency
across VM boundary in SEV, so the flush is not needed in some cases when
the page remains in the same VM. wbinvd_on_all_cpus() is a costly
operation so use the mmu notifier event type information in the range
struct to only do cache flush when needed.

The physical page might be allocated to a different VM after the range
is unmapped, cleared, released or migrated. So do a cache flush only on
those events.

Signed-off-by: Jacky Li <jackyli@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Suggested-by: Sean Christpherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8d30f6c5e872..477df8a06629 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2335,7 +2335,11 @@ void sev_guest_memory_reclaimed(struct kvm *kvm,
 	if (!sev_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	if (mmu_notifier_event == MMU_NOTIFY_UNMAP ||
+	    mmu_notifier_event == MMU_NOTIFY_CLEAR ||
+	    mmu_notifier_event == MMU_NOTIFY_RELEASE ||
+	    mmu_notifier_event == MMU_NOTIFY_MIGRATE)
+		wbinvd_on_all_cpus();
 }
 
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
-- 
2.43.0.rc0.421.g78406f8d94-goog


