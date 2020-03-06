Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B517C31E
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCFQjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:39:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54202 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgCFQjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:39:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id g134so3173841wme.3;
        Fri, 06 Mar 2020 08:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C7hkVnV+O8Kz0o38KoBSG6x8x5hnOh9oASr6dVEyrxQ=;
        b=jPo6NzJzzGciYYHEfwhjKd3cY/Gtfd+ZshXvr3b/F61CNdaoNsjyxRP/QuTYBLekJX
         llGkijWOWuHcFG8Y8GPYHZwlydU37QDq+6stEtFXDx3HqoFiQi9sAWr+cz7+iVFDxtI/
         9ZGim0apf+1fdYJiL5rt+aSV4aDwxmMUc0ZvsGe75GdYGwAktpYIfFKgY57zM9H4KEq1
         8Y3RylZSFcQUGaK61FMfzuRicEMPOWdh8SQIbI4PdMYkcCCGbl5brYbEqppcoYWvtcMT
         73jXIKF26QmjC/9Jl4WCcPy/wPKlDZQLmiV6PA2BmTsLWhTFUL/qUk0r4jUHosgJDLez
         EFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C7hkVnV+O8Kz0o38KoBSG6x8x5hnOh9oASr6dVEyrxQ=;
        b=p88doW+Mg6QsTE2sKcg/16uf7v/fEaviCaBG/CpfxXn62xrgN2eehqb/obY7QOuEPP
         G5b5+Lc7PVq/LFOWU7FLe22VkQpMeGgMEsbLFI3Q2tE6qsCe2OfFpooucIlnmYm7aE3S
         PFDYhTifsYjr8Tuw0/WR4Vy+Z1SK7oU8cO09KWtFiKW3XyabT6h9qtuhR+QBWMFp1OWR
         DmGnooKS43KW25rHWt+vN5JgYMWVenJ8RY1uD6es4DOBouqIr4qm8Tm3H/l6ojQDmllm
         yGEuhAeRL+ouyhIp+7jpt5mEyIXZSEhS7yqaaaecTfHtth1xiO+P7zJVu0SbNjyg8sgy
         picw==
X-Gm-Message-State: ANhLgQ1bwsWPF2F4l/42sX3aq8GJRHf8gHLW+6UTmSrzQE/cPwyXwhdO
        l35Z5WWmLvfX62zgiHdDQZM9dOoq
X-Google-Smtp-Source: ADFU+vvMNj1y2JubLrDKhWfl4qILWRwY6x8pQezIMAKFTGoV0V6gsU5604XmIuagY63OUr/FUMkZwQ==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr4768931wmc.65.1583512751108;
        Fri, 06 Mar 2020 08:39:11 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id n24sm8812760wra.61.2020.03.06.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:39:10 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v3 2/5] x86/hyper-v: Add synthetic debugger definitions
Date:   Fri,  6 Mar 2020 18:39:06 +0200
Message-Id: <20200306163909.1020369-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306163909.1020369-1-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com>
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

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 92abc1e42bfc..12596da95a53 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -33,6 +33,9 @@
 #define HYPERV_CPUID_ENLIGHTMENT_INFO		0x40000004
 #define HYPERV_CPUID_IMPLEMENT_LIMITS		0x40000005
 #define HYPERV_CPUID_NESTED_FEATURES		0x4000000A
+#define HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS	0x40000080
+#define HYPERV_CPUID_SYNDBG_INTERFACE			0x40000081
+#define HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	0x40000082
 
 #define HYPERV_HYPERVISOR_PRESENT_BIT		0x80000000
 #define HYPERV_CPUID_MIN			0x40000005
@@ -131,6 +134,8 @@
 #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE		BIT(8)
 /* Crash MSR available */
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
+/* Support for debug MSRs available */
+#define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
 /* stimer Direct Mode is available */
 #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
 
@@ -194,6 +199,12 @@
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
+/*
+ * Hyper-V synthetic debugger platform capabilities
+ * These are HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX bits.
+ */
+#define HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING	BIT(1)
+
 /* Hyper-V specific model specific registers (MSRs) */
 
 /* MSR used to identify the guest OS. */
@@ -267,6 +278,17 @@
 /* Hyper-V guest idle MSR */
 #define HV_X64_MSR_GUEST_IDLE			0x400000F0
 
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
 /* Hyper-V guest crash notification MSR's */
 #define HV_X64_MSR_CRASH_P0			0x40000100
 #define HV_X64_MSR_CRASH_P1			0x40000101
@@ -376,6 +398,9 @@ struct hv_tsc_emulation_status {
 #define HVCALL_SEND_IPI_EX			0x0015
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 
@@ -419,6 +444,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
 #define HV_STATUS_INVALID_CONNECTION_ID		18
-- 
2.24.1

