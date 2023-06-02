Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF38720AFF
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbjFBVef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbjFBVee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C061B9
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685741630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+M2AovfkhlbydsCpTeuPgxc/FZaOyBraUlRDQc4ANTw=;
        b=MTY0/FxExKcNqhGP4UVHq1iVx/w6mx/HD8g1lPDtqjghYcC+JshUaIBe6TWWzUvRmkaDTP
        BMxCJ1CzUodvgEjbMOYpT7zCvzRvTqYeQGOyl/L+Qcsgqti95YTlAmD83zBe7EHvFRB+cA
        A/fUrxdKUADAAw8Bhzqo6D4JY9F8A34=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-7lYiTG97Oyq3UB1_RdDKcQ-1; Fri, 02 Jun 2023 17:33:47 -0400
X-MC-Unique: 7lYiTG97Oyq3UB1_RdDKcQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5CB1185A78E;
        Fri,  2 Jun 2023 21:33:46 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A6F7400F16;
        Fri,  2 Jun 2023 21:33:46 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, diana.craciun@oss.nxp.com
Subject: [PATCH 3/3] vfio/fsl: Create Kconfig sub-menu
Date:   Fri,  2 Jun 2023 15:33:15 -0600
Message-Id: <20230602213315.2521442-4-alex.williamson@redhat.com>
In-Reply-To: <20230602213315.2521442-1-alex.williamson@redhat.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For consistency with pci and platform, push the vfio-fsl-mc option into a
sub-menu.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/fsl-mc/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 597d338c5c8a..d2757a1114aa 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,3 +1,5 @@
+menu "VFIO support for FSL_MC bus devices"
+
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
 	depends on FSL_MC_BUS
@@ -8,3 +10,5 @@ config VFIO_FSL_MC
 	  fsl-mc bus devices using the VFIO framework.
 
 	  If you don't know what to do here, say N.
+
+endmenu
-- 
2.39.2

