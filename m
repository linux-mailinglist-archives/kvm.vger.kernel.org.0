Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E7E181F11
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgCKRQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:16:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730362AbgCKRQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 13:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583947006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wdADVxXhJgEXL3ktYCtYRoI/HrQwnEtYWZwwV0awFRY=;
        b=MFnom/jq9KmR8kLmsBBD5kUw7K9FEb1GOyg0uF6MatDI4f7EonvMHwRhVcImBrKMYcjThg
        VcQqCMiysPBHgwOfRPeeF4yQxYvm81gOCrlyWnSlXBRb5bvdF7t2w+F3UYqCAmmVqBicYP
        YiCt+RNMo8FBNNHXmL0IB/wSS2UhMAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-TQMyPHx5MzGwUywT1SRRIQ-1; Wed, 11 Mar 2020 13:16:44 -0400
X-MC-Unique: TQMyPHx5MzGwUywT1SRRIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7271C800EBC;
        Wed, 11 Mar 2020 17:16:40 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9444860BEE;
        Wed, 11 Mar 2020 17:16:38 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 10/10] MAINTAINERS: Add myself as virtio-mem maintainer
Date:   Wed, 11 Mar 2020 18:14:22 +0100
Message-Id: <20200311171422.10484-11-david@redhat.com>
In-Reply-To: <20200311171422.10484-1-david@redhat.com>
References: <20200311171422.10484-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index f6dcd1233935..ee0e7cbca5c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17937,6 +17937,13 @@ S:	Maintained
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

