Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6015164D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgBDHNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726479AbgBDHNt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 02:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=6pE1yV5HBsGmICoUbkwNIntIfVP3d3daOMPPmOVPbEY=;
        b=XOiEoronLf0bK+zkE89PwmXZ9Pv03xsp0TS/wF0OKhlP87VyUlarhMGqzISmpUTGf0twAB
        1g5BODYTE9VNTiijZjoqhDJ+d48NtdHBkzDQJ7iB+aUTtIvCRpK3pghgkFeyfb6hjt+J1q
        Rs77F0JHy97UYSBXnOo0FYCHZwKuRKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-rKXpjoJOMK6yxPGTtKieWg-1; Tue, 04 Feb 2020 02:13:46 -0500
X-MC-Unique: rKXpjoJOMK6yxPGTtKieWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B40DDA0CBF;
        Tue,  4 Feb 2020 07:13:45 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9354C5C1D4;
        Tue,  4 Feb 2020 07:13:44 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com, Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 2/9] s390x: smp: Fix ecall and emcall report strings
Date:   Tue,  4 Feb 2020 08:13:28 +0100
Message-Id: <20200204071335.18180-3-thuth@redhat.com>
In-Reply-To: <20200204071335.18180-1-thuth@redhat.com>
References: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Instead of "smp: ecall: ecall" we now get "smp: ecall: received".

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200201152851.82867-3-frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index e37eb56..93a9594 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -125,7 +125,7 @@ static void ecall(void)
 	load_psw_mask(mask);
 	set_flag(1);
 	while (lc->ext_int_code != 0x1202) { mb(); }
-	report(1, "ecall");
+	report(1, "received");
 	set_flag(1);
 }
 
@@ -160,7 +160,7 @@ static void emcall(void)
 	load_psw_mask(mask);
 	set_flag(1);
 	while (lc->ext_int_code != 0x1201) { mb(); }
-	report(1, "ecall");
+	report(1, "received");
 	set_flag(1);
 }
 
-- 
2.18.1

