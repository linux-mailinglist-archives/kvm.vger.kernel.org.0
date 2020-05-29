Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F51E79D7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgE2Ju3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:50:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725306AbgE2Ju2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590745827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BwHdRwrK0wPZyetUSej9ICz5eyB+NKkH6EpaQuUXYKw=;
        b=Hw5+XGAs37wjDY5GX7JLQW7Hqv8Bx74RNHIZ6EpicC0k5wr9mZf9l/TFIX2lCDDwIOn64R
        c3Zi3LeFqH5+gAbUf5odd413wP04NEnun4r/1tirsfbhef8OPig457qtzs1j4GeLnilHRX
        zaObPgJtBxpqbtJmRCW/a5D+N7jMzh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-0E_qsUF9PEGZuZMqI_yy7Q-1; Fri, 29 May 2020 05:50:25 -0400
X-MC-Unique: 0E_qsUF9PEGZuZMqI_yy7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFB681005512
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 09:50:24 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 664BE7A8D1;
        Fri, 29 May 2020 09:50:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH kvm-unit-tests v2] access: disable phys-bits=36 for now
Date:   Fri, 29 May 2020 05:50:23 -0400
Message-Id: <20200529095023.222232-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support for guest-MAXPHYADDR < host-MAXPHYADDR is not upstream yet,
it should not be enabled.  Otherwise, all the pde.36 and pte.36
fail and the test takes so long that it times out.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index bf0d02e..504e04e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,phys-bits=36
+extra_params = -cpu host,host-phys-bits
 
 [smap]
 file = smap.flat
-- 
2.26.2

