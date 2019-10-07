Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA4CE373
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJGN07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 09:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbfJGN06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 09:26:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE5C830842AF;
        Mon,  7 Oct 2019 13:26:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.34.244.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C512D60127;
        Mon,  7 Oct 2019 13:26:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] selftests: kvm: synchronize .gitignore to Makefile
Date:   Mon,  7 Oct 2019 15:26:56 +0200
Message-Id: <20191007132656.19544-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 07 Oct 2019 13:26:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because "Untracked files:" are annoying.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index b35da375530a..409c1fa75e03 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 /s390x/sync_regs_test
+/s390x/memop
 /x86_64/cr4_cpuid_sync_test
 /x86_64/evmcs_test
 /x86_64/hyperv_cpuid
@@ -9,6 +10,7 @@
 /x86_64/state_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
+/x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
 /clear_dirty_log_test
-- 
2.20.1

