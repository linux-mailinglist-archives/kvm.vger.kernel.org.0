Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90656C8A7
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGIKHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 06:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGIKHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 06:07:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CBE4B480;
        Sat,  9 Jul 2022 03:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A854860E44;
        Sat,  9 Jul 2022 10:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E929C341D4;
        Sat,  9 Jul 2022 10:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657361258;
        bh=YDClF61V0ZMqEvrlsP1XceePMhCuNkAOjThdoE9BN1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmSIDCK8s73jCb7FH5sEul6ituFzVmpkN+sQZgGfkVBdtAXqGISB/ci8jbPpMAkG0
         gdttUGEDmQHxFGJP9qfUXD+ljAAYxBEpQDdvSppAGj5j3Inp9OyWDEYaZWmAzbQVzH
         iFMt5ohodSdReSjpIR6b7TTgYX2PjYkTwbOrDWIgH3zJtRbA/xh5wbg+Y39i0KmiD8
         1Ts3mZ6A+LPaIDzUnitHxgQM9VQcO5YFCyaSVber+ql1rj87aECPp6bo5S+B3S7nUX
         A+gV2cgJE2RBP2XZhLP4ph51yYYALrf3NcMt8mXR6k6Xrm72BvC4WsBgnPcqIAem7/
         S+zGqt6ljeMJA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oA7N9-004EHM-Nj;
        Sat, 09 Jul 2022 11:07:35 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/21] docs: virt: kvm: fix a title markup at api.rst
Date:   Sat,  9 Jul 2022 11:07:31 +0100
Message-Id: <aca9f984765785bf40226f97cf62acd874989b5c.1657360984.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657360984.git.mchehab@kernel.org>
References: <cover.1657360984.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
See [PATCH v3 00/21] at: https://lore.kernel.org/all/cover.1657360984.git.mchehab@kernel.org/

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

