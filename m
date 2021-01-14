Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCD82F5669
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbhANBrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbhANAlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:41:20 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAA1C061387
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:08 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id u8so2951054qvm.5
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l/iDpsm25breulTeHkzmVCt4ItjsCNTncC7g6D70D8s=;
        b=f69wpP78P0lUaUxEJJ++xmXO45xclAjIiQxB6+OkFqqvhlufR3vdrkro3md2YN7wTb
         EUO8GJGOd6dfLzAuITHr5BpKmjbkOppinE9c21FETRMCtGvcj2k6AOwxEdwP2rLhejqm
         ch+1LKkLQwtcEkZSulxmBK5u/IZYFexqvMpvH0themolqJGsaGn2ZLrNcb8S8tDSoF9l
         mgSVT2RmltY6N2cYdXJoZKv6IC1Tx7onks0AADpPFwstuEwsREOqse+cCyuemBCh9A3o
         ZWwwRfiMWamH3at5aSrfNXyQAmtKxNiUc+M3Is8d99ctxdz7qsQrKdK+ffbwutc9hlf/
         B/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l/iDpsm25breulTeHkzmVCt4ItjsCNTncC7g6D70D8s=;
        b=Db3Lo+7lTDcEl8Vknj6e+OzxRRwCcAyt1KFgUQGDgUwdNkxian99Ug5/zUG3e5PM0K
         cekS/ojPXc4PThEbTMZDWdYwVQLiwKbzSQlwUoCZE8TVRW+GzWS/+dkTkYdRrg+TJsq3
         jY2vLqyaFSa8TDzPgXs7LWhzhR3SvUSIPKwXgPuSL21tf1TTOI5NCH329Lm7A66p0IvF
         m+9WPeAH+/ZhtpC0zqRsbhsv+Uwu8HJHY2OykOsUNDHv7uL9f4g2+OnF1EyHKCgh9spl
         Maly9XTttLXw/KMiKnZbMNya3AhCdXMpTLmIRMXUQjyPcuENiKyWWf70bULntuhk1rde
         gxKQ==
X-Gm-Message-State: AOAM531JdKze4eAcGqtfQr+Zs+Ld6/lRbuYmYRw1bGf4LU75Ed5m8LIY
        ILk46Razxe77qqNc8D+TK882Qfmg3Dk=
X-Google-Smtp-Source: ABdhPJy6vZ+RTWIy0mpPr0BIyY9odFFL0OMXXoVWvHABdyjnk1NjPrVKbipaB5MAkXUr02/KEWpntrNbsY4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2b2:: with SMTP id
 m18mr4780555qvv.40.1610584687809; Wed, 13 Jan 2021 16:38:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:07 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 13/14] KVM: SVM: Remove an unnecessary prototype
 declaration of sev_flush_asids()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the forward declaration of sev_flush_asids(), which is only a few
lines above the function itself.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7e14514dd083..23a4bead4a82 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -41,7 +41,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
-static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
-- 
2.30.0.284.gd98b1dd5eaa7-goog

