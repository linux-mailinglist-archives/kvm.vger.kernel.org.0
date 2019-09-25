Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8278BE222
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501934AbfIYQOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:14:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40500 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501879AbfIYQOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so5599020wmj.5
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I1YJZSEUWipf8xbAeAYPLDcuRWqrfHJ47Ct1YHgHIZo=;
        b=vQTYefryCDcSF2U8R7Ki7hz5+YN1HnxDMn638NR5h38080cWkrDmHjuwlav7PNLMpn
         iUingeqRvXw3bCsurT0wAmm4XJKbxk2lVx9xubePPqOftpk41BclXzklBD+0N/UT+Ucx
         gnEgqtr2BorQUIBJuYqbTWdOZCAaDPCcODTbQUCJRb0V6xiEBJx2gIE8Hzl+cFcoG01s
         +xMUrNLm9GbMd/Mfd8bywD1Xy6Lah6kD8cPbgIly42Up5FklQqlZGRWplOTXQGFb7BF1
         Ei4WnDS/SfgR+LCHX/qdXKUdDjQ2eEN+STqSamb8E8JIrP8Q6hnRLpT+oiGrOh+nmXfF
         Lwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=I1YJZSEUWipf8xbAeAYPLDcuRWqrfHJ47Ct1YHgHIZo=;
        b=mg59UUKAKCKeghxYoByn5P9WHvegPIbHPjW6nC+Mndpo5h9lCHp0tihA0xp/kwe66B
         r9z/KnvmKBAXaui9eq7iOzIKSkEtNdseOVVp6T2tJ4J5At8IvvZgx4A4AH3RRLi4WIZv
         IE8D1UMs7ksh8Sq1F7+8TRmsTzQuoWzFqtrygAiuRdbCWiUpVIDrLn6+1cxmExcIGM6t
         hbUw99LVhuXWMTMbQJf6TiF+zVsbPAdcL78YBgcsGoFDlYZkpVeog3hdhSkWt/RSg7he
         7SogRCmYW1OZGPHlbwEG0MI5uv42X4tHtUPoiPpYxlaD/WG9H0WrJDY6H/4XBcx9xMpu
         FsPg==
X-Gm-Message-State: APjAAAVbnfRh+LbeaDEMZoMxPvQsHeVnCM69dkqO7s5f9qWAolVk2zZY
        KMAzsOB1pNeUEuC1YfPrACurEFGt
X-Google-Smtp-Source: APXvYqza/nPRN7MeLyIlrFXcFFEtQ2YlRWghy5Ju7xK2tLesPOVU15++P2rRajHCn8F7WpUisF5hlQ==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr8545979wmc.111.1569428070799;
        Wed, 25 Sep 2019 09:14:30 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a71sm4055293wme.11.2019.09.25.09.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:14:30 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 2/4] x86: vmx_tests: extend HOST_EFER tests
Date:   Wed, 25 Sep 2019 18:14:24 +0200
Message-Id: <1569428066-27894-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
References: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the tests to cover the host address size bit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 126 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 52 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b404219..8851f64 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6720,59 +6720,62 @@ static void test_host_ctl_regs(void)
 	vmcs_write(HOST_CR3, cr3_saved);
 }
 
-static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
-			   u64 ctrl_bit, u64 efer_bit,
-			   const char *efer_bit_name)
+static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
+			  u32 ctrl_fld, u64 ctrl,
+			  int i, const char *efer_bit_name)
 {
-	u64 efer_saved = vmcs_read(fld);
-	u32 ctrl_saved = vmcs_read(ctrl_fld);
-	u64 host_addr_size = ctrl_saved & EXI_HOST_64;
-	u64 efer;
+	bool ok;
 
-	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
-	efer = efer_saved & ~efer_bit;
-	vmcs_write(fld, efer);
-	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
-			    fld_name, efer);
-	test_vmx_vmlaunch(0, false);
-	report_prefix_pop();
+	ok = true;
+	if (ctrl & EXI_LOAD_EFER) {
+		if (!!(efer & EFER_LMA) != !!(ctrl & EXI_HOST_64))
+			ok = false;
+		if (!!(efer & EFER_LME) != !!(ctrl & EXI_HOST_64))
+			ok = false;
+	}
 
-	efer = efer_saved | efer_bit;
+	vmcs_write(ctrl_fld, ctrl);
 	vmcs_write(fld, efer);
-	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
-			    fld_name, efer);
-	test_vmx_vmlaunch(0, false);
-	report_prefix_pop();
+	report_prefix_pushf("%s %s bit turned %s, controls %s",
+			    fld_name, efer_bit_name,
+			    (i & 1) ? "on" : "off",
+			    (i & 2) ? "on" : "off");
 
-	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
-	efer = efer_saved & ~efer_bit;
-	vmcs_write(fld, efer);
-	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
-			    fld_name, efer);
-	if (host_addr_size)
-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				  false);
-	else
-		test_vmx_vmlaunch(0, false);
-	report_prefix_pop();
-
-	efer = efer_saved | efer_bit;
-	vmcs_write(fld, efer);
-	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
-			    fld_name, efer);
-	if (host_addr_size)
+	if (ok)
 		test_vmx_vmlaunch(0, false);
 	else
 		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
 				  false);
 	report_prefix_pop();
+}
+
+static void test_efer_bit(u32 fld, const char * fld_name,
+			  u32 ctrl_fld, u64 ctrl_bit, u64 efer_bit,
+			  const char *efer_bit_name)
+{
+	u64 efer_saved = vmcs_read(fld);
+	u32 ctrl_saved = vmcs_read(ctrl_fld);
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		u64 efer = efer_saved & ~efer_bit;
+		u64 ctrl = ctrl_saved & ~ctrl_bit;
+
+		if (i & 1)
+			efer |= efer_bit;
+		if (i & 2)
+			ctrl |= ctrl_bit;
+
+		test_efer_one(fld, fld_name, efer, ctrl_fld, ctrl,
+			      i, efer_bit_name);
+	}
 
 	vmcs_write(ctrl_fld, ctrl_saved);
 	vmcs_write(fld, efer_saved);
 }
 
 static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
-		      u64 ctrl_bit)
+		      u64 ctrl_bit1, u64 ctrl_bit2)
 {
 	u64 efer_saved = vmcs_read(fld);
 	u32 ctrl_saved = vmcs_read(ctrl_fld);
@@ -6783,10 +6786,19 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 	if (cpu_has_efer_nx())
 		efer_reserved_bits &= ~EFER_NX;
 
+	if (!ctrl_bit1) {
+		printf("\"Load-IA32-EFER\" exit control not supported\n");
+		goto test_entry_exit_mode;
+	}
+
+	report_prefix_pushf("%s %lx", fld_name, efer_saved);
+	test_vmx_vmlaunch(0, false);
+	report_prefix_pop();
+
 	/*
 	 * Check reserved bits
 	 */
-	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
+	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit1);
 	for (i = 0; i < 64; i++) {
 		if ((1ull << i) & efer_reserved_bits) {
 			efer = efer_saved | (1ull << i);
@@ -6797,15 +6809,14 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 		}
 	}
 
-	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
+	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit1);
 	for (i = 0; i < 64; i++) {
 		if ((1ull << i) & efer_reserved_bits) {
 			efer = efer_saved | (1ull << i);
 			vmcs_write(fld, efer);
 			report_prefix_pushf("%s %lx", fld_name, efer);
-			test_vmx_vmlaunch(
-				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-				false);
+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+					  false);
 			report_prefix_pop();
 		}
 	}
@@ -6816,28 +6827,39 @@ static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
 	/*
 	 * Check LMA and LME bits
 	 */
-	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LMA,
+	test_efer_bit(fld, fld_name,
+		      ctrl_fld, ctrl_bit1,
+		      EFER_LMA,
+		      "EFER_LMA");
+	test_efer_bit(fld, fld_name,
+		      ctrl_fld, ctrl_bit1,
+		      EFER_LME,
+		      "EFER_LME");
+
+test_entry_exit_mode:
+	test_efer_bit(fld, fld_name,
+		      ctrl_fld, ctrl_bit2,
+		      EFER_LMA,
 		      "EFER_LMA");
-	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LME,
+	test_efer_bit(fld, fld_name,
+		      ctrl_fld, ctrl_bit2,
+		      EFER_LME,
 		      "EFER_LME");
 }
 
 /*
- * If the â€œload IA32_EFERâ€ VM-exit control is 1, bits reserved in the
+ * If the 'load IA32_EFER' VM-exit control is 1, bits reserved in the
  * IA32_EFER MSR must be 0 in the field for that register. In addition,
  * the values of the LMA and LME bits in the field must each be that of
- * the â€œhost address-space sizeâ€ VM-exit control.
+ * the 'host address-space size' VM-exit control.
  *
  *  [Intel SDM]
  */
 static void test_host_efer(void)
 {
-	if (!(ctrl_exit_rev.clr & EXI_LOAD_EFER)) {
-		printf("\"Load-IA32-EFER\" exit control not supported\n");
-		return;
-	}
-
-	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
+	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, 
+		  ctrl_exit_rev.clr & EXI_LOAD_EFER,
+		  EXI_HOST_64);
 }
 
 /*
-- 
1.8.3.1


