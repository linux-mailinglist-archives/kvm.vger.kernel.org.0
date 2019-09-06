Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8000DAB095
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 04:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404361AbfIFCRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 22:17:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404345AbfIFCRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 22:17:39 -0400
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEA1BC0578C9
        for <kvm@vger.kernel.org>; Fri,  6 Sep 2019 02:17:39 +0000 (UTC)
Received: by mail-pl1-f198.google.com with SMTP id y18so2622967plr.20
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 19:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U9X2ocg4xLLzJVV8u6FR7s0StrvzfFTOD0TsbOAZvYI=;
        b=uUEP8/4SKrFUF1FzogdpRQ8yjWtU/rUppVF6jcjwkMXCY6j10Z5Yo3gmF9AJLSEd8i
         Ti2pS9YwByzuRw7I5zasfT2TdnNgu31SiopOEexbiEUZgEfMknP7+y4RhS2AaY/M7L2d
         CUAU/ZGUQwD9fa0DynMAOCzHVXqFpVwKvV3rB9RNJLc0scIS4ibXozQT/9Ow/NeaIQRN
         VhNKo3zqLFHfj6nX8xZ/OReRfiCQrMK1znfIo6Vb7MgPpdgyfjpifwD4VItrWztqBGOg
         CX0mPqKjgckjTixznAYlFQhFxBO2WA8OJjsAySKCqNg/yQ+JUAYLwKpT+uPHl1gVrflf
         Ea4g==
X-Gm-Message-State: APjAAAU1AcPvT7WqF7UVD+lncKFtPq3zUTQjiBk9rtW9/t9Z4NBFD2pi
        YXPZTrQLjyTLnSS29VRcYpEsGtCepMG4dxo9s5G30jgoiPYwrq0XfIJUgKWKgtvGC1IwDIn2lmP
        VFiUl29H4swPA
X-Received: by 2002:a17:902:e584:: with SMTP id cl4mr6712910plb.160.1567736259393;
        Thu, 05 Sep 2019 19:17:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzA7XI63VxKtVoT9lqWgBy/9HesvkQuEH5lLydx5b5gBH692ZTbf+VCfENgHvilhjZtCmHvMQ==
X-Received: by 2002:a17:902:e584:: with SMTP id cl4mr6712905plb.160.1567736259246;
        Thu, 05 Sep 2019 19:17:39 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11sm8212359pfg.94.2019.09.05.19.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 19:17:38 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v4 2/4] KVM: X86: Remove tailing newline for tracepoints
Date:   Fri,  6 Sep 2019 10:17:20 +0800
Message-Id: <20190906021722.2095-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906021722.2095-1-peterx@redhat.com>
References: <20190906021722.2095-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's done by TP_printk() already.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 20d6cac9f157..8a7570f8c943 100644
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
-- 
2.21.0

