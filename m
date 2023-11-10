Return-Path: <kvm+bounces-1402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5EE97E75FF
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E5DE281738
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BC3EA9;
	Fri, 10 Nov 2023 00:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhyUe2VD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B9A40
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:37:49 +0000 (UTC)
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D330EA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:37:49 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5b9344d72bbso1482999a12.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699576669; x=1700181469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ+20GJF9og6oa/Hffl1p5Z59Ddq/p4BfMNvoHc9/hM=;
        b=zhyUe2VDEwvHcga1Uk+zNXgM/WOwhOaBFN33FOzEwkntM7JqQUBheZRkad3xRVA5Mt
         QI1BGRKSjyUmyAvfs7dL+uBerDlWieF/PzWXf3FcvLfjc2vtxLjgEL7X6SJsGmb1laD/
         9xZebf7wnBdiBXRJonV/bFY1kjXV0OhJcCofqfy5If/QTJqUxy6XpDgSwV+Oi6juZC71
         S6jsIoB+WsErt6iKu1xhCDuGp/CqifXJIOo3gpCNXmRewrSoXArA8fsgeE9kSLnwMKlh
         3sgeK5TnSYyue2dWgU7j3emGlzIESCIuxLlGRWpKbbicfFt7ECG57U0ZiXWtVhweXfHc
         VyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699576669; x=1700181469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ+20GJF9og6oa/Hffl1p5Z59Ddq/p4BfMNvoHc9/hM=;
        b=GQz1XLqpv3Hm254p89+kV5ZXm0XXFCRNCdn2WQJbJhCIlyKSSIyEZcm4YLLNOZKlKp
         4z+xtcmMjsb164feopo5uu8D1thUDEsqqkltQ9Woxh79fmhAlPGo7boGL+Vi/Oq/bKjU
         vgsrdqY9nCskaTQnWqbc5M5HwarP19E8Mw9lkUwoutvaLETM9B74F6wxS8GHFngMa8wI
         qtCB+qfsN1bqWP7pHwlpTHkYvt9PiCq1hoaAZPaESXgd+6oScZM3O79Fo4a1bUhLfage
         9DgQ1H+7St7CFq5l26p2os9vg1FYtBhlV15mdCCAuGsf9gy6S0mapDQeisx5IYLRV3pF
         wk0Q==
X-Gm-Message-State: AOJu0YyCuhLDE8Uh7IHA2c8lzDMuKXhWswZ9Zn2Zhq6hhP5Zu/AS3f+C
	yx2K3CoH7zN79lU2KyRufWcgZH4FvVs=
X-Google-Smtp-Source: AGHT+IFXpaGvtWqWxLumtqQssFNp8Ii/mu7CzZRjvjV734OeDhKj0PYfbWcW6oplVWABqQBcf/rEkHNaEBRb
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a63:2646:0:b0:5b9:390c:efcd with SMTP id
 m67-20020a632646000000b005b9390cefcdmr789644pgm.5.1699576668755; Thu, 09 Nov
 2023 16:37:48 -0800 (PST)
Date: Fri, 10 Nov 2023 00:37:31 +0000
In-Reply-To: <20231110003734.1014084-1-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231110003734.1014084-2-jackyli@google.com>
Subject: [RFC PATCH 1/4] KVM: SEV: Drop wbinvd_on_all_cpus() as kvm mmu
 notifier would flush the cache
From: Jacky Li <jackyli@google.com>
To: Sean Christpherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Ashish Kalra <Ashish.Kalra@amd.com>, David Rientjes <rientjes@google.com>, 
	David Kaplan <david.kaplan@amd.com>, Peter Gonda <pgonda@google.com>, 
	Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the wbinvd_on_all_cpus inside sev_mem_enc_unregister_region() and
sev_vm_destroy() because kvm mmu notifier invalidation event would flush
the cache.

Signed-off-by: Jacky Li <jackyli@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Suggested-by: Sean Christpherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..7fbcb7dea2c0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2043,13 +2043,6 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 		goto failed;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
-
 	__unregister_enc_region_locked(kvm, region);
 
 	mutex_unlock(&kvm->lock);
@@ -2147,13 +2140,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
-
 	/*
 	 * if userspace was terminated before unregistering the memory regions
 	 * then lets unpin all the registered memory.
-- 
2.43.0.rc0.421.g78406f8d94-goog


