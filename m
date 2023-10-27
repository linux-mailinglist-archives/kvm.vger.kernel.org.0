Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084507D8CA2
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 02:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjJ0Ayz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0Ayx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 20:54:53 -0400
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBDE1B5
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 17:54:51 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698368089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cq/zS3bClxm7imQuXSmhkVhZzdLZ0oD5E8hPeZyMmAs=;
        b=WwHQMZf851niOPkkGeadjQ36LlhhpBLcxa3AUeqdx3S9WuUaGtA/1k3YFW81S15jE70V1y
        ExRV6gIE7nlOecKA4zCT4baT0EId/aNk+lTlpXmnqWZCBZ4f3futEZm7SP+QUnyhhKLO/+
        Od3X89MvtD9O8TlETpooZFYmtaRpgIE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Aishwarya TCV <aishwarya.tcv@arm.com>
Subject: [PATCH 0/2] tools: Makefile fixes for sysreg generation
Date:   Fri, 27 Oct 2023 00:54:37 +0000
Message-ID: <20231027005439.3142015-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixing a couple of issues in the Makefile changes required to get sysreg
generation working.

Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>

Oliver Upton (2):
  tools: arm64: Fix references to top srcdir in Makefile
  KVM: selftests: Avoid using forced target for generating arm64 headers

 tools/arch/arm64/tools/Makefile      | 16 ++++++++--------
 tools/testing/selftests/kvm/Makefile | 11 +++++------
 2 files changed, 13 insertions(+), 14 deletions(-)


base-commit: 54a9ea73527d55ab746d5425e10f3fa748e00e70
-- 
2.42.0.820.g83a721a137-goog

