Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32B6144FD
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 08:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKAHZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 03:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAHZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 03:25:15 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35213F9D;
        Tue,  1 Nov 2022 00:25:12 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id VIA00106;
        Tue, 01 Nov 2022 15:25:06 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201603.home.langchao.com (10.100.2.3) with Microsoft SMTP Server id
 15.1.2507.12; Tue, 1 Nov 2022 15:25:07 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Tue, 1 Nov 2022 03:25:06 -0400
Message-ID: <20221101072506.7307-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20221101152506542b37a066d351f49ca7da895e039e5a
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warning:
  virt/kvm/kvm_main.c:3847:0-23: WARNING
    vcpu_get_pid_fops should be defined with DEFINE_DEBUGFS_ATTRIBUTE

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f1df24c2bc84..3f383f27d3d7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3844,7 +3844,7 @@ static int vcpu_get_pid(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
 
 static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-- 
2.27.0

