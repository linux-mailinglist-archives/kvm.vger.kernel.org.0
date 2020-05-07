Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB61C8D4B
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 16:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgEGOCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 10:02:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31637 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgEGOCX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 10:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588860142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZbBw7pXrLEF6sMrGYbjSbEl9LiCTQZ70w4P7ewpeMA=;
        b=Pls1SqfZaBSO+HODDTIPG3YFWhGXeyiAS0qlXVakaSan+Cc7dP3G4s9nNmNVzCTkqQoWH6
        kPUsHIY+nJDctAQLySGmxw8P0KfOlF1Nz0uexHNvsBuUBe8g7JS7rabvKGSgfQVn9aj8mo
        aZD906JpyzDS07Bqujqe0re8JjRd814=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-FujlqWNdOwiAyUi_dGs_dg-1; Thu, 07 May 2020 10:02:15 -0400
X-MC-Unique: FujlqWNdOwiAyUi_dGs_dg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0FD9835B52;
        Thu,  7 May 2020 14:02:13 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0024661100;
        Thu,  7 May 2020 14:02:11 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 02/15] MAINTAINERS: Add myself as virtio-mem maintainer
Date:   Thu,  7 May 2020 16:01:26 +0200
Message-Id: <20200507140139.17083-3-david@redhat.com>
In-Reply-To: <20200507140139.17083-1-david@redhat.com>
References: <20200507140139.17083-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make sure patches/bug reports find the right person.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2926327e4976..014bbf5897c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17972,6 +17972,13 @@ S:	Maintained
 F:	drivers/iommu/virtio-iommu.c
 F:	include/uapi/linux/virtio_iommu.h
 
+VIRTIO MEM DRIVER
+M:	David Hildenbrand <david@redhat.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/virtio/virtio_mem.c
+F:	include/uapi/linux/virtio_mem.h
+
 VIRTUAL BOX GUEST DEVICE DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 M:	Arnd Bergmann <arnd@arndb.de>
-- 
2.25.3

