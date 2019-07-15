Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E34E68CA2
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbfGONwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:52:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbfGONwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:52:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB6A430C0DD0;
        Mon, 15 Jul 2019 13:52:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53D2A5D772;
        Mon, 15 Jul 2019 13:52:42 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 13/21] kvm: Update comments for sync_dirty_bitmap
Date:   Mon, 15 Jul 2019 15:51:17 +0200
Message-Id: <20190715135125.17770-14-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 15 Jul 2019 13:52:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

It's obviously obsolete.  Do some update.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190603065056.25211-8-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 accel/kvm/kvm-all.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 3d86ae5052..a3df19da56 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -478,13 +478,13 @@ static int kvm_get_dirty_pages_log_range(MemoryRegionSection *section,
 #define ALIGN(x, y)  (((x)+(y)-1) & ~((y)-1))
 
 /**
- * kvm_physical_sync_dirty_bitmap - Grab dirty bitmap from kernel space
- * This function updates qemu's dirty bitmap using
- * memory_region_set_dirty().  This means all bits are set
- * to dirty.
+ * kvm_physical_sync_dirty_bitmap - Sync dirty bitmap from kernel space
  *
- * @start_add: start of logged region.
- * @end_addr: end of logged region.
+ * This function will first try to fetch dirty bitmap from the kernel,
+ * and then updates qemu's dirty bitmap.
+ *
+ * @kml: the KVM memory listener object
+ * @section: the memory section to sync the dirty bitmap with
  */
 static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
                                           MemoryRegionSection *section)
-- 
2.21.0

