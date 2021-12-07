Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFAD46C3AA
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhLGTdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbhLGTdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:33:46 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5346C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:30:15 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso9321865pgv.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3ccAeduOzxtyrEdOkNdQDTOfyUIAJBfdyRg/JU8kY04=;
        b=VDeRVd6khk7dj6EMEzMWVk7CsPs0SGDsLdhzx0MA4FAd1lLzui6bJdTCMfd2AAmXkm
         x4wTdKcjmnMgcyHZEMDPcdLKajnoUhAWn0l8JLauo9DnGDercxPKeBkGbBs+7mQ75ghT
         Er1x5rsG44mUxrQzJK/HnlUePYtJ48brmlY19SK4fgGCDn3EiZG4CaxUSAHw2De0t5+1
         4PrFUu3fPDzKv66vDigBJBHhf/tw7uDVxeUl/Y/BFJbmEkL2KOGhJ7KTDCVSuTFlxTQM
         90hyu+StdugBpNbv+ADf9sbkAB8IuWjf7Z9CoRgRgKWPefuXNVOAhP4A794CF2RZO1Sq
         Coaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3ccAeduOzxtyrEdOkNdQDTOfyUIAJBfdyRg/JU8kY04=;
        b=r4IsxDzU7h8Sy/dgnclW3Dfj1pF2uubhp8sTCl7CBIwC0jXICyb/Aer6eRBW3c0eep
         Ncs44IbBAqG8djwYDYY7rts9pYDZQvqhDhP+5rC0s7RUxqJ2vifA1PJSgGlLXv8HVywQ
         nax+fxZamZoXk2yFOnJJIjVEvHpMzHJMOKhXEurr4b1nKhe3cR5qQWjtrrln4no+E2Vx
         bx5Q9BtsCj32WtwqjFWSUeSXF2NM6/zNd/F6vqJZmJpqsRFx7LpLb4FXdDSNTLkRkU3T
         fI5+GQGcCfH6jrRwiW+rHh1lqrHd1qvlOc83AdXmQL4lbhSnUGSeegogmQ3DSyjuZwl0
         1zbA==
X-Gm-Message-State: AOAM5321FUddDokqstEeDa+ZAKBNiQ/9JAPtwVrR4judpbdatWm6yZws
        GBtuPVbGfrdC33o/mpzhajE7QRJ3E8M=
X-Google-Smtp-Source: ABdhPJxAK4nCRUMMd1VB+V2mxCIe6PgDXOvm6BQegPzlvj4QGLd+r3vOx5t1WbZEETrceU0Ta23YmSpwsCk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2409:: with SMTP id
 nr9mr1278569pjb.244.1638905415320; Tue, 07 Dec 2021 11:30:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 19:30:05 +0000
In-Reply-To: <20211207193006.120997-1-seanjc@google.com>
Message-Id: <20211207193006.120997-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211207193006.120997-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 3/4] KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the documentation for kvm-intel's emulate_invalid_guest_state to
rectify the description of KVM's default behavior, and to document that
the behavior and thus parameter only applies to L1.

Fixes: a27685c33acc ("KVM: VMX: Emulate invalid guest state by default")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9725c546a0d4..fc34332c8d9a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2413,8 +2413,12 @@
 			Default is 1 (enabled)
 
 	kvm-intel.emulate_invalid_guest_state=
-			[KVM,Intel] Enable emulation of invalid guest states
-			Default is 0 (disabled)
+			[KVM,Intel] Disable emulation of invalid guest state.
+			Ignored if kvm-intel.enable_unrestricted_guest=1, as
+			guest state is never invalid for unrestricted guests.
+			This param doesn't apply to nested guests (L2), as KVM
+			never emulates invalid L2 guest state.
+			Default is 1 (enabled)
 
 	kvm-intel.flexpriority=
 			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
-- 
2.34.1.400.ga245620fadb-goog

