Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546497272BB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjFGXKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjFGXKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:10:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13A21BC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686179371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s3VYdj95tJSOgWvSMcq68LHjAkPlAy+Wy/vfb7xHyGI=;
        b=Rj0VVrBROjfzxHnIi8oZ5WIMP75cwsN0zRVg2B/DO3poN1rYyFdvdSaSFG0oPnk+vk0Lpw
        8Ns/75M8NNDiqY6RNoXEgQFXOVYrsPGokfNO7+aoOhN8433i3dLlG3ImB4XOShd/J4WLQv
        D9l9HB+05H7xJL8jNOkZu+8VojLOJk8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-anGtS_8DOtKIOilizNSR-Q-1; Wed, 07 Jun 2023 19:09:28 -0400
X-MC-Unique: anGtS_8DOtKIOilizNSR-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4437B811E78;
        Wed,  7 Jun 2023 23:09:28 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C95E340D1B66;
        Wed,  7 Jun 2023 23:09:27 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com, diana.craciun@oss.nxp.com
Subject: [PATCH v2 3/3] vfio/fsl: Create Kconfig sub-menu
Date:   Wed,  7 Jun 2023 17:09:18 -0600
Message-Id: <20230607230918.3157757-4-alex.williamson@redhat.com>
In-Reply-To: <20230607230918.3157757-1-alex.williamson@redhat.com>
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

