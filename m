Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6753E8C2
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbiFFPZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 11:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbiFFPZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 11:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A95A1CD358;
        Mon,  6 Jun 2022 08:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3316EB81A93;
        Mon,  6 Jun 2022 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BF4C341C4;
        Mon,  6 Jun 2022 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529148;
        bh=CiZ03MDxXuEFyM8xUVEpl2vv9u04XNMVLHJ+Cr2Kt8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRgr2Os+jWlXS7WKzBupN8Q9RY9aJaRWTK3HP26ruwjqePOc4iCwVpUi8cJQxOp9A
         x4pKx+qhfJPodmIgHArcbtV5jbjPXUr0VYfheKcbXfmJiTn4aFHaiHZ4pNxlJErfxj
         P7g83bSlKNaQ+ui40nMlq3Y2ihqie57ZtXpqdCt95suuy9pWzra3SmiXtxLrVy4uXX
         Cimn9VHNB4bsouVDhxrnsFzLNIUKKCfCcC0MeA85FR3ra00LbwV0va4oBdpKJwjYmM
         hllbQrSa5X9jTMKwCAOT9DhwTsZzyNw/omvx/mHvWSuQ/oEAJwJDxtc5R4XT5zgct/
         dz7iJmTy67EVQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nyEby-0012PI-7h;
        Mon, 06 Jun 2022 16:25:46 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/23] Documentation: KVM: update s390-pv.rst reference
Date:   Mon,  6 Jun 2022 16:25:32 +0100
Message-Id: <52042379597445f3cb983beec2ffd816f8a1fcdb.1654529011.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654529011.git.mchehab@kernel.org>
References: <cover.1654529011.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changesets: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
and: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
renamed: Documentation/virt/kvm/s390-pv.rst
to: Documentation/virt/kvm/s390/s390-pv.rst.

Update its cross-reference accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/23] at: https://lore.kernel.org/all/cover.1654529011.git.mchehab@kernel.org/

 Documentation/virt/kvm/s390/s390-pv-boot.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/s390/s390-pv-boot.rst b/Documentation/virt/kvm/s390/s390-pv-boot.rst
index 73a6083cb5e7..96c48480a360 100644
--- a/Documentation/virt/kvm/s390/s390-pv-boot.rst
+++ b/Documentation/virt/kvm/s390/s390-pv-boot.rst
@@ -10,7 +10,7 @@ The memory of Protected Virtual Machines (PVMs) is not accessible to
 I/O or the hypervisor. In those cases where the hypervisor needs to
 access the memory of a PVM, that memory must be made accessible.
 Memory made accessible to the hypervisor will be encrypted. See
-Documentation/virt/kvm/s390-pv.rst for details."
+Documentation/virt/kvm/s390/s390-pv.rst for details."
 
 On IPL (boot) a small plaintext bootloader is started, which provides
 information about the encrypted components and necessary metadata to
-- 
2.36.1

