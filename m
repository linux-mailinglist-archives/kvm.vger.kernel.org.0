Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1BF0128374
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfLTVBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:01:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727402AbfLTVBz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=hgiV5wlj3wFmzZwH/RHvvGqBrK/BNLeSLIE0aaDrKVhutX1D2ZtQ6qtU2z7EG3D+C/uOuX
        P7j3F+aVU1UxVY2a/UGPd6aBYLp3RJrQ2Y8IVsx3qxGXNsO/GTmHPfFdC7z9OQhrOTu+Za
        UO1Zrn81udgPGKsSDe22EN/NSxefPrU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-VLF08RjZO3eRxKXG2NljFQ-1; Fri, 20 Dec 2019 16:01:52 -0500
X-MC-Unique: VLF08RjZO3eRxKXG2NljFQ-1
Received: by mail-qt1-f197.google.com with SMTP id o18so6778661qtt.19
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:01:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=KJjDmELNoB5rE9pzBa3EMybzbcqond7aW5tHgfq2dPyEWHgdc5fBsxzm28p4BS4l1K
         +0ZNgmJo8iDUNMmqY1YhvDKy1jcrUNIx58s/e1lMXnHiPbioZAeHOBr8pipbHisZGSeE
         GuQT/lRAnE/uLL2ikJPUbNfn0aaRJosOeAbu5IHYRgnLR5htxXBbHjOY+6kTy63p9zMs
         V8VoLq9bOcVs76WpydOSHiVu/vUuOM5V0GFOXYoFmQQ7xADXeGqlZ01ARfVlVpviu8kT
         BbZtlvEREar/GwXZCt8hYPaStogBaO3q2OAM/U+OX5uibrO7POIsczPQ9JQBlQHkWHCI
         +jLA==
X-Gm-Message-State: APjAAAWUi3uF1sW/qlxTyqrWZdi4SHb8OtC9jyORUqQFBntrgyWqR5wc
        X1mL5eVEnPwuZm2JHNBb/3xGApl/QBYdi4AZHTgp1vAfGlHvSaL73EE3UQtNjXUP1yF0OwYIn4m
        MDpLWDwZlwZO7
X-Received: by 2002:a0c:a145:: with SMTP id d63mr14562961qva.120.1576875711980;
        Fri, 20 Dec 2019 13:01:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyyE0CUezS064v/bD144uhIMYKgEXzWV3W5bB3BV3yElQzPwD/3hl0DjnyDKfJVzzqxYHiA7w==
X-Received: by 2002:a0c:a145:: with SMTP id d63mr14562932qva.120.1576875711752;
        Fri, 20 Dec 2019 13:01:51 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:51 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 02/17] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Fri, 20 Dec 2019 16:01:32 -0500
Message-Id: <20191220210147.49617-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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
index 7ca8831c7d1a..09bdc5c91650 100644
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
 	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
@@ -274,12 +271,10 @@ TRACE_EVENT(
 	),
 
 	TP_printk("vcpu %d gva %lx error_code %s sptep %p old %#llx"
-		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  " new %llx ret %d", __entry->vcpu_id,
 		  __entry->gva, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
-		  __entry->old_spte, __entry->new_spte,
-		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
-	)
+		  __entry->old_spte, __entry->new_spte, __entry->retry)
 );
 
 TRACE_EVENT(
-- 
2.24.1

