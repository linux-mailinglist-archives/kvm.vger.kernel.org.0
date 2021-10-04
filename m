Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601AC4218B2
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhJDUvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbhJDUvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAEAC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so341603pjc.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xApr0Rvj6bYN3H9puUCvmsT2cm3F0qNnJSkbus3tXXU=;
        b=YbVGOHA73pa7aKEa0ypA97MfSgE3LzFuY1N4hqmPvSbPmzOL51gdEndjau9IN8Tfka
         2p1S0GFu3Gy2yKHWZ/S1eGXkKhMBhnNeojfGCtXMA2fDqug4cZY+1Z+0+DSh73uAgJKo
         6jk61Ii9U0PQ9RcKUf3WiB40JsgsgrgmSYTd3zRDlDqEZpvKxLW4K+8UoIh9fkYqfo52
         +pEChKPgJah2lnKrVhhl4cecUzUMQmqy8wCUgYXj6lpKvazn/DQhjgKkDOMPhKDxrLoy
         ymho0ImzLfni4H5ohBxNcZv5C0NV05LQJTmvDMLns1dq1srZT1+QoRakCDMn3jzmKIjG
         KKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xApr0Rvj6bYN3H9puUCvmsT2cm3F0qNnJSkbus3tXXU=;
        b=BNsn/pi+uXsezUCk421KQGmS4rXlN1KEk60S3KTz8bJxrAYQIRp//y1vUPFh1J4IAD
         Mx68V5zaxPDZpieaEjXcxe5ewyS23FNmZNPRK+4EO/Q3NW8MyCkZq1ry7jtZN9AnOMO4
         PlrSNet4mMmZHLJkGCVJ7n/q4HKM18+oP9p2tJ6iuSMuuXqRZcSOJR+RD6IRJg7xo2/g
         1z5zb9rbmMa19S6Y5JKkmz4F1gmExK+cfn1MbcOD8EcJY4NSDCW+M0YpDXkcyNLJ8UDn
         Iz1RdUyeXx+umsZ5zgQ+Qtve/QY6n7rYqMUAYP76HLYzOENXh3OU236o8GZn4PBlQ3Nw
         OStg==
X-Gm-Message-State: AOAM530Mgf0wZMeWgxFSzjFdTp/Xf5tqWG/Fml/Y/EwUPxYoOArJrbPV
        ko3dwKOI+4Sqgm3u6O/aSR/D2kONaiZysw==
X-Google-Smtp-Source: ABdhPJya37cYmMFF1l8RwaioKKcsn3jTcm6Oe5tzMPIercQqyNEewql/SDwCSb2sUkKWiiEAkH46dg==
X-Received: by 2002:a17:902:9a04:b0:13a:1ae3:add2 with SMTP id v4-20020a1709029a0400b0013a1ae3add2mr1614170plp.28.1633380598813;
        Mon, 04 Oct 2021 13:49:58 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:58 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 17/17] x86 AMD SEV-ES: Add test cases
Date:   Mon,  4 Oct 2021 13:49:31 -0700
Message-Id: <20211004204931.1537823-18-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

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
2.33.0

