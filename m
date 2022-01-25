Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89749B124
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiAYKDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbiAYJ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:46 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D22C061756;
        Tue, 25 Jan 2022 01:59:42 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so2271291pjb.3;
        Tue, 25 Jan 2022 01:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCL/z3KlGNzFsVCJ/3z3F4LH/FmJiw0KoHdi2KVVmgk=;
        b=gVcJuLPGV54zqq+spLjzSiaCND99bX63oHpJ6CucKDneVPQ4zgveS0nl2SuK31c6WA
         s9/RSvBxt2ab6cAM0aUY73Uuak5ORezldkllhRLXYip2s/qgHeJFndT2ZubDM8nCt6o2
         AJcobDggVSijg32KWNmyczUK8JwgPMo6KXhvnuPY5sPBvBYt1bkqVl3G1MUeUimsJPn4
         MvSg62qys7MfPTPR50RkZ8kBjZW4jOq1MjtzHVFWeYbDhZBJCLMWogYlyGVlL7e3SmWN
         OX46SAWqxHw/qTyZNzIQodX5UuLkJXJC8X+Kphs6LipNnawwZpfeZQU24LaDmWr2Y6Ji
         8VMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCL/z3KlGNzFsVCJ/3z3F4LH/FmJiw0KoHdi2KVVmgk=;
        b=cSg0lMUcuzbuyjoVhJNgGb8IdV9podlYSUJmVBJpL9nhduiD0fsI0Z6EmpscfCfd21
         1QYgV96YcDWNL8jPKWfCAZHfY1Qj+lFPCY0Xnv53+oRsUxEr6j794S0KRt8hwrf4U+Gj
         Xv8GTrEk7SgG99xCzZ8Y2k4sSU1cVdZfItWOG95IyO4P+8uTB7hkuCK6BHkyQ0NJjYBq
         IVQKlS0YgzqlWWo1Elk/dwm3B2ZOP25iicpZmn159uiJsQ4QAbIzq7Z93t3k7C/vWIxq
         qtQ/t0Sk0btJGit8xByYYEgZnIFotf/VfHIOVivh0LLngPYF3ppQHI2Jt0kKv7vguJUb
         1xVA==
X-Gm-Message-State: AOAM532FWQaACbs7spEGo0GDhVwnoaP5bXi8DizXlYnknD01J/R+aqJf
        yLj2nCgYjJPT9/hPaY8EOls=
X-Google-Smtp-Source: ABdhPJzPVmkIK7wMi/i4VnSk7XEpJzBzxl3aNCucA2MqQnRG7cLZU+sJOmCW3ilnTvg4V0olJVHGuQ==
X-Received: by 2002:a17:90a:f413:: with SMTP id ch19mr2650547pjb.19.1643104781737;
        Tue, 25 Jan 2022 01:59:41 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:41 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] KVM: x86/sev: Remove unused "kvm" of sev_unbind_asid()
Date:   Tue, 25 Jan 2022 17:59:00 +0800
Message-Id: <20220125095909.38122-11-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm *kvm" parameter of sev_unbind_asid() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index eae234afe04e..0727ac7221d7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -217,7 +217,7 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
-static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
+static void sev_unbind_asid(unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
 
@@ -363,7 +363,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* return handle to userspace */
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params))) {
-		sev_unbind_asid(kvm, start.handle);
+		sev_unbind_asid(start.handle);
 		ret = -EFAULT;
 		goto e_free_session;
 	}
@@ -1426,7 +1426,7 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
 			 &params, sizeof(struct kvm_sev_receive_start))) {
 		ret = -EFAULT;
-		sev_unbind_asid(kvm, start.handle);
+		sev_unbind_asid(start.handle);
 		goto e_free_session;
 	}
 
@@ -2078,7 +2078,7 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	sev_unbind_asid(sev->handle);
 	sev_asid_free(sev);
 }
 
-- 
2.33.1

