Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEB17E6D0
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgCISUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:20:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44986 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgCISUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:20:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id l18so2405971wru.11;
        Mon, 09 Mar 2020 11:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C7hkVnV+O8Kz0o38KoBSG6x8x5hnOh9oASr6dVEyrxQ=;
        b=ps2P2yWdzWnKfad191oRfjE8XU68RV8rkiI2K+pFURjOfJPmm5gICKUzJeSjkZLvj7
         jnTagpL9PSl5tCFUWxqAKKmhAUPSa7A9NNI2/tyl3+vxr97zX+8rI8THKQg2ky/yRuGl
         40ae9FIAlEAIZtmit5zn6BrLDSGNtbajFLxAA3zDtBG259PZFtlE2LGM3N6dPn7Jivzh
         rQPD5Rqiy+hWBatq9M97bACH7P8L5CHCi+FziqjelU1qgC6GCkPXxfAHCr/1QFiffS6M
         9JnHrqEOxxetI0qOiSaRtZOVbotU004GrMmmDc+JLLb8g6ZFQYnbMh+q0GQVhYMhvwEG
         mPfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C7hkVnV+O8Kz0o38KoBSG6x8x5hnOh9oASr6dVEyrxQ=;
        b=KIhu4BmkLUcl6wWVMm3vJFplAN7W4uEQdGBvaxuZLKUkd3RD7deAO4EQSdsD6TnHaV
         kvtFIk+IiE/FI76z4Jm/U7woteyXE/2iAWFMuNe2qaO8bdLOWUrQoav/MVjLRD7+SeMD
         DrKgKoghTnjJZWdRG91teAmEiBSypYnRCMVe6NTM7uGfyj80odanp6/VrxW3gxBT2FGQ
         NxPdbc2I/FoGi/GWILPmxNo4szlclFKZF2OHNV9CLBmgcB8G8ppSMgBPKw/o+2XXHbuG
         Sf7qmw45ZFTJ3fB2GUFNMKI/ys54rx51aCFXJULlfbJZQa1dZINyiGlLhvpexXf7M6ro
         Ug4Q==
X-Gm-Message-State: ANhLgQ3AL6zZ0Lvbo4wLXdAxrMcqC2lpF66RryY062EoC4vyw+XrWmOi
        Q1bNGfdDhkbO9DFvu7UVYhkYBZMZbvs=
X-Google-Smtp-Source: ADFU+vvc14Icnvq/CMV/r+uFviiYPXOb5T2VVNeLYlYKTZ/vEQfT2jFi2vk0y9UFp9q3q/xV4pezwQ==
X-Received: by 2002:adf:82a7:: with SMTP id 36mr14009948wrc.133.1583778029118;
        Mon, 09 Mar 2020 11:20:29 -0700 (PDT)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id t6sm8371828wrr.49.2020.03.09.11.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:20:28 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Date:   Mon,  9 Mar 2020 20:20:14 +0200
Message-Id: <20200309182017.3559534-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309182017.3559534-1-arilou@gmail.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
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

