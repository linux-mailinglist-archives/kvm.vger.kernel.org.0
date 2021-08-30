Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC24B3FB892
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 16:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhH3OzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 10:55:15 -0400
Received: from foss.arm.com ([217.140.110.172]:43410 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhH3OzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 10:55:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39C1E31B;
        Mon, 30 Aug 2021 07:54:21 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 09DDA3F5A1;
        Mon, 30 Aug 2021 07:54:16 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia He <justin.he@arm.com>
Subject: [PATCH] KVM: x86/mmu: Remove unused field mmio_cached in struct kvm_mmu_page
Date:   Mon, 30 Aug 2021 22:53:36 +0800
Message-Id: <20210830145336.27183-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After reverting and restoring the fast tlb invalidation patch series,
the mmio_cached is not removed. Hence a unused field is left in
kvm_mmu_page.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 35567293c1fd..3e6f21c1871a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -37,7 +37,6 @@ struct kvm_mmu_page {
 
 	bool unsync;
 	u8 mmu_valid_gen;
-	bool mmio_cached;
 	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
 
 	/*
-- 
2.17.1

