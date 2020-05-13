Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B211D1786
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbgEMOYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:24:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58585 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388790AbgEMOYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 10:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589379846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IOf09kqTTqRGDeH0c/dw1Ro4AhpeqWaMooBGpCchpFQ=;
        b=bLcetm6+BTQnkWcyJXogLoPNRwMbGmM5xYjG011gRCiYuondeEA3dn0Yt5Ttj812yz7wx0
        AU/R74dazF9wxfE6Th8itVqO8wUe6VL5rGqUSrzWQ30+a2KIY0Sm+wRt9wg6iulConL7Xi
        kLwxsGIMeVIal3QXpUQ4tvZUxSfN7lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-KNwAzmxAMb2sjRjXWFnuTw-1; Wed, 13 May 2020 10:24:04 -0400
X-MC-Unique: KNwAzmxAMb2sjRjXWFnuTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F58C18FE863
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 14:24:03 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6728038D;
        Wed, 13 May 2020 14:23:57 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     thuth@redhat.com, vkuznets@redhat.com,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-tests PATCH] x86/access: Fix phys-bits parameter
Date:   Wed, 13 May 2020 16:23:41 +0200
Message-Id: <20200513142341.774831-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some QEMU versions don't support setting phys-bits argument directly.
This causes breakage to Travis CI. Work around the bug by setting
host-phys-bits=on

Fixes: 1a296ac170f ("x86: access: Add tests for reserved bits of guest physical address")

Reported-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index bf0d02e..d43cac2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,phys-bits=36
+extra_params = -cpu host,host-phys-bits=on,phys-bits=36
 
 [smap]
 file = smap.flat
-- 
2.25.2

