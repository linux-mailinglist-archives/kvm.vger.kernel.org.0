Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB19B53E8F8
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiFFP0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 11:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240621AbiFFPZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 11:25:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEDE1CD362;
        Mon,  6 Jun 2022 08:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51B53B81A9C;
        Mon,  6 Jun 2022 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1CCC341D0;
        Mon,  6 Jun 2022 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529149;
        bh=4h5bZhigrNHgcgtmQ5vv6ZiB1e8LhSy/BsT+J3lN1RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEuzPzIU98z7IdedBcRKjl4FEqVZWIEzTAObFS0D1HaIJjaxXGelpM20H0sJzHiFj
         aAqm4iLySRkRxTBAREUhrmMo+VQN5U9pDVWE/t9m3apEEoZB+UueSwvd85lZFlG8ZX
         kXzaEOGPj2i6SA9bJodfOELedtkS+iPDtOEZCI8ael+zXMfWYdg8XewXxGdX10zWSd
         lHeAhWmrPMkPITIZZP93DJYd/BbMrSjyJrhdqbwYpLDGNk3+UTK+ssB0aA5cUN9jua
         C3jbLt2C5UaSWzaeEu18H5KSOwtvkZCmqQIifgbrCGzRNHuuwqaktngCAuniaRrxVL
         5TDs2hdrhfQzg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nyEby-0012PO-93;
        Mon, 06 Jun 2022 16:25:46 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/23] Documentation: KVM: update msr.rst reference
Date:   Mon,  6 Jun 2022 16:25:34 +0100
Message-Id: <d3951acdf915d64a62d32e8cdc0373e7782ee6c9.1654529011.git.mchehab@kernel.org>
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
renamed: Documentation/virt/kvm/msr.rst
to: Documentation/virt/kvm/x86/msr.rst.

Update its cross-reference accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 00/23] at: https://lore.kernel.org/all/cover.1654529011.git.mchehab@kernel.org/

 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b71e1d778e28..9cc6981f5a34 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7670,7 +7670,7 @@ architecture-specific interfaces.  This capability and the architecture-
 specific interfaces must be consistent, i.e. if one says the feature
 is supported, than the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
-For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
+For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
 
 8.25 KVM_CAP_S390_DIAG318
 -------------------------
-- 
2.36.1

