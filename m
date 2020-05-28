Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F344A1E6148
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbgE1Mrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 08:47:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60298 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389852AbgE1Mrr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 08:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590670065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=578lqEIwcFIGxMqIYDdaOt9NWnfXpZq3NaaADCB4Cx8=;
        b=fO8AzcPkqe/O7ZsHb7Dgc8YqatTRUvvHvwL/ZdkIZZSzLlEuNpP6M3jNycDu4kKrKySePI
        DuYJD3VAVtRaY0C9MtNE5pdLKFy32xIYMUszDP8J0SFbymxb3Tj9Do1cPE571bC6SopN//
        5XnSsTrQPbyDZgvc42+kNm6i8YkwneE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-A9L0eY6oOZiR7TfVl0C4uw-1; Thu, 28 May 2020 08:47:44 -0400
X-MC-Unique: A9L0eY6oOZiR7TfVl0C4uw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84E4D18FE864
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 12:47:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4A25D9EF;
        Thu, 28 May 2020 12:47:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH kvm-unit-tests] access: disable phys-bits=36 for now
Date:   Thu, 28 May 2020 08:47:42 -0400
Message-Id: <20200528124742.28953-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index bf0d02e..d658bc8 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,phys-bits=36
+extra_params = -cpu host
 
 [smap]
 file = smap.flat
-- 
2.26.2

