Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029CD797A9C
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbjIGRrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbjIGRra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:47:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AC871BF3
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 10:47:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C5F2152B;
        Thu,  7 Sep 2023 10:17:36 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0ABB3F67D;
        Thu,  7 Sep 2023 10:16:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        andre.przywara@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com
Subject: [PATCH kvmtool 2/3] builtin-run: Document mode=none for -n/--network
Date:   Thu,  7 Sep 2023 18:16:54 +0100
Message-Id: <20230907171655.6996-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230907171655.6996-1-alexandru.elisei@arm.com>
References: <20230907171655.6996-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It can be useful to disable all network devices, for example, to remove the
compat warning for the default network device when the guest does not
initialize it. This can be done by passing mode=none to the --network
command line option, but without in-depth knowledge of the code, there is
no way for the user to know this. Update the help message for -n/--network
to explain what mode=none does.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/builtin-run.c b/builtin-run.c
index 21373d41edd6..c26184ea7fc0 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -252,7 +252,8 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 									\
 	OPT_GROUP("Networking options:"),				\
 	OPT_CALLBACK_DEFAULT('n', "network", NULL, "network params",	\
-		     "Create a new guest NIC",				\
+		     "Create a new guest NIC. Pass mode=none to disable"\
+		     " all network devices",				\
 		     netdev_parser, NULL, kvm),				\
 	OPT_BOOLEAN('\0', "no-dhcp", &(cfg)->no_dhcp, "Disable kernel"	\
 			" DHCP in rootfs mode"),			\
-- 
2.42.0

