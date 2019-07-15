Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3303169792
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbfGONxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:53:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731795AbfGONxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4428485376;
        Mon, 15 Jul 2019 13:53:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D7B85D705;
        Mon, 15 Jul 2019 13:53:10 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PULL 19/21] migration/postcopy: fix document of postcopy_send_discard_bm_ram()
Date:   Mon, 15 Jul 2019 15:51:23 +0200
Message-Id: <20190715135125.17770-20-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 15 Jul 2019 13:53:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

Commit 6b6712efccd3 ('ram: Split dirty bitmap by RAMBlock') changes the
parameter of postcopy_send_discard_bm_ram(), while left the document
part untouched.

This patch correct the document and fix two typo by hand.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20190715020549.15018-1-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 8622b4dc49..85bc36101c 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2804,8 +2804,7 @@ void ram_postcopy_migrated_memory_release(MigrationState *ms)
  *
  * @ms: current migration state
  * @pds: state for postcopy
- * @start: RAMBlock starting page
- * @length: RAMBlock size
+ * @block: RAMBlock to discard
  */
 static int postcopy_send_discard_bm_ram(MigrationState *ms,
                                         PostcopyDiscardState *pds,
@@ -3004,7 +3003,7 @@ static void postcopy_chunk_hostpages_pass(MigrationState *ms, bool unsent_pass,
 }
 
 /**
- * postcopy_chuck_hostpages: discrad any partially sent host page
+ * postcopy_chunk_hostpages: discard any partially sent host page
  *
  * Utility for the outgoing postcopy code.
  *
-- 
2.21.0

