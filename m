Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC92730897
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbjFNTmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjFNTle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F58268C
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686771609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7OxB9F73sxxKzQb7MnYhti66iYjEzvVt+NUA6vB8wM8=;
        b=J2bEoIv1DSSjbx5ewxoXlZYIW/L5S5TkPWAOuNOf6ZtRPFTXlXDB5klhZD8i3T3AcON8p7
        SB8kjTU6j/6BZosAFNprymqx2lzWUkXrMvf5VX9IDtNsvsQ0NjnrNa59DZ24orxuyV18GW
        GUz6M7Czyd+x5QkbBk0OisCghXR8j/o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-F9Q2WxucPbSrKaHDodPjoA-1; Wed, 14 Jun 2023 15:40:06 -0400
X-MC-Unique: F9Q2WxucPbSrKaHDodPjoA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FA751C08DB5;
        Wed, 14 Jun 2023 19:40:05 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21B99492C1B;
        Wed, 14 Jun 2023 19:40:05 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com, diana.craciun@oss.nxp.com
Subject: [PATCH v3 3/3] vfio/fsl: Create Kconfig sub-menu
Date:   Wed, 14 Jun 2023 13:39:48 -0600
Message-Id: <20230614193948.477036-4-alex.williamson@redhat.com>
In-Reply-To: <20230614193948.477036-1-alex.williamson@redhat.com>
References: <20230614193948.477036-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/fsl-mc/Kconfig | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 597d338c5c8a..7d1d690348f0 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,6 +1,8 @@
+menu "VFIO support for FSL_MC bus devices"
+	depends on FSL_MC_BUS
+
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
-	depends on FSL_MC_BUS
 	select EVENTFD
 	help
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
@@ -8,3 +10,5 @@ config VFIO_FSL_MC
 	  fsl-mc bus devices using the VFIO framework.
 
 	  If you don't know what to do here, say N.
+
+endmenu
-- 
2.39.2

