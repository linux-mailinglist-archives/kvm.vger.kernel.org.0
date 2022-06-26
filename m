Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3E55B0B2
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 11:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiFZJLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 05:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiFZJLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 05:11:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A3A12A9A;
        Sun, 26 Jun 2022 02:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD118B80D31;
        Sun, 26 Jun 2022 09:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF663C341CD;
        Sun, 26 Jun 2022 09:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656234670;
        bh=f69PKsy7zpSeuo5OvCRQUdjrN8yXOOBZLICV3ycTvQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNgHvK6pS7H8+t8Jwa5+ptYIImjXZ5V77JqfHSIXZvOBWlXXAMRzISJkZIwt0BpCy
         ZpLW/+MriyLs9TiwalFRFaC41oVsief4wrXv45diovd1UMbGvFf1y7exGimpSETWNA
         OvgDyzy11nm1je1sk7mdd5TQ6j4CX1eG/jueO/ozMk3iqWBMfJmtQgtK3VD/LSYkfI
         JGomN/UBsWgFm23FXFhKNVqXU89yGG5C5MVI4VPERHWhlL1JlPteLGMHvfLVO5+QWD
         8qKu1BA9pbLyitElAINxQ+ytyDgTfyr+AyT86ziIvyWTNGXPOCYT2sNO50+BWnjz27
         HUdpiKy86fARw==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o5OIO-001cor-2s;
        Sun, 26 Jun 2022 10:11:08 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
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
Subject: [PATCH v2 12/20] Documentation: KVM: update amd-memory-encryption.rst references
Date:   Sun, 26 Jun 2022 10:10:58 +0100
Message-Id: <fd80db889e34aae87a4ca88cad94f650723668f4.1656234456.git.mchehab@kernel.org>
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
renamed: Documentation/virt/kvm/amd-memory-encryption.rst
to: Documentation/virt/kvm/x86/amd-memory-encryption.rst.

Update the cross-references accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v2 00/20] at: https://lore.kernel.org/all/cover.1656234456.git.mchehab@kernel.org/

 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/security/secrets/coco.rst         | 2 +-
 Documentation/virt/kvm/api.rst                  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f50e1fc6e51b..fc8cdc073764 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3116,7 +3116,7 @@
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
index 84c486ce6279..9260152c37cb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4677,7 +4677,7 @@ encrypted VMs.
 
 Currently, this ioctl is used for issuing Secure Encrypted Virtualization
 (SEV) commands on AMD Processors. The SEV commands are defined in
-Documentation/virt/kvm/amd-memory-encryption.rst.
+Documentation/virt/kvm/x86/amd-memory-encryption.rst.
 
 4.111 KVM_MEMORY_ENCRYPT_REG_REGION
 -----------------------------------
-- 
2.36.1

