Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40E755B08D
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 11:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiFZJLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 05:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiFZJLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 05:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A2812A97;
        Sun, 26 Jun 2022 02:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C40A7B80D37;
        Sun, 26 Jun 2022 09:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157C8C341DC;
        Sun, 26 Jun 2022 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656234671;
        bh=h+1QeVS8ACjM0/I0V8004v6I8M6+vBcTeWm3TDyLTxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USWBC/8pgaZLj0WIbslgCAxhMNsMTht5DjStVoR5Vy6TrnGpSrJdx8lVh7FVqo8kz
         IWE9O918sfMAUnmp9BLWjkE7NPcYsKEUuWRrwCYEyPDkeeWRdu9xXqyDZdd76VDCnh
         z9cZP/Q0skaD5VUW1vAavX6cTmYmV7w41Lf+uKhW6BQEe96yonm29Wdzo8AORZFW4X
         hn3QPlUiqtC31Z8TZLy3sw5Mc1rRKr03OdVCtFrPB7c641mtqC6P7aosbGQk7W/xZv
         Eh3U3w7jLIVGt9k3HEHNU+Z6wIeb2evYCiNMPcO1GdknaZO8oLuVngnkjFWgKo3hgS
         tUMJ+kB6Mtd0g==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o5OIO-001coz-45;
        Sun, 26 Jun 2022 10:11:08 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/20] Documentation: KVM: update s390-diag.rst reference
Date:   Sun, 26 Jun 2022 10:11:00 +0100
Message-Id: <85b81e4678bbe23d0e9692616798762a6465f0a3.1656234456.git.mchehab@kernel.org>
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

Changeset daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
renamed: Documentation/virt/kvm/s390-diag.rst
to: Documentation/virt/kvm/s390/s390-diag.rst.

Update its cross-reference accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v2 00/20] at: https://lore.kernel.org/all/cover.1656234456.git.mchehab@kernel.org/

 Documentation/virt/kvm/x86/hypercalls.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index e56fa8b9cfca..10db7924720f 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -22,7 +22,7 @@ S390:
   number in R1.
 
   For further information on the S390 diagnose call as supported by KVM,
-  refer to Documentation/virt/kvm/s390-diag.rst.
+  refer to Documentation/virt/kvm/s390/s390-diag.rst.
 
 PowerPC:
   It uses R3-R10 and hypercall number in R11. R4-R11 are used as output registers.
-- 
2.36.1

