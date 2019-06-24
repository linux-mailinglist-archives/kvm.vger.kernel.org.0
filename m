Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838B050524
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 11:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfFXJHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 05:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXJHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 05:07:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17D92307CDFC;
        Mon, 24 Jun 2019 09:07:25 +0000 (UTC)
Received: from localhost (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B60D360BF7;
        Mon, 24 Jun 2019 09:07:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio-ccw: make convert_ccw0_to_ccw1 static
Date:   Mon, 24 Jun 2019 11:07:21 +0200
Message-Id: <20190624090721.16241-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 24 Jun 2019 09:07:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reported by sparse.

Fixes: 7f8e89a8f2fd ("vfio-ccw: Factor out the ccw0-to-ccw1 transition")
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
On top of my vfio-ccw branch.

s390 arch maintainers: let me know if I should queue it and send
a pull request, or if you prefer to apply it directly.
---
 drivers/s390/cio/vfio_ccw_cp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9cddc1288059..a7b9dfd5b464 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -161,7 +161,7 @@ static inline void pfn_array_idal_create_words(
 	idaws[0] += pa->pa_iova & (PAGE_SIZE - 1);
 }
 
-void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
+static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
 {
 	struct ccw0 ccw0;
 	struct ccw1 *pccw1 = source;
-- 
2.20.1

