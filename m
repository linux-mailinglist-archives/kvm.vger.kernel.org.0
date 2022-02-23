Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773714C1363
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiBWM5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240685AbiBWM5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:57:44 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D2E8DEC3
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:57:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE825139F;
        Wed, 23 Feb 2022 04:57:15 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DA8E3F70D;
        Wed, 23 Feb 2022 04:57:14 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 1/3] configure: Fix whitespaces for the --gen-se-header help text
Date:   Wed, 23 Feb 2022 12:55:35 +0000
Message-Id: <20220223125537.41529-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223125537.41529-1-alexandru.elisei@arm.com>
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace some of the tabs with spaces to display the help text for the
--gen-se-header option like this:

    --gen-se-header=GEN_SE_HEADER
                           Provide an executable to generate a PV header
                           requires --host-key-document. (s390x-snippets only)

instead of:

    --gen-se-header=GEN_SE_HEADER
                           Provide an executable to generate a PV header
   requires --host-key-document. (s390x-snippets only)

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 2d9c3e051103..0ac9c85502ff 100755
--- a/configure
+++ b/configure
@@ -58,7 +58,7 @@ usage() {
 	                           a PVM image with 'genprotimg' (s390x only)
 	    --gen-se-header=GEN_SE_HEADER
 	                           Provide an executable to generate a PV header
-				   requires --host-key-document. (s390x-snippets only)
+	                           requires --host-key-document. (s390x-snippets only)
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
-- 
2.35.1

