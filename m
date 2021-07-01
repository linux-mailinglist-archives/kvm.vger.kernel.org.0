Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACEA3B9429
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhGAPnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33410 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhGAPnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:40 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 715AE1FD4C;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXl7KAzJEvJ9jtNlIQLYDGBEmYM3PEctw4adg8uIios=;
        b=QwGxsp1EOS4VLzIzYW0ZEsdYW6wWCyPU0qzEY0iBahoZ7Z2nc5yjBp3dutMd29Bzq+nXKm
        nDZDVtsB9akzFLwVT+jAc0XPMRrBy1/8/v0+GOVWnOjy9NW1VoyQzWYtIhPBPTPGsluDQH
        PSWbdrLdf2LmCnxxdGGJbU7eJPnX3QI=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 16AB511CD5;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXl7KAzJEvJ9jtNlIQLYDGBEmYM3PEctw4adg8uIios=;
        b=QwGxsp1EOS4VLzIzYW0ZEsdYW6wWCyPU0qzEY0iBahoZ7Z2nc5yjBp3dutMd29Bzq+nXKm
        nDZDVtsB9akzFLwVT+jAc0XPMRrBy1/8/v0+GOVWnOjy9NW1VoyQzWYtIhPBPTPGsluDQH
        PSWbdrLdf2LmCnxxdGGJbU7eJPnX3QI=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id uP9mBBXi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:09 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/6] x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
Date:   Thu,  1 Jul 2021 17:41:01 +0200
Message-Id: <20210701154105.23215-3-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The file has been moved to arch/x86 long time ago. Time to get rid of
non-x86 stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
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

