Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8E540002E
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349437AbhICNJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:09:29 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36514 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348680AbhICNJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:09:27 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 18614226EE;
        Fri,  3 Sep 2021 13:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/aqcXNXV2z3s8v1xyCrTCdccfBrUDxXipvTxdECmtZk=;
        b=G5bP1J0tyUNc77diUuUU3EF1BM/ZfCxa6TMGCjPPz6d+I9ked4Q8HtRAlu+0IqvceIEWS+
        78k+9Y9x/K2ueXBNTdN0uz6grnGhBFF+Dil65o/s0y9O3Z1j6oGCUgmDHeLutPl32/I+f3
        TLodQcUcWbC7vPShIO4iOtxMvlj/Y1M=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 883B3137D4;
        Fri,  3 Sep 2021 13:08:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id sEi6H0oeMmHYOAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:26 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 1/6] x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
Date:   Fri,  3 Sep 2021 15:08:02 +0200
Message-Id: <20210903130808.30142-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The file has been moved to arch/x86 long time ago. Time to get rid of
non-x86 stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- patch only kept for reference, has already been added to kvm.git
---
 arch/x86/kvm/ioapic.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 11e4065e1617..bbd4a5d18b5d 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -35,11 +35,7 @@ struct kvm_vcpu;
 #define	IOAPIC_INIT			0x5
 #define	IOAPIC_EXTINT			0x7
 
-#ifdef CONFIG_X86
 #define RTC_GSI 8
-#else
-#define RTC_GSI -1U
-#endif
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-- 
2.26.2

