Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49DB5992FE
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 04:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344583AbiHSCPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 22:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiHSCPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 22:15:42 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8780FD34E0;
        Thu, 18 Aug 2022 19:15:41 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 676EF1E80D08;
        Fri, 19 Aug 2022 10:12:30 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 82Ob8KXGdqpn; Fri, 19 Aug 2022 10:12:27 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id B35D31E80CFF;
        Fri, 19 Aug 2022 10:12:27 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     kunyu@nfschina.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v2] KVM: Drop unnecessary initialization of "ops" in kvm_ioctl_create_device() initialized and assigned, it is used after assignment
Date:   Fri, 19 Aug 2022 10:15:35 +0800
Message-Id: <20220819021535.483702-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20220819020648.483585-1-kunyu@nfschina.com>
References: <20220819020648.483585-1-kunyu@nfschina.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Used to reduce a movq instruction.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li kunyu <kunyu@nfschina.com>

v2:
  Change patch title.
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 80f7934c1f59..82f2b90718a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4378,7 +4378,7 @@ void kvm_unregister_device_ops(u32 type)
 static int kvm_ioctl_create_device(struct kvm *kvm,
 				   struct kvm_create_device *cd)
 {
-	const struct kvm_device_ops *ops = NULL;
+	const struct kvm_device_ops *ops;
 	struct kvm_device *dev;
 	bool test = cd->flags & KVM_CREATE_DEVICE_TEST;
 	int type;
-- 
2.18.2

