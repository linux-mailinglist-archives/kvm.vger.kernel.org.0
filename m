Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F901909B9
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCXJmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:42:02 -0400
Received: from 8bytes.org ([81.169.241.247]:55352 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbgCXJmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 05:42:00 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 32F62273; Tue, 24 Mar 2020 10:41:59 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/4] kVM SVM: Move SVM related files to own sub-directory
Date:   Tue, 24 Mar 2020 10:41:51 +0100
Message-Id: <20200324094154.32352-2-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324094154.32352-1-joro@8bytes.org>
References: <20200324094154.32352-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Move svm.c and pmu_amd.c into their own arch/x86/kvm/svm/
subdirectory.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/Makefile                 | 2 +-
 arch/x86/kvm/{pmu_amd.c => svm/pmu.c} | 0
 arch/x86/kvm/{ => svm}/svm.c          | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/x86/kvm/{pmu_amd.c => svm/pmu.c} (100%)
 rename arch/x86/kvm/{ => svm}/svm.c (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4654e97a05cc..c6f14e3cc5ab 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
-kvm-amd-y		+= svm.o pmu_amd.o
+kvm-amd-y		+= svm/svm.o svm/pmu.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/svm/pmu.c
similarity index 100%
rename from arch/x86/kvm/pmu_amd.c
rename to arch/x86/kvm/svm/pmu.c
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm/svm.c
similarity index 100%
rename from arch/x86/kvm/svm.c
rename to arch/x86/kvm/svm/svm.c
-- 
2.17.1

