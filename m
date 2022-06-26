Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF5A55B095
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 11:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiFZJLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 05:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiFZJLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 05:11:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C5B12AA6;
        Sun, 26 Jun 2022 02:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2096C6118C;
        Sun, 26 Jun 2022 09:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3FFC341CF;
        Sun, 26 Jun 2022 09:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656234671;
        bh=0VMbEb33dQlbgLBtppNYobb6lfqI/ghU3eQrEoLrjC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWjf1lPUfPb24TU7SlF7Xw5H9uH1ACzAiNBT7gtrGrPhW4OTKOiYY2RyKdSf6XGVn
         rNy0glkCrKLBecvgZhFUc0NBbb1CG55XPzbWO57W+X6Gwp/b/kJn254EJCZt1f2d7q
         yQL/W73smXoQOlIOfnM8pV0JO3Domqrn/xIyZzWYzwxC+lDCJFIJ0t6NMvrrNut8yV
         ybf1xy3GmRIzDcX8ZWFGoMj9fgmFkApxKedmL7di59t8CI64Mlxuw6pPKZUx+LJg7F
         1RBje5RM580JpWuEv2fh1hBMnaIZA9tn4QtC9GqCQoulCpbGEk/cr//wtNuC1DWRki
         tXqQA1fS1J9Qg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o5OIO-001col-27;
        Sun, 26 Jun 2022 10:11:08 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/20] Documentation: KVM: update s390-pv.rst reference
Date:   Sun, 26 Jun 2022 10:10:57 +0100
Message-Id: <e2676f087d287db0bc31ae7c05c80ce5adf93333.1656234456.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656234456.git.mchehab@kernel.org>
References: <cover.1656234456.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
See [PATCH v2 00/20] at: https://lore.kernel.org/all/cover.1656234456.git.mchehab@kernel.org/

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

