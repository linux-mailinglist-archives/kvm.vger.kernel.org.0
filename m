Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3140A3F92BD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244164AbhH0DNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:42 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55B3C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id h10-20020a056a00170a00b003e31c4d9992so2213405pfc.23
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qz364tHRAJ7dP0GQYPGE0P0hbUEMQJvVz6b5KTAgE7E=;
        b=rQtnQCIRf/agAPpzYjcXG7j1LQuaBaIyqiBfub4K8iun6kji5eA+XV6xse6BsRJUDa
         IQF912b9rKlW/0M82oK3FXHTio3Q43KQD7Y+LQCMjtFzjWrUHL1Og/eMoR1WI4DjkXye
         PTnpSTAOcpIdUauj+UkAu3V5uQSqN1a/6Z1McR9SgvcCSIEfrmIS3y10pP3tak2703TJ
         lal1uCCvE6LW/4pDoaEvmundqM2pB1uF8eHaWNlzytipabFTCJ3nqgZh3c+ux05oy9vD
         RAhB19ALY/gMaItOZTWPhl2bweh+H95emTRZoHIk/JxmQ5gtHYh4gOP6wAy4zofSOWg/
         5itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qz364tHRAJ7dP0GQYPGE0P0hbUEMQJvVz6b5KTAgE7E=;
        b=FDPp0Tfx4HMMcIvLMXSsrYnbmxFTuxtrRqm1j56DF0mta70ndxlbBwhuTAkvWbS1fg
         hAnvctf/qgnw4Ld5x6Jd3PZyMhAqatAV79lxxExzEulsk1VP5dliOPqlgiK7Z1qpVTIt
         wZmZYxS1BQ51bSN22MK3mDAf2OVB1j/mN/V51jLEVJSYHSF50GnCVonUWpLNxT6PRHPs
         RNhF4iSQrOEkEugGO3Aeo9IY+zwzy0P6aNeQjbqeXPvTFq5NKXX2OXLcbwsJ+Yy81Ovp
         XNyQMZik/nK3l5eB/y2xzBtI369ksriJlg2XvYGnF4lSanJZUKgbVGXlpPwZPuM/vGKA
         +/XA==
X-Gm-Message-State: AOAM531Pr3Y+Ud7UmN4GRtjBRUK59A1fbF/QRx9cswFzP2QCd+Y0Yqra
        1ORkUDYBvtBz733JbfapEQyBjIS2AnzJiq4WKTuNKWdHpT+RA2DfDt1We+K6L1xK9Qa6WslBMOa
        e7ylZpgwcqxrtObprqbZbUHYCa2n7OzKy0VNNzKsgDn8t7vkuOv+XXbrNr0hvjAaIJaR+
X-Google-Smtp-Source: ABdhPJwImo/T88iRiHHkN6lNf2ehUGO8/S3BpeEHG7ohI3SSZjVH0sSHih+5JQrrEya8bG6a8FyMNUJ9/xxRP6JV
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:3887:0:b0:3f2:6c5a:8a92 with SMTP
 id f129-20020a623887000000b003f26c5a8a92mr4677725pfa.8.1630033974271; Thu, 26
 Aug 2021 20:12:54 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:22 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-18-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 17/17] x86 AMD SEV-ES: Add test cases
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-ES introduces #VC handler for guest/host communications, e.g.,
accessing MSR, executing CPUID. This commit provides test cases to check
if SEV-ES is enabled and if rdmsr/wrmsr are handled correctly in SEV-ES.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 x86/amd_sev.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index a07a48f..21a491c 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -13,6 +13,7 @@
 #include "libcflat.h"
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
+#include "msr.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
@@ -55,10 +56,39 @@ static int test_sev_activation(void)
 	return EXIT_SUCCESS;
 }
 
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
+	/*
+	 * With SEV-ES, rdmsr/wrmsr trigger #VC exception. If #VC is handled
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
+
 int main(void)
 {
 	int rtn;
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
+	rtn = test_sev_es_activation();
+	report(rtn == EXIT_SUCCESS, "SEV-ES activation test.");
+	rtn = test_sev_es_msr();
+	report(rtn == EXIT_SUCCESS, "SEV-ES MSR test.");
 	return report_summary();
 }
-- 
2.33.0.259.gc128427fd7-goog

