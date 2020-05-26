Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3D198653
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 23:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgC3VTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 17:19:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:52462 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgC3VTc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 17:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585603171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=W5E8AnJX6hToQex66ypkBMbfpIseZ8s9JQtsbtKX3pI=;
        b=TKvjsNIwVhKlEs8N6hO3TioSbyBeRtRRYbZsDCsTGe7W4vYCg2ZdfMxQtxTmKYehQXJ4VO
        CIsL184vdTNx125l6otA5KAph86QO5i2nR6mPciwazFER873BTqFFEGJfYmfWUuZw8hedo
        S/p66fIBh7x9uhtMQjFRn5RsDZyOLNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-XrhlEOX0O6uEhWN97qsNUg-1; Mon, 30 Mar 2020 17:19:27 -0400
X-MC-Unique: XrhlEOX0O6uEhWN97qsNUg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B572C18AB2CA;
        Mon, 30 Mar 2020 21:19:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B6D419C6A;
        Mon, 30 Mar 2020 21:19:24 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, frankja@linux.ibm.com
Subject: [PATCH] selftests: kvm: Update .gitignore with missing binaries
Date:   Mon, 30 Mar 2020 18:19:22 -0300
Message-Id: <20200330211922.24290-1-wainersm@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated .gitignore to ignore x86_64/svm_vmcall_test and
s390x/resets test binaries.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 30072c3f52fb..489b9cf9eed5 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,3 +1,4 @@
+/s390x/resets
 /s390x/sync_regs_test
 /s390x/memop
 /x86_64/cr4_cpuid_sync_test
@@ -8,6 +9,7 @@
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
+/x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
-- 
2.17.2

