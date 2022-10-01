Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2035F1B08
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJAJNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Oct 2022 05:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJAJNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Oct 2022 05:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759F315C1F5
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 02:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5249603F2
        for <kvm@vger.kernel.org>; Sat,  1 Oct 2022 09:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FE3C433B5;
        Sat,  1 Oct 2022 09:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664615578;
        bh=aChnLthj05G6FMPEq6/4Ew+BfENWoq2cSOmNhnJSi5w=;
        h=From:To:Cc:Subject:Date:From;
        b=CTWcsLLyV4qJul3ZokGm1PEkjwBvQzZqWxpNeKU2KPU76XMO6Gv8XhgbRUtVEgp3t
         Q+cgFQMBIKE/t52ej7dxOzm4eByufWzXkYTqGNQeJ8KIfBgugd5FvxyKr366lOdv5v
         eKWouwK+CvizocuYW8A7zZZQO/L7BHnmkBrScm095LhS7BE11HdnGvF7bnjrtHIk11
         zI4WG4iiJwc9l67q2FHYsaCe89BX/stYbPMdmD+C6R/oEc3X2MzKaWzPryp0IGlgmY
         GHuyC1o1jgjgzOS579+v1CSvqKfvdmQdSJ5vAWTX3pd/OzWY7y7CAPBdnibJgj5rL6
         T0XaR8d95Zz9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oeYYJ-00DwWj-US;
        Sat, 01 Oct 2022 10:12:56 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Advertise new kvmarm mailing list
Date:   Sat,  1 Oct 2022 10:12:45 +0100
Message-Id: <20221001091245.3900668-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, catalin.marinas@arm.com, mark.rutland@arm.com, will@kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As announced on the kvmarm list, we're moving the mailing list over
to kvmarm@lists.linux.dev:

<quote>
As you probably all know, the kvmarm mailing has been hosted on
Columbia's machines for as long as the project existed (over 13
years). After all this time, the university has decided to retire the
list infrastructure and asked us to find a new hosting.

A new mailing list has been created on lists.linux.dev[1], and I'm
kindly asking everyone interested in following the KVM/arm64
developments to start subscribing to it (and start posting your
patches there). I hope that people will move over to it quickly enough
that we can soon give Columbia the green light to turn their systems
off.

Note that the new list will only get archived automatically once we
fully switch over, but I'll make sure we fill any gap and not lose any
message. In the meantime, please Cc both lists.

[...]

[1] https://subspace.kernel.org/lists.linux.dev.html
</quote>

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 589517372408..f29f27717de4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11124,7 +11124,8 @@ R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Oliver Upton <oliver.upton@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-L:	kvmarm@lists.cs.columbia.edu (moderated for non-subscribers)
+L:	kvmarm@lists.linux.dev
+L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 F:	arch/arm64/include/asm/kvm*
-- 
2.34.1

