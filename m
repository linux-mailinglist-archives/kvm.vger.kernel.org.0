Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C451012838D
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfLTVDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:03:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26611 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727749AbfLTVDg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=g338PQH4L5FEQFySm2VjtVGXXjdOgtOAPLXB9UEXosY+8CPBmhXS/9Jugq1+hRNe+xwYFX
        94TIHhAoU79ZtJqC36YX7ZzYrds+7WRxpZFkqRRa7Zd2NfFKT9b9aNaDZ7UKKUsCDUdrLe
        idIRP1YDQoAYdkEKhYa1BYCPkUZ8OLU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-sO2YBFtBOlSzo0I8d83xYw-1; Fri, 20 Dec 2019 16:03:33 -0500
X-MC-Unique: sO2YBFtBOlSzo0I8d83xYw-1
Received: by mail-qv1-f71.google.com with SMTP id k2so6692186qvu.22
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:03:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=Nu+mmFO/zBqOJEmPg1b+511yC1Z9L9WTwfG5b2tUDJPaJRiyHmHnKniYgqG1kLAnjE
         Q06tdNlasG8bif5eU9WouUiOEhBFWOSDDvlnXeIEdtX68guw/RIbY/VYHkX96N3fkxYb
         5Zp5Qt9tZU2rjjI4BBT87ha/AKKjBmnZ7aZb3SqJrmMci3TaPvO/DDLP7MpGmXMLxQdJ
         Cqu83zlgZW9w4v8IPmL/4cfXIAnaHLe3Tk6BojJDa9fu0S5fmz6A/HyUTMa2lPPgISLL
         7OnLdHVfUar3OoLgNvxC3O0CLFdadry2Uu8AFEPkBDpfRd1U72ttWmUGDX6gkGpveG7j
         CoKw==
X-Gm-Message-State: APjAAAWzdwO8xR6hr9L5KcwQyLu0tBOqkVNYzLHlFkf1awuxUa9QzfWS
        w87LuTF0oAYzUSz1ZzrmR4v9LFRMKY0eucKebKywZtGGt4JE9paeGpxTR64nFe66ZCZFkEyx9xT
        4aB21pOKH/IoI
X-Received: by 2002:a05:620a:1324:: with SMTP id p4mr15563894qkj.497.1576875812886;
        Fri, 20 Dec 2019 13:03:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyzpJoDwbumEgXM2rd/MSIPuBvYBc/66AQA/wq59Gx92NiDKpzaG+U5dMYCgnpLzFCTUZBrpA==
X-Received: by 2002:a05:620a:1324:: with SMTP id p4mr15563877qkj.497.1576875812682;
        Fri, 20 Dec 2019 13:03:32 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a9sm3061018qtb.36.2019.12.20.13.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:03:31 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 02/17] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Fri, 20 Dec 2019 16:03:11 -0500
Message-Id: <20191220210326.49949-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210326.49949-1-peterx@redhat.com>
References: <20191220210326.49949-1-peterx@redhat.com>
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

