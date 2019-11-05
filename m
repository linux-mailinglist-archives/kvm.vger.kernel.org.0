Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F497F05D3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbfKETTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:19:25 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50264 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390734AbfKETTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:19:25 -0500
Received: by mail-pf1-f201.google.com with SMTP id e13so10300434pff.17
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TuG0A8jvRSo3LdFh+fwDlIO3wYLZ26Y3Enhbcv1wzSc=;
        b=L+p2IPhMc/CuEoQeau8+9HcKWghhivmtRQkx227Sp+mC4p+gWr/2U8N8tgFqNhjnoY
         7e9EETNlOx48gdCqUPAegbIB7uK2BpOLshoNyZqwOBNvllJITxAllKR7Z9zKF39iAHqr
         iFNqhc7Fi6TZixLA0ysEt+ee/BAbD/zvbHI7Zcnes6RAoV1oIL9858OJtxkdWEQtzHOS
         JB3bw2ykLiXQWHwQvNI6cTxxDiYP1Xl3nmOzINWzljqFVrdFn9a0hhF6v0BOnhQvZvSc
         WZrTy9+IJpv3U9z9VjsZIR0U/1jRl1yTtHXJ8Rj9foSTeDnPs/SxGfHczkxmTd1+pExf
         +cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TuG0A8jvRSo3LdFh+fwDlIO3wYLZ26Y3Enhbcv1wzSc=;
        b=hNpYeRfrmn4SwvhqX4agP3wQWez9IrZq1pl42wwcltu97ATv3VWUIFOlsNW52+LOJU
         IHW+Bibds0f6vjYyKe+oJ3HF7vwj8RLw+3FK1mK+BfTvv1vHg8gD4479QwhvmWqY6qF6
         IOIgetv3pq47TdULNx7r2ZWfDeIWkek1QuXFPzdgPQCyvutMLyIyUmfMH+ZFGkY7Is93
         8SzIq1r7tfUJwfnFQ5lMio0xE8AbVZn4NaTnlaA2LmVqLyrWvrrTyNckXWr7ELwoV+eO
         DAsrus5QD6H58VEGlbR6jfZAARsQiI9tEtiSntQvNTW5EhNkVAZwtDBZnv8xorgSgt72
         EahQ==
X-Gm-Message-State: APjAAAWsk0f9kbm3MgUNw7FTjt715eSbljQw1UyAmA8/8l+YGfkw5V1k
        Q/gmjoRMVlpWo9jW8FkZNoV5x/ZskE6T9x7wtj4cUz9LL6F9fE0LXbSOlhzru9ZZvBIgkouJTSM
        1XyiVnRJZIFQ0aV4WpyReeXJnLsHkGp50rrkBfSFAWJDg+1wYZOEZnd3PsY2oHhdU0hWl
X-Google-Smtp-Source: APXvYqz2Y7jD3D2oew2/uCVZDH2j+7Y7S8f+yBI7jI5SRWP4IHlOXHArPebVcERnwzv16eJpCwxuITI1OBJSEjQB
X-Received: by 2002:a63:5125:: with SMTP id f37mr36470721pgb.98.1572981563945;
 Tue, 05 Nov 2019 11:19:23 -0800 (PST)
Date:   Tue,  5 Nov 2019 11:19:09 -0800
In-Reply-To: <20191105191910.56505-1-aaronlewis@google.com>
Message-Id: <20191105191910.56505-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v2 3/4] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename function find_msr() to vmx_find_msr_index() to share
implementations between vmx.c and nested.c in an upcoming change.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c0160ca9ddba..39c701730297 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -835,7 +835,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }

-static int find_msr(struct vmx_msrs *m, unsigned int msr)
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;

@@ -869,7 +869,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 		}
 		break;
 	}
-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (i < 0)
 		goto skip_guest;
 	--m->guest.nr;
@@ -877,7 +877,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);

 skip_guest:
-	i = find_msr(&m->host, msr);
+	i = vmx_find_msr_index(&m->host, msr);
 	if (i < 0)
 		return;

@@ -936,9 +936,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 	}

-	i = find_msr(&m->guest, msr);
+	i = vmx_find_msr_index(&m->guest, msr);
 	if (!entry_only)
-		j = find_msr(&m->host, msr);
+		j = vmx_find_msr_index(&m->host, msr);

 	if ((i < 0 && m->guest.nr == NR_MSR_ENTRIES) ||
 		(j < 0 &&  m->host.nr == NR_MSR_ENTRIES)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0c6835bd6945..34b5fef603d8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -334,6 +334,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);

 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
--
2.24.0.rc1.363.gb1bccd3e3d-goog

