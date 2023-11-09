Return-Path: <kvm+bounces-1374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD717E7347
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D5341C20C50
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A0B38FA4;
	Thu,  9 Nov 2023 21:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vlkwxTWI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BE038DF4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:50 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE13347B6
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:49 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso1598576276.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563829; x=1700168629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+5PdZyMdvOdt4VU0TI3yfX/lCMTr3N0qAkuDtTShY=;
        b=vlkwxTWI4LsVc27kx0uB6ZMDkTbhewzlwj1wv/7+uZKvU0ebkS8Onq2v/c3GQoK9Ix
         IbxAXe7wBOnCQChJBhwEZutTLAyFnSySN/KR/Byb5J69u6LneTvQ2NpyMb59JSZdYLXu
         4xCNDF9s4qn9OeLCtFgOVA1rzOIsmfNEYuM/OB28E2xDZxROlHWPPyuvuVdvDgT633iD
         4G2Trl1FIas2H3MF0lEcUHWw1KmvzAOvGiyHvV7Rgk5OxNdWUEmxpOdj9kD68zxX22Sd
         HNTcqLRajakyLjzbN7i71C7uNtHGIZShPKeFFhpL6414aMq8bs6WOGQVz0ArozRKCEqp
         sziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563829; x=1700168629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+5PdZyMdvOdt4VU0TI3yfX/lCMTr3N0qAkuDtTShY=;
        b=xPxHK+VG/9zavJf6AmInTCfXJvZy349Of7/fErIijaeDi6/NZ4Mp2lQmkPPZFMM7z1
         5PE213GlHTPwuM8kXKTOxfALyb+hRlVk/45FCzRUZFHkHzLkh8dle/I5Fb5KhDut21yW
         D7odpp282NW3SJ4XDror8mFrhFgGDlpe+KN697pGhNlSe8Rk7RtvT6GlSUe6Eo+TPW8+
         uWGa9cvssJp53QvFLDA9LSkeSs6MefgyxqnZ6tO/YUdqep+6J3BfZIW/6SqK/UbyY7j8
         DmLxA8fcWVr4IfZSBe8zf1Mrlf6GqkCYuvgvKj2iIXET9XVoKIEzjD+6uMtOdkVFZdV9
         welw==
X-Gm-Message-State: AOJu0Yz5tUSY/w9jR9Gn1C8Mr7er/gEjG7sSNv5xu+ITRYQfsSZSbIgL
	u9GTOHVk6/njnQAVx0RZ5Vt1u+//jvWqGQ==
X-Google-Smtp-Source: AGHT+IEuA2Q5awcM86dll/dLoA1R4aMXnRfBkF4bbpGUOJqZbuvX3Eb5LoClktTK56YlYoIiH1cKlOvlGRBPTg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:244f:0:b0:d9a:3a14:a5a2 with SMTP id
 k76-20020a25244f000000b00d9a3a14a5a2mr153578ybk.13.1699563828968; Thu, 09 Nov
 2023 13:03:48 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:16 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-6-amoorthy@google.com>
Subject: [PATCH v6 05/14] KVM: Try using fast GUP to resolve read faults
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

hva_to_pfn_fast() currently just fails for faults where establishing
writable mappings is forbidden, which is unnecessary. Instead, try
getting the page without passing FOLL_WRITE. This allows the
aforementioned faults to (potentially) be resolved without falling back
to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88946d5d102b..725191333c4e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2811,7 +2811,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2825,10 +2825,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
-		return false;
+	unsigned int gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(addr, gup_flags, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.42.0.869.gea05f2083d-goog


