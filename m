Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF747371BD
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjFTQeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjFTQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:34:18 -0400
Received: from out-25.mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015461992
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:34:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687278855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9YpD01o6UPhM5WsJPhZO7V/DerMefZkxr+zZT/DMt3w=;
        b=l269BUmws6WJNXZ2rJPbOyzNrMt4hsmaIkGKHGp3fexy5ujW9xom6pdPazB1SY3PmASoW7
        yypsD965CgcWE9X01JrAv66jnHwWhRS13ChJzuXrnfuCPAgD2jgMplGo2f9RsbHI3Gn7yP
        ZsfNlWfed4CqDbGX6LO7Om/RnT70eXI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 02/20] update_headers: Add missing entries to list of headers to copy
Date:   Tue, 20 Jun 2023 11:33:35 -0500
Message-ID: <20230620163353.2688567-3-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are a few headers in kvmtool that are not handled by the updater
script. Add them to the list of headers to update.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 util/update_headers.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 4c1be7e..5720151 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -10,6 +10,9 @@
 set -ue
 
 GENERIC_LIST="kvm.h \
+	      psci.h \
+	      vfio.h \
+	      vhost.h \
 	      virtio_9p.h \
 	      virtio_balloon.h \
 	      virtio_blk.h \
-- 
2.41.0.162.gfafddb0af9-goog

