Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5559A5D5
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349970AbiHSTCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 15:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbiHSTCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 15:02:40 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C0A107DB8;
        Fri, 19 Aug 2022 12:02:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660935752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qeilJkUjgYD++ZOMtMBSkczOrjiQxtJLWwy7xJrcqHQ=;
        b=rmyb69jLBe9H6Q7EGCSdAkL+5/r8HNg5NEW/e98Kh028IlZIEQyM7HGnap+fhpigMzbZHH
        dNPOhhGxNEbO6jXFX/3bB7mHpsNcgyJYnsXQAGc3OvLJWHloYpJ3Dir+aU2UeBy08aQU4P
        wTN4uCNP4PyoNKE89tgBNnVYh0xmwxc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mailmap: Update Oliver's email address
Date:   Fri, 19 Aug 2022 19:01:58 +0000
Message-Id: <20220819190158.234290-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While I'm still at Google, I've since switched to a linux.dev account
for working upstream.

Add an alias to the new address.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 38255d412f0b..d1f7ed1019cf 100644
--- a/.mailmap
+++ b/.mailmap
@@ -330,6 +330,7 @@ Oleksij Rempel <linux@rempel-privat.de> <external.Oleksij.Rempel@de.bosch.com>
 Oleksij Rempel <linux@rempel-privat.de> <fixed-term.Oleksij.Rempel@de.bosch.com>
 Oleksij Rempel <linux@rempel-privat.de> <o.rempel@pengutronix.de>
 Oleksij Rempel <linux@rempel-privat.de> <ore@pengutronix.de>
+Oliver Upton <oliver.upton@linux.dev> <oupton@google.com>
 Pali Rohár <pali@kernel.org> <pali.rohar@gmail.com>
 Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
 Patrick Mochel <mochel@digitalimplant.org>

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.1.595.g718a3a8f04-goog

