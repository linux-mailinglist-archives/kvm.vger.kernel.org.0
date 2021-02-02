Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1F30CB4A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhBBTUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbhBBS7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:59:49 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD3C0613D6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:55 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y19so1670737plr.20
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=B0VigK2P5ak64VCq6hWJQFhuqtks7N3lzzr7PnL5znA=;
        b=f10BMaH1rM64eodNhWOBnAnthqsNAHjjKYrvC9ZophPlUZRe2fDKTrcdwVRetQigOD
         8BKXc5ZpDg8iWDD/te/SmQKPVJPIOlbvZypVTq3M7TaSk387aVTmcZENyujIqiSq9tjK
         NdTRVdp2eXPSFOeo8C4RCyriGl/ze9F/o9s6L0cjEntCb2PSbFYcJMryUHz9evMXzv40
         hbu9zFHK7IPejA27L+onORHo8do7QuTyU+ymwx0Y+fgBMqV4IBkPbA8RhZTbfa/ohpd/
         GbjVsUYW1aXlOT///YnQFIUDV/VDdOm9wu2Xi04D/qMmcy1fvxjueT2AKSW+dd1AdPsp
         Imlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B0VigK2P5ak64VCq6hWJQFhuqtks7N3lzzr7PnL5znA=;
        b=APLi7Pa8x+f/IPnBN9QVG3CWLxmR3l7cHpdJYa1dsbo76reeNPEm2kPmN525lM9ypb
         zO6BMBT9QmmZoyf7n4rBbxkuIGx4CHAFS1RD8Nj0w7KxzLREQJ1OdVE0QpAo5s/IU+rv
         pizwfPY/k2hoAdryCcAWPBQDoiMDgyxSgteuEk2PP9ouG66zpaTza9MqSLBEYTRWSAfU
         R30INnomfFRpr4u0vDP9x3iFwHgviLAlqj5HxyCDepqMkiYkigXizJMxIrYK1gdsG6nI
         1oOf30WnJeLjKBRBcXL3ytpTUHPAw+oYxz+gDwxq1lTg+hsmav4LvJ4bO9S4MQmaCI/a
         ihSA==
X-Gm-Message-State: AOAM532h9IBuxtbRmwaK0A74W5k2JpBlizdrJfzZ4+/e4hkSyPDPGTfR
        Xu22MdTk9AtF73BIIxKAA5An04CNZaJK
X-Google-Smtp-Source: ABdhPJykMdXaaVCk0ONAntUZG48nUEsuDAg3ibhbZYtyiHnZr+MJZXWrl2Xj/U3/Z2Wq1xNJK2nW5Nb2e5lN
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr614578pjo.0.1612292274520; Tue, 02 Feb 2021 10:57:54 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:15 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-10-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 09/28] KVM: x86/mmu: Fix braces in kvm_recover_nx_lpages
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..60ff6837655a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6005,10 +6005,10 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		if (sp->tdp_mmu_page)
+		if (sp->tdp_mmu_page) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
 				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
-		else {
+		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
-- 
2.30.0.365.g02bc693789-goog

