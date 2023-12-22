Return-Path: <kvm+bounces-5148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7BA81CAEB
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:51:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC9B61F249D8
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25ED71A598;
	Fri, 22 Dec 2023 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TceO7nzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317DE1A70A;
	Fri, 22 Dec 2023 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-28bf27be6c4so854083a91.1;
        Fri, 22 Dec 2023 05:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253072; x=1703857872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GbTP9pyEfLW8+fO86ti39WKj5aM3Ikce3+WhF/QSJE=;
        b=TceO7nzLGqQfIx2N2+htlACYAGJRN/v/dkWpGoPmxLad9j8SkCQvbcP+4FOWroMb3T
         jI6PEw01LAKKUHr5Qx55b98buufRO0NZkiWCRUcrlJpu8e7czV2sb7vN4burBawubL4D
         mPuNDGJXtKF945zsIdWCMZu9hDhHEyMFxM+P7UZ1pn/4drrs1X6/x0LRxZA6p14jrip9
         tYpFzL/pJGTG07Fz2Uiz1ULFcW1z+TDCrgyealm6DMTu5DCGk9OitXcK+wjfZFeXMOQB
         VDKb/V2FIxQnpEoyLklSJAyGWJepadyD9qvUhOy3oRs9HKK9L6ciNOyPMxDKF6Z4FFVa
         S/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253072; x=1703857872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GbTP9pyEfLW8+fO86ti39WKj5aM3Ikce3+WhF/QSJE=;
        b=lRaSdeMW+2Ucjk14lL8isbjG2xg3FttVeKQDOa5Mj/pUUB8Nbc3bUa6+j517+cxdSL
         ZPDDrYVx5hv3Z8Xgge+aCQw7+RUbKma+o/2bOMiGrUhus9Td0yVP/iIrs2bf4iVWn8Ew
         JCqx5SFfJU1mJ1Z5W4lK7s6LCOSqLUIaH8ShUGYvM/quACAZCijQlfKOePuSQqYz6Yz5
         /iRhkW6b9BRyDM5sLTp7BXG/cIudDP311Z9FzzKsqtPLxsYZuDnRTzNNql1QuPP8ABYS
         /jil8EGqlnbJI6g1aCzGX36NAqg6jZDqUQi5jQsQ1quWbsfNe0gZTZJTviIAD/LHAVB/
         gdPw==
X-Gm-Message-State: AOJu0YzKowAx7BOVPe4Mt9vq03YudDN90QP8RgLy9X+NxmrEKQ1OQLEa
	R2fzfvUS6Sj6twe8JBzxxH0=
X-Google-Smtp-Source: AGHT+IGJI92l6o3kvWR/9nnc+3uwUDhIQTyXexnYVp7D+d/n+yWUp/xYOOZ+9JgltI8VuCq6hAiw9g==
X-Received: by 2002:a17:90b:e8b:b0:28c:27:dc87 with SMTP id fv11-20020a17090b0e8b00b0028c0027dc87mr840659pjb.49.1703253072589;
        Fri, 22 Dec 2023 05:51:12 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:11 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 1/9] s390x: clean lib/auxinfo.o
Date: Fri, 22 Dec 2023 23:50:40 +1000
Message-ID: <20231222135048.1924672-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd009..95ef9533 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -227,7 +227,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
 
 
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d lib/auxinfo.o $(comm-key)
 
 generated-files = $(asm-offsets)
 $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
-- 
2.42.0


