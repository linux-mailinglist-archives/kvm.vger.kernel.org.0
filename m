Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49659A9860
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfIECgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbfIECgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:36:36 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 987ABC04FFE0
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:36:36 +0000 (UTC)
Received: by mail-pf1-f200.google.com with SMTP id i187so699264pfc.10
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U9X2ocg4xLLzJVV8u6FR7s0StrvzfFTOD0TsbOAZvYI=;
        b=b3ih0DlSR4uC73lClDG18P9e91kpFJcF6InljPuCLkTiMcd9WYjyrs//Nh7W3bdOZ/
         onQnSPfD2Kn2gl+bhtaPoh+3TjrveOxbylwhRawgti5eqPPFm/Ov53z2utuM1jfV4465
         5YxcCWo27VVl+3Z7FrpxshapvzsKLEiKuUBw5PGLen8izJBfQ2c+d36uZ56GcKkg5RaZ
         kMgCHB7MdiHOHZco8spn9SoNLW2pI5ZzDdLnLFO33HQ8QTJTVIn9KjQXVZ810baSDDWX
         FBpdrU6aGQ/1DXZ4Ut/2OijQaJew9Ulea1vgs0Hqaia+whJsI6JjQpjYrDru2fJ4m+CI
         gbVQ==
X-Gm-Message-State: APjAAAVwE1nmA9PX4XJv1mJPbKfiglD+lC0ujJvSy9DZZ8tGQawi5HZE
        ZsepoYQhUQoIaAXjcneESQ1rtriTl5GgdDUwih5xLQyh0shoKld5Hc1TUfi+QpusWyH+Ex6T9vz
        ocHEI3yVxHAkJ
X-Received: by 2002:a17:902:b20c:: with SMTP id t12mr909117plr.205.1567650995816;
        Wed, 04 Sep 2019 19:36:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMZVOsHXzxyLu6EGf3TYqiKj1CiNnjdkbFrGuz4gGin2zvKWpp7sfwErxeXzrROqPOoSY44Q==
X-Received: by 2002:a17:902:b20c:: with SMTP id t12mr909110plr.205.1567650995683;
        Wed, 04 Sep 2019 19:36:35 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm326504pjk.23.2019.09.04.19.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:36:35 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v3 2/4] KVM: X86: Remove tailing newline for tracepoints
Date:   Thu,  5 Sep 2019 10:36:14 +0800
Message-Id: <20190905023616.29082-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905023616.29082-1-peterx@redhat.com>
References: <20190905023616.29082-1-peterx@redhat.com>
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

