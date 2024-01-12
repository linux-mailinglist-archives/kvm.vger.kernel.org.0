Return-Path: <kvm+bounces-6132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3323A82BB5F
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 07:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6A2E1F23AA5
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 06:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2400E5C8F7;
	Fri, 12 Jan 2024 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h18Bs2vP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C54482F2
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-5f8cf76ef5bso53716257b3.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 22:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705042361; x=1705647161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FIOzTLtW6keTaBF5ggaLnbp11ZiLLE0KH+rZwnUDbmg=;
        b=h18Bs2vP3ZfNJOu632gEd0ZDwyY7WjojNooUJA6gZKXckCP72WBT8t1az2n8EazwjX
         nDlv3RqcGvA3ZPGhCb3S9i97LOdI+NlQkHxSjiw9DYg0GlSxcRO3K6YbIpkT1UK7zypW
         L8O+V4Hr/DHSjIsIcwBUI1FV8l33f1zVZfe5KTbERzMlehli7q9uWCO27dfwQJMK2Ylz
         ElfJiGawCOPPtDJexOED+STefvL4U48lUUrkTrTMUaWP7NZ00/PGuhUsTt+IxZ2ZPNpC
         T/0kJVlzDp0Wb8tEq21GaPsbzRMCzFOy4P3UL3GR2jDITuiyn7jrKLy0Yg3IJ5+wqCvD
         Wx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705042361; x=1705647161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FIOzTLtW6keTaBF5ggaLnbp11ZiLLE0KH+rZwnUDbmg=;
        b=cw41erEJs7WYSLddZqUgTq6Wxq48Ql5MTY/SH242OYjkLV8sqsMVDHfwhRKioVPm+6
         scW0qhdLqu6MWXIMyHq2i5oDkONVIYCc340UW1fwACfNEgzHoq/I7voorGRoURc3YeCZ
         9iKLdYs3qkjn43p2IvRlV3TmzqKr8U3O01Ut6q50Hs1iiBt0X7fJphJJPFDlMKHQX1w3
         0Z/Q2JDkq5EvgIXALcGQUr9ZtmIF+yeNw0HstnECVe1NcFpNdOIoyMeNhHjVD9fA7uZz
         FyEG71qngGRBQTab1TfjPsJcIwPzYe6gfFtkLhcWZo5l1KLihWPrtHoC/ujUfT8Vxyk6
         1Zkg==
X-Gm-Message-State: AOJu0YwjyJ05nYewCWY40EbS/VDH4G4z0b6RZPhpAbKTPbbuzfj9x9dI
	E/A2ZabssZ/SbgR3y+8FpFg=
X-Google-Smtp-Source: AGHT+IHoZJ8KJdrlu5lqza0YkFJdo/ikYoiZg8+W11NEMnryiM0c450pIXR6rulK13NAShuXd45G7A==
X-Received: by 2002:a05:690c:3386:b0:5f7:5f66:326c with SMTP id fl6-20020a05690c338600b005f75f66326cmr1104676ywb.72.1705042360908;
        Thu, 11 Jan 2024 22:52:40 -0800 (PST)
Received: from localhost.localdomain (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902f1cb00b001d4d288005asm2320425plc.266.2024.01.11.22.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 22:52:40 -0800 (PST)
From: Robert Hoo <robert.hoo.linux@gmail.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: Robert Hoo <robert.hoo.linux@gmail.com>
Subject: [PATCH] KVM: VMX: Correct *intr_info content and *info2 for EPT_VIOLATION in get_exit_info()
Date: Fri, 12 Jan 2024 14:51:59 +0800
Message-Id: <20240112065159.982-1-robert.hoo.linux@gmail.com>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fill vmx::idt_vectoring_info in *intr_info, to align with
svm_get_exit_info(), where *intr_info is for complement information about
intercepts occurring during event delivery through IDT (APM 15.7.2
Intercepts During IDT Interrupt Delivery), whose counterpart in
VMX is IDT_VECTORING_INFO_FIELD (SDM 25.9.3 Information for VM Exits
That Occur During Event Delivery), rather than VM_EXIT_INTR_INFO.

Fill *info2 with GUEST_PHYSICAL_ADDRESS in case of EPT_VIOLATION, also
to align with SVM. It can be filled with other info for different exit
reasons, like SVM's EXITINFO2.

Fixes: 235ba74f008d ("KVM: x86: Add intr/vectoring info and error code to kvm_exit tracepoint")
Signed-off-by: Robert Hoo <robert.hoo.linux@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21f55f323ea..f1bf9f1fc561 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6141,14 +6141,26 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 
 	*reason = vmx->exit_reason.full;
 	*info1 = vmx_get_exit_qual(vcpu);
+
 	if (!(vmx->exit_reason.failed_vmentry)) {
-		*info2 = vmx->idt_vectoring_info;
-		*intr_info = vmx_get_intr_info(vcpu);
+		*intr_info = vmx->idt_vectoring_info;
 		if (is_exception_with_error_code(*intr_info))
-			*error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
+			*error_code = vmcs_read32(IDT_VECTORING_ERROR_CODE);
 		else
 			*error_code = 0;
-	} else {
+
+		/* various *info2 semantics according to exit reason */
+		switch (vmx->exit_reason.basic) {
+		case EXIT_REASON_EPT_VIOLATION:
+			*info2 = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+			break;
+		/* To do: *info2 for other exit reasons */
+		default:
+			*info2 = 0;
+			break;
+		}
+
+	} else {
 		*info2 = 0;
 		*intr_info = 0;
 		*error_code = 0;

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.39.3


