Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36F8213825
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGCJxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:53:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24495 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgGCJxG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 05:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593769985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hai0dcPIMkcr5P0By/QJCXM4A0YP3MuE4H3RrpcA9h8=;
        b=E6tGMu8kbhfiaD3CGg19hxR+uH8tmq2SsoDhl3B4NaD2iZ4zCMmX/9hDjbVkb3H9zrK2va
        OfqhPLO5XvSO0geKJGWA60JOuOxSqnP6/Xvs9QgFcZCdvWhkMzXiO19dKg/MKoYS9voVO+
        ZJGCGCXmZwMlm38NmRNbhuliF/25Ca4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-8xVo53iVNJeXuDPjeleBZg-1; Fri, 03 Jul 2020 05:53:02 -0400
X-MC-Unique: 8xVo53iVNJeXuDPjeleBZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 955F2800407;
        Fri,  3 Jul 2020 09:53:00 +0000 (UTC)
Received: from localhost (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 388425D9CA;
        Fri,  3 Jul 2020 09:53:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/1] vfio-ccw: Fix a build error due to missing include of linux/slab.h
Date:   Fri,  3 Jul 2020 11:52:53 +0200
Message-Id: <20200703095253.620719-2-cohuck@redhat.com>
In-Reply-To: <20200703095253.620719-1-cohuck@redhat.com>
References: <20200703095253.620719-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Include linux/slab.h to fix a build error due to kfree() being undefined.

Fixes: 3f02cb2fd9d2 ("vfio-ccw: Wire up the CRW irq and CRW region")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200703022628.6036-1-sean.j.christopherson@intel.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_chp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
index a646fc81c872..13b26a1c7988 100644
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -8,6 +8,7 @@
  *            Eric Farman <farman@linux.ibm.com>
  */
 
+#include <linux/slab.h>
 #include <linux/vfio.h>
 #include "vfio_ccw_private.h"
 
-- 
2.25.4

