Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD902AF088
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgKKM0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:26:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgKKM0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cY9Dc3o8oHhG/6CVI6xeevBtNQB290eszc83VzqGshk=;
        b=Niycp4vEEBi1VAfMYprGjEn4THOQ3H0gP8Lut482uL7RwGd6r1ZCks154KSAocRmdBFD6O
        0qMDTuiy4i76VNp5Q4DTaGrCQjgMSGv9HZhxlObpitLosUVAMkQn7knY+HKShHU74SXE3M
        835nEr3y/qQMbd48My/sLxHzkO2pgNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-lmXgXWwSMkagX9QfkxpqJg-1; Wed, 11 Nov 2020 07:26:45 -0500
X-MC-Unique: lmXgXWwSMkagX9QfkxpqJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EA2A186DD41;
        Wed, 11 Nov 2020 12:26:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 018F610013BD;
        Wed, 11 Nov 2020 12:26:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 01/11] KVM: selftests: Update .gitignore
Date:   Wed, 11 Nov 2020 13:26:26 +0100
Message-Id: <20201111122636.73346-2-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add x86_64/tsc_msrs_test and remove clear_dirty_log_test.

Reviewed-by: Ben Gardon <bgardon@google.com>
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

