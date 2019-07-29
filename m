Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D587846E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 07:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfG2Fc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 01:32:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36201 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfG2Fc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 01:32:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so27617601pgm.3
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2019 22:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZJ4b8SL4lecIrcsiUN4G2OH6Ni8r+V1YrncMnTM190=;
        b=Cbk1k5So2+4rU/PQUq12C5L+/PpRdcocfOAUCKS6OiFfplGsg7FQRYqfMsXlgeptTM
         eBU/8sKNQmyYKyeovA6jflLjToWbUvGoCjAjHKMJdIlnJ0USOPG51YSCqULjlViQu1hI
         0/r4dkzEGPykPnOy2r+rliXHPOClsUC8q6MsQVZoNCz7IzHavCdCTg/kfjyOM7m6nnmE
         cqnAjH3thgRun8F0EvoyiRKhCTjLDW+1pDv5lPbqYg3MPN62l74RawkMgQQj5X4f8kzB
         5kbs3YY9nXV/45pjN8TzMhfOj0dOjUCeRZZiCwazSb3v2zxEE+QvXy9ayTTY7gK08n6+
         5cBw==
X-Gm-Message-State: APjAAAWrVlTkhhiBHX0mvAhAI9G0TSTLwLuGKWxuVSgkzCKyxT5YtzYj
        R4mAJ6DZQaD4MkoHX34htIyGrwnkHzU=
X-Google-Smtp-Source: APXvYqzIH4wdp7LI90CRJPdh2W8D/+AUxVpt9lstQt7lhNhVcvrLaPwH0fYPG1VykHGKS1tUwlHXHQ==
X-Received: by 2002:a63:6c46:: with SMTP id h67mr94500479pgc.248.1564378377506;
        Sun, 28 Jul 2019 22:32:57 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o129sm30498550pfg.1.2019.07.28.22.32.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 22:32:56 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
Subject: [PATCH 2/3] KVM: X86: Remove tailing newline for tracepoints
Date:   Mon, 29 Jul 2019 13:32:42 +0800
Message-Id: <20190729053243.9224-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729053243.9224-1-peterx@redhat.com>
References: <20190729053243.9224-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's done by TP_printk() already.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 26423d2e45df..76a39bc25b95 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1323,7 +1323,7 @@ TRACE_EVENT(kvm_avic_incomplete_ipi,
 		__entry->index = index;
 	),
 
-	TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u\n",
+	TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u",
 		  __entry->vcpu, __entry->icrh, __entry->icrl,
 		  __entry->id, __entry->index)
 );
@@ -1348,7 +1348,7 @@ TRACE_EVENT(kvm_avic_unaccelerated_access,
 		__entry->vec = vec;
 	),
 
-	TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x\n",
+	TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x",
 		  __entry->vcpu,
 		  __entry->offset,
 		  __print_symbolic(__entry->offset, kvm_trace_symbol_apic),
@@ -1368,7 +1368,7 @@ TRACE_EVENT(kvm_hv_timer_state,
 			__entry->vcpu_id = vcpu_id;
 			__entry->hv_timer_in_use = hv_timer_in_use;
 			),
-		TP_printk("vcpu_id %x hv_timer %x\n",
+		TP_printk("vcpu_id %x hv_timer %x",
 			__entry->vcpu_id,
 			__entry->hv_timer_in_use)
 );
-- 
2.21.0

