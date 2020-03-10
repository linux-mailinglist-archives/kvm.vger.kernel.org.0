Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7183917F342
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 10:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCJJQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 05:16:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46615 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgCJJQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 05:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FzPIqR890Y9eu8VzNTrV4cbF4Y6Tc/k/pnAetrDWzf4=;
        b=fyrqurvJaZhuNXAy7bhFH46QlFjpuc6XhMBmMZH5KYsu9QxFJw2zV1T6VqiJI+KSagaAaQ
        iPseMrvYbbWBsXPam7HFU83jOHpWOVvYvxqttkLPib35W6Ph56pe80z4sM3z6Pu5DfZIaO
        23glkC1KpiJA+4IicB9kGbreeR0W4go=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-s0tz10t2PxWZP64Q0gyA6Q-1; Tue, 10 Mar 2020 05:16:08 -0400
X-MC-Unique: s0tz10t2PxWZP64Q0gyA6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25BB5477;
        Tue, 10 Mar 2020 09:16:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 492E760C05;
        Tue, 10 Mar 2020 09:16:05 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH 1/4] fixup! selftests: KVM: SVM: Add vmcall test
Date:   Tue, 10 Mar 2020 10:15:53 +0100
Message-Id: <20200310091556.4701-2-drjones@redhat.com>
In-Reply-To: <20200310091556.4701-1-drjones@redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Add svm_vmcall_test to gitignore list, and realphabetize it.]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selft=
ests/kvm/.gitignore
index 0abf0a8f00d5..8bc104d39e78 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,5 @@
-/s390x/sync_regs_test
 /s390x/memop
+/s390x/sync_regs_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
@@ -9,6 +9,7 @@
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
+/x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
@@ -16,6 +17,6 @@
 /x86_64/vmx_tsc_adjust_test
 /x86_64/xss_msr_test
 /clear_dirty_log_test
+/demand_paging_test
 /dirty_log_test
 /kvm_create_max_vcpus
-/demand_paging_test
--=20
2.21.1

