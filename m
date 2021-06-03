Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D2B39A22D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFCN3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:29:42 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:5151 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFCN3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 09:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1622726877; x=1654262877;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=mhdX3ValGWDxD19fMXddG/g8FPmralooTe7o3wFMNuw=;
  b=WmIQva4yowCcEsAF1g4knywDRR54JfwPtaHqnmzhYU+GPEK40hZJIUuf
   OUD8G/Vcer8spO82b1yAROmloxAvgP88qrf/E/zsFQGgHAVS6rLP2Fh4b
   oO2wPKLFFfpvJGhFdwOTIqTdCoDRgeufWSGvVth0Hblnagc4vD8+Zn6y6
   k=;
X-IronPort-AV: E=Sophos;i="5.83,246,1616457600"; 
   d="scan'208";a="4731771"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 03 Jun 2021 13:27:49 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 69B0BA2086;
        Thu,  3 Jun 2021 13:27:45 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.201) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 3 Jun 2021 13:27:39 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: hyper-v: housekeeping: Remove unnecessary type cast
Date:   Thu, 3 Jun 2021 15:27:12 +0200
Message-ID: <20210603132712.518-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.201]
X-ClientProxiedBy: EX13D38UWC004.ant.amazon.com (10.43.162.204) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unnecessary type cast of 'u8 instructions[]' to
'unsigned char *'.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f00830e5202f..7d9eb13174b6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1252,7 +1252,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		i += 3;
 
 		/* ret */
-		((unsigned char *)instructions)[i++] = 0xc3;
+		instructions[i++] = 0xc3;
 
 		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
 		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



