Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02556BE2A5
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391845AbfIYQig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391828AbfIYQif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:38:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7256B85540;
        Wed, 25 Sep 2019 16:38:35 +0000 (UTC)
Received: from thuth.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0148060BF1;
        Wed, 25 Sep 2019 16:38:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 17/17] s390x: Free allocated page in iep test
Date:   Wed, 25 Sep 2019 18:37:14 +0200
Message-Id: <20190925163714.27519-18-thuth@redhat.com>
In-Reply-To: <20190925163714.27519-1-thuth@redhat.com>
References: <20190925163714.27519-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 25 Sep 2019 16:38:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's also clean up

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20190925135623.9740-3-frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/iep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/s390x/iep.c b/s390x/iep.c
index 7da78a3..55c01ee 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -43,6 +43,7 @@ static void test_iep(void)
 	report_prefix_pop();
 	unprotect_page(iepbuf, PAGE_ENTRY_IEP);
 	ctl_clear_bit(0, 20);
+	free_page(iepbuf);
 }
 
 int main(void)
-- 
2.18.1

