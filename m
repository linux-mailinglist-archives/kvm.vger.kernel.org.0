Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AB517EB6C
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgCIVog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:44:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbgCIVog (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 17:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583790274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=RMnb+NvCYpUUCZ1w9CSsUi3LHg2Le/DHtnnszUvK/PfF6aShebqp9TWextIdZt+PFJ90Qp
        cHkqcGiL0NtqhYF04bU0peA61Frn+bfGWrnWnH9hxyMRtLBlS71V7ny/0jS3MoK7tQWSZ5
        1z5IBhSpAjtEAadpnVy61GXC/TnA1S4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-rGdOoHvhME6IU1BmzGGxxQ-1; Mon, 09 Mar 2020 17:44:31 -0400
X-MC-Unique: rGdOoHvhME6IU1BmzGGxxQ-1
Received: by mail-qv1-f70.google.com with SMTP id l16so7674781qvo.15
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=Dk0rFyP+nAzdk7AASHebzhxyg5iv1x1LqT2H9x6JJPWBCz1jEdyk+dE/NiS+SID85G
         MC41E8ol026ML2p6CU/90bXvIUy27YC+z9U1hIJl/OatvgO64JI/cgvKfcGzdNCtMTMP
         45hlzPQDhzn4v5WQHCMur9/kH3wNeDlr/zHsRlfpVnB7smSiQsabnTOal01TntB9RgrG
         R372Hdsov6H0ecXjeGiBGUza+E88nQjuFjNyJUC7ESQyoiJtFLg+9zibasnjBZBBqNyx
         A0YI1ozxWzBc6M2GgwP9M6CnPCRoMBV/0SgtwdM5MCB9VWYF7wBnNX7B26xch5QKl2tO
         DC/w==
X-Gm-Message-State: ANhLgQ0x6K2WjfliG+8m8rIFhbqIV+GJlHHDEkm7md5uwnzdc63urRUR
        8Qk6xWuRC7OIqDqyfK21etF9UmE+pvZXasW+VUOBNxCTtVuzI7CAHBPArbeDipBP04y9vXqQlQ0
        gwC0uQzPtatPb
X-Received: by 2002:ac8:7613:: with SMTP id t19mr15821442qtq.203.1583790270264;
        Mon, 09 Mar 2020 14:44:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtNsKwrUcoUekUZLm7aMwtJB3yh7uevNGAMIN8cX3luE4VyH2NbSx/AJmszLvjz/oRxyaNn7A==
X-Received: by 2002:ac8:7613:: with SMTP id t19mr15821436qtq.203.1583790270038;
        Mon, 09 Mar 2020 14:44:30 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 65sm22758686qtc.4.2020.03.09.14.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:44:29 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Mon,  9 Mar 2020 17:44:11 -0400
Message-Id: <20200309214424.330363-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
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

