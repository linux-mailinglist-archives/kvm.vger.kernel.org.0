Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8E2452EBE
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhKPKPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:15:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233941AbhKPKOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637057481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H4RvIoRAtvsLubuSMgFD8o5tLMCcJ+TlvzT8p++BAnk=;
        b=TdJ3qT7UJru7Vc4WCDllw3+cbi7S3NwxbndyrxdfiQjAKB9uPqEwetaZCYIteHf/qLquIh
        fJgApVTrR54/XaIDtyIVqeK+714Ch+sZK6deA51PaZa5tfxjqwaBXmgVmxDyKYCzCDXF9W
        WEZvr7jfIoB0yQVlqOSNUbikaYVMI3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-O7CpqKlgMmWE0mCFdCH9tA-1; Tue, 16 Nov 2021 05:11:19 -0500
X-MC-Unique: O7CpqKlgMmWE0mCFdCH9tA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B5B41006AA8;
        Tue, 16 Nov 2021 10:11:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (unknown [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF3985D9DE;
        Tue, 16 Nov 2021 10:11:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MMU: update comment on the number of page role combinations
Date:   Tue, 16 Nov 2021 05:11:14 -0500
Message-Id: <20211116101114.665451-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e977634333d4..354fd2a918d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -291,9 +291,9 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 18 bits in the mask below, not all combinations
+ * But, even though there are 20 bits in the mask below, not all combinations
  * of modes and flags are possible.  The maximum number of possible upper-level
- * shadow pages for a single gfn is in the neighborhood of 2^13.
+ * shadow pages for a single gfn is in the neighborhood of 2^15.
  *
  *   - invalid shadow pages are not accounted.
  *   - level is effectively limited to four combinations, not 16 as the number
-- 
2.27.0

