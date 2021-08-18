Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B953EF694
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhHRAKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbhHRAKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:17 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDBC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:43 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 21-20020a370815000000b003d5a81a4d12so512046qki.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JACHLJ0Fahm0I2H/knzBqTe9jo7I2AGHtG7OfwVGa3k=;
        b=OLcXEUXO7R95X0ZdMaeFXZVj+6TOfi4t9CjhY4MJjuLGszthc+TcwX6MgX2th+o58v
         Mg7jv8B7luWI2P7jn5oXffs4x8+XFBlFDZDJXn2DKfgWVdn6mR/uYpOaWBQ8z+9P2V2T
         0EXtR9zU/JLw61TRPD3Qgfp8R+pslgNYBTjGhiWRTf/jX02U2+9pkMpUbgifLDusMxvQ
         Cbzhxy0+M5YL8EnZwj58U3SbOL1SRUOKM0LMmmNF1k+vBjGNEDscAZ1AlPhyXh119TTZ
         tnL/YPvX1wSYSc5GXHNscL386edbphV1XBZxtRow1E3FGFzklpmqeIPp2xsXG9QQwRIQ
         nlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JACHLJ0Fahm0I2H/knzBqTe9jo7I2AGHtG7OfwVGa3k=;
        b=sm9sk/BrR/kSdeMCnijefwoAu/N7cZ/mPUYpe/+f7pwLVgYeK4UhiVF1UrGg7HdsbC
         voBwflVZa6QwvVdXlkBqHMWXI1wbjq1KOWRjPN0t0vzDykHm/Me+GH6ITBc5PsxKU4/u
         Rq9ZFePPleSreyHW2K/o2HaaxKlfRQMBAXC6Nsx2jmeFpNZ8dlphvcWI4G+ecmk8gzLR
         SH7rqlwbDdYUiA6QtVaUFiYR/mhRf1zUCYuiGCoO3LGtiNEgq7PfeA5w43FQPIaPX6pO
         o914vf7JZS8KOpOHNdPs8gWx0pxGQEeWXgIdVzhOrodXnQ/WO/XLfktQNPtww+zFskjT
         zN0A==
X-Gm-Message-State: AOAM532vQOgtG2uHT8Jyl8ldEjvBsQQDKiDJSEDMr06m2KbFXKgrcB9I
        Q7tcKA+nyIlH4n75v0tntS7sEEG8rHKm1yGkcO2dlmgdbsBk9uR0RJ2/cOv8cV0/5JCAdmcUeWH
        qLPkbw+0eN1im8PNnaBRbMqwd6ziVP5li/Ln9IPTPYNELCGm8EoTUX0C5HH0vPhEmbHkl
X-Google-Smtp-Source: ABdhPJxSDvazqMVNdYnLZb0ESa7bGb5q79dZvQ616HRunDDXIqYGLr3j80vSQyLy8QNDPmfYSbG6ZwYkukSOs29Q
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:3ca:: with SMTP id
 ce10mr6047440qvb.42.1629245382978; Tue, 17 Aug 2021 17:09:42 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:05 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-17-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 16/16] x86 AMD SEV-ES: Add test cases
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-ES introduces #VC handler for guest/host communications, e.g.,
accessing MSR, executing CPUID. This commit provides test cases to check
if SEV-ES is enabled and if rdmsr/wrmsr are handled correctly in SEV-ES.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 x86/amd_sev.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index a07a48f..660196e 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -13,6 +13,7 @@
 #include "libcflat.h"
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
+#include "msr.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
@@ -55,10 +56,42 @@ static int test_sev_activation(void)
 	return EXIT_SUCCESS;
 }
 
+#ifdef CONFIG_AMD_SEV_ES
+static int test_sev_es_activation(void)
+{
+	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
+
+static int test_sev_es_msr(void)
+{
+	/* With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
+	 * correctly, rdmsr/wrmsr should work like without SEV-ES and not crash
+	 * the guest VM.
+	 */
+	u64 val = 0x1234;
+	wrmsr(MSR_TSC_AUX, val);
+	if(val != rdmsr(MSR_TSC_AUX)) {
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
+#endif /* CONFIG_AMD_SEV_ES */
+
 int main(void)
 {
 	int rtn;
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
+#ifdef CONFIG_AMD_SEV_ES
+	rtn = test_sev_es_activation();
+	report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
+	rtn = test_sev_es_msr();
+	report(rtn == EXIT_SUCCESS, "SEV-ES MSR test.");
+#endif /* CONFIG_AMD_SEV_ES */
 	return report_summary();
 }
-- 
2.33.0.rc1.237.g0d66db33f3-goog

