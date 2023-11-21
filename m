Return-Path: <kvm+bounces-2199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 039D77F3456
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1048282CB8
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02BBC54FBF;
	Tue, 21 Nov 2023 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaf68A8D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB3A113
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 08:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700585780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4LNk5kAGm6SyvUcndkJLMHvNQ5mYfLA7uUadJ5oG+bo=;
	b=aaf68A8DI1VhxbGnLRlh/17J5KpkIxJqYUB6tqMAq1T4LHb/U/gfwnhRAIFispa0FqYwz6
	v3utcfTNfMX/Y0tVdf4sjTwII8CJV7LFGxl5nx8mY9lwoHL4OWv0d0PWnszs0nyG5kn3mp
	k1mNn7U3j1KUaMJzvs+9UNfSE68VcBg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-ZGZPA5lNOVGmajCidMmYKA-1; Tue,
 21 Nov 2023 11:56:18 -0500
X-MC-Unique: ZGZPA5lNOVGmajCidMmYKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6E911C0BB45;
	Tue, 21 Nov 2023 16:56:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF7311121306;
	Tue, 21 Nov 2023 16:56:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] selftests/kvm: fix -Wformat warning
Date: Tue, 21 Nov 2023 11:56:17 -0500
Message-Id: <20231121165617.1170786-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

The __TEST_REQUIRE invocation includes a "%d" format specifier
but lacks the corresponding argument, so add it.

Fixes: 5f5651c67311 ("KVM: selftests: Require DISABLE_NX_HUGE_PAGES cap for NX hugepage test")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 18ac5c1952a3..3d4e59fa9d03 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -259,7 +259,7 @@ int main(int argc, char **argv)
 	__TEST_REQUIRE(token == MAGIC_TOKEN,
 		       "This test must be run with the magic token %d.\n"
 		       "This is done by nx_huge_pages_test.sh, which\n"
-		       "also handles environment setup for the test.");
+		       "also handles environment setup for the test.", token);
 
 	run_test(reclaim_period_ms, false, reboot_permissions);
 	run_test(reclaim_period_ms, true, reboot_permissions);
-- 
2.39.1


