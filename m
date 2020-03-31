Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A188199E7A
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgCaTAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:00:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49625 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726295AbgCaTAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=GO+8PA/KdDHQqj2lPSUe2/KuzG47nqbm8j6XfBRl3s90dve8YCpPAJAahf7jIxhmvyo2Z+
        hZtYSxAMyBHUwBqTdOu/x0WbGbQsNdt44BGrfT73p07pZEjMRiX24MqGKrtHPCddP4lVjm
        qtPld3QGpZ7qUiEEtdKOAeqrWGjBd5A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-YYb3VtZ4PXW-_EfU9QqxvQ-1; Tue, 31 Mar 2020 15:00:10 -0400
X-MC-Unique: YYb3VtZ4PXW-_EfU9QqxvQ-1
Received: by mail-wr1-f72.google.com with SMTP id v17so9307934wro.21
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=EHRmOWrV+9YUaFPycnvZEeLoDyIcVeV8ZvaXR8CW830pgmnjz/ft8RIBwY5x58/xKV
         YOQ4jyHZJEY8Sc9bh8Y7biqPS1QN0uJC93xoMeNO5Xi0mu8XmvbDCXWx1qdNIHY2WkKK
         PYpV2u/YYn65ux/ywAQsK9Ulyxieazvf5tijqp/3oWT73UPTkD6p3jf1Y4ZUQzC23T3O
         eIv4czfd2Auhph8xA/II7xEm8DbmWq4gXG7hV1zalwvVH7jo4UadC18z/LQHeUA4ggEl
         6CfYZFaJAnxXb7WMrz9cZdaii2YBTIfnxMpoGUwq1opWLv3ccYtn5gAkV1JnVMjvOlYP
         kd+w==
X-Gm-Message-State: ANhLgQ3QkLejWn209NEUXFRyICr9OqAiPEf1JGC0U8FpdREu3npGueWt
        cmVbS0wGuf1Ph/XbIpT8lq27TH2jue+mLwMoS9a/q7Ju4+qx5MBZ/jHLipFkcCsIsDBFeZ99Mn4
        tfTrj+UH3TwNf
X-Received: by 2002:adf:b186:: with SMTP id q6mr21784782wra.253.1585681209639;
        Tue, 31 Mar 2020 12:00:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuw1mD28p3JHof9YrDOHCb6+VgxgT119t2q54QLWIHZ0l4+T/QIDJWlvKoTTEJJxE9mpkLKdQ==
X-Received: by 2002:adf:b186:: with SMTP id q6mr21784753wra.253.1585681209403;
        Tue, 31 Mar 2020 12:00:09 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h10sm29018467wrq.33.2020.03.31.12.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:00:08 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Tue, 31 Mar 2020 14:59:47 -0400
Message-Id: <20200331190000.659614-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It would be clearer to dump the return value to know easily on whether
did we go through the fast path for handling current page fault.
Remove the old two last parameters because after all the old/new sptes
were dumped in the same line.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmutrace.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index ffcd96fc02d0..ef523e760743 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -244,9 +244,6 @@ TRACE_EVENT(
 		  __entry->access)
 );
 
-#define __spte_satisfied(__spte)				\
-	(__entry->retry && is_writable_pte(__entry->__spte))
-
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
@@ -274,12 +271,10 @@ TRACE_EVENT(
 	),
 
 	TP_printk("vcpu %d gva %llx error_code %s sptep %p old %#llx"
-		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  " new %llx ret %d", __entry->vcpu_id,
 		  __entry->cr2_or_gpa, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
-		  __entry->old_spte, __entry->new_spte,
-		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
-	)
+		  __entry->old_spte, __entry->new_spte, __entry->retry)
 );
 
 TRACE_EVENT(
-- 
2.24.1

