Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD505F9BB
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfGDOHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51912 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfGDOHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so5897990wma.1;
        Thu, 04 Jul 2019 07:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ECChYGSgqPJWyIb7qwTvg49fGB2JZ3kEyqx7NGS7lF4=;
        b=Qsieq6booTxze/yJXXGgq8HBRJiBCmV/chqDyZsuIE4TM/4htz/KQzyKRQatL1ioEh
         nxpa+ZWtK2v60W5W5KRWFFSjpkT2cRyokzUlOlZFbVywBqeBQu+buUOrL0jgSSN/QL1a
         jaiJq7FQVJ3Iqssy7oXB2xGOu/amsQzktyfRXndX/CSZQVLtuy1Ku6MCOL2UPlZ+CQa5
         pbPh+W1IMrpXXxC654uMUmUo1dRHFlso8pGG80nTojkHbGeXQn6lLqgIL0F1d/AlwGox
         zs5acLAv4VLQiiG6xb4T6NTjH+heg8ah9I/ftHFEeN9e18KhktTihfcst0r3qZF5e7MK
         iwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ECChYGSgqPJWyIb7qwTvg49fGB2JZ3kEyqx7NGS7lF4=;
        b=rCKdpQZZf42FC/bLvP2zCFoe1RLjvL2tjUVdoa7ZBwg1eTynl5H2pgLbs344LNHh/s
         fNmP8PFMvUJnR7pDRGrMdQdpcL9BtaRS14QVhaYmRdaQ+Qz1ClUPuo6njKEMfzQ+wz9Q
         Pn+xVO6PTpFxWQ/IugCiibpqKIy4uau17HqiTNaAWRUEZie8zdfCf8ZQDfG2lG3Ge0aA
         48UgsRHem+xPAbhdaKE9Xplaqde4LLOgPtLhQHaooOoA/AL09CNIuPCaV9DLTxaFp3dW
         2xleHaIsN5hR1FZjKyPw6xX7vzR+p0XF+V/VToohjY/jvB2p36SUIvb5dTr4Pc0gRHU9
         fXOQ==
X-Gm-Message-State: APjAAAWxillH0/vi46lEd2PtsR1GJzyd+zcJWnxQGtThbg2VbXz/mJTd
        9uFZwURLZymyLWYflw5kdoO/qDLWZeo=
X-Google-Smtp-Source: APXvYqyT87GQgKhopyeSqmmY/O6fjvFFd98RkF1ZyRUuGVRuCt0weOWYn3s9DSrRVKrcOfGrsjKBWg==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr2147263wmb.160.1562249241150;
        Thu, 04 Jul 2019 07:07:21 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:20 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 4/5] KVM: cpuid: rename do_cpuid_1_ent
Date:   Thu,  4 Jul 2019 16:07:14 +0200
Message-Id: <20190704140715.31181-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704140715.31181-1-pbonzini@redhat.com>
References: <20190704140715.31181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

do_cpuid_1_ent does not do the entire processing for a CPUID entry, it
only retrieves the host's values.  Rename it to match reality.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9ebc5ae7fa0e..d403695f2f3b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -289,7 +289,7 @@ static void cpuid_mask(u32 *word, int wordnum)
 	*word &= boot_cpu_data.x86_capability[wordnum];
 }
 
-static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
+static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
 			   u32 index)
 {
 	entry->function = function;
@@ -487,7 +487,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	if (*nent >= maxnent)
 		goto out;
 
-	do_cpuid_1_ent(entry, function, 0);
+	do_host_cpuid(entry, function, 0);
 	++*nent;
 
 	switch (function) {
@@ -516,7 +516,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (*nent >= maxnent)
 				goto out;
 
-			do_cpuid_1_ent(&entry[t], function, 0);
+			do_host_cpuid(&entry[t], function, 0);
 			++*nent;
 		}
 		break;
@@ -534,7 +534,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			cache_type = entry[i - 1].eax & 0x1f;
 			if (!cache_type)
 				break;
-			do_cpuid_1_ent(&entry[i], function, i);
+			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
 		break;
@@ -557,7 +557,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				goto out;
 
 			++i;
-			do_cpuid_1_ent(&entry[i], function, i);
+			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
 		break;
@@ -609,7 +609,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			level_type = entry[i - 1].ecx & 0xff00;
 			if (!level_type)
 				break;
-			do_cpuid_1_ent(&entry[i], function, i);
+			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
 		break;
@@ -630,7 +630,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			if (*nent >= maxnent)
 				goto out;
 
-			do_cpuid_1_ent(&entry[i], function, idx);
+			do_host_cpuid(&entry[i], function, idx);
 			if (idx == 1) {
 				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
 				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
@@ -662,7 +662,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		for (t = 1; t <= times; ++t) {
 			if (*nent >= maxnent)
 				goto out;
-			do_cpuid_1_ent(&entry[t], function, t);
+			do_host_cpuid(&entry[t], function, t);
 			++*nent;
 		}
 		break;
-- 
2.21.0


