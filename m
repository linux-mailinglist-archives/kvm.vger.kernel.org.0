Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C85F2AE0F8
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKJUsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:48:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgKJUsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 15:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605041294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LWKFbnQZ4OkBqCtzuiWjVMY5oOducQlCQCmPMmoI0c=;
        b=G3UE6yolC/wzLX2VAmed8Iuo6CoaX3nTfpfUWsJjVply5xdH+qBruA/3F0QGsc8Z4YX7LD
        KG8ypp0IbgJpY+RyzpUKgK6iTfC53ePrQP3iZAAk5wu969xXJ34gkv+Je0XoAUQfELvNOJ
        OPlDFn8AMQSt5+GXSSBuej8yCr2TIxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-mz444-41N2KkWZ-O2y0kpw-1; Tue, 10 Nov 2020 15:48:13 -0500
X-MC-Unique: mz444-41N2KkWZ-O2y0kpw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3CA864156;
        Tue, 10 Nov 2020 20:48:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 105E51002C28;
        Tue, 10 Nov 2020 20:48:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 1/8] KVM: selftests: Update .gitignore
Date:   Tue, 10 Nov 2020 21:47:55 +0100
Message-Id: <20201110204802.417521-2-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-1-drjones@redhat.com>
References: <20201110204802.417521-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add x86_64/tsc_msrs_test and remove clear_dirty_log_test.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 7a2c242b7152..ceff9f4c1781 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -18,13 +18,13 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/tsc_msrs_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/xss_msr_test
-/clear_dirty_log_test
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
-- 
2.26.2

