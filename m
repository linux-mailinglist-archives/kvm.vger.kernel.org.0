Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDA1FC4C9
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 05:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgFQDlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 23:41:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:52603 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgFQDlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 23:41:25 -0400
IronPort-SDR: dn648OMM6fiiGGXoX67YKFvqmLIsxO9YidWKl2N1+4pLfC5Kodvb19wA/6duW9kfOxm5L7mv31
 7v0aRtT2YhtQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 20:41:25 -0700
IronPort-SDR: yD9c5qPCcw0nP5vDwu24s9gyXkO/DttkWnkRWj5wM2HuyxcvjgAB/UB7ij1AxJLzjfzqTRK9/w
 jcHjjDhLRfQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,521,1583222400"; 
   d="scan'208";a="476681552"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2020 20:41:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Remove vcpu_vmx's defunct copy of host_pkru
Date:   Tue, 16 Jun 2020 20:41:23 -0700
Message-Id: <20200617034123.25647-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove vcpu_vmx.host_pkru, which got left behind when PKRU support was
moved to common x86 code.

No functional change intended.

Fixes: 37486135d3a7b ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8a83b5edc820..639798e4a6ca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -288,8 +288,6 @@ struct vcpu_vmx {
 
 	u64 current_tsc_ratio;
 
-	u32 host_pkru;
-
 	unsigned long host_debugctlmsr;
 
 	/*
-- 
2.26.0

