Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B215049B63B
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbiAYO1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:27:37 -0500
Received: from 8bytes.org ([81.169.241.247]:46374 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387160AbiAYOSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 09:18:49 -0500
Received: from cap.home.8bytes.org (p549ad610.dip0.t-ipconnect.de [84.154.214.16])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 70E0B931;
        Tue, 25 Jan 2022 15:16:34 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v6 7/7] KVM: SVM: Increase supported GHCB protocol version
Date:   Tue, 25 Jan 2022 15:16:26 +0100
Message-Id: <20220125141626.16008-8-joro@8bytes.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125141626.16008-1-joro@8bytes.org>
References: <20220125141626.16008-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Now that KVM has basic support for version 2 of the GHCB specification,
bump the maximum supported protocol version. The SNP specific functions
are still missing, but those are only required when the Hypervisor
supports running SNP guests.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 403f24498020..acf224fd29a2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2638,7 +2638,7 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 }
 
 /* The min/max GHCB version supported by KVM. */
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 static u64 ghcb_msr_version_info(void)
-- 
2.34.1

