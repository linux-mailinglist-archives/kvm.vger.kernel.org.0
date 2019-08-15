Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC608E913
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 12:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfHOKfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 06:35:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46579 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730938AbfHOKfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 06:35:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id m3so538354pgv.13
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 03:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zChKo2Uz5JQYeXc3YwPovpGzjABj57VUJELuv2bvYYs=;
        b=OnvXxyqveBg/8YODNcQkj4BZbMyK/5mjfVEb+poRSrFyF6/TPM+usX1J7N+Vr9/97O
         F9gnwJl2dgjYgnNFiBRMMkIASzoB8Y/MqYV6X60Rk1l8zmeAXrtIEODCjpnhSJfk+Cmg
         2e007yhfFB4v9oFLUHm2j6ZM9n8BmIJhvU5dsbH8f0jevrNUgdXUSOVhoAbb7wFYhGo7
         wPi2ctpxNmdBrY8YXNyDfeGmeGU5yFqHHPenWcfa86vaUFi7w3JkJzuuKGYf54Ua6wqX
         8kgDbtOa+THdFsW8D8/Ev8ATIaAEoHJRPj0HKa4/qMhQfuDRHv3ySkQnzwq01lXu9+Ym
         FeMw==
X-Gm-Message-State: APjAAAXnW7MVVAtlDK/OY+zZ8CCtk0/WK9aAhXUCa7XU/IKrAxclxrTO
        4kJ1w4hTL+a6yLvNUxwk051x4n9SK56omw==
X-Google-Smtp-Source: APXvYqwI2QTk5mCHY4Q0WG7Hsbi2PIhtBcBFYCFgj/3jd2bHVzCVlHpyB0G552ORrBN9WHP+UrCgyA==
X-Received: by 2002:a63:2bd2:: with SMTP id r201mr2916911pgr.193.1565865317543;
        Thu, 15 Aug 2019 03:35:17 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o128sm2481066pfb.42.2019.08.15.03.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 03:35:16 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v2 2/3] KVM: X86: Remove tailing newline for tracepoints
Date:   Thu, 15 Aug 2019 18:34:57 +0800
Message-Id: <20190815103458.23207-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815103458.23207-1-peterx@redhat.com>
References: <20190815103458.23207-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's done by TP_printk() already.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c682f3f7f998..76a39bc25b95 100644
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

