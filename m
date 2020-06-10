Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8991F53F3
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgFJLzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:55:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728787AbgFJLzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591790135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gfo8N/39HuNuGms67Iz3gfpzyYs5Q5599cbmKQTi7kc=;
        b=bc7656Kz+Cq7SRC7YwxTRETac5cfqCDtILdkWLAmx89/LHa+nkukOo4IoPlP7/dh7gpqcP
        ynPrM0hYlfqvTgZPwhHEgNFff+xmDReX0bWc0bZvf6/wk/jBnkli9CKe/dWeFtBFpvaqpS
        dZLZKLV+EDMaSS0m8lJ7T2FGYdWhYw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-PRFe2t6NMSCLqb1PnzQQoQ-1; Wed, 10 Jun 2020 07:55:33 -0400
X-MC-Unique: PRFe2t6NMSCLqb1PnzQQoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67AF0100A8EB;
        Wed, 10 Jun 2020 11:55:32 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-42.ams2.redhat.com [10.36.114.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D5E75D9D3;
        Wed, 10 Jun 2020 11:55:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v4 12/21] MAINTAINERS: Add myself as virtio-mem maintainer
Date:   Wed, 10 Jun 2020 13:54:10 +0200
Message-Id: <20200610115419.51688-13-david@redhat.com>
In-Reply-To: <20200610115419.51688-1-david@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make sure patches/bug reports find the right person.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Markus Armbruster <armbru@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3abe3faa4e..4889485e6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1762,6 +1762,14 @@ F: hw/virtio/virtio-crypto.c
 F: hw/virtio/virtio-crypto-pci.c
 F: include/hw/virtio/virtio-crypto.h
 
+virtio-mem
+M: David Hildenbrand <david@redhat.com>
+S: Supported
+F: hw/virtio/virtio-mem.c
+F: hw/virtio/virtio-mem-pci.h
+F: hw/virtio/virtio-mem-pci.c
+F: include/hw/virtio/virtio-mem.h
+
 nvme
 M: Keith Busch <kbusch@kernel.org>
 L: qemu-block@nongnu.org
-- 
2.26.2

