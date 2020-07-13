Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0A2184FE
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgGHKfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 06:35:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34259 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725972AbgGHKfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 06:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594204519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=trlJtT0rZ2sqGWqmQPOh1MYBjEiBnTH6WW16+k+sSw4=;
        b=GXTcItW0VozRAFdDk4dgxTySjGfI/w9CB41rZQJQ2+crcI0wqQofIeMpxQtzWGMETf2gL+
        T5IXFutak8MhVFsBBkin8S4x37th35ZLMTDPuibmMOXPrxsyVsQdUBNbhM7BZEvxYwlYgv
        0zcJMcBf4C3WT5KMEKs/yzL8pLmo5ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-k4MIU8deNVSS3Cz85xjFZg-1; Wed, 08 Jul 2020 06:35:16 -0400
X-MC-Unique: k4MIU8deNVSS3Cz85xjFZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7CC31080
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 10:35:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA24879248
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 10:35:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: fix clobbers for svm_vmrun
Date:   Wed,  8 Jul 2020 06:35:15 -0400
Message-Id: <20200708103515.19477-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

r15 is used by ASM_VMRUN_CMD, so we need to mark it as clobbered.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index e30630c..d8c8272 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -235,7 +235,7 @@ int svm_vmrun(void)
 		ASM_VMRUN_CMD
 		:
 		: "a" (virt_to_phys(vmcb))
-		: "memory");
+		: "memory", "r15");
 
 	return (vmcb->control.exit_code);
 }
-- 
2.26.2

