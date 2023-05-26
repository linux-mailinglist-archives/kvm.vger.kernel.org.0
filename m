Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24A712FCE
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbjEZWR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjEZWR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:28 -0400
Received: from out-56.mta0.migadu.com (out-56.mta0.migadu.com [IPv6:2001:41d0:1004:224b::38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700AB83
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlI3q1WPiCFI6LWKYg3D5mzmyQa8cYBk2N4tMj4HLGQ=;
        b=ZLtr38GLB3QLggnvIcY//4Woaa0BgQsm8X4di/r9n6wgkKJgWZgrury1iWQ++6BYIJHHdZ
        exSk6vKdDf+ZHVY4vPbd03T957E8Qt8eGk8nHZSdA8O8059DqvGEJpchtINFL6+1juwSZH
        eU6vrctb+py1P2j+ZNxRvj9EqrPxhAQ=
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
Subject: [PATCH kvmtool 02/21] update_headers: Add missing entries to list of headers to copy
Date:   Fri, 26 May 2023 22:16:53 +0000
Message-ID: <20230526221712.317287-3-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
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
index 4c1be7e84a95..5720151972a1 100755
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
2.41.0.rc0.172.g3f132b7071-goog

