Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135B4175C22
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCBNum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 08:50:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32850 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726935AbgCBNul (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 08:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583157040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+esorcsOTdydQ/iR1D9mTLbAkiYHJj6EfvHsmJOWIA=;
        b=L5+vmAIEHNkjZ+6aAWO+YyN5Lr2pj84qx1YI4VDwZj2sn/vWo3cuIME1vgT9Q0q+gg9DGq
        fjmoh3n8VeR+6mZiB0uTVBDk+E1xaBpQujAyfjT0qFUiIkDsrUiJcgBJKvixlwMk6PacxR
        A1pz4kco54iRM9aobCwxiaCjYW2N5u8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-AB3ShGiNO7Kd_SwpwvvNrA-1; Mon, 02 Mar 2020 08:50:38 -0500
X-MC-Unique: AB3ShGiNO7Kd_SwpwvvNrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E7E1005512;
        Mon,  2 Mar 2020 13:50:37 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D0C6385;
        Mon,  2 Mar 2020 13:50:26 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v1 01/11] ACPI: NUMA: export pxm_to_node
Date:   Mon,  2 Mar 2020 14:49:31 +0100
Message-Id: <20200302134941.315212-2-david@redhat.com>
In-Reply-To: <20200302134941.315212-1-david@redhat.com>
References: <20200302134941.315212-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Will be needed by virtio-mem to identify the node from a pxm.

Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/acpi/numa/srat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 47b4969d9b93..5be5a977da1b 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -35,6 +35,7 @@ int pxm_to_node(int pxm)
 		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
+EXPORT_SYMBOL(pxm_to_node);
=20
 int node_to_pxm(int node)
 {
--=20
2.24.1

