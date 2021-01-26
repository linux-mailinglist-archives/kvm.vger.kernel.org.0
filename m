Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579DA303F55
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405437AbhAZNuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:50:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405322AbhAZNty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hOQeVC8pnB1ad5RJVkW/AXUC6LL4k0pfzDhhbINI6LM=;
        b=f06Itav/kJibPWt3asdg2rV32uorr4WdOelIRVuhlZuDCkRgPc8aXKOtYhcIY5RFJtoPcX
        Wy7rqkrnHj1IZ/vuGPjsHG42wfHxmLGMnM25gt0AHowIQzgd+jpmBRgfBz5/2Ow/t2Pq4k
        X6Oo3kRzbMEX9wQySoM56zwcRbXnR2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-3jtJZWruPj2JPtzCMYUe4g-1; Tue, 26 Jan 2021 08:48:26 -0500
X-MC-Unique: 3jtJZWruPj2JPtzCMYUe4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F356802B40;
        Tue, 26 Jan 2021 13:48:25 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 329FC5D9C2;
        Tue, 26 Jan 2021 13:48:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 03/15] KVM: x86: hyper-v: Drop unused kvm_hv_vapic_assist_page_enabled()
Date:   Tue, 26 Jan 2021 14:48:04 +0100
Message-Id: <20210126134816.1880136-4-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_hv_vapic_assist_page_enabled() seems to be unused since its
introduction in commit 10388a07164c1 ("KVM: Add HYPER-V apic access MSRs"),
drop it.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/lapic.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..4de7579e206c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -125,11 +125,6 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
-static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
-}
-
 int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_init(void);
 void kvm_lapic_exit(void);
-- 
2.29.2

