Return-Path: <kvm+bounces-6034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF6B82A5B9
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C90D28B87A
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99268257C;
	Thu, 11 Jan 2024 02:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/Prt7W+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F216110F
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 02:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbea05a6de5so5788060276.3
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 18:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704938456; x=1705543256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SfisKc9ufFv9a7SmizBx1UAzf631mmq7jI6n3buw95E=;
        b=L/Prt7W+qLQtSixtHUPxuITHKFxaXo3oNoNS/s50MDDLr25CNooHRVb6lQmHE4VZVu
         qiZqtgoKBTwGxpSZKEmkXf516KJJP+rapdd4B7tTFTIgl6kTLuIs+j7FYlZhT1UN9t4j
         WmvG6CLFTejdc7qNhizASNDBbR9XOIT4GVRDgIYWc7urbZ+5nnRTUhHV96ZoMcP1LO1m
         Afas9nHDqVTU4GMzu82WgIe/mzUduoVv8a5y7NO6oZhQChpUvSMqIOhNzfWQxr7sAOzk
         k1Zn+NZGPZtWQVHsu1m9Kjdr0aVMNM1XSkuNliOgMjdFLLW+hV9WVsZbyTXNjgt8hr3C
         E0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704938456; x=1705543256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfisKc9ufFv9a7SmizBx1UAzf631mmq7jI6n3buw95E=;
        b=NENrayuLw7g0eg+ldjTvQUjqdPRhFJ1cnrRWbUAOVYtTi73Fxil/i/za8PKqpGuM6B
         srV7T1UEgMw0yn0wPbmsU4ezxdjAzcCfDFkzq+b8Irlz+91DSh/VLxQla0Ogb6XiQqG1
         fGNAEY8TzwT9CTtEPVQD/cACP9WSt3vVBJm29tu3BuIZMOQfx/0Ezkq0T7iO7/MdGhn2
         UCWvTEfsbnsHt64+GGDqz01Yq8SypVBPUJOgtpqBlvIGpWVJHmRL5ism4k84O5oYU7jz
         8Qkn78d6uMCskjDNwQ5qdzSZd1l7Rz/KkkuyomnsbobRVvN25kEhoy2cRy5ygvIm31hY
         x9tw==
X-Gm-Message-State: AOJu0Yx7aagAb/PPElejG5iIqtcjiDHH9t2IWUaxFgkiKwjNz/9IX/JZ
	5bN8QMr/kO/QI/P4ne4aD4Vo4jT174e7+agRTA==
X-Google-Smtp-Source: AGHT+IGGWpDDh5XpprEp6J9VIccg3KI+1ylvIJG3ySsOn2OkL4yYLmL25smhU4dgMdYekhhrPGmQCn5Bj+w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7404:0:b0:dbe:111b:8875 with SMTP id
 p4-20020a257404000000b00dbe111b8875mr25375ybc.12.1704938456484; Wed, 10 Jan
 2024 18:00:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 10 Jan 2024 18:00:42 -0800
In-Reply-To: <20240111020048.844847-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111020048.844847-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111020048.844847-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: x86/mmu: Don't do TLB flush when zappings SPTEs in
 invalid roots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pattara Teerapong <pteerapong@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't force a TLB flush when zapping SPTEs in invalid roots as vCPUs
can't be actively using invalid roots (zapping SPTEs in invalid roots is
necessary only to ensure KVM doesn't mark a page accessed/dirty after it
is freed by the primary MMU).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 372da098d3ce..68920877370b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -811,7 +811,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_iter_set_spte(kvm, &iter, 0);
-		flush = true;
+
+		/*
+		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
+		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
+		 */
+		if (!root->role.invalid)
+			flush = true;
 	}
 
 	rcu_read_unlock();
-- 
2.43.0.275.g3460e3d667-goog


