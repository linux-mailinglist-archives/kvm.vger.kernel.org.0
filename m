Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665B41524DB
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgBECvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 21:51:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727796AbgBECvO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 21:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRATN7sKWcZdWDij4U02uLG0iob0fByx2e0Dt2ueT/w=;
        b=ghyN+ezigxQRPpt9/+YsXDURdcO6DUtSb9loBf5zsT9jmBsSfH/cvV2QqnOcLLkWbz29Gy
        dF8zz8omT/1Gb4xOcnQPY9r3rU66dJR5SSL9/RXlm8hK0tUljnfOKdA45I7OCyTxh4Zs1u
        hIFxDNd9bLAVC4fPxWUYv2j2wwykqQA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-XODNSm8kMQeugOF_DE0fyw-1; Tue, 04 Feb 2020 21:51:12 -0500
X-MC-Unique: XODNSm8kMQeugOF_DE0fyw-1
Received: by mail-qt1-f199.google.com with SMTP id c22so380893qtn.23
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 18:51:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRATN7sKWcZdWDij4U02uLG0iob0fByx2e0Dt2ueT/w=;
        b=nTII+8lAoe1HKMcytn9qYDHbIqa+j8+ZTkPj6M90QGrhJUT21jP+idSng9eymBdSj0
         AjkVH5pAS15kslrHX2k9HySZ2CccPv6cF+Cu7jgViBlrZzJTuC5bPQx8sBoosCdiQlWb
         z47AR2VQA2VvB+rGQUdvsJLicE9/jTIBMuxjuVTh7gvKBkmpMZV6onl7fnWYEgIRggX+
         eyRj8ovNIcPbNTAko00i0TpDO3GbVOCUS6TuTfPtS3q2Z37wb3qOOlfIommNZ2zvXd77
         M/OvqKPDW9pDRrQJaJUiMoO2ESmaYqa4AipFmiQ5eA+tgcucSEnCw05bbdSYdblSjK/P
         GxcA==
X-Gm-Message-State: APjAAAX/Qsnz0+ZODG2TtgwPC89qTfDc8lwhoHGcj6kFco034Y9A0fNM
        BrJX2CRkiKGYsoLxOpUMi5I90px9uyYYwU9nC79oWek4CuEBqQ0oRuIOGngmMpCoO0RtSdaxNvn
        OpWS0uRfVwZvA
X-Received: by 2002:a05:6214:1428:: with SMTP id o8mr31031719qvx.87.1580871071594;
        Tue, 04 Feb 2020 18:51:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXJBNvuIFypmIVFhWk564W4B95sKGIgajPPJbgokUyyK+XPEQ6Y2igS687dPfdxxOzpb45IA==
X-Received: by 2002:a05:6214:1428:: with SMTP id o8mr31031696qvx.87.1580871071387;
        Tue, 04 Feb 2020 18:51:11 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id b141sm12380923qkg.33.2020.02.04.18.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 18:51:10 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, peterx@redhat.com,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Tue,  4 Feb 2020 21:50:52 -0500
Message-Id: <20200205025105.367213-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025105.367213-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
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
index 3c6522b84ff1..456371406d2a 100644
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

