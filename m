Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A5CFF0C
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfJHQid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfJHQid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 12:38:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0CEB80F7C;
        Tue,  8 Oct 2019 16:38:32 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FAFA5C1D4;
        Tue,  8 Oct 2019 16:38:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jack Wang <jack.wang.usish@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH kvm-unit-tests] x86: svm: run svm.flat unit tests with -cpu host
Date:   Tue,  8 Oct 2019 18:38:29 +0200
Message-Id: <20191008163829.1003-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 08 Oct 2019 16:38:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With -cpu qemu64 we skip many good tests (next_rip, npt_*) and
tsc_adjust is failing. VMX tests already use '-cpu host'.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 8156256146c3..e7aa1e9844f1 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -198,7 +198,7 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-extra_params = -cpu qemu64,+svm
+extra_params = -cpu host,+svm
 arch = x86_64
 
 [taskswitch]
-- 
2.20.1

