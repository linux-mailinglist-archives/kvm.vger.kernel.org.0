Return-Path: <kvm+bounces-155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C75327DC7AC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F09E28170D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 07:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5373710A38;
	Tue, 31 Oct 2023 07:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RxHG82JP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC76220E6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:53:30 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2E9C1;
	Tue, 31 Oct 2023 00:53:22 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-53e751aeb3cso8677863a12.2;
        Tue, 31 Oct 2023 00:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698738801; x=1699343601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8328NPnqLMZL/J6Fv5GQFajew6G8hAgprdw35iD2+U=;
        b=RxHG82JPVJurVegwdlMkSsy4coUsZEuZX8J59MW5KFqjcFvqGNevWJZaF6LgTlDgnA
         GEK7MokrR1kuFQW07blnqKoM7kiGz07I9mq4YDlBJ6n+kj9Cw9moNPHntX4+S0T95nd4
         1mx8OpYsINalO2lGj7jDRREvALLB5hSGJ62oV5P444B/qQqWL/1oFLJmTbnXCMAIGNMU
         duD7J30aejEq3KEYy2Nsj/hvWCP91shU3pt2TxXdoEBQseDgg8WwunQCsyczjL8kUSTJ
         ItYRC3uPMH9st3cXK3N7G/Z0oyCumjTy0kCWSc9dnioRBd+jHBI5XuM+pCOyyRlrPX8m
         9vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698738801; x=1699343601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q8328NPnqLMZL/J6Fv5GQFajew6G8hAgprdw35iD2+U=;
        b=S91Ec9/XZx1hQG2Pc6W51orkn5iV833DP86GhHl8RMPDbXslbgtGTIWMAEHzR4PCjf
         nFKWlh05Fr5oIaBBVmYwE9zGUemkVkVpWcuafpMeDhLsrJuw/5tGIIlObntBrxuNWRzi
         HLefyuIaB0QmZ67Lk2ZLWpVJvwYtQt5kLTuT+aBVxBiBV5wqNdLZZJ+S+KLjL88R+5ho
         k7td8RfZ+yJmG+iRativwVBMpnyTa9GsP59aUeRKTaIgtZeapBuUwKEbsNrbEUeoTDTl
         lHdanMMzbpvXfji1EYgz95PvcKw3EzQIevVqb4M+BSdtD0zRz4VviKjn8AZN+MkMyaef
         Rehg==
X-Gm-Message-State: AOJu0YxruUKvL/As/dQO+pI5l+wCS9LG3JoydpVgxRWe95jaqJ/FshEO
	HTH7X9M9O8zslBivARJ3n/zMHkTjiQHhcLLa
X-Google-Smtp-Source: AGHT+IEqKEgVEI97Koipb8DVcAEYDZrOGozzNc3tNWwl9C2i6QP1YXxjyToGsCkDF+2WYSp1elAr3Q==
X-Received: by 2002:a50:9f06:0:b0:53f:25c4:357f with SMTP id b6-20020a509f06000000b0053f25c4357fmr8557733edf.34.1698738800629;
        Tue, 31 Oct 2023 00:53:20 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id j22-20020aa7c416000000b0053fa13e27dcsm659851edq.48.2023.10.31.00.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 00:53:20 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: SVM,VMX: Use %rip-relative addressing to access kvm_rebooting
Date: Tue, 31 Oct 2023 08:52:40 +0100
Message-ID: <20231031075312.47525-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instruction with %rip-relative address operand is one byte shorter than
its absolute address counterpart and is also compatible with position
independent executable (-fpie) build.

No functional changes intended.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/vmenter.S | 10 +++++-----
 arch/x86/kvm/vmx/vmenter.S |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index ef2ebabb059c..9499f9c6b077 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -270,16 +270,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY
 
-10:	cmpb $0, kvm_rebooting
+10:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 2b
 	ud2
-30:	cmpb $0, kvm_rebooting
+30:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 4b
 	ud2
-50:	cmpb $0, kvm_rebooting
+50:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 6b
 	ud2
-70:	cmpb $0, kvm_rebooting
+70:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 8b
 	ud2
 
@@ -381,7 +381,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY
 
-3:	cmpb $0, kvm_rebooting
+3:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 2b
 	ud2
 
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index be275a0410a8..906ecd001511 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -289,7 +289,7 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, kvm_rebooting
+	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne .Lvmfail
 	ud2
 .Lvmfail:
-- 
2.41.0


