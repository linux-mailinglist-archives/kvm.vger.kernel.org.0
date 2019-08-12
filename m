Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F82C89F5C
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 15:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfHLNOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 09:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfHLNOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 09:14:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5CCB1C004F52;
        Mon, 12 Aug 2019 13:14:08 +0000 (UTC)
Received: from virtlab605.virt.lab.eng.bos.redhat.com (virtlab605.virt.lab.eng.bos.redhat.com [10.19.152.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59F6E1000324;
        Mon, 12 Aug 2019 13:13:58 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com, cohuck@redhat.com
Subject: [QEMU Patch 1/2] virtio-balloon: adding bit for page reporting support
Date:   Mon, 12 Aug 2019 09:13:56 -0400
Message-Id: <20190812131357.27312-1-nitesh@redhat.com>
In-Reply-To: <20190812131235.27244-1-nitesh@redhat.com>
References: <20190812131235.27244-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 12 Aug 2019 13:14:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch will be replaced once the feature is merged into the
Linux kernel.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/standard-headers/linux/virtio_balloon.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
index 9375ca2a70..1c5f6d6f2d 100644
--- a/include/standard-headers/linux/virtio_balloon.h
+++ b/include/standard-headers/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
2.21.0

