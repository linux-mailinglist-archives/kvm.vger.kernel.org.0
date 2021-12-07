Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7111E46B7F7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhLGJyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhLGJyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:54:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DC3C061574;
        Tue,  7 Dec 2021 01:50:31 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o14so9049875plg.5;
        Tue, 07 Dec 2021 01:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=avCPCpqJAtLXvDtt+cRtCdMBtOjy+usZWeiiyquauUg=;
        b=V8dQo4vIcJIKxhwATrDALFAC1PuPhU9p1srG7qAI146b6qfnWSpKWOesfvXfQ83rvc
         QzmcX2Zi+0tO2uiFqSCcvv3XYmn/vRkAg8NAcHr5RAkGMAv7x+F34zfUh8amhbdAswry
         p0qwfFBIRRRDts2qXi9C43wNLQ6VkKtMHD6ZTJIVm3aD+hm6AqvsZN5udgKMhLchraHE
         vlmi3xehXG7nzeuxF19Dp3Abgb/UBUQwxFK7VrHHx7NeeRaeBoPepiUS7xMVwjISA3Ms
         twAFV/sx44SnkZadP42RUzsC09Fjim5Ipr52Xv9X/ilJhamWOQxPR1EGtANLDXru+wIY
         IMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=avCPCpqJAtLXvDtt+cRtCdMBtOjy+usZWeiiyquauUg=;
        b=JXMzKLDOBacOSl1yh8FUBCgB2yt38PF76o8mMXhbk1IcefBciu1pi/ELukV01iJ0DX
         oFJmEe2+Dii7fipGoiQcKrF7ImiJDtvZS3NLeV+7DIhFuSIUu8gR7CAz4EOf6RZg5oQp
         1MKOm6kHsIG+Crc57RQVg+iWyOq63tTpiOXqpFriIiyKEMO1ct02DyQMKVBykSTYJaj+
         UXo+O4vSoVOQqOIk28nUqaSbdGDutufphyR6y5WMUCMj9aN0uUulzKkWTnjogDOL99/m
         Ih21lzqHY2xfy2XUG3rLwE0g9K8trHmLD58kNEPmURNJ5d7vEe1hoJ0XXCLamzxDxY+N
         2mzQ==
X-Gm-Message-State: AOAM533EhlJvYUBjA1MavHJDG52p6dEi35BSqPXklVBpuV6KeNSsCUye
        3VpgDLmpBvwgag8TxfVGEOzIj1OV0eQ=
X-Google-Smtp-Source: ABdhPJwS0t9Coeno8fCJnkwIBscqrWH2I++ySuyOMs/tjZWxFkMelQznpV2s68kKCUFVoBjuHlzKnA==
X-Received: by 2002:a17:90b:1bcf:: with SMTP id oa15mr5428977pjb.161.1638870631314;
        Tue, 07 Dec 2021 01:50:31 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id d15sm15861277pfl.126.2021.12.07.01.50.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:50:31 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/4] KVM: X86: Fix comments in update_permission_bitmask
Date:   Tue,  7 Dec 2021 17:50:36 +0800
Message-Id: <20211207095039.53166-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211207095039.53166-1-jiangshanlai@gmail.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The commit 09f037aa48f3 ("KVM: MMU: speedup update_permission_bitmask")
refactored the code of update_permission_bitmask() and change the
comments.  It added a condition into a list to match the new code,
so the number/order for conditions in the comments should be updated
too.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63c04c25fd66..9d045395fe8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4550,8 +4550,8 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 			 *   - Page fault in kernel mode
 			 *   - if CPL = 3 or X86_EFLAGS_AC is clear
 			 *
-			 * Here, we cover the first three conditions.
-			 * The fourth is computed dynamically in permission_fault();
+			 * Here, we cover the first four conditions.
+			 * The fifth is computed dynamically in permission_fault();
 			 * PFERR_RSVD_MASK bit will be set in PFEC if the access is
 			 * *not* subject to SMAP restrictions.
 			 */
-- 
2.19.1.6.gb485710b

