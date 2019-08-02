Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7618002B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406732AbfHBS3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 14:29:00 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:39944 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405915AbfHBS27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 14:28:59 -0400
Received: by mail-pl1-f201.google.com with SMTP id 91so42054461pla.7
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r3rc6yd9xp3y2j7wcxshyFyfwfhlYZ80RgAuLgcnSAM=;
        b=UkQvSbXbuBLOtFJAHKnBa2d0F1W3JaGahk4zE1It0a4nclRszEiva5bagPLaO78Y6x
         cDk9s5j/I3hmhsvXEqEseXTeeTft9oUkzwFN16cONvUDUOZ1FLPAfuJCaNMUmG7BG1MC
         e1dc8Rt1xQIoa3t3gyYxP7/y9ZQOw7J3cyBE8u8hkdvAjrxKIqjbqVMvsCW4B1pNkP0x
         8RpVym22umCN2fS5l1TPTLcQcquWPbPc9vYA6QbRB+eoJZkYzipdMv9xFhw94VA443U1
         UlUoA0UDgRE+hwICA+zeBk5+xiTL8W5Bo5ac36p2aZKz/GWOIVXBVF+mK272CVJ/Off9
         kf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r3rc6yd9xp3y2j7wcxshyFyfwfhlYZ80RgAuLgcnSAM=;
        b=hbxAdVlxefu9PzweYKOAtdjR94R5RB7RL+OIGv5dcfJoMs7pD+0rQW1ZUuZW8cgnkq
         rIhBoQ385ydWsL0pg7LEdBPrp7aS6IVZPBguOqn/ZIoeO2GZnfyrRHRSXR+4/lvE5jMi
         6ygLDLILpc8+mqVWpN7/BdXPM1ksVUbl0va+TqVVywrWrowONDQL+rWnlanAcVxt3/PP
         gXib14G1IvO/OAsMWB1kuMGacHe3872cJ4CRo9lXKK8qDy+XRle1kWKOAGsbR8y929WX
         iaegZMEsfVb2Fj1nojGRJZc3iAMNozBI7GNDhsUe2ZNKorSC93uBe9RBBuWVr5AR7xOc
         3WDw==
X-Gm-Message-State: APjAAAWma2pnUDTwKjT347eWO4mZMaw4ilseICsrnAAmIqlu5bmb+iXJ
        Xa1Wc2W1lbeBtodufC9AeU1T53ixsw7h7EoAMLaRDzidvnwDYBg5VKpyYaMTjLrRy5w/voCnJj8
        MfLwF07uoshm1fwegBXqtHo2l7CF1O8zwSLGa6gGFKEMFs/FzpQSaeKBtVA==
X-Google-Smtp-Source: APXvYqx6r/jRbcHRBYZBZ23RgdfmBcRYNcMkjX6KhqbsC5Ehs+os2BOB5ACM8BNQFLAd+lScuwu75fqe7ts=
X-Received: by 2002:a65:448a:: with SMTP id l10mr99742962pgq.327.1564770538340;
 Fri, 02 Aug 2019 11:28:58 -0700 (PDT)
Date:   Fri,  2 Aug 2019 11:28:15 -0700
Message-Id: <20190802182814.141849-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH] [kvm-unit-tests PATCH] x86: vmx: Fix comment typo for ept_access_paddr()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

the comment for ept_access_paddr() referred to a nonexistent
ept_access_data. Fixing the comment to correctly refer to
ept_access_test_data.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad2674..eb77b54 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2471,13 +2471,14 @@ static void ept_access_violation(unsigned long access, enum ept_access_op op,
  * with wonky addresses. We don't test that yet.
  *
  * This function modifies the EPT entry that maps the GPA that the guest page
- * table entry mapping ept_access_data.gva resides on.
+ * table entry mapping ept_access_test_data.gva resides on.
  *
  *	@ept_access	EPT permissions to set. Other permissions are cleared.
  *
  *	@pte_ad		Set the A/D bits on the guest PTE accordingly.
  *
- *	@op		Guest operation to perform with ept_access_data.gva.
+ *	@op		Guest operation to perform with
+ *			ept_access_test_data.gva.
  *
  *	@expect_violation
  *			Is a violation expected during the paddr access?
-- 
2.22.0.770.g0f2c4a37fd-goog

