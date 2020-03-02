Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E646175C4F
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 14:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgCBNxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 08:53:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727159AbgCBNxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 08:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583157213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HhbhIkhXjn/AwJ4ncntCvKScFqYIEEVt6rsSJbYgZY8=;
        b=LoH+F0LKziXsP9Ta1UFIZc8UABJvsQrXAXNIJaIGR0LobXc+4QUXzB+bftmamtQWjfLC73
        mAB3uzYC5Ks5rquL6XXKLP85PK/XDsSPmVmHh+hetOKWT/UUEWCkaFY2wXfw9uqg7mYAe6
        MuYnXYYASNLhnxvGByyxoXI7TwMwSe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-LijAYyNSPC-rwnsAlvjscA-1; Mon, 02 Mar 2020 08:53:29 -0500
X-MC-Unique: LijAYyNSPC-rwnsAlvjscA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCF1F1005512;
        Mon,  2 Mar 2020 13:53:27 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E179B19C4F;
        Mon,  2 Mar 2020 13:53:24 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 11/11] MAINTAINERS: Add myself as virtio-mem maintainer
Date:   Mon,  2 Mar 2020 14:49:41 +0100
Message-Id: <20200302134941.315212-12-david@redhat.com>
In-Reply-To: <20200302134941.315212-1-david@redhat.com>
References: <20200302134941.315212-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
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
index 1636ce4613e3..fc7371c4b7eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17855,6 +17855,13 @@ S:	Maintained
 F:	drivers/iommu/virtio-iommu.c
 F:	include/uapi/linux/virtio_iommu.h
=20
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
--=20
2.24.1

