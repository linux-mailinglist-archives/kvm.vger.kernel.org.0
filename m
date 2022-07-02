Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0065563F90
	for <lists+kvm@lfdr.de>; Sat,  2 Jul 2022 13:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiGBLHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Jul 2022 07:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiGBLHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Jul 2022 07:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A26D15A32;
        Sat,  2 Jul 2022 04:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B307660D2C;
        Sat,  2 Jul 2022 11:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB65C36AE5;
        Sat,  2 Jul 2022 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656760068;
        bh=guzLfxOW9n9g54JKHBMAj7jgY4Mtb11Kn6WVHjC6AeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kjg4UJh60AndGom536PZyEYAu7d2CDmU00I/HAIcBHiqGog/7ehfoxiDELg11QCG+
         mJA0rtNKK2ydxySJgJrHwdIhjYtxt2/31Q32ofqslAsb6KadwGahrw8eRDu7cj9Lat
         dkI8VFZdfpGoLzbGYj8HXh/aXE6ksTOAuJY7Gmbb9mzIids2Us0aiB45e83saA6Ujx
         CfCT3xUCu6buco7ZeVXQsje5UQHqqC/ZjQ8LGYQox4NjexmdHU5RA7CrcZFwZNNt5S
         wSj9pADojtGhvW+TcEntB7wR4H4YT++AhvR8xU+XUgJ1cGoeeXl0xRHvsGGZlBfAFh
         oN9zt9Og+P1Ow==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o7ayX-007gs6-NK;
        Sat, 02 Jul 2022 12:07:45 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] docs: virt: kvm: fix a title markup at api.rst
Date:   Sat,  2 Jul 2022 12:07:38 +0100
Message-Id: <bfce24c8c58db2aa07ee32559dd1c053335458e8.1656759989.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656759988.git.mchehab@kernel.org>
References: <cover.1656759988.git.mchehab@kernel.org>
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

As warned by Sphinx:

	Documentation/virt/kvm/api.rst:8210: WARNING: Title underline too short.

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/12] at: https://lore.kernel.org/all/cover.1656759988.git.mchehab@kernel.org/

 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a0f68d23999..3466f7124833 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8207,15 +8207,15 @@ dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
----------------------------
+-------------------------------------
 
 :Capability KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
 :Architectures: x86
 :Type: vm
 :Parameters: arg[0] must be 0.
 :Returns 0 on success, -EPERM if the userspace process does not
-	 have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
-	 created.
+have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
+created.
 
 This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
 
-- 
2.36.1

