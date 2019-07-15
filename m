Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1A68CB1
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbfGONxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730545AbfGONxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA8AD3082141;
        Mon, 15 Jul 2019 13:53:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9326D5D772;
        Mon, 15 Jul 2019 13:53:17 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 20/21] migration/postcopy: remove redundant cpu_synchronize_all_post_init
Date:   Mon, 15 Jul 2019 15:51:24 +0200
Message-Id: <20190715135125.17770-21-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 15 Jul 2019 13:53:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

cpu_synchronize_all_post_init() is called twice in
loadvm_postcopy_handle_run_bh(), so remove one redundant call.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190715080751.24304-1-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/savevm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/migration/savevm.c b/migration/savevm.c
index c0e557b4c2..79ed44d475 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -1863,7 +1863,6 @@ static void loadvm_postcopy_handle_run_bh(void *opaque)
     }
 
     trace_loadvm_postcopy_handle_run_cpu_sync();
-    cpu_synchronize_all_post_init();
 
     trace_loadvm_postcopy_handle_run_vmstart();
 
-- 
2.21.0

