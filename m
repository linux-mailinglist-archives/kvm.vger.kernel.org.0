Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A612353EC12
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbiFFP0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 11:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbiFFPZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 11:25:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26B1CD36F;
        Mon,  6 Jun 2022 08:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D39EA61542;
        Mon,  6 Jun 2022 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009D1C36B06;
        Mon,  6 Jun 2022 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529149;
        bh=niKYlfjKmS5xHiDfjqL4v2PE2kbh/ZAGZOCN30CEhO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIoLbrUb1f3o051SNAQoTlP4mRw9FyUhl1jzZse3MzV51w7qmcXB/W6o/4JduflM+
         FRfdP5IhuNIlo3U7JAa0cl3DLpzLaIwKKonqnoZKJpIlU4T9owhpgKQqN3uYzCpI4k
         z6uhR1+LpCKPF43sPSe3xzeWIiPP5gc2B+1Av59m+UZHDxynZWUSoXFWtxVi3i2h4R
         Ve4CztRHUTC5PCw3dJ7ZBNg3f4Q1k5DN+O+yCm3uuJ59zxXPkGlg3enYaj2wK10o/8
         IyJZwkg52RPSEcY/eGbMtdA3AY24a05ReL7eCqrSCnuSUm5+NEB5JeSk1dbSNWvXxk
         bBXtin6M66PIg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nyEby-0012PL-8Q;
        Mon, 06 Jun 2022 16:25:46 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/23] Documentation: KVM: update amd-memory-encryption.rst references
Date:   Mon,  6 Jun 2022 16:25:33 +0100
Message-Id: <be9d6aaa6b745c703230739d418651e1227d2f7e.1654529011.git.mchehab@kernel.org>
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

Changeset daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
renamed: Documentation/virt/kvm/amd-memory-encryption.rst
to: Documentation/virt/kvm/x86/amd-memory-encryption.rst.

Update the cross-references accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/23] at: https://lore.kernel.org/all/cover.1654529011.git.mchehab@kernel.org/

 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/security/secrets/coco.rst         | 2 +-
 Documentation/virt/kvm/api.rst                  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8090130b544b..5ef0b2998af7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3104,7 +3104,7 @@
 			mem_encrypt=on:		Activate SME
 			mem_encrypt=off:	Do not activate SME
 
-			Refer to Documentation/virt/kvm/amd-memory-encryption.rst
+			Refer to Documentation/virt/kvm/x86/amd-memory-encryption.rst
 			for details on when memory encryption can be activated.
 
 	mem_sleep_default=	[SUSPEND] Default system suspend mode:
diff --git a/Documentation/security/secrets/coco.rst b/Documentation/security/secrets/coco.rst
index 262e7abb1b24..087e2d1ae38b 100644
--- a/Documentation/security/secrets/coco.rst
+++ b/Documentation/security/secrets/coco.rst
@@ -98,6 +98,6 @@ References
 
 See [sev-api-spec]_ for more info regarding SEV ``LAUNCH_SECRET`` operation.
 
-.. [sev] Documentation/virt/kvm/amd-memory-encryption.rst
+.. [sev] Documentation/virt/kvm/x86/amd-memory-encryption.rst
 .. [secrets-coco-abi] Documentation/ABI/testing/securityfs-secrets-coco
 .. [sev-api-spec] https://www.amd.com/system/files/TechDocs/55766_SEV-KM_API_Specification.pdf
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..b71e1d778e28 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4667,7 +4667,7 @@ encrypted VMs.
 
 Currently, this ioctl is used for issuing Secure Encrypted Virtualization
 (SEV) commands on AMD Processors. The SEV commands are defined in
-Documentation/virt/kvm/amd-memory-encryption.rst.
+Documentation/virt/kvm/x86/amd-memory-encryption.rst.
 
 4.111 KVM_MEMORY_ENCRYPT_REG_REGION
 -----------------------------------
-- 
2.36.1

