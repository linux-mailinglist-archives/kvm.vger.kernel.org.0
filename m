Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C291F434B77
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhJTMq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:46:56 -0400
Received: from 8bytes.org ([81.169.241.247]:33530 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhJTMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:51 -0400
Received: from cap.home.8bytes.org (p4ff2b5b0.dip0.t-ipconnect.de [79.242.181.176])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0E946477;
        Wed, 20 Oct 2021 14:44:35 +0200 (CEST)
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
Subject: [PATCH v5 6/6] KVM: SVM: Increase supported GHCB protocol version
Date:   Wed, 20 Oct 2021 14:44:16 +0200
Message-Id: <20211020124416.24523-7-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124416.24523-1-joro@8bytes.org>
References: <20211020124416.24523-1-joro@8bytes.org>
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
index 0c673291e905..3ad69f4f0ed6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2394,7 +2394,7 @@ static u64 ghcb_msr_cpuid_resp(u64 reg, u64 value)
 }
 
 /* The min/max GHCB version supported by KVM. */
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 static u64 ghcb_msr_version_info(void)
-- 
2.33.1

