Return-Path: <kvm+bounces-1369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EFC7E733E
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 528A9B20F6B
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 21:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E11A374FD;
	Thu,  9 Nov 2023 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rBQlbKiS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A56C374C2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 21:03:45 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49BA46BD
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:03:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04fb79246so1599450276.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 13:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563824; x=1700168624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e/ZPH+fW+W+TWa6v1thwgh3xl/A5VwjzOhARfEMfmNg=;
        b=rBQlbKiSKG79dz5i6kvFmcJcgaFpvoMO91ea3HFj2CQFJ/OQLW7zcTrp5/79gF4DAp
         GNP0hBzduzaT0zomTg0ipbmEHqlu1tP1Db+XGvDG4kh4SMdrZHNvIWT3ssqMi9blX31t
         TPHMpWAuAG+Q4a8w3lm+/q/UxM7md4hX3mZ+G2zjNr/EvQPYVlMLbzD/e/d2gp6jJTJa
         ZadrJ1d4YY/MMvVdSS8nGWJakJ+a9fT9XBoXEsdO1mPkLXLOcQO6hvqJEVU4XGNi2eMy
         6bgpk6/SA/+j6oqZ3Rj7TK57NuVIeffhlRdKreBN3a0G/5wPuTOubZPM37QAN3vHFHRw
         h/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563824; x=1700168624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/ZPH+fW+W+TWa6v1thwgh3xl/A5VwjzOhARfEMfmNg=;
        b=uGka6anuWq8zf6Uwnbvvj0dshUltFOyDlfi5phJeICmpSEX0Odm6rHUzN4MoUOIK64
         azRPTWKNyOjgf+qzpH77ohlJ1316WWmS/o+/9ulHHYswZDBsUE/+GTN0xi94rUYHxFxF
         VVXcahrZ4V7DgkvbbFJl9Jm4ZVJ1u2iY+mzqdycPB4B5sDlLd9k6Hw4ZGAWrE2dVR7Ie
         1L8HcDn50D20VMb2uuYbXqPbSNU1bsFhbRjIeijmwWXVe11Hll4AWVM6maXOVRPD9vBH
         2tF8ntIrOchai4G9xm6g+WaQqWADhNfFzKmFQkUwk/qFqoUVf8PoXmTkn2xolSL/Smo3
         2Cqw==
X-Gm-Message-State: AOJu0Yw+B/lW8EcH9BMCtqADaxBQuczCen/NLvvJl/DcFr4KQlePnXUz
	GPuv5DRAM8iXi6AqYsEx4y0CIq0Cn/DPpg==
X-Google-Smtp-Source: AGHT+IGaEfaKBu+8pNYilCRAtbdsyMyIV0FpZwyPySRyn2xcyuTHN8dL3ZSfFTUzVJm9BYhJ0Q8k+CrUz239dw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:828e:0:b0:d9c:bdff:e45a with SMTP id
 r14-20020a25828e000000b00d9cbdffe45amr176664ybk.12.1699563824210; Thu, 09 Nov
 2023 13:03:44 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:12 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-2-amoorthy@google.com>
Subject: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The current docstring can be read as "atomic -> allowed to sleep," when
in fact the intended statement is "atomic -> NOT allowed to sleep." Make
that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9170a61ea99f..687374138cfd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2983,7 +2983,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.42.0.869.gea05f2083d-goog


