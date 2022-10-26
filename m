Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492D260DED8
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 12:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiJZK1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 06:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJZK1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 06:27:08 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63279E6AA
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 03:27:06 -0700 (PDT)
Received: from localhost.localdomain (1.general.phlin.uk.vpn [10.172.194.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7469343227;
        Wed, 26 Oct 2022 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1666780024;
        bh=tbMzLIGubglbCRFNgXYnHGrh6weuC+dFFK98XeUw7ug=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=kexl0qL84wrZVmGGdAfE2upssbNA0j6x/w8yXWnFSBmgxurDGznS3mSLQmbN3Z2zt
         JLi36DeOkHFYFajwtLAFn2VqYJxizAyZ6ARH9ylXifIxDUJGuiEOIeGKdgI9t595f/
         qjvJQC1QcrpsT/IsX9kXR1zxI77uuFoGWlbcmWhqb4XoebkixzdgC9Q6EANeu+DKP0
         C+hhLum42AccO4wssc7rQW+tI2EMTMFgbtHJg3+VtRJYrkDrrkdljvX0Tu8E5i6dep
         w3FcecyONjFF+FyzcGndKCp86VS04OWop4YmmIA1fWANEpquvc5tZljms7sqTByz2q
         3K2HNRuTF4jdg==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] x86: Increase timeout for vmx_vmcs_shadow_test to 10 mins
Date:   Wed, 26 Oct 2022 18:26:47 +0800
Message-Id: <20221026102647.712110-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test can take about 7 minutes to run on VM.DenseIO2.8 instance
from Oracle cloud with Ubuntu Oracle cloud kernel (CONFIG_DEBUG_VM
was not enabled):
  * Ubuntu Focal 5.4 Oracle kernel: 6m42s / 6m46s / 6m42s
  * Ubuntu Jammy 5.15 Oracle kernel: 6m26s / 6m27s / 6m26s

Bump the timeout for this test again to 10 minutes.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed65185..799cb18 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -373,7 +373,7 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
-timeout = 180
+timeout = 600
 
 [vmx_pf_exception_test]
 file = vmx.flat
-- 
2.25.1

