Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4CC1BCA3F
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgD1SsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 14:48:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730303AbgD1SlG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 14:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588099265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2JvJAM5p12RcumIJnmGpEzfcPG1ShzjNWymeqXsNBPQ=;
        b=QaeipvLqHfELP3LhF6d1X+GJiGkD8l89y2zd6KQh4W1KC/Z25xtVvlDN9EDBA96UcpHn2m
        5CLbGoU+r8WtT04A6jN25CSzzWaWh3qDJTNl9nAHQ0Ecs7DsaPtnA97KoSuCDBtJQqVvzZ
        7POmfgEYt2oUIL4K98yc0p8xu+poHAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-hojDiYcrPpK329HM2OBAGw-1; Tue, 28 Apr 2020 14:41:01 -0400
X-MC-Unique: hojDiYcrPpK329HM2OBAGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0110B107ACCA;
        Tue, 28 Apr 2020 18:41:01 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DC085C1BD;
        Tue, 28 Apr 2020 18:41:00 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] svm: Fix nmi hlt test to fail test correctly
Date:   Tue, 28 Apr 2020 14:41:00 -0400
Message-Id: <20200428184100.5426-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last test does not return vmmcall on fail resulting
in passing the entire test.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2b84e4d..65008ba 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1480,6 +1480,7 @@ static void nmi_hlt_test(struct svm_test *test)
     if (!nmi_fired) {
         report(nmi_fired, "intercepted pending NMI not dispatched");
         set_test_stage(test, -1);
+        vmmcall();
     }
=20
     set_test_stage(test, 3);
--=20
2.20.1

