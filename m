Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95D553EAE2
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbiFFPZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 11:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240608AbiFFPZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 11:25:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD021CD36A;
        Mon,  6 Jun 2022 08:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA4F5B81A8F;
        Mon,  6 Jun 2022 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88EBC341C6;
        Mon,  6 Jun 2022 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529148;
        bh=dKol4sgwd+aRZfbYxUG7kC/mmhFopuLPynC+Zt89S7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8MCp4JwlbfSiWbjBb9YOKkjqALcKFsEqiZhw1T2ZdEB/J+WxHcROaoKSgxGzMdgv
         OXkF0n+QnyHSO5GpZ2+ILjk752Ho0GB7OlVqiOdjYT1d8GbHepbeOY683K/vlxAnbE
         IrXywtNhv5sLaZmCD1zmnP1/XW17nqzcOAF8jwzOmCIO8p8go7XYd5u7Op0duDC6rJ
         7prK0s9J/4B464n/XNT+WFEquyotVYMszxsG2CM9NauiD4jcPLA+gM222vcZ2GIUVa
         U5LTbyDdJglgF4ii7QRvy8Lr+fkdw3+/L+QoZmH+T0D94m0ROZ1D9GW5N3PxaxSfGj
         F5rEZL3LDijjQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nyEby-0012PS-9l;
        Mon, 06 Jun 2022 16:25:46 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/23] Documentation: KVM: update s390-diag.rst reference
Date:   Mon,  6 Jun 2022 16:25:35 +0100
Message-Id: <a43ac709fe3130c21dd54d0a43d0c0fc80f5ad2c.1654529011.git.mchehab@kernel.org>
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
renamed: Documentation/virt/kvm/s390-diag.rst
to: Documentation/virt/kvm/s390/s390-diag.rst.

Update its cross-reference accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/23] at: https://lore.kernel.org/all/cover.1654529011.git.mchehab@kernel.org/

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

