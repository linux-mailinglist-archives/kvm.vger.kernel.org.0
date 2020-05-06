Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB901C6D98
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgEFJu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45164 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729255AbgEFJu5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wNnV1o2sGn2mnkPQHzSb908sWqnev3kAZicrjpV0Uu4=;
        b=WTk60kHGKVpyG7EaWFIZbvet5rcGXT+bMSGxc/19lCACQGsaGxr+KPCeiwcstJY7putYv5
        JyoP59ek7mxI9betM/bZUF1RivquVze//GveHUYH7DgCs/tQMpfgt8ykc+fi4pBxAaABdP
        1R7vpWb+99MRi1aHyFefHKhbRKSBMmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-k6OBLxMJN6aj_s6dkKEgGQ-1; Wed, 06 May 2020 05:50:55 -0400
X-MC-Unique: k6OBLxMJN6aj_s6dkKEgGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4280107ACCA;
        Wed,  6 May 2020 09:50:53 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 591515C1BD;
        Wed,  6 May 2020 09:50:46 +0000 (UTC)
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
Subject: [PATCH v1 12/17] MAINTAINERS: Add myself as virtio-mem maintainer
Date:   Wed,  6 May 2020 11:49:43 +0200
Message-Id: <20200506094948.76388-13-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make sure patches/bug reports find the right person.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Markus Armbruster <armbru@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1f84e3ae2c..09fff9e1bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1734,6 +1734,14 @@ F: hw/virtio/virtio-crypto.c
 F: hw/virtio/virtio-crypto-pci.c
 F: include/hw/virtio/virtio-crypto.h
=20
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
--=20
2.25.3

