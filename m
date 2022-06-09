Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB285449AE
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbiFILEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243460AbiFILEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 07:04:21 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537F63CFEC
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 04:04:19 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w20so15756050lfa.11
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 04:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cDvzOjc/sBh8FPM+6m1a79tMWnQrhKoIX1IIc2qqN5M=;
        b=sJ9087X728vXXXcsD3UnUg0LsTORnlo3ZgGnNuJxX+nelG/jNqA8xZCueHMFTUrVAy
         1BdJ7dbLidC4ZlYaHGc15eHzPwI5mbeeDQ8mhi2o9WszmUF+pCdmBGSxjGwE3ulEDvNJ
         h49qEddIFxngaF/MHWdIFngyf7ZYGuGyNJi4wCOwIE34vH+12C+0rnHr49c14gUzuLvf
         qAlHaoisfVpm6gOWocZXm94KsxKcIGhbuxzFWaVvJ5li72yW3oBeSzU0bwzJc4JirICc
         VSYYS0MdscAEARJDhREutPMdMwZWda2ZnkvFWHS6mDRcidiUGWS5kelxV5/bXaqPeA3R
         Sqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cDvzOjc/sBh8FPM+6m1a79tMWnQrhKoIX1IIc2qqN5M=;
        b=GDP9iRqTYfmo6TQBRiUqShTrnjHeR5CVrs2xnL8JdLUmb4US+ATp9Ur8vJW57j/4Br
         WgMDsjRv0i/rxVa73UbxmngXjkyuVU0LpXETsf5K8BNfW5X0e4m8EPH6MAcgEWpL0wzK
         VJ73qGEB8n/M8tGvlksR36XEMKXNn8KMIRsIRijyEQxMr/lb+5P9w6SNWylbuFCsJ6IU
         NIi1GsUREHZyQgixSP+4EAcV9mvCax+09B2NfIbqCjwnNEBqQ4c0TqwflM3q5KjCxP6K
         HAHTaPmOgKz6GSknLiygIwzA8MmSlmHwB6gu5zSVQTpZYaOBsnNDgQvPWncAdBMgY4PW
         hFBw==
X-Gm-Message-State: AOAM533O0aAplQS7XlCDOeY1VFU3kh0Utrxqmh7GCiizrMSQm/4ggrEW
        xkeffKhsDkO6LNtKvFVnxjmcng==
X-Google-Smtp-Source: ABdhPJz6twGPG+sTdT7x6V5wwPxuL8uCuYaPA6LLDxrsywOqZ1Nq82Xsy8XrzUhiX8bwptIpALd6QA==
X-Received: by 2002:a05:6512:31c5:b0:479:47a1:2024 with SMTP id j5-20020a05651231c500b0047947a12024mr12854038lfe.420.1654772657327;
        Thu, 09 Jun 2022 04:04:17 -0700 (PDT)
Received: from jazctssd.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id a10-20020a194f4a000000b004793605e59dsm2116674lfk.245.2022.06.09.04.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 04:04:16 -0700 (PDT)
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
To:     linux-kernel@vger.kernel.org
Cc:     jaz@semihalf.com, dmy@semihalf.com,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Steve Rutherford <srutherford@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jing Liu <jing2.liu@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-acpi@vger.kernel.org (open list:ACPI),
        linux-pm@vger.kernel.org (open list:HIBERNATION (aka Software Suspend,
        aka swsusp))
Subject: [PATCH 2/2] KVM: x86: notify user space about guest entering s2idle
Date:   Thu,  9 Jun 2022 11:03:28 +0000
Message-Id: <20220609110337.1238762-3-jaz@semihalf.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220609110337.1238762-1-jaz@semihalf.com>
References: <20220609110337.1238762-1-jaz@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zide Chen <zide.chen@intel.corp-partner.google.com>

Upon exiting to user space, the kvm_run structure contains system_event
with type KVM_SYSTEM_EVENT_S2IDLE to notify about guest entering s2idle
suspend state.

Userspace can choose to:
- ignore it
- start the suspend flow in host (if notified from privileged VM,
  capable of suspending the host machine)
- take advantage of this event to make sure that the VM is suspended

The last one is especially useful for cases where some devices are
pass-through to the VM and to perform full system suspension, the guest
needs to finish with it's own suspension process first (e.g. calling
suspend hooks for given driver/subsystem which resides on the guest).
In such case host user-space power daemon (e.g. powerd) could first
notify VMM about suspension imminent. Next the VMM could trigger
suspension process on the guest VM and block till receiving
KVM_SYSTEM_EVENT_S2IDLE notification, after which the suspension of the
host can continue.

Additionally to not introduce regression on existing VMM which doesn't
support KVM_SYSTEM_EVENT_S2IDLE exits, allow to enable it through
KVM_CAP_X86_SYSTEM_S2IDLE VM capability.

Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
---
 Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/x86.c              | 15 +++++++++++++++
 include/uapi/linux/kvm.h        |  2 ++
 tools/include/uapi/linux/kvm.h  |  1 +
 5 files changed, 41 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..670dada87f50 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6146,6 +6146,8 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_WAKEUP         4
   #define KVM_SYSTEM_EVENT_SUSPEND        5
   #define KVM_SYSTEM_EVENT_SEV_TERM       6
+  #define KVM_SYSTEM_EVENT_S2IDLE         7
+
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6177,6 +6179,15 @@ Valid values for 'type' are:
    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
  - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
    the VM.
+ - KVM_SYSTEM_EVENT_S2IDLE -- the guest has notified about entering s2idle
+   state. Userspace can choose to:
+   - ignore it
+   - start the suspend flow in host (if notified from a privileged VM, capable
+     of suspending the host machine)
+   - take advantage of this event to make sure that the VM is suspended - used
+     for full system suspension, where the host waits for guest suspension
+     before continues with it's own, host suspension process.
+   This is available on x86 only.
 
 If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
 architecture specific information for the system-level event.  Only
@@ -7956,6 +7967,16 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+8.37 KVM_CAP_X86_SYSTEM_S2IDLE
+-------------------------------
+
+:Capability: KVM_CAP_X86_SYSTEM_S2IDLE
+:Architectures: x86
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_S2IDLE to process the guest s2idle notification.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 959d66b9be94..85966da56c75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -105,6 +105,7 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_S2IDLE		KVM_ARCH_REQ(32)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1160,6 +1161,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+	bool s2idle_notification;
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ed4bd6e762b..651ebac025c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4291,6 +4291,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_X86_SYSTEM_S2IDLE:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6084,6 +6085,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_SYSTEM_S2IDLE:
+		kvm->arch.s2idle_notification = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -9307,6 +9312,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 	case KVM_HC_SYSTEM_S2IDLE:
+		if (!vcpu->kvm->arch.s2idle_notification)
+			break;
+
+		kvm_make_request(KVM_REQ_HV_S2IDLE, vcpu);
 		ret = 0;
 		break;
 	default:
@@ -10114,6 +10123,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_HV_S2IDLE, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_S2IDLE;
+			r = 0;
+			goto out;
+		}
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..dd71ccf8fce4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -447,6 +447,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_S2IDLE         7
 			__u32 type;
 			__u32 ndata;
 			union {
@@ -1157,6 +1158,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_X86_SYSTEM_S2IDLE 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 6a184d260c7f..f8db91439c41 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_S2IDLE         7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.36.1.476.g0c4daa206d-goog

