Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6861F1FFB98
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 21:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgFRTMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 15:12:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726879AbgFRTMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 15:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592507538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K3Y9Ku4t7g7FpHAGcPWhhFdBH9tIdcnitGnwvpTD3+Y=;
        b=f9v17/vY0WJUFJvsahcIZIz3EsEGqT9Th9+IKKuzlfGW/8/KyYw5ehblgWtX4H9kPPEUZB
        L4BMp22ttLabGgcfETvOYdGah3aUhs8lv8fq7bvlBCkaoK8f1D58rmtlaEeVLJU44MmmkT
        ujSm39nJulPRWqaXIqmjQvZk6sHN6z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-fL7y4JKLMpCryjmxrydDfw-1; Thu, 18 Jun 2020 15:12:17 -0400
X-MC-Unique: fL7y4JKLMpCryjmxrydDfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB07B464;
        Thu, 18 Jun 2020 19:12:15 +0000 (UTC)
Received: from gimli.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6996419C4F;
        Thu, 18 Jun 2020 19:12:12 +0000 (UTC)
Subject: [PATCH] vfio/type1: Fix migration info capability ID
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Liu Yi L <yi.l.liu@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 18 Jun 2020 13:12:12 -0600
Message-ID: <159250751478.22544.8607332732745502185.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ID 1 is already used by the IOVA range capability, use ID 2.

Reported-by: Liu Yi L <yi.l.liu@intel.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Fixes: ad721705d09c ("vfio iommu: Add migration capability to report supported features")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/uapi/linux/vfio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index eca6692667a3..920470502329 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1030,7 +1030,7 @@ struct vfio_iommu_type1_info_cap_iova_range {
  * size in bytes that can be used by user applications when getting the dirty
  * bitmap.
  */
-#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
+#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  2
 
 struct vfio_iommu_type1_info_cap_migration {
 	struct	vfio_info_cap_header header;

