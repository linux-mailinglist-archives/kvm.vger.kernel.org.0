Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C225323DE0A
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgHFRVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:21:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45879 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730293AbgHFRQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aL/EuDNAcbdbzH+y5QWYpfnkZltNgWzwMN6+1Nt56y4=;
        b=QEcI+cpPoC9Wied2KZUPVNHW7W5wyIufrqLrzxctluUlRKre9kFh7fuxqCA+hA6B61nnLn
        VNYyMYFNLod3ub4jQbReZ9CKjon5h/163kbwa7GM7zZXjBb4EqNt1fHca6DWX5MstQBKHP
        gAzpePGeIBbGja07tz7CoijyrkUKNsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-H9nv_85bOuKjUfqAG14j7Q-1; Thu, 06 Aug 2020 08:44:33 -0400
X-MC-Unique: H9nv_85bOuKjUfqAG14j7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6D72803022;
        Thu,  6 Aug 2020 12:44:24 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF3E65F9DC;
        Thu,  6 Aug 2020 12:44:19 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Mohammed Gamal <m.gamal005@gmail.com>
Subject: [kvm-unit-tests PATCH 3/3] Revert "access: disable phys-bits=36 for now"
Date:   Thu,  6 Aug 2020 14:43:58 +0200
Message-Id: <20200806124358.4928-4-mgamal@redhat.com>
In-Reply-To: <20200806124358.4928-1-mgamal@redhat.com>
References: <20200806124358.4928-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This reverts commit 71de9c93fbdb15978ffa2f290dd120d3005a9292.

Now that guest_maxphyaddr < host_maxphyaddr patches are sent.
Revert this change in kvm-unit-test

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 4fa42fa..3c0b992 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,host-phys-bits
+extra_params = -cpu host,phys-bits=36
 timeout = 180
 
 [smap]
-- 
2.26.2

