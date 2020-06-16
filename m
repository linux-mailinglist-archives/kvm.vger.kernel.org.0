Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C11FBE9B
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgFPS4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34965 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730549AbgFPS4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=m8xQB6mQZC1dBMukO1QKy6l2+Gq6ZtFVdy6w67HPVeU=;
        b=ZgVbHv7xRuB96NEDMVZz8VY2VH6GlbBigglPsrhBt/bES9vC7yTasR8wp3pAPJYzhLZLWH
        uQVJQkLqdy+Q2ABVn43uzJaz1M9ZTAOBGVVcld8/gmaTO1qmfK9STLsRAZV9z+RoLBy6fp
        Nw3DDwsKLOhRd5DDKp/jj0rVyVfkBZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-DB-JvC8ANOemVURQ4x3gFw-1; Tue, 16 Jun 2020 14:56:44 -0400
X-MC-Unique: DB-JvC8ANOemVURQ4x3gFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 719C880F5D5;
        Tue, 16 Jun 2020 18:56:43 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 662A37CAA8;
        Tue, 16 Jun 2020 18:56:42 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 12/12] s390x: stsi: Make output tap13 compatible
Date:   Tue, 16 Jun 2020 20:56:22 +0200
Message-Id: <20200616185622.8644-13-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

In tap13 output # is a special character and only "skip" and "todo"
are allowed to come after it. Let's appease our CI environment and
replace # with "count".

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200525084340.1454-1-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/stsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 66b4257..b81cea7 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -129,11 +129,11 @@ static void test_3_2_2(void)
 	}
 
 	report(!memcmp(data->vm[0].uuid, uuid, sizeof(uuid)), "uuid");
-	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu # configured");
+	report(data->vm[0].conf_cpus == smp_query_num_cpus(), "cpu count configured");
 	report(data->vm[0].total_cpus ==
 	       data->vm[0].reserved_cpus + data->vm[0].conf_cpus,
-	       "cpu # total == conf + reserved");
-	report(data->vm[0].standby_cpus == 0, "cpu # standby");
+	       "cpu count total == conf + reserved");
+	report(data->vm[0].standby_cpus == 0, "cpu count standby");
 	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),
 	       "VM name == kvm-unit-test");
 
-- 
2.18.1

