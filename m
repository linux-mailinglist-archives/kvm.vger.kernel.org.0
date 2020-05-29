Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CF51E7F13
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE2NqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgE2NqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B141C08C5C6;
        Fri, 29 May 2020 06:46:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x13so3692078wrv.4;
        Fri, 29 May 2020 06:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jTDLY8IqM4gzoQ6wo3jww9wemhS46tpJf0MrInuAZDU=;
        b=k0sKlccWgpVBBT/3ULw5Ow4iY92K8lfzdb/bFT9732xrvtqOakN5xpTvO2TcxDRwZC
         GlyMVY2ITwriJQLjfWAPIbBEZktr+bhDlai9Ug15bDs5dYPuIl46fzbNYPdSWhF+bDgZ
         WgB8rZsBAYGZXUj1bR3AcHiuupdEtuhWUqMgV/YmOU3QxuhHKRwvxuwAOVXmQ/XmMEZ6
         BWLObCNS18L3ojS/oTvycoyDY75ERKTuxPp5ZmIFpYy+QQRoqg5yVQ+lbSySmWR2OEYb
         vRuYR41XoHsLPJ1qi95VO1UBY9BUG94KM67+zBjTL1aBAS0Gs/pmFbG+11xVDSh1Bbvb
         3jGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jTDLY8IqM4gzoQ6wo3jww9wemhS46tpJf0MrInuAZDU=;
        b=XtqCuQUFMl4UFpAAdofwrKOFWn7GAuNUKydZzXak6AQKNmQ1e3H3kjzPm2dfd7fMbw
         1ZEuCwNx/PRRj5men9KNRRDRh6x2FGkXmMqMDTXeGeioPknjam6A4e8oEwvGJ/INSRx2
         w4//5m3UrY0orOhRzmcIzyYnJ+SGK+CuSsE+LP2qLpLimfLgBXO471yNNkkBFpk/8QE7
         BQRrbz9mrJ7g3P+tQeY4uaSQJyxTVhSQ1x8oMlDATJUzjNxxLavrY5UjEh7ChuEPQfp1
         VXFJ5AmPxkRGlk4o0mM2/3KZqAtNXX3dov4EQ68cxO5E8p+MBP+JRABWYafdcyiQMEY6
         tASg==
X-Gm-Message-State: AOAM5308edbNKCeI7pGa8z/Ndr5cbkoHm24uKD2oYIEn7i4Sj2qfeJ/2
        NZDi5UdO1ZlfOM42hXPGci04YWKy
X-Google-Smtp-Source: ABdhPJwX0iLl2SNzjzpOCIRZNlUTfcCIQfMWmM3D5xBmhmK76BQCwM/05usatt0PGD2wO3ugbEJVgw==
X-Received: by 2002:adf:8b0c:: with SMTP id n12mr9618896wra.340.1590759958926;
        Fri, 29 May 2020 06:45:58 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:45:58 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH v12 2/6] x86/hyper-v: Add synthetic debugger definitions
Date:   Fri, 29 May 2020 16:45:39 +0300
Message-Id: <20200529134543.1127440-3-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V synthetic debugger has two modes, one that uses MSRs and
the other that use Hypercalls.

Add all the required definitions to both types of synthetic debugger
interface.

Some of the required new CPUIDs and MSRs are not documented in the TLFS
so they are in hyperv.h instead.

The reason they are not documented is because they are subjected to be
removed in future versions of Windows.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  6 ++++++
 arch/x86/kvm/hyperv.h              | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 29336574d0bc..53ef6b7bd380 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -131,6 +131,8 @@
 #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
 /* Crash MSR available */
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
+/* Support for debug MSRs available */
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
@@ -376,6 +378,9 @@ struct hv_tsc_emulation_status {
 #define HVCALL_SEND_IPI_EX			0x0015
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
 #define HVCALL_RETARGET_INTERRUPT		0x007e
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
@@ -422,6 +427,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
 #define HV_STATUS_INVALID_CONNECTION_ID		18
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 757cb578101c..7f50ff0bad07 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -23,6 +23,33 @@
 
 #include <linux/kvm_host.h>
 
+/*
+ * The #defines related to the synthetic debugger are required by KDNet, but
+ * they are not documented in the Hyper-V TLFS because the synthetic debugger
+ * functionality has been deprecated and is subject to removal in future
+ * versions of Windows.
+ */
+#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
+#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
+#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
+
+/*
+ * Hyper-V synthetic debugger platform capabilities
+ * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
+ */
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+
+/* Hyper-V Synthetic debug options MSR */
+#define HV_X64_MSR_SYNDBG_CONTROL		0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS		0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER		0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER		0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
+
+/* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
+#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
+
 static inline struct kvm_vcpu_hv *vcpu_to_hv_vcpu(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.hyperv;
-- 
2.24.1

